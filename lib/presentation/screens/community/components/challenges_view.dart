import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/screens/community/components/shared_filters.dart';
import 'package:going50/services/gamification/challenge_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:going50/core_models/gamification_models.dart';

/// ChallengesView displays active and available challenges.
///
/// This component includes:
/// - Active challenges with progress indicators
/// - Available challenges that users can join
/// - Completed challenges section
class ChallengesView extends StatefulWidget {
  const ChallengesView({super.key});

  @override
  State<ChallengesView> createState() => _ChallengesViewState();
}

// Maintain static variables for state persistence across widget rebuilds
class _ChallengesViewState extends State<ChallengesView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _filterIndex = 0;
  int _timeFilterIndex = 0;
  
  // Static variables to persist state across rebuilds
  static int persistedFilterIndex = 0;
  static int persistedTimeFilterIndex = 0;
  
  final List<String> _filterOptions = ["Active", "Available", "Completed"];
  final List<String> _timeFilterOptions = ["Week", "Month", "All time"];
  
  // Services
  final ChallengeService _challengeService = serviceLocator<ChallengeService>();
  final UserService _userService = serviceLocator<UserService>();
  
  // Challenge data
  List<UserChallenge> _activeChallenges = [];
  List<Challenge> _availableChallenges = [];
  List<UserChallenge> _completedChallenges = [];
  
  // Loading state
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with persisted values
    _filterIndex = persistedFilterIndex;
    _timeFilterIndex = persistedTimeFilterIndex;
    
    _tabController = TabController(
      length: 3, 
      vsync: this,
      initialIndex: _filterIndex, // Set initial tab from persisted state
    );
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _filterIndex = _tabController.index;
          persistedFilterIndex = _filterIndex; // Update persisted state
        });
      }
    });
    
    // Load challenges
    _loadChallenges();
  }
  
  /// Load challenges from service
  Future<void> _loadChallenges() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final currentUser = _userService.currentUser;
      
      if (currentUser == null) {
        // Try to initialize user service if user is not available
        await _userService.initialize();
        
        // Check again after initialization
        final user = _userService.currentUser;
        if (user == null) {
          if (mounted) {
            setState(() {
              _errorMessage = 'User not found. Please restart the app.';
              _isLoading = false;
            });
          }
          return;
        }
      }
      
      // Get all challenges
      final allChallenges = await _challengeService.getAllChallenges();
      
      // Get user challenges
      final userChallenges = await _challengeService.getUserChallenges(
        currentUser?.id ?? '',
      );
      
      if (mounted) {
        setState(() {
          // Set up active challenges
          _activeChallenges = userChallenges
              .where((uc) => !uc.isCompleted)
              .toList();
          
          // Set up completed challenges
          _completedChallenges = userChallenges
              .where((uc) => uc.isCompleted)
              .toList();
          
          // Set up available challenges (challenges not started by user)
          final userChallengeIds = userChallenges
              .where((uc) => !uc.isCompleted) // Only consider active challenges
              .map((uc) => uc.challengeId)
              .toSet();
          
          _availableChallenges = allChallenges
              .where((c) => !userChallengeIds.contains(c.id))
              .toList();
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load challenges: $e';
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
              persistedFilterIndex = index; // Update persisted state
              _tabController.animateTo(index);
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
              persistedTimeFilterIndex = index; // Update persisted state
            });
          },
        ),
        
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadChallenges,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildActiveChallengesTab(),
                        _buildAvailableChallengesTab(),
                        _buildCompletedChallengesTab(),
                      ],
                    ),
        ),
      ],
    );
  }
  
  Widget _buildActiveChallengesTab() {
    if (_activeChallenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No active challenges',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Switch to available challenges tab
                _tabController.animateTo(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Find Challenges'),
            ),
          ],
        )
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _activeChallenges.length,
      itemBuilder: (context, index) {
        final userChallenge = _activeChallenges[index];
        
        // Find the challenge definition
        final challengeDef = _availableChallenges.firstWhere(
          (c) => c.id == userChallenge.challengeId,
          orElse: () => Challenge(
            id: userChallenge.challengeId,
            title: 'Unknown Challenge',
            description: 'Challenge details not available',
            type: 'unknown',
            targetValue: 1,
            metricType: 'unknown',
          ),
        );
        
        // Convert to the map format used by the UI
        final challengeMap = {
          'id': userChallenge.challengeId,
          'title': challengeDef.title,
          'description': challengeDef.description,
          'iconName': challengeDef.iconName ?? 'emoji_events',
          'progress': userChallenge.progress,
          'target': challengeDef.targetValue,
          'timeRemaining': _getTimeRemaining(challengeDef.type),
          'participants': 100, // Default value
        };
        
        return _buildActiveChallengeCard(challengeMap);
      },
    );
  }
  
  Widget _buildAvailableChallengesTab() {
    if (_availableChallenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No available challenges',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'You\'ve accepted all available challenges!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        )
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _availableChallenges.length,
      itemBuilder: (context, index) {
        final challenge = _availableChallenges[index];
        
        // Convert to the map format used by the UI
        final challengeMap = {
          'id': challenge.id,
          'title': challenge.title,
          'description': challenge.description,
          'iconName': challenge.iconName ?? 'emoji_events',
          'difficulty': _getDifficultyText(challenge.difficultyLevel),
          'reward': '${challenge.rewardValue} ${challenge.rewardType ?? 'points'}',
          'duration': _getDurationText(challenge.type),
          'participants': 100, // Default value
        };
        
        return _buildAvailableChallengeCard(challengeMap);
      },
    );
  }
  
  Widget _buildCompletedChallengesTab() {
    if (_completedChallenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No completed challenges',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Switch to available challenges tab
                _tabController.animateTo(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Find Challenges'),
            ),
          ],
        )
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _completedChallenges.length,
      itemBuilder: (context, index) {
        final userChallenge = _completedChallenges[index];
        
        // Find the challenge definition
        final challengeDef = _availableChallenges.firstWhere(
          (c) => c.id == userChallenge.challengeId,
          orElse: () => Challenge(
            id: userChallenge.challengeId,
            title: 'Unknown Challenge',
            description: 'Challenge details not available',
            type: 'unknown',
            targetValue: 1,
            metricType: 'unknown',
          ),
        );
        
        // Convert to the map format used by the UI
        final challengeMap = {
          'id': userChallenge.challengeId,
          'title': challengeDef.title,
          'description': challengeDef.description,
          'iconName': challengeDef.iconName ?? 'emoji_events',
          'completedDate': _formatDate(userChallenge.completedAt ?? DateTime.now()),
          'reward': '${challengeDef.rewardValue} ${challengeDef.rewardType ?? 'points'}',
        };
        
        return _buildCompletedChallengeCard(challengeMap);
      },
    );
  }
  
  // Helper methods for formatting
  String _getTimeRemaining(String challengeType) {
    switch (challengeType) {
      case 'daily':
        return 'Today';
      case 'weekly':
        return '7 days';
      case 'achievement':
        return 'Ongoing';
      default:
        return 'Limited time';
    }
  }
  
  String _getDifficultyText(int? difficultyLevel) {
    switch (difficultyLevel) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Medium';
    }
  }
  
  String _getDurationText(String challengeType) {
    switch (challengeType) {
      case 'daily':
        return '1 day';
      case 'weekly':
        return '7 days';
      case 'achievement':
        return 'Ongoing';
      default:
        return 'Limited time';
    }
  }
  
  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  Widget _buildActiveChallengeCard(Map<String, dynamic> challenge) {
    final double progressPercent = challenge['progress'] / challenge['target'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to challenge detail screen
          Navigator.of(context).pushNamed(
            CommunityRoutes.challengeDetail,
            arguments: challenge['id'],
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(challenge['iconName']),
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          challenge['description'],
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Progress: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              '${challenge['progress']}/${challenge['target']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          children: [
                            // Background track
                            Container(
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            // Progress indicator
                            FractionallySizedBox(
                              widthFactor: progressPercent.clamp(0, 1),
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.primary.withOpacity(0.7), AppColors.primary],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            challenge['timeRemaining'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${challenge['participants']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAvailableChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to challenge detail screen
          Navigator.of(context).pushNamed(
            CommunityRoutes.challengeDetail,
            arguments: challenge['id'],
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(challenge['iconName']),
                      color: Colors.grey.shade700,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          challenge['description'],
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
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDetailChip(Icons.star, challenge['difficulty']),
                  _buildDetailChip(Icons.card_giftcard, challenge['reward']),
                  _buildDetailChip(Icons.timer, challenge['duration']),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${challenge['participants']} participants',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Joined ${challenge['title']} challenge'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Join',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCompletedChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to challenge detail screen
          Navigator.of(context).pushNamed(
            CommunityRoutes.challengeDetail,
            arguments: challenge['id'],
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(challenge['iconName']),
                  color: Colors.grey.shade700,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge['title'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      challenge['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Completed on ${challenge['completedDate']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.card_giftcard,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              challenge['reward'],
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
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