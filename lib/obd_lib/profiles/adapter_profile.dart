import 'dart:async';

import '../interfaces/obd_connection.dart';
import '../protocol/obd_protocol.dart';
import '../models/adapter_config.dart';
import 'profile_manager.dart';

/// Abstract class for OBD-II adapter profiles
///
/// This class encapsulates adapter-specific settings and behaviors,
/// allowing different adapter implementations to be used interchangeably.
abstract class AdapterProfile {
  /// Get the adapter configuration for this profile
  AdapterConfig get config;
  
  /// Unique identifier for the profile
  String get profileId => config.profileId;
  
  /// Human-readable name of the adapter
  String get adapterName => config.name;
  
  /// Description of the adapter
  String get description => config.description;
  
  /// Bluetooth service UUID for this adapter
  String get serviceUuid => config.serviceUuid;
  
  /// Characteristic UUID for notifications (reading from adapter)
  String get notifyCharacteristicUuid => config.notifyCharacteristicUuid;
  
  /// Characteristic UUID for writing commands to adapter
  String get writeCharacteristicUuid => config.writeCharacteristicUuid;
  
  /// Response timeout for commands (ms)
  int get responseTimeoutMs => config.responseTimeoutMs;
  
  /// Connection timeout (ms)
  int get connectionTimeoutMs => config.connectionTimeoutMs;
  
  /// Command timeout (ms)
  int get commandTimeoutMs => config.commandTimeoutMs;
  
  /// Delay between commands during initialization (ms)
  int get initCommandDelayMs => config.initCommandDelayMs;
  
  /// Delay after reset command (ms)
  int get resetDelayMs => config.resetDelayMs;
  
  /// Default polling interval when engine is running (ms)
  int get defaultPollingInterval => config.defaultPollingInterval;
  
  /// Slow polling interval for unreliable adapters (ms)
  int get slowPollingInterval => config.slowPollingInterval;
  
  /// Polling interval when engine is off (ms)
  int get engineOffPollingInterval => config.engineOffPollingInterval;
  
  /// Maximum number of retries per command
  int get maxRetries => config.maxRetries;
  
  /// Create a protocol handler for this adapter profile
  ///
  /// This method creates and returns an ObdProtocol implementation
  /// appropriate for this adapter profile.
  Future<ObdProtocol> createProtocol(ObdConnection connection, {
    bool isDebugMode = false,
    ProfileManager? profileManager,
    String? deviceId,
  });
  
  /// Test if the adapter is compatible with this profile
  ///
  /// This method tests if a connected adapter is compatible with this profile.
  /// Returns a compatibility score from 0.0 (incompatible) to 1.0 (perfect match).
  Future<double> testCompatibility(ObdConnection connection, {bool isDebugMode = false});
} 