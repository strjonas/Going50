import 'dart:async';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UserService manages user profiles and authentication
///
/// This service is responsible for:
/// - Creating and managing user profiles
/// - Supporting anonymous users
/// - Handling optional account registration
/// - Managing profile data
class UserService {
  // Dependencies
  final DataStorageManager _dataStorageManager;
  
  // Logging
  final _log = Logger('UserService');
  
  // State
  UserProfile? _currentUser;
  bool _isAnonymous = true;
  final _userProfileStreamController = StreamController<UserProfile?>.broadcast();
  
  // Constants
  static const _userIdKey = 'user_id';
  static const _isAnonymousKey = 'is_anonymous';
  static const _firebaseUserIdKey = 'firebase_user_id';
  
  /// Constructor
  UserService(this._dataStorageManager);
  
  /// Initialize the service
  Future<void> initialize() async {
    _log.info('Initializing UserService');
    await _loadCurrentUser();
  }
  
  /// Get the current user profile
  UserProfile? get currentUser => _currentUser;
  
  /// Is the current user anonymous?
  bool get isAnonymous => _isAnonymous;
  
  /// Stream of user profile updates
  Stream<UserProfile?> get userProfileStream => _userProfileStreamController.stream;
  
  /// Load the current user from storage
  Future<UserProfile?> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      final firebaseUserId = prefs.getString(_firebaseUserIdKey);
      
      // If we have a Firebase user ID, prioritize loading by that
      if (firebaseUserId != null) {
        _log.info('Found Firebase user ID, loading by Firebase ID: $firebaseUserId');
        final firebaseUser = await _dataStorageManager.getUserProfileByFirebaseId(firebaseUserId);
        
        if (firebaseUser != null) {
          _currentUser = firebaseUser;
          _isAnonymous = false;
          _userProfileStreamController.add(firebaseUser);
          _log.info('Loaded Firebase user: ${firebaseUser.id}');
          return firebaseUser;
        } else {
          _log.warning('Firebase user not found in database: $firebaseUserId');
        }
      }
      
      // Check if we have a local user ID
      if (userId == null) {
        _log.info('No user ID found, creating anonymous user');
        return await createAnonymousUser();
      }
      
      // Check if user is anonymous
      _isAnonymous = prefs.getBool(_isAnonymousKey) ?? true;
      
      // Load the user from the database
      final user = await _dataStorageManager.getUserProfileById(userId);
      
      if (user != null) {
        _currentUser = user;
        _userProfileStreamController.add(user);
        _log.info('Loaded user: ${user.id} (${_isAnonymous ? 'anonymous' : 'registered'})');
        return user;
      } else {
        // User not found in database, create new anonymous user
        _log.warning('User not found in database, creating new anonymous user');
        return await createAnonymousUser();
      }
    } catch (e) {
      _log.severe('Error loading current user: $e');
      // In case of error, create an anonymous user
      return await createAnonymousUser();
    }
  }
  
  /// Create an anonymous user
  Future<UserProfile> createAnonymousUser() async {
    try {
      final userId = const Uuid().v4();
      final now = DateTime.now();
      
      // Create user profile object
      final user = UserProfile(
        id: userId,
        name: 'Anonymous User',
        createdAt: now,
        lastUpdatedAt: now,
        isPublic: false,
        allowDataUpload: false,
      );
      
      _log.info('Creating anonymous user with ID: $userId');
      
      // Clear any existing user data in shared preferences first
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_isAnonymousKey);
      
      // Try to save to database with retry logic
      int attempts = 0;
      const maxAttempts = 3;
      bool saveSuccess = false;
      
      while (!saveSuccess && attempts < maxAttempts) {
        attempts++;
        try {
          // Save to database
          await _dataStorageManager.saveUserProfile(
            userId, 
            user.name, 
            user.isPublic, 
            user.allowDataUpload
          );
          
          // Verify user was saved
          final savedUser = await _dataStorageManager.getUserProfileById(userId);
          if (savedUser != null) {
            saveSuccess = true;
            _log.info('Successfully saved anonymous user on attempt $attempts');
          } else {
            _log.warning('Failed to verify user was saved on attempt $attempts');
            await Future.delayed(Duration(milliseconds: 100 * attempts));
          }
        } catch (e) {
          _log.warning('Error saving anonymous user on attempt $attempts: $e');
          await Future.delayed(Duration(milliseconds: 100 * attempts));
        }
      }
      
      if (!saveSuccess) {
        _log.severe('Failed to save anonymous user after $maxAttempts attempts');
        // We'll still continue to set shared preferences and update state
        // so the app can at least function with an in-memory user
      }
      
      // Update shared preferences
      await prefs.setString(_userIdKey, userId);
      await prefs.setBool(_isAnonymousKey, true);
      
      // Update state
      _currentUser = user;
      _isAnonymous = true;
      _userProfileStreamController.add(user);
      
      _log.info('Created anonymous user: $userId');
      return user;
    } catch (e) {
      _log.severe('Error creating anonymous user: $e');
      // Create a fallback in-memory-only user as a last resort
      final userId = const Uuid().v4();
      final user = UserProfile(
        id: userId,
        name: 'Emergency User',
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
        isPublic: false,
        allowDataUpload: false,
      );
      _currentUser = user;
      _isAnonymous = true;
      _userProfileStreamController.add(user);
      return user;
    }
  }
  
  /// Register a new user account
  Future<UserProfile> registerUser({
    required String name,
    required bool isPublic,
    required bool allowDataUpload,
    String? email,
    String? firebaseId,
  }) async {
    // Check if we already have a user
    if (_currentUser == null) {
      await _loadCurrentUser();
    }
    
    // Start with existing ID or generate a new one if needed
    final userId = _currentUser?.id ?? const Uuid().v4();
    final now = DateTime.now();
    
    final user = UserProfile(
      id: userId,
      name: name,
      createdAt: _currentUser?.createdAt ?? now,
      lastUpdatedAt: now,
      isPublic: isPublic,
      allowDataUpload: allowDataUpload,
      email: email,
      firebaseId: firebaseId,
    );
    
    // Save to database
    if (email != null || firebaseId != null) {
      // If we have Firebase details, use the Firebase-specific method
      await _dataStorageManager.saveUserProfileWithFirebase(
        userId, 
        name, 
        isPublic, 
        allowDataUpload,
        email: email,
        firebaseId: firebaseId,
      );
    } else {
      // Otherwise use the standard method
      await _dataStorageManager.saveUserProfile(
        userId, 
        name, 
        isPublic, 
        allowDataUpload
      );
    }
    
    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setBool(_isAnonymousKey, false);
    
    // If we have a Firebase ID, also store it
    if (firebaseId != null) {
      await prefs.setString(_firebaseUserIdKey, firebaseId);
    }
    
    // Update state
    _currentUser = user;
    _isAnonymous = false;
    _userProfileStreamController.add(user);
    
    _log.info('Registered user: $userId${firebaseId != null ? ' with Firebase ID: $firebaseId' : ''}');
    return user;
  }
  
  /// Update user profile
  Future<UserProfile> updateProfile({
    String? name,
    bool? isPublic,
    bool? allowDataUpload,
    String? email,
    String? firebaseId,
  }) async {
    // Ensure we have a current user
    if (_currentUser == null) {
      throw Exception('No current user to update');
    }
    
    final user = UserProfile(
      id: _currentUser!.id,
      name: name ?? _currentUser!.name,
      createdAt: _currentUser!.createdAt,
      lastUpdatedAt: DateTime.now(),
      isPublic: isPublic ?? _currentUser!.isPublic,
      allowDataUpload: allowDataUpload ?? _currentUser!.allowDataUpload,
      preferences: _currentUser!.preferences,
      email: email ?? _currentUser!.email,
      firebaseId: firebaseId ?? _currentUser!.firebaseId,
    );
    
    // Use updateUserProfile instead of saveUserProfile for existing users
    await _dataStorageManager.updateUserProfile(
      user.id, 
      user.name,
      isPublic: user.isPublic,
      allowDataUpload: user.allowDataUpload,
      email: user.email,
      firebaseId: user.firebaseId,
    );
    
    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    
    // If we have a Firebase ID, also store it
    if (firebaseId != null) {
      await prefs.setString(_firebaseUserIdKey, firebaseId);
    }
    
    // Update state
    _currentUser = user;
    _userProfileStreamController.add(user);
    
    _log.info('Updated user profile: ${user.id}');
    return user;
  }
  
  /// Set current user
  /// 
  /// This is used by the AuthenticationService to set the current user
  /// when a user signs in with Firebase.
  Future<void> setCurrentUser(UserProfile userProfile) async {
    try {
      _log.info('Setting current user: ${userProfile.id}');
      
      // Update state
      _currentUser = userProfile;
      _isAnonymous = false;
      
      // Update shared preferences to reflect current user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userProfile.id);
      await prefs.setBool(_isAnonymousKey, false);
      
      // If the user has a Firebase ID, store it
      if (userProfile.firebaseId != null) {
        await prefs.setString(_firebaseUserIdKey, userProfile.firebaseId!);
      }
      
      // Notify listeners
      _userProfileStreamController.add(userProfile);
      
      _log.info('Current user set: ${userProfile.id}');
    } catch (e) {
      _log.severe('Error setting current user: $e');
      rethrow;
    }
  }
  
  /// Sign out the current user
  ///
  /// This doesn't delete the user or data, just resets to anonymous state
  Future<void> signOut() async {
    try {
      _log.info('Signing out user');
      
      // Reset to anonymous
      _isAnonymous = true;
      
      // Remove Firebase user ID if present
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_firebaseUserIdKey);
      await prefs.setBool(_isAnonymousKey, true);
      
      // Keep the local user ID for data continuity
      
      // Notify listeners
      _userProfileStreamController.add(_currentUser);
      
      _log.info('User signed out, reverted to anonymous');
    } catch (e) {
      _log.severe('Error signing out user: $e');
      rethrow;
    }
  }
  
  /// Dispose of resources
  void dispose() {
    _userProfileStreamController.close();
  }
  
  /// Get user metrics for display in profile
  /// 
  /// This method fetches metrics like trip counts, streaks, and other user stats
  /// from the DataStorageManager
  Future<Map<String, dynamic>?> getUserMetrics(String userId) async {
    try {
      _log.info('Getting user metrics for user: $userId');
      
      // Get metrics from data storage manager
      final metrics = await _dataStorageManager.getUserMetrics(userId);
      
      // If metrics don't have a "bestDrivingStreak" field, add a default value
      if (metrics != null && !metrics.containsKey('bestDrivingStreak')) {
        // Default to 0 streak if not found
        metrics['bestDrivingStreak'] = 0;
      }
      
      return metrics;
    } catch (e) {
      _log.severe('Error getting user metrics: $e');
      return {
        'tripCount': 0,
        'fuelSaved': 0.0,
        'co2Reduced': 0.0,
        'bestDrivingStreak': 0,
      };
    }
  }
} 