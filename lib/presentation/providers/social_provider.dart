import 'package:flutter/foundation.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/services/social/social_service.dart';
import 'package:going50/services/social/leaderboard_service.dart';
import 'package:going50/services/social/sharing_service.dart';

/// Provider for social features
///
/// This provider is responsible for:
/// - Managing connections between users
/// - Providing leaderboard functionality
/// - Handling content sharing
class SocialProvider extends ChangeNotifier {
  // Dependencies
  final SocialService _socialService;
  final LeaderboardService _leaderboardService;
  final SharingService _sharingService;
  
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
  SocialProvider(this._socialService, this._leaderboardService, this._sharingService) {
    _initialize();
  }
  
  /// Initialize the provider
  void _initialize() {
    _setLoading(true);
    
    // Subscribe to social service events
    _socialService.socialEventStream.listen(_handleSocialEvent);
    _socialService.friendsStream.listen(_handleFriendsUpdate);
    
    // Load initial data
    _loadInitialData();
  }
  
  /// Load initial data 
  Future<void> _loadInitialData() async {
    try {
      // Load friends
      _friends = _socialService.friends;
      
      // Load leaderboard data
      await _refreshLeaderboard();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load social data: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Handle social event
  void _handleSocialEvent(Map<String, dynamic> event) {
    final eventType = event['type'] as String;
    
    switch (eventType) {
      case 'friend_added':
      case 'friend_removed':
      case 'request_accepted':
        // Refresh friends list
        _friends = _socialService.friends;
        notifyListeners();
        break;
        
      case 'content_shared':
      case 'content_shared_external':
        // Nothing to do here, just informational
        break;
        
      default:
        // Unknown event
        break;
    }
  }
  
  /// Handle friends update
  void _handleFriendsUpdate(List<UserProfile> friends) {
    _friends = friends;
    notifyListeners();
  }
  
  /// Set the leaderboard type
  Future<void> setLeaderboardType(String type) async {
    if (_leaderboardType != type) {
      _leaderboardType = type;
      await _refreshLeaderboard();
      notifyListeners();
    }
  }
  
  /// Set the leaderboard timeframe
  Future<void> setTimeframe(String timeframe) async {
    if (_timeframe != timeframe) {
      _timeframe = timeframe;
      await _refreshLeaderboard();
      notifyListeners();
    }
  }
  
  /// Refresh leaderboard data
  Future<void> _refreshLeaderboard() async {
    _setLoading(true);
    
    try {
      _leaderboardEntries = await _leaderboardService.getLeaderboard(
        type: _leaderboardType,
        timeframe: _timeframe,
      );
    } catch (e) {
      _setError('Failed to load leaderboard: $e');
    } finally {
      _setLoading(false);
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
      // Get current user ID (in a real implementation, this would come from a user service)
      const userId = 'current_user_id';
      
      final result = await _sharingService.shareContent(
        userId: userId,
        contentType: contentType,
        contentId: contentId,
        shareType: shareType,
      );
      
      // Return success
      return result != null;
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
      final success = await _socialService.sendFriendRequest(userId);
      
      if (success) {
        // No need to update friends list yet, as this is just a request
        notifyListeners();
      }
      
      return success;
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
      final success = await _socialService.removeFriend(friendId);
      
      if (success) {
        // Friends list should get updated via the stream listener
        // but to be safe, update it directly too
        _friends.removeWhere((friend) => friend.id == friendId);
        notifyListeners();
      }
      
      return success;
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