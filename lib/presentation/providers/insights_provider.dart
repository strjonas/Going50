import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // Added for DateTimeRange
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/driver_performance_metrics.dart';
import 'package:going50/services/driving/driving_service.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

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
  
  // Cache for performance metrics
  DriverPerformanceMetrics? _currentMetrics;
  Map<String, List<double>> _ecoScoreTrends = {};
  Map<String, double> _fuelSavings = {};
  Map<String, double> _co2Reduction = {};
  Map<String, double> _moneySavings = {};
  
  /// Constructor
  InsightsProvider(this._drivingService) {
    _loadRecentTrips();
    _loadPerformanceMetrics();
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
  
  /// Current performance metrics
  DriverPerformanceMetrics? get currentMetrics => _currentMetrics;
  
  /// Get eco-score trend data for the current time period
  List<double> get ecoScoreTrend => _ecoScoreTrends[_selectedTimeFrame] ?? [];
  
  /// Get fuel savings for the current time period
  double get fuelSavings => _fuelSavings[_selectedTimeFrame] ?? 0.0;
  
  /// Get CO2 reduction for the current time period
  double get co2Reduction => _co2Reduction[_selectedTimeFrame] ?? 0.0;
  
  /// Get money savings for the current time period
  double get moneySavings => _moneySavings[_selectedTimeFrame] ?? 0.0;
  
  /// Get time period description
  String get timePeriodDescription {
    switch (_selectedTimeFrame) {
      case 'day':
        return 'Today';
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'All Time';
    }
  }
  
  /// Get behavior scores for current time period
  Map<String, int> get behaviorScores {
    if (_currentMetrics == null) {
      return {};
    }
    
    return {
      'calm_driving': _currentMetrics!.calmDrivingScore,
      'speed_optimization': _currentMetrics!.speedOptimizationScore,
      'idle_management': _currentMetrics!.idlingScore,
      'trip_planning': _currentMetrics!.shortDistanceScore,
      'rpm_efficiency': _currentMetrics!.rpmManagementScore,
      'stop_management': _currentMetrics!.stopManagementScore,
      'following_distance': _currentMetrics!.followDistanceScore,
    };
  }
  
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
  
  /// Load performance metrics for all time periods
  Future<void> _loadPerformanceMetrics() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Load metrics for current time period
      await _loadMetricsForPeriod(_selectedTimeFrame);
      
      // Load trends
      await _loadTrends();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load performance metrics: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Load metrics for a specific time period
  Future<void> _loadMetricsForPeriod(String period) async {
    final dateRange = _getDateRangeForPeriod(period);
    
    try {
      // Normally we would get this from a service, but for now we'll create mock data
      // based on the trips in the date range
      final tripsInRange = filterTripsByDateRange(dateRange.start, dateRange.end);
      
      if (tripsInRange.isEmpty) {
        // No trips in this period, generate mock data
        _currentMetrics = _generateMockMetrics(period);
      } else {
        // Generate metrics based on actual trips
        _currentMetrics = _calculateMetricsFromTrips(tripsInRange, period);
      }
      
      // Update savings calculations
      _calculateSavings(period);
    } catch (e) {
      _setError('Failed to load metrics for $period: $e');
    }
  }
  
  /// Load trend data for charts
  Future<void> _loadTrends() async {
    _ecoScoreTrends = {
      'day': _generateHourlyTrend(),
      'week': _generateDailyTrend(),
      'month': _generateWeeklyTrend(),
      'year': _generateMonthlyTrend(),
    };
  }
  
  /// Calculate savings for the given period
  void _calculateSavings(String period) {
    if (_currentMetrics == null) return;
    
    // Fuel savings (L)
    final fuelSavings = _currentMetrics!.estimatedFuelSavingsL ?? 0.0;
    _fuelSavings[period] = fuelSavings;
    
    // CO2 reduction (kg)
    final co2Reduction = _currentMetrics!.estimatedCO2ReductionKg ?? 0.0;
    _co2Reduction[period] = co2Reduction;
    
    // Money savings ($) - assuming $1.50 per liter
    final moneySavings = fuelSavings * 1.50;
    _moneySavings[period] = moneySavings;
  }
  
  /// Get date range for the given period
  DateTimeRange _getDateRangeForPeriod(String period) {
    final now = DateTime.now();
    
    switch (period) {
      case 'day':
        final start = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: start, end: now);
      
      case 'week':
        // Start of week (assuming Sunday is the first day)
        final daysToSubtract = now.weekday % 7;
        final start = DateTime(now.year, now.month, now.day - daysToSubtract);
        return DateTimeRange(start: start, end: now);
      
      case 'month':
        final start = DateTime(now.year, now.month, 1);
        return DateTimeRange(start: start, end: now);
      
      case 'year':
        final start = DateTime(now.year, 1, 1);
        return DateTimeRange(start: start, end: now);
      
      default:
        // All time - using a far past date
        final start = DateTime(2020, 1, 1);
        return DateTimeRange(start: start, end: now);
    }
  }
  
  /// Generate mock metrics for a period
  DriverPerformanceMetrics _generateMockMetrics(String period) {
    final dateRange = _getDateRangeForPeriod(period);
    
    // Create metrics with random scores
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final baseScore = 60 + (random % 25); // Base score between 60-84
    
    return DriverPerformanceMetrics(
      generatedAt: DateTime.now(),
      periodStart: dateRange.start,
      periodEnd: dateRange.end,
      totalTrips: period == 'day' ? 1 : (period == 'week' ? 5 : (period == 'month' ? 18 : 220)),
      totalDistanceKm: period == 'day' ? 25.0 : (period == 'week' ? 125.0 : (period == 'month' ? 480.0 : 5800.0)),
      totalDrivingTimeMinutes: period == 'day' ? 45.0 : (period == 'week' ? 210.0 : (period == 'month' ? 840.0 : 9600.0)),
      averageSpeedKmh: 35.0,
      estimatedFuelSavingsL: period == 'day' ? 0.8 : (period == 'week' ? 4.2 : (period == 'month' ? 16.5 : 196.0)),
      estimatedCO2ReductionKg: period == 'day' ? 1.9 : (period == 'week' ? 9.8 : (period == 'month' ? 38.5 : 458.0)),
      calmDrivingScore: baseScore + (random % 15 - 7),
      speedOptimizationScore: baseScore + (random % 18 - 9),
      idlingScore: baseScore + (random % 12 - 6),
      shortDistanceScore: baseScore + (random % 10 - 5),
      rpmManagementScore: baseScore + (random % 20 - 10),
      stopManagementScore: baseScore + (random % 16 - 8),
      followDistanceScore: baseScore + (random % 14 - 7),
      overallEcoScore: baseScore,
      improvementRecommendations: [
        'Reduce aggressive acceleration to improve your calm driving score',
        'Avoid excessive idling to save fuel and reduce emissions',
        'Maintain a consistent speed on highways to optimize fuel efficiency',
      ],
    );
  }
  
  /// Calculate metrics from actual trips
  DriverPerformanceMetrics _calculateMetricsFromTrips(List<Trip> trips, String period) {
    final dateRange = _getDateRangeForPeriod(period);
    
    double totalDistanceKm = 0;
    double totalDrivingTimeMinutes = 0;
    double totalSpeed = 0;
    int speedReadingCount = 0;
    int totalIdlingEvents = 0;
    int totalAggressiveAccEvents = 0;
    int totalHardBrakingEvents = 0;
    int totalExcessiveSpeedEvents = 0;
    int totalStopEvents = 0;
    
    for (final trip in trips) {
      totalDistanceKm += trip.distanceKm ?? 0;
      
      if (trip.startTime != null && trip.endTime != null) {
        totalDrivingTimeMinutes += trip.endTime!.difference(trip.startTime).inMinutes.toDouble();
      }
      
      if (trip.averageSpeedKmh != null) {
        totalSpeed += trip.averageSpeedKmh!;
        speedReadingCount++;
      }
      
      // Get events from trip.toJson() since they aren't directly accessible
      final tripJson = trip.toJson();
      totalIdlingEvents += tripJson['idlingEvents'] as int? ?? 0;
      totalAggressiveAccEvents += tripJson['aggressiveAccelerationEvents'] as int? ?? 0;
      totalHardBrakingEvents += tripJson['hardBrakingEvents'] as int? ?? 0;
      totalExcessiveSpeedEvents += tripJson['excessiveSpeedEvents'] as int? ?? 0;
      totalStopEvents += tripJson['stopEvents'] as int? ?? 0;
    }
    
    final double averageSpeedKmh = speedReadingCount > 0 ? (totalSpeed / speedReadingCount).toDouble() : 0.0;
    
    // Calculate scores based on events
    final calmDrivingScore = _calculateScoreFromEvents(totalAggressiveAccEvents + totalHardBrakingEvents, trips.length);
    final idlingScore = _calculateScoreFromEvents(totalIdlingEvents, trips.length);
    final speedScore = _calculateScoreFromEvents(totalExcessiveSpeedEvents, trips.length);
    final stopScore = _calculateScoreFromEvents(totalStopEvents, trips.length);
    
    // Other scores would normally use more complex logic but we'll use defaults
    const rpmScore = 75;
    const followDistanceScore = 82;
    const shortTripScore = 68;
    
    // Overall score is the average of the component scores
    final overallScore = ((calmDrivingScore + idlingScore + speedScore + stopScore + rpmScore + followDistanceScore + shortTripScore) / 7).round();
    
    // Calculate estimated savings
    // Average car uses 8L/100km, we'll say 10% improvement from eco-driving
    final estimatedFuelSavingsL = totalDistanceKm * 0.08 * 0.1;
    // 2.3kg CO2 per liter of fuel
    final estimatedCO2ReductionKg = estimatedFuelSavingsL * 2.3;
    
    return DriverPerformanceMetrics(
      generatedAt: DateTime.now(),
      periodStart: dateRange.start,
      periodEnd: dateRange.end,
      totalTrips: trips.length,
      totalDistanceKm: totalDistanceKm,
      totalDrivingTimeMinutes: totalDrivingTimeMinutes,
      averageSpeedKmh: averageSpeedKmh,
      estimatedFuelSavingsL: estimatedFuelSavingsL,
      estimatedCO2ReductionKg: estimatedCO2ReductionKg,
      calmDrivingScore: calmDrivingScore,
      speedOptimizationScore: speedScore,
      idlingScore: idlingScore,
      shortDistanceScore: shortTripScore,
      rpmManagementScore: rpmScore,
      stopManagementScore: stopScore,
      followDistanceScore: followDistanceScore,
      overallEcoScore: overallScore,
      improvementRecommendations: _generateRecommendations([
        calmDrivingScore,
        speedScore,
        idlingScore,
        shortTripScore,
        rpmScore,
        stopScore,
        followDistanceScore,
      ]),
    );
  }
  
  /// Calculate a score based on event count and trip count
  int _calculateScoreFromEvents(int eventCount, int tripCount) {
    if (tripCount == 0) return 75; // Default
    
    // Events per trip ratio
    final ratio = eventCount / tripCount;
    
    // Score decreases as events increase
    if (ratio < 0.5) return 90;
    if (ratio < 1.0) return 80;
    if (ratio < 2.0) return 70;
    if (ratio < 3.0) return 60;
    if (ratio < 5.0) return 50;
    return 40;
  }
  
  /// Generate recommendations based on scores
  List<String> _generateRecommendations(List<int> scores) {
    final recommendations = <String>[];
    
    if (scores[0] < 70) {
      recommendations.add('Avoid aggressive acceleration and braking to improve your calm driving score');
    }
    
    if (scores[1] < 70) {
      recommendations.add('Maintain a consistent speed on highways to optimize fuel efficiency');
    }
    
    if (scores[2] < 70) {
      recommendations.add('Turn off your engine when stopped for more than 30 seconds to reduce idling');
    }
    
    if (scores[3] < 70) {
      recommendations.add('Try to combine short trips to improve your trip planning score');
    }
    
    if (scores[4] < 70) {
      recommendations.add('Shift gears earlier to maintain optimal RPM range for your vehicle');
    }
    
    if (scores[5] < 70) {
      recommendations.add('Anticipate traffic flow to reduce unnecessary stopping and starting');
    }
    
    if (scores[6] < 70) {
      recommendations.add('Keep a safe following distance to maintain steady speed and reduce braking');
    }
    
    // If all scores are good or we didn't add many recommendations
    if (recommendations.isEmpty || recommendations.length < 2) {
      recommendations.add('Great job! Continue your eco-driving habits to maximize savings');
    }
    
    return recommendations;
  }
  
  /// Generate hourly trend data for 'day' view
  List<double> _generateHourlyTrend() {

    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final double baseScore = 60.0 + (random % 25);
    final hourTrends = <double>[];
    
    final now = DateTime.now();
    final hourOfDay = now.hour;
    
    // Generate data for the past 24 hours, with more recent hours having actual data
    for (var i = 0; i < 24; i++) {
      if (i > hourOfDay) {
        // Future hours don't have data
        hourTrends.add(0.0);
      } else {
        // Past hours have data with small variations
        final double hourVariation = (i - 12) * (i - 12) / 8.0;
        final double variation = (random % 10 - 5).toDouble();
        final double score = baseScore + hourVariation + variation;
        hourTrends.add(score.clamp(0.0, 100.0));
      }
    }
    
    return hourTrends;

  }
  
  /// Generate daily trend data for 'week' view
  List<double> _generateDailyTrend() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final double baseScore = 60.0 + (random % 25);
    final dailyTrends = <double>[];
    
    final now = DateTime.now();
    final dayOfWeek = now.weekday % 7; // 0 = Sunday, 1 = Monday, etc.
    
    // Generate data for the past 7 days
    for (var i = 0; i < 7; i++) {
      if (i > dayOfWeek) {
        // Future days don't have data
        dailyTrends.add(0.0);
      } else {
        // Apply a slight upward trend to show improvement
        final double improvement = i * 0.8;
        final double variation = (random % 16 - 8) / 2.0;
        final double score = baseScore + improvement + variation;
        dailyTrends.add(score.clamp(0.0, 100.0));
      }
    }
    
    return dailyTrends;

  }
  
  /// Generate weekly trend data for 'month' view
  List<double> _generateWeeklyTrend() {
    // Create fixed mock data to avoid type conversion issues
    return [
      70.0, 74.0, 78.0, 82.0, 0.0
    ];
  }
  
  /// Generate monthly trend data for 'year' view
  List<double> _generateMonthlyTrend() {
    // Create fixed mock data to avoid type conversion issues
    return [
      65.0, 67.0, 70.0, 72.0, 68.0, 70.0, 75.0, 78.0, 80.0, 82.0, 84.0, 85.0
    ];
  }
  
  /// Refresh insights data
  Future<void> refreshInsights() async {
    await _loadRecentTrips();
    await _loadPerformanceMetrics();
  }
  
  /// Set the time frame for analysis
  Future<void> setTimeFrame(String timeFrame) async {
    if (_selectedTimeFrame != timeFrame) {
      _selectedTimeFrame = timeFrame;
      _setLoading(true);
      
      try {
        await _loadMetricsForPeriod(timeFrame);
      } catch (e) {
        _setError('Failed to load metrics for $timeFrame: $e');
      } finally {
        _setLoading(false);
      }
      
      notifyListeners();
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