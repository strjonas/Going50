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
    
    // Create the trip with the current user ID
    final trip = Trip(
      id: tripId,
      startTime: now,
      isCompleted: false,
      userId: _currentUserId, // Set the user ID to associate trip with current user
    );
    
    await _database.saveTrip(trip);
    _logger.info('Started new trip with ID: $tripId for user: $_currentUserId');
    
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
  
  /// Get friend IDs for a user
  Future<List<String>> getFriendIds(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      final connections = await _database.getSocialConnectionsForUser(userId);
      return connections
          .where((connection) => connection.connectionType == 'friend')
          .map((connection) => connection.connectedUserId)
          .toList();
    } catch (e) {
      _logger.warning('Error retrieving friend IDs: $e');
      return [];
    }
  }
  
  /// Get received friend requests
  Future<List<String>> getReceivedFriendRequests(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getReceivedFriendRequests(userId);
    } catch (e) {
      _logger.warning('Error retrieving received friend requests: $e');
      return [];
    }
  }
  
  /// Get sent friend requests
  Future<List<String>> getSentFriendRequests(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getSentFriendRequests(userId);
    } catch (e) {
      _logger.warning('Error retrieving sent friend requests: $e');
      return [];
    }
  }
  
  /// Send a friend request
  Future<bool> sendFriendRequest(String fromUserId, String toUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Create a unique ID for this request
      final requestId = const Uuid().v4();
      
      // Save the request
      await _database.saveFriendRequest(
        requestId,
        fromUserId,
        toUserId,
        DateTime.now(),
        'pending'
      );
      
      return true;
    } catch (e) {
      _logger.warning('Error sending friend request: $e');
      return false;
    }
  }
  
  /// Accept a friend request
  Future<bool> acceptFriendRequest(String toUserId, String fromUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Update request status
      await _database.updateFriendRequestStatus(fromUserId, toUserId, 'accepted');
      
      // Create social connections in both directions
      final connectionId1 = const Uuid().v4();
      final connectionId2 = const Uuid().v4();
      final now = DateTime.now();
      
      // Create a connection from requester to accepter
      await _database.saveSocialConnection(
        SocialConnection(
          id: connectionId1,
          userId: fromUserId,
          connectedUserId: toUserId,
          connectionType: 'friend',
          connectedSince: now,
          isMutual: true,
        )
      );
      
      // Create a connection from accepter to requester
      await _database.saveSocialConnection(
        SocialConnection(
          id: connectionId2,
          userId: toUserId,
          connectedUserId: fromUserId,
          connectionType: 'friend',
          connectedSince: now,
          isMutual: true,
        )
      );
      
      return true;
    } catch (e) {
      _logger.warning('Error accepting friend request: $e');
      return false;
    }
  }
  
  /// Reject a friend request
  Future<bool> rejectFriendRequest(String toUserId, String fromUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Update request status
      await _database.updateFriendRequestStatus(fromUserId, toUserId, 'rejected');
      return true;
    } catch (e) {
      _logger.warning('Error rejecting friend request: $e');
      return false;
    }
  }
  
  /// Cancel a pending friend request
  Future<bool> cancelFriendRequest(String fromUserId, String toUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Update request status
      await _database.updateFriendRequestStatus(fromUserId, toUserId, 'cancelled');
      return true;
    } catch (e) {
      _logger.warning('Error cancelling friend request: $e');
      return false;
    }
  }
  
  /// Remove a friend connection between two users
  Future<bool> removeFriend(String userId1, String userId2) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Remove connection in both directions
      await _database.removeSocialConnection(userId1, userId2, 'friend');
      await _database.removeSocialConnection(userId2, userId1, 'friend');
      return true;
    } catch (e) {
      _logger.warning('Error removing friend connection: $e');
      return false;
    }
  }
  
  /// Block a user
  Future<bool> blockUser(String userId, String blockedUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Create a block record
      final blockId = const Uuid().v4();
      await _database.saveUserBlock(blockId, userId, blockedUserId, DateTime.now());
      return true;
    } catch (e) {
      _logger.warning('Error blocking user: $e');
      return false;
    }
  }
  
  /// Unblock a user
  Future<bool> unblockUser(String userId, String blockedUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.removeUserBlock(userId, blockedUserId);
      return true;
    } catch (e) {
      _logger.warning('Error unblocking user: $e');
      return false;
    }
  }
  
  /// Check if a user is blocked
  Future<bool> isUserBlocked(String userId, String blockedUserId) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.isUserBlocked(userId, blockedUserId);
    } catch (e) {
      _logger.warning('Error checking if user is blocked: $e');
      return false;
    }
  }
  
  /// Get list of blocked users
  Future<List<String>> getBlockedUsers(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getBlockedUsers(userId);
    } catch (e) {
      _logger.warning('Error getting blocked users: $e');
      return [];
    }
  }
  
  /// Save a leaderboard entry
  Future<bool> saveLeaderboardEntry(LeaderboardEntry entry) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveLeaderboardEntry(entry);
      return true;
    } catch (e) {
      _logger.warning('Error saving leaderboard entry: $e');
      return false;
    }
  }
  
  /// Get leaderboard entries for a specific type and timeframe
  Future<List<LeaderboardEntry>> getLeaderboardEntries(String leaderboardType, String timeframe, 
    {String? regionCode, int limit = 100, int offset = 0}) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getLeaderboardEntries(
        leaderboardType, 
        timeframe, 
        regionCode: regionCode, 
        limit: limit, 
        offset: offset
      );
    } catch (e) {
      _logger.warning('Error retrieving leaderboard entries: $e');
      return [];
    }
  }
  
  /// Get a user's ranking in a leaderboard
  Future<LeaderboardEntry?> getUserLeaderboardEntry(String userId, String leaderboardType, String timeframe, 
    {String? regionCode}) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getUserLeaderboardEntry(
        userId, 
        leaderboardType, 
        timeframe, 
        regionCode: regionCode
      );
    } catch (e) {
      _logger.warning('Error retrieving user leaderboard entry: $e');
      return null;
    }
  }
  
  /// Save shared content
  Future<String?> saveSharedContent(SharedContent content) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _database.saveSharedContent(content);
      return content.id;
    } catch (e) {
      _logger.warning('Error saving shared content: $e');
      return null;
    }
  }
  
  /// Get shared content for a user
  Future<List<SharedContent>> getSharedContentForUser(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.getSharedContentForUser(userId);
    } catch (e) {
      _logger.warning('Error retrieving shared content: $e');
      return [];
    }
  }
  
  /// Search for users by name
  Future<List<UserProfile>> searchUserProfiles(String query) async {
    if (!_isInitialized) await initialize();
    
    try {
      return await _database.searchUserProfiles(query);
    } catch (e) {
      _logger.warning('Error searching user profiles: $e');
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
  
  /// Get metrics for a specific user that aren't covered by PerformanceMetrics
  Future<Map<String, dynamic>?> getUserMetrics(String userId) async {
    try {
      // Ensure we're initialized
      if (!_isInitialized) await initialize();
      
      // Query for metrics like trip count, fuel saved, CO2 reduced, etc.
      final trips = await _database.getAllTrips();
      
      // Filter trips for this user
      final userTrips = trips.where((trip) => 
        trip.isCompleted == true).toList();
      
      // Calculate metrics
      final tripCount = userTrips.length;
      
      // Calculate fuel saved (simplified calculation)
      // Assumes 10% better fuel efficiency compared to average driving
      double fuelSaved = 0.0;
      for (final trip in userTrips) {
        if (trip.fuelUsedL != null && trip.distanceKm != null) {
          // Assuming average car uses 7.5L/100km
          final averageFuelUsed = (trip.distanceKm! * 7.5) / 100;
          final actualFuelUsed = trip.fuelUsedL!;
          fuelSaved += (averageFuelUsed - actualFuelUsed).clamp(0, double.infinity);
        }
      }
      
      // Calculate CO2 reduction (2.31 kg CO2 per liter of fuel)
      final co2Reduced = fuelSaved * 2.31;
      
      // Get consecutive good days (simplified)
      int consecutiveDaysWithGoodScore = 0;
      
      // Return all metrics
      return {
        'tripCount': tripCount,
        'fuelSaved': fuelSaved,
        'co2Reduced': co2Reduced,
        'consecutiveDaysWithGoodScore': consecutiveDaysWithGoodScore,
        // Add more metrics as needed
      };
    } catch (e) {
      _logger.severe('Error getting user metrics: $e');
      return null;
    }
  }
  
  /// Save a badge for a user
  Future<Map<String, dynamic>?> saveBadge(Map<String, dynamic> badge) async {
    try {
      // Ensure we're initialized
      if (!_isInitialized) {
        _logger.info('DataStorageManager not initialized, initializing before saving badge');
        await initialize();
      }
      
      // Extract values from the badge map
      final userId = badge['userId'] as String;
      final badgeType = badge['badgeType'] as String;
      final earnedDate = badge['earnedDate'] as DateTime;
      final level = badge['level'] as int;
      final metadataJson = badge['metadataJson'] as String?;
      
      _logger.info('Saving badge $badgeType level $level for user $userId');
      
      // Verify user exists in database before trying to save badge (to avoid foreign key issues)
      final userExists = await _database.getUserProfileById(userId) != null;
      if (!userExists) {
        _logger.severe('Cannot save badge: User $userId does not exist in database');
        return null;
      }
      
      // Save to database with retry logic
      int attempts = 0;
      const maxAttempts = 3;
      bool saveSuccess = false;
      
      while (!saveSuccess && attempts < maxAttempts) {
        attempts++;
        try {
          _logger.info('Attempting to save badge $badgeType (attempt $attempts)');
          
          await _database.saveBadge(
            userId,
            badgeType,
            earnedDate,
            level,
            metadataJson,
          );
          
          // Verify the badge was saved
          final userBadges = await _database.getUserBadges(userId);
          final badgeExists = userBadges.any((b) => b.badgeType == badgeType);
          
          if (badgeExists) {
            _logger.info('Badge $badgeType successfully saved for user $userId');
            saveSuccess = true;
          } else {
            _logger.warning('Badge $badgeType not found after save attempt');
            await Future.delayed(Duration(milliseconds: 100 * attempts));
          }
        } catch (e) {
          _logger.warning('Error saving badge on attempt $attempts: $e');
          await Future.delayed(Duration(milliseconds: 100 * attempts));
        }
      }
      
      if (!saveSuccess) {
        _logger.severe('Failed to save badge $badgeType after $maxAttempts attempts');
        return null;
      }
      
      // Return the saved badge
      return badge;
    } catch (e) {
      _logger.severe('Error saving badge: $e');
      return null;
    }
  }
  
  /// Get all badges for a user
  Future<List<Map<String, dynamic>>> getUserBadges(String userId) async {
    try {
      // Ensure we're initialized
      if (!_isInitialized) {
        _logger.info('DataStorageManager not initialized, initializing before getting badges');
        await initialize();
      }
      
      _logger.info('Getting badges from database for user $userId');
      
      // Get badges from database
      final badges = await _database.getUserBadges(userId);
      _logger.info('Retrieved ${badges.length} badges from database for user $userId');
      
      // If badges is empty, log it
      if (badges.isEmpty) {
        _logger.info('No badges found in database for user $userId');
      } else {
        // Log all badge types for debugging
        final badgeTypes = badges.map((b) => b.badgeType).toList();
        _logger.info('Badge types for user $userId: ${badgeTypes.join(', ')}');
      }
      
      // Convert to Maps
      final mappedBadges = badges.map((badge) => {
        'userId': badge.userId,
        'badgeType': badge.badgeType,
        'earnedDate': badge.earnedDate,
        'level': badge.level,
        'metadataJson': badge.metadataJson,
      }).toList();
      
      return mappedBadges;
    } catch (e) {
      _logger.severe('Error getting user badges: $e');
      return [];
    }
  }
  
  /// Delete all data for a user
  Future<void> deleteUserData(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      _logger.info('Deleting all data for user: $userId');
      
      // Delete all user-related data from tables - with try/catch for each operation
      // to handle cases where tables might not exist yet
      
      // Core data tables - these should always exist
      try {
        await _database.deleteUserTrips(userId);
        _logger.info('Deleted user trips');
      } catch (e) {
        _logger.warning('Error deleting user trips: $e');
      }
      
      try {
        await _database.deleteUserDrivingEvents(userId);
        _logger.info('Deleted user driving events');
      } catch (e) {
        _logger.warning('Error deleting user driving events: $e');
      }
      
      try {
        await _database.deleteUserPerformanceMetrics(userId);
        _logger.info('Deleted user performance metrics');
      } catch (e) {
        _logger.warning('Error deleting user performance metrics: $e');
      }
      
      try {
        await _database.deleteUserBadges(userId);
        _logger.info('Deleted user badges');
      } catch (e) {
        _logger.warning('Error deleting user badges: $e');
      }
      
      try {
        await _database.deleteUserDataPrivacySettings(userId);
        _logger.info('Deleted user privacy settings');
      } catch (e) {
        _logger.warning('Error deleting user privacy settings: $e');
      }
      
      // Social features - these might not exist yet
      try {
        await _database.deleteUserSocialConnections(userId);
        _logger.info('Deleted user social connections');
      } catch (e) {
        _logger.warning('Error deleting user social connections: $e');
      }
      
      try {
        await _database.deleteUserSocialInteractions(userId);
        _logger.info('Deleted user social interactions');
      } catch (e) {
        _logger.warning('Error deleting user social interactions: $e');
      }
      
      try {
        await _database.deleteUserFriendRequests(userId);
        _logger.info('Deleted user friend requests');
      } catch (e) {
        _logger.warning('Error deleting user friend requests: $e');
      }
      
      try {
        await _database.deleteUserBlocks(userId);
        _logger.info('Deleted user blocks');
      } catch (e) {
        _logger.warning('Error deleting user blocks: $e');
      }
      
      try {
        await _database.deleteUserSharedContent(userId);
        _logger.info('Deleted user shared content');
      } catch (e) {
        _logger.warning('Error deleting user shared content: $e');
      }
      
      // Gamification - these might not exist yet
      try {
        await _database.deleteUserPreferences(userId);
        _logger.info('Deleted user preferences');
      } catch (e) {
        _logger.warning('Error deleting user preferences: $e');
      }
      
      try {
        await _database.deleteUserChallenges(userId);
        _logger.info('Deleted user challenges');
      } catch (e) {
        _logger.warning('Error deleting user challenges: $e');
      }
      
      try {
        await _database.deleteUserStreaks(userId);
        _logger.info('Deleted user streaks');
      } catch (e) {
        _logger.warning('Error deleting user streaks: $e');
      }
      
      try {
        await _database.deleteUserLeaderboardEntries(userId);
        _logger.info('Deleted user leaderboard entries');
      } catch (e) {
        _logger.warning('Error deleting user leaderboard entries: $e');
      }
      
      try {
        await _database.deleteUserExternalIntegrations(userId);
        _logger.info('Deleted user external integrations');
      } catch (e) {
        _logger.warning('Error deleting user external integrations: $e');
      }
      
      // Reset shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('is_anonymous');
      await prefs.remove('allow_cloud_sync');
      await prefs.remove('is_public_profile');
      await prefs.remove('preferences_json');
      
      // Optional: Consider clearing cached files
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final userDir = Directory('${appDir.path}/$userId');
        if (await userDir.exists()) {
          await userDir.delete(recursive: true);
          _logger.info('Deleted user directory: ${userDir.path}');
        }
      } catch (e) {
        _logger.warning('Could not delete user directory: $e');
      }
      
      // Reset internal state
      _currentUserId = null;
      _allowCloudSync = false;
      _isPublicProfile = false;
      
      _logger.info('Successfully deleted all data for user: $userId');
    } catch (e) {
      _logger.severe('Error deleting user data: $e');
      rethrow;
    }
  }
  
  /// Delete basic user data (simplified version of deleteUserData)
  /// This is a more targeted method that only deletes core data tables
  /// with timeout protection to prevent hanging
  Future<void> deleteBasicUserData(String userId) async {
    if (!_isInitialized) await initialize();
    
    try {
      _logger.info('Deleting basic user data for: $userId');
      
      // Use individual futures with timeouts for critical tables
      // to prevent any one operation from hanging the whole process
      
      // Core tables
      await _deleteTableWithTimeout(_database.deleteUserTrips, userId, 'trips');
      await _deleteTableWithTimeout(_database.deleteUserDrivingEvents, userId, 'driving events');
      await _deleteTableWithTimeout(_database.deleteUserPerformanceMetrics, userId, 'performance metrics');
      await _deleteTableWithTimeout(_database.deleteUserBadges, userId, 'badges');
      await _deleteTableWithTimeout(_database.deleteUserDataPrivacySettings, userId, 'privacy settings');
      
      // Reset shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('is_anonymous');
      await prefs.remove('allow_cloud_sync');
      await prefs.remove('is_public_profile');
      await prefs.remove('preferences_json');
      
      // Reset internal state
      _currentUserId = null;
      _allowCloudSync = false;
      _isPublicProfile = false;
      
      _logger.info('Successfully deleted basic user data for: $userId');
    } catch (e) {
      _logger.severe('Error deleting basic user data: $e');
      rethrow;
    }
  }
  
  /// Helper to delete table data with timeout protection
  Future<void> _deleteTableWithTimeout(
    Future<int> Function(String) deleteFunction, 
    String userId, 
    String tableName
  ) async {
    try {
      // Set a timeout for each delete operation to prevent hanging
      final result = await deleteFunction(userId)
          .timeout(const Duration(seconds: 3), onTimeout: () {
        _logger.warning('Timeout deleting $tableName for user $userId');
        return 0; // Return 0 rows deleted on timeout
      });
      
      _logger.info('Deleted $result $tableName records for user $userId');
    } catch (e) {
      // Log but don't rethrow to allow other tables to be processed
      _logger.warning('Error deleting $tableName: $e');
    }
  }
} 