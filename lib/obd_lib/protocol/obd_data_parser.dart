import 'package:logging/logging.dart';
import '../models/obd_data.dart';
import '../models/obd_command.dart';
import 'obd_constants.dart';

/// Parser for OBD-II response data
class ObdDataParser {
  static final Logger _logger = Logger('ObdDataParser');
  
  // Private constructor to prevent instantiation
  ObdDataParser._();
  
  /// Parse a raw response string into bytes
  static List<int> parseResponseBytes(String response, String mode, String pid) {
    try {
      // Log raw response before any processing
      _logger.fine('PARSER DEBUG - Raw response for PID $pid: "$response"');
      
      // Clean up the response
      final cleaned = _cleanResponse(response);
      
      // Log cleaned response
      _logger.fine('PARSER DEBUG - After cleaning for PID $pid: "$cleaned"');
      
      // If response is empty or shows an error
      if (cleaned.isEmpty || cleaned.contains('ERROR') || cleaned.contains('NO DATA')) {
        _logger.warning('Empty or error response for PID $pid: "$cleaned"');
        return [];
      }
      
      // Log the raw cleaned response for debugging
      _logger.fine('Cleaned response: $cleaned for PID $pid');
      
      // For mode 01 commands, the response header is '41' followed by the PID
      String expectedHeader;
      if (mode == '01') {
        // For mode 01, the response header is always '41' followed by the PID
        expectedHeader = '41${pid.toUpperCase()}';
      } else {
        // For other modes, calculate header as mode + 0x40
        expectedHeader = '${(int.parse(mode, radix: 16) + 40).toRadixString(16).padLeft(2, '0').toUpperCase()}${pid.toUpperCase()}';
      }
      
      _logger.fine('Looking for header: $expectedHeader in response: $cleaned');
      
      // Split response by spaces
      final parts = cleaned.split(' ');
      _logger.fine('PARSER DEBUG - Split parts: $parts');
      
      List<int> dataBytes = [];
      
      // Remove any non-hex characters that might have been missed in cleaning
      for (int i = 0; i < parts.length; i++) {
        parts[i] = parts[i].replaceAll(RegExp(r'[^A-Fa-f0-9]'), '');
      }
      
      // Remove any empty parts
      parts.removeWhere((part) => part.isEmpty);
      _logger.fine('PARSER DEBUG - Filtered parts: $parts');
      
      if (parts.isEmpty) {
        _logger.warning('No valid hex parts found in response for PID $pid');
        return [];
      }
      
      // Check if we have a standard OBD-II response format
      bool found = false;
      for (int i = 0; i < parts.length; i++) {
        // Case 1: The header is in a single part ("410D00")
        if (parts[i].startsWith(expectedHeader)) {
          String dataHex = parts[i].substring(expectedHeader.length);
          _logger.fine('PARSER DEBUG - Found header in part "$parts[i]", data hex: "$dataHex"');
          
          // Convert data hex to bytes
          for (int j = 0; j < dataHex.length; j += 2) {
            if (j + 2 <= dataHex.length) {
              final byteHex = dataHex.substring(j, j + 2);
              try {
                final byteValue = int.parse(byteHex, radix: 16);
                dataBytes.add(byteValue);
              } catch (e) {
                _logger.warning('Error parsing hex byte: $e');
              }
            }
          }
          found = true;
          break;
        }
        // Case 2: Header is split across parts ("41 0D 00")
        else if (i + 1 < parts.length) {
          // Try to join this part with the next one to see if that makes a header
          final possibleHeaderStart = parts[i];
          final possibleHeaderEnd = parts[i+1];
          
          if (possibleHeaderStart.length <= 2 && possibleHeaderEnd.length <= 2) {
            final joinedHeader = possibleHeaderStart + possibleHeaderEnd;
            
            if (joinedHeader == expectedHeader) {
              // Header found across two parts, data starts at i+2
              _logger.fine('PARSER DEBUG - Found split header at parts $i and ${i+1}, data starts at part ${i+2}');
              
              for (int j = i + 2; j < parts.length; j++) {
                if (parts[j].length == 2) { // Valid hex byte
                  try {
                    final byteValue = int.parse(parts[j], radix: 16);
                    dataBytes.add(byteValue);
                  } catch (e) {
                    _logger.warning('Error parsing split header hex byte: $e');
                    break;
                  }
                } else {
                  break; // Invalid format, stop processing
                }
              }
              found = true;
              break;
            }
          }
        }
      }
      
      // If standard format failed, try a more generic approach for malformed responses
      if (!found && dataBytes.isEmpty) {
        _logger.fine('Standard header pattern not found, trying generic extraction');
        
        // Combine all parts and try to find the header in the combined string
        final combinedResponse = parts.join('');
        _logger.fine('PARSER DEBUG - Combined response: "$combinedResponse"');
        
        // Look for the header pattern anywhere in the response
        final headerIndex = combinedResponse.indexOf(expectedHeader);
        if (headerIndex >= 0 && headerIndex + expectedHeader.length < combinedResponse.length) {
          // Extract all remaining data after the header
          final dataHex = combinedResponse.substring(headerIndex + expectedHeader.length);
          _logger.fine('PARSER DEBUG - Found header at position $headerIndex in combined response, remaining data: "$dataHex"');
          
          // Convert data hex to bytes
          for (int i = 0; i < dataHex.length; i += 2) {
            if (i + 2 <= dataHex.length) {
              final byteHex = dataHex.substring(i, i + 2);
              try {
                final byteValue = int.parse(byteHex, radix: 16);
                dataBytes.add(byteValue);
              } catch (e) {
                _logger.warning('Error parsing fallback hex byte: $e');
                break; // Stop at first error
              }
            }
          }
        }
        
        // If still no data, try a last resort approach for completely mangled responses
        if (dataBytes.isEmpty && parts.isNotEmpty) {
          _logger.warning('Header not found in response, attempting last resort data extraction');
          _logger.fine('PARSER DEBUG - Last resort extraction, parts: $parts');
          
          // Try to interpret any hex bytes as data (useful for some adapters that omit headers)
          for (String part in parts) {
            if (part.length == 2) {
              try {
                final byteValue = int.parse(part, radix: 16);
                dataBytes.add(byteValue);
                _logger.fine('PARSER DEBUG - Extracted byte: $byteValue (hex: $part)');
              } catch (e) {
                // Skip non-hex parts
                _logger.fine('PARSER DEBUG - Skipped non-hex part: $part');
              }
            }
          }
          
          if (dataBytes.isNotEmpty) {
            _logger.fine('Last resort data extraction yielded ${dataBytes.length} bytes');
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
          _logger.fine('PARSER DEBUG - Calculated RPM: ${((dataBytes[0] * 256) + dataBytes[1]) / 4}');
          return [dataBytes[0], dataBytes[1]]; // Take only the first two bytes for RPM
        } else if (dataBytes.length == 1) {
          // Some adapters might send a single byte for zero RPM
          _logger.fine('Only one byte for RPM: ${dataBytes[0]}');
          _logger.fine('PARSER DEBUG - Single byte - Calculated RPM: ${((dataBytes[0] * 256) + 0) / 4}');
          
          // IMPORTANT - This is where we're adding a zero byte which may be causing issues
          return [dataBytes[0], 0]; // Add a zero byte to make it two bytes
        }
      }
      
      _logger.fine('Final extracted data bytes for PID $pid: $dataBytes');
      return dataBytes;
    } catch (e) {
      _logger.warning('Error parsing response "$response" for PID $pid: $e');
      return [];
    }
  }
  
  /// Clean up an OBD response
  static String _cleanResponse(String response) {
    // Log original response
    _logger.fine('PARSER DEBUG - Before cleaning: "$response"');
    
    final result = response
        .replaceAll(RegExp(r'[\r\n>]'), ' ')  // Replace newlines, CR, prompt with space
        .replaceAll(RegExp(r'BUS INIT'), '')  // Remove BUS INIT messages
        .replaceAll(RegExp(r'SEARCHING'), '') // Remove SEARCHING messages
        .replaceAll(RegExp(r'[^A-Fa-f0-9 ]'), '') // Keep only hex chars and spaces
        .replaceAll(RegExp(r'\s+'), ' ')      // Replace multiple spaces with single space
        .trim()
        .toUpperCase();
        
    // Log after cleaning
    _logger.fine('PARSER DEBUG - After cleaning: "$result"');
    
    return result;
  }
  
  /// Decode a response for a specific command
  static ObdData? decodeResponse(String response, ObdCommand command) {
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
          return _decodeEngineRpm(bytes, command);
        case ObdConstants.pidVehicleSpeed:
          return _decodeVehicleSpeed(bytes, command);
        case ObdConstants.pidControlModuleVoltage:
          return _decodeControlModuleVoltage(bytes, command);
        case ObdConstants.pidEngineLoad:
          return _decodeEngineLoad(bytes, command);
        case ObdConstants.pidThrottlePosition:
          return _decodeThrottlePosition(bytes, command);
        // New PIDs
        case ObdConstants.pidMassAirFlow:
          return _decodeMassAirFlow(bytes, command);
        case ObdConstants.pidDistanceMIL:
          return _decodeDistanceMIL(bytes, command);
        case ObdConstants.pidFuelRate:
          return _decodeFuelRate(bytes, command);
        case ObdConstants.pidAcceleratorPosition:
          return _decodeAcceleratorPosition(bytes, command);
        // Add missing parsers
        case ObdConstants.pidFuelLevel:
        case ObdConstants.pidCurrentFuelLevel: // Both point to 0x2F
          return _decodeFuelLevel(bytes, command);
        case ObdConstants.pidFuelType:
          return _decodeFuelType(bytes, command);
        case ObdConstants.pidIntakeManifoldAbsolutePressure:
          return _decodeIntakeManifoldPressure(bytes, command);
        case ObdConstants.pidIntakeAirTemperature:
          return _decodeIntakeAirTemperature(bytes, command);
        case ObdConstants.pidEngineOilTemperature:
          return _decodeEngineOilTemperature(bytes, command);
        case ObdConstants.pidAmbientAirTemperature:
          return _decodeAmbientAirTemperature(bytes, command);
        case ObdConstants.pidFuelPressure:
          return _decodeFuelPressure(bytes, command);
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
  
  /// Decode supported PIDs response
  static ObdData _decodeSupportedPids(List<int> bytes, ObdCommand command) {
    if (bytes.length < 4) return _createErrorData(command);
    
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
  static ObdData _decodeCoolantTemp(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A - 40 = Temperature in Celsius
    final temperature = bytes[0] - 40;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: temperature,
      unit: '°C',
      rawData: bytes,
    );
  }
  
  /// Decode engine RPM response
  static ObdData _decodeEngineRpm(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return _createErrorData(command);
    
    // ((A * 256) + B) / 4 = RPM
    final rpm = ((bytes[0] * 256) + bytes[1]) / 4;
    
    // Log raw values for debugging
    _logger.fine('Raw RPM values: A=${bytes[0]}, B=${bytes[1]}, formula: ((${bytes[0]} * 256) + ${bytes[1]}) / 4 = $rpm');
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: rpm.round(),
      unit: 'RPM',
      rawData: bytes,
    );
  }
  
  /// Decode vehicle speed response
  static ObdData _decodeVehicleSpeed(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) {
      _logger.warning('Empty bytes array for vehicle speed');
      return _createErrorData(command);
    }
    
    // A = Speed in km/h (first byte only)
    final speed = bytes[0];
    
    // Log raw value for debugging
    _logger.fine('Raw speed value: ${bytes[0]} km/h (hex: 0x${bytes[0].toRadixString(16)})');
    
    // Sanity check - speeds over 250 km/h are likely errors
    if (speed > 250) {
      _logger.warning('Unrealistic speed detected: $speed km/h. Using 0 instead.');
      return ObdData(
        mode: command.mode,
        pid: command.pid,
        name: command.name,
        value: 0,
        unit: 'km/h',
        rawData: bytes,
      );
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
  static ObdData _decodeControlModuleVoltage(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return _createErrorData(command);
    
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
  
  /// Decode engine load response
  static ObdData _decodeEngineLoad(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A * 100 / 255 = Engine load as percentage
    final load = (bytes[0] * 100) / 255;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: load.round(),
      unit: '%',
      rawData: bytes,
    );
  }
  
  /// Decode throttle position response
  static ObdData _decodeThrottlePosition(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A * 100 / 255 = Throttle position as percentage
    final position = (bytes[0] * 100) / 255;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: position.round(),
      unit: '%',
      rawData: bytes,
    );
  }
  
  /// Decode mass air flow response
  static ObdData _decodeMassAirFlow(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return _createErrorData(command);
    
    // ((A * 256) + B) / 100 = Mass Air Flow rate in grams/sec
    final maf = ((bytes[0] * 256) + bytes[1]) / 100;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: maf,
      unit: 'g/s',
      rawData: bytes,
    );
  }
  
  /// Decode distance traveled with MIL on
  static ObdData _decodeDistanceMIL(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return _createErrorData(command);
    
    // (A * 256) + B = Distance in km
    final distance = (bytes[0] * 256) + bytes[1];
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: distance,
      unit: 'km',
      rawData: bytes,
    );
  }
  
  /// Decode fuel rate response
  static ObdData _decodeFuelRate(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return _createErrorData(command);
    
    // ((A * 256) + B) / 20 = Fuel consumption rate in L/h
    final rate = ((bytes[0] * 256) + bytes[1]) / 20;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: rate,
      unit: 'L/h',
      rawData: bytes,
    );
  }
  
  /// Decode accelerator pedal position
  static ObdData _decodeAcceleratorPosition(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A * 100 / 255 = Accelerator pedal position as percentage
    final position = (bytes[0] * 100) / 255;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: position.round(),
      unit: '%',
      rawData: bytes,
    );
  }
  
  /// Decode fuel level response (PID 2F)
  static ObdData _decodeFuelLevel(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A * 100 / 255 = Fuel level as percentage
    final level = (bytes[0] * 100) / 255;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: level.round(),
      unit: '%',
      rawData: bytes,
    );
  }
  
  /// Decode fuel type response (PID 51)
  static ObdData _decodeFuelType(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A = Fuel type code
    final fuelTypeCode = bytes[0];
    String fuelType;
    
    // Map fuel type codes according to SAE J1979 standard
    switch (fuelTypeCode) {
      case 0: fuelType = 'Not Available'; break;
      case 1: fuelType = 'Gasoline'; break;
      case 2: fuelType = 'Methanol'; break;
      case 3: fuelType = 'Ethanol'; break;
      case 4: fuelType = 'Diesel'; break;
      case 5: fuelType = 'LPG'; break;
      case 6: fuelType = 'CNG'; break;
      case 7: fuelType = 'Propane'; break;
      case 8: fuelType = 'Electric'; break;
      case 9: fuelType = 'Bifuel: Gasoline/CNG'; break;
      case 10: fuelType = 'Bifuel: Gasoline/LPG'; break;
      case 11: fuelType = 'Bifuel: Gasoline/Ethanol'; break;
      case 12: fuelType = 'Bifuel: Gasoline/Methanol'; break;
      case 13: fuelType = 'Bifuel: Diesel/CNG'; break;
      case 14: fuelType = 'Bifuel: Diesel/LPG'; break;
      case 15: fuelType = 'Bifuel: Diesel/Ethanol'; break;
      case 16: fuelType = 'Bifuel: Diesel/Methanol'; break;
      case 17: fuelType = 'Bifuel: Gasoline/Electric'; break;
      case 18: fuelType = 'Hybrid: Gasoline'; break;
      case 19: fuelType = 'Hybrid: Diesel'; break;
      case 20: fuelType = 'Hybrid: Electric'; break;
      case 21: fuelType = 'Hybrid: Fuel Cell'; break;
      case 22: fuelType = 'Hybrid: Gasoline/Fuel Cell'; break;
      case 23: fuelType = 'Hybrid: Ethanol/Fuel Cell'; break;
      default: fuelType = 'Unknown ($fuelTypeCode)';
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: fuelType,
      unit: '',
      rawData: bytes,
    );
  }
  
  /// Decode intake manifold absolute pressure (PID 0B)
  static ObdData _decodeIntakeManifoldPressure(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A = Intake manifold pressure in kPa (absolute)
    final pressure = bytes[0];
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: pressure,
      unit: 'kPa',
      rawData: bytes,
    );
  }
  
  /// Decode intake air temperature (PID 0F)
  static ObdData _decodeIntakeAirTemperature(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A - 40 = Intake air temperature in Celsius
    final temperature = bytes[0] - 40;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: temperature,
      unit: '°C',
      rawData: bytes,
    );
  }
  
  /// Decode engine oil temperature (PID 5C)
  static ObdData _decodeEngineOilTemperature(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A - 40 = Oil temperature in Celsius
    final temperature = bytes[0] - 40;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: temperature,
      unit: '°C',
      rawData: bytes,
    );
  }
  
  /// Decode ambient air temperature (PID 1F)
  static ObdData _decodeAmbientAirTemperature(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A - 40 = Ambient air temperature in Celsius
    final temperature = bytes[0] - 40;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: temperature,
      unit: '°C',
      rawData: bytes,
    );
  }
  
  /// Decode fuel pressure (PID 23)
  static ObdData _decodeFuelPressure(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return _createErrorData(command);
    
    // A * 3 = Fuel pressure in kPa (gauge)
    final pressure = bytes[0] * 3;
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: pressure,
      unit: 'kPa',
      rawData: bytes,
    );
  }
  
  /// Create an error data object when decoding fails
  static ObdData _createErrorData(ObdCommand command) {
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: 'Error',
      unit: '',
      rawData: [],
    );
  }
} 