import 'package:logging/logging.dart';
import 'interfaces/obd_connection.dart';
import 'protocol/obd_protocol.dart';
import 'protocol/elm327_protocol.dart';
import 'bluetooth/bluetooth_connection.dart';
import 'profiles/profile_manager.dart';
import 'profiles/adapter_profile.dart';

/// Factory for creating OBD-II connections and protocols
class ObdFactory {
  static final Logger _logger = Logger('ObdFactory');
  
  // Private constructor to prevent instantiation
  ObdFactory._();
  
  // Profile manager singleton instance
  static final ProfileManager _profileManager = ProfileManager();
  
  /// Get the profile manager instance
  static ProfileManager get profileManager => _profileManager;
  
  /// Create a Bluetooth connection to an OBD-II adapter
  static ObdConnection createBluetoothConnection(String deviceId, {bool isDebugMode = false}) {
    _logger.info('Creating Bluetooth connection to device: $deviceId');
    return BluetoothConnection(deviceId, isDebugMode: isDebugMode);
  }
  
  /// Create an ELM327 protocol handler using the specified connection
  static ObdProtocol createElm327Protocol(ObdConnection connection, {bool isDebugMode = false}) {
    _logger.info('Creating ELM327 protocol handler');
    return Elm327Protocol(connection, isDebugMode: isDebugMode);
  }
  
  /// Create a protocol handler for a device using the best matching profile
  /// 
  /// This automatically detects and selects the best adapter profile
  static Future<ObdProtocol> createProtocolForDevice(String deviceId, {bool isDebugMode = false}) async {
    _logger.info('Creating protocol for device: $deviceId');
    return await _profileManager.createProtocolForDevice(deviceId, isDebugMode: isDebugMode);
  }
  
  /// Convenience method to create a complete OBD-II connection and protocol
  /// for communicating with an ELM327 adapter over Bluetooth
  /// 
  /// This method is kept for backward compatibility
  static ObdProtocol createBluetoothElm327({
    required String deviceId,
    bool isDebugMode = false,
  }) {
    final connection = createBluetoothConnection(deviceId, isDebugMode: isDebugMode);
    return createElm327Protocol(connection, isDebugMode: isDebugMode);
  }
  
  /// Set a specific adapter profile to be used
  ///
  /// This will override automatic profile detection
  static void setAdapterProfile(String profileId) {
    _profileManager.setManualProfile(profileId);
  }
  
  /// Clear manual profile selection
  ///
  /// This will re-enable automatic profile detection
  static void enableAutomaticProfileDetection() {
    _profileManager.clearManualProfile();
  }
  
  /// Get a list of available adapter profiles
  static List<Map<String, String>> getAvailableProfiles() {
    return _profileManager.profilesList;
  }
} 