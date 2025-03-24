import 'models/adapter_config_factory.dart';
import 'profiles/cheap_elm327_profile.dart';
import 'profiles/premium_elm327_profile.dart';
import 'package:logging/logging.dart';

/// Example demonstrating how to use the adapter configuration framework
void adapterConfigExample() {
  // Configure logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  
  final Logger logger = Logger('AdapterConfigExample');

  logger.info('Creating different adapter configurations');
  
  // Create configurations using factory
  final cheapConfig = AdapterConfigFactory.createCheapElm327Config();
  final premiumConfig = AdapterConfigFactory.createPremiumElm327Config();
  final dynamicConfig = AdapterConfigFactory.createDynamicConfig();
  
  logger.info('Cheap adapter config: ${cheapConfig.profileId}');
  logger.info(' - Uses extended init delays: ${cheapConfig.useExtendedInitDelays}');
  logger.info(' - Uses lenient parsing: ${cheapConfig.useLenientParsing}');
  logger.info(' - Default polling interval: ${cheapConfig.defaultPollingInterval}ms');
  
  logger.info('Premium adapter config: ${premiumConfig.profileId}');
  logger.info(' - Uses extended init delays: ${premiumConfig.useExtendedInitDelays}');
  logger.info(' - Uses lenient parsing: ${premiumConfig.useLenientParsing}');
  logger.info(' - Default polling interval: ${premiumConfig.defaultPollingInterval}ms');
  
  logger.info('Dynamic adapter config: ${dynamicConfig.profileId}');
  logger.info(' - Uses extended init delays: ${dynamicConfig.useExtendedInitDelays}');
  logger.info(' - Uses lenient parsing: ${dynamicConfig.useLenientParsing}');
  logger.info(' - Default polling interval: ${dynamicConfig.defaultPollingInterval}ms');
  
  // Create custom configuration
  final customConfig = cheapConfig.copyWith(
    profileId: 'custom_elm327',
    name: 'Custom ELM327 Adapter', 
    defaultPollingInterval: 1500,
    maxRetries: 3,
  );
  
  logger.info('Custom adapter config: ${customConfig.profileId}');
  logger.info(' - Uses extended init delays: ${customConfig.useExtendedInitDelays}');
  logger.info(' - Uses lenient parsing: ${customConfig.useLenientParsing}');
  logger.info(' - Default polling interval: ${customConfig.defaultPollingInterval}ms');
  logger.info(' - Max retries: ${customConfig.maxRetries}');
  
  // Example of creating profiles with configurations
  final cheapProfile = CheapElm327Profile();
  final premiumProfile = PremiumElm327Profile();
  final customCheapProfile = CheapElm327Profile.withConfig(customConfig);
  
  logger.info('Cheap profile ID: ${cheapProfile.profileId}');
  logger.info('Premium profile ID: ${premiumProfile.profileId}');
  logger.info('Custom cheap profile ID: ${customCheapProfile.profileId}');
}

/// Run this to test adapter configuration
void main() {
  adapterConfigExample();
} 