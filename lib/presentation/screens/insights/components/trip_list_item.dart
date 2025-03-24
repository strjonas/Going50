import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/core/utils/formatter_utils.dart';

/// A list item that displays information about a trip.
///
/// Shows date/time, distance, duration, eco-score and key events.
class TripListItem extends StatelessWidget {
  /// The trip to display
  final Trip trip;
  
  /// Callback when the item is tapped
  final VoidCallback? onTap;
  
  /// Constructor
  const TripListItem({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Format trip date/time
    final dateTimeFormat = DateFormat('MMM d, yyyy • h:mm a');
    final tripDateTime = dateTimeFormat.format(trip.startTime);
    
    // Format trip duration
    final duration = trip.endTime != null 
        ? trip.endTime!.difference(trip.startTime) 
        : Duration.zero;
    final durationText = FormatterUtils.formatDuration(duration);
    
    // Format trip distance
    final distanceText = trip.distanceKm != null
        ? FormatterUtils.formatDistance(trip.distanceKm!)
        : 'N/A';
    
    // Calculate eco-score (based on events)
    // This would normally come from the trip data, but for now we'll calculate it
    final ecoScore = _calculateEcoScore(trip);
    final ecoScoreColor = AppColors.getEcoScoreColor(ecoScore);
    
    // Get key events for indicators
    final hasAggressiveAcceleration = (trip.aggressiveAccelerationEvents ?? 0) > 0;
    final hasHardBraking = (trip.hardBrakingEvents ?? 0) > 0;
    final hasIdling = (trip.idlingEvents ?? 0) > 0;
    final hasExcessiveSpeed = (trip.excessiveSpeedEvents ?? 0) > 0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date/time and eco-score
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tripDateTime,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Eco-score badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ecoScoreColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ecoScoreColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.eco,
                          size: 14,
                          color: ecoScoreColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ecoScore.toInt().toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ecoScoreColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Distance and duration
              Row(
                children: [
                  // Distance
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.route,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distanceText,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  
                  // Duration
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          durationText,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Event indicators (if any)
              if (hasAggressiveAcceleration || hasHardBraking || hasIdling || hasExcessiveSpeed)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (hasAggressiveAcceleration)
                        _buildEventIndicator(
                          context,
                          'Aggressive Acceleration',
                          Icons.speed,
                          AppColors.warning,
                        ),
                      if (hasHardBraking)
                        _buildEventIndicator(
                          context,
                          'Hard Braking',
                          Icons.warning,
                          AppColors.error,
                        ),
                      if (hasIdling)
                        _buildEventIndicator(
                          context,
                          'Idling',
                          Icons.timer_off,
                          AppColors.warning,
                        ),
                      if (hasExcessiveSpeed)
                        _buildEventIndicator(
                          context,
                          'Excessive Speed',
                          Icons.shutter_speed,
                          AppColors.error,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build an event indicator chip
  Widget _buildEventIndicator(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Tooltip(
      message: label,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Calculate eco-score based on trip data
  /// This is a simplified version that would ideally come from the database
  double _calculateEcoScore(Trip trip) {
    // Base score
    double score = 75.0;
    
    // Deduct points for events
    if (trip.aggressiveAccelerationEvents != null && trip.aggressiveAccelerationEvents! > 0) {
      score -= trip.aggressiveAccelerationEvents! * 3;
    }
    
    if (trip.hardBrakingEvents != null && trip.hardBrakingEvents! > 0) {
      score -= trip.hardBrakingEvents! * 4;
    }
    
    if (trip.idlingEvents != null && trip.idlingEvents! > 0) {
      score -= trip.idlingEvents! * 2;
    }
    
    if (trip.excessiveSpeedEvents != null && trip.excessiveSpeedEvents! > 0) {
      score -= trip.excessiveSpeedEvents! * 3;
    }
    
    // Ensure score stays within 0-100 range
    return score.clamp(0.0, 100.0);
  }
} 