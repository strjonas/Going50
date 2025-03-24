
// Trip model to track a single journey
class Trip {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double? distanceKm;
  final double? averageSpeedKmh;
  final double? maxSpeedKmh;
  final double? fuelUsedL; // Calculated or actual if available
  final int? idlingEvents;
  final int? aggressiveAccelerationEvents;
  final int? hardBrakingEvents;
  final int? excessiveSpeedEvents;
  final int? stopEvents;
  final double? averageRPM;
  final bool isCompleted;
  
  Trip({
    required this.id,
    required this.startTime,
    this.endTime,
    this.distanceKm,
    this.averageSpeedKmh,
    this.maxSpeedKmh,
    this.fuelUsedL,
    this.idlingEvents,
    this.aggressiveAccelerationEvents,
    this.hardBrakingEvents,
    this.excessiveSpeedEvents,
    this.stopEvents,
    this.averageRPM,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'distanceKm': distanceKm,
      'averageSpeedKmh': averageSpeedKmh,
      'maxSpeedKmh': maxSpeedKmh,
      'fuelUsedL': fuelUsedL,
      'idlingEvents': idlingEvents,
      'aggressiveAccelerationEvents': aggressiveAccelerationEvents,
      'hardBrakingEvents': hardBrakingEvents,
      'excessiveSpeedEvents': excessiveSpeedEvents,
      'stopEvents': stopEvents,
      'averageRPM': averageRPM,
      'isCompleted': isCompleted,
    };
  }
  
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      distanceKm: json['distanceKm'],
      averageSpeedKmh: json['averageSpeedKmh'],
      maxSpeedKmh: json['maxSpeedKmh'],
      fuelUsedL: json['fuelUsedL'],
      idlingEvents: json['idlingEvents'],
      aggressiveAccelerationEvents: json['aggressiveAccelerationEvents'],
      hardBrakingEvents: json['hardBrakingEvents'],
      excessiveSpeedEvents: json['excessiveSpeedEvents'],
      stopEvents: json['stopEvents'],
      averageRPM: json['averageRPM'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
  
  // Create a new Trip object with updated fields
  Trip copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    double? distanceKm,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    double? fuelUsedL,
    int? idlingEvents,
    int? aggressiveAccelerationEvents,
    int? hardBrakingEvents,
    int? excessiveSpeedEvents,
    int? stopEvents,
    double? averageRPM,
    bool? isCompleted,
  }) {
    return Trip(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      fuelUsedL: fuelUsedL ?? this.fuelUsedL,
      idlingEvents: idlingEvents ?? this.idlingEvents,
      aggressiveAccelerationEvents: aggressiveAccelerationEvents ?? this.aggressiveAccelerationEvents,
      hardBrakingEvents: hardBrakingEvents ?? this.hardBrakingEvents,
      excessiveSpeedEvents: excessiveSpeedEvents ?? this.excessiveSpeedEvents,
      stopEvents: stopEvents ?? this.stopEvents,
      averageRPM: averageRPM ?? this.averageRPM,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
