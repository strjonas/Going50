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
      
      // Check if we have a user ID
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
    );
    
    // Save to database
    await _dataStorageManager.saveUserProfile(
      userId, 
      name, 
      isPublic, 
      allowDataUpload
    );
    
    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setBool(_isAnonymousKey, false);
    
    // Update state
    _currentUser = user;
    _isAnonymous = false;
    _userProfileStreamController.add(user);
    
    _log.info('Registered user: $userId');
    return user;
  }
  
  /// Update user profile
  Future<UserProfile> updateProfile({
    String? name,
    bool? isPublic,
    bool? allowDataUpload,
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
    );
    
    // Save to database
    await _dataStorageManager.saveUserProfile(
      user.id, 
      user.name, 
      user.isPublic, 
      user.allowDataUpload
    );
    
    // Update state
    _currentUser = user;
    _userProfileStreamController.add(user);
    
    _log.info('Updated user profile: ${user.id}');
    return user;
  }
  
  /// Get a user profile by ID
  Future<UserProfile?> getUserProfile(String userId) async {
    return await _dataStorageManager.getUserProfileById(userId);
  }
  
  /// Dispose of resources
  void dispose() {
    _userProfileStreamController.close();
  }
} 