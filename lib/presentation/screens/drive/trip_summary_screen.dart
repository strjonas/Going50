import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/presentation/providers/driving_provider.dart';
import 'package:going50/presentation/screens/drive/components/trip_overview_header.dart';
import 'package:going50/presentation/screens/drive/components/savings_metrics_section.dart';
import 'package:going50/presentation/screens/drive/components/behavior_breakdown_chart.dart';
import 'package:going50/presentation/screens/drive/components/improvement_suggestion_card.dart';
import 'package:going50/services/driving/analytics_service.dart';

/// A screen that displays a detailed summary of a completed trip.
///
/// This screen shows:
/// - Basic trip information (date, time, duration, distance)
/// - Eco-score and driving behavior analysis
/// - Estimated savings (fuel, CO2, money)
/// - Improvement suggestions for future trips
class TripSummaryScreen extends StatefulWidget {
  /// Optional trip ID to display a historical trip
  /// If not provided, the most recently completed trip will be shown
  final String? tripId;
  
  /// Constructor
  const TripSummaryScreen({
    super.key,
    this.tripId,
  });

  @override
  State<TripSummaryScreen> createState() => _TripSummaryScreenState();
}

class _TripSummaryScreenState extends State<TripSummaryScreen> {
  Trip? _trip;
  double _ecoScore = 0.0;
  List<FeedbackSuggestion> _suggestions = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadTripData();
  }
  
  /// Load trip data and related metrics
  Future<void> _loadTripData() async {
    final drivingProvider = Provider.of<DrivingProvider>(context, listen: false);
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      Trip? loadedTrip;
      
      // Get the trip data
      if (widget.tripId != null) {
        // We need to implement this method in the driving provider
        // For now, we'll use the most recent trip
        final trips = await drivingProvider.getTrips(limit: 5);
        loadedTrip = trips.isNotEmpty 
            ? trips.firstWhere(
                (t) => t.id == widget.tripId,
                orElse: () => trips.first,
              )
            : null;
      } else {
        // Get most recent trip
        final trips = await drivingProvider.getTrips(limit: 1);
        loadedTrip = trips.isNotEmpty ? trips.first : null;
      }
      
      if (loadedTrip != null) {
        _trip = loadedTrip;
        _ecoScore = drivingProvider.currentEcoScore;
        
        // For now, we'll create some mock suggestions since we can't
        // directly access the analytics service
        _suggestions = _createMockSuggestions();
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load trip data: $e';
      });
    }
  }
  
  /// Create mock suggestions for demonstration
  List<FeedbackSuggestion> _createMockSuggestions() {
    return [
      FeedbackSuggestion(
        category: 'calmDriving',
        suggestion: 'Try to accelerate and brake more gently',
        benefit: 'Smoother driving can improve fuel efficiency by up to 30%',
        priority: 3,
      ),
      FeedbackSuggestion(
        category: 'speedOptimization',
        suggestion: 'Maintain a steady speed between 50-80 km/h when possible',
        benefit: 'Optimal speed ranges use fuel more efficiently',
        priority: 2,
      ),
      FeedbackSuggestion(
        category: 'idling',
        suggestion: 'Consider turning off the engine when stopped for more than 30 seconds',
        benefit: 'Reducing idling can save up to 2% in fuel consumption',
        priority: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Navigate back to the app root (TabNavigator)
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trip == null
              ? _buildNoTripView()
              : _buildTripSummary(),
    );
  }
  
  /// Builds the trip summary content
  Widget _buildTripSummary() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip overview header
          TripOverviewHeader(
            trip: _trip!,
            ecoScore: _ecoScore,
          ),
          
          // Savings metrics
          SavingsMetricsSection(
            trip: _trip!,
            ecoScore: _ecoScore,
          ),
          
          // Driving behavior breakdown
          BehaviorBreakdownChart(
            trip: _trip!,
          ),
          
          // Improvement suggestions
          if (_suggestions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                'Suggestions for Improvement',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _suggestions
                    .take(3) // Limit to 3 suggestions
                    .map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ImprovementSuggestionCard(suggestion: s),
                        ))
                    .toList(),
              ),
            ),
          ],
          
          // Add Bottom Action Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Primary Share Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share Your Trip'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement sharing functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing coming soon!'))
                    );
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Secondary Close Button
                OutlinedButton(
                  child: const Text('Close Summary'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate back to the app root (TabNavigator)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds the view shown when no trip is available
  Widget _buildNoTripView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No trip data available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Try completing a trip first',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the app root (TabNavigator)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Go to Drive'),
          ),
        ],
      ),
    );
  }
} 