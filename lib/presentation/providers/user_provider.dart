import 'package:flutter/foundation.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:going50/services/user/preferences_service.dart';

/// Provider for user profile state
///
/// This provider is responsible for:
/// - Managing user profile information
/// - Handling user preferences
/// - Managing privacy settings
class UserProvider extends ChangeNotifier {
  // Dependencies
  final UserService _userService;
  final PreferencesService _preferencesService;
  
  // State
  UserProfile? _userProfile;
  bool _isAnonymous = true;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, Map<String, dynamic>> _preferences = {};
  
  // Public getters
  
  /// The current user profile, if any
  UserProfile? get userProfile => _userProfile;
  
  /// Whether the user is anonymous (not logged in)
  bool get isAnonymous => _isAnonymous;
  
  /// Whether data is currently being loaded
  bool get isLoading => _isLoading;
  
  /// Error message, if any
  String? get errorMessage => _errorMessage;
  
  /// User preferences
  Map<String, Map<String, dynamic>> get preferences => _preferences;
  
  /// Constructor
  UserProvider(this._userService, this._preferencesService) {
    _loadUserProfile();
    
    // Listen for user profile changes
    _userService.userProfileStream.listen((profile) {
      if (profile != null) {
        _userProfile = profile;
        _isAnonymous = _userService.isAnonymous;
        notifyListeners();
      }
    });
    
    // Listen for preference changes
    _preferencesService.preferencesStream.listen((prefs) {
      _preferences = prefs;
      notifyListeners();
    });
  }
  
  /// Load the user profile from storage
  Future<void> _loadUserProfile() async {
    _setLoading(true);
    
    try {
      await _userService.initialize();
      
      _userProfile = _userService.currentUser;
      _isAnonymous = _userService.isAnonymous;
      
      // Initialize preferences service with current user ID
      if (_userProfile != null) {
        await _preferencesService.initialize(_userProfile!.id);
        _preferences = _preferencesService.getAllPreferences();
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user profile: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Get a specific preference
  dynamic getPreference(String category, String key) {
    return _preferencesService.getPreference(category, key);
  }
  
  /// Get all preferences for a category
  Map<String, dynamic>? getPreferenceCategory(String category) {
    return _preferencesService.getCategory(category);
  }
  
  /// Update a user preference
  Future<void> updatePreference(String category, String key, dynamic value) async {
    _setLoading(true);
    
    try {
      await _preferencesService.setPreference(category, key, value);
      // No need to update local preferences here as we're listening to the preferences stream
    } catch (e) {
      _setError('Failed to update preference: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Reset preferences for a category to defaults
  Future<void> resetCategoryPreferences(String category) async {
    _setLoading(true);
    
    try {
      await _preferencesService.resetCategory(category);
      // No need to update local preferences here as we're listening to the preferences stream
    } catch (e) {
      _setError('Failed to reset preferences: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Reset all preferences to defaults
  Future<void> resetAllPreferences() async {
    _setLoading(true);
    
    try {
      await _preferencesService.resetAllPreferences();
      // No need to update local preferences here as we're listening to the preferences stream
    } catch (e) {
      _setError('Failed to reset preferences: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Register a user (convert anonymous to registered)
  Future<void> registerUser({
    required String name,
    required bool isPublic,
    required bool allowDataUpload,
  }) async {
    _setLoading(true);
    
    try {
      await _userService.registerUser(
        name: name,
        isPublic: isPublic,
        allowDataUpload: allowDataUpload,
      );
      
      _userProfile = _userService.currentUser;
      _isAnonymous = _userService.isAnonymous;
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to register user: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Update user profile
  Future<void> updateProfile({String? name, bool? isPublic, bool? allowDataUpload}) async {
    if (_userProfile == null) return;
    
    _setLoading(true);
    
    try {
      await _userService.updateProfile(
        name: name,
        isPublic: isPublic,
        allowDataUpload: allowDataUpload,
      );
      
      _userProfile = _userService.currentUser;
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to update profile: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
} 