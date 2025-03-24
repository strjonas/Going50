import 'dart:async';
import 'dart:math' as math;
import 'package:logging/logging.dart';

import '../interfaces/obd_connection.dart';
import '../bluetooth/bluetooth_connection.dart';
import '../mocks/mock_connection.dart';
import '../protocol/obd_protocol.dart';
import '../protocol/elm327_protocol.dart';
import 'adapter_profile.dart';
import 'cheap_elm327_profile.dart';
import 'premium_elm327_profile.dart';
import 'elm327_v13_profile.dart';
import 'elm327_v14_profile.dart';
import 'elm327_v20_profile.dart';
import 'mock_adapter_profile.dart';
import '../models/adapter_config.dart';
import '../models/adapter_config_factory.dart';
import '../models/adapter_config_validator.dart';

/// Class responsible for selecting and managing OBD adapter profiles
///
/// This class handles detection, selection, and management of
/// adapter profiles based on compatibility testing.
class ProfileManager {
  static final Logger _logger = Logger('ProfileManager');
  
  /// List of available adapter profiles
  final List<AdapterProfile> _profiles = [];
  
  /// The last used profile ID, if any
  String? _lastUsedProfileId;
  
  /// Whether a manual profile has been selected
  bool _manualProfileSelected = false;
  
  /// Cache of device-specific compatibility scores
  final Map<String, Map<String, double>> _deviceCompatibilityCache = {};
  
  /// Cache of configurations that have been dynamically adjusted
  final Map<String, AdapterConfig> _dynamicConfigCache = {};
  
  /// Number of successful commands with a specific config
  final Map<String, int> _configSuccessMap = {};
  
  /// Number of failed commands with a specific config
  final Map<String, int> _configFailureMap = {};
  
  /// NEW: Track metrics about adapter detection over time
  final Map<String, Map<String, dynamic>> _adapterMetricsMap = {};
  
  /// Configuration validator for validating and monitoring adapters
  final AdapterConfigValidator _configValidator = AdapterConfigValidator();
  
  /// Creates a new profile manager
  ProfileManager() {
    _initializeProfiles();
  }
  
  /// Initialize the available profiles
  void _initializeProfiles() {
    _logger.info('Initializing OBD adapter profiles');
    
    // Add the version-specific profiles
    // Order matters: we try more advanced adapters first
    _profiles.add(Elm327V20Profile());
    _profiles.add(Elm327V14Profile());
    _profiles.add(Elm327V13Profile());
    
    // Add the generic profiles for backward compatibility
    _profiles.add(PremiumElm327Profile());
    _profiles.add(CheapElm327Profile());
    
    // Add the dynamic profile
    _profiles.add(_createDynamicProfile());
    
    // Add the mock profile for testing
    _profiles.add(MockAdapterProfile());
    
    _logger.info('Loaded ${_profiles.length} adapter profiles');
  }
  
  /// Create a dynamic profile with auto-adjusting configuration
  AdapterProfile _createDynamicProfile() {
    // Create a dynamic configuration that starts conservative
    // but can be optimized based on adapter performance
    final dynamicConfig = AdapterConfigFactory.createDynamicConfig();
    
    // Validate the dynamic configuration
    final validationResult = _configValidator.validateConfig(dynamicConfig);
    
    if (validationResult['isValid'] as bool) {
      final validatedConfig = validationResult['config'] as AdapterConfig;
      
      // Create a premium profile with this validated dynamic configuration
      return PremiumElm327Profile.withConfig(validatedConfig);
    } else {
      // Log validation issues but continue with the original config
      final issues = validationResult['issues'] as List<String>;
      _logger.warning('Dynamic config validation issues: ${issues.join(', ')}');
      
      // Create a premium profile with the original dynamic configuration
      return PremiumElm327Profile.withConfig(dynamicConfig);
    }
  }
  
  /// Get a list of available profile IDs
  List<String> get availableProfileIds => 
      _profiles.map((profile) => profile.profileId).toList();
  
  /// Get a list of available profiles with names
  List<Map<String, String>> get profilesList => _profiles.map((profile) => {
    'id': profile.profileId,
    'name': profile.adapterName,
  }).toList();
  
  /// Get a profile by ID
  AdapterProfile? getProfile(String profileId) {
    try {
      return _profiles.firstWhere((profile) => profile.profileId == profileId);
    } catch (e) {
      _logger.warning('Profile not found: $profileId');
      return null;
    }
  }
  
  /// Set a specific profile to be used
  ///
  /// This will override automatic profile detection
  void setManualProfile(String profileId) {
    final profile = getProfile(profileId);
    if (profile != null) {
      _lastUsedProfileId = profileId;
      _manualProfileSelected = true;
      _logger.info('Manually selected profile: ${profile.adapterName}');
    } else {
      _logger.warning('Cannot select unknown profile: $profileId');
    }
  }
  
  /// Clear manual profile selection
  ///
  /// This will re-enable automatic profile detection
  void clearManualProfile() {
    _manualProfileSelected = false;
    _logger.info('Cleared manual profile selection, automatic detection enabled');
  }
  
  /// Report a successful command execution with a specific device and profile
  /// 
  /// This is used to track adapter performance with different profiles
  void reportCommandSuccess(String deviceId, String profileId) {
    final cacheKey = '$deviceId:$profileId';
    _configSuccessMap[cacheKey] = (_configSuccessMap[cacheKey] ?? 0) + 1;
    
    // Record runtime metrics for the successful command
    final profile = getProfile(profileId);
    if (profile != null) {
      _configValidator.recordRuntimeMetrics(deviceId, profile.config, {
        'success': true,
        'responseTime': profile.config.responseTimeoutMs ~/ 2, // Estimate based on configured timeout
        'commandDuration': profile.config.commandTimeoutMs ~/ 2, // Estimate based on configured timeout
      });
    }
    
    // If we have sufficient data, update the cached configuration
    _updateDynamicConfigurationIfNeeded(deviceId, profileId);
    
    // NEW: Update metrics tracking for successful connections
    if (_adapterMetricsMap.containsKey(deviceId)) {
      final metrics = _adapterMetricsMap[deviceId]!;
      metrics['successfulConnections'] = (metrics['successfulConnections'] as int) + 1;
      
      // Calculate success rate
      final successfulConnections = metrics['successfulConnections'] as int;
      final failedConnections = metrics['failedConnections'] as int;
      final totalConnections = successfulConnections + failedConnections;
      
      if (totalConnections > 0) {
        final successRate = successfulConnections / totalConnections;
        metrics['successRate'] = successRate;
        
        // Log if success rate is very high or very low
        if (totalConnections >= 10) {
          if (successRate > 0.95) {
            _logger.info('Device $deviceId has excellent success rate: ${(successRate * 100).toStringAsFixed(1)}%');
          } else if (successRate < 0.7) {
            _logger.warning('Device $deviceId has concerning success rate: ${(successRate * 100).toStringAsFixed(1)}%');
          }
        }
      }
    }
  }
  
  /// Report a command failure with a specific device and profile
  ///
  /// This is used to track adapter problems with different profiles
  void reportCommandFailure(String deviceId, String profileId) {
    final cacheKey = '$deviceId:$profileId';
    _configFailureMap[cacheKey] = (_configFailureMap[cacheKey] ?? 0) + 1;
    
    // Record runtime metrics for the failed command
    final profile = getProfile(profileId);
    if (profile != null) {
      _configValidator.recordRuntimeMetrics(deviceId, profile.config, {
        'success': false,
        'timeout': true,
        'responseTime': profile.config.responseTimeoutMs, // Assume timeout
        'commandDuration': profile.config.commandTimeoutMs, // Assume timeout
      });
    }
    
    // If we have too many failures, force a configuration update
    if ((_configFailureMap[cacheKey] ?? 0) > 5) {
      _forceDynamicConfigurationUpdate(deviceId, profileId);
    }
    
    // NEW: Update metrics tracking for failed connections
    if (_adapterMetricsMap.containsKey(deviceId)) {
      final metrics = _adapterMetricsMap[deviceId]!;
      metrics['failedConnections'] = (metrics['failedConnections'] as int) + 1;
      
      // Check for repeated failures with the same profile
      final profileFailures = _configFailureMap[cacheKey] ?? 0;
      
      if (profileFailures >= 3) {
        _logger.warning('Device $deviceId has $profileFailures consecutive failures with profile $profileId');
        
        // If we have metrics history, check if this is potentially the wrong profile
        final history = metrics['detectionHistory'] as List<Map<String, dynamic>>;
        
        if (history.isNotEmpty) {
          final lastDetection = history.last;
          final scores = lastDetection['scores'] as Map<String, double>;
          
          // Get all profiles sorted by score
          final sortedProfiles = scores.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          
          if (sortedProfiles.length > 1 && 
              sortedProfiles.first.key == profileId && 
              sortedProfiles.first.value - sortedProfiles[1].value < 0.15) {
            
            // The chosen profile only marginally beat the second-best profile
            final alternativeProfile = sortedProfiles[1].key;
            _logger.info('Consider trying alternative profile $alternativeProfile '
                      'due to repeated failures with $profileId');
          }
        }
      }
    }
  }
  
  /// Update dynamic configuration based on adapter performance
  void _updateDynamicConfigurationIfNeeded(String deviceId, String profileId) {
    // Try to get an optimized configuration based on runtime metrics
    final optimizedConfig = _configValidator.calculateOptimizedConfig(deviceId, profileId);
    
    if (optimizedConfig != null) {
      // Validate the optimized configuration
      final validationResult = _configValidator.validateConfig(optimizedConfig);
      
      if (validationResult['isValid'] as bool) {
        // Use the validated configuration
        final validatedConfig = validationResult['config'] as AdapterConfig;
        
        // Update the cache with the validated configuration
        _dynamicConfigCache[deviceId] = validatedConfig;
        
        _logger.info('Updated dynamic configuration for device: $deviceId');
        
        // Reset counters
        final cacheKey = '$deviceId:$profileId';
        _configSuccessMap[cacheKey] = 0;
        _configFailureMap[cacheKey] = 0;
      } else {
        // Log validation issues
        final issues = validationResult['issues'] as List<String>;
        _logger.warning('Optimized configuration failed validation: ${issues.join(', ')}');
      }
    }
  }
  
  /// Force an update to a more conservative configuration after too many failures
  void _forceDynamicConfigurationUpdate(String deviceId, String profileId) {
    final cacheKey = '$deviceId:$profileId';
    
    // Get or create a configuration
    AdapterConfig currentConfig;
    if (_dynamicConfigCache.containsKey(deviceId)) {
      currentConfig = _dynamicConfigCache[deviceId]!;
    } else {
      final profile = getProfile(profileId);
      if (profile != null) {
        currentConfig = profile.config;
      } else {
        currentConfig = AdapterConfigFactory.createCheapElm327Config();
      }
    }
    
    // Make it more conservative
    final newConfig = currentConfig.copyWith(
      useExtendedInitDelays: true,
      useLenientParsing: true,
      responseTimeoutMs: _increaseWithLimit(currentConfig.responseTimeoutMs, 50, 300),
      commandTimeoutMs: _increaseWithLimit(currentConfig.commandTimeoutMs, 500, 4000),
      initCommandDelayMs: _increaseWithLimit(currentConfig.initCommandDelayMs, 50, 300),
      resetDelayMs: _increaseWithLimit(currentConfig.resetDelayMs, 100, 1000),
      maxRetries: _increaseWithLimit(currentConfig.maxRetries, 1, 3),
    );
    
    // Validate the new configuration
    final validationResult = _configValidator.validateConfig(newConfig);
    
    if (validationResult['isValid'] as bool) {
      final validatedConfig = validationResult['config'] as AdapterConfig;
      
      _logger.warning('Forced conservative configuration for device $deviceId after multiple failures');
      
      // Update the cache with the validated configuration
      _dynamicConfigCache[deviceId] = validatedConfig;
      
      // Reset failure counter
      _configFailureMap[cacheKey] = 0;
    } else {
      // If validation failed, fall back to the factory default
      _logger.warning('Validation failed for forced configuration update, falling back to factory default');
      _dynamicConfigCache[deviceId] = AdapterConfigFactory.createCheapElm327Config();
      _configFailureMap[cacheKey] = 0;
    }
  }
  
  /// Get a dynamically adjusted configuration for a device
  ///
  /// This now validates the configuration before returning it
  AdapterConfig? getDynamicConfiguration(String deviceId) {
    if (!_dynamicConfigCache.containsKey(deviceId)) {
      return null;
    }
    
    final config = _dynamicConfigCache[deviceId]!;
    
    // Validate the configuration before returning it
    final validationResult = _configValidator.validateConfig(config);
    
    if (validationResult['isValid'] as bool) {
      return validationResult['config'] as AdapterConfig;
    } else {
      // If validation fails, return null and log the issues
      final issues = validationResult['issues'] as List<String>;
      _logger.warning('Dynamic configuration failed validation: ${issues.join(', ')}');
      return null;
    }
  }
  
  /// Helper to decrease a value with a lower limit
  int _decreaseWithLimit(int current, int decreaseAmount, int lowerLimit) {
    return (current - decreaseAmount) < lowerLimit ? lowerLimit : current - decreaseAmount;
  }
  
  /// Helper to increase a value with an upper limit
  int _increaseWithLimit(int current, int increaseAmount, int upperLimit) {
    return (current + increaseAmount) > upperLimit ? upperLimit : current + increaseAmount;
  }
  
  /// Resolve the appropriate profile for a device ID
  ///
  /// This method creates a connection, tests each profile, and returns the best match
  /// Enhanced with more robust detection and caching of results
  Future<AdapterProfile> resolveProfileForDevice(String deviceId, {bool isDebugMode = false}) async {
    _logger.info('Resolving adapter profile for device: $deviceId');
    
    // If a manual profile is selected, use it
    if (_manualProfileSelected && _lastUsedProfileId != null) {
      final profile = getProfile(_lastUsedProfileId!);
      if (profile != null) {
        _logger.info('Using manually selected profile: ${profile.adapterName}');
        
        // If this is the mock profile, we don't need to create a real connection
        if (profile is MockAdapterProfile) {
          return profile;
        }
        
        return profile;
      }
    }
    
    // Check if we're using the mock device ID
    if (deviceId == 'MOCK_DEVICE') {
      _logger.info('Detected mock device ID, using mock profile');
      return _profiles.firstWhere((p) => p is MockAdapterProfile);
    }
    
    // Check the device cache first
    if (_deviceCompatibilityCache.containsKey(deviceId)) {
      final cachedResults = _deviceCompatibilityCache[deviceId]!;
      
      _logger.info('Found cached compatibility results for device: $deviceId');
      
      // Find the profile with the highest compatibility score
      String bestProfileId = _profiles.first.profileId;
      double bestScore = 0;
      
      cachedResults.forEach((profileId, score) {
        if (score > bestScore) {
          bestScore = score;
          bestProfileId = profileId;
        }
      });
      
      // NEW: Apply confidence threshold logic
      final confidenceThreshold = _getConfidenceThreshold(bestProfileId, bestScore);
      _logger.info('Confidence threshold for $bestProfileId: $confidenceThreshold (score: $bestScore)');
      
      // NEW: If the score doesn't exceed the threshold, use a fallback approach
      if (bestScore < confidenceThreshold) {
        _logger.info('Cached best profile score ($bestScore) below confidence threshold ($confidenceThreshold), performing new detection');
        // Clear the cache for this device to force a fresh detection
        _deviceCompatibilityCache.remove(deviceId);
      } else {
        // If we have a dynamic configuration for this device, use it with the best profile
        if (_dynamicConfigCache.containsKey(deviceId)) {
          _logger.info('Using dynamically adjusted configuration for device: $deviceId');
          
          // Create a dynamic profile with the cached configuration
          final dynamicConfig = _dynamicConfigCache[deviceId]!;
          
          // Use premium or cheap profile template based on the best match
          if (bestProfileId == 'premium_elm327') {
            return PremiumElm327Profile.withConfig(dynamicConfig);
          } else {
            return CheapElm327Profile.withConfig(dynamicConfig);
          }
        }
        
        // Otherwise, use the cached best profile
        final bestProfile = getProfile(bestProfileId);
        if (bestProfile != null) {
          _logger.info('Using cached best profile: ${bestProfile.adapterName} (score: $bestScore)');
          return bestProfile;
        }
      }
    }
    
    // Try to use the last successfully used profile first
    if (_lastUsedProfileId != null) {
      final lastProfile = getProfile(_lastUsedProfileId!);
      if (lastProfile != null) {
        _logger.info('Trying last used profile: ${lastProfile.adapterName}');
        final connection = BluetoothConnection(deviceId, isDebugMode: isDebugMode);
        
        // Test if the connection still works with this profile
        final compatibility = await _testProfileCompatibility(lastProfile, connection);
        await connection.disconnect();
        
        // NEW: Apply confidence threshold logic for last used profile
        final confidenceThreshold = _getConfidenceThreshold(lastProfile.profileId, compatibility) * 0.9;
        
        if (compatibility > confidenceThreshold) {
          _logger.info('Last used profile is still compatible (score: $compatibility, threshold: $confidenceThreshold)');
          return lastProfile;
        }
      }
    }
    
    // Create a new connection for testing
    final connection = BluetoothConnection(deviceId, isDebugMode: isDebugMode);
    
    try {
      // Connect to the device
      final connected = await connection.connect();
      if (!connected) {
        _logger.warning('Failed to connect to device for profile testing');
        // Fall back to the cheap profile for compatibility
        return _profiles.firstWhere((p) => p is CheapElm327Profile);
      }
      
      // Test each profile and find the best match
      final results = <String, double>{};
      
      // NEW: Use two passes for better discrimination
      // First pass: test the most likely profiles based on previous experience
      final profilesFirstPass = <AdapterProfile>[];
      final profilesSecondPass = <AdapterProfile>[];
      
      // Sort profiles by likelihood based on previous success
      for (final profile in _profiles) {
        // Skip the mock profile for real devices
        if (profile is MockAdapterProfile) {
          continue;
        }
        
        // Prioritize known profiles
        if (_lastUsedProfileId == profile.profileId) {
          profilesFirstPass.insert(0, profile);
        } else if (profile.profileId == 'premium_elm327') {
          profilesFirstPass.add(profile);
        } else if (profile.profileId == 'cheap_elm327') {
          profilesFirstPass.add(profile);
        } else {
          profilesSecondPass.add(profile);
        }
      }
      
      // Test first pass profiles
      for (final profile in profilesFirstPass) {
        _logger.info('Testing compatibility with profile (first pass): ${profile.adapterName}');
        
        // Enhanced profile testing with multiple specific tests
        final compatibility = await _enhancedProfileTesting(profile, connection);
        results[profile.profileId] = compatibility;
        
        _logger.info('Profile ${profile.adapterName} compatibility score: $compatibility');
      }
      
      // Find the best profile from first pass
      String bestProfileId = '';
      double bestScore = 0;
      
      results.forEach((profileId, score) {
        if (score > bestScore) {
          bestScore = score;
          bestProfileId = profileId;
        }
      });
      
      // Check if first pass found a highly confident match
      final confidenceThreshold = _getConfidenceThreshold(bestProfileId, bestScore);
      
      if (bestScore >= confidenceThreshold && bestProfileId.isNotEmpty) {
        _logger.info('Found high confidence match in first pass: $bestProfileId (score: $bestScore)');
      } else {
        // If first pass didn't find a confident match, try second pass
        _logger.info('First pass did not yield confident result, trying additional profiles');
        
        for (final profile in profilesSecondPass) {
          _logger.info('Testing compatibility with profile (second pass): ${profile.adapterName}');
          
          final compatibility = await _enhancedProfileTesting(profile, connection);
          results[profile.profileId] = compatibility;
          
          _logger.info('Profile ${profile.adapterName} compatibility score: $compatibility');
        }
      }
      
      // Find the profile with the highest compatibility score from all results
      bestProfileId = '';
      bestScore = 0;
      
      results.forEach((profileId, score) {
        if (score > bestScore) {
          bestScore = score;
          bestProfileId = profileId;
        }
      });
      
      // Cache the results for future use
      _deviceCompatibilityCache[deviceId] = results;
      
      // Get the best profile
      final bestProfile = bestProfileId.isNotEmpty 
          ? getProfile(bestProfileId)!
          : _profiles.firstWhere((p) => p is CheapElm327Profile);
      
      // NEW: Add adapter type classification based on scoring patterns
      final adapterClassification = _classifyAdapter(results);
      _logger.info('Adapter classification: $adapterClassification');
      
      // NEW: Track metrics for this detection
      _trackAdapterMetrics(deviceId, results, bestProfileId, adapterClassification);
      
      _logger.info('Selected best profile: ${bestProfile.adapterName} (score: $bestScore, classification: $adapterClassification)');
      
      // Remember this profile for next time
      _lastUsedProfileId = bestProfileId;
      
      return bestProfile;
    } finally {
      // Always disconnect when done testing
      await connection.disconnect();
    }
  }
  
  /// NEW: Determine the appropriate confidence threshold for a profile
  double _getConfidenceThreshold(String profileId, double score) {
    // Different profiles require different confidence thresholds
    switch (profileId) {
      case 'premium_elm327':
        // Premium adapters need higher confidence due to optimizations
        return 0.65;
      case 'cheap_elm327':
        // Cheap adapter can use a lower threshold as it's more conservative
        return 0.4;
      default:
        // Default threshold for other profiles
        return 0.5;
    }
  }
  
  /// NEW: Classify the adapter based on scoring patterns
  String _classifyAdapter(Map<String, double> results) {
    final premiumScore = results['premium_elm327'] ?? 0.0;
    final cheapScore = results['cheap_elm327'] ?? 0.0;
    
    // Calculate the difference and ratio between scores
    final difference = premiumScore - cheapScore;
    final ratio = premiumScore > 0 ? cheapScore / premiumScore : 0.0;
    
    if (premiumScore > 0.75 && difference > 0.3) {
      return 'Definite Premium Adapter';
    } else if (premiumScore > 0.6 && difference > 0.2) {
      return 'Likely Premium Adapter';
    } else if (cheapScore > 0.75 && difference < -0.3) {
      return 'Definite Cheap Adapter';
    } else if (cheapScore > 0.6 && difference < -0.2) {
      return 'Likely Cheap Adapter';
    } else if (ratio > 0.85 && ratio < 1.15) {
      return 'Hybrid/Ambiguous Adapter';
    } else if (premiumScore < 0.4 && cheapScore < 0.4) {
      return 'Unknown/Problematic Adapter';
    } else {
      return 'Standard Adapter';
    }
  }
  
  /// Enhanced profile testing with specific adapter tests
  Future<double> _enhancedProfileTesting(AdapterProfile profile, ObdConnection connection) async {
    _logger.info('Running enhanced compatibility tests for profile: ${profile.profileId}');
    
    try {
      // First do the standard compatibility test
      final basicCompatibility = await _testProfileCompatibility(profile, connection);
      
      // If extremely low compatibility, don't bother with other tests
      if (basicCompatibility < 0.2) {
        return basicCompatibility;
      }
      
      // Run specific compatibility tests to better differentiate adapters
      final testResults = <double>[];
      
      // Test 1: Response time test (more important)
      final responseTimeScore = await _testResponseTime(connection, profile);
      testResults.add(responseTimeScore);
      
      // Test 2: Protocol support test
      final protocolSupportScore = await _testProtocolSupport(connection, profile);
      testResults.add(protocolSupportScore);
      
      // Test 3: Command format test (more important)
      final commandFormatScore = await _testCommandFormat(connection, profile);
      testResults.add(commandFormatScore);
      
      // Test 4: Advanced features test (new)
      final advancedFeaturesScore = await _testAdvancedFeatures(connection, profile);
      testResults.add(advancedFeaturesScore);
      
      // Test 5: Stability test (new)
      final stabilityScore = await _testStability(connection, profile);
      testResults.add(stabilityScore);
      
      // NEW Test 6: Protocol reset response test
      final protocolResetScore = await _testProtocolReset(connection, profile);
      testResults.add(protocolResetScore);

      // NEW Test 7: Data consistency test
      final dataConsistencyScore = await _testDataConsistency(connection, profile);
      testResults.add(dataConsistencyScore);
      
      // NEW Test 8: Multi-frame message handling
      final multiFrameScore = await _testMultiFrameMessages(connection, profile);
      testResults.add(multiFrameScore);
      
      // Calculate final score as weighted average with refined weights
      final finalScore = (basicCompatibility * 0.15) +         // Basic compatibility (reduced from 20% to 15%)
                         (responseTimeScore * 0.20) +           // Response time test (reduced from 25% to 20%)
                         (protocolSupportScore * 0.10) +        // Protocol support test (reduced from 15% to 10%)
                         (commandFormatScore * 0.15) +          // Command format test (reduced from 20% to 15%)
                         (advancedFeaturesScore * 0.10) +       // Advanced features test (unchanged at 10%)
                         (stabilityScore * 0.10) +              // Stability test (unchanged at 10%)
                         (protocolResetScore * 0.05) +          // NEW Protocol reset test (5%)
                         (dataConsistencyScore * 0.10) +        // NEW Data consistency test (10%)
                         (multiFrameScore * 0.05);              // NEW Multi-frame message test (5%)
      
      _logger.info('Enhanced compatibility scores for ${profile.profileId}: ' 
                  'basic=$basicCompatibility, response=$responseTimeScore, ' 
                  'protocol=$protocolSupportScore, format=$commandFormatScore, ' 
                  'advanced=$advancedFeaturesScore, stability=$stabilityScore, '
                  'reset=$protocolResetScore, consistency=$dataConsistencyScore, '
                  'multiframe=$multiFrameScore, final=$finalScore');
      
      // For cheap_elm327 profile, always ensure minimum compatibility
      // This guarantees that the cheap adapter profile is always a fallback option
      if (profile.profileId == 'cheap_elm327' && finalScore < 0.4) {
        final adjustedScore = 0.4;
        _logger.info('Adjusting cheap adapter score from $finalScore to $adjustedScore to ensure fallback compatibility');
        return adjustedScore;
      }
      
      return finalScore;
    } catch (e) {
      _logger.warning('Error during enhanced profile testing: $e');
      
      // If an error occurs during testing, ensure the cheap profile gets a minimum score
      // to serve as a fallback option
      if (profile.profileId == 'cheap_elm327') {
        return 0.4;  // Ensure cheap profile is always viable as fallback
      }
      
      return 0.1;  // Low score for other profiles if testing fails
    }
  }
  
  /// Test the adapter's response time
  Future<double> _testResponseTime(ObdConnection connection, AdapterProfile profile) async {
    try {
      // Take multiple measurements for more accuracy
      final measurements = <int>[];
      final numTests = 3;
      
      for (int i = 0; i < numTests; i++) {
        // Measure response time for a simple command
        final stopwatch = Stopwatch()..start();
        
        // Send a simple command and wait for response
        await _sendCommandWithResponse(connection, i == 0 ? 'AT@1' : i == 1 ? 'ATI' : 'ATE0', timeout: 1000);
        
        // Stop timer
        stopwatch.stop();
        measurements.add(stopwatch.elapsedMilliseconds);
        
        // Small delay between tests
        await Future.delayed(Duration(milliseconds: 50));
      }
      
      // Calculate median response time (more robust than average)
      measurements.sort();
      final responseTime = measurements[measurements.length ~/ 2];
      
      _logger.info('Response time for ${profile.profileId}: $responseTime ms (median of $measurements)');
      
      // Score based on response time with more granular scoring
      // For premium adapters, we expect faster responses
      if (profile.profileId == 'premium_elm327') {
        if (responseTime < 50) return 1.0;    // Extremely fast (was < 100)
        if (responseTime < 100) return 0.9;   // Very fast (new category)
        if (responseTime < 150) return 0.8;   // Fast (was < 200)
        if (responseTime < 200) return 0.7;   // Moderately fast (new category)
        if (responseTime < 250) return 0.6;   // Average (was < 300)
        if (responseTime < 300) return 0.5;   // Below average (new category)
        if (responseTime < 400) return 0.4;   // Slow (was < 500)
        if (responseTime < 500) return 0.3;   // Very slow (new category)
        return 0.2;                           // Extremely slow
      } else {
        // For cheap adapters, we're more forgiving
        if (responseTime < 150) return 1.0;   // Extremely fast for cheap adapter (was < 200)
        if (responseTime < 250) return 0.9;   // Very fast (new category)
        if (responseTime < 350) return 0.8;   // Fast (was < 400)
        if (responseTime < 450) return 0.7;   // Moderately fast (new category)
        if (responseTime < 550) return 0.6;   // Average (was < 600)
        if (responseTime < 650) return 0.5;   // Below average (new category)
        if (responseTime < 750) return 0.4;   // Slow (was < 800)
        if (responseTime < 850) return 0.3;   // Very slow (new category)
        return 0.2;                           // Extremely slow
      }
    } catch (e) {
      _logger.warning('Error testing response time: $e');
      return 0.0;
    }
  }
  
  /// Test protocol support
  Future<double> _testProtocolSupport(ObdConnection connection, AdapterProfile profile) async {
    try {
      // Try to set specific protocol
      final response = await _sendCommandWithResponse(connection, 'ATSP5', timeout: 1000);
      
      if (response.contains('OK')) {
        return 1.0;
      } else if (response.contains('?')) {
        return 0.3;  // Protocol command not supported
      } else if (response.isEmpty) {
        return 0.1;  // No response
      } else {
        return 0.5;  // Some response, but not OK
      }
    } catch (e) {
      _logger.warning('Error testing protocol support: $e');
      return 0.0;
    }
  }
  
  /// Test command format handling
  Future<double> _testCommandFormat(ObdConnection connection, AdapterProfile profile) async {
    try {
      // Test standard OBD protocol command
      final response = await _sendCommandWithResponse(connection, '0100', timeout: 1000);
      
      double score = 0.0;
      
      // Premium adapters should format responses correctly
      if (profile.profileId == 'premium_elm327') {
        if (response.contains('41 00')) score += 0.7;
        if (response.contains('41 00') && response.contains('>')) score += 0.3;
        if (response.contains('NO DATA') || response.contains('ERROR')) score -= 0.5;
      } else {
        // Cheap adapters might return data in various formats
        if (response.contains('41 00') || response.contains('4100')) score += 0.5;
        if (response.contains('>')) score += 0.2;
        if (response.contains('41')) score += 0.3;
        if (response.contains('NO DATA') || response.contains('ERROR')) score -= 0.3;
      }
      
      return math.max(0.0, score);
    } catch (e) {
      _logger.warning('Error testing command format: $e');
      return 0.0;
    }
  }
  
  /// Send a command and wait for a response with timeout
  Future<String> _sendCommandWithResponse(ObdConnection connection, String command, {int timeout = 2000}) async {
    final completer = Completer<String>();
    late StreamSubscription subscription;
    String buffer = '';
    
    // Set up a timeout
    final timer = Timer(Duration(milliseconds: timeout), () {
      if (!completer.isCompleted) {
        completer.complete(buffer);
        subscription.cancel();
      }
    });
    
    // Listen for responses
    subscription = connection.dataStream.listen((data) {
      buffer += data;
      
      // Complete when we get a prompt or enough data
      if (data.contains('>') || buffer.length > 30) {
        if (!completer.isCompleted) {
          completer.complete(buffer);
          timer.cancel();
          subscription.cancel();
        }
      }
    });
    
    // Send the command
    await connection.sendCommand(command);
    
    return await completer.future;
  }
  
  /// Test an adapter's compatibility with a specific profile
  Future<double> _testProfileCompatibility(AdapterProfile profile, ObdConnection connection) async {
    try {
      // Test the profile's compatibility
      return await profile.testCompatibility(connection);
    } catch (e) {
      _logger.warning('Error testing profile ${profile.profileId}: $e');
      return 0.0;
    }
  }
  
  /// Test advanced adapter features that only premium adapters typically support
  Future<double> _testAdvancedFeatures(ObdConnection connection, AdapterProfile profile) async {
    try {
      _logger.info('Testing advanced features for ${profile.profileId}');
      
      // Counter for supported advanced commands
      int supportedCommands = 0;
      int totalCommands = 6; // Increased from 4 to 6
      
      // Test 1: Describe Protocol (ATDESC)
      final protocolDescResponse = await _sendCommandWithResponse(connection, 'ATDESC', timeout: 500);
      if (!protocolDescResponse.contains('?') && protocolDescResponse.isNotEmpty) {
        supportedCommands++;
      }
      
      // Test 2: Read Voltage (ATRV)
      final voltageResponse = await _sendCommandWithResponse(connection, 'ATRV', timeout: 500);
      if (voltageResponse.contains('.') && !voltageResponse.contains('?')) {
        supportedCommands++;
      }
      
      // Test 3: OBD Requirements (ATI3)
      final obdReqResponse = await _sendCommandWithResponse(connection, 'ATI3', timeout: 500);
      if (!obdReqResponse.contains('?') && obdReqResponse.length > 5) {
        supportedCommands++;
      }
      
      // Test 4: Protocol Auto (ATSP0)
      final protocolAutoResponse = await _sendCommandWithResponse(connection, 'ATSP0', timeout: 500);
      if (protocolAutoResponse.contains('OK')) {
        supportedCommands++;
      }
      
      // NEW Test 5: Monitor status (AT MS)
      final monitorStatusResponse = await _sendCommandWithResponse(connection, 'AT MS', timeout: 500);
      if (!monitorStatusResponse.contains('?') && monitorStatusResponse.length > 2) {
        supportedCommands++;
      }
      
      // NEW Test 6: Programmable parameter control (ATPP)
      final programmableParamResponse = await _sendCommandWithResponse(connection, 'ATPP00 SV 00', timeout: 500);
      if (!programmableParamResponse.contains('?') && !programmableParamResponse.contains('ERROR')) {
        supportedCommands++;
      }
      
      // Calculate score based on supported commands
      final score = supportedCommands / totalCommands;
      
      _logger.info('Advanced features score for ${profile.profileId}: $score ($supportedCommands/$totalCommands)');
      
      // Adjust scoring based on profile expectations
      // Premium adapters are expected to support more features
      if (profile.profileId == 'premium_elm327') {
        // For premium profile, low feature support should be penalized more
        return score < 0.5 ? score * 0.5 : score;
      } else {
        // For cheap adapters, feature support is a bonus but not expected
        return score * 0.7 + 0.3; // Minimum 0.3 score for cheap adapters
      }
    } catch (e) {
      _logger.warning('Error testing advanced features: $e');
      
      // For cheap adapters, failure is not critical
      return profile.profileId == 'cheap_elm327' ? 0.5 : 0.1;
    }
  }
  
  /// Test adapter stability by sending multiple commands in quick succession
  Future<double> _testStability(ObdConnection connection, AdapterProfile profile) async {
    try {
      _logger.info('Testing stability for ${profile.profileId}');
      
      // Number of successful commands
      int successfulCommands = 0;
      // Total number of commands to test
      final totalCommands = 5;
      
      // Simple command sequence
      final commands = [
        'ATE0', // Echo off
        'ATL0', // Linefeeds off
        'ATH0', // Headers off
        'ATS0', // Spaces off
        'ATI',  // Identify
      ];
      
      // Send commands with minimal delay and count successful responses
      for (final command in commands) {
        final response = await _sendCommandWithResponse(
          connection, 
          command, 
          timeout: profile.profileId == 'premium_elm327' ? 300 : 600
        );
        
        if (response.isNotEmpty && !response.contains('?') && (response.contains('OK') || response.contains('ELM'))) {
          successfulCommands++;
        }
        
        // Add minimal delay between commands to test stability
        await Future.delayed(Duration(milliseconds: 50));
      }
      
      // Calculate score based on successful commands
      final score = successfulCommands / totalCommands;
      
      _logger.info('Stability score for ${profile.profileId}: $score ($successfulCommands/$totalCommands)');
      
      // Adjust score based on profile expectations
      if (profile.profileId == 'premium_elm327') {
        // Premium adapters should have high stability
        return score < 0.8 ? score * 0.6 : score;
      } else {
        // Cheap adapters get more lenient scoring for stability
        return score * 0.7 + 0.3; // Minimum 0.3 score
      }
      
    } catch (e) {
      _logger.warning('Error testing stability: $e');
      
      // For cheap adapters, failure is not critical
      return profile.profileId == 'cheap_elm327' ? 0.5 : 0.1;
    }
  }
  
  /// NEW: Test protocol reset behavior
  /// Premium adapters tend to have more consistent reset behavior
  Future<double> _testProtocolReset(ObdConnection connection, AdapterProfile profile) async {
    try {
      _logger.info('Testing protocol reset behavior for ${profile.profileId}');
      
      // Reset and observe the response quality
      await connection.sendCommand('ATZ');
      await Future.delayed(Duration(milliseconds: profile.resetDelayMs));
      
      // Create a buffer for the response
      String responseBuffer = '';
      int timeoutMs = 500;
      
      // Listen to response with timeout
      final completer = Completer<String>();
      late StreamSubscription subscription;
      
      subscription = connection.dataStream.listen((data) {
        responseBuffer += data;
        
        // Complete when we get a prompt or enough data
        if (data.contains('>') || responseBuffer.contains('ELM327')) {
          if (!completer.isCompleted) {
            completer.complete(responseBuffer);
            subscription.cancel();
          }
        }
      });
      
      // Set timeout
      final timer = Timer(Duration(milliseconds: timeoutMs), () {
        if (!completer.isCompleted) {
          completer.complete(responseBuffer);
          subscription.cancel();
        }
      });
      
      try {
        responseBuffer = await completer.future;
      } finally {
        timer.cancel();
      }
      
      // Analyze reset response
      double score = 0.0;
      
      // Premium adapters typically show version number after reset
      if (responseBuffer.contains('v1.5') || 
          responseBuffer.contains('v2.1') || 
          responseBuffer.contains('v2.2') || 
          responseBuffer.contains('v2.3')) {
        score += 0.5;
      }
      
      // Clear formatting indicates a premium adapter
      if (responseBuffer.contains('\r\n') && responseBuffer.contains('>')) {
        score += 0.3;
      }
      
      // Complete response with prompt
      if (responseBuffer.contains('ELM327') && responseBuffer.contains('>')) {
        score += 0.2;
      }
      
      // Normalize score
      score = score > 1.0 ? 1.0 : score;
      
      _logger.info('Protocol reset score for ${profile.profileId}: $score');
      
      return score;
    } catch (e) {
      _logger.warning('Error testing protocol reset: $e');
      return profile.profileId == 'cheap_elm327' ? 0.5 : 0.1;
    }
  }
  
  /// NEW: Test data consistency by requesting the same data multiple times
  Future<double> _testDataConsistency(ObdConnection connection, AdapterProfile profile) async {
    try {
      _logger.info('Testing data consistency for ${profile.profileId}');
      
      final testCommand = '0100'; // Mode 01, PID 00 (supported PIDs)
      final results = <String>[];
      
      // Send the same command 3 times
      for (int i = 0; i < 3; i++) {
        final response = await _sendCommandWithResponse(connection, testCommand, timeout: profile.responseTimeoutMs * 2);
        results.add(response);
        await Future.delayed(Duration(milliseconds: 100));
      }
      
      // Analyze consistency
      double score = 0.0;
      
      // Check if responses are consistently formatted
      bool allHavePrompt = results.every((r) => r.contains('>'));
      bool allHaveResponse = results.every((r) => r.contains('41 00') || r.contains('4100'));
      
      // Check for consistent response lengths
      int maxLengthDiff = 0;
      for (int i = 0; i < results.length - 1; i++) {
        int diff = (results[i].length - results[i+1].length).abs();
        maxLengthDiff = diff > maxLengthDiff ? diff : maxLengthDiff;
      }
      
      // Premium adapters should have very consistent responses
      if (profile.profileId == 'premium_elm327') {
        if (allHavePrompt) score += 0.3;
        if (allHaveResponse) score += 0.3;
        if (maxLengthDiff < 5) score += 0.4;
        if (maxLengthDiff < 10 && maxLengthDiff >= 5) score += 0.2;
      } else {
        // Cheap adapters get more lenient scoring
        if (allHavePrompt) score += 0.2;
        if (allHaveResponse) score += 0.3;
        if (maxLengthDiff < 10) score += 0.3;
        if (maxLengthDiff < 20 && maxLengthDiff >= 10) score += 0.2;
      }
      
      // Normalize score
      score = score > 1.0 ? 1.0 : score;
      
      _logger.info('Data consistency score for ${profile.profileId}: $score (maxDiff: $maxLengthDiff)');
      
      return score;
    } catch (e) {
      _logger.warning('Error testing data consistency: $e');
      return profile.profileId == 'cheap_elm327' ? 0.5 : 0.1;
    }
  }
  
  /// NEW: Test multi-frame message handling
  /// Premium adapters typically handle multi-frame messages better
  Future<double> _testMultiFrameMessages(ObdConnection connection, AdapterProfile profile) async {
    try {
      _logger.info('Testing multi-frame message handling for ${profile.profileId}');
      
      // Request VIN (Vehicle Identification Number) which typically requires multiple frames
      final response = await _sendCommandWithResponse(connection, '0902', timeout: profile.responseTimeoutMs * 3);
      
      double score = 0.0;
      
      // Premium adapters should handle these messages correctly
      if (profile.profileId == 'premium_elm327') {
        // Check for proper multi-line response format
        if (response.contains('49 02')) score += 0.4;
        
        // Check for multi-line response lines
        final lines = response.split('\r').where((l) => l.trim().isNotEmpty).toList();
        if (lines.length > 1) score += 0.3;
        
        // Check for completion indicator
        if (response.contains('>')) score += 0.3;
      } else {
        // More lenient scoring for cheap adapters
        if (response.contains('49') || response.contains('49 02') || response.contains('4902')) score += 0.4;
        if (!response.contains('?') && !response.contains('ERROR')) score += 0.3;
        if (response.contains('>')) score += 0.3;
      }
      
      // Normalize score
      score = score > 1.0 ? 1.0 : score;
      
      _logger.info('Multi-frame message score for ${profile.profileId}: $score');
      
      return score;
    } catch (e) {
      _logger.warning('Error testing multi-frame messages: $e');
      return profile.profileId == 'cheap_elm327' ? 0.5 : 0.1;
    }
  }
  
  /// Create a protocol handler for a device using the best matching profile
  /// with a progressive enhancement approach
  ///
  /// This method determines the appropriate profile and creates a protocol
  /// with progressive enhancement based on observed adapter behavior
  Future<ObdProtocol> createProtocolForDevice(String deviceId, {bool isDebugMode = false}) async {
    _logger.info('Creating protocol for device: $deviceId');
    
    // Handle mock device special case
    if (deviceId == 'MOCK_DEVICE') {
      _logger.info('Detected mock device ID, using mock profile');
      final mockProfile = _profiles.firstWhere((p) => p is MockAdapterProfile);
      final connection = MockConnection();
      return await mockProfile.createProtocol(connection, isDebugMode: isDebugMode);
    }
    
    // Get the profile to try first
    AdapterProfile primaryProfile;
    AdapterProfile fallbackProfile;
    
    // Always set the cheap adapter as the fallback profile for reliability
    try {
      fallbackProfile = _profiles.firstWhere((p) => p.profileId == 'cheap_elm327');
    } catch (e) {
      _logger.severe('Could not find cheap_elm327 fallback profile: $e');
      // Create a default fallback profile if none exists
      fallbackProfile = CheapElm327Profile();
    }
    
    // If a manual profile is selected, use it as primary
    if (_manualProfileSelected && _lastUsedProfileId != null) {
      final profile = getProfile(_lastUsedProfileId!);
      if (profile != null) {
        _logger.info('Using manually selected profile: ${profile.adapterName}');
        primaryProfile = profile;
      } else {
        // Fallback to auto-detection if manual profile not found
        primaryProfile = await resolveProfileForDevice(deviceId, isDebugMode: isDebugMode);
      }
    } else {
      // Auto-detect the profile
      primaryProfile = await resolveProfileForDevice(deviceId, isDebugMode: isDebugMode);
    }
    
    // Check for dynamic configuration for this device
    AdapterConfig? dynamicConfig = _dynamicConfigCache[deviceId];
    
    // If we have a dynamic configuration, use it with the primary profile
    if (dynamicConfig != null) {
      _logger.info('Using dynamically adjusted configuration for device: $deviceId');
      
      // Create a connection
      final connection = BluetoothConnection(deviceId, isDebugMode: isDebugMode);
      final connected = await connection.connect();
      
      if (connected) {
        // Create a protocol with the dynamic configuration
        try {
          return Elm327Protocol(
            connection,
            isDebugMode: isDebugMode,
            adapterProfile: primaryProfile.profileId,
            adapterConfig: dynamicConfig,
            profileManager: this,
            deviceId: deviceId,
          );
        } catch (e) {
          _logger.warning('Failed to create protocol with dynamic configuration: $e');
          // If dynamic configuration fails, continue to normal flow
          await connection.disconnect();
        }
      }
    }
    
    // Try connecting with the primary profile
    final protocol = await _tryConnectWithProfile(primaryProfile, deviceId, isDebugMode: isDebugMode);
    if (protocol != null) {
      return protocol;
    }
    
    // If primary profile failed and it's not the cheap profile,
    // explicitly try the cheap profile as fallback
    if (primaryProfile.profileId != 'cheap_elm327') {
      _logger.info('Primary profile failed, trying cheap_elm327 as fallback');
      final fallbackProtocol = await _tryConnectWithProfile(fallbackProfile, deviceId, isDebugMode: isDebugMode);
      if (fallbackProtocol != null) {
        return fallbackProtocol;
      }
    }
    
    // All profile attempts failed, use the generic implementation with the cheap profile config
    // This is a last resort attempt with the most conservative settings
    _logger.warning('All profiles failed, using fallback implementation with cheap profile config');
    final connection = BluetoothConnection(deviceId, isDebugMode: isDebugMode);
    
    if (await connection.connect()) {
      final cheapConfig = AdapterConfigFactory.createCheapElm327Config();
      return Elm327Protocol(
        connection,
        isDebugMode: isDebugMode,
        adapterProfile: 'cheap_elm327',
        adapterConfig: cheapConfig,
        profileManager: this,
        deviceId: deviceId,
      );
    }
    
    throw Exception('Failed to connect with any profile');
  }
  
  /// Helper method to try connecting with a specific profile
  Future<ObdProtocol?> _tryConnectWithProfile(AdapterProfile profile, String deviceId, {bool isDebugMode = false}) async {
    _logger.info('Trying to connect with profile: ${profile.adapterName}');
    
    final connection = BluetoothConnection(deviceId, isDebugMode: isDebugMode);
    final connected = await connection.connect();
    
    if (connected) {
      _logger.info('Connected with profile: ${profile.adapterName}');
      
      try {
        // Create protocol with the profile
        return await profile.createProtocol(
          connection,
          isDebugMode: isDebugMode,
          profileManager: this,
          deviceId: deviceId,
        );
      } catch (e) {
        _logger.warning('Error creating protocol with ${profile.adapterName}: $e');
        await connection.disconnect();
        return null;
      }
    } else {
      _logger.warning('Failed to connect with profile: ${profile.adapterName}');
      return null;
    }
  }
  
  /// NEW: Track adapter detection metrics for improving detection over time
  void _trackAdapterMetrics(String deviceId, Map<String, double> results, String selectedProfileId, String classification) {
    // Initialize metrics for this device if not already present
    if (!_adapterMetricsMap.containsKey(deviceId)) {
      _adapterMetricsMap[deviceId] = {
        'detectionCount': 0,
        'lastDetectionTime': DateTime.now().millisecondsSinceEpoch,
        'detectionHistory': <Map<String, dynamic>>[],
        'successfulConnections': 0,
        'failedConnections': 0,
        'profileSuccessMap': <String, int>{},
        'classification': <String, int>{},
      };
    }
    
    final metrics = _adapterMetricsMap[deviceId]!;
    
    // Update basic metrics
    metrics['detectionCount'] = (metrics['detectionCount'] as int) + 1;
    metrics['lastDetectionTime'] = DateTime.now().millisecondsSinceEpoch;
    
    // Track this detection in history (limited to last 10)
    final history = metrics['detectionHistory'] as List<Map<String, dynamic>>;
    history.add({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'scores': Map<String, double>.from(results),
      'selectedProfile': selectedProfileId,
      'classification': classification,
    });
    
    // Keep history limited to last 10 entries
    if (history.length > 10) {
      history.removeAt(0);
    }
    
    // Update classification counts
    final classificationMap = metrics['classification'] as Map<String, int>;
    classificationMap[classification] = (classificationMap[classification] ?? 0) + 1;
    
    // Track success rates by profile
    final profileSuccessMap = metrics['profileSuccessMap'] as Map<String, int>;
    profileSuccessMap[selectedProfileId] = (profileSuccessMap[selectedProfileId] ?? 0) + 1;
    
    _logger.info('Updated adapter metrics for device: $deviceId (detection #${metrics['detectionCount']})');
    
    // Analyze metrics for potential improvements
    _analyzeMetricsForImprovements(deviceId);
  }
  
  /// NEW: Analyze adapter metrics to suggest potential improvements
  void _analyzeMetricsForImprovements(String deviceId) {
    if (!_adapterMetricsMap.containsKey(deviceId)) {
      return;
    }
    
    final metrics = _adapterMetricsMap[deviceId]!;
    final detectionCount = metrics['detectionCount'] as int;
    
    // Only analyze if we have enough data
    if (detectionCount < 3) {
      return;
    }
    
    final history = metrics['detectionHistory'] as List<Map<String, dynamic>>;
    final classificationMap = metrics['classification'] as Map<String, int>;
    
    // Check for classification consistency
    final classifications = classificationMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (classifications.isNotEmpty) {
      final mostCommon = classifications.first;
      final mostCommonPercentage = mostCommon.value / detectionCount;
      
      // If classification is consistent, we might want to optimize thresholds
      if (mostCommonPercentage > 0.7) {
        _logger.info('Device $deviceId consistently classified as ${mostCommon.key} '
                    '(${(mostCommonPercentage * 100).toStringAsFixed(1)}% of detections)');
        
        // Look for score patterns
        if (history.length >= 3) {
          // Calculate average scores for each profile
          final avgScores = <String, double>{};
          
          for (final entry in history) {
            final scores = entry['scores'] as Map<String, double>;
            scores.forEach((profile, score) {
              if (!avgScores.containsKey(profile)) {
                avgScores[profile] = 0;
              }
              avgScores[profile] = avgScores[profile]! + score;
            });
          }
          
          // Calculate averages
          avgScores.forEach((profile, total) {
            avgScores[profile] = total / history.length;
          });
          
          _logger.info('Average detection scores for device $deviceId: $avgScores');
          
          // Look for potential threshold adjustments
          final premiumAvg = avgScores['premium_elm327'] ?? 0;
          final cheapAvg = avgScores['cheap_elm327'] ?? 0;
          
          if (mostCommon.key.contains('Premium') && premiumAvg < 0.7) {
            _logger.info('Device consistently classified as Premium but with low scores. '
                        'Consider adjusting premium detection thresholds.');
          } else if (mostCommon.key.contains('Cheap') && cheapAvg < 0.5) {
            _logger.info('Device consistently classified as Cheap but with low scores. '
                        'Consider adjusting cheap adapter detection thresholds.');
          }
        }
      } else if (mostCommonPercentage < 0.5) {
        _logger.warning('Device $deviceId has inconsistent classification patterns. '
                      'This may indicate a non-standard adapter or detection issues.');
      }
    }
  }
  
  /// NEW: Get adapter metrics summary for a device
  Map<String, dynamic> getAdapterMetricsSummary(String deviceId) {
    if (!_adapterMetricsMap.containsKey(deviceId)) {
      return {'deviceId': deviceId, 'message': 'No metrics available for this device'};
    }
    
    final metrics = _adapterMetricsMap[deviceId]!;
    final detectionHistory = metrics['detectionHistory'] as List<Map<String, dynamic>>;
    final classifications = metrics['classification'] as Map<String, int>;
    
    // Calculate the most common classification
    String? mostCommonClassification;
    int highestCount = 0;
    
    classifications.forEach((classification, count) {
      if (count > highestCount) {
        highestCount = count;
        mostCommonClassification = classification;
      }
    });
    
    // Calculate success rate
    final successfulConnections = metrics['successfulConnections'] as int;
    final failedConnections = metrics['failedConnections'] as int;
    final totalConnections = successfulConnections + failedConnections;
    final successRate = totalConnections > 0 
        ? successfulConnections / totalConnections 
        : 0.0;
    
    // Create a summary
    return {
      'deviceId': deviceId,
      'detectionCount': metrics['detectionCount'],
      'mostRecentDetection': DateTime.fromMillisecondsSinceEpoch(
          metrics['lastDetectionTime'] as int
      ).toString(),
      'mostCommonClassification': mostCommonClassification,
      'successRate': '${(successRate * 100).toStringAsFixed(1)}%',
      'totalConnections': totalConnections,
      'recentDetections': detectionHistory.map((h) => {
        'timestamp': DateTime.fromMillisecondsSinceEpoch(h['timestamp'] as int).toString(),
        'selectedProfile': h['selectedProfile'],
        'classification': h['classification'],
      }).toList(),
    };
  }
  
  /// NEW: Reset adapter metrics for a device
  void resetAdapterMetrics(String deviceId) {
    _adapterMetricsMap.remove(deviceId);
    _logger.info('Reset adapter metrics for device: $deviceId');
  }
  
  /// Get runtime statistics for a device and profile
  ///
  /// This can be used for diagnostics and troubleshooting
  Map<String, dynamic>? getRuntimeStatistics(String deviceId, String profileId) {
    return _configValidator.getRuntimeStatistics(deviceId, profileId);
  }
  
  /// Check if a configuration update is safe for the given profile
  ///
  /// This prevents modification of critical parameters for cheap adapters
  bool isSafeConfigUpdate(String profileId, Map<String, dynamic> updates) {
    return _configValidator.isSafeConfigUpdate(profileId, updates);
  }
} 