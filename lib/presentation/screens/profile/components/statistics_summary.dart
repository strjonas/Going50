import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';

/// StatisticsSummary displays key user statistics and personal records
class StatisticsSummary extends StatelessWidget {
  /// Constructor
  const StatisticsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final insightsProvider = Provider.of<InsightsProvider>(context);
    final currentMetrics = insightsProvider.currentMetrics;
    
    // Get statistics from the metrics
    final totalTrips = currentMetrics?.totalTrips ?? 0;
    final totalDistance = currentMetrics?.totalDistanceKm ?? 0;
    final totalDrivingTime = currentMetrics?.totalDrivingTimeMinutes ?? 0;
    final fuelSaved = insightsProvider.fuelSavings;
    final moneySaved = insightsProvider.moneySavings;
    final co2Reduced = insightsProvider.co2Reduction;
    
    return Column(
      children: [
        // Key statistics section
        _buildSection(
          context, 
          'Key Statistics',
          [
            _buildStatisticItem(
              context,
              Icons.track_changes,
              totalTrips.toString(),
              'Total Trips'
            ),
            _buildStatisticItem(
              context,
              Icons.route,
              '${totalDistance.toStringAsFixed(1)} km',
              'Distance Driven'
            ),
            _buildStatisticItem(
              context,
              Icons.timer,
              _formatDrivingTime(totalDrivingTime),
              'Driving Time'
            ),
            _buildStatisticItem(
              context,
              Icons.local_gas_station,
              '${fuelSaved.toStringAsFixed(1)} L',
              'Fuel Saved'
            ),
            _buildStatisticItem(
              context,
              Icons.attach_money,
              '\$${moneySaved.toStringAsFixed(1)}',
              'Money Saved'
            ),
            _buildStatisticItem(
              context,
              Icons.co2,
              '${co2Reduced.toStringAsFixed(1)} kg',
              'CO₂ Reduced'
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Personal records section
        _buildSection(
          context, 
          'Personal Records',
          [
            _buildStatisticItem(
              context,
              Icons.star,
              (insightsProvider.currentMetrics?.overallEcoScore ?? 0).toString(),
              'Best Eco-Score'
            ),
            _buildStatisticItem(
              context,
              Icons.social_distance,
              '${_getLongestTrip(insightsProvider).toStringAsFixed(1)} km',
              'Longest Trip'
            ),
            _buildStatisticItem(
              context,
              Icons.speed,
              _getBestDrivingStreak(insightsProvider),
              'Best Streak'
            ),
          ],
        ),
      ],
    );
  }
  
  /// Builds a section with title and list of statistics
  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
  
  /// Builds a single statistic item with icon, value, and label
  Widget _buildStatisticItem(BuildContext context, IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Formats driving time into a human-readable string
  String _formatDrivingTime(double minutes) {
    final hours = (minutes / 60).floor();
    final remainingMinutes = (minutes % 60).floor();
    
    if (hours > 0) {
      return '$hours hr ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}';
    } else {
      return '$remainingMinutes min';
    }
  }
  
  /// Gets the longest trip distance (mock implementation)
  double _getLongestTrip(InsightsProvider provider) {
    // In a real implementation, this would query the trips data
    // For now, return a mock value
    return provider.currentMetrics?.totalDistanceKm ?? 0 * 0.25;
  }
  
  /// Gets the best driving streak (mock implementation)
  String _getBestDrivingStreak(InsightsProvider provider) {
    // In a real implementation, this would query streak data
    // For now, return a mock value
    return '${(provider.currentMetrics?.totalTrips ?? 0) ~/ 3} days';
  }
} 