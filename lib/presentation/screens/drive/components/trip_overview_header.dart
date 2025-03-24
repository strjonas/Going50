import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/core/utils/formatter_utils.dart';

/// Header component for the trip summary screen that shows basic
/// trip information like date, time, duration, and eco-score.
class TripOverviewHeader extends StatelessWidget {
  /// The trip to display
  final Trip trip;
  
  /// Optional custom eco-score to display
  final double? ecoScore;
  
  /// Constructor
  const TripOverviewHeader({
    super.key,
    required this.trip,
    this.ecoScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Format trip date/time
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final tripDate = dateFormat.format(trip.startTime);
    final tripTime = timeFormat.format(trip.startTime);
    
    // Format trip duration
    final duration = trip.endTime != null 
        ? trip.endTime!.difference(trip.startTime) 
        : Duration.zero;
    final durationText = FormatterUtils.formatDuration(duration);
    
    // Calculate eco-score
    final score = ecoScore ?? _calculateEcoScore(trip);
    final scoreColor = AppColors.getEcoScoreColor(score);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Trip Summary',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Date and time
          Text(
            tripDate,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Started at $tripTime',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats row
          Row(
            children: [
              // Duration
              Expanded(
                child: _buildStatItem(
                  context,
                  'Duration',
                  durationText,
                  Icons.access_time,
                ),
              ),
              
              // Distance
              Expanded(
                child: _buildStatItem(
                  context,
                  'Distance',
                  trip.distanceKm != null
                      ? FormatterUtils.formatDistance(trip.distanceKm!)
                      : 'N/A',
                  Icons.straighten,
                ),
              ),
              
              // Eco-score
              Expanded(
                child: _buildStatItem(
                  context,
                  'Eco-Score',
                  '${score.toInt()}',
                  Icons.eco,
                  valueColor: scoreColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Builds a stat item with an icon, label, and value
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  /// Calculate eco-score based on trip data
  /// This is a simplified version that could be improved with a more sophisticated algorithm
  double _calculateEcoScore(Trip trip) {
    if (!trip.isCompleted) return 0.0;
    
    // Base score
    double score = 100.0;
    
    // Event penalties
    if (trip.idlingEvents != null && trip.idlingEvents! > 0) {
      score -= trip.idlingEvents! * 2;
    }
    
    if (trip.aggressiveAccelerationEvents != null && trip.aggressiveAccelerationEvents! > 0) {
      score -= trip.aggressiveAccelerationEvents! * 5;
    }
    
    if (trip.hardBrakingEvents != null && trip.hardBrakingEvents! > 0) {
      score -= trip.hardBrakingEvents! * 5;
    }
    
    if (trip.excessiveSpeedEvents != null && trip.excessiveSpeedEvents! > 0) {
      score -= trip.excessiveSpeedEvents! * 3;
    }
    
    // Clamp score between 0 and 100
    return score.clamp(0.0, 100.0);
  }
} 