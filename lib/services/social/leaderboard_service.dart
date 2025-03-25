import 'dart:async';
import 'package:logging/logging.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/services/driving/performance_metrics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// LeaderboardService manages leaderboard functionality
///
/// This service is responsible for:
/// - Retrieving leaderboard data for different time periods and regions
/// - Calculating user rankings based on eco-driving performance
/// - Filtering leaderboard data based on criteria (global, regional, friends)
class LeaderboardService {
  // Dependencies
  final DataStorageManager _dataStorageManager;
  final PerformanceMetricsService _metricsService;
  
  // Logging
  final _log = Logger('LeaderboardService');
  
  // Caching
  final Map<String, List<Map<String, dynamic>>> _leaderboardCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  
  // Constants
  static const cacheDuration = Duration(minutes: 15);
  
  /// Constructor
  LeaderboardService(this._dataStorageManager, this._metricsService) {
    _log.info('LeaderboardService created');
  }
  
  /// Get leaderboard data for the specified type and timeframe
  Future<List<Map<String, dynamic>>> getLeaderboard({
    required String type, // 'global', 'regional', 'friends'
    required String timeframe, // 'daily', 'weekly', 'monthly', 'alltime'
    String? regionId,
    int limit = 100,
    int offset = 0,
  }) async {
    _log.info('Getting $type leaderboard for $timeframe timeframe');
    
    // Create cache key
    final cacheKey = '${type}_${timeframe}_${regionId ?? "all"}_${limit}_$offset';
    
    // Check cache first
    if (_isValidCache(cacheKey)) {
      _log.info('Using cached leaderboard data');
      return _leaderboardCache[cacheKey]!;
    }
    
    try {
      List<Map<String, dynamic>> leaderboard;
      
      // In a real implementation, this would query a database or API
      // Here we'll use a mock implementation
      switch (type) {
        case 'friends':
          leaderboard = await _getFriendsLeaderboard(timeframe);
          break;
        case 'regional':
          leaderboard = await _getRegionalLeaderboard(timeframe, regionId);
          break;
        case 'global':
        default:
          leaderboard = await _getGlobalLeaderboard(timeframe);
          break;
      }
      
      // Add rank based on position
      for (int i = 0; i < leaderboard.length; i++) {
        leaderboard[i]['rank'] = i + 1 + offset;
      }
      
      // Cache the result
      _leaderboardCache[cacheKey] = leaderboard;
      _cacheTimestamps[cacheKey] = DateTime.now();
      
      return leaderboard;
    } catch (e) {
      _log.severe('Error getting leaderboard data: $e');
      return [];
    }
  }
  
  /// Get the user's current ranking
  Future<Map<String, dynamic>?> getUserRanking({
    required String userId,
    required String type, // 'global', 'regional', 'friends'
    required String timeframe, // 'daily', 'weekly', 'monthly', 'alltime'
    String? regionId,
  }) async {
    _log.info('Getting ranking for user $userId in $type leaderboard');
    
    try {
      // Get user profile
      final userProfile = await _dataStorageManager.getUserProfileById(userId);
      if (userProfile == null) {
        _log.warning('User profile not found: $userId');
        return null;
      }
      
      // Get user's metrics for the timeframe
      final metrics = await _metricsService.getUserPerformanceMetrics(userId);
      if (metrics == null) {
        _log.warning('No metrics found for user $userId');
        return null;
      }
      
      // Get leaderboard to determine rank
      final leaderboard = await getLeaderboard(
        type: type,
        timeframe: timeframe,
        regionId: regionId,
        limit: 1000, // Get a larger set to find the user
      );
      
      // Find user's position in leaderboard
      int rank = -1;
      for (int i = 0; i < leaderboard.length; i++) {
        if (leaderboard[i]['userId'] == userId) {
          rank = leaderboard[i]['rank'];
          break;
        }
      }
      
      // If user not found in top 1000, estimate position
      if (rank == -1) {
        rank = await _estimateUserRank(userId, metrics['ecoScore'] as double, type, timeframe, regionId);
      }
      
      // Create user ranking object
      return {
        'userId': userId,
        'name': userProfile.name,
        'score': metrics['ecoScore'],
        'rank': rank,
        'trend': await _getUserTrend(userId, timeframe),
        'isUser': true,
      };
    } catch (e) {
      _log.severe('Error getting user ranking: $e');
      return null;
    }
  }
  
  /// Get global leaderboard
  Future<List<Map<String, dynamic>>> _getGlobalLeaderboard(String timeframe) async {
    _log.info('Getting global leaderboard for $timeframe');
    
    try {
      // In a real implementation, this would use a dedicated API
      // For now, we'll create a simple leaderboard from available data
      final List<Map<String, dynamic>> leaderboardData = [];
      
      // Get a limited set of user IDs to test with
      // In the future, this would scale to handle all users
      final testUserIds = await _getTestUserIds();
      
      // For each user, get their profile and metrics
      for (final userId in testUserIds) {
        final userProfile = await _dataStorageManager.getUserProfileById(userId);
        
        // Skip if profile not found or not public
        if (userProfile == null || !userProfile.isPublic) {
          continue;
        }
        
        // Get user's performance metrics
        final metrics = await _metricsService.getUserPerformanceMetrics(userId);
        if (metrics == null) continue;
        
        final scoreKey = _getScoreKeyForTimeframe(timeframe);
        final score = metrics[scoreKey] ?? metrics['ecoScore'] ?? 0;
        
        leaderboardData.add({
          'userId': userId,
          'name': userProfile.name,
          'score': score,
          'trend': await _getUserTrend(userId, timeframe),
        });
      }
      
      // Sort by score (descending)
      leaderboardData.sort((a, b) => (b['score'] as num).compareTo(a['score'] as num));
      
      return leaderboardData;
    } catch (e) {
      _log.severe('Error getting global leaderboard: $e');
      return [];
    }
  }
  
  /// Get a list of user IDs for testing the leaderboard
  /// In a real implementation, this would be replaced with a proper user query
  Future<List<String>> _getTestUserIds() async {
    try {
      // Get current user ID
      final currentUserId = await _getCurrentUserId();
      if (currentUserId == null) return [];
      
      // Get friend IDs
      final friendIds = await _dataStorageManager.getFriendIds(currentUserId);
      
      // Combine current user and friends
      final userIds = [currentUserId, ...friendIds];
      
      // Add some sample IDs in case we don't have enough friends yet
      const sampleIds = ['user1', 'user2', 'user3', 'user4', 'user5'];
      
      // Only use sample IDs if we don't have enough real users
      if (userIds.length < 5) {
        for (final id in sampleIds) {
          if (!userIds.contains(id)) {
            userIds.add(id);
          }
          if (userIds.length >= 10) break;
        }
      }
      
      return userIds;
    } catch (e) {
      _log.warning('Error getting test user IDs: $e');
      return [];
    }
  }
  
  /// Get regional leaderboard
  Future<List<Map<String, dynamic>>> _getRegionalLeaderboard(String timeframe, String? regionId) async {
    _log.info('Getting regional leaderboard for $timeframe in region $regionId');
    
    try {
      // For now, return the global leaderboard as we don't have region data
      // In a real implementation, we would filter users by region
      return _getGlobalLeaderboard(timeframe);
    } catch (e) {
      _log.severe('Error getting regional leaderboard: $e');
      return [];
    }
  }
  
  /// Get friends leaderboard
  Future<List<Map<String, dynamic>>> _getFriendsLeaderboard(String timeframe) async {
    _log.info('Getting friends leaderboard for $timeframe');
    
    try {
      final List<Map<String, dynamic>> leaderboardData = [];
      
      // Get current user
      final currentUser = await _getCurrentUserId();
      if (currentUser == null) {
        _log.warning('No current user found');
        return [];
      }
      
      // Get friend IDs
      final friendIds = await _dataStorageManager.getFriendIds(currentUser);
      if (friendIds.isEmpty) {
        _log.info('No friends found');
        return [];
      }
      
      // Get current user's metrics and add to leaderboard
      final currentUserMetrics = await _metricsService.getUserPerformanceMetrics(currentUser);
      final currentUserProfile = await _dataStorageManager.getUserProfileById(currentUser);
      
      if (currentUserMetrics != null && currentUserProfile != null) {
        final scoreKey = _getScoreKeyForTimeframe(timeframe);
        final score = currentUserMetrics[scoreKey] ?? currentUserMetrics['ecoScore'] ?? 0;
        
        leaderboardData.add({
          'userId': currentUser,
          'name': currentUserProfile.name,
          'score': score,
          'trend': await _getUserTrend(currentUser, timeframe),
          'isUser': true,
        });
      }
      
      // Get friend metrics and add to leaderboard
      for (final friendId in friendIds) {
        final friendProfile = await _dataStorageManager.getUserProfileById(friendId);
        if (friendProfile == null) continue;
        
        final metrics = await _metricsService.getUserPerformanceMetrics(friendId);
        if (metrics != null) {
          final scoreKey = _getScoreKeyForTimeframe(timeframe);
          final score = metrics[scoreKey] ?? metrics['ecoScore'] ?? 0;
          
          leaderboardData.add({
            'userId': friendId,
            'name': friendProfile.name,
            'score': score,
            'trend': await _getUserTrend(friendId, timeframe),
            'isFriend': true,
          });
        }
      }
      
      // Sort by score (descending)
      leaderboardData.sort((a, b) => (b['score'] as num).compareTo(a['score'] as num));
      
      return leaderboardData;
    } catch (e) {
      _log.severe('Error getting friends leaderboard: $e');
      return [];
    }
  }
  
  /// Get the appropriate score key based on the timeframe
  String _getScoreKeyForTimeframe(String timeframe) {
    switch (timeframe) {
      case 'daily':
        return 'dailyEcoScore';
      case 'weekly':
        return 'weeklyEcoScore';
      case 'monthly':
        return 'monthlyEcoScore';
      case 'alltime':
      default:
        return 'ecoScore';
    }
  }
  
  /// Get current user ID
  Future<String?> _getCurrentUserId() async {
    try {
      // Get shared preferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_id');
    } catch (e) {
      _log.warning('Error getting current user ID: $e');
      return null;
    }
  }
  
  /// Check if cache is valid
  bool _isValidCache(String cacheKey) {
    if (!_leaderboardCache.containsKey(cacheKey) || !_cacheTimestamps.containsKey(cacheKey)) {
      return false;
    }
    
    final cacheTime = _cacheTimestamps[cacheKey]!;
    final now = DateTime.now();
    
    return now.difference(cacheTime) < cacheDuration;
  }
  
  /// Estimate user rank based on score
  Future<int> _estimateUserRank(
    String userId,
    double score,
    String type,
    String timeframe,
    String? regionId,
  ) async {
    // In a real implementation, this would query the database for count of users with higher scores
    // For now, we'll return a mock estimated rank
    return 1500;
  }
  
  /// Get user trend compared to previous timeframe
  Future<String> _getUserTrend(String userId, String timeframe) async {
    // In a real implementation, this would compare current and previous timeframe scores
    // For now, return a random trend
    final trends = ['up', 'down', 'same'];
    return trends[DateTime.now().millisecondsSinceEpoch % 3];
  }
  
  /// Clear all cached data
  void clearCache() {
    _log.info('Clearing leaderboard cache');
    _leaderboardCache.clear();
    _cacheTimestamps.clear();
  }
  
  /// Clear specific cached data
  void clearCacheForType(String type, String timeframe) {
    _log.info('Clearing leaderboard cache for $type $timeframe');
    
    // Create cache key pattern
    final pattern = '${type}_${timeframe}';
    
    // Remove all matching entries
    _leaderboardCache.removeWhere((key, _) => key.startsWith(pattern));
    _cacheTimestamps.removeWhere((key, _) => key.startsWith(pattern));
  }
} 