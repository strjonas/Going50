import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/services/driving/driving_service.dart';

/// Provider for insights and historical data
///
/// This provider is responsible for:
/// - Loading and caching trip history data
/// - Managing performance metrics
/// - Providing access to historical driving data for visualization
class InsightsProvider extends ChangeNotifier {
  final DrivingService _drivingService;
  
  // State
  List<Trip> _recentTrips = [];
  Trip? _selectedTrip;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Time period for metrics analysis
  String _selectedTimeFrame = 'week'; // 'day', 'week', 'month', 'year'
  
  /// Constructor
  InsightsProvider(this._drivingService) {
    _loadRecentTrips();
  }
  
  // Public getters
  
  /// List of recent trips, sorted by start time descending
  List<Trip> get recentTrips => _recentTrips;
  
  /// Currently selected trip for detailed view
  Trip? get selectedTrip => _selectedTrip;
  
  /// Whether data is currently being loaded
  bool get isLoading => _isLoading;
  
  /// Error message, if any
  String? get errorMessage => _errorMessage;
  
  /// Currently selected time frame for analysis
  String get selectedTimeFrame => _selectedTimeFrame;
  
  /// Load recent trips
  Future<void> _loadRecentTrips() async {
    _setLoading(true);
    _clearError();
    
    try {
      final trips = await _drivingService.getTrips(limit: 50);
      _recentTrips = trips;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load trips: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Refresh trip data
  Future<void> refreshTrips() async {
    await _loadRecentTrips();
  }
  
  /// Load more trips (pagination)
  Future<void> loadMoreTrips() async {
    if (_isLoading) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final moreTrips = await _drivingService.getTrips(
        limit: 20,
        offset: _recentTrips.length,
      );
      
      if (moreTrips.isNotEmpty) {
        _recentTrips = [..._recentTrips, ...moreTrips];
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load more trips: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Select a trip for detailed view
  Future<void> selectTrip(String tripId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final trip = await _drivingService.getTrip(tripId);
      _selectedTrip = trip;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load trip details: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Clear the selected trip
  void clearSelectedTrip() {
    _selectedTrip = null;
    notifyListeners();
  }
  
  /// Set the time frame for analysis
  void setTimeFrame(String timeFrame) {
    if (_selectedTimeFrame != timeFrame) {
      _selectedTimeFrame = timeFrame;
      notifyListeners();
    }
  }
  
  /// Search trips by keyword
  Future<List<Trip>> searchTrips(String keyword) async {
    if (keyword.isEmpty) {
      return _recentTrips;
    }
    
    keyword = keyword.toLowerCase();
    
    return _recentTrips.where((trip) {
      // Check trip date in string format
      final tripDate = trip.startTime.toString().toLowerCase();
      if (tripDate.contains(keyword)) {
        return true;
      }
      
      // In the future, more fields could be searched here
      return false;
    }).toList();
  }
  
  /// Filter trips by date range
  List<Trip> filterTripsByDateRange(DateTime start, DateTime end) {
    return _recentTrips.where((trip) {
      return trip.startTime.isAfter(start) && 
             trip.startTime.isBefore(end);
    }).toList();
  }
  
  /// Calculate average eco-score for a given time period
  /// Note: We have to use 0 as a default since eco-score comes from the database
  /// but isn't defined directly in the Trip model class
  double calculateAverageEcoScore(List<Trip> trips) {
    if (trips.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int tripCount = 0;
    
    for (final trip in trips) {
      // Access the eco-score from trip.toJson() since it's stored in the database
      // but not directly accessible as a property in the Trip class
      final ecoScore = trip.toJson()['ecoScore'] as int?;
      if (ecoScore != null) {
        totalScore += ecoScore.toDouble();
        tripCount++;
      }
    }
    
    return tripCount > 0 ? totalScore / tripCount : 0.0;
  }
  
  /// Calculate total distance for a given time period
  double calculateTotalDistance(List<Trip> trips) {
    if (trips.isEmpty) return 0.0;
    
    double totalDistance = 0.0;
    
    for (final trip in trips) {
      if (trip.distanceKm != null) {
        totalDistance += trip.distanceKm!;
      }
    }
    
    return totalDistance;
  }
  
  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  /// Clear error message
  void _clearError() {
    _errorMessage = null;
  }
} 