import 'dart:async';
import '../interfaces/obd_connection.dart';

/// A mock implementation of ObdConnection for testing
class MockBluetoothConnection implements ObdConnection {
  /// Internal controller for the data stream
  final StreamController<String> _dataStreamController;
  
  /// Connection status
  bool _isConnected = false;
  
  /// List of predefined responses for testing
  final Map<String, String> _commandResponses = {};
  
  /// Delay to simulate realistic response timing
  final Duration _responseDelay;
  
  /// Create a mock Bluetooth connection
  MockBluetoothConnection({
    Duration? responseDelay,
    Map<String, String>? commandResponses,
    bool createFreshController = true,
  }) : 
    _responseDelay = responseDelay ?? const Duration(milliseconds: 50),
    _dataStreamController = StreamController<String>.broadcast() {
    
    // Add any predefined responses
    if (commandResponses != null) {
      _commandResponses.addAll(commandResponses);
    }
    
    // Add default responses for common commands if not provided
    _commandResponses.putIfAbsent('ATZ', () => 'ELM327 v1.5\r\n>');
  }
  
  @override
  Stream<String> get dataStream => _dataStreamController.stream;
  
  @override
  bool get isConnected => _isConnected;
  
  @override
  Future<bool> connect() async {
    if (_dataStreamController.isClosed) {
      return false;
    }
    
    // Simulate connection delay
    await Future.delayed(const Duration(milliseconds: 20));
    _isConnected = true;
    
    // Add the CONNECTED message
    try {
      if (!_dataStreamController.isClosed) {
        _dataStreamController.add('CONNECTED');
        
        // Give a small delay to ensure the CONNECTED message is processed
        await Future.delayed(const Duration(milliseconds: 10));
      }
    } catch (e) {
      // Ignore if stream is closed
      print('Warning: Could not add to stream: $e');
      return false;
    }
    
    return true;
  }
  
  @override
  Future<void> disconnect() async {
    _isConnected = false;
    if (!_dataStreamController.isClosed) {
      try {
        _dataStreamController.add('DISCONNECTED');
      } catch (e) {
        print('Warning: Could not add DISCONNECTED to stream: $e');
      }
    }
  }
  
  @override
  Future<void> sendCommand(String command) async {
    if (!_isConnected || _dataStreamController.isClosed) {
      return;
    }
    
    // Simulate command processing delay
    await Future.delayed(_responseDelay);
    
    try {
      // Return predefined response if available
      if (_commandResponses.containsKey(command)) {
        final response = _commandResponses[command]!;
        _dataStreamController.add(response);
        return;
      }
      
      // Generate a default response based on the command
      String response = _generateDefaultResponse(command);
      _dataStreamController.add(response);
    } catch (e) {
      print('Warning: Could not send command response: $e');
    }
  }
  
  @override
  Future<void> dispose() async {
    _isConnected = false;
    // Only close the stream if it's not already closed
    if (!_dataStreamController.isClosed) {
      await _dataStreamController.close();
    }
  }
  
  /// Add a command response mapping
  void addCommandResponse(String command, String response) {
    _commandResponses[command] = response;
  }
  
  /// Simulate sending a response directly to the stream
  void simulateResponse(String response) {
    if (!_dataStreamController.isClosed) {
      try {
        _dataStreamController.add(response);
      } catch (e) {
        print('Warning: Could not simulate response: $e');
      }
    }
  }
  
  /// Generate a default response for a command if no predefined response exists
  String _generateDefaultResponse(String command) {
    // Handle standard ELM327 commands
    if (command == 'ATZ') {
      return 'ELM327 v1.5\r\n>';
    } else if (command == 'ATE0') {
      return 'OK\r\n>';
    } else if (command == 'ATL0') {
      return 'OK\r\n>';
    } else if (command == 'ATH0') {
      return 'OK\r\n>';
    } else if (command == 'ATSP0') {
      return 'OK\r\n>';
    } else if (command == 'ATAT1') {
      return 'OK\r\n>';
    } else if (command == 'ATST64') {
      return 'OK\r\n>';
    } else if (command.startsWith('01')) {
      // Generate OBD-II mode 01 responses
      if (command == '0100') {
        // Supported PIDs
        return '41 00 98 3F 80 10\r\n>';
      } else if (command == '010C') {
        // Engine RPM (1500 RPM)
        return '41 0C 12 00\r\n>'; 
      } else if (command == '010D') {
        // Vehicle speed (50 km/h)
        return '41 0D 32\r\n>';
      } else if (command == '0105') {
        // Coolant temperature (90°C)
        return '41 05 5A\r\n>';
      } else if (command == '0111') {
        // Throttle position (25%)
        return '41 11 40\r\n>';
      } else {
        // Unknown PID
        return 'NO DATA\r\n>';
      }
    } else {
      // Unknown command
      return '?\r\n>';
    }
  }
} 