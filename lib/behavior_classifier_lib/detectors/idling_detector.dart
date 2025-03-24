import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects engine idling behavior
class IdlingDetector extends BehaviorDetector {
  final int idlingThresholdSeconds; // Seconds of idling to be considered wasteful
  final double maxSpeedForIdling; // km/h, maximum speed to be considered idling
  
  IdlingDetector({
    this.idlingThresholdSeconds = 30, // 30 seconds as per research
    this.maxSpeedForIdling = 1.0, // 1 km/h to account for GPS/speed reading fluctuations
  });
  
  @override
  int get minimumDataPoints => 5; // Need several consecutive points to detect idling
  
  @override
  List<String> get requiredDataFields => [
    'obdData.engineRunning',
    'obdData.vehicleSpeed',
    'obdData.rpm',
    'sensorData.gpsSpeed',
  ];
  
  @override
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints) {
    if (dataPoints.isEmpty) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.0,
        message: 'No data available for idling analysis',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    // Sort data points by timestamp
    dataPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    List<IdlingEvent> idlingEvents = [];
    DateTime? idlingStartTime;
    CombinedDrivingData? idlingStartData;
    
    for (int i = 0; i < dataPoints.length; i++) {
      var data = dataPoints[i];
      
      // Check if engine is running and speed is near zero
      bool isIdling = _isIdlingState(data);
      
      if (isIdling) {
        // Start tracking a new idling event
        if (idlingStartTime == null) {
          idlingStartTime = data.timestamp;
          idlingStartData = data;
        }
      } else {
        // End the current idling event if one was in progress
        if (idlingStartTime != null) {
          Duration idlingDuration = data.timestamp.difference(idlingStartTime);
          
          // Only record if duration exceeds threshold
          if (idlingDuration.inSeconds >= idlingThresholdSeconds) {
            idlingEvents.add(IdlingEvent(
              startTime: idlingStartTime,
              endTime: data.timestamp,
              duration: idlingDuration,
              temperature: idlingStartData?.obdData?.engineTemp,
            ));
          }
          
          // Reset tracking
          idlingStartTime = null;
          idlingStartData = null;
        }
      }
    }
    
    // Check for an ongoing idling event at the end of the data
    if (idlingStartTime != null) {
      var lastData = dataPoints.last;
      Duration idlingDuration = lastData.timestamp.difference(idlingStartTime);
      
      if (idlingDuration.inSeconds >= idlingThresholdSeconds) {
        idlingEvents.add(IdlingEvent(
          startTime: idlingStartTime,
          endTime: lastData.timestamp,
          duration: idlingDuration,
          temperature: idlingStartData?.obdData?.engineTemp,
        ));
      }
    }
    
    // Calculate total idling time and data collection time
    Duration totalIdlingTime = Duration.zero;
    for (var event in idlingEvents) {
      totalIdlingTime += event.duration;
    }
    
    Duration totalTime = dataPoints.isEmpty 
        ? Duration.zero 
        : dataPoints.last.timestamp.difference(dataPoints.first.timestamp);
    
    // Calculate idling percentage
    double idlingPercentage = totalTime.inSeconds > 0 
        ? totalIdlingTime.inSeconds / totalTime.inSeconds 
        : 0.0;
    
    // Determine severity based on idling percentage
    double severity = min(idlingPercentage * 5, 1.0); // Scale up to make small percentages more significant
    
    // Excessive idling detected if there's at least one event over threshold
    bool isDetected = idlingEvents.isNotEmpty;
    
    return BehaviorDetectionResult(
      detected: isDetected,
      confidence: confidence,
      severity: severity,
      message: isDetected
          ? '${idlingEvents.length} idling events detected totaling ${_formatDuration(totalIdlingTime)}'
          : 'No excessive idling detected',
      additionalData: {
        'idlingEvents': idlingEvents.map((e) => {
          'startTime': e.startTime.toIso8601String(),
          'endTime': e.endTime.toIso8601String(),
          'durationSeconds': e.duration.inSeconds,
          'engineTemp': e.temperature,
        }).toList(),
        'totalIdlingTimeSeconds': totalIdlingTime.inSeconds,
        'idlingPercentage': idlingPercentage,
      },
    );
  }
  
  // Helper to format duration in mm:ss
  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Helper to determine if the current state is idling
  bool _isIdlingState(CombinedDrivingData data) {
    // Best case: OBD data with engine status and speed
    if (data.obdData?.engineRunning == true) {
      double? speed = data.obdData?.vehicleSpeed;
      if (speed != null && speed <= maxSpeedForIdling) {
        return true;
      }
    }
    
    // Alternative: Check RPM and speed
    if (data.obdData?.rpm != null && data.obdData!.rpm! > 0) {
      double? speed = data.obdData?.vehicleSpeed ?? data.sensorData?.gpsSpeed;
      if (speed != null && speed <= maxSpeedForIdling) {
        return true;
      }
    }
    
    // Fallback: Use GPS speed only
    if (data.obdData == null && data.sensorData?.gpsSpeed != null) {
      // This is less reliable, we need to infer engine state
      if (data.sensorData!.gpsSpeed! <= maxSpeedForIdling) {
        // Try to infer if engine is running using accelerometer vibration
        if (data.sensorData?.accelerationX != null && 
            data.sensorData?.accelerationY != null && 
            data.sensorData?.accelerationZ != null) {
          
          double vibration = _calculateVibration(
            data.sensorData!.accelerationX!,
            data.sensorData!.accelerationY!,
            data.sensorData!.accelerationZ!
          );
          
          // Threshold determined experimentally - vehicle vibrations cause small accelerometer fluctuations
          return vibration > 0.05;
        }
      }
    }
    
    return false;
  }
  
  // Calculate vibration magnitude from accelerometer data
  double _calculateVibration(double x, double y, double z) {
    return sqrt(x*x + y*y + z*z);
  }
}

/// Helper class for idling events
class IdlingEvent {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final double? temperature; // Engine temperature if available
  
  IdlingEvent({
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.temperature,
  });
} 