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
/// - Can be displayed in compact mode for the main community screen
class LeaderboardView extends StatefulWidget {
  /// Whether to display in compact mode with limited entries and UI elements
  final bool isCompactMode;
  
  const LeaderboardView({
    super.key, 
    this.isCompactMode = false,
  });

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
    
    // In compact mode, show a simplified view with fewer entries
    if (widget.isCompactMode) {
      return _buildCompactView(context, provider, leaderboardEntries);
    }
    
    // Otherwise show the full view
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
        
        const SizedBox(height: 24),
        
        // Top Performers section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            'Top Performers',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
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
  
  /// Build compact view for the main community screen
  Widget _buildCompactView(BuildContext context, SocialProvider provider, List<dynamic> entries) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Using a consistent design for the filter tabs similar to SegmentedFilterBar
        Container(
          height: 52, // Reduced height for compact view
          margin: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent, width: 1),
            // Subtle shadow
            boxShadow: theme.brightness == Brightness.light ? [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ] : null,
          ),
          child: Row(
            children: List.generate(
              _filterOptions.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _filterIndex = index;
                    provider.setLeaderboardType(_leaderboardTypeValues[index]);
                  }),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _filterIndex == index ? theme.cardTheme.color : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: _filterIndex == index 
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        _filterOptions[index],
                        style: TextStyle(
                          fontSize: 15, // Slightly smaller for compact view
                          fontWeight: _filterIndex == index ? FontWeight.w600 : FontWeight.w400,
                          color: _filterIndex == index ? AppColors.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // User ranking - simplified version
        _buildUserRankingCard(context, provider),
        
        const SizedBox(height: 16),
        
        // Only show top 5 entries in compact mode - with better spacing
        Expanded(
          child: provider.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : entries.isEmpty
              ? const Center(child: Text('No leaderboard data available'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length > 5 ? 5 : entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _buildCompactLeaderboardItem(context, entry);
                  },
                ),
        ),
      ],
    );
  }
  
  Widget _buildUserRankingCard(BuildContext context, SocialProvider provider) {
    final theme = Theme.of(context);
    
    // Find user's rank in the leaderboard entries
    final userRank = provider.leaderboardEntries
        .firstWhere((entry) => entry['isUser'] == true, 
                   orElse: () => {'rank': 0, 'score': 0, 'name': 'You'});
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent, width: 1),
        // Subtle shadow for depth - only for light mode
        boxShadow: theme.brightness == Brightness.light ? [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              // Subtle glow effect for emphasis
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                userRank['rank'] == 0 ? '-' : userRank['rank'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Ranking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userRank['rank'] == 0 
                      ? 'Complete more trips to get ranked' 
                      : 'Score: ${userRank['score']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
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
    final theme = Theme.of(context);
    final isUser = entry['isUser'] == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary.withOpacity(0.07) : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUser ? AppColors.primary.withOpacity(0.3) : theme.dividerTheme.color ?? Colors.transparent,
          width: 1,
        ),
        boxShadow: theme.brightness == Brightness.light ? [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getRankColor(entry['rank']),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getRankColor(entry['rank']).withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                entry['rank'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['name'],
                  style: TextStyle(
                    fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                    fontSize: 16,
                    color: isUser ? AppColors.primary : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Score: ${entry['score']}',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
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
  
  /// Build a more compact leaderboard item for the compact view
  Widget _buildCompactLeaderboardItem(BuildContext context, dynamic entry) {
    final theme = Theme.of(context);
    final bool isUser = entry['isUser'] ?? false;
    final bool isTopPerformer = entry['rank'] == 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: isUser ? theme.colorScheme.surface.withOpacity(0.7) : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Rank
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              child: Text(
                '${entry['rank']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // User avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? 
                       AppColors.darkSurface : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: entry['photoUrl'] != null && entry['photoUrl'].isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      entry['photoUrl'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: theme.brightness == Brightness.dark ?
                           Colors.grey.shade400 : Colors.grey.shade700,
                  ),
            ),
            
            const SizedBox(width: 12),
            
            // User name with badge for top performer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isUser ? AppColors.primary : theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (isTopPerformer) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark ?
                                   Colors.amber.shade800.withOpacity(0.3) : Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.emoji_events_outlined,
                                color: Colors.amber.shade800,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Top Driver',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Score
            Text(
              '${entry['score']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
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