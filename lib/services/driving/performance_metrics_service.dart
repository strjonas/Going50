import 'dart:async';
import 'dart:math' as math;
import 'package:logging/logging.dart';

import '../../core_models/trip.dart';
import '../../data_lib/data_storage_manager.dart';

/// Service responsible for calculating and managing performance metrics
/// for eco-driving behavior analysis over different time periods.
class PerformanceMetricsService {
  final DataStorageManager _dataStorageManager;
  final Logger _logger = Logger('PerformanceMetricsService');
  
  // Cache for recently calculated metrics to reduce database hits
  final Map<String, PerformanceMetrics> _metricsCache = {};
  
  // Constants for savings calculations
  static const double _averageFuelPricePerLiter = 1.5; // Example value in USD
  static const double _kgCO2PerLiterFuel = 2.31; // Average CO2 emissions per liter of gasoline
  
  /// Creates a new PerformanceMetricsService instance
  PerformanceMetricsService(this._dataStorageManager);
  
  /// Gets performance metrics for a specific time period
  /// 
  /// [periodStart] is the start of the period
  /// [periodEnd] is the end of the period
  /// Returns a Future that completes with the calculated performance metrics
  Future<PerformanceMetrics> getMetricsForPeriod(
    DateTime periodStart, 
    DateTime periodEnd,
    {String? userId}
  ) async {
    // Generate a cache key based on period and user
    final cacheKey = '${userId ?? 'default'}_${periodStart.toIso8601String()}_${periodEnd.toIso8601String()}';
    
    // Check if we have cached metrics for this period
    if (_metricsCache.containsKey(cacheKey)) {
      return _metricsCache[cacheKey]!;
    }
    
    try {
      // Get all trips within the period
      final trips = await _dataStorageManager.getAllTrips();
      final periodTrips = trips.where((trip) {
        // Filter trips within the period
        return trip.startTime.isAfter(periodStart) &&
               trip.endTime != null &&
               trip.endTime!.isBefore(periodEnd) &&
               trip.isCompleted == true;
      }).toList();
      
      if (periodTrips.isEmpty) {
        // Return empty metrics if no trips found
        final emptyMetrics = PerformanceMetrics(
          userId: userId,
          generatedAt: DateTime.now(),
          periodStart: periodStart,
          periodEnd: periodEnd,
          totalTrips: 0,
          totalDistanceKm: 0,
          totalDrivingTimeMinutes: 0,
          calmDrivingScore: 0,
          efficientAccelerationScore: 0,
          efficientBrakingScore: 0,
          idlingScore: 0,
          speedOptimizationScore: 0,
          steadySpeedScore: 0,
          overallScore: 0,
          improvementTipsJson: '{"tips":[]}',
        );
        
        _metricsCache[cacheKey] = emptyMetrics;
        return emptyMetrics;
      }
      
      // Calculate metrics based on trips
      final metrics = await _calculateMetricsFromTrips(periodTrips);
      
      // Generate improvement tips based on metrics
      final improvementTips = _generateImprovementTips(metrics);
      
      // Create the final performance metrics object
      final performanceMetrics = PerformanceMetrics(
        userId: userId,
        generatedAt: DateTime.now(),
        periodStart: periodStart,
        periodEnd: periodEnd,
        totalTrips: periodTrips.length,
        totalDistanceKm: metrics['totalDistanceKm'] ?? 0,
        totalDrivingTimeMinutes: metrics['totalDrivingTimeMinutes'] ?? 0,
        calmDrivingScore: metrics['calmDrivingScore'] ?? 0,
        efficientAccelerationScore: metrics['efficientAccelerationScore'] ?? 0,
        efficientBrakingScore: metrics['efficientBrakingScore'] ?? 0,
        idlingScore: metrics['idlingScore'] ?? 0,
        speedOptimizationScore: metrics['speedOptimizationScore'] ?? 0,
        steadySpeedScore: metrics['steadySpeedScore'] ?? 0,
        overallScore: metrics['overallScore'] ?? 0,
        improvementTipsJson: improvementTips,
      );
      
      // Cache the metrics
      _metricsCache[cacheKey] = performanceMetrics;
      
      return performanceMetrics;
    } catch (e, stackTrace) {
      _logger.severe('Error calculating performance metrics', e, stackTrace);
      rethrow;
    }
  }
  
  /// Calculates daily metrics for a specific date
  Future<PerformanceMetrics> getDailyMetrics(DateTime date, {String? userId}) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return getMetricsForPeriod(startOfDay, endOfDay, userId: userId);
  }
  
  /// Calculates weekly metrics for a week containing the specified date
  Future<PerformanceMetrics> getWeeklyMetrics(DateTime date, {String? userId}) {
    // Get the start of the week (assuming Monday is the first day)
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final normalizedStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    // Get the end of the week (Sunday)
    final endOfWeek = normalizedStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    
    return getMetricsForPeriod(normalizedStart, endOfWeek, userId: userId);
  }
  
  /// Calculates monthly metrics for a month containing the specified date
  Future<PerformanceMetrics> getMonthlyMetrics(DateTime date, {String? userId}) {
    // First day of the month
    final startOfMonth = DateTime(date.year, date.month, 1);
    
    // Last day of the month
    final lastDay = (date.month < 12) 
        ? DateTime(date.year, date.month + 1, 0)
        : DateTime(date.year + 1, 1, 0);
    
    final endOfMonth = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
    
    return getMetricsForPeriod(startOfMonth, endOfMonth, userId: userId);
  }
  
  /// Calculates yearly metrics for the year containing the specified date
  Future<PerformanceMetrics> getYearlyMetrics(DateTime date, {String? userId}) {
    final startOfYear = DateTime(date.year, 1, 1);
    final endOfYear = DateTime(date.year, 12, 31, 23, 59, 59);
    
    return getMetricsForPeriod(startOfYear, endOfYear, userId: userId);
  }
  
  /// Gets trend data for a specific metric over time
  /// 
  /// [metricType] is the type of metric to get trend data for
  /// [startDate] is the start of the trend period
  /// [endDate] is the end of the trend period
  /// [interval] defines the granularity (daily, weekly, monthly)
  /// Returns a map of dates to metric values
  Future<Map<DateTime, double>> getTrendData(
    String metricType,
    DateTime startDate,
    DateTime endDate,
    {required String interval, String? userId}
  ) async {
    final result = <DateTime, double>{};
    
    try {
      if (interval == 'daily') {
        // Daily intervals
        var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
        while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
          final metrics = await getDailyMetrics(currentDate, userId: userId);
          result[currentDate] = _getMetricValueByType(metrics, metricType);
          currentDate = currentDate.add(const Duration(days: 1));
        }
      } else if (interval == 'weekly') {
        // Weekly intervals
        var currentDate = startDate.subtract(Duration(days: startDate.weekday - 1));
        currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
        
        while (currentDate.isBefore(endDate)) {
          final metrics = await getWeeklyMetrics(currentDate, userId: userId);
          result[currentDate] = _getMetricValueByType(metrics, metricType);
          currentDate = currentDate.add(const Duration(days: 7));
        }
      } else if (interval == 'monthly') {
        // Monthly intervals
        var currentMonth = DateTime(startDate.year, startDate.month, 1);
        
        while (currentMonth.isBefore(endDate) || 
              (currentMonth.year == endDate.year && currentMonth.month == endDate.month)) {
          final metrics = await getMonthlyMetrics(currentMonth, userId: userId);
          result[currentMonth] = _getMetricValueByType(metrics, metricType);
          
          // Move to next month
          if (currentMonth.month == 12) {
            currentMonth = DateTime(currentMonth.year + 1, 1, 1);
          } else {
            currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
          }
        }
      }
      
      return result;
    } catch (e, stackTrace) {
      _logger.severe('Error getting trend data', e, stackTrace);
      rethrow;
    }
  }
  
  /// Gets the latest performance metrics for a user
  /// This is used for achievement verification
  Future<Map<String, dynamic>?> getUserPerformanceMetrics(String userId) async {
    _logger.info('Getting performance metrics for user $userId');
    
    try {
      // Get the latest metrics for the user (last 90 days)
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 90));
      
      final metrics = await getMetricsForPeriod(startDate, endDate, userId: userId);
      
      // Convert to a map for easier use in achievement checking
      final metricsMap = <String, dynamic>{
        'overallScore': metrics.overallScore,
        'calmDrivingScore': metrics.calmDrivingScore,
        'efficientAccelerationScore': metrics.efficientAccelerationScore,
        'efficientBrakingScore': metrics.efficientBrakingScore,
        'idlingScore': metrics.idlingScore,
        'speedOptimizationScore': metrics.speedOptimizationScore,
        'steadySpeedScore': metrics.steadySpeedScore,
        'totalTrips': metrics.totalTrips,
        'totalDistanceKm': metrics.totalDistanceKm,
        'totalDrivingTimeMinutes': metrics.totalDrivingTimeMinutes,
      };
      
      // Get additional metrics from the database
      final additionalMetrics = await _dataStorageManager.getUserMetrics(userId);
      if (additionalMetrics != null) {
        metricsMap.addAll(additionalMetrics);
      }
      
      return metricsMap;
    } catch (e) {
      _logger.severe('Error getting user performance metrics: $e');
      return null;
    }
  }
  
  /// Calculates projected savings based on current performance metrics
  /// 
  /// [currentMetrics] is the current performance metrics
  /// [projectionMonths] is the number of months to project
  /// Returns a map with projected savings values
  Map<String, double> calculateProjectedSavings(
    PerformanceMetrics currentMetrics,
    int projectionMonths,
  ) {
    // No projection if no trips or distance
    if (currentMetrics.totalTrips == 0 || currentMetrics.totalDistanceKm == 0) {
      return {
        'fuelSavingsL': 0,
        'moneySavingsUSD': 0,
        'co2SavingsKg': 0,
      };
    }
    
    // Calculate the time period of the metrics in days
    final periodDays = currentMetrics.periodEnd.difference(currentMetrics.periodStart).inDays + 1;
    
    // Calculate average distance per day
    final averageDistancePerDay = currentMetrics.totalDistanceKm / periodDays;
    
    // Calculate projected distance for the projection period
    final projectedDistanceKm = averageDistancePerDay * 30 * projectionMonths;
    
    // Calculate fuel savings based on eco-score
    // Assuming linear relationship between eco-score and fuel savings
    // 0 eco-score = 0% savings, 100 eco-score = 25% savings
    final potentialSavingsPercentage = (currentMetrics.overallScore / 100) * 0.25;
    
    // Assume average fuel consumption of 7.5L/100km for a typical car
    const baselineFuelConsumption = 7.5; // L/100km
    
    // Calculate baseline fuel usage and potential savings
    final baselineFuelUsage = (projectedDistanceKm / 100) * baselineFuelConsumption;
    final fuelSavingsL = baselineFuelUsage * potentialSavingsPercentage;
    
    // Calculate money savings
    final moneySavingsUSD = fuelSavingsL * _averageFuelPricePerLiter;
    
    // Calculate CO2 savings
    final co2SavingsKg = fuelSavingsL * _kgCO2PerLiterFuel;
    
    return {
      'fuelSavingsL': fuelSavingsL,
      'moneySavingsUSD': moneySavingsUSD,
      'co2SavingsKg': co2SavingsKg,
    };
  }
  
  /// Clears the metrics cache
  void clearCache() {
    _metricsCache.clear();
  }
  
  /// Calculates detailed metrics from a list of trips
  Future<Map<String, double>> _calculateMetricsFromTrips(List<Trip> trips) async {
    final result = <String, double>{};
    
    // Initialize accumulators
    double totalDistanceKm = 0;
    double totalDrivingTimeMinutes = 0;
    int aggressiveAccelerationEventsCount = 0;
    int hardBrakingEventsCount = 0;
    int idlingEventsCount = 0;
    int excessiveSpeedEventsCount = 0;
    double totalAverageRPM = 0;
    
    // Process each trip
    for (final trip in trips) {
      // Accumulate distance
      totalDistanceKm += trip.distanceKm ?? 0;
      
      // Calculate driving time
      if (trip.endTime != null) {
        final drivingTimeMinutes = trip.endTime!.difference(trip.startTime).inMinutes;
        totalDrivingTimeMinutes += drivingTimeMinutes;
      }
      
      // Accumulate events
      aggressiveAccelerationEventsCount += trip.aggressiveAccelerationEvents ?? 0;
      hardBrakingEventsCount += trip.hardBrakingEvents ?? 0;
      idlingEventsCount += trip.idlingEvents ?? 0;
      excessiveSpeedEventsCount += trip.excessiveSpeedEvents ?? 0;
      
      // Accumulate RPM if available
      if (trip.averageRPM != null) {
        totalAverageRPM += trip.averageRPM!;
      }
      
      // Accumulate eco scores (assuming trip.ecoScore exists)
      // If it doesn't, you can adjust this or create a calculation for it
      // We'll skip this for now
    }
    
    // Calculate averages and scores
    final avgRPM = trips.isNotEmpty ? totalAverageRPM / trips.length : 0;
    
    // Calculate events per 100km for normalization
    final eventsPer100Km = totalDistanceKm > 0 ? 100 / totalDistanceKm : 0;
    final aggressiveAccelPer100Km = aggressiveAccelerationEventsCount * eventsPer100Km;
    final hardBrakingPer100Km = hardBrakingEventsCount * eventsPer100Km;
    final idlingPer100Km = idlingEventsCount * eventsPer100Km;
    final excessiveSpeedPer100Km = excessiveSpeedEventsCount * eventsPer100Km;
    
    // Calculate individual scores (inverting event counts, more events = lower score)
    // Using exponential decay function: score = 100 * e^(-k * events_per_100km)
    // where k is a calibration constant
    const kAccel = 0.3;
    const kBraking = 0.3;
    const kIdling = 0.2;
    const kSpeed = 0.15;
    
    final efficientAccelerationScore = 100 * math.exp(-kAccel * aggressiveAccelPer100Km);
    final efficientBrakingScore = 100 * math.exp(-kBraking * hardBrakingPer100Km);
    final idlingScore = 100 * math.exp(-kIdling * idlingPer100Km);
    final speedOptimizationScore = 100 * math.exp(-kSpeed * excessiveSpeedPer100Km);
    
    // Calculate calm driving score (combination of acceleration and braking)
    final calmDrivingScore = (efficientAccelerationScore + efficientBrakingScore) / 2;
    
    // Calculate steady speed score based on speed events and RPM
    // Normalize RPM score (assuming ideal RPM is around 1800)
    const idealRPM = 1800;
    final rpmDeviation = (avgRPM - idealRPM).abs() / idealRPM;
    final rpmScore = 100 * math.exp(-2 * rpmDeviation); // Exponential penalty for deviation
    
    final steadySpeedScore = (rpmScore + speedOptimizationScore) / 2;
    
    // Calculate overall score with weighted components
    const weightCalmDriving = 0.25;
    const weightEfficientAccel = 0.15;
    const weightEfficientBraking = 0.15;
    const weightIdling = 0.15;
    const weightSpeedOpt = 0.15;
    const weightSteadySpeed = 0.15;
    
    final overallScore = 
        calmDrivingScore * weightCalmDriving +
        efficientAccelerationScore * weightEfficientAccel +
        efficientBrakingScore * weightEfficientBraking +
        idlingScore * weightIdling +
        speedOptimizationScore * weightSpeedOpt +
        steadySpeedScore * weightSteadySpeed;
    
    // Store results
    result['totalDistanceKm'] = totalDistanceKm;
    result['totalDrivingTimeMinutes'] = totalDrivingTimeMinutes;
    result['calmDrivingScore'] = calmDrivingScore;
    result['efficientAccelerationScore'] = efficientAccelerationScore;
    result['efficientBrakingScore'] = efficientBrakingScore;
    result['idlingScore'] = idlingScore;
    result['speedOptimizationScore'] = speedOptimizationScore;
    result['steadySpeedScore'] = steadySpeedScore;
    result['overallScore'] = overallScore;
    
    return result;
  }
  
  /// Generates improvement tips based on metrics
  String _generateImprovementTips(Map<String, double> metrics) {
    final tips = <Map<String, dynamic>>[];
    
    // Find the lowest scoring metrics (areas for improvement)
    final scoredMetrics = <String, double>{
      'calmDriving': metrics['calmDrivingScore'] ?? 0,
      'efficientAcceleration': metrics['efficientAccelerationScore'] ?? 0,
      'efficientBraking': metrics['efficientBrakingScore'] ?? 0,
      'idling': metrics['idlingScore'] ?? 0,
      'speedOptimization': metrics['speedOptimizationScore'] ?? 0,
      'steadySpeed': metrics['steadySpeedScore'] ?? 0,
    };
    
    // Sort by score (ascending)
    final sortedMetrics = scoredMetrics.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    // Generate tips for the three lowest scores
    for (var i = 0; i < math.min(3, sortedMetrics.length); i++) {
      final metricKey = sortedMetrics[i].key;
      final score = sortedMetrics[i].value;
      
      // Only generate tips for scores below 80
      if (score >= 80) continue;
      
      // Generate specific tips based on the metric
      switch (metricKey) {
        case 'calmDriving':
          tips.add({
            'area': 'Calm Driving',
            'score': score.round(),
            'tip': 'Try to maintain a more relaxed driving style. Anticipate traffic flow to avoid sudden reactions.',
            'benefit': 'Reduces stress, fuel consumption, and wear on your vehicle.'
          });
          break;
        
        case 'efficientAcceleration':
          tips.add({
            'area': 'Acceleration',
            'score': score.round(),
            'tip': 'Accelerate gently and smoothly. Aim to reach your target speed within 15-20 seconds when possible.',
            'benefit': 'Can improve fuel efficiency by up to 20% in city driving.'
          });
          break;
          
        case 'efficientBraking':
          tips.add({
            'area': 'Braking',
            'score': score.round(),
            'tip': 'Look ahead and anticipate stops. Release the accelerator early and coast when approaching red lights or stop signs.',
            'benefit': 'Reduces fuel waste and extends the life of your brakes.'
          });
          break;
          
        case 'idling':
          tips.add({
            'area': 'Idling',
            'score': score.round(),
            'tip': 'Turn off your engine when stopped for more than 30-60 seconds, except in traffic.',
            'benefit': 'Eliminates unnecessary fuel consumption and emissions.'
          });
          break;
          
        case 'speedOptimization':
          tips.add({
            'area': 'Speed Management',
            'score': score.round(),
            'tip': 'Most vehicles are most efficient between 50-80 km/h (30-50 mph). On highways, reducing speed by 10 km/h can significantly improve efficiency.',
            'benefit': 'Every 10 km/h over 80 km/h can reduce fuel economy by about 10%.'
          });
          break;
          
        case 'steadySpeed':
          tips.add({
            'area': 'Steady Pace',
            'score': score.round(),
            'tip': 'Maintain a consistent speed and avoid unnecessary acceleration and deceleration. Use cruise control on highways when appropriate.',
            'benefit': 'Keeping a steady pace can improve fuel efficiency by 15-30% on highways.'
          });
          break;
      }
    }
    
    return '{"tips": ${tips.isEmpty ? '[]' : tips}}';
  }
  
  /// Gets a specific metric value from a PerformanceMetrics object based on type
  double _getMetricValueByType(PerformanceMetrics metrics, String metricType) {
    switch (metricType) {
      case 'overallScore':
        return metrics.overallScore;
      case 'calmDrivingScore':
        return metrics.calmDrivingScore;
      case 'efficientAccelerationScore':
        return metrics.efficientAccelerationScore;
      case 'efficientBrakingScore':
        return metrics.efficientBrakingScore;
      case 'idlingScore':
        return metrics.idlingScore;
      case 'speedOptimizationScore':
        return metrics.speedOptimizationScore;
      case 'steadySpeedScore':
        return metrics.steadySpeedScore;
      default:
        return 0;
    }
  }
}

/// Performance metrics model
class PerformanceMetrics {
  final String? userId;
  final DateTime generatedAt;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalTrips;
  final double totalDistanceKm;
  final double totalDrivingTimeMinutes;
  final double calmDrivingScore;
  final double efficientAccelerationScore;
  final double efficientBrakingScore;
  final double idlingScore;
  final double speedOptimizationScore;
  final double steadySpeedScore;
  final double overallScore;
  final String improvementTipsJson;

  PerformanceMetrics({
    this.userId,
    required this.generatedAt,
    required this.periodStart,
    required this.periodEnd,
    required this.totalTrips,
    required this.totalDistanceKm,
    required this.totalDrivingTimeMinutes,
    required this.calmDrivingScore,
    required this.efficientAccelerationScore,
    required this.efficientBrakingScore,
    required this.idlingScore,
    required this.speedOptimizationScore,
    required this.steadySpeedScore,
    required this.overallScore,
    required this.improvementTipsJson,
  });
} 