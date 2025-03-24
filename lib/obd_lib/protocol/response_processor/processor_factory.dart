import 'package:logging/logging.dart';
import 'obd_response_processor.dart';
import 'cheap_elm327_processor.dart';
import 'premium_elm327_processor.dart';
// Import additional processor classes as needed

/// Factory for creating appropriate response processors based on adapter type
///
/// This class provides factory methods for creating response processors
/// that are appropriate for different types of adapters.
class ResponseProcessorFactory {
  static final Logger _logger = Logger('ResponseProcessorFactory');
  
  // Private constructor to prevent instantiation
  ResponseProcessorFactory._();
  
  /// Creates the appropriate response processor for the adapter profile
  static ObdResponseProcessor createProcessor(String adapterProfile, bool lenientParsing) {
    _logger.info('Creating response processor for adapter profile: $adapterProfile');
    
    switch (adapterProfile) {
      case 'cheap_elm327':
        return CheapElm327Processor(lenientParsing: lenientParsing);
      case 'premium_elm327':
        return PremiumElm327Processor(lenientParsing: lenientParsing);
      case 'elm327_v13':
        // v1.3 adapters use a processor similar to premium but with some adjustments
        return PremiumElm327Processor(
          lenientParsing: lenientParsing,
          adaptiveTimeout: true,
          timeoutMultiplier: 1.25, // Older adapters need longer timeouts
        );
      case 'elm327_v15':
        // v1.5 adapters are a good middle ground
        return PremiumElm327Processor(
          lenientParsing: lenientParsing,
          adaptiveTimeout: true,
          timeoutMultiplier: 1.1, // Slightly longer timeouts
        );
      case 'elm327_v20':
        // v2.0+ adapters are faster
        return PremiumElm327Processor(
          lenientParsing: lenientParsing,
          adaptiveTimeout: true,
          timeoutMultiplier: 0.9, // Slightly shorter timeouts for newer adapters
        );
      default:
        // Default to cheap ELM327 processor as it's more robust
        return CheapElm327Processor(lenientParsing: lenientParsing);
    }
  }
} 