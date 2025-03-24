import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/driving_event.dart';

/// Component that displays a chronological timeline of driving events during a trip.
///
/// This component shows:
/// - A vertical timeline of significant events
/// - Icons and descriptions for each event
/// - Timestamps showing when events occurred
class TripTimelineSection extends StatelessWidget {
  /// The trip to display the timeline for
  final Trip trip;

  /// Constructor
  const TripTimelineSection({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    // In a real implementation, we would fetch the actual events for this trip
    // For now, we'll create sample events based on the trip data
    final events = _generateSampleEvents();
    
    return events.isEmpty
        ? _buildEmptyState(context)
        : _buildTimeline(context, events);
  }
  
  /// Build the timeline view with events
  Widget _buildTimeline(BuildContext context, List<DrivingEvent> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length + 2, // +2 for start and end events
      itemBuilder: (context, index) {
        if (index == 0) {
          // Start of trip
          return _buildTimelineItem(
            context,
            'Trip Started',
            _formatTime(trip.startTime),
            Icons.play_circle,
            Colors.green,
            isFirst: true,
            isLast: false,
          );
        } else if (index == events.length + 1) {
          // End of trip
          return _buildTimelineItem(
            context,
            'Trip Ended',
            _formatTime(trip.endTime ?? trip.startTime.add(const Duration(minutes: 30))),
            Icons.stop_circle,
            Colors.red,
            isFirst: false,
            isLast: true,
            details: 'Total Distance: ${trip.distanceKm?.toStringAsFixed(1) ?? "N/A"} km',
          );
        } else {
          // Driving event
          final event = events[index - 1];
          
          String eventTitle;
          String details;
          IconData icon;
          Color color;
          
          switch (event.eventType) {
            case 'idling':
              eventTitle = 'Excessive Idling';
              details = 'Engine idling for ${_formatDuration(_calculateIdlingDuration(event.severity))}';
              icon = Icons.timer_off;
              color = Colors.amber;
              break;
            case 'aggressive_acceleration':
              eventTitle = 'Aggressive Acceleration';
              details = 'Acceleration rate: ${(event.magnitude ?? 0.0).toStringAsFixed(1)} m/s²';
              icon = Icons.trending_up;
              color = Colors.orange;
              break;
            case 'hard_braking':
              eventTitle = 'Hard Braking';
              details = 'Deceleration rate: ${(event.magnitude ?? 0.0).toStringAsFixed(1)} m/s²';
              icon = Icons.trending_down;
              color = Colors.red;
              break;
            case 'excessive_speed':
              eventTitle = 'Excessive Speed';
              details = 'Speed: ${(event.magnitude ?? 0.0).toStringAsFixed(1)} km/h';
              icon = Icons.speed;
              color = Colors.deepOrange;
              break;
            default:
              eventTitle = 'Driving Event';
              details = 'Unspecified event';
              icon = Icons.warning;
              color = Colors.grey;
          }
          
          return _buildTimelineItem(
            context,
            eventTitle,
            _formatTime(event.timestamp),
            icon,
            color,
            isFirst: false,
            isLast: false,
            details: details,
            severity: event.severity,
          );
        }
      },
    );
  }
  
  /// Build an empty state when no events are available
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timeline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No events to display',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Event data is not available for this trip',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // This would refresh the timeline data in a real implementation
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
  
  /// Build a timeline item
  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color, {
    required bool isFirst,
    required bool isLast,
    String? details,
    double? severity,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and dot
        SizedBox(
          width: 40,
          child: Column(
            children: [
              // Top line (hidden for first item)
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey.shade300,
                ),
              
              // Timeline dot
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
              ),
              
              // Bottom line (hidden for last item)
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: 2,
                    height: 60,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        ),
        
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                
                // Title and severity
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (severity != null)
                      _buildSeverityIndicator(severity),
                  ],
                ),
                
                // Details if available
                if (details != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      details,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                
                // Location badge (for demonstration)
                if (!isFirst && !isLast)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Location unavailable',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  /// Build a severity indicator
  Widget _buildSeverityIndicator(double severity) {
    Color color;
    String label;
    
    if (severity >= 0.7) {
      color = Colors.red;
      label = 'High';
    } else if (severity >= 0.4) {
      color = Colors.orange;
      label = 'Medium';
    } else {
      color = Colors.yellow;
      label = 'Low';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Format a timestamp to a readable time string
  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
  
  /// Format a duration in minutes to a readable string
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '$minutes min ${seconds.toString().padLeft(2, '0')} sec';
    } else {
      return '${seconds.toString()} sec';
    }
  }
  
  /// Calculate idling duration based on severity
  Duration _calculateIdlingDuration(double severity) {
    // Simply create a duration based on severity (0-1 scale)
    // In a real app, this would come from actual measurements
    final seconds = (30 + severity * 90).round(); // 30s to 2min range
    return Duration(seconds: seconds);
  }
  
  /// Generate sample driving events based on the trip data
  List<DrivingEvent> _generateSampleEvents() {
    final events = <DrivingEvent>[];
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // Only generate events if the trip has event counts
    if (trip.aggressiveAccelerationEvents == null && 
        trip.hardBrakingEvents == null &&
        trip.idlingEvents == null &&
        trip.excessiveSpeedEvents == null) {
      return [];
    }
    
    // Calculate the trip duration
    final tripDuration = trip.endTime != null 
        ? trip.endTime!.difference(trip.startTime) 
        : const Duration(minutes: 30);
    
    // Helper function to create random timestamp within trip duration
    DateTime randomTimestamp() {
      final randomMinutes = (random % tripDuration.inMinutes).toInt();
      return trip.startTime.add(Duration(minutes: randomMinutes));
    }
    
    // Add aggressive acceleration events
    for (int i = 0; i < (trip.aggressiveAccelerationEvents ?? 0); i++) {
      events.add(DrivingEvent(
        id: 'acc_$i',
        tripId: trip.id,
        timestamp: randomTimestamp(),
        eventType: 'aggressive_acceleration',
        severity: 0.5 + (random % 5) / 10, // 0.5-0.9 range
        magnitude: 3.0 + (random % 30) / 10, // 3.0-6.0 m/s² range
      ));
    }
    
    // Add hard braking events
    for (int i = 0; i < (trip.hardBrakingEvents ?? 0); i++) {
      events.add(DrivingEvent(
        id: 'brk_$i',
        tripId: trip.id,
        timestamp: randomTimestamp(),
        eventType: 'hard_braking',
        severity: 0.5 + (random % 5) / 10, // 0.5-0.9 range
        magnitude: 3.0 + (random % 40) / 10, // 3.0-7.0 m/s² range
      ));
    }
    
    // Add idling events
    for (int i = 0; i < (trip.idlingEvents ?? 0); i++) {
      events.add(DrivingEvent(
        id: 'idl_$i',
        tripId: trip.id,
        timestamp: randomTimestamp(),
        eventType: 'idling',
        severity: 0.3 + (random % 7) / 10, // 0.3-0.9 range
      ));
    }
    
    // Add excessive speed events
    for (int i = 0; i < (trip.excessiveSpeedEvents ?? 0); i++) {
      events.add(DrivingEvent(
        id: 'spd_$i',
        tripId: trip.id,
        timestamp: randomTimestamp(),
        eventType: 'excessive_speed',
        severity: 0.4 + (random % 6) / 10, // 0.4-0.9 range
        magnitude: 110 + (random % 40), // 110-150 km/h range
      ));
    }
    
    // Sort by timestamp
    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return events;
  }
} 