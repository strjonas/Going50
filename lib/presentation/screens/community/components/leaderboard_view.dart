import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/providers/social_provider.dart';

/// LeaderboardView displays the user ranking based on eco-driving performance.
///
/// This component includes:
/// - Segmented control for leaderboard type (Friends/Local/Global)
/// - Time period selector
/// - User ranking display
/// - List of top performers
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialProvider>(context);
    final leaderboardEntries = provider.leaderboardEntries;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSegmentedControl(context, provider),
        const SizedBox(height: 16),
        _buildTimePeriodSelector(context, provider),
        const SizedBox(height: 24),
        _buildUserRankingCard(context, provider),
        const SizedBox(height: 16),
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
  
  Widget _buildSegmentedControl(BuildContext context, SocialProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _buildSegmentButton(
              context, 'Friends', 
              provider.leaderboardType == 'friends', 
              () => provider.setLeaderboardType('friends')
            ),
            _buildSegmentButton(
              context, 'Local', 
              provider.leaderboardType == 'regional', 
              () => provider.setLeaderboardType('regional')
            ),
            _buildSegmentButton(
              context, 'Global', 
              provider.leaderboardType == 'global', 
              () => provider.setLeaderboardType('global')
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSegmentButton(BuildContext context, String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTimePeriodSelector(BuildContext context, SocialProvider provider) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTimeChip('Week', provider.timeframe == 'weekly', 
              () => provider.setTimeframe('weekly')),
          const SizedBox(width: 8),
          _buildTimeChip('Month', provider.timeframe == 'monthly', 
              () => provider.setTimeframe('monthly')),
          const SizedBox(width: 8),
          _buildTimeChip('All time', provider.timeframe == 'alltime', 
              () => provider.setTimeframe('alltime')),
        ],
      ),
    );
  }
  
  Widget _buildTimeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
          width: 1,
        ),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
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
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
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
                const SizedBox(height: 4),
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
  
  Widget _buildLeaderboardList(BuildContext context, List<Map<String, dynamic>> entries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final bool isUser = entry['isUser'] == true;
        final bool isFriend = entry['isFriend'] == true;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUser ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Rank
              Container(
                width: 36,
                height: 36,
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
              const SizedBox(width: 12),
              
              // Avatar placeholder
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              
              // Name and score
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: 4),
                          const Text('(You)', style: TextStyle(fontSize: 12)),
                        ],
                        if (isFriend && !isUser) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.people, size: 14, color: AppColors.secondary),
                        ],
                      ],
                    ),
                    Text(
                      'Score: ${entry['score']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Trend indicator
              _buildTrendIndicator(entry['trend']),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTrendIndicator(String trend) {
    IconData icon;
    Color color;
    
    switch (trend) {
      case 'up':
        icon = Icons.arrow_upward;
        color = AppColors.success;
        break;
      case 'down':
        icon = Icons.arrow_downward;
        color = AppColors.error;
        break;
      case 'same':
      default:
        icon = Icons.remove;
        color = AppColors.neutralGray;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }
  
  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return Colors.grey.shade600; // Others
  }
} 