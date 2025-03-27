import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';

/// Shared filter components for community screens.
/// 
/// These components ensure consistent styling and behavior across
/// the leaderboard and challenges views.

/// SegmentedFilterBar provides a segmented control for filtering content.
///
/// Used across multiple components for consistent filtering UI.
class SegmentedFilterBar extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onSelectionChanged;
  
  const SegmentedFilterBar({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Clean, modern design with better spacing and visual clarity
    return Container(
      height: 52, // Optimal touch target height
      margin: const EdgeInsets.only(top: 4.0, bottom: 16.0), // Better spacing
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color, // Use theme color instead of hardcoded white
        border: Border(
          bottom: BorderSide(color: theme.dividerTheme.color ?? Colors.transparent, width: 1), // Use theme color
        ),
      ),
      child: Row(
        children: List.generate(
          options.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color, // Use theme color
                  borderRadius: BorderRadius.circular(12), // More rounded corners
                  border: selectedIndex == index
                      ? Border.all(color: AppColors.primary, width: 1.5) // Keep primary color for selection
                      : null,
                ),
                child: Center(
                  child: Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selectedIndex == index ? FontWeight.w600 : FontWeight.w400,
                      color: selectedIndex == index ? AppColors.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// TimeFilterChipGroup provides chips for time-based filtering.
///
/// Used across multiple components for consistent time filtering UI.
class TimeFilterChipGroup extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onSelectionChanged;
  
  const TimeFilterChipGroup({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Modern pill-style design with better spacing
    return Container(
      height: 44, // Optimal height
      margin: const EdgeInsets.only(bottom: 24.0), // More bottom margin for better section separation
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(
          options.length,
          (index) {
            final isSelected = selectedIndex == index;
            
            return Padding(
              padding: EdgeInsets.only(right: index < options.length - 1 ? 12 : 0), // More space between chips
              child: GestureDetector(
                onTap: () => onSelectionChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200), // Smooth transition
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // More comfortable padding
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(22), // More pronounced pill shape
                    border: Border.all(
                      color: isSelected ? AppColors.primary : theme.dividerTheme.color ?? Colors.transparent,
                      width: isSelected ? 1.5 : 1, // Thicker border for selected item
                    ),
                    // Subtle shadow for depth - only in light mode
                    boxShadow: isSelected && theme.brightness == Brightness.light ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 