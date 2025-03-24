import 'package:going50/core_models/obd_II_data.dart';
import 'package:going50/core_models/phone_sensor_data.dart';
import 'package:going50/core_models/optional_context_data.dart';

// Combined Data Model (for algorithms)
class CombinedDrivingData {
  final DateTime timestamp;
  final OBDIIData? obdData;
  final PhoneSensorData? sensorData;
  final OptionalContextData? contextData;
  
  // Derived real-time metrics (calculated from raw data)
  final double? calculatedAcceleration; // km/h/s
  final bool? isIdling;
  final bool? isAggressive;
  final bool? isOptimalSpeed;
  final bool? isHighRPM;
  final double? estimatedFollowDistance; // seconds
  
  CombinedDrivingData({
    required this.timestamp,
    this.obdData,
    this.sensorData,
    this.contextData,
    this.calculatedAcceleration,
    this.isIdling,
    this.isAggressive,
    this.isOptimalSpeed,
    this.isHighRPM,
    this.estimatedFollowDistance,
  });
  
  // Factory constructor to combine data sources
  factory CombinedDrivingData.combine({
    required DateTime timestamp,
    OBDIIData? obdData,
    PhoneSensorData? sensorData,
    OptionalContextData? contextData,
  }) {
    // Get speed from best available source
    double? speed = obdData?.vehicleSpeed ?? sensorData?.gpsSpeed;
    
    // Calculate acceleration (simplified - should use previous data points)
    double? calculatedAcceleration;
    
    // Determine if idling
    bool? isIdling;
    if (obdData?.engineRunning == true && (speed == null || speed < 1.0)) {
      isIdling = true;
    } else if (obdData?.engineRunning == true && speed != null && speed >= 1.0) {
      isIdling = false;
    }
    
    // Determine if speed is in optimal range (50-75 km/h)
    bool? isOptimalSpeed;
    if (speed != null) {
      isOptimalSpeed = (speed >= 50.0 && speed <= 75.0);
    }
    
    // Determine if RPM is higher than optimal
    bool? isHighRPM;
    if (obdData?.rpm != null && obdData?.vehicleSpeed != null) {
      // Simplified logic - actual implementation would need gear ratios
      double rpmPerSpeed = obdData!.rpm! / obdData.vehicleSpeed!;
      isHighRPM = rpmPerSpeed > 70; // Arbitrary threshold, needs calibration
    }
    
    return CombinedDrivingData(
      timestamp: timestamp,
      obdData: obdData,
      sensorData: sensorData,
      contextData: contextData,
      calculatedAcceleration: calculatedAcceleration,
      isIdling: isIdling,
      isAggressive: null, // Requires calculation using previous data points
      isOptimalSpeed: isOptimalSpeed,
      isHighRPM: isHighRPM,
      estimatedFollowDistance: null, // Requires sensor data not directly available
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'obdData': obdData?.toJson(),
      'sensorData': sensorData?.toJson(),
      'contextData': contextData?.toJson(),
      'calculatedAcceleration': calculatedAcceleration,
      'isIdling': isIdling,
      'isAggressive': isAggressive,
      'isOptimalSpeed': isOptimalSpeed,
      'isHighRPM': isHighRPM,
      'estimatedFollowDistance': estimatedFollowDistance,
    };
  }
}
