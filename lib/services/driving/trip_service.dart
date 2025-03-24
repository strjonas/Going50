import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

// Local imports
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/core_models/driving_event.dart';
import 'package:going50/data_lib/data_storage_manager.dart';

/// TripService manages trip recording and completion.
/// 
/// This service is responsible for:
/// - Starting and ending trips
/// - Calculating trip metrics
/// - Saving trip data points
/// - Retrieving trip history
class TripService extends ChangeNotifier {
  final Logger _logger = Logger('TripService');
  
  // Dependencies
  final DataStorageManager _dataStorageManager;
  
  // Service state
  bool _isInitialized = false;
  Trip? _currentTrip;
  String? _errorMessage;
  
  // Trip metrics tracking
  double _totalDistanceKm = 0.0;
  double _maxSpeedKmh = 0.0;
  double _sumSpeed = 0.0;
  int _speedReadingCount = 0;
  double _sumRpm = 0.0;
  int _rpmReadingCount = 0;
  double _estimatedFuelUsedL = 0.0;
  
  // Event counters
  int _idlingEvents = 0;
  int _aggressiveAccelerationEvents = 0;
  int _hardBrakingEvents = 0;
  int _excessiveSpeedEvents = 0;
  int _stopEvents = 0;
  
  // Data points for the current trip
  final List<CombinedDrivingData> _currentTripDataPoints = [];
  
  // Trip metrics stream
  final StreamController<Map<String, dynamic>> _metricsStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  // Trip state stream
  final StreamController<Trip?> _tripStateController = 
      StreamController<Trip?>.broadcast();
  
  // Public getters
  bool get isInitialized => _isInitialized;
  bool get isOnTrip => _currentTrip != null;
  Trip? get currentTrip => _currentTrip;
  String? get errorMessage => _errorMessage;
  double get totalDistanceKm => _totalDistanceKm;
  double get currentAverageSpeedKmh => _speedReadingCount > 0 ? _sumSpeed / _speedReadingCount : 0;
  double get maxSpeedKmh => _maxSpeedKmh;
  
  /// Stream of trip metrics updates
  Stream<Map<String, dynamic>> get metricsStream => _metricsStreamController.stream;
  
  /// Stream of trip state updates
  Stream<Trip?> get tripStateStream => _tripStateController.stream;
  
  /// Constructor
  TripService(this._dataStorageManager) {
    _logger.info('TripService created');
  }
  
  /// Initialize the trip service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    _logger.info('Initializing trip service');
    
    try {
      // Initialize data storage manager
      await _dataStorageManager.initialize();
      
      _isInitialized = true;
      _clearErrorMessage();
      return true;
    } catch (e) {
      _setErrorMessage('Failed to initialize trip service: $e');
      _logger.severe('Initialization error: $e');
      return false;
    }
  }
  
  /// Start a new trip
  Future<Trip?> startTrip() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return null;
    }
    
    if (_currentTrip != null) {
      _logger.warning('Attempted to start a trip while one is already in progress');
      return _currentTrip;
    }
    
    _logger.info('Starting new trip');
    
    try {
      // Create a new trip in the data storage
      final trip = await _dataStorageManager.startNewTrip();
      
      // Set as current trip
      _currentTrip = trip;
      
      // Reset metrics
      _resetMetrics();
      
      // Notify listeners
      notifyListeners();
      _tripStateController.add(trip);
      
      return trip;
    } catch (e) {
      _setErrorMessage('Failed to start trip: $e');
      _logger.severe('Error starting trip: $e');
      return null;
    }
  }
  
  /// End the current trip
  Future<Trip?> endTrip() async {
    if (_currentTrip == null) {
      _logger.warning('Attempted to end a trip when none is in progress');
      return null;
    }
    
    _logger.info('Ending trip ${_currentTrip!.id}');
    
    try {
      // Calculate final metrics
      final averageSpeedKmh = _speedReadingCount > 0 ? _sumSpeed / _speedReadingCount : 0.0;
      final averageRPM = _rpmReadingCount > 0 ? _sumRpm / _rpmReadingCount : 0.0;
      
      // End the trip in the data storage
      final completedTrip = await _dataStorageManager.endTrip(
        _currentTrip!.id,
        distanceKm: _totalDistanceKm,
        averageSpeedKmh: averageSpeedKmh,
        maxSpeedKmh: _maxSpeedKmh,
        fuelUsedL: _estimatedFuelUsedL,
        idlingEvents: _idlingEvents,
        aggressiveAccelerationEvents: _aggressiveAccelerationEvents,
        hardBrakingEvents: _hardBrakingEvents,
        excessiveSpeedEvents: _excessiveSpeedEvents,
        stopEvents: _stopEvents,
        averageRPM: averageRPM,
      );
      
      // Clear current trip
      final endedTrip = _currentTrip;
      _currentTrip = null;
      _currentTripDataPoints.clear();
      
      // Notify listeners
      notifyListeners();
      _tripStateController.add(null);
      
      return completedTrip;
    } catch (e) {
      _setErrorMessage('Failed to end trip: $e');
      _logger.severe('Error ending trip: $e');
      return null;
    }
  }
  
  /// Process a data point for the current trip
  Future<void> processDataPoint(CombinedDrivingData dataPoint) async {
    if (_currentTrip == null) return;
    
    try {
      // Save data point to storage
      await _dataStorageManager.saveTripDataPoint(_currentTrip!.id, dataPoint);
      
      // Add to current trip data points
      _currentTripDataPoints.add(dataPoint);
      
      // Update metrics
      _updateMetricsFromDataPoint(dataPoint);
      
      // Emit updated metrics
      _emitMetricsUpdate();
    } catch (e) {
      _logger.warning('Error processing data point: $e');
    }
  }
  
  /// Record a driving event for the current trip
  Future<void> recordDrivingEvent(DrivingEvent event) async {
    if (_currentTrip == null) return;
    
    try {
      // Save event to storage
      await _dataStorageManager.saveDrivingEvent(_currentTrip!.id, event);
      
      // Update counters based on event type
      switch (event.eventType) {
        case 'idling':
          _idlingEvents++;
          break;
        case 'aggressive_acceleration':
          _aggressiveAccelerationEvents++;
          break;
        case 'hard_braking':
          _hardBrakingEvents++;
          break;
        case 'excessive_speed':
          _excessiveSpeedEvents++;
          break;
        case 'stop':
          _stopEvents++;
          break;
      }
      
      // Emit updated metrics
      _emitMetricsUpdate();
    } catch (e) {
      _logger.warning('Error recording driving event: $e');
    }
  }
  
  /// Get trip history
  Future<List<Trip>> getTripHistory() async {
    try {
      return await _dataStorageManager.getAllTrips();
    } catch (e) {
      _logger.warning('Error getting trip history: $e');
      return [];
    }
  }
  
  /// Get a specific trip by ID
  Future<Trip?> getTrip(String tripId) async {
    try {
      return await _dataStorageManager.getTrip(tripId);
    } catch (e) {
      _logger.warning('Error getting trip $tripId: $e');
      return null;
    }
  }
  
  /// Watch for trip updates
  Stream<List<Trip>> watchTrips() {
    return _dataStorageManager.watchTrips();
  }
  
  /// Reset trip metrics
  void _resetMetrics() {
    _totalDistanceKm = 0.0;
    _maxSpeedKmh = 0.0;
    _sumSpeed = 0.0;
    _speedReadingCount = 0;
    _sumRpm = 0.0;
    _rpmReadingCount = 0;
    _estimatedFuelUsedL = 0.0;
    
    _idlingEvents = 0;
    _aggressiveAccelerationEvents = 0;
    _hardBrakingEvents = 0;
    _excessiveSpeedEvents = 0;
    _stopEvents = 0;
    
    _currentTripDataPoints.clear();
  }
  
  /// Update metrics from a data point
  void _updateMetricsFromDataPoint(CombinedDrivingData dataPoint) {
    // Get speed from best available source
    final speed = dataPoint.obdData?.vehicleSpeed ?? dataPoint.sensorData?.gpsSpeed;
    
    // Update speed metrics
    if (speed != null) {
      _sumSpeed += speed;
      _speedReadingCount++;
      
      if (speed > _maxSpeedKmh) {
        _maxSpeedKmh = speed;
      }
    }
    
    // Update RPM metrics
    if (dataPoint.obdData?.rpm != null) {
      _sumRpm += dataPoint.obdData!.rpm!;
      _rpmReadingCount++;
    }
    
    // Update distance if we have a valid speed
    if (speed != null && _currentTripDataPoints.length > 1) {
      final previousDataPoint = _currentTripDataPoints[_currentTripDataPoints.length - 2];
      final previousSpeed = previousDataPoint.obdData?.vehicleSpeed ?? previousDataPoint.sensorData?.gpsSpeed;
      
      // Calculate time difference in hours
      final timeDiffMs = dataPoint.timestamp.difference(previousDataPoint.timestamp).inMilliseconds;
      final timeDiffHours = timeDiffMs / (1000 * 60 * 60);
      
      // Simple distance calculation (speed * time)
      // Using average of current and previous speed for better accuracy
      double avgSpeed = speed;
      if (previousSpeed != null) {
        avgSpeed = (speed + previousSpeed) / 2;
      }
      
      // Calculate distance for this segment in km
      final segmentDistanceKm = avgSpeed * timeDiffHours;
      _totalDistanceKm += segmentDistanceKm;
      
      // Estimate fuel consumption (very rough estimate)
      // Using a basic approximation of 8L/100km
      const fuelConsumptionRate = 8.0 / 100.0; // L/km
      _estimatedFuelUsedL += segmentDistanceKm * fuelConsumptionRate;
    }
  }
  
  /// Emit metrics update
  void _emitMetricsUpdate() {
    if (!_metricsStreamController.isClosed) {
      _metricsStreamController.add({
        'distanceKm': _totalDistanceKm,
        'averageSpeedKmh': _speedReadingCount > 0 ? _sumSpeed / _speedReadingCount : 0,
        'maxSpeedKmh': _maxSpeedKmh,
        'estimatedFuelUsedL': _estimatedFuelUsedL,
        'idlingEvents': _idlingEvents,
        'aggressiveAccelerationEvents': _aggressiveAccelerationEvents,
        'hardBrakingEvents': _hardBrakingEvents,
        'excessiveSpeedEvents': _excessiveSpeedEvents,
        'stopEvents': _stopEvents,
        'averageRPM': _rpmReadingCount > 0 ? _sumRpm / _rpmReadingCount : 0,
      });
    }
  }
  
  /// Set error message
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  /// Clear error message
  void _clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Dispose resources
  @override
  void dispose() {
    _metricsStreamController.close();
    _tripStateController.close();
    super.dispose();
  }
} 