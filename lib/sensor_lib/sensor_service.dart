import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:geolocator/geolocator.dart';

import '../core_models/phone_sensor_data.dart';
import 'interfaces/sensor_manager.dart';
import 'interfaces/location_manager.dart';
import 'implementations/sensor_manager_impl.dart';
import 'implementations/location_manager_impl.dart';
import 'models/sensor_config.dart';

/// Main service for collecting phone sensor data
///
/// This class provides a facade for the sensor library, handling sensor initialization,
/// data collection, and processing.
class SensorService extends ChangeNotifier {
  final Logger _logger = Logger('SensorService');
  final bool isDebugMode;
  
  // Managers
  late final SensorManager _sensorManager;
  late final LocationManager _locationManager;
  
  // Config
  final SensorConfig config;
  
  // Collection state
  bool _isCollecting = false;
  Timer? _dataCollectionTimer;
  final List<PhoneSensorData> _dataBuffer = [];
  
  // Data controllers
  final StreamController<PhoneSensorData> _dataStreamController = 
      StreamController<PhoneSensorData>.broadcast();
  
  /// Creates a new SensorService instance with the specified configuration
  SensorService({
    this.config = const SensorConfig(),
    this.isDebugMode = false,
    SensorManager? sensorManager,
    LocationManager? locationManager,
    bool initLogging = true,
  }) {
    if (isDebugMode && initLogging) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        // ignore: avoid_print
        print('${record.level.name}: ${record.time}: ${record.message}');
      });
    }
    
    // Initialize managers
    _sensorManager = sensorManager ?? SensorManagerImpl(config: config);
    _locationManager = locationManager ?? LocationManagerImpl(config: config);
    
    _logger.info('SensorService created with config: ${config.toString()}');
  }
  
  /// Whether the service is currently collecting data
  bool get isCollecting => _isCollecting;
  
  /// Stream of sensor data updates
  Stream<PhoneSensorData> get dataStream => _dataStreamController.stream;
  
  /// The buffer of collected data
  List<PhoneSensorData> get dataBuffer => List.unmodifiable(_dataBuffer);
  
  /// Initialize the sensor service
  Future<void> initialize() async {
    _logger.info('Initializing sensor service');
    
    try {
      // Initialize sensors
      await _sensorManager.initialize();
      
      // Initialize location
      await _locationManager.initialize();
      
      _logger.info('Sensor service initialized successfully');
    } catch (e) {
      _logger.severe('Error initializing sensor service: $e');
    }
    
    notifyListeners();
  }
  
  /// Start collecting sensor data
  Future<void> startCollection({int collectionIntervalMs = 100}) async {
    if (_isCollecting) return;
    
    _logger.info('Starting sensor data collection');
    _isCollecting = true;
    
    // Start individual managers if they aren't already running
    _sensorManager.startCollection();
    _locationManager.startCollection();
    
    // Set up timer for periodic data collection
    _dataCollectionTimer = Timer.periodic(
      Duration(milliseconds: collectionIntervalMs), 
      _collectData
    );
    
    notifyListeners();
  }
  
  /// Stop collecting sensor data
  void stopCollection() {
    if (!_isCollecting) return;
    
    _logger.info('Stopping sensor data collection');
    _isCollecting = false;
    
    // Stop collection timer
    _dataCollectionTimer?.cancel();
    _dataCollectionTimer = null;
    
    notifyListeners();
  }
  
  /// Clear the data buffer
  void clearDataBuffer() {
    _dataBuffer.clear();
    notifyListeners();
  }
  
  /// Get the latest sensor data
  Future<PhoneSensorData> getLatestSensorData() async {
    return _collectSensorData();
  }
  
  /// Periodic collection callback
  void _collectData(Timer timer) async {
    try {
      final data = await _collectSensorData();
      
      // Add to buffer
      _dataBuffer.add(data);
      
      // Limit buffer size to prevent memory issues
      if (_dataBuffer.length > 1000) {
        _dataBuffer.removeAt(0);
      }
      
      // Send to stream
      _dataStreamController.add(data);
    } catch (e) {
      _logger.warning('Error collecting sensor data: $e');
    }
  }
  
  /// Collect and combine all sensor data
  Future<PhoneSensorData> _collectSensorData() async {
    final timestamp = DateTime.now();
    
    // Get the latest sensor readings
    final accel = _sensorManager.latestAccelerometer;
    final gyro = _sensorManager.latestGyroscope;
    final magnet = _sensorManager.latestMagnetometer;
    
    // Get location data
    Position? position = _locationManager.lastPosition;
    
    // If we don't have a recent position, try to get the current one
    try {
      position ??= await _locationManager.getCurrentPosition();
    } catch (e) {
      _logger.warning('Failed to get position: $e');
      // Position will remain null, the rest of the method handles this case
    }
    
    // Calculate total acceleration if components are available
    double? totalAcceleration;
    if (accel != null) {
      totalAcceleration = PhoneSensorData.calculateTotalAcceleration(
        accel.x, accel.y, accel.z);
    }
    
    // Construct and return the data model
    return PhoneSensorData(
      timestamp: timestamp,
      latitude: position?.latitude,
      longitude: position?.longitude,
      altitude: position?.altitude,
      gpsSpeed: position?.speed,
      gpsAccuracy: position?.accuracy,
      gpsHeading: position?.heading,
      accelerationX: accel?.x,
      accelerationY: accel?.y,
      accelerationZ: accel?.z,
      gyroX: gyro?.x,
      gyroY: gyro?.y,
      gyroZ: gyro?.z,
      magneticX: magnet?.x,
      magneticY: magnet?.y,
      magneticZ: magnet?.z,
      totalAcceleration: totalAcceleration,
    );
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _logger.info('Disposing sensor service');
    
    stopCollection();
    
    _sensorManager.dispose();
    _locationManager.dispose();
    _dataStreamController.close();
    
    super.dispose();
  }
} 