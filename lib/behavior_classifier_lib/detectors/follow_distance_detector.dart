import 'dart:math';

import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/behavior_classifier_lib/interfaces/behavior_detector.dart';

/// Detects unsafe following distance
class FollowDistanceDetector extends BehaviorDetector {
  final double minSafeFollowTimeSeconds; // Minimum safe following distance in seconds
  final double brakeDetectionThreshold; // m/s², threshold for significant braking
  
  FollowDistanceDetector({
    this.minSafeFollowTimeSeconds = 2.0, // 2 seconds minimum following distance
    this.brakeDetectionThreshold = 3.0, // 3 m/s² = moderate braking
  });
  
  @override
  int get minimumDataPoints => 30; // Need sufficient data to evaluate following patterns
  
  @override
  List<String> get requiredDataFields => [
    'obdData.vehicleSpeed',
    'sensorData.accelerationX',
    'sensorData.accelerationY',
    'sensorData.accelerationZ',
  ];
  
  @override
  BehaviorDetectionResult detectBehavior(List<CombinedDrivingData> dataPoints) {
    if (dataPoints.isEmpty) {
      return BehaviorDetectionResult(
        detected: false,
        confidence: 0.0,
        message: 'No data available for following distance analysis',
      );
    }
    
    // Calculate confidence based on available data
    double confidence = calculateConfidence(dataPoints);
    
    // Following distance can't be directly measured without radar/camera data
    // We'll use a proxy: sudden braking events, which often occur when following too closely
    
    // If we don't have the car's radar/distance sensor data (most cars won't expose this),
    // we significantly reduce confidence
    bool hasRadarData = dataPoints.any((d) => d.estimatedFollowDistance != null);
    
    if (!hasRadarData) {
      // Significantly reduce confidence since we're using a proxy
      confidence *= 0.4;
    }
    
    // Sort data points by timestamp
    dataPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    int suddenBrakingEvents = 0;
    List<DateTime> brakingEventTimes = [];
    
    // Look for sudden deceleration events
    for (int i = 1; i < dataPoints.length; i++) {
      double? prevSpeed = _getSpeed(dataPoints[i-1]);
      double? currentSpeed = _getSpeed(dataPoints[i]);
      
      if (prevSpeed == null || currentSpeed == null) continue;
      
      // Time difference in seconds
      double timeDiff = dataPoints[i].timestamp.difference(dataPoints[i-1].timestamp).inMilliseconds / 1000;
      if (timeDiff <= 0) continue;
      
      // Calculate deceleration in m/s²
      // Convert km/h to m/s by multiplying by 1000/3600
      double deceleration = ((prevSpeed - currentSpeed) * 1000 / 3600) / timeDiff;
      
      // Check for sudden braking (high deceleration)
      if (deceleration > brakeDetectionThreshold) {
        // Verify with accelerometer data if available
        bool confirmedWithAccelerometer = false;
        
        if (dataPoints[i].sensorData?.accelerationX != null) {
          // Forward deceleration is typically negative in the X direction
          // (assuming phone is mounted with screen facing driver and top pointing forward)
          double? accelX = dataPoints[i].sensorData?.accelerationX;
          if (accelX != null && accelX < -brakeDetectionThreshold) {
            confirmedWithAccelerometer = true;
          }
        }
        
        // If we have accelerometer data but it doesn't confirm braking, skip this event
        if (dataPoints[i].sensorData?.accelerationX != null && !confirmedWithAccelerometer) {
          continue;
        }
        
        suddenBrakingEvents++;
        brakingEventTimes.add(dataPoints[i].timestamp);
      }
    }
    
    // Check for clusters of braking events (indicating stop-and-go traffic)
    // which would reduce confidence since braking is expected in such conditions
    List<List<DateTime>> brakingClusters = _identifyBrakingClusters(brakingEventTimes);
    int clusteredEvents = brakingClusters.fold(0, (sum, cluster) => sum + cluster.length);
    
    // Calculate what percentage of braking events were part of clusters
    double clusterPercentage = suddenBrakingEvents > 0 
        ? clusteredEvents / suddenBrakingEvents 
        : 0.0;
    
    // Reduce confidence if many braking events are clustered (likely traffic)
    confidence *= (1.0 - clusterPercentage * 0.5);
    
    // Calculate trip distance and time
    double? totalDistanceKm = _calculateTripDistance(dataPoints);
    Duration totalTime = dataPoints.isEmpty 
        ? Duration.zero 
        : dataPoints.last.timestamp.difference(dataPoints.first.timestamp);
    
    // Calculate braking events per km and per minute
    double eventsPerKm = totalDistanceKm != null && totalDistanceKm > 0
        ? suddenBrakingEvents / totalDistanceKm
        : 0;
    
    double eventsPerMinute = totalTime.inMinutes > 0
        ? suddenBrakingEvents / (totalTime.inMinutes)
        : 0;
    
    // Determine severity based on braking frequency
    double severity = min(eventsPerKm, 1.0); // Over 1 event/km is maximum severity
    
    // Frequent sudden braking (proxy for close following) detected if more than 0.5 events per km
    bool isDetected = eventsPerKm > 0.5;
    
    return BehaviorDetectionResult(
      detected: isDetected,
      confidence: confidence,
      severity: severity,
      message: isDetected
          ? 'Frequent hard braking detected: may indicate following too closely'
          : 'Following distance appears adequate based on braking patterns',
      additionalData: {
        'suddenBrakingEvents': suddenBrakingEvents,
        'brakingEventsPerKm': eventsPerKm,
        'brakingEventsPerMinute': eventsPerMinute,
        'brakingClusters': brakingClusters.length,
        'totalDistanceKm': totalDistanceKm,
        'confidenceNote': hasRadarData 
            ? 'Based on direct distance measurements' 
            : 'Inferred from braking patterns (lower confidence)',
      },
    );
  }
  
  // Helper to get speed from best available source
  double? _getSpeed(CombinedDrivingData data) {
    return data.obdData?.vehicleSpeed ?? data.sensorData?.gpsSpeed;
  }
  
  // Identify clusters of braking events (likely indicating traffic)
  List<List<DateTime>> _identifyBrakingClusters(List<DateTime> eventTimes) {
    if (eventTimes.isEmpty) return [];
    
    List<List<DateTime>> clusters = [];
    List<DateTime> currentCluster = [eventTimes.first];
    
    for (int i = 1; i < eventTimes.length; i++) {
      // If this event is close to the previous one (within 30 seconds),
      // add it to the current cluster
      if (eventTimes[i].difference(eventTimes[i-1]).inSeconds < 30) {
        currentCluster.add(eventTimes[i]);
      } else {
        // Otherwise, start a new cluster
        if (currentCluster.length > 1) {
          clusters.add(List.from(currentCluster));
        }
        currentCluster = [eventTimes[i]];
      }
    }
    
    // Add the last cluster if it has more than one event
    if (currentCluster.length > 1) {
      clusters.add(currentCluster);
    }
    
    return clusters;
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