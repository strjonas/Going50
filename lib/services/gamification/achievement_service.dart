import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/services/driving/performance_metrics_service.dart';

/// Represents an achievement event when a badge is earned
class AchievementEvent {
  /// Unique identifier for the event
  final String id;
  
  /// User ID associated with this event
  final String userId;
  
  /// Type of badge earned
  final String badgeType;
  
  /// Name of the badge for display
  final String badgeName;
  
  /// Description of the badge
  final String badgeDescription;
  
  /// Level of the badge (if applicable)
  final int level;
  
  /// When the badge was earned
  final DateTime timestamp;
  
  /// Whether this is an upgrade to an existing badge
  final bool isUpgrade;
  
  /// Constructor
  AchievementEvent({
    required this.id,
    required this.userId,
    required this.badgeType,
    required this.badgeName,
    required this.badgeDescription,
    required this.level,
    required this.timestamp,
    this.isUpgrade = false,
  });

  /// Convert to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'badgeType': badgeType,
      'badgeName': badgeName,
      'badgeDescription': badgeDescription,
      'level': level,
      'timestamp': timestamp.toIso8601String(),
      'isUpgrade': isUpgrade,
    };
  }
}

/// Definition of the available badge types in the app
class BadgeType {
  /// Smooth Driver - maintain smooth driving style
  static const String smoothDriver = 'smooth_driver';
  
  /// Eco Warrior - achieve high eco-scores
  static const String ecoWarrior = 'eco_warrior';
  
  /// Fuel Saver - save fuel through eco-driving
  static const String fuelSaver = 'fuel_saver';
  
  /// Carbon Reducer - reduce CO2 emissions
  static const String carbonReducer = 'carbon_reducer';
  
  /// Road Veteran - complete many trips
  static const String roadVeteran = 'road_veteran';
  
  /// Speed Master - maintain optimal speeds
  static const String speedMaster = 'speed_master';
  
  /// Eco Expert - achieve excellent overall eco-score
  static const String ecoExpert = 'eco_expert';
  
  /// Fuel Efficiency - maintain good fuel efficiency
  static const String fuelEfficiency = 'fuel_efficiency';
  
  /// Consistent Driver - maintain consistent driving behavior
  static const String consistentDriver = 'consistent_driver';
  
  /// Early Adopter - used app in early stages
  static const String earlyAdopter = 'early_adopter';
  
  /// First Trip - completed first trip with the app
  static const String firstTrip = 'first_trip';
  
  /// OBD Connected - successfully connected to an OBD-II adapter
  static const String obdConnected = 'obd_connected';
}

/// Service that manages achievement tracking and awarding
class AchievementService extends ChangeNotifier {
  final Logger _logger = Logger('AchievementService');
  final DataStorageManager _dataStorageManager;
  final PerformanceMetricsService _performanceMetricsService;
  final Uuid _uuid = Uuid();
  
  // Event stream controller
  final StreamController<AchievementEvent> _achievementEventController = 
      StreamController<AchievementEvent>.broadcast();
  
  // Cache of user badges
  final Map<String, List<Map<String, dynamic>>> _userBadgesCache = {};
  
  // Achievement definitions with criteria
  late final Map<String, Map<String, dynamic>> _achievementDefinitions;
  
  // Service state
  bool _isInitialized = false;
  String? _errorMessage;
  
  // Public getters
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  
  /// Stream of achievement events (when badges are earned)
  Stream<AchievementEvent> get achievementEventStream => _achievementEventController.stream;
  
  /// Constructor
  AchievementService(this._dataStorageManager, this._performanceMetricsService) {
    _logger.info('AchievementService created');
    _defineAchievements();
    _initialize();
  }
  
  /// Define all achievements and their criteria
  void _defineAchievements() {
    _achievementDefinitions = {
      BadgeType.smoothDriver: {
        'name': 'Smooth Driver',
        'description': 'Maintain calm driving for consecutive trips',
        'levels': [
          {'threshold': 5, 'description': 'Maintain calm driving for 5 trips'},
          {'threshold': 10, 'description': 'Maintain calm driving for 10 trips'},
          {'threshold': 25, 'description': 'Maintain calm driving for 25 trips'},
        ],
        'metric': 'calmDrivingScore',
        'minScore': 80,
      },
      
      BadgeType.ecoWarrior: {
        'name': 'Eco Warrior',
        'description': 'Achieve high eco-scores on multiple trips',
        'levels': [
          {'threshold': 3, 'description': 'Achieve 85+ eco-score for 3 consecutive trips'},
          {'threshold': 5, 'description': 'Achieve 90+ eco-score for 5 consecutive trips'},
          {'threshold': 10, 'description': 'Achieve 90+ eco-score for 10 consecutive trips'},
        ],
        'metric': 'overallScore',
        'minScore': 85,
      },
      
      BadgeType.fuelSaver: {
        'name': 'Fuel Saver',
        'description': 'Save fuel through eco-driving habits',
        'levels': [
          {'threshold': 10, 'description': 'Save 10 liters of fuel through eco-driving'},
          {'threshold': 20, 'description': 'Save 20 liters of fuel through eco-driving'},
          {'threshold': 50, 'description': 'Save 50 liters of fuel through eco-driving'},
        ],
        'metric': 'fuelSaved',
        'cumulative': true,
      },
      
      BadgeType.carbonReducer: {
        'name': 'Carbon Reducer',
        'description': 'Reduce CO2 emissions through efficient driving',
        'levels': [
          {'threshold': 20, 'description': 'Reduce CO2 emissions by 20kg'},
          {'threshold': 50, 'description': 'Reduce CO2 emissions by 50kg'},
          {'threshold': 100, 'description': 'Reduce CO2 emissions by 100kg'},
        ],
        'metric': 'co2Reduced',
        'cumulative': true,
      },
      
      BadgeType.roadVeteran: {
        'name': 'Road Veteran',
        'description': 'Complete trips with the app',
        'levels': [
          {'threshold': 10, 'description': 'Complete 10 trips with the app'},
          {'threshold': 50, 'description': 'Complete 50 trips with the app'},
          {'threshold': 100, 'description': 'Complete 100 trips with the app'},
        ],
        'metric': 'tripCount',
        'cumulative': true,
      },
      
      BadgeType.speedMaster: {
        'name': 'Speed Master',
        'description': 'Maintain optimal speed during trips',
        'levels': [
          {'threshold': 10, 'description': 'Maintain optimal speed for 10 minutes continuously'},
          {'threshold': 30, 'description': 'Maintain optimal speed for 30 minutes continuously'},
          {'threshold': 60, 'description': 'Maintain optimal speed for 60 minutes continuously'},
        ],
        'metric': 'speedOptimizationScore',
        'minScore': 85,
      },
      
      BadgeType.ecoExpert: {
        'name': 'Eco Expert',
        'description': 'Achieve excellent overall eco-score',
        'levels': [
          {'threshold': 85, 'description': 'Achieve an overall eco-score of 85+'},
          {'threshold': 90, 'description': 'Achieve an overall eco-score of 90+'},
          {'threshold': 95, 'description': 'Achieve an overall eco-score of 95+'},
        ],
        'metric': 'overallScore',
        'highest': true,
      },
      
      BadgeType.fuelEfficiency: {
        'name': 'Fuel Efficiency',
        'description': 'Maintain good fuel efficiency',
        'levels': [
          {'threshold': 5, 'description': 'Improve fuel efficiency by 5%'},
          {'threshold': 10, 'description': 'Improve fuel efficiency by 10%'},
          {'threshold': 20, 'description': 'Improve fuel efficiency by 20%'},
        ],
        'metric': 'fuelEfficiencyImprovement',
      },
      
      BadgeType.consistentDriver: {
        'name': 'Consistent Driver',
        'description': 'Maintain consistent eco-driving habits',
        'levels': [
          {'threshold': 5, 'description': 'Maintain 80+ eco-score for 5 days in a row'},
          {'threshold': 14, 'description': 'Maintain 80+ eco-score for 14 days in a row'},
          {'threshold': 30, 'description': 'Maintain 80+ eco-score for 30 days in a row'},
        ],
        'metric': 'consecutiveDaysWithGoodScore',
      },
      
      BadgeType.earlyAdopter: {
        'name': 'Early Adopter',
        'description': 'Used the app in its early stages',
        'levels': [
          {'threshold': 1, 'description': 'Started using Going50 as an early adopter'},
        ],
        'metric': 'appInstallDate',
        'special': true,
      },
      
      // New achievements
      BadgeType.firstTrip: {
        'name': 'First Journey',
        'description': 'Completed your first trip with Going50',
        'levels': [
          {'threshold': 1, 'description': 'Completed your first trip with Going50 - the beginning of your eco-driving journey!'},
        ],
        'metric': 'tripCount',
        'special': true,
      },
      
      BadgeType.obdConnected: {
        'name': 'Connected Driver',
        'description': 'Successfully connected to an OBD-II adapter',
        'levels': [
          {'threshold': 1, 'description': 'Successfully connected to an OBD-II adapter - unlocking enhanced driving insights!'},
        ],
        'metric': 'obdConnected',
        'special': true,
      },
    };
  }
  
  /// Initialize the service
  Future<bool> _initialize() async {
    _logger.info('Initializing AchievementService');
    
    try {
      // Nothing special to initialize yet
      _isInitialized = true;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to initialize achievement service: $e';
      _logger.severe(_errorMessage);
      return false;
    }
  }
  
  /// Check for achievements after a trip
  Future<List<AchievementEvent>> checkAchievementsAfterTrip(Trip trip, String userId) async {
    _logger.info('Checking achievements after trip ${trip.id} for user $userId');
    
    final List<AchievementEvent> newAchievements = [];
    
    try {
      // Get user performance metrics
      final metrics = await _performanceMetricsService.getUserPerformanceMetrics(userId);
      
      if (metrics == null) {
        _logger.warning('No performance metrics found for user $userId');
        return [];
      }
      
      // Get user's existing badges
      final userBadges = await getUserBadges(userId);
      
      // Check each achievement type
      for (final entry in _achievementDefinitions.entries) {
        final badgeType = entry.key;
        final definition = entry.value;
        
        // Skip special achievements that are checked elsewhere
        if (definition['special'] == true) continue;
        
        // Get current badge level (0 if not earned yet)
        final currentLevel = _getCurrentBadgeLevel(userBadges, badgeType);
        
        // Check if user qualifies for next level
        final qualifiesForLevel = _checkQualification(
          metrics: metrics,
          badgeType: badgeType,
          definition: definition,
          currentLevel: currentLevel,
        );
        
        if (qualifiesForLevel > currentLevel) {
          // Award the new badge
          final achievementEvent = await _awardBadge(
            userId: userId,
            badgeType: badgeType,
            level: qualifiesForLevel,
            isUpgrade: currentLevel > 0,
          );
          
          if (achievementEvent != null) {
            newAchievements.add(achievementEvent);
          }
        }
      }
      
      return newAchievements;
    } catch (e) {
      _logger.severe('Error checking achievements: $e');
      return [];
    }
  }
  
  /// Check qualification for a specific badge type
  int _checkQualification({
    required Map<String, dynamic> metrics, 
    required String badgeType,
    required Map<String, dynamic> definition,
    required int currentLevel,
  }) {
    try {
      // If user already has max level, no need to check
      final levels = definition['levels'] as List;
      if (currentLevel >= levels.length) {
        return currentLevel;
      }
      
      // Get the next level to check
      final nextLevel = currentLevel + 1;
      final levelDef = levels[nextLevel - 1];
      final threshold = levelDef['threshold'] as int;
      final metric = definition['metric'] as String;
      
      // Get the metric value from performance metrics
      final dynamic metricValue = metrics[metric];
      
      if (metricValue == null) {
        _logger.warning('Metric $metric not found in performance data');
        return currentLevel;
      }
      
      // Different logic based on achievement type
      if (definition['cumulative'] == true) {
        // Cumulative achievements (like total distance)
        if (metricValue >= threshold) {
          return nextLevel;
        }
      } else if (definition['highest'] == true) {
        // Highest score achievements
        if (metricValue >= threshold) {
          return nextLevel;
        }
      } else if (definition.containsKey('minScore')) {
        // Consecutive achievements with minimum score
        final consecutiveCount = metrics['consecutive${metric.capitalize}'] ?? 0;
        if (consecutiveCount >= threshold && metricValue >= definition['minScore']) {
          return nextLevel;
        }
      } else {
        // Default check
        if (metricValue >= threshold) {
          return nextLevel;
        }
      }
      
      return currentLevel;
    } catch (e) {
      _logger.warning('Error checking qualification for $badgeType: $e');
      return currentLevel;
    }
  }
  
  /// Award a badge to a user
  Future<AchievementEvent?> _awardBadge({
    required String userId,
    required String badgeType,
    required int level,
    bool isUpgrade = false,
  }) async {
    try {
      _logger.info('Beginning award process for badge $badgeType level $level to user $userId');
      
      // Get badge definition
      final definition = _achievementDefinitions[badgeType];
      if (definition == null) {
        _logger.warning('Badge type $badgeType not found in definitions');
        return null;
      }
      
      final badgeName = definition['name'] as String;
      final levels = definition['levels'] as List;
      
      // Safety check for level boundaries
      if (level < 1 || level > levels.length) {
        _logger.warning('Invalid level $level for badge $badgeType (max level: ${levels.length})');
        // Default to level 1 if invalid
        level = 1;
      }
      
      final levelDef = levels[level - 1];
      final badgeDescription = levelDef['description'] as String;
      
      _logger.info('Creating badge data for "$badgeName" ($badgeDescription)');
      
      // Create badge data
      final badge = {
        'userId': userId,
        'badgeType': badgeType,
        'earnedDate': DateTime.now(),
        'level': level,
        'metadataJson': jsonEncode({
          'name': badgeName,
          'description': badgeDescription,
          'isUpgrade': isUpgrade,
        }),
      };
      
      // Save badge to database
      _logger.info('Saving badge $badgeType to database for user $userId');
      final savedBadge = await _dataStorageManager.saveBadge(badge);
      
      if (savedBadge == null) {
        _logger.warning('Failed to save badge $badgeType for user $userId');
        return null;
      }
      
      // Clear cache for this user
      _userBadgesCache.remove(userId);
      
      // Create achievement event
      final eventId = _uuid.v4();
      _logger.info('Creating achievement event with ID $eventId');
      
      // Create and broadcast achievement event
      final achievementEvent = AchievementEvent(
        id: eventId,
        userId: userId,
        badgeType: badgeType,
        badgeName: badgeName,
        badgeDescription: badgeDescription,
        level: level,
        timestamp: DateTime.now(),
        isUpgrade: isUpgrade,
      );
      
      // Broadcast event
      _achievementEventController.add(achievementEvent);
      _logger.info('Achievement event broadcasted: $badgeType level $level');
      
      // Update any metrics if needed
      
      return achievementEvent;
    } catch (e) {
      _logger.warning('Error awarding badge: $e');
      return null;
    }
  }
  
  /// Get current level of a specific badge (0 if not earned)
  int _getCurrentBadgeLevel(List<Map<String, dynamic>> userBadges, String badgeType) {
    try {
      for (final badge in userBadges) {
        if (badge['badgeType'] == badgeType) {
          return badge['level'] as int;
        }
      }
      return 0; // Badge not earned yet
    } catch (e) {
      _logger.warning('Error getting current badge level: $e');
      return 0;
    }
  }
  
  /// Get badges for a specific user
  Future<List<Map<String, dynamic>>> getUserBadges(String userId) async {
    try {
      _logger.info('Getting badges for user $userId');
      
      // Check cache first
      if (_userBadgesCache.containsKey(userId)) {
        _logger.info('Returning ${_userBadgesCache[userId]!.length} badges from cache for user $userId');
        return List.from(_userBadgesCache[userId]!);
      }
      
      // Fetch badges from database
      _logger.info('Fetching badges from database for user $userId');
      final badges = await _dataStorageManager.getUserBadges(userId);
      _logger.info('Retrieved ${badges.length} badges from database for user $userId');
      
      // If no badges found, return empty list
      if (badges.isEmpty) {
        _logger.info('No badges found for user $userId');
        _userBadgesCache[userId] = [];
        return [];
      }
      
      // Process badges to add name and description from definitions
      final processedBadges = badges.map((badge) {
        final badgeType = badge['badgeType'] as String;
        final level = badge['level'] as int;
        
        // Extract metadata or populate from definitions
        Map<String, dynamic> metadata = {};
        if (badge['metadataJson'] != null) {
          try {
            metadata = jsonDecode(badge['metadataJson'] as String);
          } catch (e) {
            _logger.warning('Error parsing badge metadata: $e');
          }
        }
        
        // Look up in definitions if needed
        if (!metadata.containsKey('name') || !metadata.containsKey('description')) {
          final definition = _achievementDefinitions[badgeType];
          if (definition != null) {
            final levels = definition['levels'] as List;
            final levelIdx = (level - 1).clamp(0, levels.length - 1);
            
            metadata['name'] = definition['name'];
            metadata['description'] = levels[levelIdx]['description'];
          }
        }
        
        // Merge metadata into badge
        return {
          ...badge,
          'name': metadata['name'] ?? 'Unknown Badge',
          'description': metadata['description'] ?? 'No description available',
        };
      }).toList();
      
      // Cache the results
      _userBadgesCache[userId] = processedBadges;
      _logger.info('Cached ${processedBadges.length} badges for user $userId');
      
      return processedBadges;
    } catch (e) {
      _logger.severe('Error getting user badges: $e');
      return [];
    }
  }
  
  /// Get all available badge types with descriptions
  List<Map<String, dynamic>> getAvailableBadgeTypes() {
    return _achievementDefinitions.entries.map((entry) {
      final badgeType = entry.key;
      final definition = entry.value;
      
      return {
        'badgeType': badgeType,
        'name': definition['name'],
        'description': definition['description'],
        'levels': definition['levels'],
      };
    }).toList();
  }
  
  /// Get a user's progress towards a specific badge type
  /// Returns a value between 0.0 and 1.0 representing progress percentage
  Future<double?> getBadgeProgress(String userId, String badgeType) async {
    try {
      _logger.info('Getting progress for badge $badgeType for user $userId');
      
      // Get the badge definition
      final definition = _achievementDefinitions[badgeType];
      if (definition == null) {
        _logger.warning('Badge type $badgeType not found in definitions');
        return null;
      }
      
      // Get current badge level (0 if not earned yet)
      final userBadges = await getUserBadges(userId);
      final currentLevel = _getCurrentBadgeLevel(userBadges, badgeType);
      
      // If user already has max level, return 1.0 (100%)
      final levels = definition['levels'] as List;
      if (currentLevel >= levels.length) {
        return 1.0;
      }
      
      // Get the next level to check
      final nextLevel = currentLevel + 1;
      final levelDef = levels[nextLevel - 1];
      final threshold = levelDef['threshold'] as int;
      final metric = definition['metric'] as String;
      
      // Get user's performance metrics
      final metrics = await _performanceMetricsService.getUserPerformanceMetrics(userId);
      if (metrics == null) {
        _logger.warning('No performance metrics found for user $userId');
        return 0.0;
      }
      
      // Get the metric value
      final dynamic metricValue = metrics[metric];
      if (metricValue == null) {
        _logger.warning('Metric $metric not found in performance data');
        return 0.0;
      }
      
      // Calculate progress based on achievement type
      double progress = 0.0;
      
      if (definition['cumulative'] == true) {
        // Cumulative achievements (like total distance)
        progress = (metricValue / threshold).clamp(0.0, 1.0);
      } else if (definition['highest'] == true) {
        // Highest score achievements
        progress = (metricValue / threshold).clamp(0.0, 1.0);
      } else if (definition.containsKey('minScore')) {
        // Consecutive achievements with minimum score
        final consecutiveCount = metrics['consecutive${metric.capitalize}'] ?? 0;
        progress = (consecutiveCount / threshold).clamp(0.0, 1.0);
      } else {
        // Default calculation
        progress = (metricValue / threshold).clamp(0.0, 1.0);
      }
      
      _logger.info('Progress for badge $badgeType: $progress');
      return progress;
    } catch (e) {
      _logger.warning('Error getting badge progress: $e');
      return 0.0;
    }
  }
  
  /// Award special badges triggered by special events
  Future<AchievementEvent?> awardSpecialBadge(String userId, String badgeType) async {
    try {
      _logger.info('Starting award process for special badge $badgeType to user $userId');
      
      if (!_achievementDefinitions.containsKey(badgeType)) {
        _logger.warning('Special badge type $badgeType not found in definitions');
        return null;
      }
      
      // Check if user already has this badge
      _logger.info('Checking if user $userId already has badge $badgeType');
      final userBadges = await getUserBadges(userId);
      _logger.info('User has ${userBadges.length} badges in total');
      
      // Log all badge types the user has for debugging
      if (userBadges.isNotEmpty) {
        final userBadgeTypes = userBadges.map((b) => b['badgeType'] as String).toList();
        _logger.info('User badge types: ${userBadgeTypes.join(', ')}');
      }
      
      final currentLevel = _getCurrentBadgeLevel(userBadges, badgeType);
      _logger.info('Current level for badge $badgeType: $currentLevel');
      
      if (currentLevel > 0) {
        _logger.info('User $userId already has badge $badgeType level $currentLevel');
        return null;
      }
      
      // Award the badge
      _logger.info('Awarding badge $badgeType to user $userId');
      final achievementEvent = await _awardBadge(
        userId: userId,
        badgeType: badgeType,
        level: 1,
      );
      
      if (achievementEvent != null) {
        _logger.info('Successfully awarded badge $badgeType to user $userId');
      } else {
        _logger.warning('Failed to award badge $badgeType to user $userId');
      }
      
      return achievementEvent;
    } catch (e) {
      _logger.severe('Error awarding special badge: $e');
      return null;
    }
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _achievementEventController.close();
    super.dispose();
  }
}

/// String extension for capitalization
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
} 