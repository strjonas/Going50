import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';

/// Shared filter components for community screens.
/// 
/// These components ensure consistent styling and behavior across
/// the leaderboard and challenges views.

/// A segmented filter bar (Friends/Local/Global or Active/Available/Completed)
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: List.generate(options.length, (index) {
            return Expanded(
              child: _buildFilterTab(options[index], index),
            );
          }),
        ),
      ),
    );
  }
  
  Widget _buildFilterTab(String text, int index) {
    final bool isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onSelectionChanged(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// A horizontal filter chip group for time periods (Week/Month/All time)
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
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: options.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onSelectionChanged(index),
              child: _buildTimeFilterChip(options[index], index == selectedIndex),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildTimeFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(4), // Squared corners as requested
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey.shade800,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
} 