import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that displays a radar chart of driving behaviors
///
/// This chart visualizes various driving behavior scores using a radar chart
/// (also known as a spider or web chart) to show relative strengths and weaknesses.
class DrivingBehaviorsChart extends StatefulWidget {
  /// Map of behavior names to scores (0-100)
  final Map<String, int> behaviorScores;
  
  /// Colors for each behavior (optional)
  final Map<String, Color>? behaviorColors;
  
  /// Size of the chart
  final double size;
  
  /// Constructor
  const DrivingBehaviorsChart({
    super.key,
    required this.behaviorScores,
    this.behaviorColors,
    this.size = 250,
  });

  @override
  State<DrivingBehaviorsChart> createState() => _DrivingBehaviorsChartState();
}

class _DrivingBehaviorsChartState extends State<DrivingBehaviorsChart> 
    with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final behaviors = widget.behaviorScores.keys.toList();
    
    // Default color if no specific color is provided
    final defaultColor = theme.colorScheme.primary;
    
    return Column(
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _BehaviorChartPainter(
                  behaviorScores: widget.behaviorScores,
                  behaviorColors: widget.behaviorColors,
                  defaultColor: defaultColor,
                  animation: _animation.value,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(77), // ~30% opacity
                  lineColor: theme.colorScheme.outlineVariant,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: behaviors.map((behavior) {
              final color = widget.behaviorColors?[behavior] ?? defaultColor;
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatBehaviorName(behavior),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  
  /// Format behavior name for display (e.g., "calm_driving" -> "Calm Driving")
  String _formatBehaviorName(String behavior) {
    return behavior
        .split('_')
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Custom painter for the behavior chart
class _BehaviorChartPainter extends CustomPainter {
  final Map<String, int> behaviorScores;
  final Map<String, Color>? behaviorColors;
  final Color defaultColor;
  final double animation;
  final Color backgroundColor;
  final Color lineColor;
  
  _BehaviorChartPainter({
    required this.behaviorScores,
    this.behaviorColors,
    required this.defaultColor,
    required this.animation,
    required this.backgroundColor,
    required this.lineColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final behaviors = behaviorScores.keys.toList();
    final count = behaviors.length;
    
    if (count < 3) {
      // Not enough data points for a radar chart
      _drawError(canvas, size, 'Insufficient data');
      return;
    }
    
    // Draw background shape
    _drawBackground(canvas, center, radius, count);
    
    // Draw grid lines and labels
    _drawGrid(canvas, center, radius, count);
    
    // Draw data
    _drawData(canvas, center, radius, behaviors, count);
  }
  
  /// Draw error message when there's not enough data
  void _drawError(Canvas canvas, Size size, String message) {
    final textStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
    final textSpan = TextSpan(
      text: message,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(
      canvas, 
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2)
    );
  }
  
  /// Draw the background shape
  void _drawBackground(Canvas canvas, Offset center, double radius, int count) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Draw the outer polygon
    for (var i = 0; i < count; i++) {
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    
    path.close();
    canvas.drawPath(path, backgroundPaint);
  }
  
  /// Draw grid lines and axes
  void _drawGrid(Canvas canvas, Offset center, double radius, int count) {
    final gridPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // Draw axes
    for (var i = 0; i < count; i++) {
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      canvas.drawLine(center, point, gridPaint);
    }
    
    // Draw concentric circles for scale
    for (var i = 1; i <= 4; i++) {
      final circlePaint = Paint()
        ..color = lineColor.withAlpha((0.3 * i * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      
      canvas.drawCircle(
        center,
        radius * i / 4,
        circlePaint,
      );
    }
  }
  
  /// Draw the data shape
  void _drawData(Canvas canvas, Offset center, double radius, List<String> behaviors, int count) {
    final dataPath = Path();
    
    for (var i = 0; i < count; i++) {
      final behavior = behaviors[i];
      final score = behaviorScores[behavior] ?? 0;
      final normalizedScore = score / 100; // Assuming scores are 0-100
      final adjustedRadius = radius * normalizedScore * animation;
      
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final point = Offset(
        center.dx + adjustedRadius * math.cos(angle),
        center.dy + adjustedRadius * math.sin(angle),
      );
      
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    
    dataPath.close();
    
    // Fill with gradient
    final Color lightColor = defaultColor.withAlpha(179); // ~70% opacity
    final Color darkColor = defaultColor.withAlpha(77);  // ~30% opacity
    
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          lightColor,
          darkColor,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(dataPath, gradientPaint);
    
    // Draw outline
    final outlinePaint = Paint()
      ..color = defaultColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawPath(dataPath, outlinePaint);
    
    // Draw points
    final pointPaint = Paint()
      ..color = defaultColor
      ..style = PaintingStyle.fill;
    
    for (var i = 0; i < count; i++) {
      final behavior = behaviors[i];
      final score = behaviorScores[behavior] ?? 0;
      final normalizedScore = score / 100;
      final adjustedRadius = radius * normalizedScore * animation;
      
      final angle = 2 * math.pi * i / count - math.pi / 2;
      final point = Offset(
        center.dx + adjustedRadius * math.cos(angle),
        center.dy + adjustedRadius * math.sin(angle),
      );
      
      canvas.drawCircle(point, 4, pointPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _BehaviorChartPainter oldDelegate) {
    return oldDelegate.animation != animation ||
           oldDelegate.behaviorScores != behaviorScores ||
           oldDelegate.behaviorColors != behaviorColors ||
           oldDelegate.defaultColor != defaultColor ||
           oldDelegate.backgroundColor != backgroundColor ||
           oldDelegate.lineColor != lineColor;
  }
} 