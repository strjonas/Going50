import 'package:flutter/material.dart';

/// A card for displaying statistic data with a headline figure and label.
///
/// This card follows the design system with specific padding,
/// corner radius, elevation, and text styles for statistics display.
///
/// Example:
/// ```dart
/// StatsCard(
///   headline: '87',
///   label: 'Eco-Score',
///   comparisonText: '12% better than last week',
///   isPositiveComparison: true,
///   onTap: () {
///     // Handle card tap
///   },
/// )
/// ```
class StatsCard extends StatelessWidget {
  /// The headline figure to display prominently
  final String headline;
  
  /// The label describing what the headline represents
  final String label;
  
  /// Optional text to show comparison with previous period
  final String? comparisonText;
  
  /// Whether the comparison is positive (true) or negative (false)
  final bool? isPositiveComparison;
  
  /// Optional icon to display with the headline
  final IconData? icon;
  
  /// Optional callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Create a stats card with the app's styling
  const StatsCard({
    super.key,
    required this.headline,
    required this.label,
    this.comparisonText,
    this.isPositiveComparison,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: theme.colorScheme.primary, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(178), // ~0.7 opacity
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                headline,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              if (comparisonText != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (isPositiveComparison != null)
                      Icon(
                        isPositiveComparison! 
                            ? Icons.arrow_upward 
                            : Icons.arrow_downward,
                        color: isPositiveComparison! 
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.error,
                        size: 14,
                      ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        comparisonText!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isPositiveComparison != null
                              ? (isPositiveComparison!
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error)
                              : theme.colorScheme.onSurface.withAlpha(178), // ~0.7 opacity
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 