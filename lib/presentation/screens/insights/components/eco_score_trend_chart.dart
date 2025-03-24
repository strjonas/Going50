import 'package:flutter/material.dart';

/// A widget that displays the eco-score trend over time
///
/// This simple chart shows eco-score values over time as a line chart
/// with smooth animations and an area fill beneath the line.
class EcoScoreTrendChart extends StatefulWidget {
  /// List of eco-score data points
  final List<double> scores;
  
  /// Labels for the X-axis (optional)
  final List<String>? labels;
  
  /// Title of the chart (optional)
  final String? title;
  
  /// Height of the chart
  final double height;

  /// Constructor
  const EcoScoreTrendChart({
    super.key,
    required this.scores,
    this.labels,
    this.title,
    this.height = 200,
  });

  @override
  State<EcoScoreTrendChart> createState() => _EcoScoreTrendChartState();
}

class _EcoScoreTrendChartState extends State<EcoScoreTrendChart> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
    final scores = widget.scores;
    
    if (scores.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'No eco-score data available',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
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
          child: AnimatedBuilder(
            animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ChartPainter(
                    scores: scores,
                    animation: _animation.value,
                    lineColor: theme.colorScheme.primary,
                    fillColor: theme.colorScheme.primary.withAlpha(51), // ~20% opacity
                  ),
                );
              },
            ),
          ),
        if (widget.labels != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.labels!.map((label) => 
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              ).toList(),
            ),
          ),
      ],
    );
  }
}

/// Custom painter for the chart
class _ChartPainter extends CustomPainter {
  final List<double> scores;
  final double animation;
  final Color lineColor;
  final Color fillColor;
  
  _ChartPainter({
    required this.scores,
    required this.animation,
    required this.lineColor,
    required this.fillColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;
    
    final height = size.height;
    final width = size.width;
    
    // Calculate step width
    final stepX = width / (scores.length - 1);
    
    // Find min and max scores for scaling
    final maxScore = 100.0; // Eco-score is typically 0-100
    final minScore = 0.0;
    final range = maxScore - minScore;
    
    // Create path for the line
    final path = Path();
    final fillPath = Path();
    
    // Start the fill path at the bottom-left
    fillPath.moveTo(0, height);
    
    // First point
    final firstY = height - (scores.first - minScore) / range * height * animation;
    path.moveTo(0, firstY);
    fillPath.lineTo(0, firstY);
    
    // Add points to both paths
    for (var i = 1; i < scores.length; i++) {
      final x = stepX * i;
      final y = height - (scores[i] - minScore) / range * height * animation;
      
      if (i < scores.length - 1) {
        // Use Bezier curve for smoother line
        final nextX = stepX * (i + 1);
        final nextY = height - (scores[i + 1] - minScore) / range * height * animation;
        
        final controlX1 = x + (nextX - x) / 3;
        final controlY1 = y;
        final controlX2 = x + 2 * (nextX - x) / 3;
        final controlY2 = nextY;
        
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, nextX, nextY);
        fillPath.cubicTo(controlX1, controlY1, controlX2, controlY2, nextX, nextY);
     } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
     }
   }
   
    // Complete the fill path
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();
    
    // Draw fill
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
    
    // Draw data points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    
    // Draw points only if we have a small number of them (to avoid clutter)
    if (scores.length <= 10) {
      for (var i = 0; i < scores.length; i++) {
        final x = stepX * i;
        final y = height - (scores[i] - minScore) / range * height * animation;
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.animation != animation || 
           oldDelegate.scores != scores || 
           oldDelegate.lineColor != lineColor ||
           oldDelegate.fillColor != fillColor;
  }
} 