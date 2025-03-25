import 'package:flutter/material.dart';
import 'package:going50/services/gamification/achievement_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';
import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/widgets/achievements/achievement_celebration.dart';
import 'dart:math' as math;

/// AchievementsGrid displays a grid of earned achievement badges
class AchievementsGrid extends StatefulWidget {
  /// Number of columns to display in the grid
  final int columns;
  
  /// Whether to show a "See All" button
  final bool showSeeAllButton;
  
  /// Callback when "See All" is pressed
  final VoidCallback? onSeeAllPressed;
  
  /// Constructor
  const AchievementsGrid({
    super.key, 
    this.columns = 3,
    this.showSeeAllButton = true,
    this.onSeeAllPressed,
  });

  @override
  State<AchievementsGrid> createState() => _AchievementsGridState();
}

class _AchievementsGridState extends State<AchievementsGrid> with TickerProviderStateMixin {
  final AchievementService _achievementService = serviceLocator<AchievementService>();
  final UserService _userService = serviceLocator<UserService>();
  
  // List to store user badges
  List<Map<String, dynamic>> _badges = [];
  // List to store all badges (earned and unearned) for quick view
  List<Map<String, dynamic>> _quickViewBadges = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _userInitialized = false; // Track if user is initialized
  
  // Animation controllers
  late AnimationController _shineController;
  Map<String, AnimationController> _unlockControllers = {};
  String? _recentlyUnlockedBadgeId;
  
  @override
  void initState() {
    super.initState();
    
    if (kDebugMode) {
      print('AchievementsGrid: Initializing');
    }
    
    // Initialize shine animation controller
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Initial load with a small delay to ensure services are ready
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        if (kDebugMode) {
          print('AchievementsGrid: Loading badges after delay');
        }
        _loadBadges();
      }
    });
    
    // Subscribe to achievement events to update the grid when new badges are earned
    _achievementService.achievementEventStream.listen((event) {
      if (kDebugMode) {
        print('AchievementsGrid: Achievement event received: ${event.badgeType}');
      }
      
      // Show celebration animation for the new badge
      _recentlyUnlockedBadgeId = '${event.badgeType}_${event.level}';
      
      // Force badge cache refresh by clearing the cache
      if (mounted) {
        if (kDebugMode) {
          print('AchievementsGrid: Reloading badges after achievement event');
        }
        
        // Short delay to ensure the badge is saved to the database
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            _loadBadges().then((_) {
              // Start celebration animation after badges are loaded
              _startUnlockAnimation(_recentlyUnlockedBadgeId!);
              
              // Show achievement celebration dialog
              _showAchievementCelebration(event);
            });
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _shineController.dispose();
    // Dispose all unlock controllers
    for (final controller in _unlockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  /// Start unlock animation for a specific badge
  void _startUnlockAnimation(String badgeId) {
    // Create a controller if it doesn't exist
    if (!_unlockControllers.containsKey(badgeId)) {
      _unlockControllers[badgeId] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );
    }
    
    // Reset and start the animation
    _unlockControllers[badgeId]!.reset();
    _unlockControllers[badgeId]!.forward().then((_) {
      // After main animation completes, start shine animation
      _shineController.reset();
      _shineController.forward();
    });
  }
  
  /// Load badges from the achievement service
  Future<void> _loadBadges() async {
    if (_isLoading == false) {
      setState(() {
        _isLoading = true;
      });
    }
    
    try {
      // Get the current user ID from UserService
      final user = _userService.currentUser;
      
      if (user == null) {
        if (kDebugMode) {
          print('AchievementsGrid: No user found, trying to initialize UserService');
        }
        
        // No user found, initialize UserService
        await _userService.initialize();
        final currentUser = _userService.currentUser;
        
        if (currentUser != null && mounted) {
          // Load badges for current user
          final badges = await _achievementService.getUserBadges(currentUser.id);
          
          // Get all available badge types with progress
          final allBadgeTypes = _achievementService.getAvailableBadgeTypes();
          final quickViewBadges = await _prepareQuickViewBadges(currentUser.id, allBadgeTypes, badges);
          
          if (mounted) {
            setState(() {
              _badges = badges;
              _quickViewBadges = quickViewBadges;
              _isLoading = false;
              _errorMessage = null;
              _userInitialized = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to initialize user';
            });
          }
        }
      } else {
        if (kDebugMode) {
          print('AchievementsGrid: Loading badges for user ${user.id}');
        }
        
        // Load badges for the current user
        final badges = await _achievementService.getUserBadges(user.id);
        
        // Get all available badge types with progress
        final allBadgeTypes = _achievementService.getAvailableBadgeTypes();
        final quickViewBadges = await _prepareQuickViewBadges(user.id, allBadgeTypes, badges);
        
        if (mounted) {
          setState(() {
            _badges = badges;
            _quickViewBadges = quickViewBadges;
            _isLoading = false;
            _errorMessage = null;
            _userInitialized = true;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AchievementsGrid: Error loading badges: $e');
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load achievements: $e';
        });
      }
    }
  }

  /// Prepare badges for quick view - a mix of earned and high-progress unearned badges
  Future<List<Map<String, dynamic>>> _prepareQuickViewBadges(
    String userId, 
    List<Map<String, dynamic>> allBadgeTypes,
    List<Map<String, dynamic>> earnedBadges
  ) async {
    final List<Map<String, dynamic>> result = [];
    
    // Get progress for unearned badges
    final progressBadges = <Map<String, dynamic>>[];
    
    // Find unearned badge types
    final earnedTypes = earnedBadges.map((b) => b['badgeType'] as String).toSet();
    final unearnedTypes = allBadgeTypes
        .where((b) => !earnedTypes.contains(b['badgeType']))
        .toList();
    
    // Create a list for all unearned badges - regardless of progress
    final allUnearnedBadges = <Map<String, dynamic>>[];
    
    // Process all unearned badge types
    for (final badgeType in unearnedTypes) {
      final type = badgeType['badgeType'] as String;
      final progress = await _achievementService.getBadgeProgress(userId, type);
      
      final badgeWithProgress = {
        ...badgeType,
        'progress': progress ?? 0.0,
        'earned': false,
      };
      
      // Add to all unearned badges
      allUnearnedBadges.add(badgeWithProgress);
      
      // Also add to progress badges if it has progress
      if (progress != null && progress > 0) {
        progressBadges.add(badgeWithProgress);
      }
    }
    
    // Sort by progress (highest first)
    progressBadges.sort((a, b) => 
      (b['progress'] as double).compareTo(a['progress'] as double)
    );
    
    // Sort all unearned badges by progress (highest first)
    allUnearnedBadges.sort((a, b) => 
      (b['progress'] as double).compareTo(a['progress'] as double)
    );
    
    // Add earned badges first (capped at 3 to ensure at least 3 unearned ones if possible)
    result.addAll(earnedBadges.take(3));
    
    // Add unearned badges with progress first
    if (progressBadges.isNotEmpty) {
      // How many spaces we have left in our 6-item grid
      final spacesLeft = 6 - result.length;
      // Add as many progress badges as we can fit
      result.addAll(progressBadges.take(spacesLeft));
    }
    
    // If we still have space and not enough badges yet, add more unearned badges
    if (result.length < 6) {
      // Add unearned badges that weren't already added (including those without progress)
      final alreadyAddedTypes = result.map((b) => b['badgeType'] as String).toSet();
      final remainingUnearned = allUnearnedBadges
          .where((b) => !alreadyAddedTypes.contains(b['badgeType']))
          .toList();
      
      result.addAll(remainingUnearned.take(6 - result.length));
    }
    
    // If we still have space and not enough badges yet, add more earned badges
    if (result.length < 6 && earnedBadges.length > 3) {
      final alreadyAddedEarnedTypes = result
          .where((b) => b.containsKey('earnedDate') || b['earned'] == true)
          .map((b) => b['badgeType'] as String)
          .toSet();
      
      final remainingEarned = earnedBadges
          .where((b) => !alreadyAddedEarnedTypes.contains(b['badgeType']))
          .toList();
      
      result.addAll(remainingEarned.take(6 - result.length));
    }
    
    // If we have fewer than 6 badges total (earned + unearned), just fill the grid with what we have
    if (result.length < 6 && result.length < (earnedBadges.length + allUnearnedBadges.length)) {
      if (kDebugMode) {
        print('AchievementsGrid: Unable to fill grid with 6 badges. Only ${result.length} available.');
      }
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while loading
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading achievements..."),
            ],
          ),
        ),
      );
    }
    
    // Show error message if there was an error
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadBadges,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            // Use the mixed quick view badges instead of just earned ones
            itemCount: _quickViewBadges.length > 6 ? 6 : _quickViewBadges.length,
            itemBuilder: (context, index) {
              if (index < _quickViewBadges.length) {
                final badge = _quickViewBadges[index];
                return _buildBadgeItem(context, badge);
              } else {
                return _buildLockedBadge(context);
              }
            },
          ),
        ),
        
        // Always show the "See All" button if we have any badges (earned or in progress)
        if (widget.showSeeAllButton)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: widget.onSeeAllPressed ?? () {
                _showAllAchievements(context);
              },
              child: Text(
                // Show the count of all available achievements
                'See All (${_achievementService.getAvailableBadgeTypes().length})',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build a badge item
  Widget _buildBadgeItem(BuildContext context, Map<String, dynamic> badge) {
    final bool isEarned = badge.containsKey('earnedDate') || (badge['earned'] == true) || 
        ((badge['progress'] as double?) ?? 0) >= 1.0; // Also check for 100% progress
    final double? progress = badge['progress'] as double?;
    final String badgeType = badge['badgeType'] as String;
    final int level = badge['level'] as int? ?? 1;
    final String badgeId = '${badgeType}_$level';
    
    // Check if this badge was recently unlocked
    final bool isRecentlyUnlocked = _recentlyUnlockedBadgeId == badgeId;
    
    // Create an animation controller for this badge if needed
    if (isRecentlyUnlocked && !_unlockControllers.containsKey(badgeId)) {
      _unlockControllers[badgeId] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..forward();
    }
    
    return GestureDetector(
      onTap: () => _showBadgeDetails(context, badge),
      child: isRecentlyUnlocked && _unlockControllers.containsKey(badgeId) 
          ? _buildAnimatedBadge(context, badge, _unlockControllers[badgeId]!) 
          : _buildStaticBadge(context, badge),
    );
  }
  
  /// Build an animated badge when unlocked
  Widget _buildAnimatedBadge(BuildContext context, Map<String, dynamic> badge, AnimationController controller) {
    // Create animations
    final scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );
    
    final pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );
    
    final rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0.08), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.08, end: -0.08), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -0.08, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );
    
    // Shine animation
    final shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shineController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.value < 0.4 
              ? scaleAnimation.value 
              : (controller.value < 0.7 ? pulseAnimation.value : 1.0),
          child: Transform.rotate(
            angle: rotateAnimation.value * math.pi,
            child: Stack(
              children: [
                // The badge content
                _buildStaticBadge(context, badge, isAnimating: true),
                
                // Shine effect with separate controller
                if (controller.value > 0.7)
                  AnimatedBuilder(
                    animation: _shineController,
                    builder: (context, _) {
                      return Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Transform.rotate(
                            angle: math.pi / 4, // 45 degrees
                            child: Transform.translate(
                              offset: Offset(
                                shineAnimation.value * 200,
                                0,
                              ),
                              child: Container(
                                width: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0),
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                
                // Initial celebration particles
                if (controller.value < 0.4)
                  ...List.generate(8, (i) {
                    final angle = i * (math.pi / 4); // Evenly spaced around circle
                    final distance = 50 * controller.value; // Gradually move outward
                    final fadeOpacity = 1.0 - controller.value * 2.5; // Fade out
                    
                    return Positioned(
                      left: 50 + math.cos(angle) * distance,
                      top: 50 + math.sin(angle) * distance,
                      child: Opacity(
                        opacity: fadeOpacity > 0 ? fadeOpacity : 0,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Build a static badge (normal display)
  Widget _buildStaticBadge(BuildContext context, Map<String, dynamic> badge, {bool isAnimating = false}) {
    final bool isEarned = badge.containsKey('earnedDate') || (badge['earned'] == true) || 
        ((badge['progress'] as double?) ?? 0) >= 1.0; // Also check for 100% progress
    final double? progress = badge['progress'] as double?;
    
    // Enhanced visual distinction for earned badges - with better contrast
    final borderColor = isEarned 
        ? AppColors.ecoScoreHigh // Gold/green color for earned badges
        : Colors.grey.withOpacity(0.3);
        
    // Lighter background for better contrast with the green text/icon
    final backgroundColor = isEarned 
        ? AppColors.ecoScoreHigh.withOpacity(0.08) // Reduced opacity for better contrast
        : Colors.grey.withOpacity(0.1);
    
    final iconColor = isEarned
        ? AppColors.ecoScoreHigh // Vibrant icon color 
        : Colors.grey.withOpacity(0.7);
        
    final textColor = isEarned
        ? AppColors.ecoScoreHigh // Vibrant text color
        : Colors.grey.withOpacity(0.9);
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isEarned ? 2.5 : 1.0, // Thicker border for earned badges
        ),
        // Add a subtle shadow or glow for earned badges
        boxShadow: isEarned ? [
          BoxShadow(
            color: AppColors.ecoScoreHigh.withOpacity(isAnimating ? 0.4 : 0.2),
            blurRadius: isAnimating ? 10 : 6,
            spreadRadius: isAnimating ? 2 : 1,
          )
        ] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge icon with conditional styling
          Icon(
            _getBadgeIcon(badge['badgeType'] as String),
            size: 32,
            color: iconColor,
          ),
          
          const SizedBox(height: 8),
          
          // Badge name
          Text(
            badge['name'] as String? ?? 'Badge',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isEarned ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          
          // Display either progress or completion indicator
          if (!isEarned && progress != null && progress > 0) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: 40,
              height: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          ] else if (isEarned) ...[
            // Show "Completed" indicator for earned badges
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.ecoScoreHigh.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.ecoScoreHigh.withOpacity(0.3),
                ),
              ),
              child: Text(
                '100%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ecoScoreHigh,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build a locked badge
  Widget _buildLockedBadge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 24,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Locked',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Get icon for a badge type
  IconData _getBadgeIcon(String badgeType) {
    switch (badgeType) {
      case 'smooth_driver':
        return Icons.rowing;
      case 'eco_warrior':
        return Icons.eco;
      case 'fuel_saver':
        return Icons.local_gas_station;
      case 'carbon_reducer':
        return Icons.co2;
      case 'road_veteran':
        return Icons.map;
      case 'speed_master':
        return Icons.speed;
      case 'eco_expert':
        return Icons.auto_graph;
      case 'fuel_efficiency':
        return Icons.trending_up;
      case 'consistent_driver':
        return Icons.repeat;
      case 'early_adopter':
        return Icons.star;
      default:
        return Icons.emoji_events;
    }
  }
  
  /// Show all achievements in a dialog
  void _showAllAchievements(BuildContext context) {
    // Get current user ID for loading badge progress
    final userId = _userService.currentUser?.id;
    
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please try again.')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // Make the dialog larger to avoid horizontal squashing
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Occupy 90% of screen width
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Achievements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Use less columns in the expanded view for better spacing
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _buildAllAchievementsList(userId.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading achievements: ${snapshot.error}'),
                      );
                    }
                    
                    final allBadges = snapshot.data ?? [];
                    
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Reduced from 3 to 2 for better spacing
                        crossAxisSpacing: 16, // Increased from 12 to 16
                        mainAxisSpacing: 16, // Increased from 12 to 16
                        childAspectRatio: 1.0, // Adjusted for better proportions
                      ),
                      itemCount: allBadges.length,
                      itemBuilder: (context, index) {
                        return _buildBadgeItem(context, allBadges[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build a list of all achievements (earned and unearned)
  Future<List<Map<String, dynamic>>> _buildAllAchievementsList(String userId) async {
    final List<Map<String, dynamic>> result = [];
    
    // Get all badge types
    final allBadgeTypes = _achievementService.getAvailableBadgeTypes();
    
    // Map of earned badges by type
    final earnedBadgesByType = {
      for (var badge in _badges) 
        badge['badgeType'] as String: badge
    };
    
    // Process each available badge type
    for (final badgeType in allBadgeTypes) {
      final type = badgeType['badgeType'] as String;
      
      // If earned, add the earned badge
      if (earnedBadgesByType.containsKey(type)) {
        result.add(earnedBadgesByType[type]!);
      } else {
        // Otherwise, add unearned badge with progress
        final progress = await _achievementService.getBadgeProgress(userId, type);
        result.add({
          ...badgeType,
          'level': 1, // Default to level 1 for unearned
          'progress': progress ?? 0.0,
          'earned': false,
        });
      }
    }
    
    // Sort with earned badges first, then by progress
    result.sort((a, b) {
      final aEarned = a.containsKey('earnedDate') || (a['earned'] == true);
      final bEarned = b.containsKey('earnedDate') || (b['earned'] == true);
      
      if (aEarned && !bEarned) return -1;
      if (!aEarned && bEarned) return 1;
      
      // Both earned or both unearned - sort by progress
      final aProgress = a['progress'] as double? ?? 0.0;
      final bProgress = b['progress'] as double? ?? 0.0;
      
      return bProgress.compareTo(aProgress);
    });
    
    return result;
  }
  
  /// Show badge details in a dialog
  void _showBadgeDetails(BuildContext context, Map<String, dynamic> badge) {
    // Use the same isEarned logic as in _buildStaticBadge for consistency
    final bool isEarned = badge.containsKey('earnedDate') || (badge['earned'] == true) ||
        ((badge['progress'] as double?) ?? 0) >= 1.0;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isEarned ? Border.all(
              color: AppColors.ecoScoreHigh.withOpacity(0.7),
              width: 2,
            ) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge icon with special styling
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEarned 
                      ? AppColors.ecoScoreHigh.withOpacity(0.1) // Reduced opacity for better contrast
                      : Colors.grey.withOpacity(0.1),
                  boxShadow: isEarned ? [
                    BoxShadow(
                      color: AppColors.ecoScoreHigh.withOpacity(0.2), // Reduced opacity
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ] : null,
                  border: Border.all(
                    color: isEarned 
                        ? AppColors.ecoScoreHigh.withOpacity(0.7)
                        : Colors.grey.withOpacity(0.3),
                    width: isEarned ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getBadgeIcon(badge['badgeType'] as String),
                    size: 64,
                    color: isEarned 
                        ? AppColors.ecoScoreHigh
                        : Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isEarned
                      ? AppColors.ecoScoreHigh.withOpacity(0.1) // Reduced opacity
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isEarned
                        ? AppColors.ecoScoreHigh.withOpacity(0.7)
                        : Colors.grey.withOpacity(0.3),
                    width: isEarned ? 2 : 1,
                  ),
                ),
                child: Text(
                  isEarned ? 'ACHIEVED' : 'IN PROGRESS',
                  style: TextStyle(
                    color: isEarned
                        ? AppColors.ecoScoreHigh
                        : Colors.grey.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Badge name
              Text(
                badge['name'] as String,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isEarned
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.titleLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Badge description
              Text(
                badge['description'] as String? ?? 'No description available',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Progress indicator for unearned badges
              if (!isEarned && badge.containsKey('progress')) ...[
                const SizedBox(height: 8),
                
                // Progress percentage
                Text(
                  'Progress: ${((badge['progress'] as double) * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: badge['progress'] as double,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
              
              if (isEarned && badge.containsKey('earnedDate')) ...[
                const SizedBox(height: 16),
                Text(
                  'Earned on: ${_formatEarnedDate(badge['earnedDate'])}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
              
              // Close button
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEarned 
                      ? AppColors.ecoScoreHigh
                      : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Format earned date for display
  String _formatEarnedDate(dynamic date) {
    if (date == null) return 'Unknown date';
    
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (date is String) {
      try {
        final parsedDate = DateTime.parse(date);
        return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
      } catch (e) {
        return date; // Return the original string if parsing fails
      }
    }
    
    return 'Unknown date';
  }

  /// Show the achievement celebration dialog
  void _showAchievementCelebration(AchievementEvent event) {
    // Show celebration only if we're visible
    if (mounted && ModalRoute.of(context)?.isCurrent == true) {
      showAchievementCelebration(
        context,
        title: "${event.badgeName} - Level ${event.level}",
        description: event.badgeDescription,
        icon: _getBadgeIcon(event.badgeType),
        onDismiss: () {
          // Nothing special to do on dismiss
        },
      );
    }
  }
} 