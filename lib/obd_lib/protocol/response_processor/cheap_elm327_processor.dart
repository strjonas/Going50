import 'package:logging/logging.dart';
import '../../models/obd_command.dart';
import '../../models/obd_data.dart';
import '../obd_constants.dart';
import '../obd_data_parser.dart';
import 'obd_response_processor.dart';

/// Processor for cheap ELM327 adapters, which often have non-standard responses
///
/// This processor is more lenient in parsing responses from cheap adapters
/// which may have formatting issues, dropped bytes, or other anomalies.
class CheapElm327Processor extends ObdResponseProcessor {
  static final Logger _logger = Logger('CheapElm327Processor');
  
  /// Whether to use lenient parsing (more tolerant of formatting issues)
  final bool _lenientParsing;
  
  /// Recent speed values for smoothing
  final List<double> _recentSpeedValues = [];
  
  /// Recent throttle values for smoothing
  final List<double> _recentThrottleValues = [];
  
  /// Define the maximum history size for smoothing
  static const int _maxHistorySize = 5;
  
  /// Define smoothing factors for different PIDs
  /// Higher values (closer to 1.0) give more weight to previous readings
  static const double _speedSmoothingFactor = 0.6; // 60% previous, 40% new
  static const double _throttleSmoothingFactor = 0.4; // 40% previous, 60% new
  
  /// Creates a new cheap ELM327 processor
  ///
  /// The [lenientParsing] parameter controls how strict the parsing is.
  /// For cheap adapters, this is typically true by default.
  CheapElm327Processor({
    bool lenientParsing = true,
  }) : _lenientParsing = lenientParsing {
    _logger.info('Created cheap ELM327 processor with lenientParsing=$lenientParsing');
  }
  
  @override
  ObdData? processDecodedData(ObdData data, String response, ObdCommand command) {
    // Apply PID-specific processing
    if (command.pid == ObdConstants.pidVehicleSpeed) {
      return _processSpeedData(data);
    } else if (command.pid == ObdConstants.pidThrottlePosition) {
      return _processThrottleData(data);
    }
    
    // For other PIDs, return the original data
    return data;
  }
  
  /// Apply smoothing to speed data to reduce fluctuations
  ObdData? _processSpeedData(ObdData data) {
    final dynamic rawValue = data.value;
    if (rawValue == null) return data;
    
    // Convert to double for smoothing
    double speedValue;
    if (rawValue is int) {
      speedValue = rawValue.toDouble();
    } else if (rawValue is double) {
      speedValue = rawValue;
    } else if (rawValue is String) {
      try {
        speedValue = double.parse(rawValue);
      } catch (e) {
        return data; // Can't smooth, return original
      }
    } else {
      return data; // Unknown type, return original
    }
    
    // Apply smoothing only if we have previous values and current value is not zero
    // (We don't want to smooth when actually stopping)
    double smoothedSpeed = speedValue;
    if (speedValue > 0 && _recentSpeedValues.isNotEmpty) {
      smoothedSpeed = smoothValue(
        speedValue, 
        _recentSpeedValues, 
        _speedSmoothingFactor, 
        _maxHistorySize
      );
      
      // Round to nearest whole number for speed
      smoothedSpeed = smoothedSpeed.roundToDouble();
      
      _logger.fine('Smoothed speed from $speedValue to $smoothedSpeed km/h');
    }
    
    // Add the original value to history (not the smoothed one)
    // This ensures we're not compounding smoothing effects
    _recentSpeedValues.add(speedValue);
    if (_recentSpeedValues.length > _maxHistorySize) {
      _recentSpeedValues.removeAt(0);
    }
    
    // Return a new data object with the smoothed value
    return data.copyWith(
      value: smoothedSpeed.toInt(),
      timestamp: DateTime.now(),
    );
  }
  
  /// Apply smoothing to throttle data to reduce fluctuations
  ObdData? _processThrottleData(ObdData data) {
    final dynamic rawValue = data.value;
    if (rawValue == null) return data;
    
    // Convert to double for smoothing
    double throttleValue;
    if (rawValue is int) {
      throttleValue = rawValue.toDouble();
    } else if (rawValue is double) {
      throttleValue = rawValue;
    } else if (rawValue is String) {
      try {
        throttleValue = double.parse(rawValue);
      } catch (e) {
        return data; // Can't smooth, return original
      }
    } else {
      return data; // Unknown type, return original
    }
    
    // Apply throttle-specific corrections for cheap adapters
    
    // Some adapters incorrectly report very low values when throttle is released
    // This creates a "dead zone" effect where throttle appears stuck
    if (throttleValue < 3.0) {
      // For very low readings, snap to zero for better UI response
      _logger.fine('Correcting low throttle value from $throttleValue% to 0%');
      throttleValue = 0.0;
    }
    
    // Apply smoothing for non-zero throttle values to reduce jitter
    double smoothedThrottle = throttleValue;
    if (throttleValue > 0 && _recentThrottleValues.isNotEmpty) {
      // Accelerator pedal movement should be more responsive than speed changes
      smoothedThrottle = smoothValue(
        throttleValue, 
        _recentThrottleValues, 
        _throttleSmoothingFactor, 
        _maxHistorySize
      );
      
      _logger.fine('Smoothed throttle from $throttleValue% to $smoothedThrottle%');
    }
    
    // Add the original value to history
    _recentThrottleValues.add(throttleValue);
    if (_recentThrottleValues.length > _maxHistorySize) {
      _recentThrottleValues.removeAt(0);
    }
    
    // Return a new data object with the smoothed value
    return data.copyWith(
      value: smoothedThrottle,
      timestamp: DateTime.now(),
    );
  }
  
  @override
  ObdData? processResponse(String response, ObdCommand command) {
    // Apply cheap adapter-specific preprocessing before normal processing
    final modifiedResponse = _preprocessResponse(response, command);
    
    // Use the standard processing logic from the base class
    return super.processResponse(modifiedResponse, command);
  }
  
  /// Preprocess the response to handle common issues with cheap adapters
  String _preprocessResponse(String response, ObdCommand command) {
    if (response.isEmpty) return response;
    
    // Many cheap adapters send garbage characters or have inconsistent formatting
    String processed = response;
    
    // Remove common garbage characters sent by cheap adapters
    processed = processed.replaceAll(RegExp(r'[\x00-\x1F]'), '');
    
    // Some adapters send "NODATA" without space
    if (processed.contains('NODATA')) {
      processed = processed.replaceAll('NODATA', 'NO DATA');
    }
    
    // Some adapters use non-standard response formats
    if (_lenientParsing) {
      // Try to extract valid hex from responses with bad formatting
      final hexPattern = RegExp(r'[0-9A-Fa-f]{2,}');
      final matches = hexPattern.allMatches(processed);
      
      if (matches.isNotEmpty) {
        // Check if this looks like a normal OBD response with expected header
        final normalObd = RegExp(r'41 ' + command.pid);
        if (!normalObd.hasMatch(processed)) {
          // This may be a malformed response, try to reconstruct it
          final hexParts = matches.map((m) => m.group(0)).toList();
          
          // Check if we have enough parts to form a valid response
          if (hexParts.length >= 2) {
            // Try to form a standard mode+PID response format
            processed = '41 ${command.pid} ' + hexParts.skip(1).join(' ');
            _logger.fine('Reconstructed malformed response to: $processed');
          }
        }
      }
    }
    
    return processed;
  }
  
  @override
  List<int> parseResponseBytes(String response, String mode, String pid) {
    try {
      // Log raw response before any processing
      _logger.fine('Cheap ELM - Raw response for PID $pid: "$response"');
      
      // Clean up the response
      final cleaned = cleanResponse(response);
      
      // Log cleaned response
      _logger.fine('Cheap ELM - After cleaning for PID $pid: "$cleaned"');
      
      // If response is empty or shows an error
      if (cleaned.isEmpty || cleaned.contains('ERROR') || cleaned.contains('NO DATA')) {
        _logger.warning('Empty or error response for PID $pid: "$cleaned"');
        return [];
      }
      
      // Split response by spaces
      final parts = cleaned.split(' ');
      _logger.fine('Cheap ELM - Split parts: $parts');
      
      List<int> dataBytes = [];
      
      // Remove any non-hex characters that might have been missed in cleaning
      for (int i = 0; i < parts.length; i++) {
        parts[i] = parts[i].replaceAll(RegExp(r'[^A-Fa-f0-9]'), '');
      }
      
      // Remove any empty parts
      parts.removeWhere((part) => part.isEmpty);
      
      if (parts.isEmpty) {
        _logger.warning('No valid hex parts found in response for PID $pid');
        return [];
      }
      
      // For cheap adapters, often the headers are missing or malformed
      // Go straight to the "last resort" approach
      for (String part in parts) {
        if (part.length == 2) {
          try {
            final byteValue = int.parse(part, radix: 16);
            dataBytes.add(byteValue);
            _logger.fine('Cheap ELM - Extracted byte: $byteValue (hex: ${part})');
          } catch (e) {
            // Skip non-hex parts
            _logger.fine('Cheap ELM - Skipped non-hex part: ${part}');
          }
        }
      }
      
      // PID-specific validation and processing
      if (pid == ObdConstants.pidVehicleSpeed) {
        // Vehicle speed should be just one byte
        if (dataBytes.isNotEmpty) {
          _logger.fine('Raw speed value: ${dataBytes.first}');
          return [dataBytes.first]; // Take only the first byte for speed
        }
      } else if (pid == ObdConstants.pidEngineRpm) {
        // Engine RPM needs exactly 2 bytes
        if (dataBytes.length >= 2) {
          _logger.fine('Raw RPM bytes: ${dataBytes[0]}, ${dataBytes[1]}');
          _logger.fine('Cheap ELM - Calculated RPM: ${((dataBytes[0] * 256) + dataBytes[1]) / 4}');
          return [dataBytes[0], dataBytes[1]]; // Take only the first two bytes for RPM
        } else if (dataBytes.length == 1) {
          // Some adapters might send a single byte for zero RPM
          _logger.fine('Only one byte for RPM: ${dataBytes[0]}');
          
          // Treat single byte as low byte (B) instead of high byte (A)
          // This matches the behavior in PremiumElm327Processor and produces more realistic values
          _logger.fine('Cheap ELM - Single byte - Calculated RPM: ${((0 * 256) + dataBytes[0]) / 4}');
          return [0, dataBytes[0]]; // Use as low byte, not high byte
        }
      }
      
      _logger.fine('Final extracted data bytes for PID $pid: $dataBytes');
      return dataBytes;
    } catch (e) {
      _logger.warning('Error parsing response "$response" for PID $pid: $e');
      return [];
    }
  }
  
  @override
  String cleanResponse(String response) {
    // Cheap adapters often have additional non-standard characters
    // This more aggressive cleaning helps handle their quirks
    return response
        .replaceAll(RegExp(r'[\r\n>]'), ' ')  // Replace newlines, CR, prompt with space
        .replaceAll(RegExp(r'BUS INIT'), '')  // Remove BUS INIT messages
        .replaceAll(RegExp(r'SEARCHING'), '') // Remove SEARCHING messages
        .replaceAll(RegExp(r'STOPPED'), '')   // Remove STOPPED messages
        .replaceAll(RegExp(r'DATA ERROR'), '') // Remove DATA ERROR messages
        .replaceAll(RegExp(r'CAN ERROR'), '')  // Remove CAN ERROR messages
        .replaceAll(RegExp(r'UNABLE TO CONNECT'), '') // Remove connection error messages
        .replaceAll(RegExp(r'[^A-Fa-f0-9 ]'), '') // Keep only hex chars and spaces
        .replaceAll(RegExp(r'\s+'), ' ')      // Replace multiple spaces with single space
        .trim()
        .toUpperCase();
  }
} 