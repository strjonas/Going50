import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/screens/community/components/leaderboard_view.dart';
import 'package:going50/presentation/screens/community/components/challenges_view.dart';
import 'package:going50/presentation/screens/community/components/friends_view.dart';

/// CommunityScreen is the main screen for the Community tab.
///
/// This screen provides access to leaderboards, challenges, and friend features.
/// The screen is organized as a scrollable list of sections rather than tabs
/// to reduce navigation depth and improve user experience.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.displaySmall?.color,
            fontSize: 26, // Increased size to be larger than section headings
          ),
        ),
        backgroundColor: theme.cardTheme.color, // Use card color for consistency
        elevation: 0, // Remove shadow for a more modern look
        centerTitle: false, // Left-aligned title
        actions: [
          // Search icon in the app bar
          IconButton(
            icon: Icon(Icons.search, color: theme.textTheme.bodyLarge?.color),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12), // Add top padding
            
            // Leaderboard Section - Compact version
            _buildLeaderboardSection(),
            
            const SizedBox(height: 16), // Space between sections
            
            // Active Challenges Section - Compact version
            _buildActiveChallengesSection(),
            
            const SizedBox(height: 16), // Space between sections
            
            // Friends Section - Compact version
            _buildFriendsSection(),
            
            // Add bottom padding to ensure content doesn't get cut off
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLeaderboardSection() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 22, // Smaller than parent title, larger than subheadings
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to full leaderboard view with proper back navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Leaderboard'),
                            elevation: 0,
                          ),
                          body: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: LeaderboardView(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary, // Green color like in mockup
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Embed a compact version of LeaderboardView
          SizedBox(
            height: 320, // Fixed height for compact view
            child: const LeaderboardView(isCompactMode: true),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActiveChallengesSection() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Challenges',
                  style: TextStyle(
                    fontSize: 22, // Smaller than parent title, larger than subheadings
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to full challenges view with proper back navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Challenges'),
                            elevation: 0,
                          ),
                          body: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: ChallengesView(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View All', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary, // Green color like in mockup
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Embed a compact version of ChallengesView with increased height
          SizedBox(
            height: 320, // Adjusted height for compact view
            child: const ChallengesView(isCompactMode: true),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFriendsSection() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Friends',
                  style: TextStyle(
                    fontSize: 22, // Smaller than parent title, larger than subheadings
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Show add friends dialog
                    _showAddFriendsDialog(context);
                  },
                  child: Text(
                    'Add Friends',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary, // Green color like in mockup
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Embed a compact version of FriendsView
          SizedBox(
            height: 320, // Fixed height for compact view
            child: const FriendsView(isCompactMode: true),
          ),
        ],
      ),
    );
  }
  
  // Keep the existing dialog logic for adding friends
  void _showAddFriendsDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Friends',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect with other eco-drivers to compare your performance and compete in challenges together.',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor ?? 
                           (theme.brightness == Brightness.dark ? 
                            AppColors.darkSurface : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or email',
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.iconTheme.color,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Suggested Friends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSuggestedFriendTile(context, 'Riley Johnson', 'Based on your location', 4, 88),
                      const SizedBox(height: 12),
                      _buildSuggestedFriendTile(context, 'Morgan Smith', 'Similar driving patterns', 2, 92),
                      const SizedBox(height: 12),
                      _buildSuggestedFriendTile(context, 'Casey Williams', 'Completed same challenges', 1, 79),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSuggestedFriendTile(BuildContext context, String name, String reason, int mutualFriends, int ecoScore) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? 
                     AppColors.darkSurface : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Friend info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 12,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$mutualFriends mutual',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.eco_outlined,
                      size: 12,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Score: $ecoScore',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Add button
          ElevatedButton(
            onPressed: () {
              // Add friend functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Friend request sent to $name'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(40, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
} 