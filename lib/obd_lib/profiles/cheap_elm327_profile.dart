import 'dart:async';
import 'package:logging/logging.dart';

import '../bluetooth/bluetooth_connection.dart';
import '../interfaces/obd_connection.dart';
import '../models/adapter_config.dart';
import '../models/adapter_config_factory.dart';
import '../protocol/elm327_protocol.dart';
import '../protocol/obd_constants.dart';
import '../protocol/obd_protocol.dart';
import 'adapter_profile.dart';
import 'profile_manager.dart';

/// Profile for the cheap ELM327 adapter
///
/// This profile preserves the exact configuration and behavior
/// of the original implementation for the cheap, unreliable adapter.
class CheapElm327Profile implements AdapterProfile {
  static final Logger _logger = Logger('CheapElm327Profile');
  
  /// The configuration for this adapter
  @override
  final AdapterConfig config;
  
  /// Create a new cheap ELM327 profile with default configuration
  CheapElm327Profile() : config = AdapterConfigFactory.createCheapElm327Config() {
    _logger.info('Created cheap ELM327 profile with default configuration');
  }
  
  /// Create a new cheap ELM327 profile with custom configuration
  CheapElm327Profile.withConfig(this.config) {
    _logger.info('Created cheap ELM327 profile with custom configuration');
  }

  @override
  String get profileId => 'cheap_elm327';
  
  @override
  String get adapterName => 'Cheap ELM327 Adapter';
  
  @override
  String get description => 
      'Profile for cheap, possibly counterfeit ELM327 adapters. '
      'Uses conservative settings for maximum compatibility with unreliable devices.';
  
  @override
  String get serviceUuid => ObdConstants.serviceUuid;
  
  @override
  String get notifyCharacteristicUuid => ObdConstants.notifyCharacteristicUuid;
  
  @override
  String get writeCharacteristicUuid => ObdConstants.writeCharacteristicUuid;
  
  @override
  int get responseTimeoutMs => ObdConstants.responseTimeoutMs;
  
  @override
  int get connectionTimeoutMs => ObdConstants.connectionTimeoutMs;
  
  @override
  int get commandTimeoutMs => ObdConstants.commandTimeoutMs;
  
  @override
  int get initCommandDelayMs => ObdConstants.initCommandDelayMs;
  
  @override
  int get resetDelayMs => ObdConstants.resetDelayMs;
  
  @override
  int get defaultPollingInterval => ObdConstants.defaultPollingInterval;
  
  @override
  int get slowPollingInterval => ObdConstants.slowPollingInterval;
  
  @override
  int get engineOffPollingInterval => ObdConstants.engineOffPollingInterval;
  
  @override
  int get maxRetries => 2; // Original value from elm327_protocol.dart

  @override
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  }) async {
    _logger.info('Creating protocol for cheap ELM327 adapter');
    
    // Create a protocol instance with the appropriate configuration for cheap adapters
    final protocol = Elm327Protocol(
      connection,
      isDebugMode: isDebugMode,
      adapterProfile: profileId,
      adapterConfig: config,
      profileManager: profileManager,
      deviceId: deviceId,
    );
    
    // Verify that critical configuration is set correctly
    if (!config.useExtendedInitDelays) {
      _logger.warning('Warning: Cheap ELM327 adapter without extended delays may not initialize properly');
    }
    
    if (!config.useLenientParsing) {
      _logger.warning('Warning: Cheap ELM327 adapter without lenient parsing may not interpret data correctly');
    }
    
    return protocol;
  }
  
  @override
  Future<double> testCompatibility(ObdConnection connection, {bool isDebugMode = false}) async {
    _logger.info('Testing compatibility for cheap ELM327 adapter');
    
    try {
      // Send a couple of common commands to test adapter response format
      
      // Reset the adapter
      await connection.sendCommand('ATZ');
      await Future.delayed(Duration(milliseconds: resetDelayMs));
      
      // Turn echo off
      await connection.sendCommand('ATE0');
      await Future.delayed(Duration(milliseconds: initCommandDelayMs));
      
      // Get ELM version (AT@1)
      await connection.sendCommand('AT@1');
      
      // We'll rate compatibility based on receiving any response 
      // because the cheap adapters are less predictable
      
      // For cheap adapters, assume higher compatibility since we're using
      // the most lenient settings by default
      return 0.8;  // Fairly high compatibility score
    } catch (e) {
      _logger.warning('Error testing compatibility: $e');
      return 0.3;  // Some compatibility due to lenient settings
    }
  }
} 