import 'package:flutter/material.dart';
import '../core/constants/route_constants.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/onboarding/welcome_screen.dart';
import '../presentation/screens/onboarding/value_carousel_screen.dart';
import '../presentation/screens/onboarding/account_choice_screen.dart';
import '../presentation/screens/onboarding/connection_setup_screen.dart';
import '../presentation/screens/drive/active_drive_screen.dart';
import '../presentation/screens/drive/trip_summary_screen.dart';

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
          builder: (_) => const ActiveDriveScreen(),
        );
        
      case DriveRoutes.tripSummary:
        final tripId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TripSummaryScreen(tripId: tripId),
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
          builder: (context) => WelcomeScreen(
            onGetStarted: () => Navigator.of(context).pushNamed(OnboardingRoutes.valueCarousel),
          ),
        );
        
      case OnboardingRoutes.valueCarousel:
        return MaterialPageRoute(
          builder: (context) => ValueCarouselScreen(
            onNext: () => Navigator.of(context).pushNamed(OnboardingRoutes.accountChoice),
            onSkip: () => Navigator.of(context).pushNamed(OnboardingRoutes.accountChoice),
          ),
        );
        
      case OnboardingRoutes.accountChoice:
        return MaterialPageRoute(
          builder: (context) => AccountChoiceScreen(
            onContinue: () => Navigator.of(context).pushNamed(OnboardingRoutes.connectionSetup),
          ),
        );
        
      case OnboardingRoutes.connectionSetup:
        final VoidCallback? onComplete = settings.arguments as VoidCallback?;
        return MaterialPageRoute(
          builder: (context) => ConnectionSetupScreen(
            onContinue: onComplete ?? () => Navigator.of(context).pushReplacementNamed(TabRoutes.driveTab),
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