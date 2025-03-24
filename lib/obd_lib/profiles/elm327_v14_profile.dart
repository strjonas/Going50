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

/// Profile for ELM327 v1.4 adapters
///
/// This profile targets genuine ELM327 v1.4 adapters, which offer
/// better performance and reliability than cheap clones.
/// The v1.4 adapters have some improvements over v1.3 but lack 
/// some advanced features of v2.0.
class Elm327V14Profile extends AdapterProfile {
  static final Logger _logger = Logger('Elm327V14Profile');
  
  /// Configuration for this adapter profile
  final AdapterConfig _config;
  
  /// Create a new ELM327 v1.4 profile with default configuration
  Elm327V14Profile() : _config = AdapterConfigFactory.createElm327V14Config();
  
  /// Create a new ELM327 v1.4 profile with custom configuration
  Elm327V14Profile.withConfig(this._config);
  
  @override
  AdapterConfig get config => _config;
  
  @override
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  }) async {
    _logger.info('Creating ELM327 v1.4 protocol handler');
    
    // Create processor specifically optimized for v1.4 adapters
    final processor = ResponseProcessorFactory.createProcessor(
      'elm327_v14', 
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
    _logger.info('Testing compatibility for ELM327 v1.4 adapter');
    
    double score = 0.0;
    int totalTests = 0;
    
    try {
      // Create a temporary protocol instance for testing
      final protocol = await createProtocol(connection, isDebugMode: isDebugMode);
      
      // Test 1: Version check - look for v1.4 in the adapter version string
      final version = await protocol.sendCommand('ATI');
      if (version.toLowerCase().contains('elm327 v1.4')) {
        score += 1.0;
        totalTests++;
      } else if (version.toLowerCase().contains('elm327') && 
                 version.toLowerCase().contains('1.4')) {
        // Partial match, some adapters don't format version string exactly
        score += 0.8;
        totalTests++;
      } else {
        // Not a v1.4 adapter
        score += 0.0;
        totalTests++;
      }
      
      // Test 2: Voltage reading capability (all v1.4+ adapters should support this)
      final voltageResponse = await protocol.sendCommand('ATRV');
      if (voltageResponse.isNotEmpty && voltageResponse.contains('.')) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Test 3: Memory capability test
      final memoryRead = await protocol.sendCommand('ATCR');
      if (!memoryRead.contains('ERROR') && !memoryRead.contains('?')) {
        score += 1.0;
        totalTests++;
      } else {
        score += 0.0;
        totalTests++;
      }
      
      // Test 4: Protocol detection speed
      final stopwatch = Stopwatch()..start();
      await protocol.sendCommand('ATSP0');
      stopwatch.stop();
      
      // v1.4 adapters should be able to process this command quickly
      if (stopwatch.elapsedMilliseconds < 50) {
        score += 1.0;
        totalTests++;
      } else if (stopwatch.elapsedMilliseconds < 100) {
        score += 0.5;
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