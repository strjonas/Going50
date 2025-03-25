import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/presentation/providers/social_provider.dart';
import 'package:going50/presentation/providers/insights_provider.dart';
import 'package:going50/services/gamification/achievement_service.dart';
import 'package:going50/services/service_locator.dart';

/// FriendProfileScreen displays another user's eco-driving profile.
///
/// This screen shows:
/// - Basic profile information
/// - Achievement showcase
/// - Driving statistics summary
/// - Interaction options
class FriendProfileScreen extends StatefulWidget {
  /// ID of the friend whose profile to display
  final String friendId;

  /// Constructor
  const FriendProfileScreen({
    super.key,
    required this.friendId,
  });

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  bool _isCompareMode = false;
  
  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context);
    final insightsProvider = Provider.of<InsightsProvider>(context);
    
    // Get friend profile from provider
    final friend = socialProvider.getFriendById(widget.friendId);
    
    if (friend == null) {
      // Handle case where friend is not found
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text('Friend not found'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context, friend),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, friend),
            const Divider(height: 1),
            _buildAchievementShowcase(context, friend),
            const Divider(height: 1),
            _buildStatisticsSummary(context, friend, insightsProvider),
            const Divider(height: 1),
            _buildInteractionSection(context, friend, socialProvider),
          ],
        ),
      ),
    );
  }
  
  /// Builds the profile header section with avatar, name, and basic info
  Widget _buildProfileHeader(BuildContext context, UserProfile friend) {
    // Mock data - in a real app, this would come from a service
    final ecoDriverLevel = 'Eco Explorer';
    final memberSince = friend.createdAt;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade700,
                  size: 48,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.eco,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ecoDriverLevel,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Member since ${_formatDate(memberSince)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Connection status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Connected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Impact stats
          Row(
            children: [
              _buildImpactStat(
                'CO₂ Saved',
                '320 kg',
                Icons.cloud_outlined,
              ),
              _buildImpactStat(
                'Fuel Saved',
                '145 L',
                Icons.local_gas_station_outlined,
              ),
              _buildImpactStat(
                'Money Saved',
                '\$186',
                Icons.attach_money,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Builds a single impact statistic
  Widget _buildImpactStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.secondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// Builds the achievement showcase grid
  Widget _buildAchievementShowcase(BuildContext context, UserProfile friend) {
    final achievementService = serviceLocator<AchievementService>();
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: achievementService.getUserBadges(friend.id),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Handle error state
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Could not load achievements: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        
        // Handle empty achievements
        final achievements = snapshot.data ?? [];
        if (achievements.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No achievements yet'),
          );
        }
        
        // Show badges
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show all achievements
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Full achievements view coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Achievements grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: achievements.length > 5 ? 5 : achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return _buildAchievementBadge(
                    context,
                    achievement['badgeType'] as String,
                    achievement['level'] as int,
                    achievement['name'] as String,
                    achievement['description'] as String,
                  );
                },
              ),
              
              const SizedBox(height: 8),
              
              // Challenge progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Challenge',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Eco Week: Maintain 90+ eco-score for 7 days',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.7,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Builds a single achievement badge
  Widget _buildAchievementBadge(
    BuildContext context,
    String badgeType,
    int level,
    String name,
    String description,
  ) {
    IconData iconData;
    Color color;
    
    // Determine icon and color based on achievement type
    switch (badgeType) {
      case 'eco_expert':
      case 'eco_master':
        iconData = Icons.star;
        color = AppColors.primary;
        break;
      case 'smooth_driver':
        iconData = Icons.waves;
        color = Colors.blue;
        break;
      case 'fuel_saver':
      case 'fuel_efficiency':
        iconData = Icons.local_gas_station;
        color = Colors.orange;
        break;
      case 'streak_keeper':
      case 'consistent_driver':
        iconData = Icons.local_fire_department;
        color = Colors.red;
        break;
      case 'carbon_reducer':
        iconData = Icons.cloud;
        color = Colors.green;
        break;
      case 'road_veteran':
        iconData = Icons.map;
        color = Colors.purple;
        break;
      case 'speed_master':
        iconData = Icons.speed;
        color = Colors.amber;
        break;
      default:
        iconData = Icons.emoji_events;
        color = AppColors.secondary;
    }
    
    return GestureDetector(
      onTap: () {
        // Show achievement details
        _showAchievementDetails(context, name, description, level);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Lvl $level',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds the statistics summary section
  Widget _buildStatisticsSummary(
    BuildContext context,
    UserProfile friend,
    InsightsProvider insightsProvider,
  ) {
    // Mock statistics - in a real app, this would come from a service
    final stats = {
      'Total Trips': '145',
      'Distance Driven': '2,876 km',
      'Average Eco-Score': '87',
      'Best Eco-Score': '98',
      'Total Driving Time': '156 hrs',
      'Fuel Saved': '145 L',
    };
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Compare toggle
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCompareMode = !_isCompareMode;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isCompareMode
                        ? AppColors.secondary.withOpacity(0.2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.compare_arrows,
                        size: 16,
                        color: _isCompareMode
                            ? AppColors.secondary
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Compare',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _isCompareMode
                              ? AppColors.secondary
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Statistics grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final entry = stats.entries.elementAt(index);
              // Mock data for comparison
              final yourValue = _isCompareMode ? {
                'Total Trips': '98',
                'Distance Driven': '1,920 km',
                'Average Eco-Score': '82',
                'Best Eco-Score': '95',
                'Total Driving Time': '108 hrs',
                'Fuel Saved': '98 L',
              }[entry.key] : null;
              
              return _buildStatisticItem(
                entry.key,
                entry.value,
                yourValue,
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Recent activity
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Activity timeline
          _buildActivityTimeline(),
        ],
      ),
    );
  }
  
  /// Builds a single statistic item
  Widget _buildStatisticItem(String label, String value, String? yourValue) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (yourValue != null) ...[
                const SizedBox(width: 8),
                Container(
                  height: 12,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                Text(
                  'You: $yourValue',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  /// Builds the activity timeline
  Widget _buildActivityTimeline() {
    // Mock activity data - in a real app, this would come from a service
    final activities = [
      {
        'type': 'challenge',
        'title': 'Completed "Eco Week" Challenge',
        'time': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'type': 'badge',
        'title': 'Earned "Smooth Driver" Level 3',
        'time': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'type': 'trip',
        'title': 'Achieved 95 Eco-Score on commute',
        'time': DateTime.now().subtract(const Duration(days: 7)),
      },
    ];
    
    return Column(
      children: activities.map((activity) {
        IconData iconData;
        Color color;
        
        // Determine icon and color based on activity type
        switch (activity['type']) {
          case 'challenge':
            iconData = Icons.emoji_events;
            color = AppColors.secondary;
            break;
          case 'badge':
            iconData = Icons.verified;
            color = AppColors.primary;
            break;
          case 'trip':
            iconData = Icons.route;
            color = Colors.blue;
            break;
          default:
            iconData = Icons.circle;
            color = Colors.grey;
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatActivityTime(activity['time'] as DateTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  /// Builds the interaction section with buttons
  Widget _buildInteractionSection(
    BuildContext context,
    UserProfile friend,
    SocialProvider socialProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interact',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Challenge button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showChallengeInvite(context, friend),
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('Challenge'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Message button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Messaging feature coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Shows challenge invitation dialog
  void _showChallengeInvite(BuildContext context, UserProfile friend) {
    // Mock challenges - in a real app, this would come from a service
    final challenges = [
      {'id': 'c1', 'title': 'Weekend Warrior', 'description': 'Achieve 90+ eco-score on weekend drives'},
      {'id': 'c2', 'title': 'Fuel Master', 'description': 'Save at least 5L of fuel in the next week'},
      {'id': 'c3', 'title': 'Smooth Operator', 'description': 'No harsh acceleration events for 5 days'},
    ];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Challenge ${friend.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Challenge list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            challenge['description'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Challenge invitation sent to ${friend.name}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Send Invite'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Shows achievement details dialog
  void _showAchievementDetails(
    BuildContext context,
    String name,
    String description,
    int level,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 8),
            Text('Level: $level'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  /// Shows more options menu
  void _showMoreOptions(BuildContext context, UserProfile friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Profile'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Report User'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporting feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove),
            title: const Text('Remove Friend'),
            onTap: () {
              Navigator.pop(context);
              _showRemoveFriendConfirmation(context, friend);
            },
          ),
        ],
      ),
    );
  }
  
  /// Shows confirmation dialog for removing a friend
  void _showRemoveFriendConfirmation(BuildContext context, UserProfile friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text('Are you sure you want to remove ${friend.name} from your friends?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final socialProvider = Provider.of<SocialProvider>(context, listen: false);
              final success = await socialProvider.removeFriend(friend.id);
              
              if (success && mounted) {
                Navigator.pop(context); // Return to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${friend.name} removed from friends'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
  
  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  /// Format time for activity timeline
  String _formatActivityTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inHours < 24) {
      return 'Today';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }
} 