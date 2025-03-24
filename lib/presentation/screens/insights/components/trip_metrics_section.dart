import 'package:flutter/material.dart';
import 'package:going50/core_models/trip.dart';

/// Component that displays detailed metrics about a trip with multiple tabs.
///
/// This component shows various metrics grouped by category:
/// - Performance: Speed, RPM, acceleration
/// - Efficiency: Fuel consumption, eco-score breakdown
/// - Behavior: Driving events and recommendations
class TripMetricsSection extends StatefulWidget {
  /// The trip to display metrics for
  final Trip trip;

  /// Constructor
  const TripMetricsSection({
    super.key,
    required this.trip,
  });

  @override
  State<TripMetricsSection> createState() => _TripMetricsSectionState();
}

class _TripMetricsSectionState extends State<TripMetricsSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Metrics tab bar
        Container(
          color: Colors.grey.shade200,
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Performance'),
              Tab(text: 'Efficiency'),
              Tab(text: 'Behavior'),
            ],
          ),
        ),
        
        // Metrics tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Performance tab
              _buildPerformanceTab(),
              
              // Efficiency tab
              _buildEfficiencyTab(),
              
              // Behavior tab
              _buildBehaviorTab(),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build the performance metrics tab
  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Speed Metrics'),
          const SizedBox(height: 16),
          
          // Speed metrics
          _buildMetricRow(
            'Average Speed',
            '${widget.trip.averageSpeedKmh?.toStringAsFixed(1) ?? 'N/A'} km/h',
            Icons.speed,
          ),
          _buildMetricRow(
            'Maximum Speed',
            '${widget.trip.maxSpeedKmh?.toStringAsFixed(1) ?? 'N/A'} km/h',
            Icons.trending_up,
          ),
          
          const Divider(height: 32),
          _buildSectionTitle('Engine Metrics'),
          const SizedBox(height: 16),
          
          // Engine metrics
          _buildMetricRow(
            'Average RPM',
            '${widget.trip.averageRPM?.toStringAsFixed(0) ?? 'N/A'} rpm',
            Icons.speed,
          ),
          _buildMetricRow(
            'Time in Optimal RPM',
            '76%', // Placeholder value
            Icons.thumb_up,
          ),
          
          // Performance chart - placeholder
          const SizedBox(height: 24),
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Speed/RPM Chart Placeholder'),
            ),
          ),
          
          // Trip stages (start, city, highway, etc.) - placeholder
          const SizedBox(height: 24),
          _buildSectionTitle('Trip Stages'),
          const SizedBox(height: 16),
          
          // Placeholders for trip stages
          _buildTripStage('Urban', 28, Colors.orange),
          _buildTripStage('Highway', 62, Colors.blue),
          _buildTripStage('Traffic', 10, Colors.red),
        ],
      ),
    );
  }
  
  /// Build the efficiency metrics tab
  Widget _buildEfficiencyTab() {
    // Calculate fuel efficiency
    final fuelUsed = widget.trip.fuelUsedL ?? 0.0;
    final distance = widget.trip.distanceKm ?? 0.0;
    final fuelEfficiency = distance > 0 && fuelUsed > 0
        ? distance / fuelUsed
        : 0.0;
    
    // Average values for comparison - these would ideally come from a service
    const avgFuelEfficiency = 12.0; // km/L
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Fuel Metrics'),
          const SizedBox(height: 16),
          
          // Fuel metrics
          _buildMetricRow(
            'Fuel Used',
            '${fuelUsed.toStringAsFixed(2)} L',
            Icons.local_gas_station,
          ),
          _buildMetricRow(
            'Fuel Efficiency',
            '${fuelEfficiency.toStringAsFixed(1)} km/L',
            Icons.eco,
            isHigherBetter: true,
            comparisonValue: avgFuelEfficiency,
          ),
          _buildMetricRow(
            'CO₂ Emissions',
            '${(fuelUsed * 2.3).toStringAsFixed(1)} kg',
            Icons.cloud,
            isHigherBetter: false,
          ),
          
          const Divider(height: 32),
          _buildSectionTitle('Eco-Score Breakdown'),
          const SizedBox(height: 16),
          
          // Eco-score breakdown - placeholder
          _buildScoreBar('Calm Driving', 72),
          _buildScoreBar('Speed Management', 85),
          _buildScoreBar('Idle Management', 64),
          _buildScoreBar('RPM Efficiency', 78),
          _buildScoreBar('Stop Management', 69),
          
          // Efficiency visualization - placeholder
          const SizedBox(height: 24),
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Efficiency Trends Chart Placeholder'),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build the behavior metrics tab
  Widget _buildBehaviorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Driving Events'),
          const SizedBox(height: 16),
          
          // Driving events summary
          _buildEventMetric(
            'Aggressive Acceleration',
            widget.trip.aggressiveAccelerationEvents ?? 0,
            Icons.trending_up,
            Colors.orange,
          ),
          _buildEventMetric(
            'Hard Braking',
            widget.trip.hardBrakingEvents ?? 0,
            Icons.trending_down,
            Colors.red,
          ),
          _buildEventMetric(
            'Idling Events',
            widget.trip.idlingEvents ?? 0,
            Icons.timer_off,
            Colors.amber,
          ),
          _buildEventMetric(
            'Excessive Speed',
            widget.trip.excessiveSpeedEvents ?? 0,
            Icons.speed,
            Colors.deepOrange,
          ),
          _buildEventMetric(
            'Stop Events',
            widget.trip.stopEvents ?? 0,
            Icons.stop_circle,
            Colors.blue,
          ),
          
          const Divider(height: 32),
          _buildSectionTitle('Improvement Suggestions'),
          const SizedBox(height: 16),
          
          // Improvement suggestions - placeholders
          _buildSuggestionCard(
            'Reduce Aggressive Acceleration',
            'Try to accelerate more gently to improve fuel efficiency and reduce wear on your vehicle.',
            Icons.trending_up,
          ),
          const SizedBox(height: 16),
          _buildSuggestionCard(
            'Minimize Idle Time',
            'Turn off your engine when stopped for more than 30 seconds to save fuel and reduce emissions.',
            Icons.timer_off,
          ),
        ],
      ),
    );
  }
  
  /// Build a section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  /// Build a metric row with label and value
  Widget _buildMetricRow(
    String label,
    String value,
    IconData icon, {
    bool isHigherBetter = false,
    double? comparisonValue,
  }) {
    // Determine if the value is better than the comparison
    bool isBetter = false;
    bool isWorse = false;
    
    if (comparisonValue != null) {
      final numValue = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      isBetter = isHigherBetter ? numValue > comparisonValue : numValue < comparisonValue;
      isWorse = isHigherBetter ? numValue < comparisonValue : numValue > comparisonValue;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isBetter ? Colors.green : (isWorse ? Colors.red : null),
                ),
              ),
              if (isBetter || isWorse)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    isBetter ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: isBetter ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Build a score bar for eco-score components
  Widget _buildScoreBar(String label, int score) {
    Color barColor;
    if (score >= 80) {
      barColor = Colors.green;
    } else if (score >= 60) {
      barColor = Colors.amber;
    } else {
      barColor = Colors.red;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                score.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade300,
              color: barColor,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build an event metric card
  Widget _buildEventMetric(String label, int count, IconData icon, Color color) {
    final isGood = count == 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isGood ? Colors.green.withOpacity(0.1) : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isGood ? Icons.check_circle : icon,
              color: isGood ? Colors.green : color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  isGood 
                      ? 'No events detected' 
                      : count == 1 
                          ? '1 event detected' 
                          : '$count events detected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isGood ? Colors.green : color,
                  ),
                ),
              ],
            ),
          ),
          if (!isGood)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Build a trip stage visualization
  Widget _buildTripStage(String stageName, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stageName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade300,
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a suggestion card
  Widget _buildSuggestionCard(String title, String description, IconData icon) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 