import 'package:flutter/material.dart';
import '../core/constants/route_constants.dart';

/// AppRouter handles route management for the application.
/// 
/// This class provides methods to generate routes and navigate between screens.
class AppRouter {
  /// Generate routes for the application
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Tab routes are handled by the TabNavigator, so we don't need cases for them
      
      // Drive routes
      case DriveRoutes.activeDrive:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Active Drive Screen - To be implemented')),
          ),
        );
        
      case DriveRoutes.tripSummary:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Trip Summary Screen - To be implemented')),
          ),
        );
        
      // Insights routes
      case InsightsRoutes.tripHistory:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Trip History Screen - To be implemented')),
          ),
        );
        
      case InsightsRoutes.tripDetail:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Trip Detail Screen - To be implemented')),
          ),
        );
        
      // Community routes
      case CommunityRoutes.leaderboard:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Leaderboard Screen - To be implemented')),
          ),
        );
        
      case CommunityRoutes.challenges:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Challenges Screen - To be implemented')),
          ),
        );
        
      case CommunityRoutes.friendProfile:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Friend Profile Screen - To be implemented')),
          ),
        );
        
      // Profile routes
      case ProfileRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Settings Screen - To be implemented')),
          ),
        );
        
      case ProfileRoutes.privacySettings:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Privacy Settings Screen - To be implemented')),
          ),
        );
        
      case ProfileRoutes.deviceConnection:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Device Connection Screen - To be implemented')),
          ),
        );
        
      // Onboarding routes
      case OnboardingRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Welcome Screen - To be implemented')),
          ),
        );
        
      case OnboardingRoutes.valueCarousel:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Value Carousel Screen - To be implemented')),
          ),
        );
        
      case OnboardingRoutes.accountChoice:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Account Choice Screen - To be implemented')),
          ),
        );
        
      case OnboardingRoutes.connectionSetup:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Connection Setup Screen - To be implemented')),
          ),
        );
        
      // Default case for unknown routes
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 