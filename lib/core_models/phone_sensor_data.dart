import 'dart:math' show sqrt;

// Model for Phone Sensor data
class PhoneSensorData {
  final DateTime timestamp;
  
  // GPS Data
  final double? latitude;
  final double? longitude;
  final double? altitude; // meters
  final double? gpsSpeed; // km/h
  final double? gpsAccuracy; // meters
  final double? gpsHeading; // degrees
  
  // Accelerometer Data
  final double? accelerationX; // m/s²
  final double? accelerationY; // m/s²
  final double? accelerationZ; // m/s²
  
  // Gyroscope Data
  final double? gyroX; // rad/s
  final double? gyroY; // rad/s
  final double? gyroZ; // rad/s
  
  // Magnetometer Data
  final double? magneticX; // µT
  final double? magneticY; // µT
  final double? magneticZ; // µT
  
  // Derived calculations
  final double? totalAcceleration; // magnitude of acceleration vector
  
  PhoneSensorData({
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.altitude,
    this.gpsSpeed,
    this.gpsAccuracy,
    this.gpsHeading,
    this.accelerationX,
    this.accelerationY,
    this.accelerationZ,
    this.gyroX,
    this.gyroY,
    this.gyroZ,
    this.magneticX,
    this.magneticY,
    this.magneticZ,
    this.totalAcceleration,
  });

  factory PhoneSensorData.fromJson(Map<String, dynamic> json) {
    return PhoneSensorData(
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      gpsSpeed: json['gpsSpeed'],
      gpsAccuracy: json['gpsAccuracy'],
      gpsHeading: json['gpsHeading'],
      accelerationX: json['accelerationX'],
      accelerationY: json['accelerationY'],
      accelerationZ: json['accelerationZ'],
      gyroX: json['gyroX'],
      gyroY: json['gyroY'],
      gyroZ: json['gyroZ'],
      magneticX: json['magneticX'],
      magneticY: json['magneticY'],
      magneticZ: json['magneticZ'],
      totalAcceleration: json['totalAcceleration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'gpsSpeed': gpsSpeed,
      'gpsAccuracy': gpsAccuracy,
      'gpsHeading': gpsHeading,
      'accelerationX': accelerationX,
      'accelerationY': accelerationY,
      'accelerationZ': accelerationZ,
      'gyroX': gyroX,
      'gyroY': gyroY,
      'gyroZ': gyroZ,
      'magneticX': magneticX,
      'magneticY': magneticY,
      'magneticZ': magneticZ,
      'totalAcceleration': totalAcceleration,
    };
  }
  
  // Calculate acceleration magnitude if x,y,z components are available
  static double? calculateTotalAcceleration(double? x, double? y, double? z) {
    if (x != null && y != null && z != null) {
      return sqrt(x * x + y * y + z * z);
    }
    return null;
  }
}
