import 'dart:async';
import 'package:logging/logging.dart';

import '../interfaces/obd_connection.dart';
import '../protocol/obd_protocol.dart';
import '../protocol/elm327_protocol.dart';
import '../models/adapter_config.dart';
import '../models/adapter_config_factory.dart';
import '../protocol/response_processor/processor_factory.dart';
import 'adapter_profile.dart';
import 'profile_manager.dart';

/// Profile for ELM327 v2.0+ adapters
///
/// This profile targets genuine ELM327 v2.0 and newer adapters, which offer
/// maximum performance with advanced features like message filtering,
/// better timing, and improved reliability.
class Elm327V20Profile extends AdapterProfile {
  static final Logger _logger = Logger('Elm327V20Profile');
  
  /// Configuration for this adapter profile
  final AdapterConfig _config;
  
  /// Create a new ELM327 v2.0 profile with default configuration
  Elm327V20Profile() : _config = AdapterConfigFactory.createElm327V20Config();
  
  /// Create a new ELM327 v2.0 profile with custom configuration
  Elm327V20Profile.withConfig(this._config);
  
  @override
  AdapterConfig get config => _config;
  
  @override
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  }) async {
    _logger.info('Creating ELM327 v2.0 protocol handler');
    
    // Create processor specifically optimized for v2.0 adapters
    final processor = ResponseProcessorFactory.createProcessor(
      'elm327_v20',
      _config.useLenientParsing,
    );
    
    return Elm327Protocol(
      connection,
      isDebugMode: isDebugMode,
      customResponseProcessor: processor,
      adapterConfig: _config,
      profileManager: profileManager,
      deviceId: deviceId,
    );
  }
  
  @override
  Future<double> testCompatibility(ObdConnection connection, {bool isDebugMode = false}) async {
    _logger.info('Testing compatibility for ELM327 v2.0 adapter');
    
    double score = 0.0;
    int totalTests = 0;
    
    try {
      // Create a temporary protocol instance for testing
      final protocol = await createProtocol(connection, isDebugMode: isDebugMode);
      
      // Test 1: Version check - look for v2.0+ in the adapter version string
      final version = await protocol.sendCommand('ATI');
      if (version.toLowerCase().contains('elm327 v2.0') || 
          version.toLowerCase().contains('elm327 v2.1') || 
          version.toLowerCase().contains('elm327 v2.2')) {
        score += 1.0;
        totalTests++;
      } else if (version.toLowerCase().contains('elm327') && 
                (version.toLowerCase().contains('2.0') || 
                 version.toLowerCase().contains('2.1') || 
                 version.toLowerCase().contains('2.2'))) {
        // Partial match, some adapters don't format version string exactly
        score += 0.8;
        totalTests++;
      } else {
        // Not a v2.0+ adapter
        score += 0.0;
        totalTests++;
      }
      
      // Test 2: CAN specific commands - v2.0 adapters have advanced CAN capabilities
      final canTest = await protocol.sendCommand('ATCF');
      if (!canTest.contains('?') && !canTest.contains('ERROR')) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Test 3: Test for message filtering capability (v2.0+ feature)
      final cmTest = await protocol.sendCommand('ATCM');
      if (!cmTest.contains('?') && !cmTest.contains('ERROR')) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Test 4: Speed test - v2.0 adapters are much faster
      final stopwatch = Stopwatch()..start();
      await protocol.sendCommand('ATH1');
      stopwatch.stop();
      
      // v2.0 adapters are very responsive (<30ms response time)
      if (stopwatch.elapsedMilliseconds < 30) {
        score += 1.0;
        totalTests++;
      } else if (stopwatch.elapsedMilliseconds < 50) {
        score += 0.5;
        totalTests++;
      } else {
        // Too slow for a v2.0 adapter
        score += 0.0;
        totalTests++;
      }
      
      // Test 5: Advanced protocol support - v2.0 supports more protocols
      final protocolTest = await protocol.sendCommand('ATDPN');
      // Genuine v2.0 adapters return protocol number without errors
      if (!protocolTest.contains('?') && protocolTest.trim().length <= 2) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Calculate final score (0.0 to 1.0)
      return totalTests > 0 ? score / totalTests : 0.0;
    } catch (e) {
      _logger.warning('Error during compatibility test: $e');
      return 0.0; // Not compatible if exceptions occur
    }
  }
} 