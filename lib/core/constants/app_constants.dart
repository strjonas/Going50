/// Application-wide constants for the Going50 app.
/// This file contains various constants used throughout the application.
library;

/// App information constants
class AppInfo {
  /// The name of the application
  static const String appName = 'Going50';
  
  /// The tagline/slogan of the application
  static const String appTagline = 'Drive Smart, Live Green';
  
  /// The current version of the application
  static const String appVersion = '1.0.0';
  
  /// The build number of the application
  static const String appBuildNumber = '1';
  
  // Prevent instantiation
  AppInfo._();
}

/// Default values used throughout the application
class DefaultValues {
  /// Default refresh interval in milliseconds
  static const int defaultRefreshIntervalMs = 500;
  
  /// Default eco-score value
  static const double defaultEcoScore = 50.0;
  
  /// Maximum number of recent trips to show in list
  static const int maxRecentTrips = 5;
  
  // Prevent instantiation
  DefaultValues._();
}

/// Feature flags for enabling/disabling features during development
class FeatureFlags {
  /// Whether OBD functionality is enabled
  static const bool enableObd = true;
  
  /// Whether social features are enabled
  static const bool enableSocialFeatures = true;
  
  /// Whether gamification features are enabled
  static const bool enableGamification = true;
  
  /// Whether background data collection is enabled
  static const bool enableBackgroundCollection = true;
  
  // Prevent instantiation
  FeatureFlags._();
}

/// Timing constants for various operations
class TimingConstants {
  /// Timeout for OBD connection in milliseconds
  static const int obdConnectionTimeoutMs = 10000;
  
  /// Timeout for sensor initialization in milliseconds
  static const int sensorInitTimeoutMs = 5000;
  
  /// Minimum duration of a trip to be recorded, in milliseconds
  static const int minTripDurationMs = 60000; // 1 minute
  
  // Prevent instantiation
  TimingConstants._();
}

/// Common error messages used in the application
class ErrorMessages {
  /// Error message for OBD connection failure
  static const String obdConnectionFailed = 'Could not connect to OBD device';
  
  /// Error message for sensor initialization failure
  static const String sensorInitFailed = 'Failed to initialize sensors';
  
  /// Error message for when location permission is denied
  static const String locationPermissionDenied = 'Location permission required for trip tracking';
  
  // Prevent instantiation
  ErrorMessages._();
} 