import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/core/utils/permission_utils.dart';
import 'package:going50/core/utils/device_utils.dart';
import 'package:going50/core_models/phone_sensor_data.dart';
import 'package:going50/sensor_lib/sensor_service.dart' as sensor_lib;
import 'package:logging/logging.dart';

/// A service that manages phone sensors for collecting driving data when
/// an OBD device is not available or as supplementary data.
class SensorService extends ChangeNotifier {
  final Logger _logger = Logger('SensorService');
  final sensor_lib.SensorService _sensorService;
  
  // Service state
  bool _isInitialized = false;
  bool _isCollecting = false;
  String? _errorMessage;
  
  // Store the latest sensor data
  PhoneSensorData? _latestSensorData;
  
  // Stream controller for sensor data
  final StreamController<PhoneSensorData> _dataStreamController = 
      StreamController<PhoneSensorData>.broadcast();
  
  // Public getters
  bool get isInitialized => _isInitialized;
  bool get isCollecting => _isCollecting;
  String? get errorMessage => _errorMessage;
  PhoneSensorData? get latestSensorData => _latestSensorData;
  
  /// Stream of sensor data
  Stream<PhoneSensorData> get dataStream => _dataStreamController.stream;
  
  /// Constructor
  SensorService(this._sensorService) {
    _logger.info('SensorService initialized');
    
    // Subscribe to the sensor library's data stream
    _sensorService.dataStream.listen(_handleSensorData);
  }
  
  /// Initialize the sensor service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    _logger.info('Initializing sensor service');
    
    try {
      // Check for required permissions
      final hasPermissions = await PermissionUtils.checkSensorPermissions();
      if (!hasPermissions) {
        _logger.info('Requesting sensor permissions');
        final permissionsGranted = await PermissionUtils.requestSensorPermissions();
        if (!permissionsGranted) {
          _setErrorMessage('Required permissions not granted');
          return false;
        }
      }
      
      // Check device capabilities
      final hasSensorCapabilities = await DeviceUtils.hasSensorCapabilities();
      if (!hasSensorCapabilities) {
        _setErrorMessage('Device does not have required sensors');
        return false;
      }
      
      // Initialize the underlying sensor service
      await _sensorService.initialize();
      
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
  
  /// Start collecting sensor data
  Future<bool> startCollection({int collectionIntervalMs = 100}) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }
    
    if (_isCollecting) return true;
    
    _logger.info('Starting sensor data collection');
    
    try {
      // Start collection in the sensor service
      await _sensorService.startCollection(collectionIntervalMs: collectionIntervalMs);
      
      _isCollecting = true;
      _clearErrorMessage();
      notifyListeners();
      return true;
    } catch (e) {
      _setErrorMessage('Failed to start collection: $e');
      _logger.severe('Collection start error: $e');
      return false;
    }
  }
  
  /// Stop collecting sensor data
  void stopCollection() {
    if (!_isCollecting) return;
    
    _logger.info('Stopping sensor data collection');
    
    _sensorService.stopCollection();
    
    _isCollecting = false;
    notifyListeners();
  }
  
  /// Get the latest sensor data point
  Future<PhoneSensorData?> getLatestSensorData() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return null;
    }
    
    try {
      final data = await _sensorService.getLatestSensorData();
      _latestSensorData = data;
      return data;
    } catch (e) {
      _logger.warning('Error getting latest sensor data: $e');
      return _latestSensorData;
    }
  }
  
  /// Handle new sensor data from the underlying service
  void _handleSensorData(PhoneSensorData data) {
    _latestSensorData = data;
    _dataStreamController.add(data);
  }
  
  /// Set error message
  void _setErrorMessage(String message) {
    _errorMessage = message;
    _logger.warning(message);
    notifyListeners();
  }
  
  /// Clear error message
  void _clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _logger.info('Disposing sensor service');
    
    // Stop collection if running
    if (_isCollecting) {
      stopCollection();
    }
    
    // Close stream controller
    _dataStreamController.close();
    
    super.dispose();
  }
} 