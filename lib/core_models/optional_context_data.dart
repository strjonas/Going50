
// Model for Optional External Data
class OptionalContextData {
  final DateTime timestamp;
  
  // Road & Traffic Data
  final int? speedLimit; // km/h
  final String? roadType; // highway, urban, rural
  final double? slope; // % grade
  final int? trafficDensity; // scale 1-10
  final bool? isTrafficJam;
  
  // Weather Data
  final double? temperature; // Celsius
  final double? precipitation; // mm/h
  final double? windSpeed; // km/h
  final String? weatherCondition; // clear, rain, snow, etc.
  
  // User Input
  final bool? userConfirmedDriving;
  final String? transmissionType; // manual/automatic
  
  OptionalContextData({
    required this.timestamp,
    this.speedLimit,
    this.roadType,
    this.slope,
    this.trafficDensity,
    this.isTrafficJam,
    this.temperature,
    this.precipitation,
    this.windSpeed,
    this.weatherCondition,
    this.userConfirmedDriving,
    this.transmissionType,
  });

  factory OptionalContextData.fromJson(Map<String, dynamic> json) {
    return OptionalContextData(
      timestamp: DateTime.parse(json['timestamp']),
      speedLimit: json['speedLimit'],
      roadType: json['roadType'],
      slope: json['slope'],
      trafficDensity: json['trafficDensity'],
      isTrafficJam: json['isTrafficJam'],
      temperature: json['temperature'],
      precipitation: json['precipitation'],
      windSpeed: json['windSpeed'],
      weatherCondition: json['weatherCondition'],
      userConfirmedDriving: json['userConfirmedDriving'],
      transmissionType: json['transmissionType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'speedLimit': speedLimit,
      'roadType': roadType,
      'slope': slope,
      'trafficDensity': trafficDensity,
      'isTrafficJam': isTrafficJam,
      'temperature': temperature,
      'precipitation': precipitation,
      'windSpeed': windSpeed,
      'weatherCondition': weatherCondition,
      'userConfirmedDriving': userConfirmedDriving,
      'transmissionType': transmissionType,
    };
  }
}
