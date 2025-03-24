import 'dart:io';

import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling all permission-related functionality
///
/// This class provides methods to request, check, and manage all permissions
/// required by the app for proper operation.
class PermissionService {
  final Logger _logger = Logger('PermissionService');
  
  // Key for first-time permission request tracking
  static const String _firstTimeRequestKey = 'first_time_permission_request';
  
  /// Get the list of all permissions required by the app
  List<Permission> get _requiredPermissions {
    final permissions = <Permission>[];
    
    // Location permissions (required on both platforms)
    permissions.add(Permission.locationWhenInUse);
    permissions.add(Permission.locationAlways);
    
    // Platform-specific Bluetooth permissions
    if (Platform.isAndroid) {
      // Android 12+ requires these specific Bluetooth permissions
      permissions.add(Permission.bluetoothScan);
      permissions.add(Permission.bluetoothConnect);
      
      // Activity recognition (for motion sensors)
      permissions.add(Permission.activityRecognition);
    } else if (Platform.isIOS) {
      // iOS has a single Bluetooth permission
      permissions.add(Permission.bluetooth);
      
      // Add motion sensor permission for iOS
      permissions.add(Permission.sensors);
    }
    
    return permissions;
  }
  
  /// Public getter for all required permissions
  List<Permission> get allPermissions => _requiredPermissions;
  
  /// Checks if all required permissions are granted
  ///
  /// Returns true if all permissions are granted, false otherwise
  Future<bool> areAllPermissionsGranted() async {
    _logger.info('Checking if all permissions are granted');
    
    for (final permission in _requiredPermissions) {
      final status = await permission.status;
      _logger.info('Permission ${permission.toString()}: ${status.toString()}');
      
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  
  /// Requests all permissions required by the app
  ///
  /// Returns a map of permission statuses for each required permission
  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    _logger.info('Requesting all required permissions');
    
    // Request all permissions
    Map<Permission, PermissionStatus> statuses = await _requiredPermissions.request();
    
    // Log the status of each permission
    for (final entry in statuses.entries) {
      _logger.info('Permission ${entry.key}: ${entry.value}');
    }
    
    return statuses;
  }
  
  /// Checks if Bluetooth permissions are granted
  Future<bool> areBluetoothPermissionsGranted() async {
    if (Platform.isAndroid) {
      final scanStatus = await Permission.bluetoothScan.status;
      final connectStatus = await Permission.bluetoothConnect.status;
      _logger.info('Bluetooth scan: $scanStatus, connect: $connectStatus');
      return scanStatus == PermissionStatus.granted && 
             connectStatus == PermissionStatus.granted;
    } else if (Platform.isIOS) {
      // iOS uses a single Bluetooth permission
      final status = await Permission.bluetooth.status;
      _logger.info('Bluetooth: $status');
      return status == PermissionStatus.granted;
    }
    return false;
  }
  
  /// Checks if location permissions are granted
  Future<bool> areLocationPermissionsGranted() async {
    final status = await Permission.locationWhenInUse.status;
    _logger.info('Location when in use: $status');
    return status == PermissionStatus.granted;
  }
  
  /// Checks if background location permission is granted
  Future<bool> isBackgroundLocationGranted() async {
    final status = await Permission.locationAlways.status;
    _logger.info('Location always: $status');
    return status == PermissionStatus.granted;
  }
  
  /// Check if this is the first time asking for permissions
  Future<bool> isFirstTimeRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = !(prefs.getBool(_firstTimeRequestKey) ?? false);
    _logger.info('Is first time permission request? $isFirstTime');
    return isFirstTime;
  }
  
  /// Mark that we have asked for permissions
  Future<void> markPermissionsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    _logger.info('Marking permissions as requested');
    await prefs.setBool(_firstTimeRequestKey, true);
  }
  
  /// Force reset first time request flag (for testing purposes)
  Future<void> resetFirstTimeRequestFlag() async {
    final prefs = await SharedPreferences.getInstance();
    _logger.info('Resetting first-time permission request flag');
    await prefs.setBool(_firstTimeRequestKey, false);
  }
  
  /// Requests location permissions (when in use and always)
  Future<void> requestLocationPermissions({bool background = true}) async {
    _logger.info('Requesting location permissions');
    
    // Check if it's the first time we're asking for permissions
    final isFirstTime = await isFirstTimeRequest();
    
    // Special handling for iOS
    if (Platform.isIOS) {
      var status = await Permission.locationWhenInUse.status;
      
      // If permission is permanently denied on iOS and it's not the first time
      if (status == PermissionStatus.permanentlyDenied && !isFirstTime) {
        _logger.warning('Location permission is permanently denied on iOS. User needs to enable in settings.');
        return;
      }
      
      // Request "when in use" permission
      _logger.info('Requesting location when in use on iOS...');
      status = await Permission.locationWhenInUse.request();
      _logger.info('Location when in use status after request: $status');
      
      // Only request "always" if "when in use" is granted and background is requested
      if (status == PermissionStatus.granted && background) {
        // Delay before requesting background permission on iOS
        // This is a UX best practice on iOS to not request both permissions immediately
        await Future.delayed(const Duration(milliseconds: 500));
        _logger.info('Requesting background location on iOS...');
        final backgroundStatus = await Permission.locationAlways.request();
        _logger.info('Location always status after request: $backgroundStatus');
      }
      
      // Mark that we've requested permissions
      await markPermissionsRequested();
    } else {
      // Android flow - more explicit error handling and checks
      try {
        // First, request location when in use permission
        _logger.info('Requesting location when in use on Android...');
        var status = await Permission.locationWhenInUse.request();
        _logger.info('Location when in use status after request: $status');
        
        // Only request background location if "when in use" is granted and background is requested
        if (status == PermissionStatus.granted && background) {
          await Future.delayed(const Duration(milliseconds: 500));
          _logger.info('Requesting background location on Android...');
          final backgroundStatus = await Permission.locationAlways.request();
          _logger.info('Location always status after request: $backgroundStatus');
        }
        
        // Mark that we've requested permissions
        await markPermissionsRequested();
      } catch (e) {
        _logger.severe('Error requesting location permissions on Android: $e');
      }
    }
  }
  
  /// Requests Bluetooth permissions
  Future<void> requestBluetoothPermissions() async {
    _logger.info('Requesting Bluetooth permissions');
    
    // Check if it's the first time we're asking for permissions
    final isFirstTime = await isFirstTimeRequest();
    
    // Special handling for iOS
    if (Platform.isIOS) {
      var status = await Permission.bluetooth.status;
      
      // If permission is permanently denied on iOS and it's not the first time
      if (status == PermissionStatus.permanentlyDenied && !isFirstTime) {
        _logger.warning('Bluetooth permission is permanently denied on iOS. User needs to enable in settings.');
        return;
      }
      
      _logger.info('Requesting Bluetooth permission on iOS...');
      status = await Permission.bluetooth.request();
      _logger.info('After request - Bluetooth: $status');
      
      // Mark that we've requested permissions
      await markPermissionsRequested();
    } else if (Platform.isAndroid) {
      try {
        _logger.info('Requesting Bluetooth scan permission on Android...');
        final scanStatus = await Permission.bluetoothScan.request();
        _logger.info('After request - Bluetooth scan: $scanStatus');
        
        // Add a small delay between permission requests
        await Future.delayed(const Duration(milliseconds: 300));
        
        _logger.info('Requesting Bluetooth connect permission on Android...');
        final connectStatus = await Permission.bluetoothConnect.request();
        _logger.info('After request - Bluetooth connect: $connectStatus');
        
        // Mark that we've requested permissions
        await markPermissionsRequested();
      } catch (e) {
        _logger.severe('Error requesting Bluetooth permissions on Android: $e');
      }
    }
  }
  
  /// Requests activity recognition permission (Android) or motion sensor permission (iOS)
  Future<void> requestActivityRecognitionPermission() async {
    _logger.info('Requesting activity recognition permission');
    
    try {
      if (Platform.isAndroid) {
        final status = await Permission.activityRecognition.request();
        _logger.info('Activity recognition permission status: $status');
      } else if (Platform.isIOS) {
        final status = await Permission.sensors.request();
        _logger.info('Sensors permission status: $status');
      }
    } catch (e) {
      _logger.severe('Error requesting activity recognition permission: $e');
    }
  }
  
  /// Opens app settings so user can manually enable permissions
  Future<bool> openSettings() async {
    _logger.info('Opening app settings');
    return await openAppSettings();
  }
  
  /// Determines if the permanent permission denial message should be shown
  ///
  /// Returns true if any permission is permanently denied
  Future<bool> shouldShowPermanentDenialMessage() async {
    // Check if it's the first time we're asking for permissions
    final isFirstTime = await isFirstTimeRequest();
    
    // On first-time requests, don't show the permanent denial message
    if (isFirstTime) {
      return false;
    }
    
    // On iOS, we handle permission denials differently - we should guide
    // users to settings rather than showing permanent denial message
    if (Platform.isIOS) {
      var anyPermanentlyDenied = false;
      
      for (final permission in _requiredPermissions) {
        final status = await permission.status;
        if (status == PermissionStatus.permanentlyDenied) {
          _logger.info('${permission.toString()} is permanently denied on iOS');
          anyPermanentlyDenied = true;
        }
      }
      
      // For iOS, we need to check the essential permissions
      if (anyPermanentlyDenied) {
        final locationStatus = await Permission.locationWhenInUse.status;
        final bluetoothStatus = Platform.isIOS 
          ? await Permission.bluetooth.status
          : await Permission.bluetoothConnect.status;
        
        // Show permanent denial screen if both essential permissions are denied
        return locationStatus == PermissionStatus.permanentlyDenied &&
               bluetoothStatus == PermissionStatus.permanentlyDenied;
      }
      
      return false;
    } else {
      // Android behavior
      for (final permission in _requiredPermissions) {
        final status = await permission.status;
        if (status == PermissionStatus.permanentlyDenied) {
          _logger.info('${permission.toString()} is permanently denied');
          return true;
        }
      }
      return false;
    }
  }
} 