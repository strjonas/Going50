import 'dart:async';
import '../models/obd_data.dart';
import '../models/obd_command.dart';
import 'obd_connection.dart';

/// Abstract interface for OBD-II protocol handlers
abstract class ObdProtocol {
  /// The underlying connection used by this protocol
  ObdConnection get connection;
  
  /// Whether the protocol is initialized and ready to communicate
  bool get isInitialized;
  
  /// Whether the protocol is currently connected to a device
  bool get isConnected;
  
  /// Whether the protocol is currently connecting to a device
  bool get isConnecting;
  
  /// The latest error message, if any occurred
  String? get errorMessage;
  
  /// Stream of raw response data from the OBD adapter
  Stream<String> get dataStream;
  
  /// Stream of parsed OBD data
  Stream<ObdData> get obdDataStream;
  
  /// Initialize the protocol
  /// 
  /// This method should be called after establishing a connection.
  /// Returns true if initialization was successful.
  Future<bool> initialize();
  
  /// Send a raw command to the OBD adapter
  /// 
  /// Returns the raw response from the OBD adapter.
  Future<String> sendCommand(String command);
  
  /// Send an OBD command to the OBD adapter
  /// 
  /// Returns the raw response from the OBD adapter.
  Future<String> sendObdCommand(ObdCommand command);
  
  /// Request data for a specific PID
  /// 
  /// Returns the parsed OBD data.
  Future<ObdData?> requestPid(String pid);
  
  /// Request data for a list of PIDs
  /// 
  /// Returns a map of PID to parsed OBD data.
  Future<Map<String, ObdData>> requestPids(List<String> pids);
  
  /// Dispose of any resources used by the protocol
  void dispose();
} 