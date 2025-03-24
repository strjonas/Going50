import 'package:flutter/material.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'dart:math' as math;

/// A gauge chart that displays an eco-score value.
///
/// This component provides a visually appealing gauge visualization
/// for displaying eco-score values from 0-100, with appropriate colors
/// based on the score range. The gauge includes animations and an
/// optional text display.
class EcoScoreGauge extends StatefulWidget {
  /// The eco-score value to display (0-100)
  final double score;
  
  /// The size of the gauge
  final double size;
  
  /// Whether to show the score text
  final bool showScore;
  
  /// Whether to show the gauge label
  final bool showLabel;
  
  /// The thickness of the gauge arc
  final double thickness;
  
  /// The background color of the gauge
  final Color? backgroundColor;
  
  /// Optional custom label text
  final String? label;
  
  /// Creates an eco-score gauge
  const EcoScoreGauge({
    super.key,
    required this.score,
    this.size = 150,
    this.showScore = true,
    this.showLabel = true,
    this.thickness = 10.0,
    this.backgroundColor,
    this.label,
  });

  @override
  State<EcoScoreGauge> createState() => _EcoScoreGaugeState();
}

class _EcoScoreGaugeState extends State<EcoScoreGauge> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(EcoScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.score != widget.score) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreValue = widget.score.clamp(0.0, 100.0);
    
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _EcoScoreGaugePainter(
                    score: scoreValue * _animation.value,
                    backgroundColor: widget.backgroundColor ?? 
                        theme.colorScheme.surfaceVariant.withOpacity(0.4),
                    thickness: widget.thickness,
                  ),
                  size: Size(widget.size, widget.size),
                );
              },
            ),
          ),
          if (widget.showScore)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                scoreValue.round().toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.getEcoScoreColor(scoreValue),
                ),
              ),
            ),
          if (widget.showLabel)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.label ?? 'Eco-Score',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter for the eco-score gauge
class _EcoScoreGaugePainter extends CustomPainter {
  final double score;
  final Color backgroundColor;
  final double thickness;
  
  _EcoScoreGaugePainter({
    required this.score,
    required this.backgroundColor,
    required this.thickness,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - thickness / 2;
    
    // Draw background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8, // Start at 144 degrees
      math.pi * 1.4, // End at 396 degrees (or 36 degrees)
      false,
      backgroundPaint,
    );
    
    // Calculate the angle based on the score (0-100)
    final angle = (score / 100) * math.pi * 1.4;
    
    // Draw colored arc
    final scorePaint = Paint()
      ..color = AppColors.getEcoScoreColor(score)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8, // Start at 144 degrees
      angle, // End based on score
      false,
      scorePaint,
    );
    
    // Draw small ticks for gauge markings
    _drawTicks(canvas, center, radius, size);
  }
  
  /// Draws tick marks around the gauge
  void _drawTicks(Canvas canvas, Offset center, double radius, Size size) {
    final tickPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    const tickCount = 10; // Number of ticks
    final outerRadius = radius + thickness / 2 + 2;
    final innerRadius = radius + thickness / 2 - 2;
    
    for (int i = 0; i <= tickCount; i++) {
      // Calculate angle for this tick
      final angle = math.pi * 0.8 + (i / tickCount) * math.pi * 1.4;
      
      // Calculate start and end points for tick line
      final outerX = center.dx + outerRadius * math.cos(angle);
      final outerY = center.dy + outerRadius * math.sin(angle);
      final innerX = center.dx + innerRadius * math.cos(angle);
      final innerY = center.dy + innerRadius * math.sin(angle);
      
      // Draw the tick
      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        tickPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant _EcoScoreGaugePainter oldDelegate) {
    return oldDelegate.score != score ||
           oldDelegate.backgroundColor != backgroundColor ||
           oldDelegate.thickness != thickness;
  }
} 