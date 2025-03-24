import 'dart:async';
import 'package:logging/logging.dart';

import '../interfaces/obd_connection.dart';
import '../models/adapter_config.dart';
import '../models/adapter_config_factory.dart';
import '../protocol/obd_protocol.dart';
import '../protocol/elm327_protocol.dart';
import 'adapter_profile.dart';
import 'profile_manager.dart';

/// Profile for premium ELM327 adapters
///
/// This profile is optimized for more reliable, genuine ELM327 adapters
/// with better response times and stability.
class PremiumElm327Profile implements AdapterProfile {
  static final Logger _logger = Logger('PremiumElm327Profile');
  
  /// The configuration for this adapter
  @override
  final AdapterConfig config;
  
  /// Create a new premium ELM327 profile with default configuration
  PremiumElm327Profile() : config = AdapterConfigFactory.createPremiumElm327Config() {
    _logger.info('Created premium ELM327 profile with default configuration');
  }
  
  /// Create a new premium ELM327 profile with custom configuration
  PremiumElm327Profile.withConfig(this.config) {
    _logger.info('Created premium ELM327 profile with custom configuration');
  }
  
  @override
  String get profileId => 'premium_elm327';
  
  @override
  String get adapterName => 'Premium ELM327 Adapter';
  
  @override
  String get description => 
      'Profile for premium, genuine ELM327 adapters. '
      'Uses optimized settings for faster polling and better reliability.';
  
  // Bluetooth UUIDs - use the values from config for consistency
  @override
  String get serviceUuid => config.serviceUuid;
  
  @override
  String get notifyCharacteristicUuid => config.notifyCharacteristicUuid;
  
  @override
  String get writeCharacteristicUuid => config.writeCharacteristicUuid;
  
  // Timing parameters - use values from config for consistency
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
  
  // Polling intervals - use values from config for consistency
  @override
  int get defaultPollingInterval => config.defaultPollingInterval;
  
  @override
  int get slowPollingInterval => config.slowPollingInterval;
  
  @override
  int get engineOffPollingInterval => config.engineOffPollingInterval;
  
  // Error handling - use values from config for consistency
  @override
  int get maxRetries => config.maxRetries;
  
  @override
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  }) async {
    _logger.info('Creating protocol for premium ELM327 adapter');
    
    // Create a protocol instance with the appropriate configuration for premium adapters
    final protocol = Elm327Protocol(
      connection,
      isDebugMode: isDebugMode,
      adapterProfile: profileId,
      adapterConfig: config,
      profileManager: profileManager,
      deviceId: deviceId,
    );
    
    // Verify that configuration is appropriate for premium adapter
    if (config.useExtendedInitDelays) {
      _logger.warning('Warning: Premium ELM327 adapter configured with extended delays. '
          'This may not be optimal for performance.');
    }
    
    // Perform additional verification specific to premium adapters
    if (config.responseTimeoutMs > 200) {
      _logger.warning('Warning: Premium ELM327 adapter configured with long response timeout. '
          'This is typically not necessary for genuine adapters.');
    }
    
    return protocol;
  }
  
  @override
  Future<double> testCompatibility(ObdConnection connection, {bool isDebugMode = false}) async {
    _logger.info('Testing compatibility for premium ELM327 adapter');
    
    try {
      // Track specific indicators of premium adapter capabilities
      bool versionIndicatesPremium = false;
      bool formatIndicatesPremium = false;
      bool performanceIndicatesPremium = false;
      
      // Reset the adapter
      final resetResponse = await _sendCommandWithResponse(connection, 'ATZ');
      await Future.delayed(Duration(milliseconds: resetDelayMs));
      
      // Check if reset response looks like a premium adapter
      final resetCompatibility = _checkResponseFormat(resetResponse);
      
      // Check for version information indicating premium adapter
      if (resetResponse.contains('v1.5') || 
          resetResponse.contains('v2.1') ||
          resetResponse.contains('v2.2') ||
          resetResponse.contains('v2.3')) {
        versionIndicatesPremium = true;
        _logger.info('Version number indicates premium adapter: $resetResponse');
      }
      
      // Check for well-formatted response indicating premium adapter
      if (resetResponse.contains('ELM327') && resetResponse.contains('>') && !resetResponse.contains('?')) {
        formatIndicatesPremium = true;
        _logger.info('Response format indicates premium adapter');
      }
      
      // Turn echo off
      await connection.sendCommand('ATE0');
      await Future.delayed(Duration(milliseconds: initCommandDelayMs));
      
      // Get ELM version (AT@1) and measure response time
      final stopwatch = Stopwatch()..start();
      final versionResponse = await _sendCommandWithResponse(connection, 'AT@1');
      final responseTime = stopwatch.elapsedMilliseconds;
      stopwatch.stop();
      
      // Fast response time indicates premium adapter
      if (responseTime < 100) {
        performanceIndicatesPremium = true;
        _logger.info('Fast response time (${responseTime}ms) indicates premium adapter');
      }
      
      // Check if version response looks like a premium adapter
      final versionCompatibility = _checkResponseFormat(versionResponse);
      
      // Test additional advanced commands that premium adapters should support
      final supportedResponse = await _sendCommandWithResponse(connection, 'ATDPN');
      final protocolExistsResponse = await _sendCommandWithResponse(connection, 'ATDESC');
      
      // Premium adapters typically support more commands
      final advancedCommandSupport = supportedResponse.contains('OK') || !supportedResponse.contains('?');
      
      // Get supported PIDs (mode 01 pid 00)
      final pidsResponse = await _sendCommandWithResponse(connection, '0100');
      
      // Check if PIDs response has proper format
      final pidsCompatibility = _checkPidResponseFormat(pidsResponse);
      
      // Calculate overall compatibility score with more emphasis on premium-specific indicators
      double overallScore = 0.0;
      
      // Version indicators (30%)
      if (versionIndicatesPremium) {
        overallScore += 0.3;
      }
      
      // Format indicators (30%)
      overallScore += resetCompatibility * 0.15;
      overallScore += versionCompatibility * 0.15;
      
      // Performance indicators (20%)
      if (performanceIndicatesPremium) {
        overallScore += 0.2;
      }
      
      // Advanced features (10%)
      if (advancedCommandSupport) {
        overallScore += 0.1;
      }
      
      // Data format (10%)
      overallScore += pidsCompatibility * 0.1;
      
      _logger.info('Premium adapter compatibility score: $overallScore');
      
      // Add a bias against extremely low scores to avoid misidentification
      if (overallScore < 0.3) {
        overallScore = 0.1; // Very low score for unlikely matches
      }
      
      return overallScore;
    } catch (e) {
      _logger.warning('Error testing premium compatibility: $e');
      return 0.1;  // Low compatibility if errors occurred
    }
  }
  
  /// Send a command and wait for a response
  Future<String> _sendCommandWithResponse(ObdConnection connection, String command) async {
    final completer = Completer<String>();
    var responseBuffer = '';
    late StreamSubscription subscription;
    
    subscription = connection.dataStream.listen((data) {
      responseBuffer += data;
      
      // When we get a complete response (ends with prompt or has enough data)
      if (data.contains('>') || responseBuffer.length > 20) {
        if (!completer.isCompleted) {
          completer.complete(responseBuffer);
          subscription.cancel();
        }
      }
    });
    
    // Send the command
    await connection.sendCommand(command);
    
    // Set a timeout using the config value
    final timeout = Timer(Duration(milliseconds: commandTimeoutMs), () {
      if (!completer.isCompleted) {
        completer.complete(responseBuffer);
        subscription.cancel();
      }
    });
    
    try {
      return await completer.future;
    } finally {
      timeout.cancel();
    }
  }
  
  /// Check if a response follows premium adapter format
  double _checkResponseFormat(String response) {
    if (response.isEmpty) return 0.0;
    
    double score = 0.0;
    
    // Look for well-formed responses
    if (response.contains('ELM327')) score += 0.3;
    if (response.contains('v1.5') || 
        response.contains('v2.1') || 
        response.contains('v2.2') || 
        response.contains('v2.3')) {
      score += 0.3; // Higher score for version numbers (was 0.2)
    }
    if (response.contains('OK')) score += 0.2;
    if (response.contains('>')) score += 0.1;
    
    // Additional checks for premium adapter characteristics
    if (!response.contains('?')) score += 0.2;
    if (response.split('\r').length >= 2 || response.split('\n').length >= 2) {
      score += 0.1; // Proper line formatting
    }
    
    // Check for consistent formatting (lines ending with proper CR/LF)
    if ((response.contains('\r\n') || response.contains('\n\r')) && 
        !response.contains('??')) {
      score += 0.1;
    }
    
    return score;
  }
  
  /// Check if a PID response has the expected format for premium adapters
  double _checkPidResponseFormat(String response) {
    if (response.isEmpty) return 0.0;
    
    double score = 0.0;
    
    // Premium adapters typically respond with clean, structured data
    if (response.contains('41 00')) score += 0.4;
    if (!response.contains('SEARCHING')) score += 0.2;
    if (!response.contains('ERROR')) score += 0.2;
    if (response.split(' ').length >= 4) score += 0.2;  // Should have at least 4 parts
    
    // Additional checks for proper data formatting in premium adapters
    if (response.contains('41 00') && response.contains('>')) {
      score += 0.2; // Proper complete response with prompt
    }
    
    // Check for lack of repeat data (some cheap adapters repeat data)
    final lines = response.split('\r');
    final uniqueLines = lines.toSet().length;
    if (uniqueLines == lines.length) {
      score += 0.1; // No duplicate lines
    }
    
    // Check for proper byte spacing (premium adapters typically use space between bytes)
    if (response.contains(' ') && !response.contains('NO DATA')) {
      score += 0.1;
    }
    
    // Normalize to 0.0-1.0 range
    return score > 1.0 ? 1.0 : score;
  }
} 