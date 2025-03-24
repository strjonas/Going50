import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/presentation/screens/insights/components/trip_map_section.dart';
import 'package:going50/presentation/screens/insights/components/trip_metrics_section.dart';
import 'package:going50/presentation/screens/insights/components/trip_timeline_section.dart';

/// A screen that displays detailed information about a specific trip.
///
/// This screen shows:
/// - Map visualization of the trip route (if location permitted)
/// - Detailed metrics with tabs for different categories
/// - Timeline of driving events
class TripDetailScreen extends StatefulWidget {
  /// The ID of the trip to display
  final String tripId;
  
  /// Constructor
  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load the trip data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTripData();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  /// Load the trip data from the provider
  Future<void> _loadTripData() async {
    final insightsProvider = Provider.of<InsightsProvider>(context, listen: false);
    await insightsProvider.selectTrip(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement sharing functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing coming soon!'))
              );
            },
          ),
        ],
      ),
      body: Consumer<InsightsProvider>(
        builder: (context, insightsProvider, child) {
          if (insightsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (insightsProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading trip details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insightsProvider.errorMessage ?? 'Unknown error',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _loadTripData(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          if (insightsProvider.selectedTrip == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.not_listed_location,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Trip not found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The requested trip could not be found',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          
          final trip = insightsProvider.selectedTrip!;
          
          return Column(
            children: [
              // Trip header with basic info
              _buildTripHeader(trip),
              
              // Tab bar
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Metrics'),
                    Tab(text: 'Timeline'),
                  ],
                ),
              ),
              
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Overview tab with map
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Map visualization
                          TripMapSection(trip: trip),
                          
                          // Summary metrics
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildSummaryMetrics(trip),
                          ),
                        ],
                      ),
                    ),
                    
                    // Detailed metrics tab
                    TripMetricsSection(trip: trip),
                    
                    // Timeline tab
                    TripTimelineSection(trip: trip),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  /// Build the trip header with basic information
  Widget _buildTripHeader(Trip trip) {
    // Format the date and time
    final dateFormatter = DateFormat('E, MMM d, yyyy');
    final timeFormatter = DateFormat('h:mm a');
    final date = dateFormatter.format(trip.startTime);
    final startTime = timeFormatter.format(trip.startTime);
    final endTime = trip.endTime != null ? timeFormatter.format(trip.endTime!) : 'N/A';
    
    // Calculate duration
    final duration = trip.endTime != null 
      ? _formatDuration(trip.endTime!.difference(trip.startTime))
      : 'Unknown';
    
    // Calculate eco-score - using a placeholder calculation
    final ecoScore = _calculateEcoScore(trip);
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Date and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$startTime - $endTime',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Eco-score
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: _getScoreColor(ecoScore),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    ecoScore.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _getScoreColor(ecoScore),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Trip stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context, 
                '${trip.distanceKm?.toStringAsFixed(1) ?? 'N/A'} km',
                'Distance',
                Icons.map,
              ),
              _buildStatItem(
                context, 
                '${trip.averageSpeedKmh?.toStringAsFixed(1) ?? 'N/A'} km/h',
                'Avg Speed',
                Icons.speed,
              ),
              _buildStatItem(
                context, 
                duration,
                'Duration',
                Icons.timer,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Build a summary metrics card
  Widget _buildSummaryMetrics(Trip trip) {
    // Calculate fuel used and savings
    final fuelUsed = trip.fuelUsedL ?? 0.0;
    final fuelSavings = fuelUsed * 0.1; // Assuming 10% savings from eco-driving
    
    // Calculate CO2 emissions and reduction (2.3kg per liter of fuel)
    final co2Reduction = fuelSavings * 2.3;
    
    // Calculate money saved (assuming $1.50 per liter)
    final moneySaved = fuelSavings * 1.50;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eco-Driving Impact',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Savings grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSavingItem(
                  context,
                  '${fuelSavings.toStringAsFixed(2)} L',
                  'Fuel Saved',
                  Icons.local_gas_station,
                  Colors.green,
                ),
                _buildSavingItem(
                  context,
                  '${co2Reduction.toStringAsFixed(2)} kg',
                  'CO₂ Reduction',
                  Icons.eco,
                  Colors.teal,
                ),
                _buildSavingItem(
                  context,
                  '\$${moneySaved.toStringAsFixed(2)}',
                  'Money Saved',
                  Icons.attach_money,
                  Colors.amber,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Event summary
            Text(
              'Driving Events',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Event counts
            _buildEventRow(context, 
              'Aggressive Acceleration', 
              trip.aggressiveAccelerationEvents ?? 0, 
              Icons.trending_up
            ),
            _buildEventRow(context, 
              'Hard Braking', 
              trip.hardBrakingEvents ?? 0, 
              Icons.trending_down
            ),
            _buildEventRow(context, 
              'Excessive Idling', 
              trip.idlingEvents ?? 0, 
              Icons.timer_off
            ),
            _buildEventRow(context, 
              'Speed Violations', 
              trip.excessiveSpeedEvents ?? 0, 
              Icons.speed
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a stat item for the header
  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 18,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
  
  /// Build a saving item for the impact section
  Widget _buildSavingItem(BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
  
  /// Build an event row for the event summary
  Widget _buildEventRow(BuildContext context, String label, int count, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: count > 0 ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: count > 0 ? Colors.orange : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Format a duration to a readable string
  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int hours = minutes ~/ 60;
    minutes = minutes % 60;
    
    if (hours > 0) {
      return '$hours h ${minutes.toString().padLeft(2, '0')} min';
    } else {
      return '$minutes min';
    }
  }
  
  /// Calculate eco-score from trip data
  double _calculateEcoScore(Trip trip) {
    // Base score
    double score = 75.0;
    
    // Deduct points for events
    if (trip.aggressiveAccelerationEvents != null && trip.aggressiveAccelerationEvents! > 0) {
      score -= trip.aggressiveAccelerationEvents! * 3;
    }
    
    if (trip.hardBrakingEvents != null && trip.hardBrakingEvents! > 0) {
      score -= trip.hardBrakingEvents! * 4;
    }
    
    if (trip.idlingEvents != null && trip.idlingEvents! > 0) {
      score -= trip.idlingEvents! * 2;
    }
    
    if (trip.excessiveSpeedEvents != null && trip.excessiveSpeedEvents! > 0) {
      score -= trip.excessiveSpeedEvents! * 3;
    }
    
    // Ensure score stays within 0-100 range
    return score.clamp(0.0, 100.0);
  }
  
  /// Get color based on score value
  Color _getScoreColor(double score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }
} 