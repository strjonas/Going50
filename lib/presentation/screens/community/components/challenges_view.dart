import 'package:flutter/material.dart';
import 'dart:async';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/screens/community/components/shared_filters.dart';
import 'package:going50/services/gamification/challenge_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:going50/core_models/gamification_models.dart';
import 'package:logging/logging.dart';

/// ChallengesView displays active and available challenges.
///
/// This component includes:
/// - Active challenges with progress indicators
/// - Available challenges that users can join
/// - Completed challenges section
/// - Can be displayed in compact mode for the main community screen
class ChallengesView extends StatefulWidget {
  /// Whether to display in compact mode with limited entries and UI elements
  final bool isCompactMode;
  
  const ChallengesView({
    super.key, 
    this.isCompactMode = false,
  });

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
  List<Challenge> _allChallenges = [];
  List<UserChallenge> _completedChallenges = [];
  
  // Loading state
  bool _isLoading = true;
  String? _errorMessage;
  
  // Subscription for challenge state changes
  StreamSubscription? _challengeStateSubscription;
  
  final _logger = Logger('ChallengesView');
  
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
    
    // Subscribe to challenge state changes
    _challengeStateSubscription = _challengeService.challengeStateChangeStream
        .listen(_handleChallengeStateChange);
    
    // Load challenges
    _loadChallenges();
  }
  
  /// Handle challenge state changes from the service
  void _handleChallengeStateChange(Map<String, dynamic> event) {
    _logger.info('Challenge state change: ${event['action']} - ${event['challengeId']}');
    
    // Reload challenges on any state change
    _loadChallenges();
    
    // If a challenge was joined, switch to active tab
    if (event['action'] == 'joined') {
      _tabController.animateTo(0); // Switch to active tab
    }
  }
  
  /// Load challenges from service
  Future<void> _loadChallenges() async {
    _logger.info('Loading challenges for user: ${_userService.currentUser?.id}');
    
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      var currentUser = _userService.currentUser;
      
      // Initialize UserService if needed
      if (currentUser == null) {
        _logger.info('User not available, initializing UserService');
        await _userService.initialize();
        currentUser = _userService.currentUser;
        
        final user = _userService.currentUser;
        if (user == null) {
          _logger.warning('Failed to get user after UserService initialization');
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
      _logger.info('Getting all challenges from ChallengeService');
      final allChallenges = await _challengeService.getAllChallenges();
      _logger.info('Retrieved ${allChallenges.length} total challenges');
      
      // Get user challenges - no need to explicitly invalidate cache as service handles this
      final userChallenges = await _challengeService.getUserChallenges(
        currentUser?.id ?? '',
      );
      _logger.info('Retrieved ${userChallenges.length} user challenges');
      
      if (mounted) {
        setState(() {
          // Store all challenges for reference
          _allChallenges = allChallenges;
          
          // Set up active challenges - ANY non-completed user challenge is considered active
          _activeChallenges = userChallenges
              .where((uc) => !uc.isCompleted)
              .toList();
          _logger.info('Active challenges: ${_activeChallenges.length}');
          
          // Set up completed challenges
          _completedChallenges = userChallenges
              .where((uc) => uc.isCompleted)
              .toList();
          _logger.info('Completed challenges: ${_completedChallenges.length}');
          
          // Get ALL user challenge IDs (both active and completed)
          final allUserChallengeIds = userChallenges
              .map((uc) => uc.challengeId)
              .toSet();
              
          // Available challenges should be challenges NOT in any user challenges list
          _availableChallenges = allChallenges
              .where((c) => !allUserChallengeIds.contains(c.id))
              .toList();
          _logger.info('Available challenges: ${_availableChallenges.length}');
          
          _isLoading = false;
        });
      }
    } catch (e) {
      _logger.severe('Error loading challenges: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load challenges: $e';
          _isLoading = false;
        });
      }
    }
  }
  
  /// Create a formatted challenge map for UI components
  Map<String, dynamic> _formatChallengeForUI(Challenge challenge, {UserChallenge? userChallenge}) {
    final bool hasUserData = userChallenge != null;
    
    return {
      'id': challenge.id,
      'title': challenge.title,
      'description': challenge.description,
      'iconName': challenge.iconName ?? 'emoji_events',
      'difficulty': _getDifficultyText(challenge.difficultyLevel),
      'reward': '${challenge.rewardValue} ${challenge.rewardType ?? 'points'}',
      'duration': _getDurationText(challenge.type),
      'timeRemaining': _getTimeRemaining(challenge.type),
      'participants': 50 + (challenge.id.hashCode % 100).abs(), // Simulated count but deterministic
      
      // User-specific data if available
      if (hasUserData) ...{
        'progress': userChallenge.progress,
        'target': challenge.targetValue,
        'isCompleted': userChallenge.isCompleted,
        'completedDate': userChallenge.completedAt != null ? 
            _formatDate(userChallenge.completedAt!) : null,
      }
    };
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _challengeStateSubscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // In compact mode, only show active challenges
    if (widget.isCompactMode) {
      return _buildCompactView();
    }
    
    // Otherwise use the full tabbed view
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
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
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
        
        // Find the challenge definition from ALL challenges
        final challengeDef = _allChallenges.firstWhere(
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
        
        // Use the new formatter helper
        final challengeMap = _formatChallengeForUI(challengeDef, userChallenge: userChallenge);
        
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
        
        // Use the new formatter helper
        final challengeMap = _formatChallengeForUI(challenge);
        
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
        final challengeDef = _allChallenges.firstWhere(
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
        
        // Use the new formatter helper
        final challengeMap = _formatChallengeForUI(challengeDef, userChallenge: userChallenge);
        
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
  
  /// Builds the UI for an active challenge card
  Widget _buildActiveChallengeCard(Map<String, dynamic> challenge) {
    final theme = Theme.of(context);
    final double progressPercent = challenge['progress'] / challenge['target'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: theme.cardTheme.color,
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
                      color: theme.brightness == Brightness.dark ? 
                             AppColors.darkSurface : AppColors.primary.withOpacity(0.15),
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
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          challenge['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ?
                             Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_run,
                          size: 12,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ongoing',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Time remaining or expiry
                  Text(
                    '${challenge['daysRemaining'] ?? 'No'} days left',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    '${challenge['progress']}/${challenge['target']} ${challenge['unit'] ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressPercent.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: theme.brightness == Brightness.dark ? 
                                  Colors.grey.shade800 : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the UI for an available challenge
  Widget _buildAvailableChallengeCard(Map<String, dynamic> challenge) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: theme.cardTheme.color,
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
                      color: theme.brightness == Brightness.dark ? 
                             AppColors.darkSurface : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconData(challenge['iconName']),
                      color: theme.brightness == Brightness.dark ? 
                             Colors.grey.shade400 : Colors.grey.shade700,
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
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          challenge['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Reward: ${challenge['rewardValue']} points',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _getDifficultyText(challenge['difficultyLevel']),
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _joinChallenge(challenge['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text('Join Challenge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the UI for a completed challenge
  Widget _buildCompletedChallengeCard(Map<String, dynamic> challenge) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: theme.cardTheme.color,
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
                  color: theme.brightness == Brightness.dark ? 
                         AppColors.darkSurface : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(challenge['iconName']),
                  color: theme.brightness == Brightness.dark ? 
                         Colors.grey.shade400 : Colors.grey.shade700,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Completed on ${challenge['completedDate'] ?? 'Unknown date'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark ?
                         Colors.green.shade900.withOpacity(0.3) : Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
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

  /// Build compact view for the main community screen - only showing active challenges
  Widget _buildCompactView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    
    List<Widget> challengeWidgets = [];
    
    if (_activeChallenges.isEmpty) {
      challengeWidgets.add(_buildCompactEmptyChallenges());
    } else {
      // Show up to 2 challenges to match mockup
      final displayCount = _activeChallenges.length > 2 ? 2 : _activeChallenges.length;
      
      for (int i = 0; i < displayCount; i++) {
        final userChallenge = _activeChallenges[i];
        
        // Find the challenge details
        final challenge = _allChallenges.firstWhere(
          (c) => c.id == userChallenge.challengeId,
          orElse: () => Challenge(
            id: userChallenge.challengeId,
            title: 'Unknown Challenge',
            description: 'Challenge details not available',
            type: 'unknown',
            targetValue: 0,
            difficultyLevel: 1,
            rewardValue: 0,
            metricType: 'unknown',
          ),
        );
        
        challengeWidgets.add(
          InkWell(
            onTap: () {
              // Navigate to challenge detail screen
              Navigator.of(context).pushNamed(
                CommunityRoutes.challengeDetail,
                arguments: challenge.id,
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: _buildCompactChallengeItem(challenge, userChallenge),
          ),
        );
      }
    }
    
    // Add "Browse All Challenges" button
    challengeWidgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: InkWell(
          onTap: () {
            // Navigate to full challenges view
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Challenges'),
                            elevation: 0,
                            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
                            centerTitle: false,
                          ),
                          body: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: ChallengesView(),
                          ),
                        ),
                      ),
                    );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                'Browse All Challenges',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: challengeWidgets,
    );
  }

  /// Build a compact challenge item for the main community screen
  Widget _buildCompactChallengeItem(Challenge challenge, UserChallenge userChallenge) {
    final progress = userChallenge.progress / challenge.targetValue;
    final formattedChallenge = _formatChallengeForUI(challenge, userChallenge: userChallenge);
    final theme = Theme.of(context);
    
    // Simplified item card to match mockup
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Trophy/Challenge icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark 
                           ? AppColors.darkSurface
                           : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Challenge info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedChallenge['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.dark 
                                     ? Colors.grey.shade800 
                                     : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Ongoing',
                              style: TextStyle(
                                color: theme.brightness == Brightness.dark 
                                       ? Colors.grey.shade300 
                                       : Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.people, 
                            size: 16, 
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${formattedChallenge['participants']}',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Progress section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}% Complete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '${userChallenge.progress}/${challenge.targetValue}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.brightness == Brightness.dark 
                                     ? Colors.grey.shade800 
                                     : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactEmptyChallenges() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No active challenges',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join a challenge to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Join the given challenge
  Future<void> _joinChallenge(String challengeId) async {
    final currentUser = _userService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please restart the app.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Join the challenge
      final result = await _challengeService.startChallenge(
        currentUser.id,
        challengeId,
      );
      
      if (result != null) {
        _logger.info('Successfully joined challenge: $challengeId');
        
        // Reload challenges to update UI
        await _loadChallenges();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Joined challenge successfully'),
              duration: Duration(seconds: 2),
            ),
          );
          
          // Switch to active challenges tab to show the user their joined challenge
          _tabController.animateTo(0);
        }
      } else {
        _logger.warning('Failed to join challenge: $challengeId');
        
        // Hide loading indicator
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to join challenge. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      _logger.severe('Error joining challenge: $e');
      
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error joining challenge: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
} 