import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects frequent stops and starts
class StopManagementDetector extends BehaviorDetector {
  final double stopSpeedThreshold; // km/h, speed below which is considered a stop
  final double minDistanceBetweenStopsKm; // Minimum distance between stops to be considered separate stops
  
  StopManagementDetector({
    this.stopSpeedThreshold = 3.0, // 3 km/h threshold for a stop
    this.minDistanceBetweenStopsKm = 0.5, // 500m minimum between stops
  });
  
  @override
  int get minimumDataPoints => 20; // Need sufficient data to evaluate stop patterns
  
  @override
  List<String> get requiredDataFields => [
    'obdData.vehicleSpeed',
    'sensorData.gpsSpeed',
    'sensorData.latitude',
    'sensorData.longitude',
  ];
  
  @override
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints) {
    if (dataPoints.isEmpty) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.0,
        message: 'No data available for stop pattern analysis',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    // Sort data points by timestamp
    dataPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    List<StopEvent> stopEvents = [];
    bool inStopState = false;
    CombinedDrivingData? stopStartData;
    
    // Identify all stops in the data
    for (int i = 0; i < dataPoints.length; i++) {
      var data = dataPoints[i];
      double? speed = _getSpeed(data);
      
      if (speed == null) continue;
      
      bool isStopped = speed < stopSpeedThreshold;
      
      // Transition from moving to stopped
      if (!inStopState && isStopped) {
        inStopState = true;
        stopStartData = data;
      }
      // Transition from stopped to moving
      else if (inStopState && !isStopped) {
        if (stopStartData != null) {
          stopEvents.add(StopEvent(
            startTime: stopStartData.timestamp,
            endTime: data.timestamp,
            duration: data.timestamp.difference(stopStartData.timestamp),
            latitude: data.sensorData?.latitude,
            longitude: data.sensorData?.longitude,
          ));
        }
        
        inStopState = false;
        stopStartData = null;
      }
    }
    
    // Check for an ongoing stop at the end of the data
    if (inStopState && stopStartData != null) {
      var lastData = dataPoints.last;
      stopEvents.add(StopEvent(
        startTime: stopStartData.timestamp,
        endTime: lastData.timestamp,
        duration: lastData.timestamp.difference(stopStartData.timestamp),
        latitude: lastData.sensorData?.latitude,
        longitude: lastData.sensorData?.longitude,
      ));
    }
    
    // Filter out very brief stops (less than 3 seconds) as they might be data noise
    stopEvents = stopEvents.where((event) => event.duration.inSeconds >= 3).toList();
    
    // Calculate trip distance and time
    double? totalDistanceKm = _calculateTripDistance(dataPoints);
    Duration totalTime = dataPoints.isEmpty 
        ? Duration.zero 
        : dataPoints.last.timestamp.difference(dataPoints.first.timestamp);
    
    // Calculate stops per km and stops per minute
    double stopsPerKm = totalDistanceKm != null && totalDistanceKm > 0
        ? stopEvents.length / totalDistanceKm
        : 0;
    
    double stopsPerMinute = totalTime.inMinutes > 0
        ? stopEvents.length / (totalTime.inMinutes)
        : 0;
    
    // Determine severity based on stop frequency
    // Stops per km is more relevant for eco-driving
    double severity = min(stopsPerKm / 2, 1.0); // Over 2 stops/km is maximum severity
    
    // Frequent stops detected if more than 1 stop per km
    bool isDetected = stopsPerKm > 1.0;
    
    return BehaviorDetectionResult(
      detected: isDetected,
      confidence: confidence,
      severity: severity,
      message: isDetected
          ? 'Frequent stops detected: ${stopsPerKm.toStringAsFixed(1)} stops per km'
          : 'Stop frequency is acceptable: ${stopsPerKm.toStringAsFixed(1)} stops per km',
      additionalData: {
        'totalStops': stopEvents.length,
        'stopsPerKm': stopsPerKm,
        'stopsPerMinute': stopsPerMinute,
        'totalDistanceKm': totalDistanceKm,
        'totalTimeMinutes': totalTime.inMinutes,
      },
    );
  }
  
  // Helper to get speed from best available source
  double? _getSpeed(CombinedDrivingData data) {
    return data.obdData?.vehicleSpeed ?? data.sensorData?.gpsSpeed;
  }
  
  // Calculate trip distance using GPS coordinates if available
  double? _calculateTripDistance(List<CombinedDrivingData> dataPoints) {
    double totalDistance = 0.0;
    
    // Use GPS coordinates if available
    bool hasGpsData = false;
    for (int i = 1; i < dataPoints.length; i++) {
      double? lat1 = dataPoints[i-1].sensorData?.latitude;
      double? lon1 = dataPoints[i-1].sensorData?.longitude;
      double? lat2 = dataPoints[i].sensorData?.latitude;
      double? lon2 = dataPoints[i].sensorData?.longitude;
      
      if (lat1 != null && lon1 != null && lat2 != null && lon2 != null) {
        totalDistance += _calculateHaversineDistance(lat1, lon1, lat2, lon2);
        hasGpsData = true;
      }
    }
    
    // If no GPS data, try to use speed data to estimate distance
    if (!hasGpsData) {
      totalDistance = 0.0;
      for (int i = 1; i < dataPoints.length; i++) {
        double? speed = _getSpeed(dataPoints[i-1]);
        if (speed != null) {
          // Convert speed from km/h to km/s
          double speedKmS = speed / 3600;
          // Time difference in seconds
          double timeDiff = dataPoints[i].timestamp.difference(dataPoints[i-1].timestamp).inMilliseconds / 1000;
          // Distance = speed * time
          totalDistance += speedKmS * timeDiff;
        } else {
          // If we don't have speed data, we can't calculate distance
          return null;
        }
      }
    }
    
    return totalDistance;
  }
  
  // Calculate haversine distance between two points
  double _calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    
    // Convert to radians
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
               cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
               sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}

/// Helper class for stop events
class StopEvent {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final double? latitude;
  final double? longitude;
  
  StopEvent({
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.latitude,
    this.longitude,
  });
} 