import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/services/driving/trip_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';

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
              (currentMetrics?.overallEcoScore ?? 0).toString(),
              'Best Eco-Score'
            ),
            FutureBuilder<double>(
              future: _getLongestTrip(),
              builder: (context, snapshot) {
                final longestTripDistance = snapshot.hasData 
                    ? snapshot.data!
                    : 0.0;
                
                return _buildStatisticItem(
                  context,
                  Icons.social_distance,
                  '${longestTripDistance.toStringAsFixed(1)} km',
                  'Longest Trip'
                );
              },
            ),
            FutureBuilder<String>(
              future: _getBestDrivingStreak(),
              builder: (context, snapshot) {
                final streakText = snapshot.hasData 
                    ? snapshot.data!
                    : '0 days';
                
                return _buildStatisticItem(
                  context,
                  Icons.speed,
                  streakText,
                  'Best Streak'
                );
              },
            ),
          ],
        ),
      ],
    );
  }
  
  /// Builds a section with title and list of statistics
  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.textTheme.titleLarge?.color,
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
    final theme = Theme.of(context);
    
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
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
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
  
  /// Gets the longest trip distance based on actual trip data
  Future<double> _getLongestTrip() async {
    // Get the trip service from the service locator
    final tripService = serviceLocator<TripService>();
    final userService = serviceLocator<UserService>();
    
    try {
      // Get the current user ID
      final userId = userService.currentUser?.id;
      if (userId == null) return 0.0;
      
      // Get all trips from the service
      final trips = await tripService.getTripHistory();
      
      // Filter for the current user's completed trips
      final userTrips = trips.where((trip) => 
        trip.userId == userId && 
        trip.isCompleted == true &&
        trip.distanceKm != null).toList();
      
      if (userTrips.isEmpty) return 0.0;
      
      // Find the trip with the maximum distance
      double maxDistance = 0.0;
      for (final trip in userTrips) {
        if (trip.distanceKm != null && trip.distanceKm! > maxDistance) {
          maxDistance = trip.distanceKm!;
        }
      }
      
      return maxDistance;
    } catch (e) {
      // Return 0 on error
      return 0.0;
    }
  }
  
  /// Gets the best driving streak based on streak data
  Future<String> _getBestDrivingStreak() async {
    // Get user service from the service locator
    final userService = serviceLocator<UserService>();
    
    try {
      // Get the current user
      final userId = userService.currentUser?.id;
      if (userId == null) return '0 days';
      
      // Get user metrics which should include best streak
      final userMetrics = await userService.getUserMetrics(userId);
      
      // Get best streak count (or 0 if not available)
      final bestStreakCount = userMetrics?['bestDrivingStreak'] as int? ?? 0;
      
      // Format the streak count
      return '$bestStreakCount days';
    } catch (e) {
      // Return 0 on error
      return '0 days';
    }
  }
} 