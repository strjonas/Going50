import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:going50/services/user/preferences_service.dart';
import 'package:going50/core_models/driving_event.dart';

/// NotificationType represents the different types of notifications the app can send
enum NotificationType {
  /// Regular system notifications
  system,
  
  /// Notifications related to driving behavior
  drivingEvent,
  
  /// Notifications related to achievements
  achievement,
  
  /// Notifications related to social features
  social,
  
  /// Notifications related to trips (completion, summary, etc.)
  trip,
  
  /// Background service notifications
  background,
  
  /// Notifications for eco tips and suggestions
  ecoTip,
}

/// NotificationPriority represents the urgency/importance of the notification
enum NotificationPriority {
  /// Low priority, silent notifications
  low,
  
  /// Default priority, makes a sound but doesn't pop up
  medium,
  
  /// High priority, makes sound and appears as a pop-up
  high,
}

/// NotificationService manages all in-app and system notifications
///
/// This service is responsible for:
/// - Creating and managing notification channels
/// - Sending different types of notifications based on app events
/// - Respecting user notification preferences
/// - Handling platform-specific notification implementation
class NotificationService {
  static const String _methodChannelName = 'com.example.going50/notifications';
  
  final Logger _logger = Logger('NotificationService');
  final MethodChannel _methodChannel = const MethodChannel(_methodChannelName);
  
  // Dependencies
  final PreferencesService _preferencesService;
  
  // Channel IDs for Android
  static const Map<NotificationType, String> _notificationChannels = {
    NotificationType.system: 'going50_system',
    NotificationType.drivingEvent: 'going50_driving_events',
    NotificationType.achievement: 'going50_achievements',
    NotificationType.social: 'going50_social',
    NotificationType.trip: 'going50_trips',
    NotificationType.background: 'going50_background_service',
    NotificationType.ecoTip: 'going50_eco_tips',
  };
  
  // Channel names for Android
  static const Map<NotificationType, String> _channelNames = {
    NotificationType.system: 'System Notifications',
    NotificationType.drivingEvent: 'Driving Events',
    NotificationType.achievement: 'Achievements',
    NotificationType.social: 'Social Updates',
    NotificationType.trip: 'Trip Information',
    NotificationType.background: 'Background Service',
    NotificationType.ecoTip: 'Eco Tips',
  };
  
  // Channel descriptions for Android
  static const Map<NotificationType, String> _channelDescriptions = {
    NotificationType.system: 'General app notifications',
    NotificationType.drivingEvent: 'Notifications for driving behavior events',
    NotificationType.achievement: 'Notifications for earned achievements',
    NotificationType.social: 'Notifications for social activity',
    NotificationType.trip: 'Notifications about trips and summaries',
    NotificationType.background: 'Required notifications for background service',
    NotificationType.ecoTip: 'Tips for improving eco-driving score',
  };
  
  // Notification stream controller for in-app notifications
  final _notificationStreamController = StreamController<Map<String, dynamic>>.broadcast();
  
  // Track notification permissions status
  bool _areNotificationsPermitted = false;
  
  /// Constructor
  NotificationService(this._preferencesService) {
    _logger.info('NotificationService created');
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }
  
  /// Stream of in-app notifications
  Stream<Map<String, dynamic>> get notificationStream => _notificationStreamController.stream;
  
  /// Get whether notifications are permitted
  bool get areNotificationsPermitted => _areNotificationsPermitted;
  
  /// Initialize the notification service
  /// 
  /// This creates notification channels on Android and requests permissions on iOS.
  Future<bool> initialize() async {
    try {
      _logger.info('Initializing NotificationService');
      
      // Create notification channels on Android
      if (Platform.isAndroid) {
        await _createNotificationChannels();
      }
      
      // Request notification permissions
      _areNotificationsPermitted = await requestPermissions();
      
      _logger.info('NotificationService initialized successfully. Permissions granted: $_areNotificationsPermitted');
      return true;
    } catch (e) {
      _logger.severe('Error initializing NotificationService: $e');
      return false;
    }
  }
  
  /// Create notification channels on Android
  Future<void> _createNotificationChannels() async {
    try {
      List<Map<String, dynamic>> channels = [];
      
      // Create channel configuration for each notification type
      for (var type in NotificationType.values) {
        final channelId = _notificationChannels[type];
        final channelName = _channelNames[type];
        final channelDescription = _channelDescriptions[type];
        
        // Skip if any are missing
        if (channelId == null || channelName == null || channelDescription == null) {
          continue;
        }
        
        // Determine importance based on notification type
        int importance;
        switch (type) {
          case NotificationType.drivingEvent:
          case NotificationType.background:
            importance = 3; // IMPORTANCE_DEFAULT
            break;
          case NotificationType.achievement:
          case NotificationType.trip:
            importance = 4; // IMPORTANCE_HIGH
            break;
          default:
            importance = 2; // IMPORTANCE_LOW
            break;
        }
        
        channels.add({
          'id': channelId,
          'name': channelName,
          'description': channelDescription,
          'importance': importance,
        });
      }
      
      // Create all channels at once
      await _methodChannel.invokeMethod('createNotificationChannels', {'channels': channels});
      _logger.info('Created ${channels.length} notification channels');
    } catch (e) {
      _logger.warning('Error creating notification channels: $e');
    }
  }
  
  /// Request permission to show notifications
  Future<bool> requestPermissions() async {
    try {
      final result = await _methodChannel.invokeMethod('requestNotificationPermissions');
      return result == true;
    } catch (e) {
      _logger.warning('Error requesting notification permissions: $e');
      return false;
    }
  }
  
  /// Show a notification
  /// 
  /// This will show a system notification if the app is in the background
  /// or an in-app notification if the app is in the foreground.
  /// Returns true if the notification was shown.
  Future<bool> showNotification({
    required String title,
    required String body,
    required NotificationType type,
    NotificationPriority priority = NotificationPriority.medium,
    Map<String, dynamic>? data,
    String? notificationId,
  }) async {
    // Check if notifications of this type are enabled
    if (!isNotificationTypeEnabled(type)) {
      _logger.info('Notification of type $type is disabled by user preferences');
      return false;
    }
    
    final id = notificationId ?? DateTime.now().millisecondsSinceEpoch.toString();
    
    try {
      // Create notification payload
      final notification = {
        'id': id,
        'title': title,
        'body': body,
        'type': type.toString(),
        'priority': priority.toString(),
        'data': data ?? {},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      // Emit to in-app stream first
      _notificationStreamController.add(notification);
      
      // Only send system notification if app is not in foreground
      final isAppInForeground = await _methodChannel.invokeMethod('isAppInForeground');
      if (isAppInForeground == true) {
        _logger.info('App is in foreground, showing in-app notification only');
        return true;
      }
      
      // Send system notification
      await _methodChannel.invokeMethod('showNotification', {
        'id': id,
        'title': title,
        'body': body,
        'channelId': _notificationChannels[type],
        'priority': _getPriorityValue(priority),
        'data': data ?? {},
      });
      
      _logger.info('Showed notification: $title');
      return true;
    } catch (e) {
      _logger.warning('Error showing notification: $e');
      return false;
    }
  }
  
  /// Show a driving event notification
  /// 
  /// Specialized method for showing notifications related to driving events.
  Future<bool> showDrivingEventNotification(DrivingEvent event) async {
    // Format title and message based on event type
    String title;
    String message;
    
    switch (event.eventType) {
      case 'harsh_acceleration':
        title = 'Aggressive Acceleration';
        message = 'Try accelerating more gradually for better efficiency';
        break;
      case 'harsh_braking':
        title = 'Hard Braking';
        message = 'Try to anticipate stops and brake gradually';
        break;
      case 'excessive_speed':
        title = 'Speeding';
        message = 'Maintaining a consistent, legal speed improves efficiency';
        break;
      case 'excessive_idling':
        title = 'Excessive Idling';
        message = 'Consider turning off your engine when stopped for long periods';
        break;
      case 'trip_completed':
        title = 'Trip Completed';
        message = 'Check your summary for eco-driving insights';
        break;
      default:
        // Use the additionalData if available
        title = event.additionalData?['title'] as String? ?? 'Driving Event';
        message = event.additionalData?['message'] as String? ?? '';
    }
    
    return showNotification(
      title: title,
      body: message, 
      type: NotificationType.drivingEvent,
      priority: NotificationPriority.medium,
      data: {'eventType': event.eventType, 'eventId': event.id},
      notificationId: 'driving_event_${event.id}',
    );
  }
  
  /// Show an achievement notification
  Future<bool> showAchievementNotification({
    required String title,
    required String message,
    required String badgeType,
    required int level,
  }) {
    return showNotification(
      title: title,
      body: message,
      type: NotificationType.achievement,
      priority: NotificationPriority.high,
      data: {'badgeType': badgeType, 'level': level},
      notificationId: 'achievement_${badgeType}_$level',
    );
  }
  
  /// Show a trip summary notification
  Future<bool> showTripSummaryNotification({
    required String tripId,
    required int ecoScore,
    required double distanceKm,
    required double fuelSavedL,
  }) {
    String title = 'Trip Summary';
    String message = 'Eco-Score: $ecoScore | Distance: ${distanceKm.toStringAsFixed(1)} km';
    
    if (fuelSavedL > 0) {
      message += ' | Saved: ${fuelSavedL.toStringAsFixed(2)}L';
    }
    
    return showNotification(
      title: title,
      body: message,
      type: NotificationType.trip,
      priority: NotificationPriority.medium,
      data: {'tripId': tripId, 'ecoScore': ecoScore},
      notificationId: 'trip_summary_$tripId',
    );
  }
  
  /// Cancel a notification by ID
  Future<void> cancelNotification(String id) async {
    try {
      await _methodChannel.invokeMethod('cancelNotification', {'id': id});
      _logger.info('Cancelled notification: $id');
    } catch (e) {
      _logger.warning('Error cancelling notification: $e');
    }
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _methodChannel.invokeMethod('cancelAllNotifications');
      _logger.info('Cancelled all notifications');
    } catch (e) {
      _logger.warning('Error cancelling all notifications: $e');
    }
  }
  
  /// Update notification settings for a given type
  Future<void> updateNotificationSetting(NotificationType type, bool enabled) async {
    final category = 'notifications';
    String key;
    
    switch (type) {
      case NotificationType.achievement:
        key = 'achievements';
        break;
      case NotificationType.drivingEvent:
        key = 'driving_events';
        break;
      case NotificationType.trip:
        key = 'trip_summary';
        break;
      case NotificationType.social:
        key = 'social';
        break;
      case NotificationType.ecoTip:
        key = 'eco_tips';
        break;
      case NotificationType.background:
        key = 'background_collection';
        break;
      default:
        key = 'system';
    }
    
    await _preferencesService.setPreference(category, key, enabled);
    _logger.info('Updated notification setting: $type => $enabled');
  }
  
  /// Check if a notification type is enabled based on user preferences
  bool isNotificationTypeEnabled(NotificationType type) {
    final category = 'notifications';
    String key;
    
    switch (type) {
      case NotificationType.achievement:
        key = 'achievements';
        break;
      case NotificationType.drivingEvent:
        key = 'driving_events';
        break;
      case NotificationType.trip:
        key = 'trip_summary';
        break;
      case NotificationType.social:
        key = 'social';
        break;
      case NotificationType.ecoTip:
        key = 'eco_tips';
        break;
      case NotificationType.background:
        key = 'background_collection';
        break;
      default:
        // System notifications are always enabled
        return true;
    }
    
    // Get user preference, defaulting to true if not found
    return _preferencesService.getPreference(category, key) ?? true;
  }
  
  /// Handle incoming method calls from the platform
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNotificationClicked':
        // Handle notification click
        _logger.info('Notification clicked: ${call.arguments}');
        return null;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }
  
  /// Get platform-specific priority value
  int _getPriorityValue(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return 0; // PRIORITY_LOW
      case NotificationPriority.high:
        return 1; // PRIORITY_HIGH
      case NotificationPriority.medium:
        return 0; // PRIORITY_DEFAULT
    }
  }
  
  /// Dispose resources
  void dispose() {
    _notificationStreamController.close();
  }
} 