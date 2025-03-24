import 'package:geolocator/geolocator.dart';

/// Interface for location management
abstract class LocationManager {
  /// Initialize the location manager and request permissions
  Future<void> initialize();

  /// Check if location services are enabled
  Future<bool> get isLocationServiceEnabled;

  /// Get the current position
  Future<Position?> getCurrentPosition();

  /// Get a stream of position updates
  Stream<Position> get positionStream;

  /// Get the last known position
  Position? get lastPosition;

  /// Start collecting location data
  void startCollection({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 5, // meters
    int timeInterval = 1000, // milliseconds
  });

  /// Stop collecting location data
  void stopCollection();

  /// Clean up resources
  void dispose();
} 