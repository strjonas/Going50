import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects high RPM driving patterns
class RPMManagementDetector extends BehaviorDetector {
  final Map<int, int> gearRPMThresholds; // Map of gear position to RPM threshold
  final int defaultRPMThreshold; // Default threshold for unknown gear
  final double speedRPMRatioThreshold; // Threshold for RPM/speed ratio
  
  RPMManagementDetector({
    Map<int, int>? gearRPMThresholds,
    this.defaultRPMThreshold = 2500, // Conservative default for all gears
    this.speedRPMRatioThreshold = 70.0, // RPM per km/h threshold
  }) : this.gearRPMThresholds = gearRPMThresholds ?? {
    1: 3000, // 1st gear
    2: 2700, // 2nd gear
    3: 2500, // 3rd gear
    4: 2300, // 4th gear
    5: 2000, // 5th gear
    6: 1800, // 6th gear
  };
  
  @override
  int get minimumDataPoints => 20; // Need sufficient data to evaluate RPM patterns
  
  @override
  List<String> get requiredDataFields => [
    'obdData.rpm',
    'obdData.vehicleSpeed',
    'obdData.gearPosition',
    'contextData.transmissionType',
  ];
  
  @override
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints) {
    if (dataPoints.isEmpty) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.0,
        message: 'No data available for RPM analysis',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    // If we don't have RPM data, we can't do this analysis
    bool hasRPMData = dataPoints.any((data) => data.obdData?.rpm != null);
    if (!hasRPMData) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.1,
        message: 'No RPM data available for analysis',
      );
    }
    
    // Check if transmission is automatic (less relevant for automatic)
    String? transmissionType;
    for (var data in dataPoints) {
      if (data.contextData?.transmissionType != null) {
        transmissionType = data.contextData!.transmissionType;
        break;
      }
    }
    
    // If automatic, reduce confidence as RPM management is less driver-controlled
    if (transmissionType?.toLowerCase() == 'automatic') {
      confidence *= 0.6;
    }
    
    int totalPoints = 0;
    int highRPMPoints = 0;
    Map<int, int> totalPointsByGear = {};
    Map<int, int> highRPMPointsByGear = {};
    
    // Track max and average RPM
    int? maxRPM;
    double rpmSum = 0;
    int rpmCount = 0;
    
    // Analyze each data point
    for (var data in dataPoints) {
      int? rpm = data.obdData?.rpm;
      double? speed = data.obdData?.vehicleSpeed;
      int? gear = data.obdData?.gearPosition;
      
      if (rpm == null) continue;
      
      // Track max RPM
      if (maxRPM == null || rpm > maxRPM) {
        maxRPM = rpm;
      }
      
      // Add to average calculation
      rpmSum += rpm;
      rpmCount++;
      
      // Skip if speed is very low (likely idling, stopping)
      if (speed == null || speed < 5) continue;
      
      totalPoints++;
      
      // Use gear-specific threshold if gear is known
      int rpmThreshold;
      if (gear != null && gearRPMThresholds.containsKey(gear)) {
        rpmThreshold = gearRPMThresholds[gear]!;
        
        // Track by gear for detailed analysis
        totalPointsByGear[gear] = (totalPointsByGear[gear] ?? 0) + 1;
        if (rpm > rpmThreshold) {
          highRPMPointsByGear[gear] = (highRPMPointsByGear[gear] ?? 0) + 1;
        }
      } else {
        // Use RPM/speed ratio if gear is unknown
        double rpmPerSpeed = rpm / speed;
        if (rpmPerSpeed > speedRPMRatioThreshold) {
          highRPMPoints++;
        }
        
        // Also use default threshold as backup
        rpmThreshold = defaultRPMThreshold;
      }
      
      // Check if RPM is higher than threshold
      if (rpm > rpmThreshold) {
        highRPMPoints++;
      }
    }
    
    // Calculate average RPM
    double? avgRPM = rpmCount > 0 ? rpmSum / rpmCount : null;
    
    // Calculate percentage of time spent at high RPM
    double highRPMPercentage = totalPoints > 0 ? highRPMPoints / totalPoints : 0;
    
    // Determine severity (0-1 range)
    double severity = min(highRPMPercentage * 2, 1.0); // Scale up to make small percentages more significant
    
    // High RPM driving detected if more than 20% of time is at high RPM
    bool isDetected = highRPMPercentage > 0.2;
    
    return BehaviorDetectionResult(
      detected: isDetected,
      confidence: confidence,
      severity: severity,
      message: isDetected
          ? 'High RPM driving detected: ${(highRPMPercentage * 100).toStringAsFixed(1)}% of driving time'
          : 'RPM management is good: ${(highRPMPercentage * 100).toStringAsFixed(1)}% high RPM',
      additionalData: {
        'highRPMPercentage': highRPMPercentage,
        'maxRPM': maxRPM,
        'averageRPM': avgRPM,
        'totalPointsByGear': totalPointsByGear,
        'highRPMPointsByGear': highRPMPointsByGear,
        'transmissionType': transmissionType,
      },
    );
  }
} 