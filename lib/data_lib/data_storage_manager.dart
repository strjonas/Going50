import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';

// Core models
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/core_models/driver_performance_metrics.dart';
import 'package:going50/core_models/driving_event.dart';
import 'package:going50/core_models/data_privacy_settings.dart';
import 'package:going50/core_models/social_models.dart';
import 'package:going50/core_models/gamification_models.dart';
import 'package:going50/core_models/user_profile.dart';

// Local imports
import 'package:going50/data_lib/database_service.dart';

/// DataStorageManager handles all data persistence operations for the application.
/// 
/// It serves as a facade over the local database, shared preferences, and 
/// (optionally) cloud storage services. It orchestrates data flow between these
/// storage systems based on user preferences and data privacy settings.
class DataStorageManager {
  final Logger _logger = Logger('DataStorageManager');
  final AppDatabase _database;
  final Uuid _uuid = const Uuid();
  
  // Singleton pattern
  static final DataStorageManager _instance = DataStorageManager._internal();
  factory DataStorageManager() => _instance;
  
  // User profile state
  String? _currentUserId;
  bool _isInitialized = false;
  
  // Settings that control data synchronization
  bool _allowCloudSync = false;
  bool _isPublicProfile = false;
  
  // Added to prevent multiple concurrent initialization
  static Future<void>? _initializationFuture;
  
  DataStorageManager._internal() : _database = AppDatabase();
  
  /// Initialize the storage manager and ensure user profile exists
  Future<void> initialize() async {
    // If already initialized, return immediately
    if (_isInitialized) return;
    
    // If initialization is in progress, wait for it to complete
    if (_initializationFuture != null) {
      await _initializationFuture;
      return;
    }
    
    // Create a new initialization future
    _initializationFuture = _doInitialize();
    
    // Wait for initialization to complete
    await _initializationFuture;
    
    // Reset the initialization future
    _initializationFuture = null;
  }
  
  /// The actual initialization function
  Future<void> _doInitialize() async {
    try {
      _logger.info('Starting DataStorageManager initialization');
      
      // Ensure we have a user profile
      await _loadOrCreateUserProfile();
      
      // Verify user was saved by checking again
      final userProfile = await _database.getUserProfileById(_currentUserId!);
      if (userProfile == null) {
        throw Exception('Failed to create or verify user profile after attempts');
      }
      
      // Add a small delay to ensure user profile is saved to database
      await Future.delayed(Duration(milliseconds: 200));
      
      // Initialize default privacy settings
      await _ensureDefaultPrivacySettings();
      
      _isInitialized = true;
      _logger.info('DataStorageManager initialized successfully');
    } catch (e) {
      _logger.severe('Failed to initialize DataStorageManager: $e');
      // Reset initialization status so it can be attempted again
      _isInitialized = false;
      rethrow;
    }
  }
  
  /// Load existing user profile or create a new one if none exists
  Future<void> _loadOrCreateUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('user_id');
      
      // If no user ID exists, create a new user profile
      if (_currentUserId == null) {
        _currentUserId = _uuid.v4();
        await prefs.setString('user_id', _currentUserId!);
        
        _logger.info('Generated new user ID: $_currentUserId, creating profile');
        
        // Create default user profile in database with retry logic
        int attempts = 0;
        const maxAttempts = 3;
        UserProfile? userProfile;
        
        while (userProfile == null && attempts < maxAttempts) {
          attempts++;
          _logger.info('Attempting to create user profile (attempt $attempts)');
          
          userProfile = await saveUserProfile(
            _currentUserId!, 
            'Default User', 
            false, // isPublic 
            false, // allowDataUpload
          );
          
          if (userProfile == null) {
            _logger.warning('Failed to create user profile on attempt $attempts');
            await Future.delayed(Duration(milliseconds: 100 * attempts));
          }
        }
        
        if (userProfile == null) {
          throw Exception('Failed to create new user profile after $maxAttempts attempts');
        }
        
        _logger.info('Created new user profile with ID: $_currentUserId');
      } else {
        _logger.info('Found existing user ID in preferences: $_currentUserId');
        
        // Verify the user exists in the database
        final existingUser = await _database.getUserProfileById(_currentUserId!);
        
        if (existingUser == null) {
          _logger.warning('User ID exists in preferences but not in database. Recreating user profile.');
          
          // Create user profile in database with retry logic
          int attempts = 0;
          const maxAttempts = 3;
          UserProfile? userProfile;
          
          while (userProfile == null && attempts < maxAttempts) {
            attempts++;
            _logger.info('Attempting to recreate missing user profile (attempt $attempts)');
            
            userProfile = await saveUserProfile(
              _currentUserId!, 
              'Default User', 
              false, // isPublic 
              false, // allowDataUpload
            );
            
            if (userProfile == null) {
              _logger.warning('Failed to recreate user profile on attempt $attempts');
              await Future.delayed(Duration(milliseconds: 100 * attempts));
            }
          }
          
          if (userProfile == null) {
            throw Exception('Failed to recreate missing user profile after $maxAttempts attempts');
          }
          
          _logger.info('Recreated user profile with ID: $_currentUserId');
        } else {
          _logger.info('Loaded existing user profile with ID: $_currentUserId');
        }
      }
      
      // Load sync preferences
      _allowCloudSync = prefs.getBool('allow_cloud_sync') ?? false;
      _isPublicProfile = prefs.getBool('is_public_profile') ?? false;
      
    } catch (e) {
      _logger.severe('Error loading user profile: $e');
      rethrow;
    }
  }
  
  /// Ensure default privacy settings exist for the user
  Future<void> _ensureDefaultPrivacySettings() async {
    if (_currentUserId == null) return;
    
    try {
      // First verify the user exists in the database to avoid foreign key issues
      final userProfile = await _database.getUserProfileById(_currentUserId!);
      if (userProfile == null) {
        _logger.warning('Cannot create privacy settings: User $_currentUserId does not exist in database');
        return;
      }
      
      final settings = await _database.getDataPrivacySettingsForUser(_currentUserId!);
      
      // If no settings exist, create default ones
      if (settings.isEmpty) {
        _logger.info('No privacy settings found for user $_currentUserId, creating defaults');
        
        final dataTypes = ['trips', 'location', 'driving_events', 'performance_metrics'];
        int successCount = 0;
        
        for (final dataType in dataTypes) {
          try {
            final settingId = _uuid.v4();
            _logger.info('Creating privacy setting for $dataType with ID $settingId');
            
            await _database.saveDataPrivacySettings(
              DataPrivacySettings(
                id: settingId, 
                userId: _currentUserId!, 
                dataType: dataType,
              ),
            );
            
            // Verify the setting was saved
            final updatedSettings = await _database.getDataPrivacySettingsForUser(_currentUserId!);
            if (updatedSettings.any((s) => s.dataType == dataType)) {
              successCount++;
              _logger.info('Privacy setting for $dataType created successfully');
            } else {
              _logger.warning('Failed to verify privacy setting for $dataType was created');
            }
          } catch (e) {
            _logger.warning('Error creating privacy setting for $dataType: $e');
          }
        }
        
        _logger.info('Created $successCount/${dataTypes.length} default privacy settings for user $_currentUserId');
      } else {
        _logger.info('Found ${settings.length} existing privacy settings for user $_currentUserId');
      }
    } catch (e) {
      _logger.warning('Error ensuring default privacy settings: $e');
      // Don't rethrow to avoid crashing the app initialization
    }
  }
  
  /// Start a new trip recording
  Future<Trip> startNewTrip() async {
    if (!_isInitialized) await initialize();
    
    final now = DateTime.now();
    final tripId = _uuid.v4();
    
    final trip = Trip(
      id: tripId,
      startTime: now,
      isCompleted: false,
    );
    
    await _database.saveTrip(trip);
    _logger.info('Started new trip with ID: $tripId');
    
    return trip;
  }
  
  /// End an ongoing trip
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
  }) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Get the existing trip
      final trips = await _database.getAllTrips();
      final existingTrip = trips.firstWhere((t) => t.id == tripId);
      
      // Update in the database directly
      await _database.updateTripWithEndDetails(
        tripId,
        distanceKm: distanceKm,
        averageSpeedKmh: averageSpeedKmh,
        maxSpeedKmh: maxSpeedKmh,
        fuelUsedL: fuelUsedL,
        idlingEvents: idlingEvents,
        aggressiveAccelerationEvents: aggressiveAccelerationEvents,
        hardBrakingEvents: hardBrakingEvents,
        excessiveSpeedEvents: excessiveSpeedEvents,
        stopEvents: stopEvents,
        averageRPM: averageRPM,
        ecoScore: ecoScore,
      );
      
      // Create the updated trip object to return
      final updatedTrip = existingTrip.copyWith(
        endTime: DateTime.now(),
        distanceKm: distanceKm,
        averageSpeedKmh: averageSpeedKmh,
        maxSpeedKmh: maxSpeedKmh,
        fuelUsedL: fuelUsedL,
        idlingEvents: idlingEvents,
        aggressiveAccelerationEvents: aggressiveAccelerationEvents,
        hardBrakingEvents: hardBrakingEvents,
        excessiveSpeedEvents: excessiveSpeedEvents,
        stopEvents: stopEvents,
        averageRPM: averageRPM,
        isCompleted: true,
      );
      
      _logger.info('Ended trip with ID: $tripId');
      
      // If cloud sync is enabled, sync this trip data
      if (_allowCloudSync) {
        _syncTripToCloud(updatedTrip);
      }
      
      return updatedTrip;
    } catch (e) {
      _logger.severe('Error ending trip $tripId: $e');
      rethrow;
    }
  }
  
  /// Save a data point during a trip
  Future<void> saveTripDataPoint(String tripId, CombinedDrivingData dataPoint) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveTripDataPoint(tripId, dataPoint);
    } catch (e) {
      _logger.warning('Error saving trip data point: $e');
    }
  }
  
  /// Save a driving event during a trip
  Future<void> saveDrivingEvent(String tripId, DrivingEvent event) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveDrivingEvent(tripId, event);
    } catch (e) {
      _logger.warning('Error saving driving event: $e');
    }
  }
  
  /// Save driver performance metrics
  Future<void> savePerformanceMetrics(DriverPerformanceMetrics metrics) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.savePerformanceMetrics(metrics, _currentUserId!);
      
      // Sync metrics to cloud if enabled
      if (_allowCloudSync && _isPublicProfile) {
        _syncMetricsToCloud(metrics);
      }
    } catch (e) {
      _logger.warning('Error saving performance metrics: $e');
    }
  }
  
  /// Get all trips for the current user
  Future<List<Trip>> getAllTrips() async {
    if (!_isInitialized) await initialize();
    return _database.getAllTrips();
  }
  
  /// Stream of trips that updates in real-time
  Stream<List<Trip>> watchTrips() {
    return _database.watchAllTrips();
  }
  
  /// Update user profile settings
  Future<void> updateUserSettings({
    String? name,
    bool? isPublicProfile,
    bool? allowCloudSync,
  }) async {
    if (!_isInitialized) await initialize();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Update cloud sync preference
      if (allowCloudSync != null) {
        _allowCloudSync = allowCloudSync;
        await prefs.setBool('allow_cloud_sync', allowCloudSync);
      }
      
      // Update public profile preference
      if (isPublicProfile != null) {
        _isPublicProfile = isPublicProfile;
        await prefs.setBool('is_public_profile', isPublicProfile);
      }
      
      // Update user profile in database
      await _database.saveUserProfile(
        _currentUserId!, 
        name ?? 'Default User', 
        _isPublicProfile, 
        _allowCloudSync,
      );
      
      _logger.info('Updated user settings: public=$_isPublicProfile, sync=$_allowCloudSync');
    } catch (e) {
      _logger.severe('Error updating user settings: $e');
      rethrow;
    }
  }
  
  /// Get a user profile by ID
  Future<UserProfile?> getUserProfileById(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getUserProfileById(userId);
    } catch (e) {
      _logger.warning('Error retrieving user profile for ID $userId: $e');
      return null;
    }
  }
  
  /// Save a user profile with the given properties
  Future<UserProfile?> saveUserProfile(String userId, String name, bool isPublic, bool allowDataUpload) async {
    // Don't call initialize here to avoid recursive initialization
    
    try {
      _logger.info('Attempting to save user profile: $userId');
      
      // Add retry logic to ensure the profile is saved
      UserProfile? savedUser;
      int attempts = 0;
      const maxAttempts = 3;
      
      while (savedUser == null && attempts < maxAttempts) {
        attempts++;
        
        // Save the user profile
        await _database.saveUserProfile(userId, name, isPublic, allowDataUpload);
        
        // Verify the user was saved by retrieving it
        savedUser = await _database.getUserProfileById(userId);
        
        if (savedUser != null) {
          _logger.info('User profile saved successfully: $userId (attempt $attempts)');
        } else {
          _logger.warning('User profile not saved on attempt $attempts, retrying...');
          // Small delay before retrying
          await Future.delayed(Duration(milliseconds: 50 * attempts));
        }
      }
      
      if (savedUser == null) {
        _logger.severe('Failed to save user profile after $maxAttempts attempts: $userId');
        return null;
      }
      
      // Update local state
      if (userId == _currentUserId) {
        _isPublicProfile = isPublic;
        
        // Update shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_public_profile', isPublic);
      }
      
      return savedUser;
    } catch (e) {
      _logger.severe('Error saving user profile: $e');
      return null;
    }
  }
  
  /// Export trip data to a JSON file
  Future<File> exportTripData(String tripId) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Get the trip
      final trips = await _database.getAllTrips();
      final trip = trips.firstWhere((t) => t.id == tripId);
      
      // Create a JSON representation
      final tripJson = trip.toJson();
      
      // Create a file in the documents directory
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'trip_${tripId.substring(0, 8)}_${trip.startTime.toIso8601String().substring(0, 10)}.json';
      final file = File('${dir.path}/$fileName');
      
      // Write the JSON to the file
      await file.writeAsString(jsonEncode(tripJson));
      
      _logger.info('Exported trip data to file: $fileName');
      return file;
    } catch (e) {
      _logger.severe('Error exporting trip data: $e');
      rethrow;
    }
  }
  
  /// Export all user data (for backup, data portability, etc.)
  Future<File> exportAllUserData() async {
    if (!_isInitialized) await initialize();
    
    try {
      // Get all trips
      final trips = await _database.getAllTrips();
      
      // Create a JSON representation
      final dataJson = {
        'userId': _currentUserId,
        'exportDate': DateTime.now().toIso8601String(),
        'trips': trips.map((t) => t.toJson()).toList(),
      };
      
      // Create a file in the documents directory
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'going50_data_export_${DateTime.now().toIso8601String().substring(0, 10)}.json';
      final file = File('${dir.path}/$fileName');
      
      // Write the JSON to the file
      await file.writeAsString(jsonEncode(dataJson));
      
      _logger.info('Exported all user data to file: $fileName');
      return file;
    } catch (e) {
      _logger.severe('Error exporting all user data: $e');
      rethrow;
    }
  }
  
  /// Sync trip data to cloud (placeholder for cloud implementation)
  void _syncTripToCloud(Trip trip) {
    // This would be implemented when cloud services are integrated
    _logger.info('Syncing trip ${trip.id} to cloud (not implemented)');
  }
  
  /// Sync metrics to cloud (placeholder for cloud implementation)
  void _syncMetricsToCloud(DriverPerformanceMetrics metrics) {
    // This would be implemented when cloud services are integrated
    _logger.info('Syncing performance metrics to cloud (not implemented)');
  }
  
  /// Close the database when the app is shutting down
  Future<void> dispose() async {
    await _database.close();
    _logger.info('DataStorageManager disposed');
  }
  
  /// Get a specific trip by ID
  Future<Trip?> getTrip(String tripId) async {
    if (!_isInitialized) await initialize();
    
    try {
      final trips = await _database.getAllTrips();
      return trips.firstWhere((t) => t.id == tripId);
    } catch (e) {
      _logger.warning('Trip not found with ID: $tripId');
      return null;
    }
  }
  
  /// Save data privacy settings
  Future<void> saveDataPrivacySettings(DataPrivacySettings settings) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveDataPrivacySettings(settings);
      _logger.info('Saved data privacy settings for type: ${settings.dataType}');
    } catch (e) {
      _logger.warning('Error saving data privacy settings: $e');
      rethrow;
    }
  }
  
  /// Get data privacy settings for the current user
  Future<List<DataPrivacySettings>> getDataPrivacySettings() async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getDataPrivacySettingsForUser(_currentUserId!);
    } catch (e) {
      _logger.warning('Error retrieving data privacy settings: $e');
      rethrow;
    }
  }
  
  /// Get data privacy setting for a specific data type
  Future<DataPrivacySettings?> getDataPrivacySettingForType(String dataType) async {
    if (!_isInitialized) await initialize();
    
    try {
      final settings = await _database.getDataPrivacySettingsForUser(_currentUserId!);
      return settings.firstWhere(
        (s) => s.dataType == dataType,
        orElse: () => DataPrivacySettings(
          id: _uuid.v4(),
          userId: _currentUserId!,
          dataType: dataType,
        ),
      );
    } catch (e) {
      _logger.warning('Error retrieving data privacy setting for type $dataType: $e');
      return null;
    }
  }
  
  /// Check if a specific operation is allowed for a data type
  Future<bool> isOperationAllowed(String dataType, String operation) async {
    if (!_isInitialized) await initialize();
    
    try {
      final setting = await getDataPrivacySettingForType(dataType);
      if (setting == null) return false;
      
      switch (operation) {
        case 'local_storage':
          return setting.allowLocalStorage;
        case 'cloud_sync':
          return setting.allowCloudSync;
        case 'sharing':
          return setting.allowSharing;
        case 'analytics':
          return setting.allowAnonymizedAnalytics;
        default:
          return false;
      }
    } catch (e) {
      _logger.warning('Error checking operation permission: $e');
      return false;
    }
  }
  
  /// Save a challenge
  Future<void> saveChallenge(Challenge challenge) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveChallenge(challenge);
      _logger.info('Saved challenge: ${challenge.title}');
    } catch (e) {
      _logger.warning('Error saving challenge: $e');
      rethrow;
    }
  }
  
  /// Get all available challenges
  Future<List<Challenge>> getAllChallenges() async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getAllChallenges();
    } catch (e) {
      _logger.warning('Error retrieving challenges: $e');
      return [];
    }
  }
  
  /// Save user's progress on a challenge
  Future<void> saveUserChallenge(UserChallenge userChallenge) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveUserChallenge(userChallenge);
      _logger.info('Updated user challenge progress: ${userChallenge.challengeId}');
    } catch (e) {
      _logger.warning('Error saving user challenge: $e');
      rethrow;
    }
  }
  
  /// Get all challenges for the current user
  Future<List<UserChallenge>> getUserChallenges() async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getUserChallengesForUser(_currentUserId!);
    } catch (e) {
      _logger.warning('Error retrieving user challenges: $e');
      return [];
    }
  }
  
  /// Save a social connection
  Future<void> saveSocialConnection(SocialConnection connection) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveSocialConnection(connection);
      _logger.info('Saved social connection to user: ${connection.connectedUserId}');
    } catch (e) {
      _logger.warning('Error saving social connection: $e');
      rethrow;
    }
  }
  
  /// Get all social connections for the current user
  Future<List<SocialConnection>> getSocialConnections() async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getSocialConnectionsForUser(_currentUserId!);
    } catch (e) {
      _logger.warning('Error retrieving social connections: $e');
      return [];
    }
  }
  
  /// Check if an operation is allowed based on user's privacy settings
  Future<bool> checkPrivacyPermission(String dataType, String operation) async {
    if (!_isInitialized) await initialize();
    
    try {
      // For data privacy-aware operations:
      // 1. Check if the operation is allowed for this data type
      final isAllowed = await isOperationAllowed(dataType, operation);
      
      // 2. If not allowed, log and return false
      if (!isAllowed) {
        _logger.info('Operation $operation not allowed for data type $dataType due to privacy settings');
        return false;
      }
      
      return true;
    } catch (e) {
      _logger.warning('Error checking privacy permission: $e');
      return false;
    }
  }
} 