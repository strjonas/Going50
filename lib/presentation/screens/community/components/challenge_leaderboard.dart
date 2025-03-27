import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/providers/social_provider.dart';

/// ChallengeLeaderboard displays the leaderboard for a specific challenge.
///
/// This component includes:
/// - List of top participants
/// - User's current position
/// - Each participant's score/progress
class ChallengeLeaderboard extends StatefulWidget {
  /// The unique identifier of the challenge
  final String challengeId;
  
  /// The title of the challenge
  final String challengeTitle;
  
  /// Constructor
  const ChallengeLeaderboard({
    super.key,
    required this.challengeId,
    required this.challengeTitle,
  });

  @override
  State<ChallengeLeaderboard> createState() => _ChallengeLeaderboardState();
}

class _ChallengeLeaderboardState extends State<ChallengeLeaderboard> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _leaderboardEntries = [];
  Map<String, dynamic>? _currentUserEntry;
  
  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }
  
  /// Load leaderboard data
  Future<void> _loadLeaderboardData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // In a real app, this would fetch data from a service based on the challenge ID
      // For now, we'll use mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simulate fetching challenge leaderboard data
      _leaderboardEntries = [
        {
          'rank': 1,
          'userId': 'user1',
          'name': 'Taylor Green',
          'progress': 5,
          'score': 100,
          'isCurrentUser': false,
        },
        {
          'rank': 2,
          'userId': 'user2',
          'name': 'Jordan Rivera',
          'progress': 4,
          'score': 80,
          'isCurrentUser': false,
        },
        {
          'rank': 3,
          'userId': 'user3',
          'name': 'Casey Lee',
          'progress': 3,
          'score': 60,
          'isCurrentUser': true,
        },
        {
          'rank': 4,
          'userId': 'user4',
          'name': 'Morgan Chen',
          'progress': 2,
          'score': 40,
          'isCurrentUser': false,
        },
        {
          'rank': 5,
          'userId': 'user5',
          'name': 'Alex Johnson',
          'progress': 1,
          'score': 20,
          'isCurrentUser': false,
        },
      ];
      
      // Find current user's entry
      _currentUserEntry = _leaderboardEntries.firstWhere(
        (entry) => entry['isCurrentUser'] == true,
        orElse: () => {
          'rank': 10,
          'userId': 'currentUser',
          'name': 'You',
          'progress': 0,
          'score': 0,
          'isCurrentUser': true,
        },
      );
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Top participants in this challenge',
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          
          // Loading indicator or error message
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_leaderboardEntries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No participants yet',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                // Top participants list
                ..._leaderboardEntries
                    .take(5)
                    .map((entry) => _buildLeaderboardEntryTile(context, entry)),
                
                // Divider if current user is not in top 5
                if (_currentUserEntry != null && 
                    !_leaderboardEntries.take(5).any((e) => e['isCurrentUser'] == true))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: theme.dividerTheme.color,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '•••',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: theme.dividerTheme.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Current user's position (if not in top 5)
                if (_currentUserEntry != null && 
                    !_leaderboardEntries.take(5).any((e) => e['isCurrentUser'] == true))
                  _buildLeaderboardEntryTile(context, _currentUserEntry!),
              ],
            ),
          
          // View all button
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Navigate to full leaderboard (not implemented)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Full leaderboard view not implemented'),
                  ),
                );
              },
              icon: const Icon(Icons.people_outline),
              label: const Text('View All Participants'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboardEntryTile(BuildContext context, Map<String, dynamic> entry) {
    final bool isCurrentUser = entry['isCurrentUser'] == true;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? AppColors.primary.withOpacity(0.1) 
            : (theme.brightness == Brightness.dark 
                ? theme.cardTheme.color?.withOpacity(0.7) 
                : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentUser 
              ? AppColors.primary.withOpacity(0.3) 
              : (theme.brightness == Brightness.dark 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Rank with medal color for top 3
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getMedalColor(entry['rank']).withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: _getMedalColor(entry['rank']).withOpacity(theme.brightness == Brightness.dark ? 0.5 : 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                '${entry['rank']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getMedalColor(entry['rank']),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Participant name and progress/score
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry['name'],
                  style: TextStyle(
                    fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                    color: isCurrentUser 
                        ? AppColors.primary 
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  '${entry['progress']}/${entry['target'] ?? 5}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.blueGrey.shade300;
      case 3:
        return Colors.brown.shade300;
      default:
        return AppColors.primary;
    }
  }
} 