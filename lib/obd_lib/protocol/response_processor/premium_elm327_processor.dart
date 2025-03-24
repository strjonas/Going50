import 'package:logging/logging.dart';
import '../../models/obd_command.dart';
import '../../models/obd_data.dart';
import '../obd_constants.dart';
import '../obd_data_parser.dart';
import 'obd_response_processor.dart';

/// Processor for premium ELM327 adapters, which follow the standard OBD-II protocol more closely
///
/// This processor handles the more structured response formats from premium adapters
/// with proper headers and standardized formatting.
class PremiumElm327Processor extends ObdResponseProcessor {
  final Logger _logger = Logger('PremiumElm327Processor');
  
  // Validation thresholds
  static const int MAX_VALID_SPEED_KMH = 220; // Maximum realistic speed in km/h
  static const int MAX_VALID_RPM = 8000; // Maximum realistic RPM
  static const int MAX_VALID_COOLANT_TEMP = 150; // Maximum realistic coolant temperature in °C
  
  /// Whether to use lenient parsing (more tolerant of formatting issues)
  final bool lenientParsing;
  
  /// Whether to use adaptive timeouts based on response times
  final bool adaptiveTimeout;
  
  /// Multiplier to apply to timeouts (for different adapter versions)
  final double timeoutMultiplier;
  
  /// Recent speed values for smoothing
  final List<double> _recentSpeedValues = [];
  
  /// Define the maximum history size for smoothing
  static const int _maxHistorySize = 3;
  
  /// Define smoothing factors for different PIDs
  /// Premium adapters need less smoothing
  static const double _speedSmoothingFactor = 0.4; // 40% previous, 60% new
  
  /// Creates a new processor for premium ELM327 adapters
  PremiumElm327Processor({
    this.lenientParsing = false,
    this.adaptiveTimeout = true,
    this.timeoutMultiplier = 1.0,
  }) {
    _logger.info('Created premium ELM327 processor with lenientParsing=$lenientParsing, '
          'adaptiveTimeout=$adaptiveTimeout, timeoutMultiplier=$timeoutMultiplier');
  }
  
  @override
  ObdData? processDecodedData(ObdData data, String response, ObdCommand command) {
    // Apply PID-specific processing
    if (command.pid == ObdConstants.pidVehicleSpeed) {
      return _processSpeedData(data);
    }
    
    // For other PIDs, return the original data
    return data;
  }
  
  /// Apply minimal smoothing to speed data for premium adapters
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
    
    // Apply minimal smoothing only if we have previous values
    // Premium adapters generally need less smoothing
    double smoothedSpeed = speedValue;
    if (_recentSpeedValues.isNotEmpty) {
      smoothedSpeed = smoothValue(
        speedValue, 
        _recentSpeedValues, 
        _speedSmoothingFactor, 
        _maxHistorySize
      );
      
      // Round to nearest whole number for speed
      smoothedSpeed = smoothedSpeed.roundToDouble();
    }
    
    // Add the original value to history
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
  
  @override
  ObdData? processResponse(String response, ObdCommand command) {
    final bytes = parseResponseBytes(response, command.mode, command.pid);
    
    if (bytes.isEmpty) {
      _logger.warning('No bytes returned from response "$response" for PID ${command.pid}');
      return null;
    }
    
    // Based on the command mode and PID, decode the data appropriately
    if (command.mode == '01') {
      switch (command.pid) {
        case ObdConstants.pidSupportedPids:
          return _decodeSupportedPids(bytes, command);
        case ObdConstants.pidCoolantTemp:
          return _decodeCoolantTemp(bytes, command);
        case ObdConstants.pidEngineRpm:
          return decodeEngineRpm(bytes, command);
        case ObdConstants.pidVehicleSpeed:
          return decodeVehicleSpeed(bytes, command);
        case ObdConstants.pidControlModuleVoltage:
          return _decodeControlModuleVoltage(bytes, command);
        default:
          _logger.warning('Unsupported PID: ${command.pid}');
          return null;
      }
    }
    
    // Return raw data for unsupported modes
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: bytes,
      unit: 'raw',
      rawData: bytes,
    );
  }
  
  @override
  List<int> parseResponseBytes(String response, String mode, String pid) {
    try {
      // Log raw response before any processing
      _logger.fine('Premium ELM - Raw response for PID $pid: "$response"');
      
      // Clean up the response
      final cleaned = cleanResponse(response);
      
      // Log cleaned response
      _logger.fine('Premium ELM - After cleaning for PID $pid: "$cleaned"');
      
      // If response is empty or shows an error
      if (cleaned.isEmpty || cleaned.contains('ERROR') || cleaned.contains('NO DATA')) {
        _logger.warning('Empty or error response for PID $pid: "$cleaned"');
        return [];
      }
      
      // For mode 01 commands, the response header is '41' followed by the PID
      String expectedHeader;
      if (mode == '01') {
        // For mode 01, the response header is always '41' followed by the PID
        expectedHeader = '41${pid.toUpperCase()}';
      } else {
        // For other modes, calculate header as mode + 0x40
        expectedHeader = '${(int.parse(mode, radix: 16) + 40).toRadixString(16).padLeft(2, '0').toUpperCase()}${pid.toUpperCase()}';
      }
      
      _logger.fine('Premium ELM - Looking for header: $expectedHeader in response: $cleaned');
      
      // Premium adapters often send responses in standard format with proper headers
      
      // Split response by spaces
      final parts = cleaned.split(' ');
      _logger.fine('Premium ELM - Split parts: $parts');
      
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
      
      // First try standard format where header and data are in separate parts
      bool found = false;
      
      // Case 1: Header and PID as separate parts (e.g., "41 0C 1A 2B")
      for (int i = 0; i < parts.length - 1; i++) {
        if (parts[i] == '41' && parts[i + 1] == pid.toUpperCase()) {
          _logger.fine('Premium ELM - Found standard format header at index $i');
          
          // Extract data bytes (starting from i+2)
          for (int j = i + 2; j < parts.length; j++) {
            if (parts[j].length == 2) {
              try {
                final byteValue = int.parse(parts[j], radix: 16);
                dataBytes.add(byteValue);
                _logger.fine('Premium ELM - Extracted byte: $byteValue (hex: ${parts[j]})');
              } catch (e) {
                _logger.warning('Error parsing hex byte: $e');
              }
            }
          }
          found = true;
          break;
        }
      }
      
      // Case 2: Header and PID combined (e.g., "410C 1A 2B")
      if (!found) {
        for (int i = 0; i < parts.length; i++) {
          if (parts[i] == expectedHeader || parts[i].startsWith(expectedHeader)) {
            _logger.fine('Premium ELM - Found combined header at index $i');
            
            // If header and data are in the same part, extract the data portion
            if (parts[i].length > expectedHeader.length) {
              String dataHex = parts[i].substring(expectedHeader.length);
              
              // Parse data hex into bytes
              for (int j = 0; j < dataHex.length; j += 2) {
                if (j + 2 <= dataHex.length) {
                  try {
                    final byteValue = int.parse(dataHex.substring(j, j + 2), radix: 16);
                    dataBytes.add(byteValue);
                    _logger.fine('Premium ELM - Extracted byte: $byteValue from combined header');
                  } catch (e) {
                    _logger.warning('Error parsing hex byte: $e');
                  }
                }
              }
            }
            
            // Also check subsequent parts for additional data bytes
            for (int j = i + 1; j < parts.length; j++) {
              if (parts[j].length == 2) {
                try {
                  final byteValue = int.parse(parts[j], radix: 16);
                  dataBytes.add(byteValue);
                  _logger.fine('Premium ELM - Extracted byte: $byteValue (hex: ${parts[j]})');
                } catch (e) {
                  _logger.warning('Error parsing hex byte: $e');
                }
              }
            }
            
            found = true;
            break;
          }
        }
      }
      
      // Case 3: Fallback for non-standard responses (similar to cheap processor)
      if (!found || dataBytes.isEmpty) {
        _logger.fine('Premium ELM - No standard format found, trying fallback approach');
        
        for (String part in parts) {
          if (part.length == 2) {
            try {
              final byteValue = int.parse(part, radix: 16);
              dataBytes.add(byteValue);
              _logger.fine('Premium ELM - Fallback - Extracted byte: $byteValue (hex: ${part})');
            } catch (e) {
              // Skip non-hex parts
              _logger.fine('Premium ELM - Fallback - Skipped non-hex part: ${part}');
            }
          }
        }
      }
      
      // PID-specific validation and processing (similar to cheap processor)
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
          return [dataBytes[0], dataBytes[1]]; // Take only the first two bytes for RPM
        } else if (dataBytes.length == 1) {
          // Some adapters might send a single byte for zero RPM
          _logger.fine('Only one byte for RPM: ${dataBytes[0]}');
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
  
  /// Decode supported PIDs response
  ObdData _decodeSupportedPids(List<int> bytes, ObdCommand command) {
    if (bytes.length < 4) return createErrorData(command);
    
    final supportedPids = <String>[];
    
    // Each bit in the 4 bytes represents support for a specific PID
    for (int i = 0; i < 32; i++) {
      final byteIndex = i ~/ 8;
      final bitIndex = 7 - (i % 8);
      
      if ((bytes[byteIndex] & (1 << bitIndex)) != 0) {
        final pidNumber = i + 1;
        supportedPids.add(pidNumber.toRadixString(16).padLeft(2, '0').toUpperCase());
      }
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: supportedPids,
      unit: 'PIDs',
      rawData: bytes,
    );
  }
  
  /// Decode coolant temperature response
  ObdData _decodeCoolantTemp(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return createErrorData(command);
    
    // A - 40 = Temperature in Celsius
    int temperature = bytes[0] - 40;
    
    // Validate temperature range
    if (temperature > MAX_VALID_COOLANT_TEMP || temperature < -40) {
      _logger.warning('Unrealistic coolant temperature: $temperature°C. Using 0 instead.');
      temperature = 0;
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: temperature,
      unit: '°C',
      rawData: bytes,
    );
  }
  
  /// Decode engine RPM response - Override from parent class
  @override
  ObdData decodeEngineRpm(List<int> bytes, ObdCommand command) {
    // If we have no bytes or if it's a STOPPED signal, return 0 RPM
    if (bytes.isEmpty) {
      _logger.warning('No bytes available for RPM calculation');
      return ObdData(
        mode: command.mode,
        pid: command.pid,
        name: command.name,
        value: 0,
        unit: 'RPM',
        rawData: [],
      );
    }
    
    // Handle case where only one byte is available
    if (bytes.length == 1) {
      // If only one byte, treat it as the low byte (B) for formula ((A * 256) + B) / 4
      _logger.fine('Only one byte available for RPM: treating ${bytes[0]} as low byte');
      double rpm = bytes[0] / 4.0; // B/4 since A=0
      
      return ObdData(
        mode: command.mode,
        pid: command.pid,
        name: command.name,
        value: rpm.round(),
        unit: 'RPM',
        rawData: bytes,
      );
    }
    
    // Standard case with 2 bytes
    // Calculate RPM: ((A * 256) + B) / 4
    double rpm = ((bytes[0] * 256) + bytes[1]) / 4;
    
    // Log the raw calculation for debugging
    _logger.fine('Raw RPM values: A=${bytes[0]}, B=${bytes[1]}, formula: ((${bytes[0]} * 256) + ${bytes[1]}) / 4 = $rpm');
    
    // More lenient validation - only reject truly unrealistic values (like > 20,000 RPM)
    // Most car engines redline between 5,000-9,000 RPM, with some exotic cars going up to 12,000
    // We'll be more permissive here to match the cheap processor behavior
    if (rpm > 20000) {
      _logger.warning('Extremely unrealistic RPM calculated: $rpm. Capping to 8000 RPM.');
      rpm = 8000;
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: rpm.round(),
      unit: 'RPM',
      rawData: bytes,
    );
  }
  
  /// Decode vehicle speed response - Override from parent class
  @override
  ObdData decodeVehicleSpeed(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return createErrorData(command);
    
    // Speed is simply the value of A in km/h
    int speed = bytes[0];
    
    // Log the raw speed value for debugging
    _logger.fine('Raw speed value: $speed km/h (hex: 0x${bytes[0].toRadixString(16).padLeft(2, '0')})');
    
    // Validate speed range
    if (speed > MAX_VALID_SPEED_KMH) {
      _logger.warning('Unrealistic speed calculated: $speed km/h. Using 0 instead.');
      speed = 0;
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: speed,
      unit: 'km/h',
      rawData: bytes,
    );
  }
  
  /// Decode control module voltage response
  ObdData _decodeControlModuleVoltage(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return createErrorData(command);
    
    // ((A * 256) + B) / 1000 = Voltage
    final voltage = ((bytes[0] * 256) + bytes[1]) / 1000;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: voltage.toStringAsFixed(1),
      unit: 'V',
      rawData: bytes,
    );
  }
} 