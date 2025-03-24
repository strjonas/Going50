import 'package:logging/logging.dart';
import '../protocol/obd_constants.dart';
import 'adapter_config.dart';

/// Factory for creating adapter configurations
///
/// This class provides factory methods for creating pre-configured
/// adapter configurations for different types of ELM327 adapters.
class AdapterConfigFactory {
  static final Logger _logger = Logger('AdapterConfigFactory');
  
  // Private constructor to prevent instantiation
  AdapterConfigFactory._();
  
  /// Create a configuration for a cheap ELM327 adapter
  ///
  /// This configuration uses conservative settings optimized for
  /// unreliable, possibly counterfeit adapters.
  /// CRITICAL: These exact settings are required by the cheap adapter according to
  /// bluetooth-elm327-obd-do-not-modify-instruction.mdc and must not be changed.
  static AdapterConfig createCheapElm327Config() {
    _logger.info('Creating configuration for cheap ELM327 adapter');
    
    return AdapterConfig(
      profileId: 'cheap_elm327',
      name: 'Cheap ELM327 Adapter',
      description: 'Configuration for cheap, possibly counterfeit ELM327 adapters. '
          'Uses conservative settings for maximum compatibility with unreliable devices. '
          'The timing settings in this profile must not be modified as per project requirements.',
      
      // Bluetooth settings - must maintain exact UUIDs for compatibility
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      
      // Timing settings - CRITICAL VALUES - DO NOT MODIFY
      // These exact values are required for compatibility with the cheap adapter
      responseTimeoutMs: 300, // Critical value for cheap adapters
      connectionTimeoutMs: 10000, // Critical value for cheap adapters
      commandTimeoutMs: 4000, // Critical value for cheap adapters
      initCommandDelayMs: 300, // Critical value for cheap adapters
      resetDelayMs: 1000, // Critical value for cheap adapters
      
      // Polling intervals
      defaultPollingInterval: 2000, // Slower rate for cheap adapters
      slowPollingInterval: 3000, // Even slower for problematic conditions
      engineOffPollingInterval: 5000, // Very slow when engine is off
      
      // Error handling
      maxRetries: 2, // From original CheapElm327Profile
      
      // Behavior flags - CRITICAL VALUES - DO NOT MODIFY
      useExtendedInitDelays: true, // Critical flag for cheap adapters
      useLenientParsing: true, // Critical flag for cheap adapters
      
      // Protocol settings - CRITICAL VALUES - DO NOT MODIFY
      obdProtocol: 'ISO 14230-4', // KWP (5 baud init)
      baudRate: 10400, // 10.4 kbaud as per ATBRD10
    );
  }
  
  /// Create a configuration for a premium ELM327 adapter
  ///
  /// This configuration uses optimized settings for genuine
  /// or high-quality ELM327 adapters.
  static AdapterConfig createPremiumElm327Config() {
    _logger.info('Creating configuration for premium ELM327 adapter');
    
    return AdapterConfig(
      profileId: 'premium_elm327',
      name: 'Premium ELM327 Adapter',
      description: 'Configuration for genuine or high-quality ELM327 adapters. '
          'Uses optimized settings for better performance and faster response times.',
      
      // Bluetooth settings - keep same UUIDs for consistency
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      
      // Timing settings - optimized for genuine adapters
      // These values are significantly faster than the cheap adapter settings
      responseTimeoutMs: 100, // Faster response expected (was 150)
      connectionTimeoutMs: 6000, // Faster connection (was 8000)
      commandTimeoutMs: 1500, // Faster command timeout (was 2000) 
      initCommandDelayMs: 50, // Faster initialization (was 100)
      resetDelayMs: 300, // Shorter reset delay (was 500)
      
      // Polling intervals - faster for better real-time data
      defaultPollingInterval: 250, // Much faster polling possible with premium adapters (was 500)
      slowPollingInterval: 500, // Moderately slower for problematic conditions (was 1000)
      engineOffPollingInterval: 2000, // Slower when engine is off (was 3000)
      
      // Error handling - fewer retries needed for reliable adapters
      maxRetries: 1, // Premium adapters typically need fewer retries
      
      // Behavior flags - optimized for premium adapters
      useExtendedInitDelays: false, // No need for extended delays with premium adapters
      useLenientParsing: false, // Premium adapters provide properly formatted responses
      
      // Protocol settings - use same protocol for compatibility
      // but with more optimized timing parameters
      obdProtocol: 'ISO 14230-4', // KWP (5 baud init)
      baudRate: 10400, // 10.4 kbaud as per ATBRD10
    );
  }
  
  /// Create a configuration for an ELM327 v1.4 adapter
  ///
  /// This configuration is optimized for genuine ELM327 v1.4 adapters,
  /// which offer improved performance and stability over v1.3.
  static AdapterConfig createElm327V14Config() {
    _logger.info('Creating configuration for ELM327 v1.4 adapter');
    
    return AdapterConfig(
      profileId: 'elm327_v14',
      name: 'ELM327 v1.4 Adapter',
      description: 'Configuration for genuine ELM327 v1.4 adapters. '
          'These adapters offer better performance than v1.3 with improved '
          'stability and data processing capabilities.',
      
      // Bluetooth settings - keep same UUIDs for consistency
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      
      // Timing settings - optimized for v1.4 adapters
      responseTimeoutMs: 120, // Faster than cheap but more reliable than premium
      connectionTimeoutMs: 7000, // Balance between speed and reliability
      commandTimeoutMs: 2000, // Good balance for v1.4 adapters
      initCommandDelayMs: 75, // Slightly faster than cheap adapters
      resetDelayMs: 500, // Moderate reset delay
      
      // Polling intervals - optimized for v1.4 capabilities
      defaultPollingInterval: 350, // Faster than cheap, slower than premium
      slowPollingInterval: 750, // Moderate slowdown for problematic conditions
      engineOffPollingInterval: 2500, // Reasonable interval when engine is off
      
      // Error handling - balanced approach
      maxRetries: 2, // V1.4 adapters benefit from retries but fewer than cheap adapters
      
      // Behavior flags - optimized for v1.4 capabilities
      useExtendedInitDelays: false, // v1.4 adapters don't need extended delays
      useLenientParsing: false, // v1.4 adapters provide properly formatted responses
      
      // Protocol settings - use same protocol for compatibility
      obdProtocol: 'ISO 14230-4', // KWP (5 baud init)
      baudRate: 10400, // 10.4 kbaud as per ATBRD10
    );
  }
  
  /// Create a configuration for an ELM327 v2.0 adapter
  ///
  /// This configuration is optimized for genuine ELM327 v2.0+ adapters,
  /// which offer maximum performance and advanced features.
  static AdapterConfig createElm327V20Config() {
    _logger.info('Creating configuration for ELM327 v2.0 adapter');
    
    return AdapterConfig(
      profileId: 'elm327_v20',
      name: 'ELM327 v2.0+ Adapter',
      description: 'Configuration for genuine ELM327 v2.0 and newer adapters. '
          'These adapters offer maximum performance with advanced features like '
          'message filtering, better timing, and improved reliability.',
      
      // Bluetooth settings - keep same UUIDs for consistency
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      
      // Timing settings - optimized for v2.0 adapters (fastest possible)
      responseTimeoutMs: 80, // V2.0 adapters are very responsive
      connectionTimeoutMs: 5000, // Fast connection for modern adapters
      commandTimeoutMs: 1200, // Very responsive command handling
      initCommandDelayMs: 40, // Minimal delay needed
      resetDelayMs: 250, // Shorter reset delay for modern adapters
      
      // Polling intervals - optimized for v2.0 capabilities (maximum speed)
      defaultPollingInterval: 200, // Very fast polling for real-time data
      slowPollingInterval: 400, // Moderately slower for problematic conditions
      engineOffPollingInterval: 1500, // Faster checking even when engine is off
      
      // Error handling - minimal retries for reliable adapters
      maxRetries: 1, // V2.0 adapters rarely need retries
      
      // Behavior flags - optimized for v2.0 capabilities
      useExtendedInitDelays: false, // V2.0 adapters don't need extended delays
      useLenientParsing: false, // V2.0 adapters provide properly formatted responses
      
      // Protocol settings - use CAN protocol by default for v2.0 adapters
      obdProtocol: 'ISO 15765-4', // CAN (11/500)
      baudRate: 38400, // Higher baud rate for v2.0 adapters
    );
  }
  
  /// Create a configuration for an ELM327 v1.3 adapter
  ///
  /// This configuration is optimized for genuine ELM327 v1.3 adapters,
  /// which are older but still capable units.
  static AdapterConfig createElm327V13Config() {
    _logger.info('Creating configuration for ELM327 v1.3 adapter');
    
    return AdapterConfig(
      profileId: 'elm327_v13',
      name: 'ELM327 v1.3 Adapter',
      description: 'Configuration for genuine ELM327 v1.3 adapters. '
          'These are older adapters with decent performance but lacking '
          'some of the newer features and optimizations.',
      
      // Bluetooth settings - keep same UUIDs for consistency
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      
      // Timing settings - conservative for v1.3 limitations
      responseTimeoutMs: 150, // Moderate timeout for older adapters
      connectionTimeoutMs: 8000, // Longer connection time for older hardware
      commandTimeoutMs: 2500, // More time for command processing
      initCommandDelayMs: 100, // More delay between initialization commands
      resetDelayMs: 700, // Longer reset for older hardware
      
      // Polling intervals - balanced for v1.3 capabilities
      defaultPollingInterval: 500, // Moderate polling interval
      slowPollingInterval: 1000, // Slower for problematic conditions
      engineOffPollingInterval: 3000, // Conservative when engine is off
      
      // Error handling - more retries for older hardware
      maxRetries: 2, // V1.3 adapters benefit from retries
      
      // Behavior flags - balanced for v1.3 capabilities
      useExtendedInitDelays: true, // V1.3 benefits from extended delays
      useLenientParsing: false, // V1.3 adapters provide formatted responses
      
      // Protocol settings - use same protocol for compatibility
      obdProtocol: 'ISO 14230-4', // KWP (5 baud init)
      baudRate: 10400, // 10.4 kbaud as per ATBRD10
    );
  }
  
  /// Create a configuration based on adapter profile ID
  ///
  /// This method returns a configuration matching the given profile ID.
  /// If no matching profile is found, it defaults to the cheap adapter
  /// configuration for maximum compatibility.
  static AdapterConfig createConfig(String profileId) {
    _logger.info('Creating configuration for profile: $profileId');
    
    switch (profileId.toLowerCase()) {
      case 'premium_elm327':
        return createPremiumElm327Config();
      case 'elm327_v13':
        return createElm327V13Config();
      case 'elm327_v14':
        return createElm327V14Config();
      case 'elm327_v20':
        return createElm327V20Config();
      case 'cheap_elm327':
      default:
        // Default to cheap adapter for maximum compatibility
        return createCheapElm327Config();
    }
  }
  
  /// Create a dynamic configuration based on observed adapter behavior
  ///
  /// This method creates a configuration that starts with conservative
  /// settings and can be dynamically adjusted based on adapter performance.
  static AdapterConfig createDynamicConfig() {
    _logger.info('Creating dynamic adapter configuration');
    
    // Start with cheap adapter configuration for maximum compatibility
    final config = createCheapElm327Config();
    
    // Clone and modify to add dynamic behavior flags
    return config.copyWith(
      profileId: 'dynamic_elm327',
      name: 'Dynamic ELM327 Adapter',
      description: 'Dynamic configuration that adjusts based on adapter behavior. '
          'Starts with conservative settings and optimizes if possible.',
    );
  }
} 