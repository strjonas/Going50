import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A radar chart component that visualizes multiple metrics in a radial formation.
///
/// This component is useful for displaying skill assessments, behavior patterns,
/// or any multi-dimensional data that can be represented in a radial format.
class AppRadarChart extends StatefulWidget {
  /// The data to display in the chart
  final Map<String, double> data;
  
  /// The maximum value for the data points (usually 100.0)
  final double maxValue;
  
  /// The number of rings to display in the chart background
  final int rings;
  
  /// The size of the chart (both width and height)
  final double size;
  
  /// The color of the chart fill
  final Color? fillColor;
  
  /// The color of the chart outline
  final Color? outlineColor;
  
  /// The color for the chart grid lines
  final Color? gridColor;
  
  /// The color for the chart labels
  final Color? labelColor;
  
  /// Whether to animate the chart when it first appears
  final bool animate;
  
  /// Creates a radar chart
  const AppRadarChart({
    super.key,
    required this.data,
    this.maxValue = 100.0,
    this.rings = 4,
    this.size = 300.0,
    this.fillColor,
    this.outlineColor,
    this.gridColor,
    this.labelColor,
    this.animate = true,
  });

  @override
  State<AppRadarChart> createState() => _AppRadarChartState();
}

class _AppRadarChartState extends State<AppRadarChart> with SingleTickerProviderStateMixin {
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
    
    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(AppRadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reset animation if data changes
    if (widget.data != oldWidget.data) {
      if (widget.animate) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _animationController.value = 1.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // If no data, display a placeholder
    if (widget.data.isEmpty) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(
          child: Text(
            'No data available',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }
    
    // Get effective colors
    final fillColor = widget.fillColor ?? theme.colorScheme.primary.withOpacity(0.2);
    final outlineColor = widget.outlineColor ?? theme.colorScheme.primary;
    final gridColor = widget.gridColor ?? theme.colorScheme.outline.withOpacity(0.3);
    final labelColor = widget.labelColor ?? theme.colorScheme.onSurface;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RadarChartPainter(
              data: widget.data,
              maxValue: widget.maxValue,
              rings: widget.rings,
              animation: _animation.value,
              fillColor: fillColor,
              outlineColor: outlineColor,
              gridColor: gridColor,
              labelColor: labelColor,
              textStyle: theme.textTheme.bodySmall,
            ),
            size: Size(widget.size, widget.size),
          ),
        );
      },
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, double> data;
  final double maxValue;
  final int rings;
  final double animation;
  final Color fillColor;
  final Color outlineColor;
  final Color gridColor;
  final Color labelColor;
  final TextStyle? textStyle;
  
  _RadarChartPainter({
    required this.data,
    required this.maxValue,
    required this.rings,
    required this.animation,
    required this.fillColor,
    required this.outlineColor,
    required this.gridColor,
    required this.labelColor,
    this.textStyle,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 30; // Leave space for labels
    
    final categories = data.keys.toList();
    final values = data.values.toList();
    final count = categories.length;
    
    if (count < 3) {
      // Not enough points for a radar chart
      _drawErrorMessage(canvas, size, 'Insufficient data (need at least 3 points)');
      return;
    }
    
    // Draw rings and spokes
    _drawGrid(canvas, center, radius, count);
    
    // Draw data polygon
    _drawData(canvas, center, radius, count, values);
    
    // Draw labels
    _drawLabels(canvas, center, radius, count, categories);
  }
  
  void _drawGrid(Canvas canvas, Offset center, double radius, int count) {
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    // Draw concentric rings
    for (int i = 1; i <= rings; i++) {
      final ringRadius = radius * i / rings;
      canvas.drawCircle(center, ringRadius, gridPaint);
    }
    
    // Draw spokes from center to each corner
    for (int i = 0; i < count; i++) {
      final angle = 2 * math.pi * i / count - math.pi / 2; // Start from top (270 degrees)
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      canvas.drawLine(
        center,
        Offset(x, y),
        gridPaint,
      );
    }
  }
  
  void _drawData(Canvas canvas, Offset center, double radius, int count, List<double> values) {
    // Create a path for the data polygon
    final path = Path();
    
    // Move to the first point
    final firstAngle = -math.pi / 2; // Start from top (270 degrees)
    final firstValue = (values[0] / maxValue).clamp(0.0, 1.0) * animation;
    final firstX = center.dx + radius * firstValue * math.cos(firstAngle);
    final firstY = center.dy + radius * firstValue * math.sin(firstAngle);
    path.moveTo(firstX, firstY);
    
    // Draw lines to each point
    for (int i = 1; i < count; i++) {
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final value = (values[i] / maxValue).clamp(0.0, 1.0) * animation;
      final x = center.dx + radius * value * math.cos(angle);
      final y = center.dy + radius * value * math.sin(angle);
      
      path.lineTo(x, y);
    }
    
    // Close the path
    path.close();
    
    // Draw fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
    
    // Draw outline
    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);
    
    // Draw data points
    final pointPaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < count; i++) {
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final value = (values[i] / maxValue).clamp(0.0, 1.0) * animation;
      final x = center.dx + radius * value * math.cos(angle);
      final y = center.dy + radius * value * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }
  
  void _drawLabels(Canvas canvas, Offset center, double radius, int count, List<String> categories) {
    final effectiveTextStyle = textStyle ?? const TextStyle(fontSize: 12, color: Colors.black);
    
    for (int i = 0; i < count; i++) {
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final labelRadius = radius + 20; // Position labels slightly outside the chart
      
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);
      
      final textSpan = TextSpan(
        text: categories[i],
        style: effectiveTextStyle.copyWith(color: labelColor),
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      
      textPainter.layout(minWidth: 0, maxWidth: 80);
      
      // Adjust text position based on angle
      Offset textOffset;
      if (angle == -math.pi / 2) { // Top
        textOffset = Offset(x - textPainter.width / 2, y - textPainter.height);
      } else if (angle > -math.pi / 2 && angle < math.pi / 2) { // Right side
        textOffset = Offset(x, y - textPainter.height / 2);
      } else if (angle == math.pi / 2) { // Bottom
        textOffset = Offset(x - textPainter.width / 2, y);
      } else { // Left side
        textOffset = Offset(x - textPainter.width, y - textPainter.height / 2);
      }
      
      textPainter.paint(canvas, textOffset);
    }
  }
  
  void _drawErrorMessage(Canvas canvas, Size size, String message) {
    final textSpan = TextSpan(
      text: message,
      style: TextStyle(color: labelColor, fontSize: 12),
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }
  
  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
           oldDelegate.maxValue != maxValue ||
           oldDelegate.rings != rings ||
           oldDelegate.animation != animation ||
           oldDelegate.fillColor != fillColor ||
           oldDelegate.outlineColor != outlineColor ||
           oldDelegate.gridColor != gridColor ||
           oldDelegate.labelColor != labelColor ||
           oldDelegate.textStyle != textStyle;
  }
} 