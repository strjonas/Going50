# Going50 App: Refined Architecture Document

## Application Overview

Going50 is an eco-driving application designed to encourage sustainable driving behavior through real-time feedback, gamification, and social features. The app uses either OBD-II adapters or phone sensors to collect driving data, analyze driving patterns, and provide actionable feedback to improve driving efficiency.

## Design Principles

- **Minimalist & Intuitive**: Clean interfaces with focused content and clear visual hierarchies
- **Progressive Disclosure**: Information presented in layers, starting with core functionality
- **Glanceability**: Minimized distraction during driving with highly visible key information
- **Data Visualization**: Complex data presented through intuitive visualizations
- **Social Integration**: Social elements incorporated throughout to leverage normative feedback
- **Privacy-First**: Data collection and privacy controls made transparent and accessible
- **Low-Friction Onboarding**: Immediate value before requiring account creation
- **Offline-First**: Local data processing with optional cloud features

## Architecture Overview

The application follows a clean architecture pattern with clear separation of concerns:

```
going50/
│
├── lib/                          # Application code
│   ├── main.dart                 # Application entry point
│   ├── app.dart                  # MyApp widget, theme setup, initial routing
│   │
│   ├── core/                     # Core utilities and configurations
│   ├── services/                 # Business logic and data operations
│   ├── presentation/             # All UI-related code (screens, widgets, etc.)
│   ├── navigation/               # Routing and navigation structure
│   │
│   ├── behavior_classifier_lib/  # Driving behavior classification
│   ├── core_models/              # Data models
│   ├── data_lib/                 # Data storage and retrieval
│   ├── obd_lib/                  # OBD interface
│   └── sensor_lib/               # Phone sensor interface
│
├── assets/                       # Static assets (images, fonts, etc.)
└── test/                         # Unit and widget tests
```

## Library Interfaces

### OBD Library (`obd_lib`)

```dart
// Main facade class
class ObdService {
  // Constructor
  ObdService({bool isDebugMode = false, bool initLogging = false});
  
  // Core functionality
  Stream<BluetoothDevice> scanForDevices();
  Future<bool> connect(String deviceId);
  Future<void> disconnect();
  
  // Data collection
  Future<void> startContinuousQueries();
  Future<void> stopQueries();
  Future<ObdData?> requestPid(String pid);
  
  // State and configuration
  bool get isConnected;
  bool get isEngineRunning;
  String? get selectedProfileId;
  Map<String, ObdData> get latestData;
  
  // Configuration management
  void setAdapterProfile(String profileId);
  void enableAutomaticProfileDetection();
  List<Map<String, String>> getAvailableProfiles();
  void addMonitoredPid(String pid);
  void removeMonitoredPid(String pid);
  
  // Event listeners
  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);
  
  // Resource management
  void dispose();
}
```

### Sensor Library (`sensor_lib`)

```dart
class SensorService {
  // Constructor
  SensorService({
    SensorConfig? config,
    bool isDebugMode = false,
    bool initLogging = false,
  });
  
  // Core functionality
  Future<void> initialize();
  Future<void> startCollection({int collectionIntervalMs = 500});
  void stopCollection();
  
  // Data access
  Stream<PhoneSensorData> get dataStream;
  Future<PhoneSensorData> getLatestSensorData();
  
  // State
  bool get isCollecting;
  
  // Configuration
  void updateConfig(SensorConfig config);
  
  // Resource management
  void dispose();
}
```

### Behavior Classifier Library (`behavior_classifier_lib`)

```dart
class EcoDrivingManager {
  // Constructor
  EcoDrivingManager({
    List<BehaviorDetector>? detectors,
    int historyWindowSize = 60,
  });
  
  // Core functionality
  void addDataPoint(CombinedDrivingData dataPoint);
  Map<String, BehaviorDetectionResult> analyzeAll();
  double calculateOverallScore();
  
  // Analytics
  Map<String, dynamic> getDetailedAnalysis();
  
  // Reset functionality
  void clearData();
}

// Supporting interface for detection results
class BehaviorDetectionResult {
  final bool detected;
  final double confidence;
  final double? severity;
  final String? message;
  final Map<String, dynamic>? additionalData;
  final int occurrences;
  
  BehaviorDetectionResult({
    required this.detected,
    required this.confidence,
    this.severity,
    this.message,
    this.additionalData,
    this.occurrences = 0,
  });
}
```

### Data Library (`data_lib`)

```dart
class DataStorageManager {
  // Singleton accessor
  factory DataStorageManager() => _instance;
  
  // Initialization
  Future<void> initialize();
  
  // Trip management
  Future<Trip> startNewTrip();
  Future<Trip> endTrip(String tripId, {
    double? distanceKm,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    double? fuelUsedL,
    int? idlingEvents,
    int? aggressiveAccelerationEvents,
    int? hardBrakingEvents,
    int? excessiveSpeedEvents,
    int? stopEvents,
    double? averageRPM,
    int? ecoScore,
  });
  Future<void> saveTripDataPoint(String tripId, CombinedDrivingData dataPoint);
  Future<void> saveDrivingEvent(String tripId, DrivingEvent event);
  Future<List<Trip>> getAllTrips();
  Future<Trip?> getTrip(String tripId);
  Stream<List<Trip>> watchTrips();
  
  // Metrics management
  Future<void> savePerformanceMetrics(DriverPerformanceMetrics metrics);
  
  // User management
  Future<void> updateUserSettings({
    String? name,
    bool? isPublicProfile,
    bool? allowCloudSync,
  });
  
  // Data export
  Future<File> exportTripData(String tripId);
  Future<File> exportAllUserData();
  
  // Privacy management
  Future<void> saveDataPrivacySettings(DataPrivacySettings settings);
  Future<List<DataPrivacySettings>> getDataPrivacySettings();
  Future<DataPrivacySettings?> getDataPrivacySettingForType(String dataType);
  Future<bool> isOperationAllowed(String dataType, String operation);
  Future<bool> checkPrivacyPermission(String dataType, String operation);
  
  // Gamification
  Future<void> saveChallenge(Challenge challenge);
  Future<List<Challenge>> getAllChallenges();
  Future<void> saveUserChallenge(UserChallenge userChallenge);
  Future<List<UserChallenge>> getUserChallenges();
  
  // Social features
  Future<void> saveSocialConnection(SocialConnection connection);
  Future<List<SocialConnection>> getSocialConnections();
  
  // Resource management
  Future<void> dispose();
}
```

## Detailed Architecture

### Core Layer

```
core/
│
├── constants/                    # Application-wide constants
│   ├── app_constants.dart        # General app constants
│   ├── asset_paths.dart          # Paths to assets
│   ├── route_constants.dart      # Named routes
│   └── ui_constants.dart         # UI-related constants
│
├── enums/                        # Application enums
│   ├── trip_status.dart          # Trip status states
│   ├── connection_status.dart    # Connection status states
│   ├── feedback_type.dart        # Types of feedback
│   └── motivation_type.dart      # User motivation categories
│
├── theme/                        # Theming configuration
│   ├── app_theme.dart            # Main theme definition
│   ├── app_colors.dart           # Color palette
│   └── app_text_styles.dart      # Text styles
│
└── utils/                        # Utility functions
    ├── permission_utils.dart     # Permission handling utilities
    ├── formatter_utils.dart      # Data formatting utilities
    ├── driving_utils.dart        # Driving-related calculations
    └── device_utils.dart         # Device capability detection
```

### Services Layer

```
services/
│
├── service_locator.dart          # Dependency injection setup
│
├── driving/                      # Driving-related services
│   ├── driving_service.dart      # Main driving service facade
│   ├── obd_connection_service.dart # OBD connection management
│   ├── data_collection_service.dart # Data collection coordination
│   ├── analytics_service.dart    # Driving analytics
│   ├── feedback_service.dart     # Feedback generation
│   └── trip_service.dart         # Trip management
│
├── user/                         # User-related services
│   ├── user_service.dart         # User profile management
│   ├── preferences_service.dart  # User preferences
│   └── privacy_service.dart      # Privacy settings management
│
├── gamification/                 # Gamification services
│   ├── gamification_service.dart # Main gamification service
│   ├── challenge_service.dart    # Challenge management
│   └── achievement_service.dart  # Achievement tracking
│
├── social/                       # Social features
│   ├── social_service.dart       # Social features facade
│   ├── leaderboard_service.dart  # Leaderboard functionality
│   └── sharing_service.dart      # Content sharing
│
└── background/                   # Background processing
    ├── background_service.dart   # Background service facade
    ├── notification_service.dart # Notification management
    └── tracking_service.dart     # Background tracking
```

### Presentation Layer

```
presentation/
│
├── providers/                    # State management
│   ├── driving_provider.dart     # Driving-related state
│   ├── insights_provider.dart    # Insights and history state
│   ├── user_provider.dart        # User profile state
│   └── social_provider.dart      # Social features state
│
├── screens/                      # Application screens
│   ├── onboarding/               # Onboarding screens
│   │   ├── onboarding_screen.dart      # Main onboarding wrapper
│   │   ├── welcome_screen.dart         # Initial welcome
│   │   └── connection_screen.dart      # OBD connection setup
│   │
│   ├── drive/                    # Drive-related screens
│   │   ├── drive_screen.dart           # Main drive tab
│   │   ├── active_drive_screen.dart    # Active driving
│   │   ├── trip_summary_screen.dart    # Post-trip summary
│   │   └── components/                 # Drive components
│   │
│   ├── insights/                 # Insights screens
│   │   ├── insights_screen.dart        # Main insights tab
│   │   ├── trip_history_screen.dart    # Trip history
│   │   ├── trip_detail_screen.dart     # Trip details
│   │   └── components/                 # Insights components
│   │
│   ├── community/                # Community screens
│   │   ├── community_screen.dart       # Main community tab
│   │   ├── leaderboard_screen.dart     # Leaderboards
│   │   ├── challenges_screen.dart      # Challenges
│   │   └── components/                 # Community components
│   │
│   └── profile/                  # Profile screens
│       ├── profile_screen.dart         # Main profile tab
│       ├── settings_screen.dart        # App settings
│       ├── privacy_screen.dart         # Privacy settings
│       └── components/                 # Profile components
│
└── widgets/                      # Reusable widgets
    ├── common/                   # Common widgets
    │   ├── buttons/                  # Button widgets
    │   ├── cards/                    # Card widgets
    │   ├── indicators/               # Status indicators
    │   └── layout/                   # Layout helpers
    │
    ├── drive/                    # Drive-specific widgets
    ├── insights/                 # Insights-specific widgets
    ├── community/                # Community-specific widgets
    └── profile/                  # Profile-specific widgets
```

### Navigation Layer

```
navigation/
│
├── app_router.dart               # Main router configuration
├── tab_navigator.dart            # Tab-based navigation
└── route_names.dart              # Named routes
```

## Core Integration Patterns

### Driving Flow Integration

The main driving flow integrates multiple libraries to provide eco-driving functionality:

1. **OBD Connection**:
   ```dart
   // In ObdConnectionService
   Future<bool> connectToDevice(String deviceId) async {
     bool connected = await _obdService.connect(deviceId);
     if (connected) {
       await _obdService.startContinuousQueries();
     }
     return connected;
   }
   ```

2. **Sensor Integration**:
   ```dart
   // In DataCollectionService
   Future<bool> startCollection() async {
     await _sensorService.initialize();
     await _sensorService.startCollection();
     _sensorService.dataStream.listen(_processSensorData);
     return true;
   }
   ```

3. **Combined Data Processing**:
   ```dart
   // In DataCollectionService
   void _processSensorData(PhoneSensorData sensorData) async {
     final obdData = await _obdConnectionService.getLatestOBDData();
     
     // Create combined data
     final combinedData = CombinedDrivingData(
       timestamp: sensorData.timestamp,
       obdData: obdData,
       sensorData: sensorData,
       // Additional fields...
     );
     
     // Process data
     _dataStreamController.add(combinedData);
     _ecoDrivingManager.addDataPoint(combinedData);
   }
   ```

4. **Behavior Analysis**:
   ```dart
   // In AnalyticsService
   void addDataPoint(CombinedDrivingData dataPoint) {
     _ecoDrivingManager.addDataPoint(dataPoint);
     _updateScores();
   }
   
   void _updateScores() {
     _overallScore = _ecoDrivingManager.calculateOverallScore();
     _detailedScores = _ecoDrivingManager.getDetailedAnalysis();
     notifyListeners();
   }
   ```

5. **Trip Recording**:
   ```dart
   // In TripService
   Future<Trip> startTrip() async {
     final trip = await _dataStorageManager.startNewTrip();
     _currentTrip = trip;
     return trip;
   }
   
   Future<Trip?> endTrip() async {
     if (_currentTrip == null) return null;
     
     // Calculate trip metrics
     final metrics = _calculateTripMetrics();
     
     // End trip in storage
     final completedTrip = await _dataStorageManager.endTrip(
       _currentTrip!.id,
       distanceKm: metrics.distance,
       averageSpeedKmh: metrics.avgSpeed,
       // Additional fields...
     );
     
     _currentTrip = null;
     return completedTrip;
   }
   ```

### UI Integration Pattern

The UI layer uses providers to access services and manage state:

```dart
// In DrivingProvider
class DrivingProvider extends ChangeNotifier {
  final DrivingService _drivingService;
  final AnalyticsService _analyticsService;
  
  // State
  bool get isCollecting => _drivingService.isCollecting;
  bool get isObdConnected => _drivingService.isObdConnected;
  Trip? get currentTrip => _drivingService.currentTrip;
  double get ecoScore => _analyticsService.overallScore;
  
  // Actions
  Future<bool> startTrip() async {
    final success = await _drivingService.startTrip() != null;
    notifyListeners();
    return success;
  }
  
  Future<bool> endTrip() async {
    final success = await _drivingService.endTrip() != null;
    notifyListeners();
    return success;
  }
  
  // OBD functionality
  Future<bool> connectObd(String deviceId) async {
    final success = await _drivingService.connectToObdDevice(deviceId);
    notifyListeners();
    return success;
  }
  
  // Additional methods...
}
```

### Gamification Integration Pattern

Gamification features integrate with driving data and user actions:

```dart
// In GamificationService
class GamificationService {
  final ChallengeService _challengeService;
  final DataStorageManager _dataStorageManager;
  
  // Challenge management
  Future<List<Challenge>> getActiveChallenges() async {
    final challenges = await _dataStorageManager.getAllChallenges();
    return challenges.where((c) => c.isActive).toList();
  }
  
  // Process trip completion for challenges
  Future<void> processTripCompletion(Trip trip) async {
    final userChallenges = await _dataStorageManager.getUserChallenges();
    
    for (final userChallenge in userChallenges) {
      final challenge = await _challengeService.getChallenge(userChallenge.challengeId);
      
      // Update progress based on challenge type
      int newProgress = userChallenge.progress;
      switch (challenge.metricType) {
        case 'distance':
          newProgress += trip.distanceKm?.round() ?? 0;
          break;
        case 'eco_score':
          // Update based on trip's eco score
          break;
        // Additional metrics...
      }
      
      // Update challenge progress
      await _challengeService.updateChallengeProgress(
        userChallenge.id, 
        newProgress, 
        challenge.targetValue
      );
    }
  }
}
```

### Privacy Integration Pattern

Privacy controls are integrated throughout the app:

```dart
// In PrivacyService
class PrivacyService {
  final DataStorageManager _dataStorageManager;
  
  // Check if an operation is allowed
  Future<bool> canPerformOperation(String dataType, String operation) async {
    return _dataStorageManager.isOperationAllowed(dataType, operation);
  }
  
  // Update privacy settings
  Future<void> updatePrivacySetting(
    String dataType, 
    {bool? allowLocalStorage, bool? allowCloudSync, bool? allowSharing}
  ) async {
    // Get current setting
    final currentSetting = await _dataStorageManager.getDataPrivacySettingForType(dataType);
    
    if (currentSetting != null) {
      // Create updated setting
      final updatedSetting = currentSetting.copyWith(
        allowLocalStorage: allowLocalStorage ?? currentSetting.allowLocalStorage,
        allowCloudSync: allowCloudSync ?? currentSetting.allowCloudSync,
        allowSharing: allowSharing ?? currentSetting.allowSharing,
      );
      
      // Save updated setting
      await _dataStorageManager.saveDataPrivacySettings(updatedSetting);
    }
  }
}
```

## Integration With Existing Codebase

The architecture can be implemented incrementally by:

1. **Using Facade Pattern**: Create service facades that use your existing implementation
2. **Component-by-Component Migration**: Replace components one at a time
3. **Parallel Implementations**: Keep old code working while building new components

Example of adapting your current `DrivingService` to fit the new architecture:

```dart
// New facade that uses your existing implementation
class DrivingServiceFacade implements DrivingService {
  final DrivingServiceManager _legacyService;
  
  DrivingServiceFacade(this._legacyService);
  
  @override
  Future<Trip?> startTrip() => _legacyService.startTrip();
  
  @override
  Future<Trip?> endTrip() => _legacyService.endTrip();
  
  @override
  bool get isCollecting => _legacyService.isCollecting;
  
  // Other methods...
}
```

This approach allows you to gradually migrate to the new architecture while maintaining a working application throughout the process.