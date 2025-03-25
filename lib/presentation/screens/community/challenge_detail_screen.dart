import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/services/gamification/challenge_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:going50/presentation/providers/social_provider.dart';
import 'package:going50/presentation/screens/community/components/challenge_progress_section.dart';
import 'package:going50/presentation/screens/community/components/challenge_leaderboard.dart';

/// ChallengeDetailScreen displays detailed information about a specific challenge.
///
/// This screen includes:
/// - Challenge information (title, description, etc.)
/// - Progress tracking and visualization
/// - Participant leaderboard
/// - Join/leave functionality
class ChallengeDetailScreen extends StatefulWidget {
  /// The unique identifier of the challenge
  final String challengeId;
  
  /// Constructor
  const ChallengeDetailScreen({
    super.key, 
    required this.challengeId,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  final ChallengeService _challengeService = serviceLocator<ChallengeService>();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _challengeData;
  bool _isParticipating = false;
  
  // Add the UserService
  final UserService _userService = serviceLocator<UserService>();
  
  // Subscription for challenge state changes
  StreamSubscription? _challengeStateSubscription;

  @override
  void initState() {
    super.initState();
    _loadChallengeData();
    
    // Listen to challenge state changes from the service
    _challengeStateSubscription = _challengeService.challengeStateChangeStream
        .listen(_handleChallengeStateChange);
  }
  
  @override
  void dispose() {
    _challengeStateSubscription?.cancel();
    super.dispose();
  }
  
  /// Handle challenge state changes from the service
  void _handleChallengeStateChange(Map<String, dynamic> event) {
    // Only process events relevant to this challenge
    if (event['challengeId'] == widget.challengeId) {
      _loadChallengeData();
    }
  }
  
  /// Load challenge details from the service
  Future<void> _loadChallengeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Get the current user ID from UserService
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'User not found. Please restart the app.';
        });
        return;
      }
      
      final challengeData = await _challengeService.getDetailedChallenge(
        currentUser.id, 
        widget.challengeId,
      );
      
      if (challengeData != null) {
        setState(() {
          _challengeData = challengeData;
          
          // Use explicit isJoined flag if available, fall back to progress check
          _isParticipating = challengeData['isJoined'] ?? false;
        });
      } else {
        setState(() {
          _errorMessage = 'Challenge not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load challenge: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  /// Join or leave the challenge
  Future<void> _toggleParticipation() async {
    if (_challengeData == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get the current user ID from UserService
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'User not found. Please restart the app.';
        });
        return;
      }
      
      if (_isParticipating) {
        // Leave the challenge
        final success = await _challengeService.leaveChallenge(
          currentUser.id, 
          widget.challengeId
        );
        
        if (success) {
          // State will be updated via the event listener
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Left ${_challengeData!['title']} challenge'),
            ),
          );
          
          // Navigate back to previous screen
          Navigator.of(context).pop();
          return; // Return early since we've already popped
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to leave challenge'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Join the challenge
        final result = await _challengeService.startChallenge(
          currentUser.id, 
          widget.challengeId
        );
        
        if (result != null) {
          // State will be updated via the event listener
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Joined ${_challengeData!['title']} challenge'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to join challenge'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      
      // Reload challenge data
      await _loadChallengeData();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update participation: $e';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $_errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Details'),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _challengeData == null
                  ? const Center(child: Text('Challenge not found'))
                  : _buildChallengeContent(),
    );
  }
  
  Widget _buildChallengeContent() {
    final data = _challengeData!;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Challenge header section
          _buildChallengeHeader(data),
          
          // Divider
          const Divider(height: 1),
          
          // Progress section
          ChallengeProgressSection(
            progress: data['progress'] ?? 0,
            targetValue: data['targetValue'] ?? 100,
            metricType: data['metricType'] ?? '',
            isCompleted: data['isCompleted'] ?? false,
            timeRemaining: _getTimeRemaining(data),
          ),
          
          // Divider
          const Divider(height: 1),
          
          // Reward section
          _buildRewardSection(data),
          
          // Divider
          const Divider(height: 1),
          
          // Leaderboard section
          ChallengeLeaderboard(
            challengeId: widget.challengeId,
            challengeTitle: data['title'] ?? 'Challenge',
          ),
        ],
      ),
    );
  }
  
  Widget _buildChallengeHeader(Map<String, dynamic> data) {
    final bool isCompleted = data['isCompleted'] ?? false;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(data['iconName']),
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'] ?? 'Challenge',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDifficultyText(data['difficultyLevel']),
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
          const SizedBox(height: 16),
          Text(
            data['description'] ?? 'No description available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data['participantCount'] ?? '120'} participants',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isCompleted ? null : _toggleParticipation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isParticipating ? Colors.grey.shade200 : AppColors.primary,
                  foregroundColor: _isParticipating ? Colors.grey.shade800 : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isCompleted
                      ? 'Completed'
                      : (_isParticipating ? 'Leave' : 'Join'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildRewardSection(Map<String, dynamic> data) {
    final String rewardType = data['rewardType'] ?? 'points';
    final int rewardValue = data['rewardValue'] ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reward',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  rewardType == 'badge' ? Icons.military_tech : Icons.stars,
                  color: AppColors.secondary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rewardType == 'badge' 
                          ? 'Badge: Level $rewardValue' 
                          : '$rewardValue Points',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rewardType == 'badge'
                          ? 'Earn this badge by completing the challenge'
                          : 'Points will be added to your total score',
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
          
          // For completed challenges, add claim button
          if (data['isCompleted'] == true && data['rewardClaimed'] != true)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Get the current user ID from UserService
                      final currentUser = _userService.currentUser;
                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User not found. Please restart the app.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      final success = await _challengeService.claimChallengeReward(
                        currentUser.id, 
                        widget.challengeId,
                      );
                      
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Claimed reward for ${data['title']}!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        
                        // Reload challenge data
                        await _loadChallengeData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to claim reward'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Claim Reward'),
                ),
              ),
            ),
          
          // For already claimed rewards
          if (data['isCompleted'] == true && data['rewardClaimed'] == true)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reward Claimed',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  String _getDifficultyText(int? difficultyLevel) {
    switch (difficultyLevel) {
      case 1:
        return 'Easy';
      case 2:
        return 'Moderate';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Expert';
      default:
        return 'Normal';
    }
  }
  
  String _getTimeRemaining(Map<String, dynamic> data) {
    final String type = data['type'] ?? '';
    if (type == 'daily') {
      return 'Today';
    } else if (type == 'weekly') {
      return 'This week';
    } else if (type == 'achievement') {
      return 'Ongoing';
    } else {
      // For other types or when no specific end date is known
      return '7 days remaining';
    }
  }
  
  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'eco':
        return Icons.eco;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'speed':
        return Icons.speed;
      case 'cloud':
        return Icons.cloud;
      case 'trending_up':
        return Icons.trending_up;
      case 'location_city':
        return Icons.location_city;
      case 'weekend':
        return Icons.weekend;
      case 'access_time':
        return Icons.access_time;
      case 'mood':
        return Icons.mood;
      case 'timer':
        return Icons.timer;
      case 'repeat':
        return Icons.repeat;
      case 'straighten':
        return Icons.straighten;
      case 'event_available':
        return Icons.event_available;
      case 'directions_car':
        return Icons.directions_car;
      case 'stars':
        return Icons.stars;
      default:
        return Icons.emoji_events;
    }
  }
} 