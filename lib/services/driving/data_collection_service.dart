import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/behavior_classifier_lib/managers/eco_driving_manager.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/core_models/obd_II_data.dart';
import 'package:going50/core_models/phone_sensor_data.dart';
import 'package:going50/services/driving/obd_connection_service.dart';
import 'package:going50/services/driving/sensor_service.dart';
import 'package:logging/logging.dart';

/// A service that coordinates collection of driving data from OBD and sensors.
/// 
/// This service is responsible for:
/// - Combining data from multiple sources (OBD and phone sensors)
/// - Implementing data buffering for continuous operation
/// - Processing data in real-time
/// - Calculating derived metrics
class DataCollectionService extends ChangeNotifier {
  final Logger _logger = Logger('DataCollectionService');
  
  // Dependencies
  final ObdConnectionService _obdConnectionService;
  final SensorService _sensorService;
  final EcoDrivingManager _ecoDrivingManager;
  
  // Service state
  bool _isInitialized = false;
  bool _isCollecting = false;
  String? _errorMessage;
  
  // Buffering system
  final List<CombinedDrivingData> _dataBuffer = [];
  final int _maxBufferSize = 300; // ~5 minutes at 1Hz
  
  // Stream controllers
  final StreamController<CombinedDrivingData> _dataStreamController = 
      StreamController<CombinedDrivingData>.broadcast();
  
  // Background collection
  Timer? _processingTimer;
  Timer? _backgroundCollectionTimer;
  static const _backgroundCollectionIntervalMs = 1000; // 1 second
  
  // Public getters
  bool get isInitialized => _isInitialized;
  bool get isCollecting => _isCollecting;
  String? get errorMessage => _errorMessage;
  List<CombinedDrivingData> get dataBuffer => List.unmodifiable(_dataBuffer);
  
  /// Stream of combined driving data
  Stream<CombinedDrivingData> get dataStream => _dataStreamController.stream;
  
  /// Constructor
  DataCollectionService(
    this._obdConnectionService,
    this._sensorService,
    this._ecoDrivingManager,
  ) {
    _logger.info('DataCollectionService initialized');
    
    // Set up OBD data stream subscription
    _obdConnectionService.dataStream.listen((data) {
      _processObdData(data);
    });
    
    // Set up sensor data stream subscription
    _sensorService.dataStream.listen((data) {
      _processSensorData(data);
    });
  }
  
  /// Initialize the data collection service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    _logger.info('Initializing data collection service');
    
    try {
      // Initialize sensor service
      final sensorInitialized = await _sensorService.initialize();
      if (!sensorInitialized) {
        _setErrorMessage('Failed to initialize sensor service');
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
  
  /// Start collecting driving data
  Future<bool> startCollection() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }
    
    if (_isCollecting) return true;
    
    _logger.info('Starting data collection');
    
    try {
      // Start sensor collection
      final sensorStarted = await _sensorService.startCollection();
      if (!sensorStarted) {
        _setErrorMessage('Failed to start sensor collection');
        return false;
      }
      
      // Set up data processing timer
      _processingTimer = Timer.periodic(
        const Duration(milliseconds: 100), 
        (_) => _processBufferedData()
      );
      
      // Set up background collection timer
      _backgroundCollectionTimer = Timer.periodic(
        const Duration(milliseconds: _backgroundCollectionIntervalMs),
        (_) => _collectDataPoint()
      );
      
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
  
  /// Stop collecting driving data
  void stopCollection() {
    if (!_isCollecting) return;
    
    _logger.info('Stopping data collection');
    
    // Stop sensor collection
    _sensorService.stopCollection();
    
    // Cancel timers
    _processingTimer?.cancel();
    _processingTimer = null;
    
    _backgroundCollectionTimer?.cancel();
    _backgroundCollectionTimer = null;
    
    _isCollecting = false;
    notifyListeners();
  }
  
  /// Clear the data buffer
  void clearDataBuffer() {
    _dataBuffer.clear();
    notifyListeners();
  }
  
  /// Process OBD data received from the ObdConnectionService
  void _processObdData(OBDIIData obdData) {
    // We'll create a combined data point when we receive sensor data
    // This handles the case where OBD data might come at different frequency
    
    // If we're not actively collecting, skip processing
    if (!_isCollecting) return;
    
    // If we have recent sensor data, create a combined data point
    final latestSensorData = _sensorService.latestSensorData;
    if (latestSensorData != null) {
      final timeDifference = DateTime.now().difference(latestSensorData.timestamp).inMilliseconds;
      
      // Only use sensor data if it's fresh (less than 500ms old)
      if (timeDifference < 500) {
        _createCombinedDataPoint(obdData, latestSensorData);
      }
    }
  }
  
  /// Process sensor data received from the SensorService
  void _processSensorData(PhoneSensorData sensorData) {
    // If we're not actively collecting, skip processing
    if (!_isCollecting) return;
    
    // Get latest OBD data if available
    OBDIIData? latestObdData;
    if (_obdConnectionService.isConnected) {
      latestObdData = _obdConnectionService.getLatestOBDData();
    }
    
    // Create combined data point
    _createCombinedDataPoint(latestObdData, sensorData);
  }
  
  /// Create a combined data point and add it to the processing queue
  void _createCombinedDataPoint(OBDIIData? obdData, PhoneSensorData sensorData) {
    // Create the combined data point
    final combinedData = CombinedDrivingData.combine(
      timestamp: DateTime.now(),
      obdData: obdData,
      sensorData: sensorData,
    );
    
    // Add to buffer
    _addToDataBuffer(combinedData);
    
    // Process immediately
    _dataStreamController.add(combinedData);
    _ecoDrivingManager.addDataPoint(combinedData);
  }
  
  /// Actively collect a data point regardless of individual data streams
  /// Used for background collection to ensure continuous data flow
  Future<void> _collectDataPoint() async {
    if (!_isCollecting) return;
    
    try {
      // Get the latest sensor data
      final sensorData = await _sensorService.getLatestSensorData();
      if (sensorData == null) return;
      
      // Get latest OBD data if available
      OBDIIData? obdData;
      if (_obdConnectionService.isConnected) {
        obdData = _obdConnectionService.getLatestOBDData();
      }
      
      // Create combined data point
      final combinedData = CombinedDrivingData.combine(
        timestamp: DateTime.now(),
        obdData: obdData,
        sensorData: sensorData,
      );
      
      // Add to buffer
      _addToDataBuffer(combinedData);
      
      // Process data
      _dataStreamController.add(combinedData);
      _ecoDrivingManager.addDataPoint(combinedData);
      
    } catch (e) {
      _logger.warning('Error collecting data point: $e');
    }
  }
  
  /// Add data to the buffer with overflow protection
  void _addToDataBuffer(CombinedDrivingData data) {
    _dataBuffer.add(data);
    
    // Truncate buffer if it's too large
    while (_dataBuffer.length > _maxBufferSize) {
      _dataBuffer.removeAt(0);
    }
  }
  
  /// Process any buffered data that hasn't been sent
  void _processBufferedData() {
    // This is a placeholder for potential future processing
    // Currently data is processed immediately when received
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
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _logger.info('Disposing data collection service');
    
    // Stop collection if running
    if (_isCollecting) {
      stopCollection();
    }
    
    // Close stream controller
    _dataStreamController.close();
    
    super.dispose();
  }
} 