import 'package:flutter/material.dart';
import '../core/constants/route_constants.dart';
import '../core/theme/app_colors.dart';
import '../presentation/screens/drive/drive_screen.dart';
import '../presentation/screens/insights/insights_screen.dart';
import '../presentation/screens/community/community_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';

/// TabNavigator handles tab-based navigation for the application.
/// 
/// This class manages the bottom navigation bar and tab switching.
class TabNavigator extends StatefulWidget {
  /// Optional initial route to determine which tab to show first
  final String? initialRoute;

  /// Creates a tab navigator widget
  const TabNavigator({
    super.key,
    this.initialRoute,
  });

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;
  
  // The list of tab screens
  final List<Widget> _screens = [
    const DriveScreen(),
    const InsightsScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];
  
  // The tab configuration data
  final List<_TabItem> _tabs = [
    _TabItem(
      index: 0,
      label: 'Drive',
      route: TabRoutes.driveTab,
      icon: Icons.directions_car_outlined,
      activeIcon: Icons.directions_car,
    ),
    _TabItem(
      index: 1,
      label: 'Insights',
      route: TabRoutes.insightsTab,
      icon: Icons.insights_outlined,
      activeIcon: Icons.insights,
    ),
    _TabItem(
      index: 2,
      label: 'Community',
      route: TabRoutes.communityTab,
      icon: Icons.people_outline,
      activeIcon: Icons.people,
    ),
    _TabItem(
      index: 3,
      label: 'Profile',
      route: TabRoutes.profileTab,
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Set the initial tab based on the initial route if provided
    if (widget.initialRoute != null) {
      _setInitialTab(widget.initialRoute!);
    }
  }
  
  /// Sets the initial tab based on the provided route
  void _setInitialTab(String route) {
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].route == route) {
        setState(() {
          _currentIndex = i;
        });
        return;
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.neutralGray,
        items: _tabs.map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: tab.label,
        )).toList(),
      ),
    );
  }
}

/// Helper class to store tab item data
class _TabItem {
  final int index;
  final String label;
  final String route;
  final IconData icon;
  final IconData activeIcon;
  
  const _TabItem({
    required this.index,
    required this.label,
    required this.route,
    required this.icon,
    required this.activeIcon,
  });
} 