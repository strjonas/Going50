import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/core/utils/formatter_utils.dart';

/// A card that displays information about the most recent trip.
///
/// Shows date/time, distance, eco-score, and savings metrics.
class RecentTripCard extends StatelessWidget {
  /// The trip to display
  final Trip trip;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Constructor
  const RecentTripCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Format trip date/time
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final tripDate = dateFormat.format(trip.startTime);
    final tripTime = timeFormat.format(trip.startTime);
    
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
    // This is a simple calculation that could be improved with a dedicated algorithm
    final ecoScore = _calculateEcoScore(trip);
    final ecoScoreColor = AppColors.getEcoScoreColor(ecoScore);
    
    // Calculate estimated savings
    // These are simple estimates that could be improved with more sophisticated calculations
    final fuelSavedLiters = _calculateFuelSaved(trip);
    final co2SavedKg = fuelSavedLiters * 2.3; // ~2.3kg CO2 per liter of fuel
    final moneySaved = fuelSavedLiters * 1.5; // Assuming $1.50 per liter
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Date and time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tripDate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tripTime,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Eco-score badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ecoScoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                          color: ecoScoreColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ecoScore.toInt().toString(),
                          style: TextStyle(
                            color: ecoScoreColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Trip details
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
              
              const SizedBox(height: 12),
              
              // Savings section
              Row(
                children: [
                  // Fuel saved
                  Expanded(
                    child: _buildSavingsItem(
                      context,
                      icon: Icons.local_gas_station,
                      label: 'Fuel',
                      value: '${fuelSavedLiters.toStringAsFixed(1)}L',
                    ),
                  ),
                  
                  // CO2 saved
                  Expanded(
                    child: _buildSavingsItem(
                      context,
                      icon: Icons.cloud,
                      label: 'CO₂',
                      value: '${co2SavedKg.toStringAsFixed(1)}kg',
                    ),
                  ),
                  
                  // Money saved
                  Expanded(
                    child: _buildSavingsItem(
                      context,
                      icon: Icons.attach_money,
                      label: 'Money',
                      value: FormatterUtils.formatCurrency(moneySaved),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Calculates an eco-score based on trip data
  double _calculateEcoScore(Trip trip) {
    // Start with a perfect score and subtract for events
    double score = 100;
    
    // Only calculate if the trip is completed
    if (!trip.isCompleted || trip.distanceKm == null || trip.distanceKm! <= 0) {
      return 50; // Default score for incomplete or invalid trips
    }
    
    // Get total events, or use default values if null
    final idling = trip.idlingEvents ?? 0;
    final acceleration = trip.aggressiveAccelerationEvents ?? 0;
    final braking = trip.hardBrakingEvents ?? 0;
    final speeding = trip.excessiveSpeedEvents ?? 0;
    
    // Calculate events per km
    final distance = trip.distanceKm!;
    final eventsPerKm = (idling + acceleration + braking + speeding) / distance;
    
    // Subtract points based on events per km (adjust these values as needed)
    if (eventsPerKm > 5) {
      score -= 50;
    } else if (eventsPerKm > 2) {
      score -= 30;
    } else if (eventsPerKm > 1) {
      score -= 15;
    } else if (eventsPerKm > 0.5) {
      score -= 5;
    }
    
    // Ensure score stays within 0-100 range
    return score.clamp(0, 100);
  }
  
  /// Calculates estimated fuel saved based on trip data
  double _calculateFuelSaved(Trip trip) {
    // This is a very simple estimate - in a real app this would be more sophisticated
    if (!trip.isCompleted || trip.distanceKm == null || trip.fuelUsedL == null) {
      return 0.5; // Default value for incomplete trips
    }
    
    // Calculate based on distance and actual fuel used
    // Here we're making a simple assumption of potential savings
    // In a real implementation, this would compare to baseline fuel consumption
    final distance = trip.distanceKm!;
    final fuelUsed = trip.fuelUsedL!;
    
    // Estimate 10% better than average for a positive user experience
    return (distance * 0.07) - fuelUsed; // 0.07L/km is an average consumption
  }
  
  /// Builds a savings item with icon, label, and value
  Widget _buildSavingsItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
} 