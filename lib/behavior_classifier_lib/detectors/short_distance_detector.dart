import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects short trips that are inefficient
class ShortDistanceDetector extends BehaviorDetector {
  final double shortTripThresholdKm; // Threshold for short trip classification
  final double engineWarmupTimeMinutes; // Estimated time for engine to warm up
  
  ShortDistanceDetector({
    this.shortTripThresholdKm = 3.0, // Trips under 3 km considered short
    this.engineWarmupTimeMinutes = 5.0, // Engine needs ~5 min to warm up
  });
  
  @override
  int get minimumDataPoints => 5; // Need enough data points to determine trip characteristics
  
  @override
  List<String> get requiredDataFields => [
    'obdData.vehicleSpeed',
    'obdData.engineTemp',
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
        message: 'No data available for trip analysis',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    // Sort data points by timestamp
    dataPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    // Analyze the trip
    double? distanceKm = _calculateTripDistance(dataPoints);
    Duration tripDuration = dataPoints.last.timestamp.difference(dataPoints.first.timestamp);
    
    // Get engine temperature data if available
    double? startTemp = _getEngineTemp(dataPoints.first);
    double? endTemp = _getEngineTemp(dataPoints.last);
    bool coldStart = startTemp != null && startTemp < 60; // Example threshold for cold engine
    
    // If we can't calculate distance, try using time as a proxy
    if (distanceKm == null) {
      // Lower confidence since we're estimating
      confidence *= 0.7;
      
      // Estimate distance based on time and assumed average speed
      double avgSpeed = 30.0; // km/h, conservative urban average
      distanceKm = tripDuration.inSeconds * (avgSpeed / 3600);
    }
    
    // Determine severity based on how short the trip is and if it was a cold start
    double distanceFactor = distanceKm < shortTripThresholdKm 
        ? 1.0 - (distanceKm / shortTripThresholdKm) 
        : 0.0;
    
    // Cold starts are worse for short trips
    double severity = distanceFactor;
    if (coldStart) {
      severity = min(severity * 1.5, 1.0);
    }
    
    // Short trip detected if distance is under threshold
    bool isShortTrip = distanceKm < shortTripThresholdKm;
    
    return BehaviorDetectionResult(
      detected: isShortTrip,
      confidence: confidence,
      severity: severity,
      message: isShortTrip
          ? 'Short trip detected: ${distanceKm.toStringAsFixed(1)} km${coldStart ? ' with cold engine' : ''}'
          : 'Trip length is efficient: ${distanceKm.toStringAsFixed(1)} km',
      additionalData: {
        'distanceKm': distanceKm,
        'durationMinutes': tripDuration.inMinutes,
        'coldStart': coldStart,
        'startTemperature': startTemp,
        'endTemperature': endTemp,
      },
    );
  }
  
  // Helper to get engine temperature
  double? _getEngineTemp(CombinedDrivingData data) {
    return data.obdData?.engineTemp;
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
  
  // Helper to get speed from best available source
  double? _getSpeed(CombinedDrivingData data) {
    return data.obdData?.vehicleSpeed ?? data.sensorData?.gpsSpeed;
  }
} 