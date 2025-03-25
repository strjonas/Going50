import 'package:flutter/material.dart';
import 'package:going50/presentation/screens/profile/components/profile_header.dart';
import 'package:going50/presentation/screens/profile/components/achievements_grid.dart';
import 'package:going50/presentation/screens/profile/components/statistics_summary.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // Profile header with user info and eco-score
              const ProfileHeader(),
              
              const SizedBox(height: 32),
              
              // Achievements section
              _buildSectionTitle(context, 'Achievements'),
              const SizedBox(height: 16),
              const AchievementsGrid(),
              
              const SizedBox(height: 32),
              
              // Statistics section
              _buildSectionTitle(context, 'Statistics'),
              const SizedBox(height: 8),
              const StatisticsSummary(),
              
              const SizedBox(height: 32),
              
              // Action buttons
              Center(
                child: _buildActionButton(
                  context,
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
              ),
              
              const SizedBox(height: 16),
              
              Center(
                child: _buildActionButton(
                  context,
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
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Builds a section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Builds an action button
  Widget _buildActionButton(
    BuildContext context,
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