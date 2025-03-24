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

/// Profile for ELM327 v1.3 adapters
///
/// This profile targets genuine ELM327 v1.3 adapters, which are
/// older but still capable devices that require specific handling.
class Elm327V13Profile extends AdapterProfile {
  static final Logger _logger = Logger('Elm327V13Profile');
  
  /// Configuration for this adapter profile
  final AdapterConfig _config;
  
  /// Create a new ELM327 v1.3 profile with default configuration
  Elm327V13Profile() : _config = AdapterConfigFactory.createElm327V13Config();
  
  /// Create a new ELM327 v1.3 profile with custom configuration
  Elm327V13Profile.withConfig(this._config);
  
  @override
  AdapterConfig get config => _config;
  
  @override
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  }) async {
    _logger.info('Creating ELM327 v1.3 protocol handler');
    
    // Create processor specifically optimized for v1.3 adapters
    final processor = ResponseProcessorFactory.createProcessor(
      'elm327_v13',
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
    _logger.info('Testing compatibility for ELM327 v1.3 adapter');
    
    double score = 0.0;
    int totalTests = 0;
    
    try {
      // Create a temporary protocol instance for testing
      final protocol = await createProtocol(connection, isDebugMode: isDebugMode);
      
      // Test 1: Version check - look for v1.3 in the adapter version string
      final version = await protocol.sendCommand('ATI');
      if (version.toLowerCase().contains('elm327 v1.3')) {
        score += 1.0;
        totalTests++;
      } else if (version.toLowerCase().contains('elm327') && 
                 version.toLowerCase().contains('1.3')) {
        // Partial match, some adapters don't format version string exactly
        score += 0.8;
        totalTests++;
      } else {
        // Not a v1.3 adapter
        score += 0.0;
        totalTests++;
      }
      
      // Test 2: Protocol capabilities specific to v1.3
      // Many v1.3 adapters still support the STI command
      final stiResponse = await protocol.sendCommand('ATSTI');
      if (!stiResponse.contains('?') && !stiResponse.contains('ERROR')) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Test 3: Check if adapter supports ISO 14230-4 (KWP)
      final kwpTest = await protocol.sendCommand('ATSP5');
      if (!kwpTest.contains('?') && !kwpTest.contains('ERROR')) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Test 4: Timing test - v1.3 adapters are slower than newer versions
      final stopwatch = Stopwatch()..start();
      await protocol.sendCommand('ATH1');
      stopwatch.stop();
      
      // v1.3 adapters are typically slower (>50ms response time)
      if (stopwatch.elapsedMilliseconds > 50 && stopwatch.elapsedMilliseconds < 150) {
        score += 1.0;
        totalTests++;
      } else if (stopwatch.elapsedMilliseconds <= 50) {
        // Too fast for a v1.3 adapter, likely a newer version
        score += 0.0;
        totalTests++;
      } else if (stopwatch.elapsedMilliseconds >= 150) {
        // Too slow even for a v1.3 adapter, might be a cheap clone
        score += 0.5;
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