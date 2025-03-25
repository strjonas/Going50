import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the native background tracking service
///
/// This class handles communication with the platform-specific
/// background service implementation using method channels.
class TrackingServiceManager {
  static const String _methodChannelName = 'com.example.going50/tracking_service';
  static const String _callbackHandleKey = 'tracking_service_callback_handle';
  
  final Logger _logger = Logger('TrackingServiceManager');
  final MethodChannel _methodChannel = const MethodChannel(_methodChannelName);
  
  /// Callback for when the service starts
  final VoidCallback? onServiceStarted;
  
  /// Callback for when the service stops
  final VoidCallback? onServiceStopped;
  
  /// Whether the service is currently running
  bool _isRunning = false;
  
  /// Creates a new TrackingServiceManager
  TrackingServiceManager({
    this.onServiceStarted,
    this.onServiceStopped,
  }) {
    _methodChannel.setMethodCallHandler(_handleMethodCall);
    _checkServiceStatus();
  }
  
  /// Get whether the service is running
  bool get isRunning => _isRunning;
  
  /// Start the background tracking service
  /// 
  /// In Android, this launches a foreground service with notification.
  /// In iOS, this registers for background processing.
  Future<bool> startService() async {
    try {
      if (await _isServiceRunning()) {
        _logger.info('Service already running');
        return true;
      }
      
      // Register callback first
      await _registerCallback();
      
      if (Platform.isAndroid) {
        // Get the callback handle for the static entry point
        final callbackHandle = await _getCallbackHandle();
        if (callbackHandle == null) {
          _logger.severe('Could not get callback handle');
          return false;
        }
        
        // Start the Android service
        final Map<String, dynamic> args = {
          'backgroundCallbackHandle': callbackHandle,
        };
        
        await _methodChannel.invokeMethod('startService', args);
        _isRunning = true;
        return true;
      } else if (Platform.isIOS) {
        // iOS doesn't use the same service model, but we can start background tasks
        await _methodChannel.invokeMethod('startBackgroundTask');
        _isRunning = true;
        return true;
      }
      
      return false;
    } catch (e) {
      _logger.severe('Error starting tracking service: $e');
      return false;
    }
  }
  
  /// Stop the background tracking service
  Future<bool> stopService() async {
    try {
      if (!await _isServiceRunning()) {
        _logger.info('Service not running');
        return true;
      }
      
      await _methodChannel.invokeMethod('stopService');
      _isRunning = false;
      return true;
    } catch (e) {
      _logger.severe('Error stopping tracking service: $e');
      return false;
    }
  }
  
  /// Handle method calls from the native side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onServiceStarted':
        _isRunning = true;
        onServiceStarted?.call();
        break;
      case 'onServiceStopped':
        _isRunning = false;
        onServiceStopped?.call();
        break;
      default:
        _logger.warning('Unknown method call: ${call.method}');
    }
  }
  
  /// Check if the service is running
  Future<bool> _isServiceRunning() async {
    try {
      final result = await _methodChannel.invokeMethod('isServiceRunning');
      _isRunning = result ?? false;
      return _isRunning;
    } on MissingPluginException catch (e) {
      // This means the plugin isn't registered correctly
      _logger.warning('MissingPluginException checking service status: $e');
      // In the simulator or when plugins aren't properly set up, assume the service isn't running
      _isRunning = false;
      return false;
    } catch (e) {
      _logger.warning('Error checking service status: $e');
      return false;
    }
  }
  
  /// Update the current service status
  Future<void> _checkServiceStatus() async {
    _isRunning = await _isServiceRunning();
  }
  
  /// Register the callback for the service
  Future<void> _registerCallback() async {
    // Get the callback handle for the static entry point
    final handle = PluginUtilities.getCallbackHandle(backgroundServiceCallback)?.toRawHandle();
    if (handle == null) {
      _logger.severe('Could not get callback handle');
      return;
    }
    
    // Store the callback handle
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_callbackHandleKey, handle);
  }
  
  /// Get the stored callback handle
  Future<int?> _getCallbackHandle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_callbackHandleKey);
  }
}

/// Static entry point for the background service
@pragma('vm:entry-point')
void backgroundServiceCallback() {
  // This is the entry point for the background service
  // It will be called when the service starts in the background
  
  // Set up method channel for communication
  const MethodChannel methodChannel = 
      MethodChannel('com.example.going50/tracking_service');
      
  // Initialize any required services here
  WidgetsFlutterBinding.ensureInitialized();
  
  // Log startup
  print('Background service started on Dart side');
} 