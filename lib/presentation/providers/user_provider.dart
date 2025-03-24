import 'package:flutter/foundation.dart';
import 'package:going50/core_models/user_profile.dart';

/// Provider for user profile state
///
/// This provider is responsible for:
/// - Managing user profile information
/// - Handling user preferences
/// - Managing privacy settings
class UserProvider extends ChangeNotifier {
  // State
  UserProfile? _userProfile;
  bool _isAnonymous = true;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _preferences = {};
  
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
  Map<String, dynamic> get preferences => _preferences;
  
  /// Constructor
  UserProvider() {
    _loadUserProfile();
  }
  
  /// Load the user profile from storage
  Future<void> _loadUserProfile() async {
    _setLoading(true);
    
    try {
      // TODO: Implement actual data loading from a user service when created
      // For now, set a default anonymous profile
      
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      _userProfile = UserProfile(
        id: 'anonymous',
        name: 'Anonymous User',
        createdAt: DateTime.now(),
        isPublic: false,
        allowDataUpload: false,
      );
      
      _isAnonymous = true;
      
      // Load default preferences
      _loadPreferences();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user profile: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Load user preferences
  Future<void> _loadPreferences() async {
    try {
      // TODO: Implement actual preference loading from storage
      
      // Set default preferences for now
      _preferences = {
        'notifications': {
          'trip_summary': true,
          'achievements': true,
          'eco_tips': true,
          'social': false,
        },
        'privacy': {
          'share_trip_data': false,
          'share_achievements': false,
          'allow_leaderboard': false,
        },
        'display': {
          'dark_mode': 'system', // 'light', 'dark', 'system'
          'units': 'metric', // 'metric', 'imperial'
        },
      };
    } catch (e) {
      _setError('Failed to load preferences: $e');
    }
  }
  
  /// Update a user preference
  Future<void> updatePreference(String category, String key, dynamic value) async {
    _setLoading(true);
    
    try {
      // Validate that the category exists
      if (!_preferences.containsKey(category)) {
        throw Exception('Preference category $category does not exist');
      }
      
      // Validate that the key exists in the category
      if (!(_preferences[category] as Map<String, dynamic>).containsKey(key)) {
        throw Exception('Preference key $key does not exist in category $category');
      }
      
      // Update the preference
      (_preferences[category] as Map<String, dynamic>)[key] = value;
      
      // TODO: Save preferences to storage when user service is implemented
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to update preference: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Update user profile
  Future<void> updateProfile({String? name, bool? isPublic, bool? allowDataUpload}) async {
    if (_userProfile == null) return;
    
    _setLoading(true);
    
    try {
      // Create updated profile
      _userProfile = UserProfile(
        id: _userProfile!.id,
        name: name ?? _userProfile!.name,
        createdAt: _userProfile!.createdAt,
        isPublic: isPublic ?? _userProfile!.isPublic,
        allowDataUpload: allowDataUpload ?? _userProfile!.allowDataUpload,
      );
      
      // TODO: Save profile to storage when user service is implemented
      
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