import 'package:flutter/material.dart';

/// A widget that allows users to select a time period for insights data
///
/// This widget displays a row of selectable time period options (day, week, month, year)
/// with the currently selected option highlighted.
class TimePeriodSelector extends StatelessWidget {
  /// The currently selected time period
  final String selected;
  
  /// Callback when a time period is selected
  final Function(String) onSelect;
  
  /// Available time period options
  final List<String> options;
  
  /// Constructor
  const TimePeriodSelector({
    super.key,
    required this.selected,
    required this.onSelect,
    this.options = const ['day', 'week', 'month', 'year'],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(77), // ~30% opacity
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selected;
          
          return GestureDetector(
            onTap: () => onSelect(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getDisplayText(option),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                      ? theme.colorScheme.onPrimaryContainer 
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  /// Converts the time period option to a display-friendly format
  String _getDisplayText(String option) {
    switch (option) {
      case 'day':
        return 'Day';
      case 'week':
        return 'Week';
      case 'month':
        return 'Month';
      case 'year':
        return 'Year';
      default:
        return option.substring(0, 1).toUpperCase() + option.substring(1);
    }
  }
} 