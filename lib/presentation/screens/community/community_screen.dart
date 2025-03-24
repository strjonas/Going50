import 'package:flutter/material.dart';

/// CommunityScreen is the main screen for the Community tab.
///
/// This screen provides access to leaderboards, challenges, and friend features.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people,
              size: 64,
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
            Text(
              'Community Tab',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Connect with other eco-drivers, compete in challenges, and earn achievements',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            _buildFeatureCard(
              title: 'Leaderboards',
              description: 'See how you rank against others',
              icon: Icons.leaderboard,
              onTap: () {
                // TODO: Implement leaderboard navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Leaderboards not yet implemented'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              title: 'Challenges',
              description: 'Join challenges to earn rewards',
              icon: Icons.flag,
              onTap: () {
                // TODO: Implement challenges navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Challenges not yet implemented'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              title: 'Friends',
              description: 'Connect with other eco-drivers',
              icon: Icons.group,
              onTap: () {
                // TODO: Implement friends navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Friends feature not yet implemented'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  /// Builds a feature card widget
  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.purple,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
} 