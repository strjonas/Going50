import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:going50/data_lib/data_storage_manager.dart';

/// PreferencesService manages user preferences
///
/// This service is responsible for:
/// - Storing and retrieving user preferences
/// - Providing default preferences
/// - Broadcasting preference changes
/// - Managing preference persistence
class PreferencesService {
  // Dependencies
  final DataStorageManager _dataStorageManager;
  
  // Logging
  final _log = Logger('PreferencesService');
  
  // State
  final Map<String, Map<String, dynamic>> _preferences = {};
  String? _currentUserId;
  final _preferencesStreamController = StreamController<Map<String, Map<String, dynamic>>>.broadcast();
  
  // Default preferences by category
  static final Map<String, Map<String, dynamic>> _defaultPreferences = {
    'notifications': {
      'trip_summary': true,
      'achievements': true,
      'eco_tips': true,
      'social': false,
      'background_collection': true,
    },
    'privacy': {
      'share_trip_data': false,
      'share_achievements': false,
      'allow_leaderboard': false,
      'collect_location': true,
    },
    'display': {
      'dark_mode': 'system', // 'light', 'dark', 'system'
      'units': 'metric', // 'metric', 'imperial'
      'glanceable_mode': true,
      'show_speed_gauge': true,
    },
    'driving': {
      'auto_start_trip': false,
      'auto_end_trip': true,
      'audio_feedback': true,
      'feedback_style': 'balanced', // 'gentle', 'balanced', 'direct'
      'focus_mode': false,
    },
    'feedback': {
      'acceleration_sensitivity': 'medium', // 'low', 'medium', 'high'
      'braking_sensitivity': 'medium', // 'low', 'medium', 'high'
      'speeding_threshold': 10, // km/h over limit
      'idling_threshold': 30, // seconds
    },
    'connection': {
      'preferred_obd_device_id': null,
      'connection_mode': 'auto', // 'auto', 'obd_only', 'phone_only'
      'auto_reconnect': true,
      'scan_on_startup': true,
    },
  };
  
  /// Constructor
  PreferencesService(this._dataStorageManager);
  
  /// Initialize the service
  Future<void> initialize(String userId) async {
    _log.info('Initializing PreferencesService for user: $userId');
    _currentUserId = userId;
    await _loadPreferences(userId);
  }
  
  /// Load preferences from storage
  Future<void> _loadPreferences(String userId) async {
    try {
      final userProfile = await _dataStorageManager.getUserProfileById(userId);
      
      if (userProfile != null && userProfile.preferences != null) {
        // Load from user profile if it has preferences
        _log.info('Loading preferences from user profile');
        
        final userPrefs = userProfile.preferences!;
        
        // Merge with default preferences to ensure all keys exist
        for (final category in _defaultPreferences.keys) {
          final defaultCategoryPrefs = _defaultPreferences[category]!;
          final userCategoryPrefs = userPrefs[category] as Map<String, dynamic>? ?? {};
          
          // Create category if it doesn't exist
          if (!_preferences.containsKey(category)) {
            _preferences[category] = {};
          }
          
          // Add all default preferences
          for (final key in defaultCategoryPrefs.keys) {
            _preferences[category]![key] = userCategoryPrefs[key] ?? defaultCategoryPrefs[key];
          }
        }
      } else {
        // Use default preferences
        _log.info('Using default preferences for user: $userId');
        _resetToDefaults();
      }
      
      // Notify listeners
      _preferencesStreamController.add(_preferences);
    } catch (e) {
      _log.severe('Error loading preferences: $e');
      _resetToDefaults();
      _preferencesStreamController.add(_preferences);
    }
  }
  
  /// Reset all preferences to defaults
  void _resetToDefaults() {
    _preferences.clear();
    
    // Deep copy default preferences
    for (final category in _defaultPreferences.keys) {
      _preferences[category] = Map.from(_defaultPreferences[category]!);
    }
  }
  
  /// Get all preferences
  Map<String, Map<String, dynamic>> getAllPreferences() {
    return Map.unmodifiable(_preferences);
  }
  
  /// Get a specific preference category
  Map<String, dynamic>? getCategory(String category) {
    if (!_preferences.containsKey(category)) {
      return null;
    }
    return Map.unmodifiable(_preferences[category]!);
  }
  
  /// Get a specific preference value
  dynamic getPreference(String category, String key) {
    if (!_preferences.containsKey(category)) {
      return _defaultPreferences[category]?[key];
    }
    
    if (!_preferences[category]!.containsKey(key)) {
      return _defaultPreferences[category]?[key];
    }
    
    return _preferences[category]![key];
  }
  
  /// Set a specific preference value
  Future<void> setPreference(String category, String key, dynamic value) async {
    // Validate category
    if (!_preferences.containsKey(category)) {
      if (!_defaultPreferences.containsKey(category)) {
        throw Exception('Invalid preference category: $category');
      }
      _preferences[category] = {};
    }
    
    // Update the preference
    _preferences[category]![key] = value;
    
    // Save preferences
    await _savePreferences();
    
    // Notify listeners
    _preferencesStreamController.add(_preferences);
    
    _log.info('Set preference: $category.$key = $value');
  }
  
  /// Save all preferences to storage
  Future<void> _savePreferences() async {
    if (_currentUserId == null) {
      _log.warning('Cannot save preferences: No current user ID');
      return;
    }
    
    try {
      // Get current user profile
      final userProfile = await _dataStorageManager.getUserProfileById(_currentUserId!);
      
      if (userProfile == null) {
        _log.warning('Cannot save preferences: User profile not found');
        return;
      }
      
      // Create updated profile with new preferences
      final updatedProfile = userProfile.copyWith(
        preferences: _preferences,
      );
      
      // Save updated profile
      await _dataStorageManager.saveUserProfile(
        updatedProfile.id,
        updatedProfile.name,
        updatedProfile.isPublic,
        updatedProfile.allowDataUpload,
      );
      
      // Also persist current preference state to shared preferences for fast access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferences_json', jsonEncode(_preferences));
      
      _log.info('Saved preferences for user: $_currentUserId');
    } catch (e) {
      _log.severe('Error saving preferences: $e');
    }
  }
  
  /// Reset a category to default values
  Future<void> resetCategory(String category) async {
    if (!_defaultPreferences.containsKey(category)) {
      throw Exception('Invalid preference category: $category');
    }
    
    // Reset the category
    _preferences[category] = Map.from(_defaultPreferences[category]!);
    
    // Save preferences
    await _savePreferences();
    
    // Notify listeners
    _preferencesStreamController.add(_preferences);
    
    _log.info('Reset category to defaults: $category');
  }
  
  /// Reset all preferences to defaults
  Future<void> resetAllPreferences() async {
    _resetToDefaults();
    
    // Save preferences
    await _savePreferences();
    
    // Notify listeners
    _preferencesStreamController.add(_preferences);
    
    _log.info('Reset all preferences to defaults');
  }
  
  /// Check if a preference exists
  bool hasPreference(String category, String key) {
    return _preferences.containsKey(category) && _preferences[category]!.containsKey(key);
  }
  
  /// Stream of preference changes
  Stream<Map<String, Map<String, dynamic>>> get preferencesStream => _preferencesStreamController.stream;
  
  /// Dispose of resources
  void dispose() {
    _preferencesStreamController.close();
  }
} 