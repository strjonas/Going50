import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:logging/logging.dart';

import '../interfaces/sensor_manager.dart';
import '../models/sensor_config.dart';

/// Implementation of the SensorManager interface
class SensorManagerImpl implements SensorManager {
  final Logger _logger = Logger('SensorManager');
  final SensorConfig config;
  
  // Store the latest sensor readings
  AccelerometerEvent? _latestAccelerometer;
  GyroscopeEvent? _latestGyroscope;
  MagnetometerEvent? _latestMagnetometer;
  UserAccelerometerEvent? _latestUserAccelerometer;
  
  // Stream subscriptions
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  
  // Stream controllers for custom event frequencies
  final StreamController<AccelerometerEvent> _accelerometerController = 
      StreamController<AccelerometerEvent>.broadcast();
  final StreamController<GyroscopeEvent> _gyroscopeController = 
      StreamController<GyroscopeEvent>.broadcast();
  final StreamController<MagnetometerEvent> _magnetometerController = 
      StreamController<MagnetometerEvent>.broadcast();
  final StreamController<UserAccelerometerEvent> _userAccelerometerController = 
      StreamController<UserAccelerometerEvent>.broadcast();
  
  bool _isCollecting = false;
  
  /// Create a new SensorManagerImpl with the given configuration
  SensorManagerImpl({this.config = const SensorConfig()});
  
  @override
  Future<void> initialize() async {
    _logger.info('Initializing sensor manager');
    
    // Start collection if config says so
    if (config.collectAccelerometer || 
        config.collectGyroscope || 
        config.collectMagnetometer) {
      startCollection();
    }
  }

  @override
  AccelerometerEvent? get latestAccelerometer => _latestAccelerometer;

  @override
  GyroscopeEvent? get latestGyroscope => _latestGyroscope;

  @override
  MagnetometerEvent? get latestMagnetometer => _latestMagnetometer;

  @override
  UserAccelerometerEvent? get latestUserAccelerometer => _latestUserAccelerometer;

  @override
  Stream<AccelerometerEvent> get accelerometerStream => _accelerometerController.stream;

  @override
  Stream<GyroscopeEvent> get gyroscopeStream => _gyroscopeController.stream;

  @override
  Stream<MagnetometerEvent> get magnetometerStream => _magnetometerController.stream;

  @override
  Stream<UserAccelerometerEvent> get userAccelerometerStream => _userAccelerometerController.stream;
  
  @override
  void startCollection() {
    if (_isCollecting) return;
    
    _logger.info('Starting sensor data collection');
    _isCollecting = true;
    
    // Subscribe to accelerometer events
    if (config.collectAccelerometer) {
      _accelerometerSubscription = accelerometerEventStream().listen((event) {
        _latestAccelerometer = event;
        _accelerometerController.add(event);
      });
      
      _userAccelerometerSubscription = userAccelerometerEventStream().listen((event) {
        _latestUserAccelerometer = event;
        _userAccelerometerController.add(event);
      });
    }
    
    // Subscribe to gyroscope events
    if (config.collectGyroscope) {
      _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
        _latestGyroscope = event;
        _gyroscopeController.add(event);
      });
    }
    
    // Subscribe to magnetometer events
    if (config.collectMagnetometer) {
      _magnetometerSubscription = magnetometerEventStream().listen((event) {
        _latestMagnetometer = event;
        _magnetometerController.add(event);
      });
    }
  }
  
  @override
  void stopCollection() {
    if (!_isCollecting) return;
    
    _logger.info('Stopping sensor data collection');
    _isCollecting = false;
    
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    
    _gyroscopeSubscription?.cancel();
    _gyroscopeSubscription = null;
    
    _magnetometerSubscription?.cancel();
    _magnetometerSubscription = null;
    
    _userAccelerometerSubscription?.cancel();
    _userAccelerometerSubscription = null;
  }
  
  @override
  void dispose() {
    _logger.info('Disposing sensor manager');
    
    stopCollection();
    
    _accelerometerController.close();
    _gyroscopeController.close();
    _magnetometerController.close();
    _userAccelerometerController.close();
  }
} 