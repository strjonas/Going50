import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/services/gamification/challenge_service.dart';

/// ChallengeProgressSection displays progress for a challenge.
///
/// This component includes:
/// - Visual progress indicator
/// - Current progress text
/// - Target description
/// - Time remaining
class ChallengeProgressSection extends StatelessWidget {
  /// Current progress value
  final int progress;
  
  /// Target value to complete the challenge
  final int targetValue;
  
  /// Type of metric being measured
  final String metricType;
  
  /// Whether the challenge is completed
  final bool isCompleted;
  
  /// Time remaining text
  final String timeRemaining;
  
  /// Constructor
  const ChallengeProgressSection({
    super.key,
    required this.progress,
    required this.targetValue,
    required this.metricType,
    required this.isCompleted,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercent = targetValue > 0 
        ? (progress / targetValue).clamp(0.0, 1.0) 
        : 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$progress/$targetValue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getMetricLabel(metricType),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor: Colors.grey.shade200,
                        color: isCompleted ? AppColors.success : AppColors.primary,
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildTimeRemaining(),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoNote(),
        ],
      ),
    );
  }
  
  Widget _buildTimeRemaining() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.success.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? AppColors.success.withOpacity(0.3) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.timer_outlined,
            size: 16,
            color: isCompleted ? AppColors.success : Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isCompleted ? 'Completed' : timeRemaining,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
              color: isCompleted ? AppColors.success : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoNote() {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Congratulations! You have completed this challenge.',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final String description = _getProgressDescription();
      
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue.shade700,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  
  String _getMetricLabel(String metricType) {
    switch (metricType) {
      case MetricType.ecoScore:
        return 'points';
      case MetricType.tripCount:
        return 'trips';
      case MetricType.distanceKm:
        return 'kilometers';
      case MetricType.activeDays:
        return 'days';
      case MetricType.calmDriving:
        return 'points';
      case MetricType.speedOptimization:
        return 'points';
      case MetricType.idlingScore:
        return 'points';
      case MetricType.fuelSaved:
        return 'liters';
      case MetricType.co2Reduced:
        return 'kg';
      case MetricType.steadySpeed:
        return 'points';
      default:
        return '';
    }
  }
  
  String _getProgressDescription() {
    final int remaining = targetValue - progress;
    
    if (remaining <= 0) {
      return 'You have met the target! Complete any remaining requirements to finish the challenge.';
    }
    
    switch (metricType) {
      case MetricType.ecoScore:
        return 'Achieve a score of $targetValue to complete this challenge.';
      case MetricType.tripCount:
        return 'Complete $remaining more trip${remaining == 1 ? '' : 's'} to achieve this challenge.';
      case MetricType.distanceKm:
        return 'Drive $remaining more kilometer${remaining == 1 ? '' : 's'} to complete this challenge.';
      case MetricType.activeDays:
        return 'Drive on $remaining more day${remaining == 1 ? '' : 's'} to complete this challenge.';
      case MetricType.calmDriving:
        return 'Improve your calm driving score to $targetValue to complete this challenge.';
      case MetricType.fuelSaved:
        return 'Save $remaining more liter${remaining == 1 ? '' : 's'} of fuel to complete this challenge.';
      case MetricType.co2Reduced:
        return 'Reduce CO₂ emissions by $remaining more kg to complete this challenge.';
      default:
        return 'Complete the required progress to achieve this challenge.';
    }
  }
} 