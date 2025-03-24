import 'package:flutter/material.dart';

/// ProfileScreen is the main screen for the Profile tab.
///
/// This screen displays user achievements and provides access to settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              _buildProfileHeader(),
              const SizedBox(height: 32),
              _buildSectionTitle('Achievements'),
              const SizedBox(height: 16),
              _buildAchievementGrid(),
              const SizedBox(height: 32),
              _buildSectionTitle('Statistics'),
              const SizedBox(height: 16),
              _buildStatisticItem('Total Trips', '0'),
              _buildStatisticItem('Distance Driven', '0 km'),
              _buildStatisticItem('Fuel Saved', '0 L'),
              _buildStatisticItem('CO₂ Reduced', '0 kg'),
              const SizedBox(height: 32),
              _buildActionButton(
                'Settings',
                Icons.settings,
                () {
                  // TODO: Implement settings navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings not yet implemented'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                'Help & Support',
                Icons.help_outline,
                () {
                  // TODO: Implement help & support
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & Support not yet implemented'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds the profile header with avatar and user info
  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Anonymous User',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.eco,
                size: 16,
                color: Colors.teal,
              ),
              SizedBox(width: 4),
              Text(
                'Eco-Driving Beginner',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Builds a section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  /// Builds a grid of achievement badges
  Widget _buildAchievementGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          // Placeholder for achievement badges
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
        },
      ),
    );
  }
  
  /// Builds a statistic item
  Widget _buildStatisticItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Builds an action button
  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 280,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
} 