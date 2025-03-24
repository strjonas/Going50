import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/behavior_classifier_lib/managers/eco_driving_manager.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/core_models/obd_II_data.dart';
import 'package:going50/core_models/phone_sensor_data.dart';
import 'package:going50/services/driving/obd_connection_service.dart';
import 'package:going50/services/driving/sensor_service.dart';
import 'package:going50/services/driving/analytics_service.dart';
import 'package:going50/services/driving/trip_service.dart';
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
  AnalyticsService? _analyticsService; // Optional dependency
  TripService? _tripService; // Optional dependency
  
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
  
  /// Set the analytics service
  void setAnalyticsService(AnalyticsService analyticsService) {
    _analyticsService = analyticsService;
    _logger.info('Analytics service registered with data collection service');
  }
  
  /// Set the trip service
  void setTripService(TripService tripService) {
    _tripService = tripService;
    _logger.info('Trip service registered with data collection service');
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
      
      // Try to initialize OBD service, but don't fail if it doesn't work
      // This allows the app to work with just sensors
      try {
        await _obdConnectionService.initialize();
      } catch (e) {
        _logger.warning('OBD initialization failed, will use sensor fallback: $e');
        _useFallbackMode = true;
      }
      
      // Initialize trip service if available
      if (_tripService != null) {
        await _tripService!.initialize();
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
      
      // Try to use OBD if available and not in fallback mode
      if (!_useFallbackMode) {
        // Check if OBD is connected
        if (!_obdConnectionService.isConnected) {
          _logger.info('OBD not connected, switching to sensor fallback mode');
          _useFallbackMode = true;
        } else {
          _logger.info('Using OBD for data collection');
        }
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
      
      // Initialize analytics if available
      if (_analyticsService != null) {
        await _analyticsService!.initialize();
      }
      
      // Start a new trip if we have a trip service
      if (_tripService != null && !_tripService!.isOnTrip) {
        await _tripService!.startTrip();
        _logger.info('Started a new trip via TripService');
      }
      
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
  Future<void> stopCollection() async {
    if (!_isCollecting) return;
    
    _logger.info('Stopping data collection');
    
    // Stop sensor collection
    _sensorService.stopCollection();
    
    // Cancel timers
    _processingTimer?.cancel();
    _processingTimer = null;
    
    _backgroundCollectionTimer?.cancel();
    _backgroundCollectionTimer = null;
    
    // Stop analytics if available
    if (_analyticsService != null) {
      _analyticsService!.stopAnalysis();
    }
    
    // End the current trip if we have a trip service
    if (_tripService != null && _tripService!.isOnTrip) {
      await _tripService!.endTrip();
      _logger.info('Ended current trip via TripService');
    }
    
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
    
    // Send to trip service if available and on a trip
    if (_tripService != null && _tripService!.isOnTrip) {
      _tripService!.processDataPoint(combinedData);
    }
    
    // Trigger analytics if available
    if (_analyticsService != null && _isCollecting) {
      _analyticsService!.triggerAnalysis();
    }
  }
  
  /// Actively collect a data point regardless of individual data streams
  /// Used for background collection to ensure continuous data flow
  Future<void> _collectDataPoint() async {
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
      
      // Send to trip service if available and on a trip
      if (_tripService != null && _tripService!.isOnTrip) {
        _tripService!.processDataPoint(combinedData);
      }
      
      // Trigger analytics if available
      if (_analyticsService != null) {
        _analyticsService!.triggerAnalysis();
      }
      
    } catch (e) {
      _logger.warning('Error collecting data point: $e');
    }
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