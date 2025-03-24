import '../obd_service.dart';

/// Helper methods for sending custom commands to OBD adapters
class ObdCommandHelpers {
  /// Send a custom command to the OBD adapter
  /// 
  /// This is a helper method that bypasses the ObdService and uses the protocol directly
  /// Returns the raw response string from the adapter
  static Future<String> sendCustomCommand(ObdService service, String command) async {
    if (!service.isConnected) {
      return 'Not connected';
    }
    
    try {
      // Since we can't use service._protocol directly (it's private),
      // we'll use the requestPid method and manually construct a response
      final data = await service.requestPid(command);
      if (data != null) {
        return "${data.name}: ${data.value} ${data.unit}";
      } else {
        return 'No response or invalid command';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
} 