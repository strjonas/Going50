import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math'; // Import for max function

/// A reusable bar chart component that can be used throughout the app.
///
/// This component provides a customizable bar chart with support for
/// multiple series, animations, and various styling options.
class AppBarChart extends StatefulWidget {
  /// The data for the chart.
  /// 
  /// List of x values paired with y values (height).
  final List<BarData> data;
  
  /// Labels for the X-axis.
  final List<String>? xLabels;
  
  /// The interval between x values. Defaults to 1.0.
  final double xInterval;
  
  /// The y-axis minimum value.
  final double? minY;
  
  /// The y-axis maximum value.
  final double? maxY;
  
  /// The title of the chart.
  final String? title;
  
  /// Whether to show the grid.
  final bool showGrid;
  
  /// The width of the bars.
  final double barWidth;
  
  /// The height of the chart.
  final double height;
  
  /// The width of the chart.
  final double? width;
  
  /// The color of the bars.
  final Color? barColor;
  
  /// Function to determine the color of the bar based on its value.
  final Color Function(double value)? getBarColor;
  
  /// Creates a bar chart.
  const AppBarChart({
    super.key,
    required this.data,
    this.xLabels,
    this.xInterval = 1.0,
    this.minY,
    this.maxY,
    this.title,
    this.showGrid = true,
    this.barWidth = 20,
    this.height = 200,
    this.width,
    this.barColor,
    this.getBarColor,
  });

  @override
  State<AppBarChart> createState() => _AppBarChartState();
}

class _AppBarChartState extends State<AppBarChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(AppBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reset animation if data changes
    if (widget.data != oldWidget.data) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: Text(
            'No data available',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }
    
    // Calculate min/max Y if not provided
    double effectiveMinY = widget.minY ?? 0;
    double effectiveMaxY = widget.maxY ?? 0;
    
    if (widget.maxY == null) {
      for (final bar in widget.data) {
        if (bar.y > effectiveMaxY) {
          effectiveMaxY = bar.y;
        }
      }
      // Add 10% padding at the top
      effectiveMaxY += effectiveMaxY * 0.1;
    }
    
    // Ensure non-zero range
    if (effectiveMaxY == effectiveMinY) {
      effectiveMaxY = effectiveMinY + 1;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
            child: Text(
              widget.title!,
              style: theme.textTheme.titleMedium,
            ),
          ),
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: effectiveMaxY,
                  minY: effectiveMinY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final barData = widget.data[groupIndex];
                        return BarTooltipItem(
                          barData.y.toStringAsFixed(1),
                          TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          children: widget.xLabels != null && 
                                  groupIndex < widget.xLabels!.length
                              ? [
                                  TextSpan(
                                    text: '\n${widget.xLabels![groupIndex]}',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ]
                              : null,
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: widget.xLabels != null,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (widget.xLabels == null || 
                              index < 0 || 
                              index >= widget.xLabels!.length) {
                            return const SizedBox();
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.xLabels![index],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          // Only show a few labels
                          if (value == effectiveMinY || 
                              value == effectiveMaxY || 
                              value == (effectiveMinY + effectiveMaxY) / 2) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toStringAsFixed(1),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            );
                          }
                          
                          return const SizedBox();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: widget.showGrid,
                    drawVerticalLine: false,
                    horizontalInterval: max((widget.maxY ?? 1) / 4, 0.1),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.5),
                        width: 1,
                      ),
                      left: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  barGroups: _buildBarGroups(widget.data, _animation.value),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  /// Builds bar groups with animation
  List<BarChartGroupData> _buildBarGroups(List<BarData> data, double animationValue) {
    return List.generate(data.length, (index) {
      final barData = data[index];
      final animatedHeight = barData.y * animationValue;
      
      Color barColor = widget.barColor ?? 
          Theme.of(context).colorScheme.primary;
          
      if (widget.getBarColor != null) {
        barColor = widget.getBarColor!(barData.y);
      } else if (barData.color != null) {
        barColor = barData.color!;
      }
      
      return BarChartGroupData(
        x: barData.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: animatedHeight,
            color: barColor,
            width: widget.barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: data.map((e) => e.y).reduce((a, b) => a > b ? a : b),
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      );
    });
  }
}

/// Data for a single bar in the chart
class BarData {
  /// X-coordinate of the bar
  final double x;
  
  /// Height of the bar
  final double y;
  
  /// Optional color of the bar
  final Color? color;
  
  /// Optional label for the bar
  final String? label;
  
  /// Creates a bar data object
  const BarData({
    required this.x,
    required this.y,
    this.color,
    this.label,
  });
} 