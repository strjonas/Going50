import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:logging/logging.dart';

import '../interfaces/obd_connection.dart';
import '../protocol/obd_protocol.dart';
import '../protocol/obd_constants.dart';
import '../models/obd_command.dart';
import '../models/obd_data.dart';
import '../models/adapter_config.dart';
import '../models/adapter_config_factory.dart';
import 'mock_test_data.dart';

/// A mock implementation of the ELM327 protocol for testing
///
/// This class simulates the behavior of an ELM327 protocol handler,
/// providing synthetic responses based on pre-defined or recorded data.
class MockElm327Protocol implements ObdProtocol {
  static final Logger _logger = Logger('MockElm327Protocol');
  
  /// The connection being used (likely a MockConnection)
  final ObdConnection connection;
  
  /// Debug mode flag
  final bool _isDebugMode;
  
  /// Test data configuration
  final String? scenarioName;
  final Map<String, List<dynamic>>? testData;
  final bool simulateConnectionIssues;
  final double connectionReliability;
  
  /// Adapter configuration
  final AdapterConfig config;
  
  /// Protocol state
  bool _isInitialized = false;
  bool _isConnecting = false;
  String? _errorMessage;
  
  /// Data stream controller
  final _dataStreamController = StreamController<ObdData>.broadcast();
  
  /// Stream subscription for connection data
  StreamSubscription? _connectionSubscription;
  
  /// Test data provider
  late MockTestData _testDataProvider;
  
  /// Current simulation timer
  Timer? _simulationTimer;
  
  /// Creates a new MockElm327Protocol
  MockElm327Protocol(
    this.connection, {
    this.scenarioName,
    this.testData,
    this.simulateConnectionIssues = false,
    this.connectionReliability = 1.0,
    bool isDebugMode = false,
    AdapterConfig? adapterConfig,
  }) : _isDebugMode = isDebugMode,
       config = adapterConfig ?? AdapterConfigFactory.createCheapElm327Config() {
    // Initialize with appropriate test data
    _testDataProvider = MockTestData(
      scenarioName: scenarioName,
      customData: testData,
    );
    
    // Log configuration
    _logger.info('Created MockElm327Protocol with '
        'scenario: $scenarioName, '
        'simulateConnectionIssues: $simulateConnectionIssues, '
        'reliability: $connectionReliability, '
        'config: ${config.profileId}');
  }
  
  @override
  bool get isInitialized => _isInitialized;
  
  @override
  bool get isConnected => connection.isConnected && _isInitialized;
  
  @override
  bool get isConnecting => _isConnecting;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  Stream<String> get dataStream => connection.dataStream;
  
  @override
  Stream<ObdData> get obdDataStream => _dataStreamController.stream;
  
  @override
  Future<bool> initialize() async {
    _logger.info('Initializing mock protocol');
    _isConnecting = true;
    _errorMessage = null;
    
    try {
      // Simulate connection process
      if (!connection.isConnected) {
        final connected = await connection.connect();
        if (!connected) {
          _errorMessage = 'Failed to connect';
          _isConnecting = false;
          return false;
        }
      }
      
      // Simulate initialization delay
      await Future.delayed(Duration(milliseconds: 200));
      
      // Simulate a connection issue if configured
      if (simulateConnectionIssues && Random().nextDouble() > connectionReliability) {
        _errorMessage = 'Simulated connection issue during initialization';
        _isConnecting = false;
        return false;
      }
      
      // Set up listeners
      _setupDataListener();
      
      // Set up simulation timer for continuous data
      _startSimulation();
      
      _isInitialized = true;
      _isConnecting = false;
      return true;
    } catch (e) {
      _errorMessage = 'Error during initialization: $e';
      _logger.severe(_errorMessage);
      _isConnecting = false;
      return false;
    }
  }
  
  @override
  Future<void> dispose() async {
    _logger.info('Disposing mock protocol');
    
    // Stop simulation
    _stopSimulation();
    
    // Cancel subscriptions
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;
    
    // Close streams
    await _dataStreamController.close();
    
    // Disconnect
    if (connection.isConnected) {
      await connection.disconnect();
    }
    
    _isInitialized = false;
  }
  
  @override
  Future<ObdData?> requestPid(String pid) async {
    if (!isConnected) {
      _logger.warning('Cannot request data: not connected');
      return null;
    }
    
    // Simulate command processing delay
    await Future.delayed(Duration(milliseconds: 20 + Random().nextInt(30)));
    
    // Simulate connection issues if configured
    if (simulateConnectionIssues && Random().nextDouble() > connectionReliability) {
      _logger.warning('Simulated connection issue during command: $pid');
      return null;
    }
    
    // Get data from test data provider
    final data = _testDataProvider.getDataForPid(pid);
    if (data != null) {
      final obdData = ObdData(
        pid: pid,
        value: data,
        timestamp: DateTime.now(),
        mode: '01',  // Standard mode for current data
        name: _getPidName(pid),
        unit: _getPidUnit(pid),
        rawData: utf8.encode(data.toString()),  // Convert to bytes
      );
      _dataStreamController.add(obdData);
      return obdData;
    }
    
    _logger.warning('No test data available for PID: $pid');
    return null;
  }
  
  @override
  Future<Map<String, ObdData>> requestPids(List<String> pids) async {
    if (!isConnected) {
      _logger.warning('Cannot request multiple data: not connected');
      return {};
    }
    
    final results = <String, ObdData>{};
    
    // Process each PID with a small delay between them
    for (final pid in pids) {
      final data = await requestPid(pid);
      if (data != null) {
        results[pid] = data;
      }
      
      // Small delay between commands
      await Future.delayed(Duration(milliseconds: 10));
    }
    
    return results;
  }
  
  @override
  Future<String> sendCommand(String command) async {
    if (!isConnected) {
      _logger.warning('Cannot send command: not connected');
      return 'ERROR';
    }
    
    // Simulate command processing
    await Future.delayed(Duration(milliseconds: 50));
    
    // Simulate success or failure
    if (simulateConnectionIssues && Random().nextDouble() > connectionReliability) {
      return 'ERROR';
    }
    
    // For standard commands, return OK
    return 'OK';
  }
  
  @override
  Future<String> sendObdCommand(ObdCommand command) async {
    if (!isConnected) {
      _logger.warning('Cannot send OBD command: not connected');
      return 'ERROR';
    }
    
    // Simulate command processing
    await Future.delayed(Duration(milliseconds: 50));
    
    // Simulate success or failure
    if (simulateConnectionIssues && Random().nextDouble() > connectionReliability) {
      return 'ERROR';
    }
    
    // Return a simulated response based on command
    return '41 ${command.pid} 00 00';
  }
  
  /// Set up the data listener
  void _setupDataListener() {
    // Subscribe to the connection's data stream
    _connectionSubscription = connection.dataStream.listen((data) {
      if (_isDebugMode) {
        _logger.fine('Received data from connection: $data');
      }
      
      // In a real implementation, this would parse the data
      // For the mock, we'll ignore it since we're generating data directly
    });
  }
  
  /// Start the simulation timer for continuous data updates
  void _startSimulation() {
    _logger.info('Starting data simulation');
    
    // Cancel any existing timer
    _stopSimulation();
    
    // Create a new timer that generates data periodically
    // Increased from 100ms to 1000ms to make values more stable and readable
    _simulationTimer = Timer.periodic(Duration(milliseconds: 1000), (_) {
      if (isConnected) {
        _simulateDataUpdate();
      }
    });
  }
  
  /// Stop the simulation timer
  void _stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }
  
  /// Simulate a data update by generating values for common PIDs
  void _simulateDataUpdate() {
    final now = DateTime.now();
    
    // Generate data for common PIDs
    final commonPids = [
      ObdConstants.pidEngineRpm,
      ObdConstants.pidVehicleSpeed,
      ObdConstants.pidThrottlePosition,
      ObdConstants.pidCoolantTemp,
      ObdConstants.pidControlModuleVoltage,
    ];
    
    for (final pid in commonPids) {
      final value = _testDataProvider.getDataForPid(pid);
      if (value != null) {
        final obdData = ObdData(
          pid: pid,
          value: value,
          timestamp: now,
          mode: '01',  // Standard mode for current data
          name: _getPidName(pid),
          unit: _getPidUnit(pid),
          rawData: utf8.encode(value.toString()),  // Convert to bytes
        );
        _dataStreamController.add(obdData);
      }
    }
  }
  
  /// Get a human-readable name for a PID
  String _getPidName(String pid) {
    switch (pid) {
      case ObdConstants.pidEngineRpm:
        return 'Engine RPM';
      case ObdConstants.pidVehicleSpeed:
        return 'Vehicle Speed';
      case ObdConstants.pidThrottlePosition:
        return 'Throttle Position';
      case ObdConstants.pidCoolantTemp:
        return 'Coolant Temperature';
      case ObdConstants.pidControlModuleVoltage:
        return 'Module Voltage';
      case ObdConstants.pidFuelLevel:
        return 'Fuel Level';
      default:
        return 'Unknown';
    }
  }
  
  /// Get the unit for a PID
  String _getPidUnit(String pid) {
    switch (pid) {
      case ObdConstants.pidEngineRpm:
        return 'rpm';
      case ObdConstants.pidVehicleSpeed:
        return 'km/h';
      case ObdConstants.pidThrottlePosition:
        return '%';
      case ObdConstants.pidCoolantTemp:
        return '°C';
      case ObdConstants.pidControlModuleVoltage:
        return 'V';
      case ObdConstants.pidFuelLevel:
        return '%';
      default:
        return '';
    }
  }
} 