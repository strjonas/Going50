import 'dart:async';
import 'package:logging/logging.dart';

import '../interfaces/obd_connection.dart';
import '../models/adapter_config.dart';
import '../protocol/obd_constants.dart';
import '../protocol/obd_protocol.dart';
import '../mocks/mock_elm327_protocol.dart';
import 'adapter_profile.dart';
import 'profile_manager.dart';

/// Profile for mock ELM327 adapter used in testing
///
/// This profile simulates an ELM327 adapter for testing purposes
/// without requiring actual hardware.
class MockAdapterProfile implements AdapterProfile {
  static final Logger _logger = Logger('MockAdapterProfile');
  
  /// The configuration for this adapter
  @override
  final AdapterConfig config;
  
  /// Configuration for the mock profile
  final String? scenarioName;
  final Map<String, List<dynamic>>? testData;
  final bool simulateConnectionIssues;
  final double connectionReliability;

  /// Creates a new MockAdapterProfile with optional configuration
  MockAdapterProfile({
    this.scenarioName,
    this.testData,
    this.simulateConnectionIssues = false,
    this.connectionReliability = 1.0,
    AdapterConfig? adapterConfig,
  }) : config = adapterConfig ?? _createDefaultMockConfig() {
    _logger.info('Created mock adapter profile with ${config.profileId} configuration');
  }
  
  /// Implement all getters from AdapterProfile
  @override
  String get profileId => config.profileId;
  
  @override
  String get adapterName => config.name;
  
  @override
  String get description => config.description;
  
  @override
  String get serviceUuid => config.serviceUuid;
  
  @override
  String get notifyCharacteristicUuid => config.notifyCharacteristicUuid;
  
  @override
  String get writeCharacteristicUuid => config.writeCharacteristicUuid;
  
  @override
  int get responseTimeoutMs => config.responseTimeoutMs;
  
  @override
  int get connectionTimeoutMs => config.connectionTimeoutMs;
  
  @override
  int get commandTimeoutMs => config.commandTimeoutMs;
  
  @override
  int get initCommandDelayMs => config.initCommandDelayMs;
  
  @override
  int get resetDelayMs => config.resetDelayMs;
  
  @override
  int get defaultPollingInterval => config.defaultPollingInterval;
  
  @override
  int get slowPollingInterval => config.slowPollingInterval;
  
  @override
  int get engineOffPollingInterval => config.engineOffPollingInterval;
  
  @override
  int get maxRetries => config.maxRetries;
  
  /// Create a default mock configuration with fast response times for testing
  static AdapterConfig _createDefaultMockConfig() {
    return AdapterConfig(
      profileId: 'mock_elm327',
      name: 'Mock ELM327 Adapter',
      description: 'Profile for testing without actual hardware. '
          'Simulates OBD-II communication with configurable behavior.',
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      responseTimeoutMs: 50, // Very fast for tests
      connectionTimeoutMs: 500, // Very fast for tests
      commandTimeoutMs: 100, // Very fast for tests
      initCommandDelayMs: 10, // Very fast for tests
      resetDelayMs: 50, // Very fast for tests
      defaultPollingInterval: 100, // Very fast for tests
      slowPollingInterval: 200, // Very fast for tests
      engineOffPollingInterval: 500, // Very fast for tests
      maxRetries: 0, // No retries needed for mocks
      useExtendedInitDelays: false, // No need for extended delays in tests
      useLenientParsing: true, // Use lenient parsing for flexible test data
      obdProtocol: 'AUTO', // Use auto protocol detection
      baudRate: 10400, // Standard baud rate
    );
  }
  
  @override
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  }) async {
    _logger.info('Creating mock protocol');
    return MockElm327Protocol(
      connection,
      scenarioName: scenarioName,
      testData: testData,
      simulateConnectionIssues: simulateConnectionIssues,
      connectionReliability: connectionReliability,
      isDebugMode: isDebugMode,
      adapterConfig: config,
    );
  }
  
  @override
  Future<double> testCompatibility(ObdConnection connection, {bool isDebugMode = false}) async {
    // Mock adapters always claim to be compatible
    return 1.0;
  }
} 