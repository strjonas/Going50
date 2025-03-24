import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/core_models/combined_driving_data.dart';

/// A strip of current driving metrics shown at the bottom of the active driving screen.
///
/// This component displays essential real-time metrics such as speed, acceleration, and RPM,
/// along with a button to end the current trip.
class CurrentMetricsStrip extends StatefulWidget {
  /// Callback when end trip button is tapped
  final VoidCallback onEndTripTap;
  
  /// Constructor
  const CurrentMetricsStrip({
    super.key,
    required this.onEndTripTap,
  });

  @override
  State<CurrentMetricsStrip> createState() => _CurrentMetricsStripState();
}

class _CurrentMetricsStripState extends State<CurrentMetricsStrip> {
  CombinedDrivingData? _latestData;
  Timer? _refreshTimer;
  
  @override
  void initState() {
    super.initState();
    _setupRefreshTimer();
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  void _setupRefreshTimer() {
    // Refresh metrics every 1 second
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshData();
    });
    
    // Initial data load
    _refreshData();
  }
  
  Future<void> _refreshData() async {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    final latestData = await drivingProvider.getLatestDrivingData();
    
    if (mounted && latestData != null) {
      setState(() {
        _latestData = latestData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Metrics row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem(
                label: 'SPEED',
                value: _getSpeedValue(),
                unit: 'km/h',
              ),
              _buildMetricItem(
                label: 'RPM',
                value: _getRpmValue(),
                unit: '',
              ),
              _buildMetricItem(
                label: 'ACCEL',
                value: _getAccelerationValue(),
                unit: 'm/s²',
                isGood: _isAccelerationGood(),
              ),
            ],
          ),
          
          // End trip button
          TextButton.icon(
            onPressed: widget.onEndTripTap,
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('END TRIP'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMetricItem({
    required String label,
    required String value,
    required String unit,
    bool? isGood,
  }) {
    // Determine color based on whether the value is good/optimal
    Color valueColor = Colors.white;
    if (isGood != null) {
      valueColor = isGood ? AppColors.ecoScoreHigh : AppColors.ecoScoreLow;
    }
    
    return Column(
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        // Value and unit
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: unit.isNotEmpty ? ' $unit' : '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Helper methods to extract and format data
  
  String _getSpeedValue() {
    if (_latestData == null) return '0';
    final speed = _latestData!.obdData?.vehicleSpeed ?? _latestData!.sensorData?.gpsSpeed;
    if (speed == null) return '0';
    return speed.toInt().toString();
  }
  
  String _getRpmValue() {
    if (_latestData == null || _latestData!.obdData?.rpm == null) return '0';
    final rpm = _latestData!.obdData!.rpm!.toInt();
    return rpm.toString();
  }
  
  String _getAccelerationValue() {
    if (_latestData == null) return '0.0';
    final accel = _latestData!.calculatedAcceleration ?? _latestData!.sensorData?.accelerationX;
    if (accel == null) return '0.0';
    // Convert to m/s² and limit to one decimal place
    return accel.toStringAsFixed(1);
  }
  
  bool? _isAccelerationGood() {
    if (_latestData == null) return null;
    if (_latestData!.isAggressive != null) {
      return !_latestData!.isAggressive!;
    }
    // Determine based on raw values if the derived flag is not available
    final accel = _latestData!.calculatedAcceleration ?? _latestData!.sensorData?.accelerationX;
    if (accel == null) return null;
    // Moderate acceleration is considered good (values are approximate)
    // Positive means acceleration, negative means braking
    return (accel > -3.0 && accel < 2.0);
  }
} 