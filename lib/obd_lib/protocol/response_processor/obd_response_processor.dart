import 'package:logging/logging.dart';
import '../../models/obd_command.dart';
import '../../models/obd_data.dart';
import '../obd_constants.dart';
import '../obd_data_parser.dart';

/// Base class for OBD response processors
/// 
/// This abstract class defines the interface for processing OBD responses
/// and converting them to [ObdData] objects.
abstract class ObdResponseProcessor {
  static final Logger _logger = Logger('ObdResponseProcessor');
  
  /// Process a raw response string and return an OBD data object
  /// 
  /// This method is responsible for:
  /// 1. Extracting relevant data from the raw response string
  /// 2. Converting the data to a structured OBD data object
  /// 3. Performing any necessary validation or filtering
  /// 
  /// Returns null if the response is invalid or could not be processed
  ObdData? processResponse(String response, ObdCommand command) {
    if (response.isEmpty) {
      _logger.warning('Empty response for command: ${command.command}');
      return null;
    }
    
    if (response.contains('NO DATA') || 
        response.contains('ERROR') || 
        response.contains('UNABLE TO CONNECT') ||
        response.contains('TIMEOUT')) {
      _logger.warning('Error response for command ${command.command}: $response');
      return null;
    }
    
    try {
      // Use the data parser to decode the response
      final data = ObdDataParser.decodeResponse(response, command);
      
      if (data != null) {
        // Let derived classes perform additional processing
        return processDecodedData(data, response, command);
      }
      
      return null;
    } catch (e) {
      _logger.severe('Error processing response for ${command.command}: $e');
      return null;
    }
  }
  
  /// Additional processing steps for decoded data
  /// 
  /// This method allows derived classes to perform additional processing
  /// on the decoded data, such as filtering, normalization, or smoothing.
  /// 
  /// The default implementation returns the data unmodified.
  ObdData? processDecodedData(ObdData data, String response, ObdCommand command) {
    return data;
  }
  
  /// Apply smoothing to a numeric value using a specific algorithm
  /// 
  /// This helper method allows derived classes to apply smoothing to measurements
  /// that might experience jitter or fluctuations due to adapter limitations.
  /// 
  /// Parameters:
  /// - newValue: the latest reading value
  /// - previousValues: a list of recent previous readings
  /// - smoothingFactor: 0-1 value determining smoothing intensity (0.8 = 80% previous, 20% new)
  /// - maxPreviousValues: the maximum number of previous values to consider
  double smoothValue(
    double newValue,
    List<double> previousValues,
    double smoothingFactor,
    int maxPreviousValues,
  ) {
    if (previousValues.isEmpty) {
      return newValue;
    }
    
    // Ensure we're not using too many previous values
    while (previousValues.length > maxPreviousValues) {
      previousValues.removeAt(0);
    }
    
    // Calculate weighted average with exponential weighting
    double smoothedValue = newValue * (1 - smoothingFactor);
    
    // Apply higher weight to more recent values
    for (int i = 0; i < previousValues.length; i++) {
      // Weight decreases exponentially as we go further back in history
      final weight = smoothingFactor * pow(0.5, i.toDouble());
      smoothedValue += previousValues[previousValues.length - 1 - i] * weight;
    }
    
    return smoothedValue;
  }
  
  /// Helper method: exponential function for smoothing
  double pow(double base, double exponent) {
    return base == 0 ? 0 : base * pow(base, exponent - 1);
  }
  
  /// Parse a raw response string into bytes for a specific PID
  List<int> parseResponseBytes(String response, String mode, String pid);
  
  /// Create error data for invalid responses
  ObdData createErrorData(ObdCommand command) {
    return ObdData(
      mode: command.mode,
      pid: command.pid,
      name: command.name,
      value: null,
      unit: '',
      rawData: [],
    );
  }
  
  /// Clean up an OBD response - may be overridden by specific processors
  String cleanResponse(String response) {
    return response
        .replaceAll(RegExp(r'[\r\n>]'), ' ')  // Replace newlines, CR, prompt with space
        .replaceAll(RegExp(r'BUS INIT'), '')  // Remove BUS INIT messages
        .replaceAll(RegExp(r'SEARCHING'), '') // Remove SEARCHING messages
        .replaceAll(RegExp(r'[^A-Fa-f0-9 ]'), '') // Keep only hex chars and spaces
        .replaceAll(RegExp(r'\s+'), ' ')      // Replace multiple spaces with single space
        .trim()
        .toUpperCase();
  }
  
  /// Decode engine RPM response
  ObdData decodeEngineRpm(List<int> bytes, ObdCommand command) {
    if (bytes.length < 2) return createErrorData(command);
    
    // ((A * 256) + B) / 4 = RPM
    final rpm = ((bytes[0] * 256) + bytes[1]) / 4;
    
    // Log raw values for debugging
    _logger.fine('Raw RPM values: A=${bytes[0]}, B=${bytes[1]}, formula: ((${bytes[0]} * 256) + ${bytes[1]}) / 4 = $rpm');
    
    // Validate the RPM value (sanity check)
    if (rpm > 10000) {
      _logger.warning('Unrealistic RPM calculated: $rpm. Using 0 instead.');
      return ObdData(
        mode: command.mode,
        pid: command.pid,
        name: command.name,
        value: 0,
        unit: 'RPM',
        rawData: bytes,
      );
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
  
  /// Decode vehicle speed response
  ObdData decodeVehicleSpeed(List<int> bytes, ObdCommand command) {
    if (bytes.isEmpty) {
      _logger.warning('Empty bytes array for vehicle speed');
      return createErrorData(command);
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
} 