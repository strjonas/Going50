import 'package:flutter_test/flutter_test.dart';
import 'package:going50/obd_lib/models/adapter_config.dart';
import 'package:going50/obd_lib/models/adapter_config_factory.dart';
import 'package:going50/obd_lib/models/adapter_config_validator.dart';
import 'package:going50/obd_lib/protocol/obd_constants.dart';

void main() {
  group('AdapterConfigValidator', () {
    late AdapterConfigValidator validator;
    
    setUp(() {
      validator = AdapterConfigValidator();
    });
    
    test('validates premium adapter config correctly', () {
      final config = AdapterConfigFactory.createPremiumElm327Config();
      final result = validator.validateConfig(config);
      
      expect(result['isValid'], isTrue);
      expect(result['issues'], isEmpty);
      expect(result['config'], equals(config));
    });
    
    test('validates cheap adapter config correctly', () {
      final config = AdapterConfigFactory.createCheapElm327Config();
      final result = validator.validateConfig(config);
      
      expect(result['isValid'], isTrue);
      expect(result['issues'], isEmpty);
      expect(result['config'], equals(config));
    });
    
    test('corrects invalid response timeout for premium adapter', () {
      final originalConfig = AdapterConfigFactory.createPremiumElm327Config();
      final invalidConfig = originalConfig.copyWith(responseTimeoutMs: 50); // Too low
      
      final result = validator.validateConfig(invalidConfig);
      
      expect(result['isValid'], isTrue);
      expect(result['issues'], isNotEmpty);
      expect((result['config'] as AdapterConfig).responseTimeoutMs, 
          greaterThanOrEqualTo(80)); // Should be adjusted to minimum
    });
    
    test('corrects invalid response timeout for cheap adapter', () {
      final originalConfig = AdapterConfigFactory.createCheapElm327Config();
      final invalidConfig = originalConfig.copyWith(responseTimeoutMs: 400); // Too high
      
      final result = validator.validateConfig(invalidConfig);
      
      expect(result['isValid'], isTrue);
      expect(result['issues'], isNotEmpty);
      expect((result['config'] as AdapterConfig).responseTimeoutMs, 
          lessThanOrEqualTo(350)); // Should be adjusted to maximum
    });
    
    test('identifies invalid Bluetooth parameters', () {
      final originalConfig = AdapterConfigFactory.createPremiumElm327Config();
      final invalidConfig = originalConfig.copyWith(serviceUuid: 'invalid-uuid');
      
      final result = validator.validateConfig(invalidConfig);
      
      expect(result['issues'], isNotEmpty);
      expect(result['issues'], contains(contains('Invalid service UUID')));
    });
    
    test('enforces critical settings for cheap adapters', () {
      final originalConfig = AdapterConfigFactory.createCheapElm327Config();
      final invalidConfig = originalConfig.copyWith(
        useExtendedInitDelays: false,
        useLenientParsing: false,
      );
      
      final result = validator.validateConfig(invalidConfig);
      
      expect(result['issues'], isNotEmpty);
      expect(result['issues'], contains(contains('useExtendedInitDelays must be true')));
      expect(result['issues'], contains(contains('useLenientParsing must be true')));
    });
    
    test('isSafeConfigUpdate prevents modifying critical params for cheap adapter', () {
      final safeUpdates = {'defaultPollingInterval': 1000};
      final unsafeUpdates = {'responseTimeoutMs': 100, 'defaultPollingInterval': 1000};
      
      expect(validator.isSafeConfigUpdate('cheap_elm327', safeUpdates), isTrue);
      expect(validator.isSafeConfigUpdate('cheap_elm327', unsafeUpdates), isFalse);
      
      // Should allow all updates for premium adapter
      expect(validator.isSafeConfigUpdate('premium_elm327', unsafeUpdates), isTrue);
    });
    
    test('records and retrieves runtime metrics', () {
      final config = AdapterConfigFactory.createPremiumElm327Config();
      final deviceId = 'test-device-123';
      final profileId = config.profileId;
      
      // Record some metrics
      validator.recordRuntimeMetrics(deviceId, config, {
        'success': true,
        'responseTime': 75,
        'commandDuration': 500,
      });
      
      validator.recordRuntimeMetrics(deviceId, config, {
        'success': true,
        'responseTime': 85,
        'commandDuration': 600,
      });
      
      validator.recordRuntimeMetrics(deviceId, config, {
        'success': false,
        'timeout': true,
        'responseTime': 150,
        'commandDuration': 1500,
      });
      
      // Get statistics
      final stats = validator.getRuntimeStatistics(deviceId, profileId);
      
      expect(stats, isNotNull);
      expect(stats!['commandCount'], equals(3));
      expect(stats['successRate'], equals(2/3));
      expect(stats['timeoutRate'], equals(1/3));
      
      // Average response time should be around (75 + 85 + 150) / 3 = 103.33
      expect(stats['avgResponseTime'], closeTo(103.33, 1.0));
    });
    
    test('calculateOptimizedConfig returns null with insufficient data', () {
      final config = AdapterConfigFactory.createPremiumElm327Config();
      final deviceId = 'test-device-456';
      final profileId = config.profileId;
      
      // Record just a few metrics, not enough for optimization
      validator.recordRuntimeMetrics(deviceId, config, {
        'success': true,
        'responseTime': 75,
        'commandDuration': 500,
      });
      
      validator.recordRuntimeMetrics(deviceId, config, {
        'success': true,
        'responseTime': 85,
        'commandDuration': 600,
      });
      
      // Should return null since we don't have enough data
      final optimizedConfig = validator.calculateOptimizedConfig(deviceId, profileId);
      expect(optimizedConfig, isNull);
    });
  });
} 