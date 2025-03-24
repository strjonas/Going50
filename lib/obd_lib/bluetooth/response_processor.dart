import 'dart:convert';
import 'package:logging/logging.dart';

/// Interface for processing OBD adapter responses
///
/// This interface allows for adapter-specific processing of command
/// strings and response data, enabling different adapters to use
/// different data formats without requiring subclassing.
abstract class ResponseProcessor {
  /// Process an outgoing command before sending to the adapter
  String processOutgoingCommand(String command);
  
  /// Process incoming raw data from the adapter
  /// 
  /// Takes raw bytes from the adapter and returns a decoded string.
  /// This allows adapter-specific handling of special characters,
  /// encoding issues, etc.
  String processIncomingData(List<int> data, bool isDebugMode);
}

/// Standard response processor for most ELM327 adapters
///
/// Uses standard UTF-8 encoding with basic sanitization.
class StandardResponseProcessor implements ResponseProcessor {
  final Logger _logger = Logger('StandardResponseProcessor');
  
  @override
  String processOutgoingCommand(String command) {
    // No special processing needed for standard adapters
    return command;
  }
  
  @override
  String processIncomingData(List<int> data, bool isDebugMode) {
    if (data.isEmpty) return '';
    
    try {
      // Log the raw bytes for debugging
      if (isDebugMode) {
        _logger.fine('Received raw bytes: ${data.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');
      }
      
      // Basic sanitization - keep only valid ASCII printable chars and control chars
      final cleanedData = data.where((byte) => 
        byte == 0x0D || // CR
        byte == 0x0A || // LF
        byte == 0x3E || // >
        (byte >= 0x20 && byte <= 0x7E) // Printable ASCII
      ).toList();
      
      // Log if data was sanitized
      if (isDebugMode && cleanedData.length != data.length) {
        _logger.fine('Sanitized ${data.length - cleanedData.length} non-printable bytes from response');
      }
      
      // Convert the cleaned data to a string
      String receivedText;
      try {
        receivedText = utf8.decode(cleanedData);
      } catch (e) {
        // If decoding still fails, use a more robust approach
        _logger.warning('UTF-8 decode failed, using direct character conversion: $e');
        receivedText = cleanedData.map((b) => String.fromCharCode(b)).join('');
      }
      
      if (isDebugMode) {
        _logger.fine('Decoded text: $receivedText');
      }
      
      return receivedText;
    } catch (e) {
      _logger.warning('Error processing incoming data: $e');
      return ''; // Return empty string on error
    }
  }
}

/// Premium response processor for high-quality ELM327 adapters
///
/// Handles specific encoding issues observed with premium adapters,
/// particularly the 0xFC byte that can cause UTF-8 decoding errors.
class PremiumResponseProcessor implements ResponseProcessor {
  final Logger _logger = Logger('PremiumResponseProcessor');
  
  @override
  String processOutgoingCommand(String command) {
    // Add a small delay before each command
    // This is handled in the protocol, not here
    return command;
  }
  
  @override
  String processIncomingData(List<int> data, bool isDebugMode) {
    if (data.isEmpty) return '';
    
    try {
      // Log the raw bytes for debugging
      if (isDebugMode) {
        _logger.fine('Premium received raw bytes: ${data.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');
      }
      
      // More aggressive filtering for premium adapters
      // Specifically exclude the 0xFC byte that causes UTF-8 decoding issues
      final cleanedData = data.where((byte) => 
        byte == 0x0D || // CR
        byte == 0x0A || // LF
        byte == 0x3E || // >
        (byte >= 0x20 && byte <= 0x7E) && // Printable ASCII
        byte != 0xFC // Exclude the problematic byte
      ).toList();
      
      // Log if data was sanitized
      if (isDebugMode && cleanedData.length != data.length) {
        _logger.fine('Premium sanitized ${data.length - cleanedData.length} non-standard bytes from response');
      }
      
      // Try UTF-8 first, fall back to Latin1
      String receivedText;
      try {
        receivedText = utf8.decode(cleanedData);
      } catch (e) {
        // Latin1 can handle all byte values 0-255
        _logger.warning('Premium UTF-8 decode failed, using Latin1 encoding: $e');
        receivedText = latin1.decode(cleanedData);
      }
      
      if (isDebugMode) {
        _logger.fine('Premium decoded text: $receivedText');
      }
      
      return receivedText;
    } catch (e) {
      _logger.warning('Premium error processing incoming data: $e');
      return ''; // Return empty string on error
    }
  }
} 