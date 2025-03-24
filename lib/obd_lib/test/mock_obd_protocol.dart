import 'dart:async';

import '../interfaces/obd_connection.dart';
import '../protocol/obd_protocol.dart';
import '../models/obd_command.dart';
import '../models/obd_data.dart';

/// A mock implementation of ObdProtocol for testing
class MockObdProtocol implements ObdProtocol {
  /// The connection used by this protocol
  final ObdConnection? connection;
  
  /// Whether the protocol has been initialized
  bool _isInitialized = false;
  
  /// Whether the protocol is connected
  bool _isConnected = false;
  
  /// Whether the protocol is connecting
  bool _isConnecting = false;
  
  /// Error message if initialization fails
  String? _errorMessage;
  
  /// Stream controller for OBD data
  final _dataStreamController = StreamController<ObdData>.broadcast();
  
  /// Map of predefined responses by PID
  final Map<String, ObdData> _pidResponses = {};
  
  /// Map of predefined raw responses
  final Map<String, String> _commandResponses = {};
  
  /// Subscription to connection data stream
  StreamSubscription? _connectionSubscription;
  
  /// Last received response from the connection
  String _lastResponse = '';
  
  /// Completer for the current command
  Completer<String>? _currentCommandCompleter;
  
  /// Create a new mock protocol instance
  MockObdProtocol({
    this.connection,
    Map<String, ObdData>? pidResponses,
    Map<String, String>? commandResponses,
  }) {
    // Add any predefined PID responses
    if (pidResponses != null) {
      _pidResponses.addAll(pidResponses);
    }
    
    // Add any predefined command responses
    if (commandResponses != null) {
      _commandResponses.addAll(commandResponses);
    }
    
    // Subscribe to connection data if available
    if (connection != null) {
      _connectionSubscription = connection!.dataStream.listen(_handleConnectionData);
    }
  }
  
  /// Handle incoming data from the connection
  void _handleConnectionData(String data) {
    _lastResponse = data;
    
    // If there's a pending command, complete it with the response
    if (_currentCommandCompleter != null && !_currentCommandCompleter!.isCompleted) {
      _currentCommandCompleter!.complete(data);
    }
  }
  
  @override
  Stream<ObdData> get obdDataStream => _dataStreamController.stream;
  
  @override
  Stream<String> get dataStream => connection?.dataStream ?? 
      Stream<String>.empty();
  
  @override
  bool get isConnected => _isConnected;
  
  @override
  bool get isConnecting => _isConnecting;
  
  @override
  bool get isInitialized => _isInitialized;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  Future<bool> initialize() async {
    _isConnecting = true;
    // Simulate initialization delay
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
    _isConnected = true;
    _isConnecting = false;
    return true;
  }
  
  @override
  Future<String> sendCommand(String command) async {
    if (!_isConnected) {
      return 'ERROR: Not connected';
    }
    
    // Return predefined response if available
    if (_commandResponses.containsKey(command)) {
      return _commandResponses[command]!;
    }
    
    // Use the connection if available
    if (connection != null) {
      try {
        // Create a completer for this command
        _currentCommandCompleter = Completer<String>();
        
        // Send the command (which will return void)
        await connection!.sendCommand(command);
        
        // Wait for a response with timeout
        final response = await _currentCommandCompleter!.future
            .timeout(const Duration(seconds: 2), 
              onTimeout: () => 'ERROR: Timeout waiting for response');
        
        return response;
      } catch (e) {
        return 'ERROR: $e';
      }
    }
    
    // Default response
    if (command.startsWith('AT')) {
      return 'OK\r\n>';
    } else {
      return 'NO DATA\r\n>';
    }
  }
  
  @override
  Future<String> sendObdCommand(ObdCommand command) async {
    final response = await sendCommand(command.command);
    return response;
  }
  
  @override
  Future<ObdData?> requestPid(String pid) async {
    if (!_isConnected) {
      return null;
    }
    
    // Return predefined response if available
    if (_pidResponses.containsKey(pid)) {
      final data = _pidResponses[pid]!;
      _dataStreamController.add(data);
      return data;
    }
    
    // Generate a basic response for common PIDs
    final defaultData = _generateDefaultPidResponse(pid);
    if (defaultData != null) {
      _dataStreamController.add(defaultData);
    }
    
    return defaultData;
  }
  
  @override
  Future<Map<String, ObdData>> requestPids(List<String> pids) async {
    if (!_isConnected) {
      return {};
    }
    
    final results = <String, ObdData>{};
    
    for (final pid in pids) {
      final data = await requestPid(pid);
      if (data != null) {
        results[pid] = data;
      }
    }
    
    return results;
  }
  
  @override
  Future<void> dispose() async {
    _isConnected = false;
    await _connectionSubscription?.cancel();
    await _dataStreamController.close();
    
    // Don't dispose the connection, it's managed externally
  }
  
  /// Add a PID response for testing
  void addPidResponse(String pid, ObdData data) {
    _pidResponses[pid] = data;
  }
  
  /// Add a command response for testing
  void addCommandResponse(String command, String response) {
    _commandResponses[command] = response;
  }
  
  /// Simulate a data response coming from the adapter
  void simulateDataResponse(ObdData data) {
    if (_isConnected) {
      _dataStreamController.add(data);
    }
  }
  
  /// Set the initialized state for testing
  void setInitialized(bool initialized) {
    _isInitialized = initialized;
  }
  
  /// Set the connected state for testing
  void setConnected(bool connected) {
    _isConnected = connected;
  }
  
  /// Convert a hexadecimal string to a list of integers
  List<int> _hexStringToBytes(String hexString) {
    final cleanHex = hexString.replaceAll(' ', '');
    final bytes = <int>[];
    for (var i = 0; i < cleanHex.length; i += 2) {
      if (i + 2 <= cleanHex.length) {
        bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
      }
    }
    return bytes;
  }
  
  /// Generate a default response for common PIDs
  ObdData? _generateDefaultPidResponse(String pid) {
    final timestamp = DateTime.now();
    
    // Handle common PIDs
    switch (pid) {
      case '0100': // Supported PIDs 01-20
        return ObdData(
          pid: pid,
          mode: '01',
          value: 'BE1FA813', // Example supported PIDs bitstring
          unit: '',
          timestamp: timestamp,
          rawData: _hexStringToBytes('4100BE1FA813'),
          name: 'Supported PIDs 01-20'
        );
        
      case '010C': // Engine RPM
        return ObdData(
          pid: pid,
          mode: '01',
          value: 1500, // 1500 RPM
          unit: 'rpm',
          timestamp: timestamp,
          rawData: _hexStringToBytes('410C12C0'),
          name: 'Engine RPM'
        );
        
      case '010D': // Vehicle speed
        return ObdData(
          pid: pid,
          mode: '01',
          value: 50, // 50 km/h
          unit: 'km/h',
          timestamp: timestamp,
          rawData: _hexStringToBytes('410D32'),
          name: 'Vehicle Speed'
        );
        
      case '0105': // Coolant temperature
        return ObdData(
          pid: pid,
          mode: '01',
          value: 90, // 90°C
          unit: '°C',
          timestamp: timestamp,
          rawData: _hexStringToBytes('41055A'),
          name: 'Engine Coolant Temperature'
        );
        
      case '0111': // Throttle position
        return ObdData(
          pid: pid,
          mode: '01',
          value: 25.0, // 25%
          unit: '%',
          timestamp: timestamp,
          rawData: _hexStringToBytes('411140'),
          name: 'Throttle Position'
        );
        
      case '0142': // Control module voltage
        return ObdData(
          pid: pid,
          mode: '01',
          value: 14.2, // 14.2V
          unit: 'V',
          timestamp: timestamp,
          rawData: _hexStringToBytes('41428E'),
          name: 'Control Module Voltage'
        );
        
      default:
        return null;
    }
  }
} 