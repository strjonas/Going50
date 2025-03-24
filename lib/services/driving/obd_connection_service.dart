import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/core/utils/permission_utils.dart';
import 'package:going50/core/utils/device_utils.dart';
import 'package:going50/core_models/obd_II_data.dart';
import 'package:going50/obd_lib/obd_service.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/obd_lib/models/obd_data.dart';
import 'package:going50/obd_lib/protocol/obd_constants.dart';
import 'package:logging/logging.dart';
import 'package:going50/services/driving/sensor_service.dart';

/// A service that manages the connection to the OBD device and provides
/// an interface for retrieving vehicle data.
/// Falls back to sensor data if OBD connection is lost.
class ObdConnectionService extends ChangeNotifier {
  final Logger _logger = Logger('ObdConnectionService');
  final ObdService _obdService;
  final SensorService? sensorService;
  
  // Connection state
  bool _isInitialized = false;
  bool _isScanning = false;
  bool _isConnecting = false;
  String? _currentDeviceId;
  String? _errorMessage;
  
  // Store the latest OBD data
  final Map<String, OBDIIData> _latestObdData = {};
  
  // Create stream controllers for observables
  final StreamController<List<BluetoothDevice>> _deviceStreamController = 
      StreamController<List<BluetoothDevice>>.broadcast();
  final StreamController<OBDIIData> _dataStreamController = 
      StreamController<OBDIIData>.broadcast();
  
  // Stale data handling
  DateTime? _lastDataTimestamp;
  static const _dataStaleThresholdMs = 5000; // 5 seconds
  Timer? _staleDataTimer;
  
  // Fallback mode
  bool _fallbackModeActive = false;
  
  // Public getters
  bool get isInitialized => _isInitialized;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _obdService.isConnected;
  bool get isEngineRunning => _obdService.isEngineRunning;
  bool get fallbackModeActive => _fallbackModeActive;
  String? get currentDeviceId => _currentDeviceId;
  String? get errorMessage => _errorMessage;
  
  /// Stream of discovered Bluetooth devices
  Stream<List<BluetoothDevice>> get deviceStream => _deviceStreamController.stream;
  
  /// Stream of OBD data
  Stream<OBDIIData> get dataStream => _dataStreamController.stream;
  
  /// Constructor
  ObdConnectionService(this._obdService, {this.sensorService}) {
    _logger.info('ObdConnectionService initialized');
  }
  
  /// Initialize the OBD connection service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    _logger.info('Initializing OBD connection service');
    
    try {
      // Check if device supports Bluetooth
      final hasBluetoothSupport = await DeviceUtils.hasBluetoothSupport();
      if (!hasBluetoothSupport) {
        _setErrorMessage('Device does not support Bluetooth');
        return false;
      }
      
      // Check for required permissions
      final hasPermissions = await PermissionUtils.checkDrivingPermissions();
      if (!hasPermissions) {
        _logger.info('Requesting driving permissions');
        final permissionsGranted = await PermissionUtils.requestDrivingPermissions();
        if (!permissionsGranted) {
          _setErrorMessage('Required permissions not granted');
          return false;
        }
      }
      
      // Check if Bluetooth is enabled
      final isBluetoothEnabled = await DeviceUtils.isBluetoothEnabled();
      if (!isBluetoothEnabled) {
        _setErrorMessage('Bluetooth is not enabled');
        return false;
      }
      
      _isInitialized = true;
      _clearErrorMessage();
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage('Failed to initialize: $e');
      _logger.severe('Initialization error: $e');
      return false;
    }
  }
  
  /// Start scanning for OBD devices
  Future<bool> startScan() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }
    
    if (_isScanning) return true;
    
    _logger.info('Starting scan for OBD devices');
    
    try {
      _isScanning = true;
      _clearErrorMessage();
      notifyListeners();
      
      // Clear any previous scan results
      List<BluetoothDevice> discoveredDevices = [];
      
      // Start device scan
      _obdService.scanForDevices().listen(
        (device) {
          _logger.fine('Found device: ${device.name} (${device.id})');
          
          // Add device to list if not already present
          if (!discoveredDevices.any((d) => d.id == device.id)) {
            discoveredDevices.add(device);
            _deviceStreamController.add(List.from(discoveredDevices));
          }
        },
        onError: (e) {
          _setErrorMessage('Error scanning: $e');
          _isScanning = false;
          notifyListeners();
        },
        onDone: () {
          _isScanning = false;
          notifyListeners();
        }
      );
      
      return true;
    } catch (e) {
      _setErrorMessage('Failed to start scan: $e');
      _logger.severe('Scan error: $e');
      _isScanning = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Stop scanning for OBD devices
  void stopScan() {
    if (!_isScanning) return;
    
    _logger.info('Stopping device scan');
    _isScanning = false;
    notifyListeners();
  }
  
  /// Connect to an OBD device
  Future<bool> connectToDevice(String deviceId) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }
    
    if (_isConnecting) return false;
    if (_obdService.isConnected && deviceId == _currentDeviceId) return true;
    
    _logger.info('Connecting to OBD device: $deviceId');
    
    try {
      _isConnecting = true;
      _clearErrorMessage();
      notifyListeners();
      
      // Disconnect from current device if connected
      if (_obdService.isConnected) {
        _obdService.disconnect();
      }
      
      // Connect to the new device
      final connected = await _obdService.connect(deviceId);
      
      if (connected) {
        _logger.info('Successfully connected to device: $deviceId');
        _currentDeviceId = deviceId;
        
        // Start continuous queries
        await _obdService.startContinuousQueries();
        
        // Start a timer to check for stale data
        _setupStaleDataTimer();
        
        // Listen for changes in the OBD service
        _obdService.addListener(_onObdServiceChanged);
      } else {
        _setErrorMessage('Failed to connect to device');
        _logger.warning('Failed to connect to device: $deviceId');
      }
      
      _isConnecting = false;
      notifyListeners();
      return connected;
    } catch (e) {
      _setErrorMessage('Connection error: $e');
      _logger.severe('Error connecting to device: $e');
      _isConnecting = false;
      _currentDeviceId = null;
      notifyListeners();
      return false;
    }
  }
  
  /// Disconnect from the current OBD device
  Future<bool> disconnect() async {
    if (!_obdService.isConnected) return true;
    
    _logger.info('Disconnecting from OBD device');
    
    try {
      // Stop the stale data timer
      _cancelStaleDataTimer();
      
      // Remove the OBD service listener
      _obdService.removeListener(_onObdServiceChanged);
      
      // Stop continuous queries
      await _obdService.stopQueries();
      
      // Disconnect from the device
      _obdService.disconnect();
      
      _currentDeviceId = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage('Disconnect error: $e');
      _logger.severe('Error disconnecting: $e');
      return false;
    }
  }
  
  /// Get the latest OBD data
  OBDIIData? getLatestOBDData() {
    if (!_obdService.isConnected || _latestObdData.isEmpty) {
      return null;
    }
    
    // Get the most recent data point
    final sortedKeys = _latestObdData.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    
    return _latestObdData[sortedKeys.first];
  }
  
  /// Get a list of available adapter profiles
  List<Map<String, String>> getAvailableProfiles() {
    return _obdService.getAvailableProfiles();
  }
  
  /// Set a specific adapter profile to be used
  void setAdapterProfile(String profileId) {
    _obdService.setAdapterProfile(profileId);
  }
  
  /// Clear manual profile selection and enable automatic profile detection
  void enableAutomaticProfileDetection() {
    _obdService.enableAutomaticProfileDetection();
  }
  
  /// Request a specific PID from the OBD adapter
  Future<OBDIIData?> requestPid(String pid) async {
    if (!_obdService.isConnected) {
      return null;
    }
    
    try {
      final data = await _obdService.requestPid(pid);
      if (data != null) {
        final obdIIData = _convertToObdIIData(data);
        return obdIIData;
      }
      return null;
    } catch (e) {
      _logger.warning('Error requesting PID $pid: $e');
      return null;
    }
  }
  
  /// Convert ObdData to OBDIIData
  OBDIIData _convertToObdIIData(ObdData obdData) {
    // Create OBDIIData object with the data from the OBD adapter
    final timestamp = DateTime.now();
    
    // Map specific PIDs to their corresponding fields in OBDIIData
    double? speed;
    int? rpm;
    double? throttlePosition;
    double? engineTemp;
    double? engineLoad;
    double? mafRate;
    
    // Extract values based on PID type
    if (obdData.pid == ObdConstants.pidVehicleSpeed) {
      speed = double.tryParse(obdData.value.toString());
    } else if (obdData.pid == ObdConstants.pidEngineRpm) {
      rpm = int.tryParse(obdData.value.toString());
    } else if (obdData.pid == ObdConstants.pidThrottlePosition) {
      throttlePosition = double.tryParse(obdData.value.toString());
    } else if (obdData.pid == ObdConstants.pidCoolantTemp) {
      engineTemp = double.tryParse(obdData.value.toString());
    } else if (obdData.pid == ObdConstants.pidEngineLoad) {
      engineLoad = double.tryParse(obdData.value.toString());
    }
    // MAF rate is not included in ObdConstants, so we'll skip it for now
    
    // Create the OBDIIData object
    final obdIIData = OBDIIData(
      timestamp: timestamp,
      vehicleSpeed: speed,
      rpm: rpm,
      throttlePosition: throttlePosition,
      engineRunning: rpm != null && rpm > 0,
      engineTemp: engineTemp,
      engineLoad: engineLoad,
      mafRate: mafRate,
    );
    
    // Store this as the latest data
    _latestObdData[timestamp.toIso8601String()] = obdIIData;
    
    // Update last data timestamp
    _lastDataTimestamp = timestamp;
    
    // Send to the data stream
    _dataStreamController.add(obdIIData);
    
    return obdIIData;
  }
  
  /// Callback for changes in the OBD service
  void _onObdServiceChanged() {
    // Send notification about the OBD service state change
    notifyListeners();
    
    // Get the latest data from the OBD service
    if (_obdService.isConnected) {
      final latestData = _obdService.latestData;
      
      if (latestData.isNotEmpty) {
        // Process each PID data
        for (final entry in latestData.entries) {
          final obdData = entry.value;
          // Call the convert method without using its return value
          _convertToObdIIData(obdData);
        }
      }
    }
  }
  
  /// Set up a timer to check for stale data
  void _setupStaleDataTimer() {
    // Cancel any existing timer
    _cancelStaleDataTimer();
    
    // Create a new timer
    _staleDataTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lastDataTimestamp != null) {
        final now = DateTime.now();
        final diff = now.difference(_lastDataTimestamp!).inMilliseconds;
        
        if (diff > _dataStaleThresholdMs) {
          _logger.warning('Data is stale (${diff}ms since last update)');
          
          // Optionally, try to recover the connection
          // This could be implemented with a reconnection strategy
        }
      }
    });
  }
  
  /// Cancel the stale data timer
  void _cancelStaleDataTimer() {
    _staleDataTimer?.cancel();
    _staleDataTimer = null;
  }
  
  /// Set an error message
  void _setErrorMessage(String message) {
    _errorMessage = message;
    _logger.warning(message);
  }
  
  /// Clear the error message
  void _clearErrorMessage() {
    _errorMessage = null;
  }
  
  /// Switch to sensor-only fallback mode
  Future<bool> switchToFallbackMode() async {
    if (sensorService == null) {
      _setErrorMessage('Sensor service not available for fallback mode');
      return false;
    }
    
    _logger.info('Switching to sensor-only fallback mode');
    
    try {
      // Disconnect from OBD if connected
      if (isConnected) {
        await disconnect();
      }
      
      // Initialize and start sensor service
      final sensorInitialized = await sensorService!.initialize();
      if (!sensorInitialized) {
        _setErrorMessage('Failed to initialize sensor fallback');
        return false;
      }
      
      final sensorStarted = await sensorService!.startCollection();
      if (!sensorStarted) {
        _setErrorMessage('Failed to start sensor fallback collection');
        return false;
      }
      
      _fallbackModeActive = true;
      _clearErrorMessage();
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage('Error switching to fallback mode: $e');
      _logger.severe('Fallback mode error: $e');
      return false;
    }
  }
  
  /// Check connection status and switch to fallback if needed
  Future<bool> ensureDataCollection() async {
    // If already in fallback mode or connected, we're good
    if (_fallbackModeActive || isConnected) {
      return true;
    }
    
    // Try to initialize and connect to OBD
    final initialized = await initialize();
    if (!initialized) {
      _logger.info('OBD initialization failed, trying fallback mode');
      return switchToFallbackMode();
    }
    
    // Start scanning for devices
    await startScan();
    
    // Wait a bit for devices to be discovered
    await Future.delayed(const Duration(seconds: 3));
    
    // If no devices found or connection fails, switch to fallback
    if (_deviceStreamController.hasListener) {
      final devices = await _deviceStreamController.stream.first;
      if (devices.isEmpty) {
        _logger.info('No OBD devices found, switching to fallback mode');
        return switchToFallbackMode();
      }
      
      // Try to connect to the first device
      final connected = await connectToDevice(devices.first.id);
      if (!connected) {
        _logger.info('OBD connection failed, switching to fallback mode');
        return switchToFallbackMode();
      }
      
      return true;
    }
    
    // If we couldn't even scan properly, switch to fallback
    _logger.info('OBD scanning failed, switching to fallback mode');
    return switchToFallbackMode();
  }
  
  /// Exit fallback mode and try to reconnect to OBD
  Future<bool> exitFallbackMode() async {
    if (!_fallbackModeActive) {
      return true;
    }
    
    _logger.info('Exiting fallback mode');
    
    try {
      // Stop sensor collection
      if (sensorService != null && sensorService!.isCollecting) {
        sensorService!.stopCollection();
      }
      
      _fallbackModeActive = false;
      notifyListeners();
      
      // Try to initialize OBD again
      return await initialize();
    } catch (e) {
      _logger.warning('Error exiting fallback mode: $e');
      return false;
    }
  }
  
  /// Get combined data from available sources (OBD or sensors)
  Future<OBDIIData?> getCombinedData() async {
    // If in fallback mode, get data from sensors
    if (_fallbackModeActive && sensorService != null) {
      final sensorData = await sensorService!.getLatestSensorData();
      if (sensorData != null) {
        // Convert sensor data to a simplified OBDIIData format
        return OBDIIData(
          timestamp: sensorData.timestamp,
          vehicleSpeed: sensorData.gpsSpeed, // Using GPS speed as vehicle speed
          rpm: 0, // Not available from sensors
          engineLoad: 0.0, // Not available from sensors
          engineTemp: 0.0, // Not available from sensors
          throttlePosition: 0.0, // Not available from sensors
          // Add additional fields as needed
        );
      }
      return null;
    }
    
    // If connected to OBD, get data from there
    if (isConnected) {
      return getLatestOBDData();
    }
    
    return null;
  }
  
  /// Override the dispose method to clean up resources
  @override
  void dispose() {
    _logger.info('Disposing OBD connection service');
    
    // Stop fallback mode if active
    if (_fallbackModeActive && sensorService != null && sensorService!.isCollecting) {
      sensorService!.stopCollection();
    }
    
    // Disconnect if connected
    if (isConnected) {
      disconnect();
    }
    
    // Close stream controllers
    _deviceStreamController.close();
    _dataStreamController.close();
    
    // Cancel stale data timer
    _staleDataTimer?.cancel();
    
    super.dispose();
  }
} 