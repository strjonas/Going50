import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/core/utils/device_utils.dart';
import 'package:going50/core_models/obd_II_data.dart';
import 'package:going50/obd_lib/obd_service.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/obd_lib/models/obd_data.dart';
import 'package:going50/obd_lib/protocol/obd_constants.dart';
import 'package:going50/services/permission_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:logging/logging.dart';

/// A service that manages the connection to the OBD device and provides
/// an interface for retrieving vehicle data.
/// Falls back to sensor data if OBD connection is lost.
class ObdConnectionService extends ChangeNotifier {
  final Logger _logger = Logger('ObdConnectionService');
  final ObdService _obdService;
  late final PermissionService _permissionService;
  
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
  
  // Public getters
  bool get isInitialized => _isInitialized;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _obdService.isConnected;
  bool get isEngineRunning => _obdService.isEngineRunning;
  String? get currentDeviceId => _currentDeviceId;
  String? get errorMessage => _errorMessage;
  
  /// Stream of discovered Bluetooth devices
  Stream<List<BluetoothDevice>> get deviceStream => _deviceStreamController.stream;
  
  /// Stream of OBD data
  Stream<OBDIIData> get dataStream => _dataStreamController.stream;
  
  /// Constructor
  ObdConnectionService(this._obdService) {
    _logger.info('ObdConnectionService initialized');
    _permissionService = serviceLocator<PermissionService>();
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
      final hasBluetoothPermissions = await _permissionService.areBluetoothPermissionsGranted();
      final hasLocationPermissions = await _permissionService.areLocationPermissionsGranted();
      
      if (!hasBluetoothPermissions || !hasLocationPermissions) {
        _logger.info('Requesting Bluetooth and location permissions');
        
        // Request Bluetooth permissions
        if (!hasBluetoothPermissions) {
          await _permissionService.requestBluetoothPermissions();
          
          // Check again if permissions were granted
          final bluetoothGranted = await _permissionService.areBluetoothPermissionsGranted();
          if (!bluetoothGranted) {
            _setErrorMessage('Bluetooth permissions required for OBD connection');
            return false;
          }
        }
        
        // Request location permissions
        if (!hasLocationPermissions) {
          await _permissionService.requestLocationPermissions(background: false);
          
          // Check again if permissions were granted
          final locationGranted = await _permissionService.areLocationPermissionsGranted();
          if (!locationGranted) {
            _setErrorMessage('Location permission required for OBD connection');
            return false;
          }
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
    
    // Call the OBD service's method to stop scanning
    try {
      _obdService.stopScan();
    } catch (e) {
      _logger.warning('Error stopping scan: $e');
    }
    
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
  
  /// Start continuous queries to get OBD data
  Future<bool> startContinuousQueries() async {
    if (!_obdService.isConnected) {
      _logger.warning('Cannot start continuous queries: No OBD device connected');
      return false;
    }
    
    try {
      await _obdService.startContinuousQueries();
      _logger.info('Continuous queries started successfully');
      return true;
    } catch (e) {
      _setErrorMessage('Failed to start continuous queries: $e');
      _logger.severe('Error starting continuous queries', e);
      return false;
    }
  }
  
  /// Stop continuous queries
  Future<bool> stopQueries() async {
    if (!_obdService.isConnected) return true;
    
    try {
      await _obdService.stopQueries();
      _logger.info('Queries stopped successfully');
      return true;
    } catch (e) {
      _setErrorMessage('Failed to stop queries: $e');
      _logger.severe('Error stopping queries', e);
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
    
    // Enhance logging for debugging
    _logger.info('Converting OBD data: PID=${obdData.pid}, value=${obdData.value}, rawData=${obdData.rawData}');
    
    // Extract values based on PID type with enhanced error handling and fallbacks
    if (obdData.pid == ObdConstants.pidVehicleSpeed) {
      // Try the normal parsing first
      try {
        speed = double.tryParse(obdData.value.toString());
        
        // Check if we got a valid speed value
        if (speed == null) {
          _logger.warning('Failed to parse speed value: ${obdData.value}');
          
          // If raw data is available, try direct byte extraction
          if (obdData.rawData != null && obdData.rawData!.isNotEmpty) {
            // Use the first byte directly as speed value (standard OBD-II protocol)
            speed = obdData.rawData!.first * 4.0; // Apply 4x multiplier to address scaling issue
            _logger.info('Using raw byte for speed calculation: ${obdData.rawData!.first} * 4 = $speed km/h');
          }
        } else {
          // Apply scaling correction to parsed value too
          speed = speed * 4.0; // Apply 4x multiplier
          _logger.info('Applied 4x scaling to parsed speed: $speed km/h');
        }
      } catch (e) {
        _logger.severe('Error processing speed data: $e');
      }
    } else if (obdData.pid == ObdConstants.pidEngineRpm) {
      // Try normal parsing first
      try {
        rpm = int.tryParse(obdData.value.toString());
        
        // Check if we got a valid RPM value
        if (rpm == null) {
          _logger.warning('Failed to parse RPM value: ${obdData.value}');
          
          // If raw data is available, try direct byte extraction
          if (obdData.rawData != null && obdData.rawData!.length >= 2) {
            // Standard OBD-II formula: ((A * 256) + B) / 4
            final a = obdData.rawData![0];
            final b = obdData.rawData![1];
            rpm = (((a * 256) + b) / 4).round();
            _logger.info('Using raw bytes for RPM calculation: ((${a} * 256) + ${b}) / 4 = $rpm RPM');
          } else if (obdData.rawData != null && obdData.rawData!.length == 1) {
            // Some adapters send single-byte RPM, try a different formula
            rpm = (obdData.rawData!.first * 40).round(); // Alternative calculation for single byte
            _logger.info('Using single raw byte for RPM: ${obdData.rawData!.first} * 40 = $rpm RPM');
          }
        }
        
        // Some adapters report very high RPM values that need to be adjusted
        if (rpm != null && rpm > 16000) {
          _logger.warning('Unreasonably high RPM: $rpm, dividing by 4');
          rpm = (rpm / 4).round(); // Division by 4 works for some adapters
        }
      } catch (e) {
        _logger.severe('Error processing RPM data: $e');
      }
    } else if (obdData.pid == ObdConstants.pidThrottlePosition) {
      throttlePosition = double.tryParse(obdData.value.toString());
    } else if (obdData.pid == ObdConstants.pidCoolantTemp) {
      engineTemp = double.tryParse(obdData.value.toString());
    } else if (obdData.pid == ObdConstants.pidEngineLoad) {
      engineLoad = double.tryParse(obdData.value.toString());
    }
    
    // Emergency fallback for missing RPM
    if (rpm == null && obdData.pid == ObdConstants.pidEngineRpm && obdData.rawData != null) {
      _logger.warning('Emergency RPM parsing from raw bytes: ${obdData.rawData}');
      
      // Try several approaches to extract a sensible RPM value
      if (obdData.rawData!.length >= 2) {
        final rawData = obdData.rawData!;
        
        // Try multiple calculation methods and use the most reasonable
        final options = [
          (((rawData[0] * 256) + rawData[1]) / 4).round(),  // Standard
          (rawData[0] * 40).round(),                        // Alternative A
          (rawData[1] * 40).round(),                        // Alternative B
          ((rawData[0] * 256) + rawData[1]).round(),        // No division
          (((rawData[0] * 256) + rawData[1]) / 16).round(), // Division by 16
        ];
        
        // Find the first value in a reasonable range (500-8000 RPM)
        for (final option in options) {
          if (option >= 500 && option <= 8000) {
            rpm = option;
            _logger.info('Emergency RPM calculation selected value: $rpm');
            break;
          }
        }
        
        // If no reasonable value found, use the first option
        if (rpm == null) {
          rpm = options[0];
          _logger.warning('No reasonable RPM found, using first calculation: $rpm');
        }
      }
    }
    
    // Log the final converted values
    _logger.info('Final conversion results: speed=$speed km/h, rpm=$rpm');
    
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
  
  /// Override the dispose method to clean up resources
  @override
  void dispose() {
    _logger.info('Disposing OBD connection service');
    
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