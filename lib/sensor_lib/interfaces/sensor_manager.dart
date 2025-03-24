import 'package:sensors_plus/sensors_plus.dart';

/// Interface for sensor management
abstract class SensorManager {
  /// Initialize the sensor manager and start collecting data
  Future<void> initialize();

  /// Latest accelerometer reading
  AccelerometerEvent? get latestAccelerometer;

  /// Latest gyroscope reading
  GyroscopeEvent? get latestGyroscope;

  /// Latest magnetometer reading (if available)
  MagnetometerEvent? get latestMagnetometer;

  /// Latest user accelerometer reading (gravity removed)
  UserAccelerometerEvent? get latestUserAccelerometer;

  /// Get a stream of accelerometer events
  Stream<AccelerometerEvent> get accelerometerStream;

  /// Get a stream of gyroscope events
  Stream<GyroscopeEvent> get gyroscopeStream;

  /// Get a stream of magnetometer events
  Stream<MagnetometerEvent> get magnetometerStream;

  /// Get a stream of user accelerometer events
  Stream<UserAccelerometerEvent> get userAccelerometerStream;

  /// Start collecting sensor data
  void startCollection();

  /// Stop collecting sensor data
  void stopCollection();

  /// Clean up resources
  void dispose();
} 