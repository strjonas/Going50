import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:going50/core/theme/app_colors.dart';

/// A modal bottom sheet for filtering trips.
///
/// Includes:
/// - Date range picker
/// - Eco-score range slider
/// - Distance range slider
/// - Event type checkboxes
/// - Apply/Reset buttons
class FilterSheet extends StatefulWidget {
  /// Initial date range for filtering
  final DateTimeRange? initialDateRange;
  
  /// Initial eco-score range for filtering (0-100)
  final RangeValues? initialEcoScoreRange;
  
  /// Initial distance range for filtering (in km)
  final RangeValues? initialDistanceRange;
  
  /// Initial selected event types
  final List<String>? initialSelectedEventTypes;
  
  /// Callback when filter is applied
  final Function(
    DateTimeRange? dateRange,
    RangeValues ecoScoreRange,
    RangeValues distanceRange,
    List<String> selectedEventTypes,
  ) onApply;
  
  /// Constructor
  const FilterSheet({
    super.key,
    this.initialDateRange,
    this.initialEcoScoreRange,
    this.initialDistanceRange,
    this.initialSelectedEventTypes,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late DateTimeRange? _dateRange;
  late RangeValues _ecoScoreRange;
  late RangeValues _distanceRange;
  late List<String> _selectedEventTypes;
  
  final List<Map<String, dynamic>> _eventTypes = [
    {'id': 'aggressive_acceleration', 'label': 'Aggressive Acceleration', 'icon': Icons.speed},
    {'id': 'hard_braking', 'label': 'Hard Braking', 'icon': Icons.warning},
    {'id': 'idling', 'label': 'Idling', 'icon': Icons.timer_off},
    {'id': 'excessive_speed', 'label': 'Excessive Speed', 'icon': Icons.shutter_speed},
  ];
  
  // Formatters
  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  
  @override
  void initState() {
    super.initState();
    _dateRange = widget.initialDateRange;
    _ecoScoreRange = widget.initialEcoScoreRange ?? const RangeValues(0, 100);
    _distanceRange = widget.initialDistanceRange ?? const RangeValues(0, 100);
    _selectedEventTypes = widget.initialSelectedEventTypes?.toList() ?? [];
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Trips',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Date range picker
          Text(
            'Date Range',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectDateRange,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 12),
                  Text(
                    _dateRange != null
                        ? '${_dateFormat.format(_dateRange!.start)} - ${_dateFormat.format(_dateRange!.end)}'
                        : 'All time',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  if (_dateRange != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _dateRange = null;
                        });
                      },
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Eco-score range slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eco-Score',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_ecoScoreRange.start.round()}-${_ecoScoreRange.end.round()}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10,
              ),
            ),
            child: RangeSlider(
              values: _ecoScoreRange,
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels(
                _ecoScoreRange.start.round().toString(),
                _ecoScoreRange.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _ecoScoreRange = values;
                });
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Distance range slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distance (km)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_distanceRange.start.round()}-${_distanceRange.end.round()}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10,
              ),
            ),
            child: RangeSlider(
              values: _distanceRange,
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels(
                _distanceRange.start.round().toString(),
                _distanceRange.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  _distanceRange = values;
                });
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Event type checkboxes
          Text(
            'Event Types',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _eventTypes.map((eventType) {
              final id = eventType['id'] as String;
              final label = eventType['label'] as String;
              final icon = eventType['icon'] as IconData;
              final isSelected = _selectedEventTypes.contains(id);
              
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedEventTypes.add(id);
                    } else {
                      _selectedEventTypes.remove(id);
                    }
                  });
                },
                checkmarkColor: Colors.white,
                selectedColor: AppColors.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              // Reset button
              OutlinedButton(
                onPressed: _resetFilters,
                child: const Text('Reset'),
              ),
              const SizedBox(width: 12),
              // Apply button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      _dateRange,
                      _ecoScoreRange,
                      _distanceRange,
                      _selectedEventTypes,
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Reset all filters to their default values
  void _resetFilters() {
    setState(() {
      _dateRange = null;
      _ecoScoreRange = const RangeValues(0, 100);
      _distanceRange = const RangeValues(0, 100);
      _selectedEventTypes = [];
    });
  }
  
  /// Open the date range picker dialog
  Future<void> _selectDateRange() async {
    final initialDateRange = _dateRange ?? DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
    
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (newDateRange != null) {
      setState(() {
        _dateRange = newDateRange;
      });
    }
  }
} 