
// Model for OBD-II data collection
class OBDIIData {
  final DateTime timestamp;
  final double? vehicleSpeed; // km/h
  final int? rpm; // engine RPM
  final double? throttlePosition; // %
  final bool? engineRunning; // true if engine is on
  final double? engineTemp; // Celsius
  final double? fuelRate; // L/h if available
  final double? engineLoad; // %a
  final double? mafRate; // Mass Air Flow rate g/s
  final double? relativePedalPosition; // %
  final int? gearPosition; // if available (usually only in newer cars)
  final double? distanceTraveledWithMIL; // km traveled with malfunction indicator lamp on
  final double? instantFuelEconomy; // if available (km/L)
  final double? acceleratorPedalPosition; // %
  
  OBDIIData({
    required this.timestamp,
    this.vehicleSpeed,
    this.rpm,
    this.throttlePosition,
    this.engineRunning,
    this.engineTemp,
    this.fuelRate,
    this.engineLoad,
    this.mafRate,
    this.relativePedalPosition,
    this.gearPosition,
    this.distanceTraveledWithMIL,
    this.instantFuelEconomy,
    this.acceleratorPedalPosition,
  });

  factory OBDIIData.fromJson(Map<String, dynamic> json) {
    return OBDIIData(
      timestamp: DateTime.parse(json['timestamp']),
      vehicleSpeed: json['vehicleSpeed'],
      rpm: json['rpm'],
      throttlePosition: json['throttlePosition'],
      engineRunning: json['engineRunning'],
      engineTemp: json['engineTemp'],
      fuelRate: json['fuelRate'],
      engineLoad: json['engineLoad'],
      mafRate: json['mafRate'],
      relativePedalPosition: json['relativePedalPosition'],
      gearPosition: json['gearPosition'],
      distanceTraveledWithMIL: json['distanceTraveledWithMIL'],
      instantFuelEconomy: json['instantFuelEconomy'],
      acceleratorPedalPosition: json['acceleratorPedalPosition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'vehicleSpeed': vehicleSpeed,
      'rpm': rpm,
      'throttlePosition': throttlePosition,
      'engineRunning': engineRunning,
      'engineTemp': engineTemp,
      'fuelRate': fuelRate,
      'engineLoad': engineLoad,
      'mafRate': mafRate,
      'relativePedalPosition': relativePedalPosition,
      'gearPosition': gearPosition,
      'distanceTraveledWithMIL': distanceTraveledWithMIL,
      'instantFuelEconomy': instantFuelEconomy,
      'acceleratorPedalPosition': acceleratorPedalPosition,
    };
  }
}
