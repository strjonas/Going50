import 'package:logging/logging.dart';

/// Configuration for OBD-II adapters
///
/// This class encapsulates adapter-specific settings and replaces
/// hard-coded constants with configurable parameters. It allows
/// for dynamic configuration of adapters based on their capabilities.
class AdapterConfig {
  static final Logger _logger = Logger('AdapterConfig');
  
  /// Unique identifier for the configuration profile
  final String profileId;
  
  /// Human-readable name for the configuration
  final String name;
  
  /// Description of this configuration profile
  final String description;
  
  // Bluetooth-related settings
  /// Service UUID for BLE communication
  final String serviceUuid;
  
  /// Characteristic UUID for notifications (data from adapter)
  final String notifyCharacteristicUuid;
  
  /// Characteristic UUID for writing commands to adapter
  final String writeCharacteristicUuid;
  
  // Timing-related settings
  /// Response timeout for single commands (ms)
  final int responseTimeoutMs;
  
  /// Connection establishment timeout (ms)
  final int connectionTimeoutMs;
  
  /// Command execution timeout (ms)
  final int commandTimeoutMs;
  
  /// Delay between initialization commands (ms)
  final int initCommandDelayMs;
  
  /// Delay after reset command (ms)
  final int resetDelayMs;
  
  // Polling-related settings
  /// Default polling interval for normal operation (ms)
  final int defaultPollingInterval;
  
  /// Slower polling for less reliable adapters (ms)
  final int slowPollingInterval;
  
  /// Polling interval when engine is off (ms)
  final int engineOffPollingInterval;
  
  // Error handling settings
  /// Maximum number of command retries
  final int maxRetries;
  
  /// Whether to use extended initialization delays
  final bool useExtendedInitDelays;
  
  /// Whether to use strict or lenient response parsing
  final bool useLenientParsing;
  
  // Protocol settings
  /// OBD protocol to use (e.g., "AUTO", "ISO 14230-4")
  final String obdProtocol;
  
  /// Baud rate for communication
  final int baudRate;
  
  /// Create a new adapter configuration
  AdapterConfig({
    required this.profileId,
    required this.name,
    required this.description,
    required this.serviceUuid,
    required this.notifyCharacteristicUuid,
    required this.writeCharacteristicUuid,
    required this.responseTimeoutMs,
    required this.connectionTimeoutMs,
    required this.commandTimeoutMs,
    required this.initCommandDelayMs,
    required this.resetDelayMs,
    required this.defaultPollingInterval,
    required this.slowPollingInterval,
    required this.engineOffPollingInterval,
    required this.maxRetries,
    required this.useExtendedInitDelays,
    required this.useLenientParsing,
    required this.obdProtocol,
    required this.baudRate,
  }) {
    _logger.info('Created adapter configuration: $profileId');
  }
  
  /// Create a deep copy of this configuration with optional overrides
  AdapterConfig copyWith({
    String? profileId,
    String? name,
    String? description,
    String? serviceUuid,
    String? notifyCharacteristicUuid,
    String? writeCharacteristicUuid,
    int? responseTimeoutMs,
    int? connectionTimeoutMs,
    int? commandTimeoutMs,
    int? initCommandDelayMs,
    int? resetDelayMs,
    int? defaultPollingInterval,
    int? slowPollingInterval,
    int? engineOffPollingInterval,
    int? maxRetries,
    bool? useExtendedInitDelays,
    bool? useLenientParsing,
    String? obdProtocol,
    int? baudRate,
  }) {
    return AdapterConfig(
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      description: description ?? this.description,
      serviceUuid: serviceUuid ?? this.serviceUuid,
      notifyCharacteristicUuid: notifyCharacteristicUuid ?? this.notifyCharacteristicUuid,
      writeCharacteristicUuid: writeCharacteristicUuid ?? this.writeCharacteristicUuid,
      responseTimeoutMs: responseTimeoutMs ?? this.responseTimeoutMs,
      connectionTimeoutMs: connectionTimeoutMs ?? this.connectionTimeoutMs,
      commandTimeoutMs: commandTimeoutMs ?? this.commandTimeoutMs,
      initCommandDelayMs: initCommandDelayMs ?? this.initCommandDelayMs,
      resetDelayMs: resetDelayMs ?? this.resetDelayMs,
      defaultPollingInterval: defaultPollingInterval ?? this.defaultPollingInterval,
      slowPollingInterval: slowPollingInterval ?? this.slowPollingInterval,
      engineOffPollingInterval: engineOffPollingInterval ?? this.engineOffPollingInterval,
      maxRetries: maxRetries ?? this.maxRetries,
      useExtendedInitDelays: useExtendedInitDelays ?? this.useExtendedInitDelays,
      useLenientParsing: useLenientParsing ?? this.useLenientParsing,
      obdProtocol: obdProtocol ?? this.obdProtocol,
      baudRate: baudRate ?? this.baudRate,
    );
  }
  
  @override
  String toString() {
    return 'AdapterConfig{profileId: $profileId, name: $name}';
  }
} 