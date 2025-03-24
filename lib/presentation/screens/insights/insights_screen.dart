import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/presentation/widgets/common/layout/section_container.dart';
import 'package:going50/presentation/screens/insights/components/time_period_selector.dart';
import 'package:going50/presentation/widgets/common/charts/line_chart.dart';
import 'package:going50/presentation/screens/insights/components/savings_summary_card.dart';
import 'package:going50/presentation/widgets/common/charts/radar_chart.dart';
import 'package:going50/presentation/widgets/common/charts/eco_score_gauge.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:fl_chart/fl_chart.dart';

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
          
          // Convert trend data to FlSpot for AppLineChart
          final trendSpots = _convertTrendDataToFlSpots(insightsProvider.ecoScoreTrend);

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
                            EcoScoreGauge(
                              score: (insightsProvider.currentMetrics?.overallEcoScore ?? 0).toDouble(),
                              size: 140,
                              showLabel: true,
                              showScore: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppLineChart(
                          dataPoints: [trendSpots],
                          xLabels: trendLabels,
                          height: 150,
                          title: 'Trend',
                          showGrid: true,
                          showFill: true,
                          minY: 0,
                          maxY: 100,
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
                          child: AppRadarChart(
                            data: _convertBehaviorScoresToDoubles(insightsProvider.behaviorScores),
                            size: 250,
                            maxValue: 100,
                            rings: 4,
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
  
  /// Convert the behavior scores from int to double
  Map<String, double> _convertBehaviorScoresToDoubles(Map<String, int> behaviorScores) {
    return behaviorScores.map((key, value) => MapEntry(key, value.toDouble()));
  }
  
  /// Convert trend data to FlSpot for use with AppLineChart
  List<FlSpot> _convertTrendDataToFlSpots(List<double> trendData) {
    return List.generate(trendData.length, (index) => 
      FlSpot(index.toDouble(), trendData[index]));
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