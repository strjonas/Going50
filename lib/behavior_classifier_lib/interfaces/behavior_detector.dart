import 'package:going50/core_models/combined_driving_data.dart';

/// Base abstract class for all behavior detectors
abstract class BehaviorDetector {
  /// Analyzes data to detect eco-driving behavior
  /// Returns a BehaviorDetectionResult with detection status and confidence
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints);
  
  /// Returns the minimum required data points for reliable detection
  int get minimumDataPoints;
  
  /// Returns the list of required data fields for optimal detection
  List<String> get requiredDataFields;
  
  /// Calculate confidence score based on available data
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
}

/// Result of a behavior detection operation
class BehaviorDetectionResult {
  final bool detected;
  final double confidence; // 0.0 to 1.0
  final double? severity; // 0.0 to 1.0, how severe the behavior is
  final String? message;
  final Map<String, dynamic>? additionalData;
  final int occurrences; // Number of times the behavior was detected
  
  BehaviorDetectionResult({
    required this.detected,
    required this.confidence,
    this.severity,
    this.message,
    this.additionalData,
    this.occurrences = 0,
  });
  
  @override
  String toString() {
    return 'Detected: $detected, Confidence: ${(confidence * 100).toStringAsFixed(1)}%, ${severity != null ? 'Severity: ${(severity! * 100).toStringAsFixed(1)}%, ' : ''}Occurrences: $occurrences, ${message != null ? 'Message: $message' : ''}';
  }
} 