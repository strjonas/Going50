import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/providers/social_provider.dart';
import 'package:going50/presentation/screens/community/components/shared_filters.dart';

/// LeaderboardView displays the user ranking based on eco-driving performance.
///
/// This component includes:
/// - Filter for scope (friends, local, global)
/// - Time period filter (week, month, all time)
/// - User ranking display
/// - List of top performers
class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  int _filterIndex = 0;
  int _timeFilterIndex = 0;
  
  final List<String> _filterOptions = ["Friends", "Local", "Global"];
  final List<String> _timeFilterOptions = ["Week", "Month", "All time"];
  
  // Maps our UI indices to the provider's values
  final List<String> _leaderboardTypeValues = ["friends", "regional", "global"];
  final List<String> _timeframeValues = ["weekly", "monthly", "alltime"];
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialProvider>(context);
    final leaderboardEntries = provider.leaderboardEntries;
    
    // Initialize the filter indices based on provider state
    if (_filterIndex != _leaderboardTypeValues.indexOf(provider.leaderboardType)) {
      _filterIndex = _leaderboardTypeValues.indexOf(provider.leaderboardType);
    }
    
    if (_timeFilterIndex != _timeframeValues.indexOf(provider.timeframe)) {
      _timeFilterIndex = _timeframeValues.indexOf(provider.timeframe);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Using shared segmented filter bar
        SegmentedFilterBar(
          options: _filterOptions,
          selectedIndex: _filterIndex,
          onSelectionChanged: (index) {
            setState(() {
              _filterIndex = index;
              provider.setLeaderboardType(_leaderboardTypeValues[index]);
            });
          },
        ),
        
        // Using shared time filter chip group
        TimeFilterChipGroup(
          options: _timeFilterOptions,
          selectedIndex: _timeFilterIndex,
          onSelectionChanged: (index) {
            setState(() {
              _timeFilterIndex = index;
              provider.setTimeframe(_timeframeValues[index]);
            });
          },
        ),
        
        // Your Ranking section
        _buildUserRankingCard(context, provider),
        
        const SizedBox(height: 16),
        
        // Top Performers section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Top Performers',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // List of top performers
        Expanded(
          child: provider.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : leaderboardEntries.isEmpty
              ? const Center(child: Text('No leaderboard data available'))
              : _buildLeaderboardList(context, leaderboardEntries),
        ),
      ],
    );
  }
  
  Widget _buildUserRankingCard(BuildContext context, SocialProvider provider) {
    // Find user's rank in the leaderboard entries
    final userRank = provider.leaderboardEntries
        .firstWhere((entry) => entry['isUser'] == true, 
                   orElse: () => {'rank': 0, 'score': 0, 'name': 'You'});
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                userRank['rank'] == 0 ? '-' : userRank['rank'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Ranking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userRank['rank'] == 0 
                      ? 'Complete more trips to get ranked' 
                      : 'Score: ${userRank['score']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboardList(BuildContext context, List<dynamic> entries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildLeaderboardItem(context, entry);
      },
    );
  }
  
  Widget _buildLeaderboardItem(BuildContext context, Map<String, dynamic> entry) {
    final isUser = entry['isUser'] == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUser ? AppColors.primary.withOpacity(0.3) : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(entry['rank']),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                entry['rank'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['name'],
                  style: TextStyle(
                    fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Score: ${entry['score']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey.shade400;
    if (rank == 3) return Colors.brown.shade300;
    return AppColors.primary;
  }
} 