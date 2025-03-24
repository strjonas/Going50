import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';

import '../interfaces/location_manager.dart';
import '../models/sensor_config.dart';

/// Implementation of the LocationManager interface
class LocationManagerImpl implements LocationManager {
  final Logger _logger = Logger('LocationManager');
  final SensorConfig config;
  
  // Location data
  Position? _lastPosition;
  StreamSubscription<Position>? _positionSubscription;
  final StreamController<Position> _positionController = StreamController<Position>.broadcast();
  
  bool _isCollecting = false;
  
  /// Create a new LocationManagerImpl with the given configuration
  LocationManagerImpl({this.config = const SensorConfig()});
  
  @override
  Future<void> initialize() async {
    _logger.info('Initializing location manager');
    
    if (!config.collectLocation) {
      _logger.info('Location collection disabled by configuration');
      return;
    }
    
    try {
      // Check if location services are enabled
      final enabled = await isLocationServiceEnabled;
      if (!enabled) {
        _logger.warning('Location services are disabled');
        return;
      }
      
      // Request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _logger.warning('Location permissions denied');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _logger.warning('Location permissions permanently denied');
        return;
      }
      
      // Start collection
      startCollection();
    } catch (e) {
      _logger.severe('Error initializing location manager: $e');
    }
  }
  
  @override
  Future<bool> get isLocationServiceEnabled => Geolocator.isLocationServiceEnabled();
  
  @override
  Position? get lastPosition => _lastPosition;
  
  @override
  Stream<Position> get positionStream => _positionController.stream;
  
  @override
  Future<Position?> getCurrentPosition() async {
    try {
      if (_lastPosition != null) {
        return _lastPosition;
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: config.locationAccuracy,
        timeLimit: const Duration(seconds: 2) // Add a reasonable timeout
      ).timeout(
        const Duration(seconds: 2), // Add explicit timeout handling
        onTimeout: () {
          _logger.warning('Timeout while getting position, using last known position');
          return _lastPosition ?? Position(
            longitude: 0, 
            latitude: 0, 
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0, 
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0
          );
        }
      );
      
      _lastPosition = position;
      return position;
    } catch (e) {
      _logger.warning('Error getting current position: $e');
      // Return the last position or a default position instead of null
      return _lastPosition ?? Position(
        longitude: 0, 
        latitude: 0, 
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0, 
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0
      );
    }
  }
  
  @override
  void startCollection({
    LocationAccuracy? accuracy,
    int? distanceFilter,
    int? timeInterval,
  }) {
    if (_isCollecting) return;
    
    _logger.info('Starting location data collection');
    _isCollecting = true;
    
    try {
      // Use provided parameters or fall back to config values
      final locationSettings = LocationSettings(
        accuracy: accuracy ?? config.locationAccuracy,
        distanceFilter: distanceFilter ?? config.locationDistanceFilter,
        timeLimit: Duration(milliseconds: timeInterval ?? config.locationUpdateIntervalMs),
      );
      
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        _lastPosition = position;
        _positionController.add(position);
      });
    } catch (e) {
      _logger.severe('Error starting location collection: $e');
      _isCollecting = false;
    }
  }
  
  @override
  void stopCollection() {
    if (!_isCollecting) return;
    
    _logger.info('Stopping location data collection');
    _isCollecting = false;
    
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }
  
  @override
  void dispose() {
    _logger.info('Disposing location manager');
    
    stopCollection();
    _positionController.close();
  }
} 