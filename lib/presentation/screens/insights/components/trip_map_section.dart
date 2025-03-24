import 'package:flutter/material.dart';
import 'package:going50/core_models/trip.dart';

/// Component that displays a map visualization of the trip route.
///
/// In a real implementation, this would use a mapping library like Google Maps.
/// For now, we'll create a placeholder with a simulated route visualization.
class TripMapSection extends StatelessWidget {
  /// The trip to display on the map
  final Trip trip;

  /// Constructor
  const TripMapSection({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Map placeholder with simulated route
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey.shade300,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _RoutePainter(),
              ),
            ),
          ),
          
          // Map overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.map,
                  size: 36,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'Route Map',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Location data not available',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          
          // Map controls (mockup)
          Positioned(
            right: 8,
            bottom: 8,
            child: Column(
              children: [
                _buildMapButton(Icons.add, () {}),
                const SizedBox(height: 8),
                _buildMapButton(Icons.remove, () {}),
                const SizedBox(height: 8),
                _buildMapButton(Icons.my_location, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a circular map control button
  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

/// Custom painter to simulate a route on the map
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade500
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Create a simulated route path
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * 0.5,
      size.width * 0.6, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.85,
      size.width * 0.85, size.height * 0.3,
    );
    
    canvas.drawPath(path, paint);
    
    // Draw the start point
    final startPointPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      6,
      startPointPaint,
    );
    
    // Draw a white border around the start point
    final startBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      6,
      startBorderPaint,
    );
    
    // Draw the end point
    final endPointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.3),
      6,
      endPointPaint,
    );
    
    // Draw a white border around the end point
    final endBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.3),
      6,
      endBorderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 