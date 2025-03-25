import 'package:flutter/material.dart';

import 'package:going50/core/theme/app_colors.dart';
import 'package:going50/presentation/screens/community/components/leaderboard_view.dart';
import 'package:going50/presentation/screens/community/components/challenges_view.dart';
import 'package:going50/presentation/screens/community/components/friends_view.dart';

/// CommunityScreen is the main screen for the Community tab.
///
/// This screen provides access to leaderboards, challenges, and friend features.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
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
    return Scaffold(
      backgroundColor: Colors.white, // Use white background to match screenshot
      appBar: AppBar(
        title: const Text(
          'Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary, // Primary color for AppBar
        elevation: 0, // Remove shadow for a more modern look
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab bar with icons - fixed width for proper alignment
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: _buildIconTab(0, Icons.leaderboard, 'Leaderboard'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: _buildIconTab(1, Icons.emoji_events, 'Challenges'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: _buildIconTab(2, Icons.people, 'Friends'),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Colors.black12),
          
          // Add spacing to match the image
          const SizedBox(height: 12),
          
          // Expanded tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                LeaderboardView(),
                ChallengesView(),
                FriendsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIconTab(int index, IconData icon, String label) {
    final bool isSelected = _tabController.index == index;
    
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 