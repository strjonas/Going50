import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';  // Added for DateTimeRange
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/driver_performance_metrics.dart';
import 'package:going50/services/driving/driving_service.dart';
import 'package:going50/services/driving/performance_metrics_service.dart';
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
  final PerformanceMetricsService _metricsService;
  
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
  final Map<String, double> _fuelSavings = {};
  final Map<String, double> _co2Reduction = {};
  final Map<String, double> _moneySavings = {};

  // Cache for performance metrics service results
  final Map<String, PerformanceMetrics> _performanceMetricsCache = {};
  
  /// Constructor
  InsightsProvider(this._drivingService, this._metricsService) {
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
    try {
      // Get performance metrics from the service
      PerformanceMetrics metrics;
      
      // Check if we have cached metrics
      if (_performanceMetricsCache.containsKey(period)) {
        metrics = _performanceMetricsCache[period]!;
      } else {
        // Get metrics from the service based on the time period
        switch (period) {
          case 'day':
            metrics = await _metricsService.getDailyMetrics(DateTime.now());
            break;
          case 'week':
            metrics = await _metricsService.getWeeklyMetrics(DateTime.now());
            break;
          case 'month':
            metrics = await _metricsService.getMonthlyMetrics(DateTime.now());
            break;
          case 'year':
            metrics = await _metricsService.getYearlyMetrics(DateTime.now());
            break;
          default:
            // Default to weekly metrics
            metrics = await _metricsService.getWeeklyMetrics(DateTime.now());
        }
        
        // Cache the metrics
        _performanceMetricsCache[period] = metrics;
      }
      
      // Convert PerformanceMetrics to DriverPerformanceMetrics
      _currentMetrics = _convertToDriverPerformanceMetrics(metrics, period);
      
      // Update savings calculations based on the performance metrics
      final projectionData = _metricsService.calculateProjectedSavings(
        metrics, 
        period == 'day' ? 1 : period == 'week' ? 4 : period == 'month' ? 12 : 52
      );
      
      _fuelSavings[period] = projectionData['fuelSavingsL'] ?? 0.0;
      _moneySavings[period] = projectionData['moneySavingsUSD'] ?? 0.0;
      _co2Reduction[period] = projectionData['co2SavingsKg'] ?? 0.0;
      
    } catch (e) {
      _setError('Failed to load metrics for $period: $e');
      
      // Fall back to mock metrics if there's an error
      _currentMetrics = _generateMockMetrics(period);
      _calculateSavings(period);
    }
  }
  
  /// Convert PerformanceMetrics to DriverPerformanceMetrics
  DriverPerformanceMetrics _convertToDriverPerformanceMetrics(
    PerformanceMetrics metrics,
    String period
  ) {
    // Extract improvement tips from JSON
    List<String> improvementTips = [];
    try {
      final tipsData = jsonDecode(metrics.improvementTipsJson);
      if (tipsData['tips'] != null) {
        for (var tip in tipsData['tips']) {
          improvementTips.add('${tip['area']}: ${tip['tip']} ${tip['benefit']}');
        }
      }
    } catch (e) {
      improvementTips = ['Try to drive more efficiently to improve your eco-score.'];
    }
    
    return DriverPerformanceMetrics(
      generatedAt: metrics.generatedAt,
      periodStart: metrics.periodStart,
      periodEnd: metrics.periodEnd,
      totalTrips: metrics.totalTrips,
      totalDistanceKm: metrics.totalDistanceKm,
      totalDrivingTimeMinutes: metrics.totalDrivingTimeMinutes,
      averageSpeedKmh: metrics.totalDrivingTimeMinutes > 0 
        ? (metrics.totalDistanceKm / metrics.totalDrivingTimeMinutes) * 60 
        : 0,
      estimatedFuelSavingsL: _fuelSavings[period],
      estimatedCO2ReductionKg: _co2Reduction[period],
      calmDrivingScore: metrics.calmDrivingScore.round(),
      speedOptimizationScore: metrics.speedOptimizationScore.round(),
      idlingScore: metrics.idlingScore.round(),
      shortDistanceScore: 70, // Not directly tracked in PerformanceMetrics
      rpmManagementScore: metrics.steadySpeedScore.round(),
      stopManagementScore: 75, // Not directly tracked in PerformanceMetrics
      followDistanceScore: 80, // Not directly tracked in PerformanceMetrics
      overallEcoScore: metrics.overallScore.round(),
      improvementRecommendations: improvementTips,
    );
  }
  
  /// Load trend data for charts
  Future<void> _loadTrends() async {
    try {
      // Load trend data from the metrics service
      // For each time period, we need a different interval and date range
      
      final now = DateTime.now();
      
      // Daily trend (hourly intervals for the current day)
      final startOfDay = DateTime(now.year, now.month, now.day);
      final dayTrend = await _metricsService.getTrendData(
        'overallScore',
        startOfDay,
        now,
        interval: 'daily',
      );
      
      // Weekly trend (daily intervals for the current week)
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final weekTrend = await _metricsService.getTrendData(
        'overallScore',
        startOfWeek,
        now,
        interval: 'daily',
      );
      
      // Monthly trend (weekly intervals for the current month)
      final startOfMonth = DateTime(now.year, now.month, 1);
      final monthTrend = await _metricsService.getTrendData(
        'overallScore',
        startOfMonth,
        now,
        interval: 'weekly',
      );
      
      // Yearly trend (monthly intervals for the current year)
      final startOfYear = DateTime(now.year, 1, 1);
      final yearTrend = await _metricsService.getTrendData(
        'overallScore',
        startOfYear,
        now,
        interval: 'monthly',
      );
      
      // Convert trend data to lists
      _ecoScoreTrends = {
        'day': _convertTrendMapToList(dayTrend),
        'week': _convertTrendMapToList(weekTrend),
        'month': _convertTrendMapToList(monthTrend),
        'year': _convertTrendMapToList(yearTrend),
      };
    } catch (e) {
      // Fall back to generated trends if there's an error
      _ecoScoreTrends = {
        'day': _generateHourlyTrend(),
        'week': _generateDailyTrend(),
        'month': _generateWeeklyTrend(),
        'year': _generateMonthlyTrend(),
      };
    }
  }
  
  /// Convert trend map to list
  List<double> _convertTrendMapToList(Map<DateTime, double> trendMap) {
    // Sort the dates
    final sortedDates = trendMap.keys.toList()..sort();
    
    // Create list of values in order
    return sortedDates.map((date) => trendMap[date] ?? 0.0).toList();
  }
  
  /// Calculate savings for the given period (legacy method, used as fallback)
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
  
  /// Generate mock metrics for a period (used as fallback if services fail)
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
  
  // The following methods filter trips and generate mock trend data
  // We keep them as fallbacks for when the service is unavailable

  /// Filter trips by date range
  List<Trip> filterTripsByDateRange(DateTime start, DateTime end) {
    return _recentTrips.where((trip) {
      return trip.startTime.isAfter(start) && 
             (trip.endTime?.isBefore(end) ?? false);
    }).toList();
  }
  
  /// Generate hourly trend data for the day view (fallback)
  List<double> _generateHourlyTrend() {
    // Create fixed mock data to avoid type conversion issues
    final baseValue = 65.0 + (DateTime.now().hour % 10);
    List<double> trend = [];
    
    for (int i = 0; i < 24; i++) {
      if (i <= DateTime.now().hour) {
        // Only include hours up to the current hour
        final variation = math.sin(i / 24 * math.pi * 2) * 10;
        trend.add(baseValue + variation);
      }
    }
    
    return trend;
  }
  
  /// Generate daily trend data for the week view (fallback)
  List<double> _generateDailyTrend() {
    // Create fixed mock data to avoid type conversion issues
    return [
      65.0, 68.0, 72.0, 70.0, 75.0, 78.0, 80.0
    ].sublist(0, math.min(7, DateTime.now().weekday + 1));
  }
  
  /// Generate weekly trend data for the month view (fallback)
  List<double> _generateWeeklyTrend() {
    // Create fixed mock data to avoid type conversion issues
    final weekOfMonth = (DateTime.now().day / 7).ceil();
    return [
      67.0, 70.0, 73.0, 75.0, 78.0
    ].sublist(0, math.min(5, weekOfMonth));
  }
  
  /// Generate monthly trend data for the year view (fallback)
  List<double> _generateMonthlyTrend() {
    // Create fixed mock data to avoid type conversion issues
    return [
      65.0, 67.0, 70.0, 72.0, 68.0, 70.0, 75.0, 78.0, 80.0, 82.0, 84.0, 85.0
    ].sublist(0, DateTime.now().month);
  }
  
  /// Refresh insights data
  Future<void> refreshInsights() async {
    // Clear caches
    _performanceMetricsCache.clear();
    
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
  
  // Helper methods to set loading state and errors
  
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
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
  List<Trip> searchTrips(String query) {
    if (query.isEmpty) return _recentTrips;
    
    final lowercaseQuery = query.toLowerCase();
    
    return _recentTrips.where((trip) {
      final date = DateFormat.yMMMd().format(trip.startTime);
      final time = DateFormat.jm().format(trip.startTime);
      
      return date.toLowerCase().contains(lowercaseQuery) ||
             time.toLowerCase().contains(lowercaseQuery) ||
             (trip.distanceKm?.toString() ?? '').contains(lowercaseQuery);
    }).toList();
  }
} 