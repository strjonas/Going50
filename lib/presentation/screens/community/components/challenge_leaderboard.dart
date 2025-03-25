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
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Top participants in this challenge',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
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
                    color: Colors.grey.shade700,
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
                    .map((entry) => _buildLeaderboardEntryTile(entry)),
                
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
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '•••',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Current user's position (if not in top 5)
                if (_currentUserEntry != null && 
                    !_leaderboardEntries.take(5).any((e) => e['isCurrentUser'] == true))
                  _buildLeaderboardEntryTile(_currentUserEntry!),
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
  
  Widget _buildLeaderboardEntryTile(Map<String, dynamic> entry) {
    final bool isCurrentUser = entry['isCurrentUser'] == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentUser ? AppColors.primary.withOpacity(0.3) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getRankColor(entry['rank']),
              shape: BoxShape.circle,
            ),
            child: Text(
              entry['rank'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['name'],
                  style: TextStyle(
                    fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                    color: isCurrentUser ? AppColors.primary : Colors.black,
                  ),
                ),
                Text(
                  'Progress: ${entry['progress']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${entry['score']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade700; // Gold
      case 2:
        return Colors.blueGrey.shade400; // Silver
      case 3:
        return Colors.brown.shade400; // Bronze
      default:
        return Colors.grey.shade500;
    }
  }
} 