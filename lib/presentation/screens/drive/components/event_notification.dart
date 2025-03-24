import 'package:flutter/material.dart';
import 'package:going50/core_models/driving_event.dart';
import 'package:going50/core/theme/app_colors.dart';

/// A component to display driving event notifications.
///
/// This appears temporarily when significant driving events occur
/// (like aggressive acceleration, hard braking, etc.) to provide
/// immediate feedback to the driver.
class EventNotification extends StatelessWidget {
  /// The driving event to display
  final DrivingEvent event;
  
  /// Constructor
  const EventNotification({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Format the event info
    final eventInfo = _getEventInfo(event);
    
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: eventInfo.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Icon(
                  eventInfo.icon,
                  color: eventInfo.iconColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                
                // Message
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      Text(
                        eventInfo.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (eventInfo.message.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        // Event message
                        Text(
                          eventInfo.message,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Returns formatted event information based on event type
  _EventInfo _getEventInfo(DrivingEvent event) {
    switch (event.eventType) {
      case 'behavior_aggressive_acceleration':
        return _EventInfo(
          title: 'Aggressive Acceleration',
          message: 'Try accelerating more gradually',
          icon: Icons.speed,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreLow.withOpacity(0.9),
        );
        
      case 'behavior_hard_braking':
        return _EventInfo(
          title: 'Hard Braking',
          message: 'Anticipate stops for smoother braking',
          icon: Icons.do_not_disturb,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreLow.withOpacity(0.9),
        );
        
      case 'behavior_idling':
        return _EventInfo(
          title: 'Extended Idling',
          message: 'Consider turning off engine when stopped',
          icon: Icons.timer,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreMedium.withOpacity(0.9),
        );
        
      case 'behavior_excessive_speed':
        return _EventInfo(
          title: 'Excessive Speed',
          message: 'Reduce speed for optimal efficiency',
          icon: Icons.shutter_speed,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreLow.withOpacity(0.9),
        );
        
      case 'behavior_optimal_speed':
        return _EventInfo(
          title: 'Optimal Speed',
          message: 'Great job maintaining efficient speed',
          icon: Icons.thumb_up,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreHigh.withOpacity(0.9),
        );
        
      case 'behavior_high_rpm':
        return _EventInfo(
          title: 'High RPM',
          message: 'Consider shifting up for better efficiency',
          icon: Icons.swap_vert_circle,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreMedium.withOpacity(0.9),
        );
        
      case 'trip_started':
        return _EventInfo(
          title: 'Trip Started',
          message: '',
          icon: Icons.play_circle,
          iconColor: Colors.white,
          backgroundColor: AppColors.secondary.withOpacity(0.9),
        );
        
      case 'obd_connection_error':
        return _EventInfo(
          title: 'OBD Connection Lost',
          message: 'Using phone sensors for data',
          icon: Icons.bluetooth_disabled,
          iconColor: Colors.white,
          backgroundColor: AppColors.ecoScoreMedium.withOpacity(0.9),
        );
        
      default:
        // If we get an unknown event type, provide a generic notification
        final String eventName = event.eventType.split('_').map((word) => 
            word.length > 0 ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
            
        return _EventInfo(
          title: eventName,
          message: '',
          icon: Icons.info,
          iconColor: Colors.white,
          backgroundColor: AppColors.info.withOpacity(0.9),
        );
    }
  }
}

/// Helper class to store event information
class _EventInfo {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  
  _EventInfo({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
} 