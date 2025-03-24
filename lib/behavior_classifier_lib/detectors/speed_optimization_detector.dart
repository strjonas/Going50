import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects if speed is within optimal range for fuel efficiency
class SpeedOptimizationDetector extends BehaviorDetector {
  final double minOptimalSpeed; // km/h
  final double maxOptimalSpeed; // km/h
  final double minSpeedThreshold; // Only evaluate when above this speed
  
  SpeedOptimizationDetector({
    this.minOptimalSpeed = 50.0, // 50-75 km/h optimal range as per research
    this.maxOptimalSpeed = 75.0,
    this.minSpeedThreshold = 20.0, // Don't evaluate below 20 km/h (city traffic)
  });
  
  @override
  int get minimumDataPoints => 10; // Need sufficient data to evaluate speed patterns
  
  @override
  List<String> get requiredDataFields => [
    'obdData.vehicleSpeed',
    'sensorData.gpsSpeed',
    'contextData.speedLimit',
    'contextData.roadType',
  ];
  
  @override
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints) {
    if (dataPoints.isEmpty) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.0,
        message: 'No data available for speed analysis',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    int totalPoints = 0;
    int optimalPoints = 0;
    int highSpeedPoints = 0;
    double? maxSpeed;
    double? avgSpeed;
    
    // Calculate sum for average
    double speedSum = 0;
    int speedCount = 0;
    
    // Analyze each data point
    for (var data in dataPoints) {
      double? speed = _getSpeed(data);
      if (speed == null) continue;
      
      // Track max speed
      if (maxSpeed == null || speed > maxSpeed) {
        maxSpeed = speed;
      }
      
      // Add to average calculation
      speedSum += speed;
      speedCount++;
      
      // Skip evaluation for very low speeds (likely in city traffic, stopping)
      if (speed < minSpeedThreshold) continue;
      
      totalPoints++;
      
      // Check if within optimal range
      if (speed >= minOptimalSpeed && speed <= maxOptimalSpeed) {
        optimalPoints++;
      }
      
      // Check for excessive speed (over 80 km/h as per research)
      if (speed > 80) {
        highSpeedPoints++;
      }
    }
    
    // Calculate average speed
    if (speedCount > 0) {
      avgSpeed = speedSum / speedCount;
    }
    
    // Calculate deviation from optimal range
    double severity = 0.0;
    if (totalPoints > 0) {
      double optimalPercentage = optimalPoints / totalPoints;
      double highSpeedPercentage = highSpeedPoints / totalPoints;
      
      // Severity is inverse of optimal percentage + penalty for high speed
      severity = (1.0 - optimalPercentage) * 0.7 + highSpeedPercentage * 0.3;
      severity = min(severity, 1.0);
    }
    
    // Determine if speed is optimal based on severity
    bool isOptimal = severity < 0.3; // Less than 30% deviation is considered optimal
    
    return BehaviorDetectionResult(
      detected: isOptimal,
      confidence: confidence,
      severity: severity,
      message: isOptimal 
          ? 'Speed management is optimal: ${(100 - severity * 100).toStringAsFixed(1)}% within efficient range'
          : 'Speed management needs improvement: only ${((1.0 - severity) * 100).toStringAsFixed(1)}% within efficient range',
      additionalData: {
        'maxSpeed': maxSpeed,
        'avgSpeed': avgSpeed,
        'optimalPercentage': totalPoints > 0 ? optimalPoints / totalPoints : 0,
        'highSpeedPercentage': totalPoints > 0 ? highSpeedPoints / totalPoints : 0,
      },
    );
  }
  
  // Helper to get speed from best available source
  double? _getSpeed(CombinedDrivingData data) {
    return data.obdData?.vehicleSpeed ?? data.sensorData?.gpsSpeed;
  }
} 