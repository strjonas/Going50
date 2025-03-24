import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects aggressive acceleration and braking patterns
class CalmDrivingDetector extends BehaviorDetector {
  final double accelerationThreshold; // km/h/s threshold for aggressive acceleration
  final double brakingThreshold; // km/h/s threshold for aggressive braking
  final double slopeAdjustmentFactor; // How much to adjust thresholds for slope
  
  CalmDrivingDetector({
    this.accelerationThreshold = 5.0, // 5 km/h/s as per research
    this.brakingThreshold = 5.0,      // 5 km/h/s
    this.slopeAdjustmentFactor = 0.5, // increase threshold by 0.5 km/h/s per % slope
  });
  
  @override
  int get minimumDataPoints => 5; // Need several data points to detect acceleration patterns
  
  @override
  List<String> get requiredDataFields => [
    'obdData.vehicleSpeed',
    'sensorData.accelerationX',
    'sensorData.accelerationY',
    'sensorData.accelerationZ',
    'contextData.slope',
  ];
  
  @override
  double calculateConfidence(List<CombinedDrivingData> dataPoints) {
    // Base confidence starts at 0.3 (minimum)
    double confidence = 0.3;
    
    // Check if we have enough data points
    if (dataPoints.length < minimumDataPoints) {
      return confidence * (dataPoints.length / minimumDataPoints);
    }
    
    // Count how many required fields are present
    int availableFields = 0;
    int totalRequiredFields = requiredDataFields.length;
    
    for (String field in requiredDataFields) {
      bool hasField = _checkFieldAvailability(dataPoints.first, field);
      if (hasField) availableFields++;
    }
    
    // Calculate confidence based on field availability (0.3-1.0 range)
    return 0.3 + 0.7 * (availableFields / totalRequiredFields);
  }
  
  /// Helper to check if a field is available in the data
  bool _checkFieldAvailability(CombinedDrivingData data, String fieldPath) {
    List<String> parts = fieldPath.split('.');
    
    if (parts[0] == 'obdData') {
      if (data.obdData == null) return false;
      
      switch (parts[1]) {
        case 'vehicleSpeed': return data.obdData!.vehicleSpeed != null;
        case 'rpm': return data.obdData!.rpm != null;
        case 'throttlePosition': return data.obdData!.throttlePosition != null;
        case 'engineRunning': return data.obdData!.engineRunning != null;
        // Add additional OBD fields as needed
        default: return false;
      }
    } else if (parts[0] == 'sensorData') {
      if (data.sensorData == null) return false;
      
      switch (parts[1]) {
        case 'gpsSpeed': return data.sensorData!.gpsSpeed != null;
        case 'accelerationX': return data.sensorData!.accelerationX != null;
        case 'accelerationY': return data.sensorData!.accelerationY != null;
        case 'accelerationZ': return data.sensorData!.accelerationZ != null;
        // Add additional sensor fields as needed
        default: return false;
      }
    } else if (parts[0] == 'contextData') {
      if (data.contextData == null) return false;
      
      switch (parts[1]) {
        case 'speedLimit': return data.contextData!.speedLimit != null;
        case 'slope': return data.contextData!.slope != null;
        case 'isTrafficJam': return data.contextData!.isTrafficJam != null;
        // Add additional context fields as needed
        default: return false;
      }
    }
    
    return false;
  }
  
  @override
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints) {
    if (dataPoints.length < 2) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.1,
        message: 'Insufficient data points to calculate acceleration',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    // Track aggressive events
    int aggressiveAccelerations = 0;
    int aggressiveBrakings = 0;
    List<double> accelerationValues = [];
    
    // Sort data points by timestamp to ensure correct sequence
    dataPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    // Calculate acceleration between consecutive data points
    for (int i = 1; i < dataPoints.length; i++) {
      double? prevSpeed = _getSpeed(dataPoints[i-1]);
      double? currentSpeed = _getSpeed(dataPoints[i]);
      
      if (prevSpeed == null || currentSpeed == null) continue;
      
      // Time difference in seconds
      double timeDiff = dataPoints[i].timestamp.difference(dataPoints[i-1].timestamp).inMilliseconds / 1000;
      if (timeDiff <= 0) continue;
      
      // Calculate acceleration in km/h/s
      double acceleration = (currentSpeed - prevSpeed) / timeDiff;
      accelerationValues.add(acceleration);
      
      // Adjust threshold based on slope if available
      double adjustedAccelThreshold = accelerationThreshold;
      double adjustedBrakingThreshold = brakingThreshold;
      
      if (dataPoints[i].contextData?.slope != null) {
        double slope = dataPoints[i].contextData!.slope!;
        adjustedAccelThreshold += slope * slopeAdjustmentFactor;
        adjustedBrakingThreshold -= slope * slopeAdjustmentFactor;
      }
      
      // Check for aggressive acceleration
      if (acceleration > adjustedAccelThreshold && prevSpeed > 30) { // Above 30 km/h as per research
        aggressiveAccelerations++;
      }
      
      // Check for aggressive braking (negative acceleration)
      if (acceleration < -adjustedBrakingThreshold) {
        aggressiveBrakings++;
      }
    }
    
    // Calculate the percentage of aggressive events
    int totalEvents = dataPoints.length - 1;
    double aggressivePercentage = (aggressiveAccelerations + aggressiveBrakings) / totalEvents;
    
    // Determine severity - higher percentage means higher severity
    double severity = min(aggressivePercentage * 3, 1.0); // Scale it to 0-1 range
    
    // Aggressive driving is detected if severity exceeds 0.2 (i.e., >6.7% of events are aggressive)
    bool isAggressive = severity > 0.2;
    
    return BehaviorDetectionResult(
      detected: isAggressive,
      confidence: confidence,
      severity: severity,
      message: isAggressive 
          ? 'Aggressive driving detected: ${(severity * 100).toStringAsFixed(1)}% aggressive events'
          : 'Calm driving pattern detected',
      additionalData: {
        'aggressiveAccelerations': aggressiveAccelerations,
        'aggressiveBrakings': aggressiveBrakings,
        'totalEvents': totalEvents,
        'accelerationValues': accelerationValues,
      },
    );
  }
  
  // Helper to get speed from best available source
  double? _getSpeed(CombinedDrivingData data) {
    return data.obdData?.vehicleSpeed ?? data.sensorData?.gpsSpeed;
  }
} 