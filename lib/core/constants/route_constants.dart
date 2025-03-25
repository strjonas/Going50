/// Route constants for the Going50 app.
/// This file contains named routes used throughout the application.
library;

/// Main tab routes
class TabRoutes {
  /// Route for the Drive tab
  static const String driveTab = '/drive';
  
  /// Route for the Insights tab
  static const String insightsTab = '/insights';
  
  /// Route for the Community tab
  static const String communityTab = '/community';
  
  /// Route for the Profile tab
  static const String profileTab = '/profile';
  
  // Prevent instantiation
  TabRoutes._();
}

/// Drive section routes
class DriveRoutes {
  /// Route for the active driving screen
  static const String activeDrive = '/drive/active';
  
  /// Route for the trip summary screen
  static const String tripSummary = '/drive/trip-summary';
  
  // Prevent instantiation
  DriveRoutes._();
}

/// Insights section routes
class InsightsRoutes {
  /// Route for the trip history screen
  static const String tripHistory = '/insights/history';
  
  /// Route for the trip detail screen
  static const String tripDetail = '/insights/trip-detail';
  
  // Prevent instantiation
  InsightsRoutes._();
}

/// Community section routes
class CommunityRoutes {
  /// Route for the leaderboard screen
  static const String leaderboard = '/community/leaderboard';
  
  /// Route for the challenges screen
  static const String challenges = '/community/challenges';
  
  /// Route for the friend profile screen
  static const String friendProfile = '/community/friend-profile';
  
  /// Route for the challenge detail screen
  static const String challengeDetail = '/community/challenge-detail';
  
  // Prevent instantiation
  CommunityRoutes._();
}

/// Profile section routes
class ProfileRoutes {
  /// Route for the settings screen
  static const String settings = '/profile/settings';
  
  /// Route for the privacy settings screen
  static const String privacySettings = '/profile/privacy';
  
  /// Route for the device connection screen
  static const String deviceConnection = '/profile/device-connection';
  
  /// Route for the data management screen
  static const String dataManagement = '/profile/data-management';
  
  // Prevent instantiation
  ProfileRoutes._();
}

/// Onboarding routes
class OnboardingRoutes {
  /// Route for the welcome screen
  static const String welcome = '/onboarding/welcome';
  
  /// Route for the value carousel screen
  static const String valueCarousel = '/onboarding/value-carousel';
  
  /// Route for the account choice screen
  static const String accountChoice = '/onboarding/account-choice';
  
  /// Route for the connection setup screen
  static const String connectionSetup = '/onboarding/connection-setup';
  
  // Prevent instantiation
  OnboardingRoutes._();
} 