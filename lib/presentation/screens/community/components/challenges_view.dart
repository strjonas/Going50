import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/core/constants/route_constants.dart';

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

class _ChallengesViewState extends State<ChallengesView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey.shade700,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Available'),
            Tab(text: 'Completed'),
          ],
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
            padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(16),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to challenge detail screen
          Navigator.of(context).pushNamed(
            CommunityRoutes.challengeDetail,
            arguments: challenge['id'],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconData(challenge['iconName']),
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress: ${challenge['progress']}/${challenge['target']}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            challenge['timeRemaining'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${challenge['participants']} participants',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to challenge detail screen
          Navigator.of(context).pushNamed(
            CommunityRoutes.challengeDetail,
            arguments: challenge['id'],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconData(challenge['iconName']),
                      color: Colors.grey.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDetailChip(Icons.star, challenge['difficulty']),
                  const SizedBox(width: 8),
                  _buildDetailChip(Icons.card_giftcard, challenge['reward']),
                  const SizedBox(width: 8),
                  _buildDetailChip(Icons.timer, challenge['duration']),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${challenge['participants']} participants',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Join'),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to challenge detail screen
          Navigator.of(context).pushNamed(
            CommunityRoutes.challengeDetail,
            arguments: challenge['id'],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(challenge['iconName']),
                  color: Colors.grey.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completed on ${challenge['completedDate']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.card_giftcard,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          challenge['reward'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
  
  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
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