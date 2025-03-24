// Event model to track specific eco-driving events
class DrivingEvent {
  final String id;
  final String tripId;
  final DateTime timestamp;
  final String eventType; // 'idling', 'aggressive_acceleration', 'hard_braking', 'excessive_speed', etc.
  final double severity; // 0.0 to 1.0 representing event severity
  final double? magnitude; // Severity of the event (e.g., acceleration rate)
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? additionalData;
  
  DrivingEvent({
    required this.id,
    required this.tripId,
    required this.timestamp,
    required this.eventType,
    required this.severity,
    this.magnitude,
    this.latitude,
    this.longitude,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'timestamp': timestamp.toIso8601String(),
      'eventType': eventType,
      'severity': severity,
      'magnitude': magnitude,
      'latitude': latitude,
      'longitude': longitude,
      'additionalData': additionalData,
    };
  }
  
  factory DrivingEvent.fromJson(Map<String, dynamic> json) {
    return DrivingEvent(
      id: json['id'],
      tripId: json['tripId'],
      timestamp: DateTime.parse(json['timestamp']),
      eventType: json['eventType'],
      severity: json['severity'],
      magnitude: json['magnitude'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      additionalData: json['additionalData'],
    );
  }
}
