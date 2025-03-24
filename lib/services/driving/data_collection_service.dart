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
  
  // Fallback mode tracking
  bool _useFallbackMode = false;
  
  // Public getters
  bool get isInitialized => _isInitialized;
  bool get isCollecting => _isCollecting;
  String? get errorMessage => _errorMessage;
  List<CombinedDrivingData> get dataBuffer => List.unmodifiable(_dataBuffer);
  bool get useFallbackMode => _useFallbackMode;
  
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
      // Initialize OBD connection service if not already done
      if (!_obdConnectionService.isInitialized) {
        final obdInitialized = await _obdConnectionService.initialize();
        if (!obdInitialized) {
          _setErrorMessage('Failed to initialize OBD connection service');
          return false;
        }
      }
      
      // Initialize sensor service if not already done
      if (!_sensorService.isInitialized) {
        final sensorInitialized = await _sensorService.initialize();
        if (!sensorInitialized) {
          _setErrorMessage('Failed to initialize sensor service');
          return false;
        }
      }
      
      _isInitialized = true;
      _clearErrorMessage();
      notifyListeners();
      
      _logger.info('Data collection service initialized successfully');
      return true;
    } catch (e) {
      _setErrorMessage('Error initializing data collection service: $e');
      _logger.severe('Error initializing data collection service', e);
      return false;
    }
  }
  
  /// Starts data collection
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
      
      // Try to start OBD collection, but don't fail if it doesn't work
      bool obdStarted = false;
      if (_obdConnectionService.isConnected) {
        try {
          await _obdConnectionService.startContinuousQueries();
          obdStarted = true;
        } catch (e) {
          _logger.warning('Failed to start OBD queries: $e');
        }
      }
      _useFallbackMode = !obdStarted;
      
      if (!obdStarted) {
        _logger.warning('OBD data collection failed, using sensor fallback mode');
      }
      
      // Set up data processing timer
      _setupProcessingTimer();
      
      // Set up background collection timer
      _setupBackgroundCollectionTimer();
      
      _isCollecting = true;
      notifyListeners();
      
      _logger.info('Data collection started successfully');
      return true;
    } catch (e) {
      _setErrorMessage('Error starting data collection: $e');
      _logger.severe('Error starting data collection', e);
      return false;
    }
  }
  
  /// Stops data collection
  Future<bool> stopCollection() async {
    if (!_isCollecting) return true;
    
    _logger.info('Stopping data collection');
    
    try {
      // Stop timers
      _processingTimer?.cancel();
      _processingTimer = null;
      
      _backgroundCollectionTimer?.cancel();
      _backgroundCollectionTimer = null;
      
      // Stop sensor collection
      _sensorService.stopCollection();
      
      // Stop OBD collection if connected
      if (_obdConnectionService.isConnected) {
        try {
          await _obdConnectionService.stopQueries();
        } catch (e) {
          _logger.warning('Failed to stop OBD queries: $e');
        }
      }
      
      // Clear buffer
      _dataBuffer.clear();
      
      _isCollecting = false;
      notifyListeners();
      
      _logger.info('Data collection stopped successfully');
      return true;
    } catch (e) {
      _setErrorMessage('Error stopping data collection: $e');
      _logger.severe('Error stopping data collection', e);
      return false;
    }
  }
  
  /// Clear the data buffer
  void clearDataBuffer() {
    _dataBuffer.clear();
    notifyListeners();
  }
  
  /// Process OBD data received from the ObdConnectionService
  void _processObdData(OBDIIData obdData) {
    // If we're not actively collecting, skip processing
    if (!_isCollecting) return;
    
    // If we're in fallback mode, ignore OBD data
    if (_useFallbackMode) return;
    
    // Create combined data point with OBD data and the latest sensor data
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
    
    // If in fallback mode or OBD not connected, use sensor data only
    if (_useFallbackMode || !_obdConnectionService.isConnected) {
      _createCombinedDataPoint(null, sensorData);
      return;
    }
    
    // If OBD connected, get the latest OBD data and combine with sensor data
    OBDIIData? latestObdData = _obdConnectionService.getLatestOBDData();
    _createCombinedDataPoint(latestObdData, sensorData);
  }
  
  /// Process the latest data
  void _processData() {
    if (!_isCollecting) return;
    
    try {
      // Create a combined data point
      final obdData = _obdConnectionService.isConnected ? _obdConnectionService.getLatestOBDData() : null;
      final sensorData = _sensorService.latestSensorData;
      
      if (sensorData == null) {
        _logger.warning('No sensor data available for processing');
        return;
      }
      
      final combinedData = _createCombinedDataPoint(obdData, sensorData);
      
      // Add to buffer
      _addToDataBuffer(combinedData);
      
      // Emit data point
      _dataStreamController.add(combinedData);
      
      // Add data point to eco driving manager
      _ecoDrivingManager.addDataPoint(combinedData);
    } catch (e) {
      _logger.warning('Error processing data: $e');
    }
  }
  
  /// Collect background data
  Future<void> _collectBackgroundData() async {
    if (!_isCollecting) return;
    
    try {
      // Get the latest sensor data
      final sensorData = await _sensorService.getLatestSensorData();
      if (sensorData == null) return;
      
      // Get latest OBD data if available and not in fallback mode
      OBDIIData? obdData;
      if (!_useFallbackMode && _obdConnectionService.isConnected) {
        obdData = _obdConnectionService.getLatestOBDData();
      }
      
      // Create combined data point
      final combinedData = _createCombinedDataPoint(obdData, sensorData);
      
      // Add to buffer
      _addToDataBuffer(combinedData);
      
      // Add data point to eco driving manager
      _ecoDrivingManager.addDataPoint(combinedData);
    } catch (e) {
      _logger.warning('Error collecting background data: $e');
    }
  }
  
  /// Create combined data point from OBD and sensor data
  CombinedDrivingData _createCombinedDataPoint(OBDIIData? obdData, PhoneSensorData sensorData) {
    // Create and return the combined data
    return CombinedDrivingData.combine(
      timestamp: DateTime.now(),
      obdData: obdData,
      sensorData: sensorData,
    );
  }
  
  /// Setup the timer for processing data
  void _setupProcessingTimer() {
    _processingTimer?.cancel();
    _processingTimer = Timer.periodic(
      const Duration(milliseconds: 200), 
      (_) => _processData()
    );
  }
  
  /// Setup the timer for background collection (when app in background)
  void _setupBackgroundCollectionTimer() {
    _backgroundCollectionTimer?.cancel();
    _backgroundCollectionTimer = Timer.periodic(
      const Duration(milliseconds: _backgroundCollectionIntervalMs), 
      (_) => _collectBackgroundData()
    );
  }
  
  /// Enable fallback mode to use only sensor data
  void enableFallbackMode() {
    if (_useFallbackMode) return;
    
    _logger.info('Enabling sensor fallback mode');
    _useFallbackMode = true;
    notifyListeners();
  }
  
  /// Attempt to use OBD data if available
  Future<bool> tryUseObdMode() async {
    if (!_useFallbackMode) return true;
    
    _logger.info('Attempting to exit fallback mode');
    
    // Check if OBD is connected
    if (!_obdConnectionService.isConnected) {
      _logger.info('OBD not connected, staying in fallback mode');
      return false;
    }
    
    _useFallbackMode = false;
    notifyListeners();
    return true;
  }
  
  /// Add data to the buffer with overflow protection
  void _addToDataBuffer(CombinedDrivingData data) {
    _dataBuffer.add(data);
    
    // Truncate buffer if it's too large
    while (_dataBuffer.length > _maxBufferSize) {
      _dataBuffer.removeAt(0);
    }
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