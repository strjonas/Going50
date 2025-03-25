import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';
import 'package:going50/presentation/screens/community/components/shared_filters.dart';

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
          child: TabBarView(
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
    // Mock data - in a real app, this would come from a service or provider
    final List<Map<String, dynamic>> activeChallenges = [
      {
        'id': 'daily_eco_score_75',
        'title': 'Green Commuter',
        'description': 'Achieve at least 75 eco-score on a trip today',
        'iconName': 'eco',
        'progress': 3,
        'target': 5,
        'timeRemaining': '3 days',
        'participants': 243,
      },
      {
        'id': 'achievement_fuel_saved_20',
        'title': 'Fuel Miser',
        'description': 'Save 20 liters of fuel through eco-driving',
        'iconName': 'local_gas_station',
        'progress': 2.7,
        'target': 5,
        'timeRemaining': '5 days',
        'participants': 189,
      },
      {
        'id': 'weekly_trips_5',
        'title': 'Regular Driver',
        'description': 'Complete 5 trips this week',
        'iconName': 'repeat',
        'progress': 1,
        'target': 3,
        'timeRemaining': '2 days',
        'participants': 310,
      },
    ];
    
    return activeChallenges.isEmpty
        ? const Center(child: Text('No active challenges'))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: activeChallenges.length,
            itemBuilder: (context, index) {
              final challenge = activeChallenges[index];
              return _buildActiveChallengeCard(challenge);
            },
          );
  }
  
  Widget _buildAvailableChallengesTab() {
    // Mock data - in a real app, this would come from a service or provider
    final List<Map<String, dynamic>> availableChallenges = [
      {
        'id': 'achievement_co2_reduced_50',
        'title': 'Climate Guardian',
        'description': 'Reduce CO2 emissions by 50kg',
        'iconName': 'cloud',
        'difficulty': 'Medium',
        'reward': '100 points',
        'duration': '7 days',
        'participants': 156,
      },
      {
        'id': 'daily_calm_driving_80',
        'title': 'Zen Driver',
        'description': 'Maintain a calm driving score of 80+ today',
        'iconName': 'mood',
        'difficulty': 'Hard',
        'reward': '200 points',
        'duration': '5 days',
        'participants': 85,
      },
      {
        'id': 'weekly_distance_100',
        'title': 'Distance Champion',
        'description': 'Drive 100km with eco-score above 80 this week',
        'iconName': 'straighten',
        'difficulty': 'Easy',
        'reward': '75 points',
        'duration': '10 days',
        'participants': 230,
      },
    ];
    
    return availableChallenges.isEmpty
        ? const Center(child: Text('No available challenges'))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: availableChallenges.length,
            itemBuilder: (context, index) {
              final challenge = availableChallenges[index];
              return _buildAvailableChallengeCard(challenge);
            },
          );
  }
  
  Widget _buildCompletedChallengesTab() {
    // Mock data - in a real app, this would come from a service or provider
    final List<Map<String, dynamic>> completedChallenges = [
      {
        'id': 'weekly_active_days_5',
        'title': 'Consistent Driver',
        'description': 'Drive on 5 different days this week',
        'iconName': 'event_available',
        'completedDate': 'Apr 2, 2023',
        'reward': '50 points',
      },
      {
        'id': 'daily_idle_reduction',
        'title': 'Idle Buster',
        'description': 'Keep idling time under 3 minutes for all trips today',
        'iconName': 'timer',
        'completedDate': 'Mar 28, 2023',
        'reward': '25 points',
      },
    ];
    
    return completedChallenges.isEmpty
        ? const Center(child: Text('No completed challenges'))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: completedChallenges.length,
            itemBuilder: (context, index) {
              final challenge = completedChallenges[index];
              return _buildCompletedChallengeCard(challenge);
            },
          );
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