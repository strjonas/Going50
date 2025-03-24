/// Represents a Bluetooth device that can be used for OBD-II communication
class BluetoothDevice {
  /// Unique identifier of the device
  final String id;
  
  /// Human-readable name of the device
  final String name;
  
  /// Signal strength indicator (RSSI)
  final int? rssi;
  
  /// Whether the device is connectable
  final bool isConnectable;
  
  /// Creates a new Bluetooth device
  const BluetoothDevice({
    required this.id,
    required this.name,
    this.rssi,
    this.isConnectable = true,
  });
  
  @override
  String toString() => '$name ($id)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDevice && runtimeType == other.runtimeType && id == other.id;
  
  @override
  int get hashCode => id.hashCode;
} 