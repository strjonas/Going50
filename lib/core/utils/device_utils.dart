import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide Logger;
import 'package:permission_handler/permission_handler.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:logging/logging.dart';

/// A utility class for detecting device capabilities and features
class DeviceUtils {
  static final Logger _logger = Logger('DeviceUtils');
  static final FlutterReactiveBle _ble = FlutterReactiveBle();
  static final Battery _battery = Battery();
  
  /// Check if the device supports Bluetooth
  static Future<bool> hasBluetoothSupport() async {
    try {
      if (!Platform.isAndroid && !Platform.isIOS) {
        return false; // Only Android and iOS support Bluetooth
      }
      
      final status = await _ble.statusStream.first;
      return status != BleStatus.unsupported;
    } catch (e) {
      _logger.warning('Error checking Bluetooth support: $e');
      return false;
    }
  }
  
  /// Check if Bluetooth is currently enabled
  static Future<bool> isBluetoothEnabled() async {
    try {
      final status = await _ble.statusStream.first;
      return status == BleStatus.ready;
    } catch (e) {
      _logger.warning('Error checking if Bluetooth is enabled: $e');
      return false;
    }
  }
  
  /// Check if the device has a gyroscope
  static Future<bool> hasGyroscope() async {
    try {
      final hasPermission = await Permission.sensors.isGranted;
      if (!hasPermission) {
        return false;
      }
      
      // This is a simplified check - in a real implementation, you would actually try to read from the sensor
      return Platform.isAndroid || Platform.isIOS; // Most modern devices have gyroscopes
    } catch (e) {
      _logger.warning('Error checking gyroscope availability: $e');
      return false;
    }
  }
  
  /// Check if the device has location services available
  static Future<bool> hasLocationServices() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return await Permission.locationWhenInUse.serviceStatus.isEnabled;
      }
      return false;
    } catch (e) {
      _logger.warning('Error checking location services: $e');
      return false;
    }
  }
  
  /// Get the current battery level as a percentage
  static Future<int> getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      _logger.warning('Error getting battery level: $e');
      return -1;
    }
  }
  
  /// Check if the device is currently charging
  static Future<bool> isCharging() async {
    try {
      final batteryState = await _battery.batteryState;
      return batteryState == BatteryState.charging || 
             batteryState == BatteryState.full;
    } catch (e) {
      _logger.warning('Error checking charging status: $e');
      return false;
    }
  }
  
  /// Check if the device is in low power mode
  static Future<bool> isLowPowerMode() async {
    try {
      if (Platform.isIOS) {
        return await _battery.isInBatterySaveMode;
      } else {
        // No direct API for Android, return false as fallback
        return false;
      }
    } catch (e) {
      _logger.warning('Error checking low power mode: $e');
      return false;
    }
  }
  
  /// Get the app version
  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      _logger.warning('Error getting app version: $e');
      return 'Unknown';
    }
  }
  
  /// Get the device model
  static String getDeviceModel() {
    try {
      if (Platform.isAndroid) {
        return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
      } else if (Platform.isIOS) {
        return 'iOS ${Platform.operatingSystemVersion}';
      } else {
        return Platform.operatingSystem;
      }
    } catch (e) {
      _logger.warning('Error getting device model: $e');
      return 'Unknown';
    }
  }
  
  /// Check if the device has background execution capabilities
  static bool canExecuteInBackground() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
  
  /// Check if the device is using a lot of battery (would benefit from optimizations)
  static Future<bool> needsBatteryOptimization() async {
    try {
      // Consider below 20% as low battery
      final int batteryLevel = await getBatteryLevel();
      return batteryLevel > 0 && batteryLevel < 20 && !(await isCharging());
    } catch (e) {
      _logger.warning('Error checking battery optimization need: $e');
      return false;
    }
  }
  
  /// Check if the device has all required sensors for collecting driving data
  static Future<bool> hasSensorCapabilities() async {
    try {
      // Check for accelerometer and location services
      final hasAccelerometer = await hasGyroscope(); // Using gyroscope check as a proxy for sensors
      final hasLocation = await hasLocationServices();
      
      // Both are required for basic functionality
      return hasAccelerometer && hasLocation;
    } catch (e) {
      _logger.warning('Error checking sensor capabilities: $e');
      return false;
    }
  }
} 