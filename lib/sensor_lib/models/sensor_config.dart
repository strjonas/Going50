import 'package:geolocator/geolocator.dart';

/// Configuration options for sensor collection
class SensorConfig {
  /// Frequency of accelerometer readings in Hz
  final int accelerometerFrequency;
  
  /// Frequency of gyroscope readings in Hz
  final int gyroscopeFrequency;
  
  /// Frequency of magnetometer readings in Hz
  final int magnetometerFrequency;
  
  /// Frequency of location updates in seconds
  final int locationUpdateIntervalMs;
  
  /// Accuracy level for location data
  final LocationAccuracy locationAccuracy;
  
  /// Minimum distance (in meters) between location updates
  final int locationDistanceFilter;
  
  /// Whether to collect accelerometer data
  final bool collectAccelerometer;
  
  /// Whether to collect gyroscope data
  final bool collectGyroscope;
  
  /// Whether to collect magnetometer data
  final bool collectMagnetometer;
  
  /// Whether to collect location data
  final bool collectLocation;
  
  /// Constructor
  const SensorConfig({
    this.accelerometerFrequency = 10,
    this.gyroscopeFrequency = 10,
    this.magnetometerFrequency = 10,
    this.locationUpdateIntervalMs = 1000, // Every second
    this.locationAccuracy = LocationAccuracy.high,
    this.locationDistanceFilter = 5,
    this.collectAccelerometer = true,
    this.collectGyroscope = true,
    this.collectMagnetometer = true,
    this.collectLocation = true,
  });
  
  /// Default configuration suitable for eco-driving analysis
  static const SensorConfig ecoDrivingConfig = SensorConfig(
    accelerometerFrequency: 20, // Higher frequency for sudden movements
    gyroscopeFrequency: 10,
    magnetometerFrequency: 5,
    locationUpdateIntervalMs: 1000,
    locationAccuracy: LocationAccuracy.high,
    locationDistanceFilter: 5,
  );
  
  /// Configuration for low power usage
  static const SensorConfig lowPowerConfig = SensorConfig(
    accelerometerFrequency: 5,
    gyroscopeFrequency: 5,
    magnetometerFrequency: 2,
    locationUpdateIntervalMs: 5000, // Every 5 seconds
    locationAccuracy: LocationAccuracy.medium,
    locationDistanceFilter: 20,
  );
  
  /// Create a new SensorConfig with modified parameters
  SensorConfig copyWith({
    int? accelerometerFrequency,
    int? gyroscopeFrequency,
    int? magnetometerFrequency,
    int? locationUpdateIntervalMs,
    LocationAccuracy? locationAccuracy,
    int? locationDistanceFilter,
    bool? collectAccelerometer,
    bool? collectGyroscope,
    bool? collectMagnetometer,
    bool? collectLocation,
  }) {
    return SensorConfig(
      accelerometerFrequency: accelerometerFrequency ?? this.accelerometerFrequency,
      gyroscopeFrequency: gyroscopeFrequency ?? this.gyroscopeFrequency,
      magnetometerFrequency: magnetometerFrequency ?? this.magnetometerFrequency,
      locationUpdateIntervalMs: locationUpdateIntervalMs ?? this.locationUpdateIntervalMs,
      locationAccuracy: locationAccuracy ?? this.locationAccuracy,
      locationDistanceFilter: locationDistanceFilter ?? this.locationDistanceFilter,
      collectAccelerometer: collectAccelerometer ?? this.collectAccelerometer,
      collectGyroscope: collectGyroscope ?? this.collectGyroscope,
      collectMagnetometer: collectMagnetometer ?? this.collectMagnetometer,
      collectLocation: collectLocation ?? this.collectLocation,
    );
  }
} 