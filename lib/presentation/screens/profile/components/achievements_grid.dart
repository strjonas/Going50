import 'package:flutter/material.dart';
import 'package:going50/services/gamification/achievement_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:going50/presentation/providers/user_provider.dart';

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

class _AchievementsGridState extends State<AchievementsGrid> {
  final AchievementService _achievementService = serviceLocator<AchievementService>();
  final UserService _userService = serviceLocator<UserService>();
  
  // List to store user badges
  List<Map<String, dynamic>> _badges = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _userInitialized = false; // Track if user is initialized
  
  @override
  void initState() {
    super.initState();
    // Check if user service is initialized with a small delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _loadBadges();
      }
    });
    
    // Subscribe to achievement events to update the grid when new badges are earned
    _achievementService.achievementEventStream.listen((event) {
      _loadBadges(); // Reload badges when a new one is earned
    });
  }
  
  /// Load badges from the achievement service
  Future<void> _loadBadges() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Get current user from provider to ensure it's initialized
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Check if user provider is still loading
      if (userProvider.isLoading) {
        // Try again after a delay if user data is still loading
        if (mounted) {
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) _loadBadges();
          });
        }
        return;
      }
      
      final currentUser = _userService.currentUser;
      if (currentUser != null) {
        // Get badges from service
        final badges = await _achievementService.getUserBadges(currentUser.id);
        
        // Add progress data from available badge types
        final badgeTypes = _achievementService.getAvailableBadgeTypes();
        
        if (mounted) {
          setState(() {
            _badges = _processUserBadges(badges, badgeTypes);
            _isLoading = false;
            _userInitialized = true;
          });
        }
      } else {
        // Try to initialize user service if not already done
        if (!_userInitialized) {
          if (mounted) {
            setState(() {
              _isLoading = true;
              _errorMessage = "Loading user data...";
            });
          }
          
          // Initialize user service
          await _userService.initialize();
          
          // Try again after initialization
          if (mounted) {
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) _loadBadges();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _errorMessage = 'User not found. Please restart the app.';
              _isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading badges: $e');
      }
      
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load achievements';
          _isLoading = false;
        });
      }
    }
  }
  
  /// Process user badges and add progress information
  List<Map<String, dynamic>> _processUserBadges(
    List<Map<String, dynamic>> userBadges,
    List<Map<String, dynamic>> badgeTypes
  ) {
    // First add all earned badges
    final processedBadges = [...userBadges];
    
    // Then add badges that aren't earned yet (up to max count)
    for (final badgeType in badgeTypes) {
      // Skip if user already has this badge
      if (userBadges.any((b) => b['badgeType'] == badgeType['badgeType'])) {
        continue;
      }
      
      // Add unearned badge with progress (mocked for now until we have real progress tracking)
      processedBadges.add({
        'badgeType': badgeType['badgeType'],
        'name': badgeType['name'],
        'description': badgeType['description'],
        'earned': false,
        'progress': 0.0, // We'll need a way to track progress for each badge type
        'icon': _getBadgeIcon(badgeType['badgeType']),
      });
    }
    
    return processedBadges;
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
            itemCount: _badges.length > 6 ? 6 : _badges.length, // Show max 6 badges or fewer
            itemBuilder: (context, index) {
              if (index < _badges.length) {
                final badge = _badges[index];
                return _buildBadgeItem(context, badge);
              } else {
                return _buildLockedBadge(context);
              }
            },
          ),
        ),
        
        if (widget.showSeeAllButton && _badges.length > 0)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: widget.onSeeAllPressed ?? () {
                _showAllAchievements(context);
              },
              child: Text(
                'See All (${_badges.length})',
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
    final bool isEarned = badge.containsKey('earnedDate') || (badge['earned'] == true);
    final double? progress = badge['progress'] as double?;
    
    return GestureDetector(
      onTap: () => _showBadgeDetails(context, badge),
      child: Container(
        decoration: BoxDecoration(
          color: isEarned 
              ? Theme.of(context).primaryColor.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned 
                ? Theme.of(context).primaryColor.withOpacity(0.3) 
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge icon
            Icon(
              _getBadgeIcon(badge['badgeType']),
              size: 32,
              color: isEarned 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.withOpacity(0.5),
            ),
            
            const SizedBox(height: 8),
            
            // Badge name
            Text(
              badge['name'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isEarned ? FontWeight.bold : FontWeight.normal,
                color: isEarned 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withOpacity(0.7),
              ),
            ),
            
            // Progress indicator (if badge is in progress)
            if (!isEarned && progress != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
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
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
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
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _badges.length,
                  itemBuilder: (context, index) {
                    return _buildBadgeItem(context, _badges[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Show badge details in a dialog
  void _showBadgeDetails(BuildContext context, Map<String, dynamic> badge) {
    final bool isEarned = badge.containsKey('earnedDate') || (badge['earned'] == true);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getBadgeIcon(badge['badgeType']),
                size: 64,
                color: isEarned 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                badge['name'] as String,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isEarned 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge['description'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEarned 
                    ? 'Earned: ${_formatDate(badge['earnedDate'] as DateTime? ?? DateTime.now())}' 
                    : 'Not earned yet',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Format a date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 