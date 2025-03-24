import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// A reusable line chart component that can be used throughout the app.
///
/// This component provides a customizable line chart with support for
/// multiple data series, animations, and various styling options.
class AppLineChart extends StatefulWidget {
  /// The data points for the chart.
  /// 
  /// Each list represents a separate line series.
  /// Each point should have an x and y value.
  final List<List<FlSpot>> dataPoints;
  
  /// Labels for the X-axis.
  final List<String>? xLabels;
  
  /// Labels for the Y-axis.
  final List<String>? yLabels;
  
  /// Whether to show grid lines.
  final bool showGrid;
  
  /// Whether to fill the area below the line.
  final bool showFill;
  
  /// Whether to show the line dots.
  final bool showDots;
  
  /// The y-axis minimum value.
  final double? minY;
  
  /// The y-axis maximum value.
  final double? maxY;
  
  /// The title of the chart.
  final String? title;
  
  /// The colors for each line series.
  final List<Color>? lineColors;
  
  /// The fill colors for each line series.
  final List<Color>? fillColors;
  
  /// The width of the lines.
  final double lineWidth;
  
  /// The radius of the dots.
  final double dotRadius;
  
  /// The height of the chart.
  final double height;
  
  /// The width of the chart.
  /// 
  /// If null, the chart will take the full available width.
  final double? width;
  
  /// Creates a line chart.
  const AppLineChart({
    super.key,
    required this.dataPoints,
    this.xLabels,
    this.yLabels,
    this.showGrid = true,
    this.showFill = true,
    this.showDots = true,
    this.minY,
    this.maxY,
    this.title,
    this.lineColors,
    this.fillColors,
    this.lineWidth = 2,
    this.dotRadius = 3,
    this.height = 200,
    this.width,
  });

  @override
  State<AppLineChart> createState() => _AppLineChartState();
}

class _AppLineChartState extends State<AppLineChart> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(AppLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reset animation if data changes
    if (widget.dataPoints != oldWidget.dataPoints) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.dataPoints.isEmpty || 
        widget.dataPoints.any((series) => series.isEmpty)) {
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
    double effectiveMinY = widget.minY ?? double.infinity;
    double effectiveMaxY = widget.maxY ?? -double.infinity;
    
    if (widget.minY == null || widget.maxY == null) {
      for (final series in widget.dataPoints) {
        for (final spot in series) {
          if (spot.y < effectiveMinY) effectiveMinY = spot.y;
          if (spot.y > effectiveMaxY) effectiveMaxY = spot.y;
        }
      }
      
      // Add some padding
      final range = effectiveMaxY - effectiveMinY;
      effectiveMinY -= range * 0.1;
      effectiveMaxY += range * 0.1;
      
      // Ensure non-zero range
      if (effectiveMinY == effectiveMaxY) {
        effectiveMinY -= 1;
        effectiveMaxY += 1;
      }
    }
    
    // Calculate min/max X
    double minX = double.infinity;
    double maxX = -double.infinity;
    
    for (final series in widget.dataPoints) {
      for (final spot in series) {
        if (spot.x < minX) minX = spot.x;
        if (spot.x > maxX) maxX = spot.x;
      }
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
              return LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.8),
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final seriesIndex = spot.barIndex;
                          final color = widget.lineColors != null && 
                                       seriesIndex < widget.lineColors!.length
                              ? widget.lineColors![seriesIndex]
                              : theme.colorScheme.primary;
                              
                          return LineTooltipItem(
                            spot.y.toStringAsFixed(1),
                            TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            children: widget.xLabels != null && 
                                  spot.x.toInt() < widget.xLabels!.length
                                ? [
                                    TextSpan(
                                      text: '\n${widget.xLabels![spot.x.toInt()]}',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ]
                                : null,
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: widget.showGrid,
                    drawVerticalLine: widget.showGrid,
                    horizontalInterval: (effectiveMaxY - effectiveMinY) / 4,
                    verticalInterval: (maxX - minX) / 6,
                    checkToShowHorizontalLine: (value) => 
                      value % ((effectiveMaxY - effectiveMinY) / 4) == 0,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      strokeWidth: 0.5,
                    ),
                    getDrawingVerticalLine: (_) => FlLine(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      strokeWidth: 0.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: widget.xLabels != null,
                        getTitlesWidget: (value, meta) {
                          if (widget.xLabels == null || 
                              value < 0 || 
                              value >= widget.xLabels!.length) {
                            return const SizedBox();
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.xLabels![value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (widget.yLabels != null) {
                            // Use custom labels if provided
                            final index = ((value - effectiveMinY) / 
                                (effectiveMaxY - effectiveMinY) * 
                                widget.yLabels!.length).floor();
                                
                            if (index >= 0 && index < widget.yLabels!.length) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  widget.yLabels![index],
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              );
                            }
                          }
                          
                          // Default numeric labels
                          if ((value == effectiveMinY || 
                               value == effectiveMaxY || 
                               value == (effectiveMinY + effectiveMaxY) / 2)) {
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
                  minX: minX,
                  maxX: maxX,
                  minY: effectiveMinY,
                  maxY: effectiveMaxY,
                  lineBarsData: _buildLineData(
                    theme,
                    widget.dataPoints,
                    _animation.value,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  /// Builds line chart data with animation
  List<LineChartBarData> _buildLineData(
    ThemeData theme,
    List<List<FlSpot>> seriesData,
    double animationValue,
  ) {
    return List.generate(seriesData.length, (seriesIndex) {
      final spots = seriesData[seriesIndex];
      
      final color = widget.lineColors != null && 
                   seriesIndex < widget.lineColors!.length
          ? widget.lineColors![seriesIndex]
          : theme.colorScheme.primary;
          
      final fillColor = widget.fillColors != null && 
                       seriesIndex < widget.fillColors!.length
          ? widget.fillColors![seriesIndex]
          : color.withOpacity(0.2);
      
      // For animation, we'll show only a portion of the line based on animation value
      final animatedSpots = <FlSpot>[];
      final pointCount = spots.length;
      
      for (var i = 0; i < pointCount; i++) {
        final spot = spots[i];
        if (i <= pointCount * animationValue) {
          animatedSpots.add(spot);
        }
      }
      
      return LineChartBarData(
        spots: animatedSpots,
        isCurved: true,
        curveSmoothness: 0.3,
        color: color,
        barWidth: widget.lineWidth,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: widget.showDots,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: widget.dotRadius,
            color: color,
            strokeWidth: 1,
            strokeColor: Colors.white,
          ),
        ),
        belowBarData: BarAreaData(
          show: widget.showFill,
          color: fillColor,
          cutOffY: widget.minY ?? 0,
        ),
      );
    });
  }
} 