/// Represents a decoded OBD-II data response
class ObdData {
  /// The command mode (e.g., '01' for current data)
  final String mode;
  
  /// The Parameter ID (PID) for the response
  final String pid;
  
  /// The raw response bytes
  final List<int> rawData;
  
  /// Human-readable name of the data
  final String name;
  
  /// Decoded value
  final dynamic value;
  
  /// Unit of measurement (e.g., 'km/h', '°C')
  final String unit;
  
  /// Timestamp when the data was received
  final DateTime timestamp;

  /// Creates a new OBD-II data instance
  ObdData({
    required this.mode,
    required this.pid,
    required this.rawData,
    required this.name,
    required this.value,
    required this.unit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Creates a copy of this OBD data with the given fields replaced
  ObdData copyWith({
    String? mode,
    String? pid,
    List<int>? rawData,
    String? name,
    dynamic value,
    String? unit,
    DateTime? timestamp,
  }) {
    return ObdData(
      mode: mode ?? this.mode,
      pid: pid ?? this.pid,
      rawData: rawData ?? this.rawData,
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  @override
  String toString() {
    return '$name: $value $unit';
  }
} 