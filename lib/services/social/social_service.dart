import 'dart:async';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/services/user/user_service.dart';
import 'package:going50/services/user/privacy_service.dart';

/// SocialService manages user connections and social features
///
/// This service is responsible for:
/// - Managing connections between users (friends)
/// - Processing friend requests
/// - Handling user discovery
/// - Managing social visibility based on privacy settings
class SocialService {
  // Dependencies
  final DataStorageManager _dataStorageManager;
  final UserService _userService;
  final PrivacyService _privacyService;
  
  // Logging
  final _log = Logger('SocialService');
  
  // State
  final List<UserProfile> _friends = [];
  final List<String> _friendRequests = [];
  final List<String> _sentRequests = [];
  final Map<String, UserProfile> _userCache = {};
  
  // Stream controllers
  final _friendsStreamController = StreamController<List<UserProfile>>.broadcast();
  final _requestsStreamController = StreamController<List<String>>.broadcast();
  final _sentRequestsStreamController = StreamController<List<String>>.broadcast();
  final _socialEventStreamController = StreamController<Map<String, dynamic>>.broadcast();
  
  // Constants
  static const _friendsKey = 'friends';
  static const _friendRequestsKey = 'friend_requests';
  static const _sentRequestsKey = 'sent_requests';

  /// Constructor
  SocialService(this._dataStorageManager, this._userService, this._privacyService) {
    _log.info('SocialService created');
    _initialize();
  }
  
  /// Initialize the service and load data
  Future<void> _initialize() async {
    _log.info('Initializing SocialService');
    await _loadFriends();
    await _loadRequests();
  }
  
  /// Get the list of friends
  List<UserProfile> get friends => List.unmodifiable(_friends);
  
  /// Get the list of friend requests
  List<String> get friendRequests => List.unmodifiable(_friendRequests);
  
  /// Get the list of sent requests
  List<String> get sentRequests => List.unmodifiable(_sentRequests);
  
  /// Stream of friends updates
  Stream<List<UserProfile>> get friendsStream => _friendsStreamController.stream;
  
  /// Stream of friend requests updates
  Stream<List<String>> get requestsStream => _requestsStreamController.stream;
  
  /// Stream of sent requests updates
  Stream<List<String>> get sentRequestsStream => _sentRequestsStreamController.stream;
  
  /// Stream of social events (friend added, request received, etc.)
  Stream<Map<String, dynamic>> get socialEventStream => _socialEventStreamController.stream;
  
  /// Load friends from storage
  Future<void> _loadFriends() async {
    _log.info('Loading friends');
    _friends.clear();
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return;
      }
      
      // Get friend IDs from storage
      final friendIds = await _dataStorageManager.getFriendIds(currentUser.id);
      if (friendIds.isEmpty) {
        _log.info('No friends found');
        _friendsStreamController.add(_friends);
        return;
      }
      
      // Load each friend's profile
      for (final friendId in friendIds) {
        final friendProfile = await _dataStorageManager.getUserProfileById(friendId);
        if (friendProfile != null) {
          _friends.add(friendProfile);
          _userCache[friendId] = friendProfile;
        } else {
          _log.warning('Friend profile not found for ID: $friendId');
        }
      }
      
      _log.info('Loaded ${_friends.length} friends');
      _friendsStreamController.add(_friends);
    } catch (e) {
      _log.severe('Error loading friends: $e');
    }
  }
  
  /// Load friend requests from storage
  Future<void> _loadRequests() async {
    _log.info('Loading friend requests');
    _friendRequests.clear();
    _sentRequests.clear();
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return;
      }
      
      // Get received requests
      final receivedRequests = await _dataStorageManager.getReceivedFriendRequests(currentUser.id);
      _friendRequests.addAll(receivedRequests);
      
      // Get sent requests
      final sentRequests = await _dataStorageManager.getSentFriendRequests(currentUser.id);
      _sentRequests.addAll(sentRequests);
      
      _log.info('Loaded ${_friendRequests.length} received requests and ${_sentRequests.length} sent requests');
      _requestsStreamController.add(_friendRequests);
      _sentRequestsStreamController.add(_sentRequests);
    } catch (e) {
      _log.severe('Error loading friend requests: $e');
    }
  }
  
  /// Search for users by name
  Future<List<UserProfile>> searchUsers(String query) async {
    _log.info('Searching for users with query: $query');
    
    if (query.isEmpty) {
      return [];
    }
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return [];
      }
      
      // Search for users
      final results = await _dataStorageManager.searchUserProfiles(query);
      
      // Filter out current user and respect privacy settings
      return results.where((user) {
        // Skip current user
        if (user.id == currentUser.id) return false;
        
        // Only include public profiles
        return user.isPublic;
      }).toList();
    } catch (e) {
      _log.severe('Error searching users: $e');
      return [];
    }
  }
  
  /// Get user profile by ID (respects privacy settings)
  Future<UserProfile?> getUserProfile(String userId) async {
    _log.info('Getting user profile for ID: $userId');
    
    // Check cache first
    if (_userCache.containsKey(userId)) {
      return _userCache[userId];
    }
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return null;
      }
      
      // Don't return self
      if (userId == currentUser.id) {
        return currentUser;
      }
      
      // Get user profile
      final userProfile = await _dataStorageManager.getUserProfileById(userId);
      
      // Respect privacy settings - only return if public or friends
      if (userProfile != null) {
        if (userProfile.isPublic || _isFriend(userId)) {
          // Cache for future use
          _userCache[userId] = userProfile;
          return userProfile;
        } else {
          _log.info('User profile is private and not a friend: $userId');
          return null;
        }
      } else {
        _log.warning('User profile not found for ID: $userId');
        return null;
      }
    } catch (e) {
      _log.severe('Error getting user profile: $e');
      return null;
    }
  }
  
  /// Check if a user is a friend
  bool _isFriend(String userId) {
    return _friends.any((friend) => friend.id == userId);
  }
  
  /// Check if a user has a pending friend request
  bool hasPendingRequest(String userId) {
    return _friendRequests.contains(userId);
  }
  
  /// Check if we have sent a request to a user
  bool hasSentRequest(String userId) {
    return _sentRequests.contains(userId);
  }
  
  /// Send a friend request
  Future<bool> sendFriendRequest(String userId) async {
    _log.info('Sending friend request to user: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Don't send request to self
      if (userId == currentUser.id) {
        _log.warning('Cannot send friend request to self');
        return false;
      }
      
      // Don't send request if already friends
      if (_isFriend(userId)) {
        _log.warning('Already friends with user: $userId');
        return false;
      }
      
      // Don't send request if already sent
      if (hasSentRequest(userId)) {
        _log.warning('Friend request already sent to user: $userId');
        return false;
      }
      
      // Send the request
      await _dataStorageManager.sendFriendRequest(currentUser.id, userId);
      
      // Update local state
      _sentRequests.add(userId);
      _sentRequestsStreamController.add(_sentRequests);
      
      // Send event
      _socialEventStreamController.add({
        'type': 'request_sent',
        'userId': userId,
      });
      
      _log.info('Friend request sent to user: $userId');
      return true;
    } catch (e) {
      _log.severe('Error sending friend request: $e');
      return false;
    }
  }
  
  /// Accept a friend request
  Future<bool> acceptFriendRequest(String userId) async {
    _log.info('Accepting friend request from user: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Check if request exists
      if (!hasPendingRequest(userId)) {
        _log.warning('No pending request from user: $userId');
        return false;
      }
      
      // Accept the request
      await _dataStorageManager.acceptFriendRequest(currentUser.id, userId);
      
      // Get friend profile
      final friendProfile = await _dataStorageManager.getUserProfileById(userId);
      if (friendProfile != null) {
        _friends.add(friendProfile);
        _userCache[userId] = friendProfile;
      }
      
      // Update local state
      _friendRequests.remove(userId);
      _requestsStreamController.add(_friendRequests);
      _friendsStreamController.add(_friends);
      
      // Send event
      _socialEventStreamController.add({
        'type': 'request_accepted',
        'userId': userId,
      });
      
      _log.info('Friend request accepted from user: $userId');
      return true;
    } catch (e) {
      _log.severe('Error accepting friend request: $e');
      return false;
    }
  }
  
  /// Reject a friend request
  Future<bool> rejectFriendRequest(String userId) async {
    _log.info('Rejecting friend request from user: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Check if request exists
      if (!hasPendingRequest(userId)) {
        _log.warning('No pending request from user: $userId');
        return false;
      }
      
      // Reject the request
      await _dataStorageManager.rejectFriendRequest(currentUser.id, userId);
      
      // Update local state
      _friendRequests.remove(userId);
      _requestsStreamController.add(_friendRequests);
      
      _log.info('Friend request rejected from user: $userId');
      return true;
    } catch (e) {
      _log.severe('Error rejecting friend request: $e');
      return false;
    }
  }
  
  /// Cancel a sent friend request
  Future<bool> cancelFriendRequest(String userId) async {
    _log.info('Canceling friend request to user: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Check if request exists
      if (!hasSentRequest(userId)) {
        _log.warning('No sent request to user: $userId');
        return false;
      }
      
      // Cancel the request
      await _dataStorageManager.cancelFriendRequest(currentUser.id, userId);
      
      // Update local state
      _sentRequests.remove(userId);
      _sentRequestsStreamController.add(_sentRequests);
      
      _log.info('Friend request canceled to user: $userId');
      return true;
    } catch (e) {
      _log.severe('Error canceling friend request: $e');
      return false;
    }
  }
  
  /// Remove a friend
  Future<bool> removeFriend(String userId) async {
    _log.info('Removing friend: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Check if friend exists
      if (!_isFriend(userId)) {
        _log.warning('Not friends with user: $userId');
        return false;
      }
      
      // Remove the friend
      await _dataStorageManager.removeFriend(currentUser.id, userId);
      
      // Update local state
      _friends.removeWhere((friend) => friend.id == userId);
      _friendsStreamController.add(_friends);
      
      // Send event
      _socialEventStreamController.add({
        'type': 'friend_removed',
        'userId': userId,
      });
      
      _log.info('Friend removed: $userId');
      return true;
    } catch (e) {
      _log.severe('Error removing friend: $e');
      return false;
    }
  }
  
  /// Block a user
  Future<bool> blockUser(String userId) async {
    _log.info('Blocking user: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Block the user
      await _dataStorageManager.blockUser(currentUser.id, userId);
      
      // Also remove as friend if exists
      if (_isFriend(userId)) {
        await removeFriend(userId);
      }
      
      // Reject any pending requests
      if (hasPendingRequest(userId)) {
        await rejectFriendRequest(userId);
      }
      
      // Cancel any sent requests
      if (hasSentRequest(userId)) {
        await cancelFriendRequest(userId);
      }
      
      // Send event
      _socialEventStreamController.add({
        'type': 'user_blocked',
        'userId': userId,
      });
      
      _log.info('User blocked: $userId');
      return true;
    } catch (e) {
      _log.severe('Error blocking user: $e');
      return false;
    }
  }
  
  /// Unblock a user
  Future<bool> unblockUser(String userId) async {
    _log.info('Unblocking user: $userId');
    
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      // Unblock the user
      await _dataStorageManager.unblockUser(currentUser.id, userId);
      
      _log.info('User unblocked: $userId');
      return true;
    } catch (e) {
      _log.severe('Error unblocking user: $e');
      return false;
    }
  }
  
  /// Check if a user is blocked
  Future<bool> isUserBlocked(String userId) async {
    try {
      // Get current user
      final currentUser = _userService.currentUser;
      if (currentUser == null) {
        _log.warning('No current user found');
        return false;
      }
      
      return await _dataStorageManager.isUserBlocked(currentUser.id, userId);
    } catch (e) {
      _log.severe('Error checking if user is blocked: $e');
      return false;
    }
  }
  
  /// Dispose resources
  void dispose() {
    _friendsStreamController.close();
    _requestsStreamController.close();
    _sentRequestsStreamController.close();
    _socialEventStreamController.close();
  }
} 