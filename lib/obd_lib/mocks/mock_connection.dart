import 'dart:async';
import 'dart:math';
import 'package:logging/logging.dart';

import '../interfaces/obd_connection.dart';

/// Mock OBD connection for testing
///
/// This class simulates an OBD-II connection for testing purposes
/// without requiring actual hardware.
class MockConnection implements ObdConnection {
  final Logger _logger = Logger('MockConnection');
  
  /// Stream controller for incoming data
  final _dataStreamController = StreamController<String>.broadcast();
  
  /// Whether the connection is established
  bool _isConnected = false;
  
  /// Simulated connection reliability
  final double connectionReliability;
  
  /// Simulate connection issues
  final bool simulateConnectionIssues;
  
  /// Mock responses for commands
  final Map<String, dynamic>? mockResponses;
  
  /// Index for selecting mock responses
  final Map<String, int> _responseIndex = {};
  
  /// Creates a new MockConnection
  MockConnection({
    this.connectionReliability = 1.0,
    this.simulateConnectionIssues = false,
    this.mockResponses,
  }) {
    _logger.info('Created MockConnection with reliability: $connectionReliability');
  }
  
  @override
  Stream<String> get dataStream => _dataStreamController.stream;
  
  @override
  bool get isConnected => _isConnected;
  
  @override
  Future<bool> connect() async {
    _logger.info('Connecting mock connection');
    
    // Simulate connection delay
    await Future.delayed(Duration(milliseconds: 200));
    
    // Simulate connection reliability
    if (Random().nextDouble() > connectionReliability) {
      _logger.warning('Mock connection failed (simulated failure)');
      return false;
    }
    
    _isConnected = true;
    _dataStreamController.add('CONNECTED');
    _logger.info('Mock connection successful');
    return true;
  }
  
  @override
  Future<bool> disconnect() async {
    _logger.info('Disconnecting mock connection');
    
    // Simulate disconnection delay
    await Future.delayed(Duration(milliseconds: 100));
    
    _isConnected = false;
    _dataStreamController.add('DISCONNECTED');
    _logger.info('Mock disconnection successful');
    return true;
  }
  
  @override
  Future<bool> sendCommand(String command) async {
    _logger.info('Sending mock command: $command');
    
    if (!isConnected) {
      _logger.warning('Cannot send command: mock connection not established');
      return false;
    }
    
    // Simulate connection issues if enabled
    if (simulateConnectionIssues && Random().nextDouble() > connectionReliability) {
      _logger.warning('Simulated connection issue for command: $command');
      // Don't send any response
      return false;
    }

    // Simulate command processing delay
    await Future.delayed(Duration(milliseconds: Random().nextInt(100) + 50));
    
    // Generate appropriate mock response based on the command
    String response = '';
    
    // Handle initialization commands
    if (command == 'ATZ') {
      response = 'ELM327 v1.5\r\r>';
    } else if (command == 'ATE0') {
      response = 'OK\r\r>';
    } else if (command == 'ATH0') {
      response = 'OK\r\r>';
    } else if (command == 'ATL0') {
      response = 'OK\r\r>';
    } else if (command == 'ATSP4') {
      response = 'OK\r\r>';
    } else if (command == 'ATBRD10') {
      response = 'OK\r\r>';
    } else if (command == 'ATST20') {
      response = 'OK\r\r>';
    } else if (command == 'AT@1') {
      response = 'ELM327 v1.5\r\r>';
    }
    // Handle OBD PID commands
    else if (command == '0100') {
      response = '41 00 BE 3E B8 10\r\r>';
    } else if (command == '010C') {
      response = '41 0C 0F A0\r\r>'; // ~1000 RPM
    } else if (command == '010D') {
      response = '41 0D 45\r\r>'; // ~70 km/h
    } else if (command == '0105') {
      response = '41 05 50\r\r>'; // ~40°C
    } else if (command == '0142') {
      response = '41 42 30 14\r\r>'; // ~12.3V
    } else {
      // Default response
      response = 'NO DATA\r\r>';
    }
    
    // Check if there's a mock response defined for this command
    if (mockResponses != null && mockResponses!.containsKey(command)) {
      final mockResponse = mockResponses![command];
      if (mockResponse != null) {
        // If it's a string, use it directly
        if (mockResponse is String) {
          response = mockResponse;
        }
        // If it's a list, get the next response from the list
        else if (mockResponse is List<String>) {
          if (_responseIndex.containsKey(command)) {
            final index = _responseIndex[command]!;
            if (index < mockResponse.length) {
              response = mockResponse[index];
              _responseIndex[command] = index + 1;
            }
          } else {
            if (mockResponse.isNotEmpty) {
              response = mockResponse[0];
              _responseIndex[command] = 1;
            }
          }
        }
      }
    }
    
    // Send the response
    if (response.isNotEmpty) {
      _sendResponse(response);
    }
    
    return true;
  }

  /// Send a response through the data stream
  void _sendResponse(String response) {
    if (_isConnected) {
      _dataStreamController.add(response);
    }
  }
  
  @override
  Future<void> dispose() async {
    _logger.info('Disposing mock connection');
    await disconnect();
    await _dataStreamController.close();
  }
} 