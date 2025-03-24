import 'package:logging/logging.dart';
import '../../models/obd_command.dart';
import '../../models/obd_data.dart';
import '../obd_constants.dart';
import 'obd_response_processor.dart';

/// Base implementation of the OBD response processor with common functionality
/// This class provides shared implementation details used by both cheap and premium processors
abstract class BaseResponseProcessor extends ObdResponseProcessor {
  final Logger _logger = Logger('BaseResponseProcessor');
  
  // Validation thresholds shared by all processor types
  static const int MAX_VALID_SPEED_KMH = 220; // Maximum realistic speed in km/h
  static const int MAX_VALID_RPM = 8000; // Maximum realistic RPM
  static const int MAX_VALID_COOLANT_TEMP = 150; // Maximum realistic coolant temperature in °C
  
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
          return decodeSupportedPids(bytes, command);
        case ObdConstants.pidCoolantTemp:
          return decodeCoolantTemp(bytes, command);
        case ObdConstants.pidEngineRpm:
          return decodeEngineRpm(bytes, command);
        case ObdConstants.pidVehicleSpeed:
          return decodeVehicleSpeed(bytes, command);
        case ObdConstants.pidControlModuleVoltage:
          return decodeControlModuleVoltage(bytes, command);
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
  ObdData decodeSupportedPids(List<int> bytes, ObdCommand command) {
    if (bytes.length < 4) return createErrorData(command);
    
    final supportedPids = <String>[];
    
    // Each bit in the 4 bytes represents support for a specific PID
    for (int i = 0; i < 32; i++) {
      final byteIndex = i ~/ 8;
      final bitIndex = 7 - (i % 8);
      
      if ((bytes[byteIndex] & (1 << bitIndex)) != 0) {
        final pidNumber = i + 1;
        final pidHex = pidNumber.toRadixString(16).padLeft(2, '0').toUpperCase();
        supportedPids.add(pidHex);
      }
    }
    
    _logger.fine('Supported PIDs: $supportedPids');
    
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
  ObdData decodeCoolantTemp(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) return createErrorData(command);
    
    // A - 40 = Temperature in °C
    final tempC = bytes[0] - 40;
    
    // Log raw value for debugging
    _logger.fine('Raw coolant temp value: ${bytes[0]} (${bytes[0].toRadixString(16)}), calculated: $tempC °C');
    
    // Validate the temperature (sanity check)
    if (tempC < -40 || tempC > MAX_VALID_COOLANT_TEMP) {
      _logger.warning('Unrealistic coolant temperature: $tempC °C. Using 0 instead.');
      return ObdData(
        mode: command.mode,
        pid: command.pid,
        name: command.name,
        value: 0,
        unit: '°C',
        rawData: bytes,
      );
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: tempC,
      unit: '°C',
      rawData: bytes,
    );
  }
  
  /// Decode control module voltage response
  ObdData decodeControlModuleVoltage(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return createErrorData(command);
    
    // ((A * 256) + B) / 1000 = Voltage in V
    final voltage = ((bytes[0] * 256) + bytes[1]) / 1000;
    
    // Log raw values for debugging
    _logger.fine('Raw voltage values: A=${bytes[0]}, B=${bytes[1]}, formula: ((${bytes[0]} * 256) + ${bytes[1]}) / 1000 = $voltage V');
    
    // Validate the voltage (sanity check)
    if (voltage < 5 || voltage > 20) {
      _logger.warning('Unrealistic voltage calculated: $voltage V. Using 12 instead.');
      return ObdData(
        mode: command.mode,
        pid: command.pid,
        name: command.name,
        value: 12.0,
        unit: 'V',
        rawData: bytes,
      );
    }
    
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: voltage,
      unit: 'V',
      rawData: bytes,
    );
  }
  
  /// Template method to be implemented by specific processors
  /// Each processor type will implement its own parsing strategy
  @override
  List<int> parseResponseBytes(String response, String mode, String pid);
} 