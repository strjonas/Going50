import 'dart:collection';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/calm_driving_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/speed_optimization_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/idling_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/short_distance_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/rpm_management_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/stop_management_detector.dart';
import 'package:going50/behavior_classifier_lib/detectors/follow_distance_detector.dart';

/// Manages all eco-driving detectors
class EcoDrivingManager {
  final List<BehaviorDetector> detectors;
  final int historyWindowSize;
  final Queue<CombinedDrivingData> dataQueue = Queue();
  
  EcoDrivingManager({
    List<BehaviorDetector>? detectors,
    this.historyWindowSize = 60, // Default to 1 minute of data (assuming 1 sample per second)
  }) : detectors = detectors ?? [
    CalmDrivingDetector(),
    SpeedOptimizationDetector(),
    IdlingDetector(),
    ShortDistanceDetector(),
    RPMManagementDetector(),
    StopManagementDetector(),
    FollowDistanceDetector(),
  ];
  
  /// Add new data point and analyze
  void addDataPoint(CombinedDrivingData dataPoint) {
    // Add to queue
    dataQueue.add(dataPoint);
    
    // Remove oldest if queue is too large
    while (dataQueue.length > historyWindowSize) {
      dataQueue.removeFirst();
    }
  }
  
  /// Analyze current data and return results from all detectors
  Map<String, BehaviorDetectionResult> analyzeAll() {
    Map<String, BehaviorDetectionResult> results = {};
    List<CombinedDrivingData> dataPoints = dataQueue.toList();
    
    // Run each detector
    results['calmDriving'] = detectors[0].detectBehavior(dataPoints);
    results['speedOptimization'] = detectors[1].detectBehavior(dataPoints);
    results['idling'] = detectors[2].detectBehavior(dataPoints);
    results['shortDistance'] = detectors[3].detectBehavior(dataPoints);
    results['rpmManagement'] = detectors[4].detectBehavior(dataPoints);
    results['stopManagement'] = detectors[5].detectBehavior(dataPoints);
    results['followDistance'] = detectors[6].detectBehavior(dataPoints);
    
    return results;
  }
  
  /// Calculate overall eco-driving score (0-100)
  double calculateOverallScore() {
    Map<String, BehaviorDetectionResult> results = analyzeAll();
    
    // If no data, return 0
    if (dataQueue.isEmpty) return 0.0;
    
    // Define weights for each behavior (sum should be 1.0)
    Map<String, double> weights = {
      'calmDriving': 0.25,        // 25% - Very important
      'speedOptimization': 0.2,   // 20% - Important
      'idling': 0.1,              // 10% - Lower but still important
      'shortDistance': 0.1,       // 10% - Lower but still important
      'rpmManagement': 0.15,      // 15% - Moderately important
      'stopManagement': 0.1,      // 10% - Lower but still important
      'followDistance': 0.1,      // 10% - Lower but still important
    };
    
    double weightedSum = 0.0;
    double totalWeight = 0.0;
    
    // Calculate weighted score
    results.forEach((key, result) {
      double weight = weights[key] ?? 0.0;
      
      // Adjust weight by confidence
      double adjustedWeight = weight * result.confidence;
      totalWeight += adjustedWeight;
      
      // Add to weighted sum (invert severity since lower severity = better score)
      double score = result.detected ? 100.0 * (1.0 - (result.severity ?? 0.0)) : 100.0;
      weightedSum += score * adjustedWeight;
    });
    
    // Return weighted average (or 0 if no weights)
    return totalWeight > 0.0 ? weightedSum / totalWeight : 0.0;
  }
  
  /// Get detailed analysis with scores for each category
  Map<String, dynamic> getDetailedAnalysis() {
    Map<String, BehaviorDetectionResult> results = analyzeAll();
    double overallScore = calculateOverallScore();
    
    Map<String, dynamic> detailedScores = {};
    
    // Calculate individual scores
    results.forEach((key, result) {
      double score = result.detected ? 100.0 * (1.0 - (result.severity ?? 0.0)) : 100.0;
      
      detailedScores[key] = {
        'score': score,
        'confidence': result.confidence,
        'message': result.message,
        'details': result.additionalData,
      };
    });
    
    return {
      'overallScore': overallScore,
      'detailedScores': detailedScores,
      'dataPointsAnalyzed': dataQueue.length,
      'timeRange': dataQueue.isNotEmpty 
          ? '${dataQueue.first.timestamp.toIso8601String()} to ${dataQueue.last.timestamp.toIso8601String()}'
          : 'No data',
    };
  }
  
  /// Clear all stored data
  void clearData() {
    dataQueue.clear();
  }
} 