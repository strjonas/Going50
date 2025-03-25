import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/core_models/gamification_models.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/services/driving/performance_metrics_service.dart';

/// Represents a challenge event when a challenge is completed or updated
class ChallengeEvent {
  /// Unique identifier for the event
  final String id;
  
  /// User ID associated with this event
  final String userId;
  
  /// Challenge ID associated with this event
  final String challengeId;
  
  /// Title of the challenge
  final String challengeTitle;
  
  /// Current progress of the challenge
  final int progress;
  
  /// Target value of the challenge
  final int targetValue;
  
  /// Event timestamp
  final DateTime timestamp;
  
  /// Event type: 'started', 'updated', 'completed', 'reward_claimed'
  final String eventType;
  
  /// Whether the challenge is completed
  final bool isCompleted;
  
  /// Constructor
  ChallengeEvent({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.challengeTitle,
    required this.progress,
    required this.targetValue,
    required this.timestamp,
    required this.eventType,
    required this.isCompleted,
  });

  /// Convert to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'challengeId': challengeId,
      'challengeTitle': challengeTitle,
      'progress': progress,
      'targetValue': targetValue,
      'timestamp': timestamp.toIso8601String(),
      'eventType': eventType,
      'isCompleted': isCompleted,
    };
  }
}

/// Definition of the available challenge types in the app
class ChallengeType {
  /// Daily challenges that reset each day
  static const String daily = 'daily';
  
  /// Weekly challenges that reset each week
  static const String weekly = 'weekly';
  
  /// Long-term achievement challenges
  static const String achievement = 'achievement';
  
  /// Community challenges with group participation
  static const String community = 'community';
  
  /// Special event challenges available for limited times
  static const String event = 'event';
}

/// Definition of the available metric types for challenges
class MetricType {
  /// Overall eco-score value
  static const String ecoScore = 'eco_score';
  
  /// Number of trips completed
  static const String tripCount = 'trip_count';
  
  /// Total distance driven in km
  static const String distanceKm = 'distance_km';
  
  /// Number of days with at least one trip
  static const String activeDays = 'active_days';
  
  /// Calm driving score
  static const String calmDriving = 'calm_driving';
  
  /// Speed optimization score
  static const String speedOptimization = 'speed_optimization';
  
  /// Idling management score
  static const String idlingScore = 'idling_score';
  
  /// Fuel saved in liters
  static const String fuelSaved = 'fuel_saved';
  
  /// CO2 emissions reduced in kg
  static const String co2Reduced = 'co2_reduced';
  
  /// Consistent speed maintenance score
  static const String steadySpeed = 'steady_speed';
}

/// Service that manages challenges and their progress tracking.
///
/// IMPLEMENTATION NOTE:
/// This service currently uses a local-only implementation with client-side
/// challenge definitions. The current implementation uses deterministic IDs that
/// are consistent across app restarts to meet the 36-character database constraint.
///
/// MIGRATION PLAN:
/// This service will be migrated to use Firebase/server-based challenge definitions
/// during Phase 2/3 of implementation. The migration will involve:
/// 1. Fetching challenge definitions from Firestore
/// 2. Syncing user progress bidirectionally
/// 3. Supporting offline functionality with local caching
/// 4. Managing challenge lifecycle (seasonal, timed challenges)
///
/// See the MockReplacementRoadmap.md "Transition Plan" section for detailed steps.
class ChallengeService extends ChangeNotifier {
  final Logger _logger = Logger('ChallengeService');
  final DataStorageManager _dataStorageManager;
  final PerformanceMetricsService _performanceMetricsService;
  final Uuid _uuid = Uuid();
  
  // Event stream controller
  final StreamController<ChallengeEvent> _challengeEventController = 
      StreamController<ChallengeEvent>.broadcast();
  
  // Cache of available challenges and user challenges
  final Map<String, Challenge> _challengesCache = {};
  final Map<String, List<UserChallenge>> _userChallengesCache = {};
  
  // Challenge definitions with criteria
  late final List<Challenge> _systemChallenges;
  
  // Service state
  bool _isInitialized = false;
  String? _errorMessage;
  
  // Public getters
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  
  /// Stream of challenge events (when challenges are updated or completed)
  Stream<ChallengeEvent> get challengeEventStream => _challengeEventController.stream;
  
  /// Constructor
  ChallengeService(this._dataStorageManager, this._performanceMetricsService) {
    _logger.info('ChallengeService created');
    _defineSystemChallenges();
    _initialize();
  }
  
  /// Define system-provided challenges
  ///
  /// IMPLEMENTATION NOTE:
  /// This method creates hard-coded challenge definitions with 
  /// deterministic IDs that meet the 36-character database constraint.
  /// The createConsistentId() function generates IDs that are consistent
  /// across app restarts while preserving the descriptive ID structure.
  ///
  /// In the server-based implementation, this method will be replaced with
  /// code that fetches challenge definitions from Firebase/backend API.
  /// See MockReplacementRoadmap.md "Transition Plan" for migration details.
  void _defineSystemChallenges() {
    // Helper function to create consistent IDs that meet the 36-char requirement
    String createConsistentId(String shortId) {
      // Pad the ID to ensure it's always 36 characters
      // Format: original_id + underscore + padding_characters_to_reach_36
      const String padding = "0123456789abcdef0123456789abcdef0123456789";
      final int padLength = 36 - shortId.length - 1; // -1 for the underscore
      
      if (padLength <= 0) {
        // Already 36+ characters (shouldn't happen with our current IDs)
        return shortId;
      }
      
      return "$shortId${"_"}${padding.substring(0, padLength)}";
    }
    
    _systemChallenges = [
      // Daily challenges
      Challenge(
        id: createConsistentId('daily_eco_score_75'),
        title: 'Green Commuter',
        description: 'Achieve at least 75 eco-score on a trip today',
        type: ChallengeType.daily,
        targetValue: 75,
        metricType: MetricType.ecoScore,
        iconName: 'eco',
        rewardType: 'points',
        rewardValue: 50,
      ),
      Challenge(
        id: createConsistentId('daily_calm_driving_80'),
        title: 'Zen Driver',
        description: 'Maintain a calm driving score of 80+ today',
        type: ChallengeType.daily,
        targetValue: 80,
        metricType: MetricType.calmDriving,
        iconName: 'mood',
        rewardType: 'points',
        rewardValue: 50,
      ),
      Challenge(
        id: createConsistentId('daily_idle_reduction'),
        title: 'Idle Buster',
        description: 'Keep idling time under 3 minutes for all trips today',
        type: ChallengeType.daily,
        targetValue: 90,
        metricType: MetricType.idlingScore,
        iconName: 'timer',
        rewardType: 'points',
        rewardValue: 50,
      ),
      
      // Weekly challenges
      Challenge(
        id: createConsistentId('weekly_trips_5'),
        title: 'Regular Driver',
        description: 'Complete 5 trips this week',
        type: ChallengeType.weekly,
        targetValue: 5,
        metricType: MetricType.tripCount,
        iconName: 'repeat',
        rewardType: 'points',
        rewardValue: 100,
      ),
      Challenge(
        id: createConsistentId('weekly_distance_100'),
        title: 'Distance Champion',
        description: 'Drive 100km with eco-score above 80 this week',
        type: ChallengeType.weekly,
        targetValue: 100,
        metricType: MetricType.distanceKm,
        iconName: 'straighten',
        rewardType: 'points',
        rewardValue: 150,
      ),
      Challenge(
        id: createConsistentId('weekly_active_days_5'),
        title: 'Consistent Driver',
        description: 'Drive on 5 different days this week',
        type: ChallengeType.weekly,
        targetValue: 5,
        metricType: MetricType.activeDays,
        iconName: 'event_available',
        rewardType: 'points',
        rewardValue: 125,
      ),
      
      // Achievement challenges
      Challenge(
        id: createConsistentId('achievement_fuel_saved_20'),
        title: 'Fuel Miser',
        description: 'Save 20 liters of fuel through eco-driving',
        type: ChallengeType.achievement,
        targetValue: 20,
        metricType: MetricType.fuelSaved,
        iconName: 'local_gas_station',
        difficultyLevel: 3,
        rewardType: 'badge',
        rewardValue: 1,
      ),
      Challenge(
        id: createConsistentId('achievement_co2_reduced_50'),
        title: 'Climate Guardian',
        description: 'Reduce CO2 emissions by 50kg',
        type: ChallengeType.achievement,
        targetValue: 50,
        metricType: MetricType.co2Reduced,
        iconName: 'eco',
        difficultyLevel: 3,
        rewardType: 'badge',
        rewardValue: 1,
      ),
      Challenge(
        id: createConsistentId('achievement_trips_100'),
        title: 'Century Driver',
        description: 'Complete 100 trips with the app',
        type: ChallengeType.achievement,
        targetValue: 100,
        metricType: MetricType.tripCount,
        iconName: 'directions_car',
        difficultyLevel: 4,
        rewardType: 'badge',
        rewardValue: 1,
      ),
      Challenge(
        id: createConsistentId('achievement_perfect_week'),
        title: 'Perfect Week',
        description: 'Complete all daily challenges for 7 consecutive days',
        type: ChallengeType.achievement,
        targetValue: 7,
        metricType: 'consecutive_days',
        iconName: 'stars',
        difficultyLevel: 5,
        rewardType: 'badge',
        rewardValue: 2,
      ),
    ];
  }
  
  /// Initialize the service and ensure system challenges exist
  Future<void> _initialize() async {
    // TODO: During server migration, update this method to fetch challenges from Firebase
    // and implement local caching with offline support. See MockReplacementRoadmap.md.
    
    try {
      _logger.info('Initializing ChallengeService');
      
      // Load existing challenges from database
      final existingChallenges = await _dataStorageManager.getAllChallenges();
      
      // Add challenges to cache
      for (final challenge in existingChallenges) {
        _challengesCache[challenge.id] = challenge;
      }
      
      // Ensure system challenges exist
      for (final systemChallenge in _systemChallenges) {
        if (!_challengesCache.containsKey(systemChallenge.id)) {
          await _dataStorageManager.saveChallenge(systemChallenge);
          _challengesCache[systemChallenge.id] = systemChallenge;
          _logger.info('Created system challenge: ${systemChallenge.title}');
        }
      }
      
      _isInitialized = true;
      _logger.info('ChallengeService initialized successfully');
    } catch (e) {
      _errorMessage = 'Failed to initialize challenge service: $e';
      _logger.severe(_errorMessage);
    }
  }
  
  /// Get all active challenges
  Future<List<Challenge>> getAllChallenges() async {
    if (!_isInitialized) await _initialize();
    
    try {
      // If cache is empty, reload from database
      if (_challengesCache.isEmpty) {
        final challenges = await _dataStorageManager.getAllChallenges();
        for (final challenge in challenges) {
          _challengesCache[challenge.id] = challenge;
        }
      }
      
      return _challengesCache.values.where((c) => c.isActive).toList();
    } catch (e) {
      _logger.warning('Error getting challenges: $e');
      return [];
    }
  }
  
  /// Get challenges of a specific type
  Future<List<Challenge>> getChallengesByType(String type) async {
    final allChallenges = await getAllChallenges();
    return allChallenges.where((c) => c.type == type).toList();
  }
  
  /// Get challenges for a specific user
  Future<List<UserChallenge>> getUserChallenges(String userId) async {
    if (!_isInitialized) await _initialize();
    
    try {
      // Check cache first
      if (_userChallengesCache.containsKey(userId)) {
        return List.from(_userChallengesCache[userId]!);
      }
      
      // Fetch all user challenges from database
      final userChallenges = await _dataStorageManager.getUserChallenges();
      
      // Filter challenges for the current user
      final filteredChallenges = userChallenges
          .where((uc) => uc.userId == userId)
          .toList();
      
      // Cache the results
      _userChallengesCache[userId] = filteredChallenges;
      
      return filteredChallenges;
    } catch (e) {
      _logger.warning('Error getting user challenges: $e');
      return [];
    }
  }
  
  /// Invalidate the user challenges cache for a specific user
  /// This is used to ensure fresh data is loaded after a challenge is joined
  Future<void> invalidateUserChallengesCache(String userId) async {
    _logger.info('Invalidating user challenges cache for user: $userId');
    _userChallengesCache.remove(userId);
  }
  
  /// Get user challenges of a specific type
  Future<List<UserChallenge>> getUserChallengesByType(String userId, String type) async {
    final allChallenges = await getAllChallenges();
    final userChallenges = await getUserChallenges(userId);
    
    // Get the challenge IDs of the specified type
    final challengeIds = allChallenges
        .where((c) => c.type == type)
        .map((c) => c.id)
        .toSet();
    
    // Filter user challenges by those IDs
    return userChallenges
        .where((uc) => challengeIds.contains(uc.challengeId))
        .toList();
  }
  
  /// Get a specific challenge by ID
  Future<Challenge?> _getChallenge(String challengeId) async {
    // First check in cache
    if (_challengesCache.containsKey(challengeId)) {
      return _challengesCache[challengeId];
    }
    
    try {
      // Get all challenges if not in cache
      final challenges = await getAllChallenges();
      
      // Find matching challenge
      for (final challenge in challenges) {
        if (challenge.id == challengeId) {
          return challenge;
        }
      }
      
      _logger.warning('Challenge not found with ID: $challengeId');
      return null;
    } catch (e) {
      _logger.warning('Error getting challenge with ID $challengeId: $e');
      return null;
    }
  }
  
  /// Start a challenge for a user
  Future<UserChallenge?> startChallenge(String userId, String challengeId) async {
    if (!_isInitialized) await _initialize();
    
    try {
      // Get the challenge
      final challenge = _challengesCache[challengeId];
      if (challenge == null) {
        _logger.warning('Challenge not found with ID: $challengeId');
        return null;
      }
      
      _logger.info('Starting challenge for user $userId: ${challenge.title} (ID: $challengeId)');
      
      // Check if user already has this challenge
      final userChallenges = await getUserChallenges(userId);
      _logger.info('User has ${userChallenges.length} existing challenges');
      
      // Check if the user already has this challenge
      UserChallenge? existingActiveChallenge;
      for (final uc in userChallenges) {
        if (uc.challengeId == challengeId && !uc.isCompleted) {
          existingActiveChallenge = uc;
          break;
        }
      }
      
      // If active challenge found, return it
      if (existingActiveChallenge != null) {
        _logger.info('User $userId already has an active challenge: $challengeId');
        return existingActiveChallenge;
      }
      
      // Check if this challenge was completed before
      UserChallenge? existingCompletedChallenge;
      for (final uc in userChallenges) {
        if (uc.challengeId == challengeId && uc.isCompleted) {
          existingCompletedChallenge = uc;
          break;
        }
      }
      
      // If challenge exists but is completed, check if it's a repeatable type
      if (existingCompletedChallenge != null) {
        _logger.info('User $userId has completed this challenge before');
        
        if (challenge.type == ChallengeType.daily || challenge.type == ChallengeType.weekly) {
          // Create a new instance of the challenge
          _logger.info('Creating new instance of repeatable challenge type: ${challenge.type}');
          
          final newChallenge = UserChallenge(
            id: _uuid.v4(),
            userId: userId,
            challengeId: challengeId,
            startedAt: DateTime.now(),
          );
          
          await _dataStorageManager.saveUserChallenge(newChallenge);
          _logger.info('Saved new repeatable challenge instance to database');
          
          // Clear cache
          _userChallengesCache.remove(userId);
          
          // Create and broadcast event
          final event = ChallengeEvent(
            id: _uuid.v4(),
            userId: userId,
            challengeId: challengeId,
            challengeTitle: challenge.title,
            progress: 0,
            targetValue: challenge.targetValue,
            timestamp: DateTime.now(),
            eventType: 'started',
            isCompleted: false,
          );
          
          _challengeEventController.add(event);
          _logger.info('User $userId started challenge: ${challenge.title}');
          
          return newChallenge;
        } else {
          // Achievement challenges can only be completed once
          _logger.info('Challenge $challengeId already completed by user $userId and is not repeatable');
          return existingCompletedChallenge;
        }
      }
      
      // This is a new challenge the user hasn't started before
      _logger.info('Creating new challenge for user $userId: ${challenge.title}');
      
      // Create new challenge
      final newChallenge = UserChallenge(
        id: _uuid.v4(),
        userId: userId,
        challengeId: challengeId,
        startedAt: DateTime.now(),
      );
      
      // Save the new challenge
      await _dataStorageManager.saveUserChallenge(newChallenge);
      _logger.info('Saved new challenge to database with ID: ${newChallenge.id}');
      
      // Clear cache
      _userChallengesCache.remove(userId);
      
      // Create and broadcast event
      final event = ChallengeEvent(
        id: _uuid.v4(),
        userId: userId,
        challengeId: challengeId,
        challengeTitle: challenge.title,
        progress: 0,
        targetValue: challenge.targetValue,
        timestamp: DateTime.now(),
        eventType: 'started',
        isCompleted: false,
      );
      
      _challengeEventController.add(event);
      _logger.info('User $userId started challenge: ${challenge.title}');
      
      return newChallenge;
    } catch (e) {
      _logger.severe('Error starting challenge: $e');
      return null;
    }
  }
  
  /// Update progress on a challenge
  Future<UserChallenge?> updateChallengeProgress(
    String userId, 
    String challengeId, 
    int progress
  ) async {
    if (!_isInitialized) await _initialize();
    
    try {
      // Get the challenge
      final challenge = _challengesCache[challengeId];
      if (challenge == null) {
        _logger.warning('Challenge not found with ID: $challengeId');
        return null;
      }
      
      // Get user challenges
      final userChallenges = await getUserChallenges(userId);
      
      // Look for an existing active challenge
      UserChallenge? existingChallenge;
      for (final uc in userChallenges) {
        if (uc.challengeId == challengeId && !uc.isCompleted) {
          existingChallenge = uc;
          break;
        }
      }
      
      // If no active challenge found, start a new one
      if (existingChallenge == null) {
        _logger.info('No active challenge found, starting a new one');
        existingChallenge = UserChallenge(
          id: _uuid.v4(),
          userId: userId,
          challengeId: challengeId,
          startedAt: DateTime.now(),
        );
        
        // Save the new challenge
        await _dataStorageManager.saveUserChallenge(existingChallenge);
        _logger.info('Saved new challenge to database with ID: ${existingChallenge.id}');
      }
      
      // Update progress
      final wasCompleted = existingChallenge.isCompleted;
      final updatedChallenge = existingChallenge.copyWithProgress(
        progress, 
        challenge.targetValue
      );
      
      // Save updated challenge
      await _dataStorageManager.saveUserChallenge(updatedChallenge);
      
      // Clear cache
      _userChallengesCache.remove(userId);
      
      // Determine event type
      String eventType = 'updated';
      if (!wasCompleted && updatedChallenge.isCompleted) {
        eventType = 'completed';
      }
      
      // Create and broadcast event
      final event = ChallengeEvent(
        id: _uuid.v4(),
        userId: userId,
        challengeId: challengeId,
        challengeTitle: challenge.title,
        progress: updatedChallenge.progress,
        targetValue: challenge.targetValue,
        timestamp: DateTime.now(),
        eventType: eventType,
        isCompleted: updatedChallenge.isCompleted,
      );
      
      _challengeEventController.add(event);
      
      // Log progress update
      if (eventType == 'completed') {
        _logger.info('User $userId completed challenge: ${challenge.title}');
      } else {
        _logger.info('User $userId updated progress on challenge: ${challenge.title} to ${updatedChallenge.progress}/${challenge.targetValue}');
      }
      
      return updatedChallenge;
    } catch (e) {
      _logger.severe('Error updating challenge progress: $e');
      return null;
    }
  }
  
  /// Claim reward for a completed challenge
  Future<bool> claimChallengeReward(String userId, String challengeId) async {
    if (!_isInitialized) await _initialize();
    
    try {
      // Get the challenge
      final challenge = _challengesCache[challengeId];
      if (challenge == null) {
        _logger.warning('Challenge not found with ID: $challengeId');
        return false;
      }
      
      // Get user challenges
      final userChallenges = await getUserChallenges(userId);
      final existingChallenge = userChallenges.firstWhere(
        (uc) => uc.challengeId == challengeId && uc.isCompleted && !uc.rewardClaimed,
        orElse: () => UserChallenge(
          id: _uuid.v4(),
          userId: userId,
          challengeId: challengeId,
          startedAt: DateTime.now(),
          isCompleted: false,
        ),
      );
      
      // Check if challenge is completed and reward not claimed
      if (!existingChallenge.isCompleted || existingChallenge.rewardClaimed) {
        _logger.warning('Challenge $challengeId not eligible for reward claim');
        return false;
      }
      
      // Update challenge to mark reward as claimed
      final updatedChallenge = existingChallenge.copyWithRewardClaimed();
      
      // Save updated challenge
      await _dataStorageManager.saveUserChallenge(updatedChallenge);
      
      // Clear cache
      _userChallengesCache.remove(userId);
      
      // Create and broadcast event
      final event = ChallengeEvent(
        id: _uuid.v4(),
        userId: userId,
        challengeId: challengeId,
        challengeTitle: challenge.title,
        progress: updatedChallenge.progress,
        targetValue: challenge.targetValue,
        timestamp: DateTime.now(),
        eventType: 'reward_claimed',
        isCompleted: true,
      );
      
      _challengeEventController.add(event);
      _logger.info('User $userId claimed reward for challenge: ${challenge.title}');
      
      // Here you would apply the reward to the user
      // This could involve updating points, awarding badges, etc.
      // For now, we'll just assume this happens successfully
      
      return true;
    } catch (e) {
      _logger.severe('Error claiming challenge reward: $e');
      return false;
    }
  }
  
  /// Create a custom challenge
  Future<Challenge?> createCustomChallenge(Challenge challenge, String creatorId) async {
    if (!_isInitialized) await _initialize();
    
    try {
      // Verify challenge has required fields
      if (challenge.title.isEmpty || 
          challenge.description.isEmpty || 
          challenge.targetValue <= 0) {
        _logger.warning('Invalid challenge data');
        return null;
      }
      
      // Create new challenge with UUID
      final newChallenge = challenge.copyWith(
        id: _uuid.v4(),
        isSystem: false,
        creatorId: creatorId,
      );
      
      // Save to database
      await _dataStorageManager.saveChallenge(newChallenge);
      
      // Add to cache
      _challengesCache[newChallenge.id] = newChallenge;
      
      _logger.info('Created custom challenge: ${newChallenge.title}');
      return newChallenge;
    } catch (e) {
      _logger.severe('Error creating custom challenge: $e');
      return null;
    }
  }
  
  /// Check for challenge updates after a trip
  Future<void> checkChallengesAfterTrip(Trip trip, String userId) async {
    if (!_isInitialized) await _initialize();
    
    try {
      _logger.info('Checking challenges after trip ${trip.id} for user $userId');
      
      // Get all active challenges for the user
      final challenges = await getAllChallenges();
      final userChallenges = await getUserChallenges(userId);
      
      // Get all trip history to calculate metrics
      final allTrips = await _dataStorageManager.getAllTrips();
      
      // Filter for user's trips
      final userTrips = allTrips.where((t) => t.userId == userId).toList();
      
      // Calculate basic metrics
      int totalTrips = userTrips.length;
      double totalDistanceKm = 0;
      int completedTrips = 0;
      
      for (var t in userTrips) {
        if (t.distanceKm != null) {
          totalDistanceKm += t.distanceKm!;
        }
        if (t.isCompleted) {
          completedTrips++;
        }
      }
      
      // Process each challenge
      for (final challenge in challenges) {
        // Look for an existing active challenge
        UserChallenge? existingUserChallenge;
        for (final uc in userChallenges) {
          if (uc.challengeId == challenge.id && !uc.isCompleted) {
            existingUserChallenge = uc;
            break;
          }
        }
        
        // If this is a new challenge the user doesn't have yet, create and save it
        if (existingUserChallenge == null) {
          existingUserChallenge = UserChallenge(
            id: _uuid.v4(),
            userId: userId,
            challengeId: challenge.id,
            startedAt: DateTime.now(),
          );
          
          await _dataStorageManager.saveUserChallenge(existingUserChallenge);
          _userChallengesCache.remove(userId);
          _logger.info('Created new challenge for user: ${challenge.title}');
        }
        
        // Determine current progress based on metric type
        int progress = existingUserChallenge.progress;
        
        switch (challenge.metricType) {
          case MetricType.ecoScore:
            // We'll assume the AnalyticsService provides this via DrivingService
            // For now, use a simple heuristic based on events
            if (trip.hardBrakingEvents != null && 
                trip.aggressiveAccelerationEvents != null) {
              int totalEvents = (trip.hardBrakingEvents ?? 0) + 
                           (trip.aggressiveAccelerationEvents ?? 0);
              // Higher score if fewer events
              int estimatedScore = 100 - (totalEvents * 5);
              estimatedScore = estimatedScore.clamp(0, 100);
              
              if (estimatedScore >= challenge.targetValue) {
                progress = challenge.targetValue;
              }
            }
            break;
            
          case MetricType.tripCount:
            // Simply use the total number of trips
            progress = totalTrips;
            break;
            
          case MetricType.distanceKm:
            // Use total distance traveled
            progress = totalDistanceKm.toInt();
            break;
            
          case MetricType.activeDays:
            // Get number of unique days with trips
            // This would need a more sophisticated calculation
            // For now, use trip count as a proxy, clamped to max 7 days
            progress = completedTrips.clamp(0, 7);
            break;
            
          case MetricType.fuelSaved:
            // This would come from PerformanceMetricsService
            // For now, use a placeholder calculation
            double estimatedFuelSaved = totalDistanceKm * 0.01; // 1% fuel savings per km
            progress = estimatedFuelSaved.toInt();
            break;
            
          case MetricType.co2Reduced:
            // This would come from PerformanceMetricsService
            // For now, use a placeholder calculation
            double estimatedCO2Reduced = totalDistanceKm * 0.02; // 20g CO2 reduction per km
            progress = estimatedCO2Reduced.toInt();
            break;
            
          default:
            // Handle other metric types
            break;
        }
        
        // Update challenge progress if it changed
        if (progress > existingUserChallenge.progress) {
          await updateChallengeProgress(userId, challenge.id, progress);
        }
      }
      
      _logger.info('Completed challenge checking after trip ${trip.id}');
    } catch (e) {
      _logger.severe('Error checking challenges after trip: $e');
    }
  }
  
  /// Reset all daily challenges
  Future<void> resetDailyChallenges() async {
    if (!_isInitialized) await _initialize();
    
    try {
      _logger.info('Resetting daily challenges');
      
      // Get all daily challenges
      final dailyChallenges = await getChallengesByType(ChallengeType.daily);
      final dailyChallengeIds = dailyChallenges.map((c) => c.id).toSet();
      
      // Get all user challenges for daily challenges
      final allUserChallenges = await _dataStorageManager.getUserChallenges();
      final dailyUserChallenges = allUserChallenges
          .where((uc) => dailyChallengeIds.contains(uc.challengeId))
          .toList();
      
      // Group by user
      final userChallengesMap = <String, List<UserChallenge>>{};
      for (final uc in dailyUserChallenges) {
        if (!userChallengesMap.containsKey(uc.userId)) {
          userChallengesMap[uc.userId] = [];
        }
        userChallengesMap[uc.userId]!.add(uc);
      }
      
      // Process each user
      for (final userId in userChallengesMap.keys) {
        // Start new challenges for each user
        for (final challenge in dailyChallenges) {
          await startChallenge(userId, challenge.id);
        }
      }
      
      _logger.info('Daily challenges have been reset');
    } catch (e) {
      _logger.severe('Error resetting daily challenges: $e');
    }
  }
  
  /// Reset all weekly challenges
  Future<void> resetWeeklyChallenges() async {
    if (!_isInitialized) await _initialize();
    
    try {
      _logger.info('Resetting weekly challenges');
      
      // Get all weekly challenges
      final weeklyChallenges = await getChallengesByType(ChallengeType.weekly);
      final weeklyChallengeIds = weeklyChallenges.map((c) => c.id).toSet();
      
      // Get all user challenges for weekly challenges
      final allUserChallenges = await _dataStorageManager.getUserChallenges();
      final weeklyUserChallenges = allUserChallenges
          .where((uc) => weeklyChallengeIds.contains(uc.challengeId))
          .toList();
      
      // Group by user
      final userChallengesMap = <String, List<UserChallenge>>{};
      for (final uc in weeklyUserChallenges) {
        if (!userChallengesMap.containsKey(uc.userId)) {
          userChallengesMap[uc.userId] = [];
        }
        userChallengesMap[uc.userId]!.add(uc);
      }
      
      // Process each user
      for (final userId in userChallengesMap.keys) {
        // Start new challenges for each user
        for (final challenge in weeklyChallenges) {
          await startChallenge(userId, challenge.id);
        }
      }
      
      _logger.info('Weekly challenges have been reset');
    } catch (e) {
      _logger.severe('Error resetting weekly challenges: $e');
    }
  }
  
  /// Get detailed challenge with progress
  Future<Map<String, dynamic>?> getDetailedChallenge(String userId, String challengeId) async {
    if (!_isInitialized) await _initialize();
    
    try {
      // Get the challenge
      final challenge = _challengesCache[challengeId];
      if (challenge == null) {
        _logger.warning('Challenge not found with ID: $challengeId');
        return null;
      }
      
      // Get user challenge
      final userChallenges = await getUserChallenges(userId);
      
      // Look for an existing challenge
      UserChallenge? userChallenge;
      for (final uc in userChallenges) {
        if (uc.challengeId == challengeId) {
          userChallenge = uc;
          break;
        }
      }
      
      // If no user challenge found, create a template for display
      // but don't save it to the database
      if (userChallenge == null) {
        userChallenge = UserChallenge(
          id: _uuid.v4(),
          userId: userId,
          challengeId: challengeId,
          startedAt: DateTime.now(),
        );
      }
      
      // Combine challenge and user challenge info
      return {
        ...challenge.toJson(),
        'progress': userChallenge.progress,
        'isCompleted': userChallenge.isCompleted,
        'rewardClaimed': userChallenge.rewardClaimed,
        'startedAt': userChallenge.startedAt.toIso8601String(),
        'completedAt': userChallenge.completedAt?.toIso8601String(),
      };
    } catch (e) {
      _logger.severe('Error getting detailed challenge: $e');
      return null;
    }
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _challengeEventController.close();
    super.dispose();
  }
} 