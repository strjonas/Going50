import 'package:flutter/material.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/services/driving/analytics_service.dart';

/// A card that displays an improvement suggestion for eco-driving.
///
/// This component shows a driving improvement tip with a description
/// of the benefits of implementing the suggestion.
class ImprovementSuggestionCard extends StatelessWidget {
  /// The suggestion to display
  final FeedbackSuggestion suggestion;
  
  /// Constructor
  const ImprovementSuggestionCard({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine priority icon and color
    final (IconData icon, Color color) = _getPriorityIconAndColor(suggestion.priority);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Text(
                    _getCategoryTitle(suggestion.category),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                _buildPriorityTag(context, suggestion.priority),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Suggestion text
            Text(
              suggestion.suggestion,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Benefit text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 16,
                ),
                
                const SizedBox(width: 8),
                
                Expanded(
                  child: Text(
                    suggestion.benefit,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a priority tag widget
  Widget _buildPriorityTag(BuildContext context, int priority) {
    final color = priority == 3 
        ? AppColors.error 
        : (priority == 2 ? AppColors.warning : AppColors.info);
    
    final label = priority == 3 
        ? 'High' 
        : (priority == 2 ? 'Medium' : 'Low');
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
  
  /// Get an icon and color based on priority
  (IconData, Color) _getPriorityIconAndColor(int priority) {
    switch (priority) {
      case 3: // High
        return (Icons.priority_high, AppColors.error);
      case 2: // Medium
        return (Icons.notifications, AppColors.warning);
      default: // Low
        return (Icons.lightbulb_outline, AppColors.info);
    }
  }
  
  /// Get a human-readable title for a category
  String _getCategoryTitle(String category) {
    switch (category) {
      case 'calmDriving':
        return 'Smoother Driving';
      case 'speedOptimization':
        return 'Speed Management';
      case 'idling':
        return 'Reduce Idling';
      case 'shortDistance':
        return 'Trip Planning';
      case 'rpmManagement':
        return 'Engine Efficiency';
      case 'stopManagement':
        return 'Anticipate Traffic';
      case 'followDistance':
        return 'Following Distance';
      default:
        return 'Driving Improvement';
    }
  }
} 