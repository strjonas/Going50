import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/presentation/widgets/common/layout/section_container.dart';
import 'package:going50/presentation/screens/insights/components/time_period_selector.dart';
import 'package:going50/presentation/screens/insights/components/eco_score_trend_chart.dart';
import 'package:going50/presentation/screens/insights/components/savings_summary_card.dart';
import 'package:going50/presentation/screens/insights/components/driving_behaviors_chart.dart';
import 'package:going50/core/constants/route_constants.dart';

/// InsightsScreen is the main screen for the Insights tab.
///
/// This screen provides access to trip history and driving analytics,
/// showing eco-driving performance metrics and trends.
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    // Initial data loading is handled in the provider constructor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refreshInsights();
            },
            tooltip: 'Refresh insights',
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
                    'Error loading insights',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insightsProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _refreshInsights,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          // Generate labels for the eco-score trend chart
          final trendLabels = _generateTrendLabels(insightsProvider.selectedTimeFrame);

          return RefreshIndicator(
            onRefresh: () => insightsProvider.refreshInsights(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time period selector
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TimePeriodSelector(
                        selected: insightsProvider.selectedTimeFrame,
                        onSelect: (timeFrame) {
                          insightsProvider.setTimeFrame(timeFrame);
                        },
                      ),
                    ),
                  ),
                  
                  // Eco-Score Overview
                  SectionContainer(
                    title: 'Your Eco-Score',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildScoreCircle(
                              context,
                              score: insightsProvider.currentMetrics?.overallEcoScore ?? 0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        EcoScoreTrendChart(
                          scores: insightsProvider.ecoScoreTrend,
                          labels: trendLabels,
                          title: 'Trend',
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Savings Summary
                  SavingsSummaryCard(
                    fuelSavingsL: insightsProvider.fuelSavings,
                    moneySavings: insightsProvider.moneySavings,
                    co2ReductionKg: insightsProvider.co2Reduction,
                    timePeriod: insightsProvider.timePeriodDescription,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Driving Behaviors Radar Chart
                  SectionContainer(
                    title: 'Driving Behaviors',
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: DrivingBehaviorsChart(
                            behaviorScores: insightsProvider.behaviorScores,
                            behaviorColors: _getBehaviorColors(),
                          ),
                        ),
                        if (insightsProvider.currentMetrics != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: _buildRecommendations(
                              context,
                              insightsProvider.currentMetrics!.improvementRecommendations,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // View Trip History Button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(InsightsRoutes.tripHistory);
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('View Trip History'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// Refresh insights data
  Future<void> _refreshInsights() async {
    await Provider.of<InsightsProvider>(context, listen: false).refreshInsights();
  }
  
  /// Generate labels for the eco-score trend chart based on the selected time frame
  List<String> _generateTrendLabels(String timeFrame) {
    switch (timeFrame) {
      case 'day':
        return ['12am', '6am', '12pm', '6pm'];
      case 'week':
        return ['Sun', 'Mon', 'Wed', 'Fri'];
      case 'month':
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      case 'year':
        return ['Jan', 'Apr', 'Jul', 'Oct'];
      default:
        return [];
    }
  }
  
  /// Get colors for different driving behaviors
  Map<String, Color> _getBehaviorColors() {
    return {
      'calm_driving': Colors.blue,
      'speed_optimization': Colors.green,
      'idle_management': Colors.orange,
      'trip_planning': Colors.purple,
      'rpm_efficiency': Colors.red,
      'stop_management': Colors.teal,
      'following_distance': Colors.indigo,
    };
  }
  
  /// Build a circular eco-score indicator
  Widget _buildScoreCircle(BuildContext context, {required int score}) {
    final theme = Theme.of(context);
    final size = 140.0;
    
    // Determine color based on score
    Color scoreColor;
    if (score >= 80) {
      scoreColor = Colors.green;
    } else if (score >= 60) {
      scoreColor = Colors.lightGreen;
    } else if (score >= 40) {
      scoreColor = Colors.amber;
    } else if (score >= 20) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            scoreColor.withAlpha(179), // ~70% opacity
            scoreColor.withAlpha(77),  // ~30% opacity
          ],
          center: Alignment.center,
          radius: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withAlpha(51), // ~20% opacity
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score.toString(),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'Eco-Score',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(179), // ~70% opacity
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a recommendations list
  Widget _buildRecommendations(BuildContext context, List<String> recommendations) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
          child: Text(
            'Recommendations',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...recommendations.map((recommendation) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.tips_and_updates,
                  size: 18,
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
} 