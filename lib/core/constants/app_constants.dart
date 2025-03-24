/// Application-wide constants for the Going50 app.
///
/// This file contains various constants used throughout the application.

// App information
class AppInfo {
  static const String appName = 'Going50';
  static const String appTagline = 'Drive Smart, Live Green';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Prevent instantiation
  AppInfo._();
}

// Default values
class DefaultValues {
  static const int defaultRefreshIntervalMs = 500;
  static const double defaultEcoScore = 50.0;
  static const int maxRecentTrips = 5;
  
  // Prevent instantiation
  DefaultValues._();
}

// Feature flags for enabling/disabling features during development
class FeatureFlags {
  static const bool enableObd = true;
  static const bool enableSocialFeatures = true;
  static const bool enableGamification = true;
  static const bool enableBackgroundCollection = true;
  
  // Prevent instantiation
  FeatureFlags._();
}

// Timing constants
class TimingConstants {
  static const int obdConnectionTimeoutMs = 10000;
  static const int sensorInitTimeoutMs = 5000;
  static const int minTripDurationMs = 60000; // 1 minute
  
  // Prevent instantiation
  TimingConstants._();
}

// Error messages
class ErrorMessages {
  static const String obdConnectionFailed = 'Could not connect to OBD device';
  static const String sensorInitFailed = 'Failed to initialize sensors';
  static const String locationPermissionDenied = 'Location permission required for trip tracking';
  
  // Prevent instantiation
  ErrorMessages._();
} 