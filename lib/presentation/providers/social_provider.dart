import 'package:flutter/foundation.dart';
import 'package:going50/core_models/user_profile.dart';

/// Provider for social features
///
/// This provider is responsible for:
/// - Managing connections between users
/// - Providing leaderboard functionality
/// - Handling content sharing
class SocialProvider extends ChangeNotifier {
  // State
  List<UserProfile> _friends = [];
  List<Map<String, dynamic>> _leaderboardEntries = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Public getters
  
  /// List of friends
  List<UserProfile> get friends => _friends;
  
  /// Current leaderboard entries
  List<Map<String, dynamic>> get leaderboardEntries => _leaderboardEntries;
  
  /// Whether data is currently being loaded
  bool get isLoading => _isLoading;
  
  /// Error message, if any
  String? get errorMessage => _errorMessage;
  
  /// Selected leaderboard type ('global', 'regional', 'friends')
  String _leaderboardType = 'global';
  String get leaderboardType => _leaderboardType;
  
  /// Selected leaderboard timeframe ('daily', 'weekly', 'monthly', 'alltime')
  String _timeframe = 'weekly';
  String get timeframe => _timeframe;
  
  /// Constructor
  SocialProvider() {
    _loadMockData();
  }
  
  /// Load mock friends and leaderboard data for development
  void _loadMockData() {
    _setLoading(true);
    
    try {
      // Mock friends data
      _friends = [
        UserProfile(
          id: 'friend1',
          name: 'Alex Johnson',
          createdAt: DateTime.now().subtract(const Duration(days: 100)),
          isPublic: true,
          allowDataUpload: true,
        ),
        UserProfile(
          id: 'friend2',
          name: 'Jamie Smith',
          createdAt: DateTime.now().subtract(const Duration(days: 50)),
          isPublic: true,
          allowDataUpload: false,
        ),
        UserProfile(
          id: 'friend3',
          name: 'Sam Williams',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          isPublic: true,
          allowDataUpload: true,
        ),
      ];
      
      // Mock leaderboard data
      _leaderboardEntries = [
        {
          'rank': 1,
          'userId': 'user1',
          'name': 'Taylor Green',
          'score': 95,
          'trend': 'up',
        },
        {
          'rank': 2,
          'userId': 'user2',
          'name': 'Jordan Rivera',
          'score': 92,
          'trend': 'same',
        },
        {
          'rank': 3,
          'userId': 'friend1',
          'name': 'Alex Johnson',
          'score': 88,
          'trend': 'up',
          'isFriend': true,
        },
        {
          'rank': 4,
          'userId': 'user3',
          'name': 'Casey Lee',
          'score': 85,
          'trend': 'down',
        },
        {
          'rank': 5,
          'userId': 'user4',
          'name': 'Morgan Chen',
          'score': 82,
          'trend': 'up',
        },
      ];
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load social data: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Set the leaderboard type
  void setLeaderboardType(String type) {
    if (_leaderboardType != type) {
      _leaderboardType = type;
      // In a real implementation, this would refresh the data
      // but for now we'll just notify listeners
      notifyListeners();
    }
  }
  
  /// Set the leaderboard timeframe
  void setTimeframe(String timeframe) {
    if (_timeframe != timeframe) {
      _timeframe = timeframe;
      // In a real implementation, this would refresh the data
      // but for now we'll just notify listeners
      notifyListeners();
    }
  }
  
  /// Filter leaderboard by friend status
  List<Map<String, dynamic>> getFilteredLeaderboard({bool friendsOnly = false}) {
    if (!friendsOnly) return _leaderboardEntries;
    
    return _leaderboardEntries.where((entry) => 
      entry['isFriend'] == true
    ).toList();
  }
  
  /// Share trip or achievement
  Future<bool> shareContent({
    required String contentType, 
    required String contentId,
    required String shareType
  }) async {
    _setLoading(true);
    
    try {
      // In a real implementation, this would handle the actual sharing
      // but for now we'll just simulate success
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return success
      return true;
    } catch (e) {
      _setError('Failed to share content: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Get details for a specific friend
  UserProfile? getFriendById(String friendId) {
    try {
      return _friends.firstWhere((friend) => friend.id == friendId);
    } catch (e) {
      // Friend not found
      return null;
    }
  }
  
  /// Add a new friend
  Future<bool> addFriend(String userId) async {
    _setLoading(true);
    
    try {
      // In a real implementation, this would handle the actual friend request
      // but for now we'll just simulate success
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return success
      return true;
    } catch (e) {
      _setError('Failed to add friend: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Remove a friend
  Future<bool> removeFriend(String friendId) async {
    _setLoading(true);
    
    try {
      // In a real implementation, this would handle the actual friend removal
      // but for now we'll just simulate success
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Remove from local list
      _friends.removeWhere((friend) => friend.id == friendId);
      notifyListeners();
      
      // Return success
      return true;
    } catch (e) {
      _setError('Failed to remove friend: $e');
      return false;
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