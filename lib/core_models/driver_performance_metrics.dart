import 'package:intl/intl.dart';

/// Represents a collection of performance metrics for a driver over a period of time
/// Used for tracking progress and providing feedback on eco-driving behaviors
class DriverPerformanceMetrics {
  /// When these metrics were generated
  final DateTime generatedAt;
  
  /// Start of the period these metrics cover
  final DateTime periodStart;
  
  /// End of the period these metrics cover
  final DateTime periodEnd;
  
  /// Total number of trips in this period
  final int totalTrips;
  
  /// Total distance driven in kilometers
  final double totalDistanceKm;
  
  /// Total time spent driving in minutes
  final double totalDrivingTimeMinutes;
  
  /// Average speed in km/h across all trips
  final double averageSpeedKmh;
  
  /// Estimated fuel savings in liters (if available)
  final double? estimatedFuelSavingsL;
  
  /// Estimated CO2 reduction in kg (if available)
  final double? estimatedCO2ReductionKg;
  
  // Behavior-specific scores (0-100)
  
  /// Score for smooth acceleration/braking (0-100)
  final int calmDrivingScore;
  
  /// Score for maintaining optimal speed (0-100)
  final int speedOptimizationScore;
  
  /// Score for minimizing idle time (0-100)
  final int idlingScore;
  
  /// Score for avoiding unnecessary short trips (0-100)
  final int shortDistanceScore;
  
  /// Score for optimal RPM management (0-100)
  final int rpmManagementScore;
  
  /// Score for efficient stop management (0-100)
  final int stopManagementScore;
  
  /// Score for maintaining safe following distance (0-100)
  final int followDistanceScore;
  
  /// Overall eco-driving score (0-100)
  final int overallEcoScore;
  
  /// List of recommended improvements
  final List<String> improvementRecommendations;

  DriverPerformanceMetrics({
    required this.generatedAt,
    required this.periodStart,
    required this.periodEnd,
    required this.totalTrips,
    required this.totalDistanceKm,
    required this.totalDrivingTimeMinutes,
    required this.averageSpeedKmh,
    this.estimatedFuelSavingsL,
    this.estimatedCO2ReductionKg,
    required this.calmDrivingScore,
    required this.speedOptimizationScore,
    required this.idlingScore,
    required this.shortDistanceScore,
    required this.rpmManagementScore,
    required this.stopManagementScore,
    required this.followDistanceScore,
    required this.overallEcoScore,
    required this.improvementRecommendations,
  });

  /// Convert to JSON representation
  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    return {
      'generatedAt': dateFormat.format(generatedAt),
      'periodStart': dateFormat.format(periodStart),
      'periodEnd': dateFormat.format(periodEnd),
      'totalTrips': totalTrips,
      'totalDistanceKm': totalDistanceKm,
      'totalDrivingTimeMinutes': totalDrivingTimeMinutes,
      'averageSpeedKmh': averageSpeedKmh,
      'estimatedFuelSavingsL': estimatedFuelSavingsL,
      'estimatedCO2ReductionKg': estimatedCO2ReductionKg,
      'calmDrivingScore': calmDrivingScore,
      'speedOptimizationScore': speedOptimizationScore,
      'idlingScore': idlingScore,
      'shortDistanceScore': shortDistanceScore,
      'rpmManagementScore': rpmManagementScore,
      'stopManagementScore': stopManagementScore,
      'followDistanceScore': followDistanceScore,
      'overallEcoScore': overallEcoScore,
      'improvementRecommendations': improvementRecommendations,
    };
  }

  /// Create from JSON data
  factory DriverPerformanceMetrics.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    return DriverPerformanceMetrics(
      generatedAt: dateFormat.parse(json['generatedAt']),
      periodStart: dateFormat.parse(json['periodStart']),
      periodEnd: dateFormat.parse(json['periodEnd']),
      totalTrips: json['totalTrips'],
      totalDistanceKm: json['totalDistanceKm'].toDouble(),
      totalDrivingTimeMinutes: json['totalDrivingTimeMinutes'].toDouble(),
      averageSpeedKmh: json['averageSpeedKmh'].toDouble(),
      estimatedFuelSavingsL: json['estimatedFuelSavingsL']?.toDouble(),
      estimatedCO2ReductionKg: json['estimatedCO2ReductionKg']?.toDouble(),
      calmDrivingScore: json['calmDrivingScore'],
      speedOptimizationScore: json['speedOptimizationScore'],
      idlingScore: json['idlingScore'],
      shortDistanceScore: json['shortDistanceScore'],
      rpmManagementScore: json['rpmManagementScore'],
      stopManagementScore: json['stopManagementScore'],
      followDistanceScore: json['followDistanceScore'],
      overallEcoScore: json['overallEcoScore'],
      improvementRecommendations: List<String>.from(json['improvementRecommendations']),
    );
  }
}
