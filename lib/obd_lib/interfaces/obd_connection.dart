import 'dart:async';

/// Abstract interface for OBD-II connections
abstract class ObdConnection {
  /// Stream of incoming data from the connection
  Stream<String> get dataStream;
  
  /// Whether the connection is active
  bool get isConnected;
  
  /// Connects to the specified OBD-II device
  Future<bool> connect();
  
  /// Disconnects from the OBD-II device
  Future<void> disconnect();
  
  /// Sends a command to the OBD-II device
  Future<void> sendCommand(String command);
  
  /// Disposes of the connection resources
  Future<void> dispose();
} 