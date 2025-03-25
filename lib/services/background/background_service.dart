import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:going50/services/driving/data_collection_service.dart';
import 'package:going50/services/driving/obd_connection_service.dart';
import 'package:going50/services/driving/trip_service.dart';
import 'package:going50/services/user/preferences_service.dart';
import 'package:going50/core_models/combined_driving_data.dart';

/// ServiceStatus represents the current state of the background service
enum ServiceStatus {
  /// Service is inactive/stopped
  inactive,
  
  /// Service is starting up
  starting,
  
  /// Service is actively running
  running,
  
  /// Service is in the process of stopping
  stopping,
  
  /// Service is in an error state
  error
}

/// Manages the background service for continuous data collection and processing.
///
/// This class provides a facade for interacting with the platform-specific
/// background service implementation using method channels. It coordinates
/// background operation of several key features:
/// - Data collection (OBD and sensors)
/// - Trip monitoring
/// - Battery optimization
/// - Background notifications
class BackgroundService extends ChangeNotifier {
  static const String _methodChannelName = 'com.example.going50/background_service';
  static const String _callbackHandleKey = 'background_service_callback_handle';
  
  final Logger _logger = Logger('BackgroundService');
  final MethodChannel _methodChannel = const MethodChannel(_methodChannelName);
  
  // Dependencies
  final DataCollectionService _dataCollectionService;
  final ObdConnectionService _obdConnectionService;
  final TripService _tripService;
  final PreferencesService _preferencesService;
  
  // Service state
  ServiceStatus _serviceStatus = ServiceStatus.inactive;
  String? _errorMessage;
  bool _isPowerSaveEnabled = false;
  final StreamController<CombinedDrivingData> _backgroundDataController = 
      StreamController<CombinedDrivingData>.broadcast();

  // Subscription for data collection
  StreamSubscription<CombinedDrivingData>? _dataSubscription;
  
  // Timer for background health checks
  Timer? _healthCheckTimer;
  Timer? _idleDetectionTimer;
  DateTime? _lastDataTimestamp;
  
  /// Creates a new BackgroundService
  BackgroundService(
    this._dataCollectionService,
    this._obdConnectionService,
    this._tripService,
    this._preferencesService,
  ) {
    _logger.info('BackgroundService created');
    _methodChannel.setMethodCallHandler(_handleMethodCall);
    _checkServiceStatus();
    _loadPowerSaveSettings();
  }
  
  /// Get current service status
  ServiceStatus get serviceStatus => _serviceStatus;
  
  /// Get any current error message
  String? get errorMessage => _errorMessage;
  
  /// Get whether power saving mode is enabled
  bool get isPowerSaveEnabled => _isPowerSaveEnabled;
  
  /// Get whether the service is running
  bool get isRunning => _serviceStatus == ServiceStatus.running;
  
  /// Stream of data collected while in the background
  Stream<CombinedDrivingData> get backgroundDataStream => _backgroundDataController.stream;
  
  /// Start the background service
  /// 
  /// This will launch a foreground service on Android or register for
  /// background processing on iOS. Returns true if successful.
  Future<bool> startBackgroundService() async {
    try {
      if (_serviceStatus == ServiceStatus.running || 
          _serviceStatus == ServiceStatus.starting) {
        _logger.info('Service already running or starting');
        return true;
      }
      
      _serviceStatus = ServiceStatus.starting;
      notifyListeners();
      
      _logger.info('Starting background service');
      
      // Register callback first
      await _registerCallback();
      
      // Configure background operation mode based on user preferences
      await _configureBackgroundMode();
      
      if (Platform.isAndroid) {
        // Get the callback handle for the static entry point
        final callbackHandle = await _getCallbackHandle();
        if (callbackHandle == null) {
          _setError('Could not get callback handle');
          return false;
        }
        
        // Prepare notification configuration
        final notificationConfig = await _getNotificationConfig();
        
        // Start the Android service
        final Map<String, dynamic> args = {
          'backgroundCallbackHandle': callbackHandle,
          'notificationConfig': notificationConfig,
          'batteryOptimization': _isPowerSaveEnabled,
        };
        
        await _methodChannel.invokeMethod('startService', args);
      } else if (Platform.isIOS) {
        // iOS doesn't use the same service model, but we can register background tasks
        await _methodChannel.invokeMethod('startBackgroundTask', {
          'batteryOptimization': _isPowerSaveEnabled,
        });
      }
      
      // Start listening to data collection stream
      _startDataListening();
      
      // Start health check timer
      _startHealthCheck();
      
      _serviceStatus = ServiceStatus.running;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error starting background service: $e');
      return false;
    }
  }
  
  /// Stop the background service
  /// 
  /// This will stop the foreground service on Android or unregister
  /// background processing on iOS. Returns true if successful.
  Future<bool> stopBackgroundService() async {
    try {
      if (_serviceStatus == ServiceStatus.inactive || 
          _serviceStatus == ServiceStatus.stopping) {
        _logger.info('Service already stopped or stopping');
        return true;
      }
      
      _serviceStatus = ServiceStatus.stopping;
      notifyListeners();
      
      _logger.info('Stopping background service');
      
      // Stop health check timer
      _stopHealthCheck();
      
      // Stop data listening
      _stopDataListening();
      
      // Stop platform service
      await _methodChannel.invokeMethod('stopService');
      
      _serviceStatus = ServiceStatus.inactive;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error stopping background service: $e');
      return false;
    }
  }
  
  /// Set power saving mode
  /// 
  /// When enabled, this will reduce data collection frequency and
  /// disable certain features to conserve battery.
  Future<void> setPowerSaveMode(bool enabled) async {
    try {
      _isPowerSaveEnabled = enabled;
      
      // Save preference using setPreference instead of savePreference
      await _preferencesService.setPreference(
        'background', 
        'powerSaveMode', 
        enabled
      );
      
      // If service is running, reconfigure
      if (_serviceStatus == ServiceStatus.running) {
        await _configureBackgroundMode();
        
        // Notify platform of change
        await _methodChannel.invokeMethod('updatePowerMode', {
          'batteryOptimization': enabled,
        });
      }
      
      notifyListeners();
    } catch (e) {
      _logger.warning('Error setting power save mode: $e');
    }
  }
  
  /// Check if the service can run in the background
  /// 
  /// This checks if all required permissions are granted and
  /// if the device supports background execution.
  Future<bool> canRunInBackground() async {
    try {
      final result = await _methodChannel.invokeMethod('checkBackgroundCapability');
      return result ?? false;
    } catch (e) {
      _logger.warning('Error checking background capability: $e');
      return false;
    }
  }
  
  /// Manually attempt to keep the service alive
  /// 
  /// This is useful for devices that aggressively kill background processes.
  /// It will attempt to ensure the service stays running.
  Future<void> keepAlive() async {
    try {
      await _methodChannel.invokeMethod('keepAlive');
    } catch (e) {
      _logger.warning('Error sending keepAlive signal: $e');
    }
  }
  
  /// Configure background mode based on user preferences
  Future<void> _configureBackgroundMode() async {
    // We don't have direct control over collection intervals
    // So we'll restart collection with appropriate settings when needed
    if (_dataCollectionService.isCollecting) {
      // Stop and restart collection to apply new settings
      await _dataCollectionService.stopCollection();
      await _dataCollectionService.startCollection();
    }
  }
  
  /// Handle method calls from the native side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    _logger.info('Received method call: ${call.method}');
    
    switch (call.method) {
      case 'onServiceStarted':
        _serviceStatus = ServiceStatus.running;
        notifyListeners();
        break;
        
      case 'onServiceStopped':
        _serviceStatus = ServiceStatus.inactive;
        _stopDataListening();
        _stopHealthCheck();
        notifyListeners();
        break;
        
      case 'onLowMemory':
        // Handle low memory warning
        _logger.warning('Low memory warning from system');
        // Maybe reduce collection frequency or stop non-essential features
        break;
        
      case 'onPowerSaveModeChanged':
        final bool enabled = call.arguments['enabled'] ?? false;
        await setPowerSaveMode(enabled);
        break;
        
      case 'onBackgroundTimeout':
        // Handle background execution time limit reached
        _logger.warning('Background execution time limit reached');
        await _methodChannel.invokeMethod('extendBackgroundExecution');
        break;
        
      default:
        _logger.warning('Unknown method call: ${call.method}');
    }
  }
  
  /// Start listening to data from the data collection service
  void _startDataListening() {
    _stopDataListening(); // Make sure we don't have multiple subscriptions
    
    _dataSubscription = _dataCollectionService.dataStream.listen((data) {
      _lastDataTimestamp = DateTime.now();
      _backgroundDataController.add(data);
    }, onError: (error) {
      _logger.warning('Error from data stream: $error');
    });
  }
  
  /// Stop listening to data
  void _stopDataListening() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
  }
  
  /// Start a health check timer to monitor service health
  void _startHealthCheck() {
    _stopHealthCheck(); // Make sure we don't have multiple timers
    
    // Health check every 30 seconds
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      try {
        // Check if service is still running
        final isRunning = await _isServiceRunning();
        if (!isRunning && _serviceStatus == ServiceStatus.running) {
          _logger.warning('Service stopped unexpectedly, attempting to restart');
          await startBackgroundService();
        }
        
        // Check OBD connection if applicable
        if (_obdConnectionService.isConnected) {
          // Since we don't have a checkConnection method,
          // we'll check if we have recent OBD data
          final latestData = _obdConnectionService.getLatestOBDData();
          final isStale = latestData == null || 
              DateTime.now().difference(latestData.timestamp).inSeconds > 10;
              
          if (isStale) {
            _logger.warning('OBD connection may be lost - no recent data');
            // No automatic reconnection to avoid battery drain,
            // just notify about the disconnection
          }
        }
        
        // Check data collection
        if (_dataCollectionService.isCollecting) {
          // Check if we've received data recently (2 minutes timeout)
          if (_lastDataTimestamp != null) {
            final now = DateTime.now();
            final difference = now.difference(_lastDataTimestamp!);
            
            if (difference.inMinutes >= 2) {
              _logger.warning('No data received for 2 minutes, checking for idle');
              _startIdleDetection();
            }
          }
        }
        
        // Ping to keep alive
        await keepAlive();
      } catch (e) {
        _logger.warning('Error in health check: $e');
      }
    });
  }
  
  /// Stop the health check timer
  void _stopHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
    _stopIdleDetection();
  }
  
  /// Start idle detection process
  void _startIdleDetection() {
    _stopIdleDetection(); // Make sure we don't have multiple timers
    
    // If we already have an active trip, we need to check if vehicle has stopped
    if (_tripService.currentTrip != null) {
      // Set a timer for additional 3 minutes to see if we should end the trip
      _idleDetectionTimer = Timer(const Duration(minutes: 3), () async {
        // If no data has been received for 5 minutes total, consider ending the trip
        if (_lastDataTimestamp != null) {
          final now = DateTime.now();
          final difference = now.difference(_lastDataTimestamp!);
          
          if (difference.inMinutes >= 5) {
            _logger.info('Vehicle appears to be stopped for 5+ minutes, ending trip');
            await _tripService.endTrip();
          }
        }
      });
    }
  }
  
  /// Stop idle detection timer
  void _stopIdleDetection() {
    _idleDetectionTimer?.cancel();
    _idleDetectionTimer = null;
  }
  
  /// Check if the background service is running
  Future<bool> _isServiceRunning() async {
    try {
      final result = await _methodChannel.invokeMethod('isServiceRunning');
      final bool isRunning = result ?? false;
      
      // Update service status based on platform info
      if (isRunning && _serviceStatus != ServiceStatus.running) {
        _serviceStatus = ServiceStatus.running;
        notifyListeners();
      } else if (!isRunning && _serviceStatus == ServiceStatus.running) {
        _serviceStatus = ServiceStatus.inactive;
        notifyListeners();
      }
      
      return isRunning;
    } catch (e) {
      _logger.warning('Error checking service status: $e');
      return false;
    }
  }
  
  /// Get notification configuration from user preferences
  Future<Map<String, dynamic>> _getNotificationConfig() async {
    try {
      // Default configuration
      Map<String, dynamic> config = {
        'title': 'Going50 - Eco Driving Active',
        'content': 'Collecting driving data...',
        'channelId': 'going50_background_service',
        'channelName': 'Driving Data Collection',
        'importance': 3, // IMPORTANCE_DEFAULT
        'priority': 0, // PRIORITY_DEFAULT
        'showActivityButton': true,
        'showStopButton': true
      };
      
      // Get user preferences
      final notificationPrefs = await _preferencesService.getPreference(
        'notifications', 
        'background'
      );
      
      // Override defaults with user preferences if available
      if (notificationPrefs != null && notificationPrefs is Map<String, dynamic>) {
        config.addAll(notificationPrefs);
      }
      
      return config;
    } catch (e) {
      _logger.warning('Error getting notification config: $e');
      return {
        'title': 'Going50 - Eco Driving Active',
        'content': 'Collecting driving data...',
        'channelId': 'going50_background_service',
        'channelName': 'Driving Data Collection',
        'importance': 3,
        'priority': 0,
        'showActivityButton': true,
        'showStopButton': true
      };
    }
  }
  
  /// Load power save settings from preferences
  Future<void> _loadPowerSaveSettings() async {
    try {
      final powerSaveMode = await _preferencesService.getPreference(
        'background', 
        'powerSaveMode'
      );
      
      if (powerSaveMode != null) {
        _isPowerSaveEnabled = powerSaveMode as bool;
      } else {
        // Default to enabled for better battery life out of the box
        _isPowerSaveEnabled = true;
      }
    } catch (e) {
      _logger.warning('Error loading power save settings: $e');
      _isPowerSaveEnabled = true; // Default to battery saving mode
    }
  }
  
  /// Update the current service status
  Future<void> _checkServiceStatus() async {
    try {
      await _isServiceRunning();
    } catch (e) {
      _logger.warning('Error checking service status: $e');
    }
  }
  
  /// Set error state
  void _setError(String message) {
    _errorMessage = message;
    _serviceStatus = ServiceStatus.error;
    _logger.severe(message);
    notifyListeners();
  }
  
  /// Register the callback for the service
  Future<void> _registerCallback() async {
    try {
      // Get the callback handle for the static entry point
      final handle = PluginUtilities.getCallbackHandle(backgroundServiceCallback)?.toRawHandle();
      if (handle == null) {
        _logger.severe('Could not get callback handle');
        return;
      }
      
      // Store the callback handle
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_callbackHandleKey, handle);
    } catch (e) {
      _logger.severe('Error registering callback: $e');
    }
  }
  
  /// Get the stored callback handle
  Future<int?> _getCallbackHandle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_callbackHandleKey);
    } catch (e) {
      _logger.severe('Error getting callback handle: $e');
      return null;
    }
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _logger.info('Disposing BackgroundService');
    
    // Stop health check
    _stopHealthCheck();
    
    // Stop data listening
    _stopDataListening();
    
    // Close stream controller
    _backgroundDataController.close();
    
    super.dispose();
  }
}

/// Static entry point for the background service
@pragma('vm:entry-point')
void backgroundServiceCallback() {
  // This is the entry point for the background service
  // It will be called when the service starts in the background
  
  // Set up method channel for communication
  const MethodChannel methodChannel = 
      MethodChannel('com.example.going50/background_service');
      
  // Initialize any required services here
  WidgetsFlutterBinding.ensureInitialized();
  
  // Log startup
  print('Background service started on Dart side');
} 