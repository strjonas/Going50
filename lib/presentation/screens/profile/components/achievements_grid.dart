import 'package:flutter/material.dart';

/// AchievementsGrid displays a grid of earned achievement badges
class AchievementsGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Using mock badges data until achievement service is implemented
    final badges = _getMockBadges();
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: badges.length > 6 ? 6 : badges.length, // Show max 6 badges or fewer
            itemBuilder: (context, index) {
              if (index < badges.length) {
                final badge = badges[index];
                return _buildBadgeItem(context, badge);
              } else {
                return _buildLockedBadge(context);
              }
            },
          ),
        ),
        
        if (showSeeAllButton && badges.length > 6)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: onSeeAllPressed ?? () {
                // Default action if callback not provided
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Achievements view not yet implemented'),
                  ),
                );
              },
              child: Text(
                'See All (${badges.length})',
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
    final isEarned = badge['earned'] as bool;
    final progress = badge['progress'] as double?;
    
    return Container(
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
            badge['icon'] as IconData,
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
  
  /// Get mock badge data until achievement service is implemented
  List<Map<String, dynamic>> _getMockBadges() {
    return [
      {
        'id': '1',
        'name': 'Smooth Driver',
        'icon': Icons.rowing,
        'earned': true,
        'earnedDate': DateTime.now().subtract(const Duration(days: 5)),
        'description': 'Maintain calm driving for 10 trips',
      },
      {
        'id': '2',
        'name': 'Eco Warrior',
        'icon': Icons.eco,
        'earned': true,
        'earnedDate': DateTime.now().subtract(const Duration(days: 10)),
        'description': 'Achieve 90+ eco-score for 5 consecutive trips',
      },
      {
        'id': '3',
        'name': 'Fuel Saver',
        'icon': Icons.local_gas_station,
        'earned': false,
        'progress': 0.7,
        'description': 'Save 20 liters of fuel through eco-driving',
      },
      {
        'id': '4',
        'name': 'Carbon Reducer',
        'icon': Icons.co2,
        'earned': false,
        'progress': 0.4,
        'description': 'Reduce CO2 emissions by 50kg',
      },
      {
        'id': '5',
        'name': 'Road Veteran',
        'icon': Icons.map,
        'earned': true,
        'earnedDate': DateTime.now().subtract(const Duration(days: 15)),
        'description': 'Complete 50 trips with the app',
      },
      {
        'id': '6',
        'name': 'Speed Master',
        'icon': Icons.speed,
        'earned': false,
        'progress': 0.2,
        'description': 'Maintain optimal speed for 30 minutes continuously',
      },
      {
        'id': '7',
        'name': 'Eco Expert',
        'icon': Icons.auto_graph,
        'earned': false,
        'progress': 0.1,
        'description': 'Achieve an overall eco-score of 95+',
      },
    ];
  }
} 