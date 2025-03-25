import 'dart:async';
import 'package:logging/logging.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/services/driving/performance_metrics_service.dart';

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
  
  /// Get mock global leaderboard
  Future<List<Map<String, dynamic>>> _getGlobalLeaderboard(String timeframe) async {
    _log.info('Getting global leaderboard for $timeframe');
    
    // In a real implementation, this would be fetched from a database or API
    // For now, we'll return mock data
    return [
      {
        'userId': 'user1',
        'name': 'Taylor Green',
        'score': 95,
        'trend': 'up',
      },
      {
        'userId': 'user2',
        'name': 'Jordan Rivera',
        'score': 92,
        'trend': 'same',
      },
      {
        'userId': 'friend1',
        'name': 'Alex Johnson',
        'score': 88,
        'trend': 'up',
        'isFriend': true,
      },
      {
        'userId': 'user3',
        'name': 'Casey Lee',
        'score': 85,
        'trend': 'down',
      },
      {
        'userId': 'user4',
        'name': 'Morgan Chen',
        'score': 82,
        'trend': 'up',
      },
    ];
  }
  
  /// Get mock regional leaderboard
  Future<List<Map<String, dynamic>>> _getRegionalLeaderboard(String timeframe, String? regionId) async {
    _log.info('Getting regional leaderboard for $timeframe in region $regionId');
    
    // In a real implementation, this would be fetched from a database or API
    // For now, we'll return mock data
    return [
      {
        'userId': 'local1',
        'name': 'Alex Morgan',
        'score': 91,
        'trend': 'up',
      },
      {
        'userId': 'friend2',
        'name': 'Jamie Smith',
        'score': 87,
        'trend': 'up',
        'isFriend': true,
      },
      {
        'userId': 'local2',
        'name': 'Riley Johnson',
        'score': 84,
        'trend': 'down',
      },
      {
        'userId': 'local3',
        'name': 'Taylor Swift',
        'score': 82,
        'trend': 'same',
      },
      {
        'userId': 'local4',
        'name': 'Chris Martin',
        'score': 79,
        'trend': 'up',
      },
    ];
  }
  
  /// Get mock friends leaderboard
  Future<List<Map<String, dynamic>>> _getFriendsLeaderboard(String timeframe) async {
    _log.info('Getting friends leaderboard for $timeframe');
    
    // In a real implementation, this would be fetched from a database or API
    // For now, we'll return mock data
    return [
      {
        'userId': 'friend1',
        'name': 'Alex Johnson',
        'score': 88,
        'trend': 'up',
        'isFriend': true,
      },
      {
        'userId': 'friend2',
        'name': 'Jamie Smith',
        'score': 84,
        'trend': 'up',
        'isFriend': true,
      },
      {
        'userId': 'friend3',
        'name': 'Sam Williams',
        'score': 79,
        'trend': 'down',
        'isFriend': true,
      },
    ];
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