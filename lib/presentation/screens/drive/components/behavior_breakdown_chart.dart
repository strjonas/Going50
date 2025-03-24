import 'package:flutter/material.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core_models/trip.dart';

/// A component that displays a breakdown of driving behaviors in a visual chart.
///
/// This chart shows the different driving behavior categories and their scores 
/// based on the trip data.
class BehaviorBreakdownChart extends StatelessWidget {
  /// The trip to analyze
  final Trip trip;
  
  /// Constructor
  const BehaviorBreakdownChart({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate behavior scores from trip data
    final behaviorScores = _calculateBehaviorScores(trip);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Driving Behavior Breakdown',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Behavior chart
          ...behaviorScores.entries.map((entry) => 
            _buildBehaviorScoreBar(
              context, 
              entry.key, 
              entry.value, 
              _getBehaviorDescription(entry.key),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds a horizontal score bar for a behavior
  Widget _buildBehaviorScoreBar(
    BuildContext context,
    String behavior,
    double score,
    String description,
  ) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBarWidth = screenWidth - 76; // Account for padding and labels
    final barWidth = (score / 100) * maxBarWidth;
    
    // Determine color based on score
    final Color barColor = _getScoreColor(score);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Behavior name and score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                behavior,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                score.round().toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 6),
          
          // Score bar
          Stack(
            children: [
              // Background bar
              Container(
                height: 8,
                width: maxBarWidth,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Filled bar
              Container(
                height: 8,
                width: barWidth,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Description
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Divider
          const Divider(height: 1),
        ],
      ),
    );
  }
  
  /// Calculate behavior scores based on trip data
  Map<String, double> _calculateBehaviorScores(Trip trip) {
    // Default score (perfect)
    final scores = {
      'Acceleration': 100.0,
      'Braking': 100.0,
      'Speed': 100.0,
      'Idling': 100.0,
      'Consistency': 100.0,
    };
    
    // Adjust scores based on trip events
    // Note: These are simplified calculations that could be improved
    
    // Acceleration score
    if (trip.aggressiveAccelerationEvents != null && trip.aggressiveAccelerationEvents! > 0) {
      final events = trip.aggressiveAccelerationEvents!;
      scores['Acceleration'] = 100.0 - (events * 20.0).clamp(0.0, 100.0);
    }
    
    // Braking score
    if (trip.hardBrakingEvents != null && trip.hardBrakingEvents! > 0) {
      final events = trip.hardBrakingEvents!;
      scores['Braking'] = 100.0 - (events * 20.0).clamp(0.0, 100.0);
    }
    
    // Speed score
    if (trip.excessiveSpeedEvents != null && trip.excessiveSpeedEvents! > 0) {
      final events = trip.excessiveSpeedEvents!;
      scores['Speed'] = 100.0 - (events * 15.0).clamp(0.0, 100.0);
    }
    
    // Idling score
    if (trip.idlingEvents != null && trip.idlingEvents! > 0) {
      final events = trip.idlingEvents!;
      scores['Idling'] = 100.0 - (events * 10.0).clamp(0.0, 100.0);
    }
    
    // Consistency score (based on stop events)
    if (trip.stopEvents != null && trip.stopEvents! > 0) {
      final events = trip.stopEvents!;
      final distanceKm = trip.distanceKm ?? 10.0;
      
      // Calculate events per km (more events per km = lower consistency)
      final eventsPerKm = events / distanceKm;
      scores['Consistency'] = 100.0 - (eventsPerKm * 25.0).clamp(0.0, 100.0);
    }
    
    return scores;
  }
  
  /// Get color for a score
  Color _getScoreColor(double score) {
    return AppColors.getEcoScoreColor(score);
  }
  
  /// Get description for a behavior category
  String _getBehaviorDescription(String behavior) {
    switch (behavior) {
      case 'Acceleration':
        return 'Smooth acceleration saves fuel and reduces wear on the vehicle';
      case 'Braking':
        return 'Gentle braking improves safety and fuel efficiency';
      case 'Speed':
        return 'Maintaining optimal speed ranges improves fuel economy';
      case 'Idling':
        return 'Reducing idle time saves fuel and reduces emissions';
      case 'Consistency':
        return 'Consistent driving with fewer stops improves efficiency';
      default:
        return 'Eco-driving improves efficiency and reduces environmental impact';
    }
  }
} 