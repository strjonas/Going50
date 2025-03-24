import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

/// A utility class for handling app permissions
class PermissionUtils {
  static final Logger _logger = Logger('PermissionUtils');
  
  /// Permissions required for driving features with OBD
  static const List<Permission> drivingPermissions = [
    Permission.location,
    Permission.locationWhenInUse,
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ];
  
  /// Permissions required for driving features with phone sensors only
  static const List<Permission> sensorOnlyPermissions = [
    Permission.location,
    Permission.locationWhenInUse,
    Permission.sensors,
  ];
  
  /// Permissions required for background tracking
  static const List<Permission> backgroundTrackingPermissions = [
    Permission.location,
    Permission.locationAlways,
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.ignoreBatteryOptimizations,
  ];
  
  /// Check if a permission is granted
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }
  
  /// Request a specific permission
  static Future<bool> requestPermission(Permission permission) async {
    _logger.info('Requesting permission: ${permission.toString()}');
    
    try {
      final status = await permission.request();
      _logger.info('Permission ${permission.toString()} status: ${status.toString()}');
      return status.isGranted;
    } catch (e) {
      _logger.severe('Error requesting permission ${permission.toString()}: $e');
      return false;
    }
  }
  
  /// Request multiple permissions
  static Future<Map<Permission, bool>> requestPermissions(List<Permission> permissions) async {
    _logger.info('Requesting multiple permissions: ${permissions.map((p) => p.toString()).join(', ')}');
    
    Map<Permission, bool> results = {};
    
    for (final permission in permissions) {
      results[permission] = await requestPermission(permission);
    }
    
    return results;
  }
  
  /// Check if all required permissions for driving with OBD are granted
  static Future<bool> checkDrivingPermissions() async {
    for (final permission in drivingPermissions) {
      if (!await isPermissionGranted(permission)) {
        return false;
      }
    }
    return true;
  }
  
  /// Check if all required permissions for driving with sensors only are granted
  static Future<bool> checkSensorOnlyPermissions() async {
    for (final permission in sensorOnlyPermissions) {
      if (!await isPermissionGranted(permission)) {
        return false;
      }
    }
    return true;
  }
  
  /// Check if all required permissions for background tracking are granted
  static Future<bool> checkBackgroundTrackingPermissions() async {
    for (final permission in backgroundTrackingPermissions) {
      if (!await isPermissionGranted(permission)) {
        return false;
      }
    }
    return true;
  }
  
  /// Request all permissions needed for driving with OBD
  static Future<bool> requestDrivingPermissions() async {
    final results = await requestPermissions(drivingPermissions);
    return !results.values.contains(false);
  }
  
  /// Request all permissions needed for driving with sensors only
  static Future<bool> requestSensorOnlyPermissions() async {
    final results = await requestPermissions(sensorOnlyPermissions);
    return !results.values.contains(false);
  }
  
  /// Request all permissions needed for background tracking
  static Future<bool> requestBackgroundTrackingPermissions() async {
    final results = await requestPermissions(backgroundTrackingPermissions);
    return !results.values.contains(false);
  }
  
  /// Open app settings when permissions are permanently denied
  static Future<bool> openSettings() async {
    _logger.info('Opening app settings');
    return await openAppSettings();
  }
  
  /// Check if all required permissions for sensor use are granted
  static Future<bool> checkSensorPermissions() async {
    return checkSensorOnlyPermissions();
  }
  
  /// Request all permissions needed for sensor use
  static Future<bool> requestSensorPermissions() async {
    return requestSensorOnlyPermissions();
  }
} 