import 'package:logging/logging.dart';
import 'adapter_config.dart';
import '../protocol/obd_constants.dart';

/// Validates and monitors OBD adapter configurations
///
/// This class provides validation for configuration parameters,
/// runtime monitoring of adapter behavior, and protection for
/// critical parameters.
class AdapterConfigValidator {
  static final Logger _logger = Logger('AdapterConfigValidator');
  
  // Minimum and maximum values for critical parameters
  static const Map<String, Map<String, int>> _parameterLimits = {
    'cheap_elm327': {
      'responseTimeoutMs_min': 200,
      'responseTimeoutMs_max': 350,
      'connectionTimeoutMs_min': 8000,
      'connectionTimeoutMs_max': 12000,
      'commandTimeoutMs_min': 3000,
      'commandTimeoutMs_max': 5000,
      'initCommandDelayMs_min': 250,
      'initCommandDelayMs_max': 350,
      'resetDelayMs_min': 800,
      'resetDelayMs_max': 1200,
    },
    'premium_elm327': {
      'responseTimeoutMs_min': 80,
      'responseTimeoutMs_max': 150,
      'connectionTimeoutMs_min': 4000,
      'connectionTimeoutMs_max': 8000,
      'commandTimeoutMs_min': 1000,
      'commandTimeoutMs_max': 2000,
      'initCommandDelayMs_min': 30,
      'initCommandDelayMs_max': 100,
      'resetDelayMs_min': 200,
      'resetDelayMs_max': 500,
    },
    'elm327_v13': {
      'responseTimeoutMs_min': 120,
      'responseTimeoutMs_max': 200,
      'connectionTimeoutMs_min': 6000,
      'connectionTimeoutMs_max': 10000,
      'commandTimeoutMs_min': 2000,
      'commandTimeoutMs_max': 3000,
      'initCommandDelayMs_min': 80,
      'initCommandDelayMs_max': 150,
      'resetDelayMs_min': 500,
      'resetDelayMs_max': 1000,
    },
    'elm327_v14': {
      'responseTimeoutMs_min': 100,
      'responseTimeoutMs_max': 150,
      'connectionTimeoutMs_min': 6000,
      'connectionTimeoutMs_max': 8000,
      'commandTimeoutMs_min': 1500,
      'commandTimeoutMs_max': 2500,
      'initCommandDelayMs_min': 60,
      'initCommandDelayMs_max': 120,
      'resetDelayMs_min': 400,
      'resetDelayMs_max': 700,
    },
    'elm327_v20': {
      'responseTimeoutMs_min': 70,
      'responseTimeoutMs_max': 120,
      'connectionTimeoutMs_min': 4000,
      'connectionTimeoutMs_max': 6000,
      'commandTimeoutMs_min': 1000,
      'commandTimeoutMs_max': 1500,
      'initCommandDelayMs_min': 30,
      'initCommandDelayMs_max': 80,
      'resetDelayMs_min': 200,
      'resetDelayMs_max': 400,
    },
    'dynamic_elm327': {
      'responseTimeoutMs_min': 80,
      'responseTimeoutMs_max': 350,
      'connectionTimeoutMs_min': 4000,
      'connectionTimeoutMs_max': 12000,
      'commandTimeoutMs_min': 1000,
      'commandTimeoutMs_max': 5000,
      'initCommandDelayMs_min': 30,
      'initCommandDelayMs_max': 350,
      'resetDelayMs_min': 200,
      'resetDelayMs_max': 1200,
    },
  };
  
  // Required configuration parameters that must be validated
  static const List<String> _requiredParameters = [
    'responseTimeoutMs',
    'connectionTimeoutMs',
    'commandTimeoutMs',
    'initCommandDelayMs',
    'resetDelayMs',
    'defaultPollingInterval',
    'slowPollingInterval',
    'engineOffPollingInterval',
    'maxRetries',
  ];
  
  // Metrics for tracking runtime performance
  final Map<String, Map<String, dynamic>> _runtimeMetrics = {};
  
  /// Validate adapter configuration against defined constraints
  ///
  /// Returns a tuple with (isValid, validatedConfig, issues)
  /// where isValid is a boolean, validatedConfig is the adjusted configuration
  /// if needed, and issues is a list of validation issues.
  Map<String, dynamic> validateConfig(AdapterConfig config) {
    final profileId = config.profileId;
    final validationIssues = <String>[];
    bool isValid = true;
    var adjustedConfig = config;
    
    _logger.info('Validating configuration for profile: $profileId');
    
    // Check required parameters
    for (final param in _requiredParameters) {
      if (!_hasParameter(config, param)) {
        validationIssues.add('Missing required parameter: $param');
        isValid = false;
      }
    }
    
    // Check parameter limits
    if (_parameterLimits.containsKey(profileId)) {
      final limits = _parameterLimits[profileId]!;
      
      // Validate and adjust timing parameters if needed
      adjustedConfig = _validateTimingParameters(config, limits, validationIssues);
      
      // If validation failed but we have an adjusted config, we mark as valid
      // but report the issues
      if (config != adjustedConfig) {
        _logger.warning('Configuration adjusted to meet constraints for profile: $profileId');
      }
    } else {
      _logger.warning('No validation limits defined for profile: $profileId');
    }
    
    // Validate Bluetooth parameters
    _validateBluetoothParameters(config, validationIssues);
    
    // Check for safe protocol settings
    _validateProtocolSettings(config, validationIssues);
    
    // Additional validation for cheap adapters
    if (profileId == 'cheap_elm327') {
      _validateCheapAdapterSettings(config, validationIssues);
    }
    
    // Log all validation issues
    for (final issue in validationIssues) {
      _logger.warning('Validation issue: $issue');
    }
    
    return {
      'isValid': isValid || config != adjustedConfig,
      'config': adjustedConfig,
      'issues': validationIssues,
    };
  }
  
  /// Validate and adjust timing parameters based on limits
  AdapterConfig _validateTimingParameters(
    AdapterConfig config, 
    Map<String, int> limits, 
    List<String> validationIssues
  ) {
    var adjustedConfig = config;
    
    // Check each timing parameter
    void validateParam(String param, int value) {
      final minKey = '${param}_min';
      final maxKey = '${param}_max';
      
      if (limits.containsKey(minKey) && limits.containsKey(maxKey)) {
        final min = limits[minKey]!;
        final max = limits[maxKey]!;
        
        if (value < min) {
          validationIssues.add('$param too low: $value (min: $min)');
          // Create adjusted config using copyWith
          adjustedConfig = _updateConfigParam(adjustedConfig, param, min);
        } else if (value > max) {
          validationIssues.add('$param too high: $value (max: $max)');
          // Create adjusted config using copyWith
          adjustedConfig = _updateConfigParam(adjustedConfig, param, max);
        }
      }
    }
    
    validateParam('responseTimeoutMs', config.responseTimeoutMs);
    validateParam('connectionTimeoutMs', config.connectionTimeoutMs);
    validateParam('commandTimeoutMs', config.commandTimeoutMs);
    validateParam('initCommandDelayMs', config.initCommandDelayMs);
    validateParam('resetDelayMs', config.resetDelayMs);
    
    return adjustedConfig;
  }
  
  /// Update a specific parameter in the config using copyWith
  AdapterConfig _updateConfigParam(AdapterConfig config, String param, int value) {
    switch (param) {
      case 'responseTimeoutMs':
        return config.copyWith(responseTimeoutMs: value);
      case 'connectionTimeoutMs':
        return config.copyWith(connectionTimeoutMs: value);
      case 'commandTimeoutMs':
        return config.copyWith(commandTimeoutMs: value);
      case 'initCommandDelayMs':
        return config.copyWith(initCommandDelayMs: value);
      case 'resetDelayMs':
        return config.copyWith(resetDelayMs: value);
      default:
        return config;
    }
  }
  
  /// Check if a parameter exists on the config object
  bool _hasParameter(AdapterConfig config, String param) {
    try {
      switch (param) {
        case 'responseTimeoutMs':
          return config.responseTimeoutMs != null;
        case 'connectionTimeoutMs':
          return config.connectionTimeoutMs != null;
        case 'commandTimeoutMs':
          return config.commandTimeoutMs != null;
        case 'initCommandDelayMs':
          return config.initCommandDelayMs != null;
        case 'resetDelayMs':
          return config.resetDelayMs != null;
        case 'defaultPollingInterval':
          return config.defaultPollingInterval != null;
        case 'slowPollingInterval':
          return config.slowPollingInterval != null;
        case 'engineOffPollingInterval':
          return config.engineOffPollingInterval != null;
        case 'maxRetries':
          return config.maxRetries != null;
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  /// Validate Bluetooth parameters
  void _validateBluetoothParameters(AdapterConfig config, List<String> validationIssues) {
    // Check service UUID
    if (config.serviceUuid != ObdConstants.serviceUuid) {
      validationIssues.add('Invalid service UUID: ${config.serviceUuid}');
    }
    
    // Check notification characteristic UUID
    if (config.notifyCharacteristicUuid != ObdConstants.notifyCharacteristicUuid) {
      validationIssues.add('Invalid notify characteristic UUID: ${config.notifyCharacteristicUuid}');
    }
    
    // Check write characteristic UUID
    if (config.writeCharacteristicUuid != ObdConstants.writeCharacteristicUuid) {
      validationIssues.add('Invalid write characteristic UUID: ${config.writeCharacteristicUuid}');
    }
  }
  
  /// Validate protocol settings
  void _validateProtocolSettings(AdapterConfig config, List<String> validationIssues) {
    // Check OBD protocol
    if (config.obdProtocol != 'AUTO' && 
        config.obdProtocol != 'ISO 14230-4' && 
        config.obdProtocol != 'ISO 15765-4') {
      validationIssues.add('Unsupported OBD protocol: ${config.obdProtocol}');
    }
    
    // Check baud rate
    if (config.baudRate != 9600 && config.baudRate != 10400 && config.baudRate != 38400) {
      validationIssues.add('Unusual baud rate: ${config.baudRate}');
    }
  }
  
  /// Additional validation for cheap adapters
  void _validateCheapAdapterSettings(AdapterConfig config, List<String> validationIssues) {
    // Cheap adapters must have specific flags set
    if (!config.useExtendedInitDelays) {
      validationIssues.add('useExtendedInitDelays must be true for cheap adapters');
    }
    
    if (!config.useLenientParsing) {
      validationIssues.add('useLenientParsing must be true for cheap adapters');
    }
  }
  
  /// Record runtime metrics for an adapter configuration
  /// 
  /// This allows monitoring of adapter behavior over time and can
  /// be used to automatically adjust configuration parameters.
  void recordRuntimeMetrics(String deviceId, AdapterConfig config, Map<String, dynamic> metrics) {
    final profileId = config.profileId;
    final key = '$deviceId:$profileId';
    
    if (!_runtimeMetrics.containsKey(key)) {
      _runtimeMetrics[key] = {
        'deviceId': deviceId,
        'profileId': profileId,
        'commandCount': 0,
        'successCount': 0,
        'failureCount': 0,
        'totalResponseTime': 0,
        'avgResponseTime': 0,
        'maxResponseTime': 0,
        'minResponseTime': null,
        'timeoutCount': 0,
        'lastUpdateTime': DateTime.now().millisecondsSinceEpoch,
        'sampledParameters': <String, List<int>>{},
      };
      
      // Initialize sample collections for timing parameters
      _runtimeMetrics[key]!['sampledParameters']!['responseTime'] = [];
      _runtimeMetrics[key]!['sampledParameters']!['commandDuration'] = [];
    }
    
    // Update metrics
    final data = _runtimeMetrics[key]!;
    data['commandCount'] = (data['commandCount'] as int) + 1;
    
    if (metrics.containsKey('success') && metrics['success'] == true) {
      data['successCount'] = (data['successCount'] as int) + 1;
    } else {
      data['failureCount'] = (data['failureCount'] as int) + 1;
    }
    
    if (metrics.containsKey('responseTime')) {
      final responseTime = metrics['responseTime'] as int;
      data['totalResponseTime'] = (data['totalResponseTime'] as int) + responseTime;
      data['avgResponseTime'] = (data['totalResponseTime'] as int) / (data['commandCount'] as int);
      
      if (data['maxResponseTime'] < responseTime) {
        data['maxResponseTime'] = responseTime;
      }
      
      if (data['minResponseTime'] == null || (data['minResponseTime'] as int) > responseTime) {
        data['minResponseTime'] = responseTime;
      }
      
      // Add to samples
      final samples = (data['sampledParameters']!['responseTime'] as List<int>);
      if (samples.length >= 100) {
        samples.removeAt(0); // Remove oldest sample
      }
      samples.add(responseTime);
    }
    
    if (metrics.containsKey('timeout') && metrics['timeout'] == true) {
      data['timeoutCount'] = (data['timeoutCount'] as int) + 1;
    }
    
    if (metrics.containsKey('commandDuration')) {
      final duration = metrics['commandDuration'] as int;
      final samples = (data['sampledParameters']!['commandDuration'] as List<int>);
      if (samples.length >= 100) {
        samples.removeAt(0); // Remove oldest sample
      }
      samples.add(duration);
    }
    
    // Update timestamp
    data['lastUpdateTime'] = DateTime.now().millisecondsSinceEpoch;
  }
  
  /// Calculate optimized timing parameters based on runtime metrics
  ///
  /// Returns a new configuration with optimized timing parameters
  /// if sufficient data is available.
  AdapterConfig? calculateOptimizedConfig(String deviceId, String profileId) {
    final key = '$deviceId:$profileId';
    
    if (!_runtimeMetrics.containsKey(key)) {
      _logger.info('No runtime metrics available for $deviceId with profile $profileId');
      return null;
    }
    
    final metrics = _runtimeMetrics[key]!;
    final commandCount = metrics['commandCount'] as int;
    
    // Need at least 20 commands to have enough data
    if (commandCount < 20) {
      _logger.info('Insufficient command count for optimization: $commandCount');
      return null;
    }
    
    // Get the current config
    final profile = profileId == 'cheap_elm327' ? 'cheap_elm327' : 'premium_elm327';
    final limits = _parameterLimits[profile]!;
    
    // Get success rate
    final successCount = metrics['successCount'] as int;
    final successRate = successCount / commandCount;
    
    // If success rate is too low, don't try to optimize
    if (successRate < 0.8) {
      _logger.info('Success rate too low for optimization: ${(successRate * 100).toStringAsFixed(1)}%');
      return null;
    }
    
    // Calculate optimized response timeout based on observed response times
    final responseSamples = (metrics['sampledParameters']!['responseTime'] as List<int>);
    
    if (responseSamples.isEmpty) {
      return null;
    }
    
    // Sort samples to find percentiles
    responseSamples.sort();
    final p95Index = ((responseSamples.length - 1) * 0.95).round();
    final p95ResponseTime = responseSamples[p95Index];
    
    // Add 20% margin to the 95th percentile
    int optimizedResponseTimeout = (p95ResponseTime * 1.2).round();
    
    // Clamp to allowed range
    optimizedResponseTimeout = optimizedResponseTimeout.clamp(
      limits['responseTimeoutMs_min']!,
      limits['responseTimeoutMs_max']!
    );
    
    // Get current config
    // Note: In a real implementation, you'd get this from the profile manager
    // For this example, we'll create a placeholder for demonstration
    var currentConfig = AdapterConfig(
      profileId: profileId,
      name: 'Runtime Optimized Config',
      description: 'Automatically optimized configuration based on runtime metrics',
      serviceUuid: ObdConstants.serviceUuid,
      notifyCharacteristicUuid: ObdConstants.notifyCharacteristicUuid,
      writeCharacteristicUuid: ObdConstants.writeCharacteristicUuid,
      responseTimeoutMs: optimizedResponseTimeout,
      connectionTimeoutMs: limits['connectionTimeoutMs_min']!,
      commandTimeoutMs: limits['commandTimeoutMs_min']!,
      initCommandDelayMs: limits['initCommandDelayMs_min']!,
      resetDelayMs: limits['resetDelayMs_min']!,
      defaultPollingInterval: 500,
      slowPollingInterval: 1000,
      engineOffPollingInterval: 3000,
      maxRetries: 2,
      useExtendedInitDelays: profileId == 'cheap_elm327',
      useLenientParsing: profileId == 'cheap_elm327',
      obdProtocol: 'ISO 14230-4',
      baudRate: 10400,
    );
    
    // Optimize command timeout based on command duration samples
    final commandSamples = (metrics['sampledParameters']!['commandDuration'] as List<int>);
    
    if (commandSamples.isNotEmpty) {
      commandSamples.sort();
      final p95Index = ((commandSamples.length - 1) * 0.95).round();
      final p95CommandDuration = commandSamples[p95Index];
      
      // Add 50% margin to the 95th percentile
      int optimizedCommandTimeout = (p95CommandDuration * 1.5).round();
      
      // Clamp to allowed range
      optimizedCommandTimeout = optimizedCommandTimeout.clamp(
        limits['commandTimeoutMs_min']!,
        limits['commandTimeoutMs_max']!
      );
      
      currentConfig = currentConfig.copyWith(commandTimeoutMs: optimizedCommandTimeout);
    }
    
    _logger.info('Generated optimized configuration for $deviceId with profile $profileId');
    return currentConfig;
  }
  
  /// Check if a configuration is safe to update for a given profileId
  ///
  /// This prevents modifications to critical parameters for cheap adapters
  bool isSafeConfigUpdate(String profileId, Map<String, dynamic> updates) {
    // For cheap adapters, block modification of critical parameters
    if (profileId == 'cheap_elm327') {
      // Critical parameters that should not be modified for cheap adapters
      final protectedParameters = [
        'responseTimeoutMs',
        'connectionTimeoutMs',
        'commandTimeoutMs',
        'initCommandDelayMs',
        'resetDelayMs',
        'useExtendedInitDelays',
        'useLenientParsing',
        'obdProtocol',
        'baudRate',
      ];
      
      // Check if any protected parameters are being modified
      for (final param in protectedParameters) {
        if (updates.containsKey(param)) {
          _logger.warning('Attempt to modify protected parameter for cheap adapter: $param');
          return false;
        }
      }
    }
    
    return true;
  }
  
  /// Get runtime statistics summary for a device and profile
  Map<String, dynamic>? getRuntimeStatistics(String deviceId, String profileId) {
    final key = '$deviceId:$profileId';
    
    if (!_runtimeMetrics.containsKey(key)) {
      return null;
    }
    
    final metrics = _runtimeMetrics[key]!;
    final commandCount = metrics['commandCount'] as int;
    final successCount = metrics['successCount'] as int;
    final timeoutCount = metrics['timeoutCount'] as int;
    
    // Calculate statistics
    final successRate = commandCount > 0 ? successCount / commandCount : 0.0;
    final timeoutRate = commandCount > 0 ? timeoutCount / commandCount : 0.0;
    final avgResponseTime = metrics['avgResponseTime'] as double;
    
    return {
      'deviceId': deviceId,
      'profileId': profileId,
      'commandCount': commandCount,
      'successRate': successRate,
      'timeoutRate': timeoutRate,
      'avgResponseTime': avgResponseTime,
      'maxResponseTime': metrics['maxResponseTime'] as int,
      'minResponseTime': metrics['minResponseTime'] as int?,
      'lastUpdateTime': metrics['lastUpdateTime'] as int,
    };
  }
} 