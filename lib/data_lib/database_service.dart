import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:logging/logging.dart';
import 'package:going50/core_models/user_profile.dart';

// Models
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/core_models/driver_performance_metrics.dart';
import 'package:going50/core_models/driving_event.dart';
import 'package:going50/core_models/data_privacy_settings.dart';
import 'package:going50/core_models/social_models.dart';
import 'package:going50/core_models/gamification_models.dart';

part 'database_service.g.dart';

// Tables
class TripsTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get distanceKm => real().nullable()();
  RealColumn get averageSpeedKmh => real().nullable()();
  RealColumn get maxSpeedKmh => real().nullable()();
  RealColumn get fuelUsedL => real().nullable()();
  IntColumn get idlingEvents => integer().nullable()();
  IntColumn get aggressiveAccelerationEvents => integer().nullable()();
  IntColumn get hardBrakingEvents => integer().nullable()();
  IntColumn get excessiveSpeedEvents => integer().nullable()();
  IntColumn get stopEvents => integer().nullable()();
  RealColumn get averageRPM => real().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get ecoScore => integer().nullable()(); // Overall eco-score for the trip
  TextColumn get routeDataJson => text().nullable()(); // Simplified storage of route as GeoJSON
  TextColumn get userId => text().nullable()(); // Link to user profile
  
  @override
  Set<Column> get primaryKey => {id};
}

class TripDataPointsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tripId => text().references(TripsTable, #id)();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get speed => real().nullable()(); // km/h
  RealColumn get acceleration => real().nullable()(); // m/s^2
  RealColumn get rpm => real().nullable()();
  RealColumn get throttlePosition => real().nullable()(); // percentage
  RealColumn get engineLoad => real().nullable()(); // percentage
  RealColumn get fuelRate => real().nullable()(); // L/h
  TextColumn get rawDataJson => text().nullable()(); // All other data as JSON
}

class DrivingEventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tripId => text().references(TripsTable, #id)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get eventType => text()(); // e.g., 'hard_braking', 'aggressive_acceleration'
  RealColumn get severity => real().withDefault(const Constant(1.0))(); // 0.0 to 1.0
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get detailsJson => text().nullable()(); // Additional event details as JSON
}

class UserProfilesTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastUpdatedAt => dateTime()();
  BoolColumn get isPublic => boolean().withDefault(const Constant(false))();
  BoolColumn get allowDataUpload => boolean().withDefault(const Constant(false))();
  TextColumn get preferencesJson => text().nullable()(); // User preferences as JSON
  
  @override
  Set<Column> get primaryKey => {id};
}

class PerformanceMetricsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  DateTimeColumn get generatedAt => dateTime()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  IntColumn get totalTrips => integer()();
  RealColumn get totalDistanceKm => real()();
  RealColumn get totalDrivingTimeMinutes => real()();
  RealColumn get averageSpeedKmh => real()();
  RealColumn get estimatedFuelSavingsPercent => real().nullable()();
  RealColumn get estimatedCO2ReductionKg => real().nullable()();
  IntColumn get calmDrivingScore => integer().nullable()();
  IntColumn get speedOptimizationScore => integer().nullable()();
  IntColumn get idlingScore => integer().nullable()();
  IntColumn get shortDistanceScore => integer().nullable()();
  IntColumn get rpmManagementScore => integer().nullable()();
  IntColumn get stopManagementScore => integer().nullable()();
  IntColumn get followDistanceScore => integer().nullable()();
  IntColumn get overallScore => integer()();
  TextColumn get improvementTipsJson => text().nullable()(); // Tips as JSON array
}

class BadgesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get badgeType => text()(); // e.g., 'eco_master', 'smooth_driver'
  DateTimeColumn get earnedDate => dateTime()();
  IntColumn get level => integer().withDefault(const Constant(1))(); // Badge level
  TextColumn get metadataJson => text().nullable()(); // Additional badge data
}

// New tables for data model extensions

class DataPrivacySettingsTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get dataType => text()(); // 'trips', 'location', 'driving_events', etc.
  BoolColumn get allowLocalStorage => boolean().withDefault(const Constant(true))();
  BoolColumn get allowCloudSync => boolean().withDefault(const Constant(false))();
  BoolColumn get allowSharing => boolean().withDefault(const Constant(false))();
  BoolColumn get allowAnonymizedAnalytics => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class SocialConnectionsTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get connectedUserId => text().references(UserProfilesTable, #id)();
  TextColumn get connectionType => text()(); // 'friend', 'following'
  DateTimeColumn get connectedSince => dateTime()();
  BoolColumn get isMutual => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class SocialInteractionsTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get contentType => text()(); // 'trip', 'achievement', 'milestone'
  TextColumn get contentId => text()(); // ID of the related content
  TextColumn get interactionType => text()(); // 'like', 'comment', 'share'
  TextColumn get content => text().nullable()(); // For comments, etc.
  DateTimeColumn get timestamp => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class FriendRequestsTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get fromUserId => text().references(UserProfilesTable, #id)();
  TextColumn get toUserId => text().references(UserProfilesTable, #id)();
  DateTimeColumn get requestedAt => dateTime()();
  TextColumn get status => text()(); // 'pending', 'accepted', 'rejected', 'cancelled'
  
  @override
  Set<Column> get primaryKey => {id};
}

class UserBlocksTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get blockedUserId => text().references(UserProfilesTable, #id)();
  DateTimeColumn get blockedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class SharedContentTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get contentType => text()(); // 'trip', 'achievement', 'ecoScore'
  TextColumn get contentId => text()(); // ID of the shared content
  TextColumn get shareType => text()(); // 'public', 'friends', 'external'
  TextColumn get externalPlatform => text().nullable()(); // If external, where it was shared
  TextColumn get shareUrl => text().nullable()(); // Public URL if generated
  DateTimeColumn get sharedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class UserPreferencesTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get preferenceCategory => text()(); // 'feedback', 'gamification', 'ui', etc.
  TextColumn get preferenceName => text()();
  TextColumn get preferenceValue => text()(); // JSON-encoded value
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class FeedbackEffectivenessTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get feedbackType => text()(); // 'gentle_reminder', 'direct_instruction', 'positive_reinforcement'
  TextColumn get drivingBehaviorType => text()(); // 'acceleration', 'speed', 'idling', etc.
  IntColumn get timesDelivered => integer().withDefault(const Constant(0))();
  IntColumn get timesBehaviorImproved => integer().withDefault(const Constant(0))();
  RealColumn get effectivenessRatio => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastUpdated => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class ChallengesTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get type => text()(); // 'daily', 'weekly', 'achievement'
  IntColumn get targetValue => integer()();
  TextColumn get metricType => text()(); // 'calmDriving', 'idling', etc.
  BoolColumn get isSystem => boolean().withDefault(const Constant(true))();
  TextColumn get creatorId => text().nullable().references(UserProfilesTable, #id)(); // If user-created
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get difficultyLevel => integer().withDefault(const Constant(1))(); // 1-5
  TextColumn get iconName => text().nullable()();
  TextColumn get rewardType => text().nullable()(); // Points, badge, etc.
  IntColumn get rewardValue => integer().withDefault(const Constant(0))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class UserChallengesTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get challengeId => text().references(ChallengesTable, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get rewardClaimed => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class StreaksTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get streakType => text()(); // 'daily_drive', 'eco_score', etc.
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  IntColumn get bestCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastRecorded => dateTime()();
  DateTimeColumn get nextDue => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class LeaderboardEntriesTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get leaderboardType => text()(); // 'global', 'regional', 'friends'
  TextColumn get timeframe => text()(); // 'daily', 'weekly', 'monthly', 'alltime'
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get regionCode => text().nullable()(); // Optional region
  IntColumn get rank => integer()();
  IntColumn get score => integer()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get daysRetained => integer().withDefault(const Constant(0))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class ExternalIntegrationsTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get platformType => text()(); // 'uber', 'lyft', 'applecarplay', etc.
  TextColumn get externalId => text().nullable()();
  TextColumn get integrationStatus => text()(); // 'active', 'pending', 'revoked'
  DateTimeColumn get connectedAt => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get accessToken => text().nullable()(); // Encrypted if needed
  TextColumn get refreshToken => text().nullable()(); // Encrypted if needed
  TextColumn get integrationDataJson => text().nullable()(); // Platform-specific settings
  
  @override
  Set<Column> get primaryKey => {id};
}

class SyncStatusTable extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().references(UserProfilesTable, #id)();
  TextColumn get entityType => text()(); // 'trip', 'badge', 'challenge', etc.
  TextColumn get entityId => text()();
  TextColumn get targetPlatform => text().nullable()(); // If syncing to specific external platform
  TextColumn get syncStatus => text()(); // 'pending', 'synced', 'failed'
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  TripsTable, 
  TripDataPointsTable, 
  DrivingEventsTable, 
  UserProfilesTable,
  PerformanceMetricsTable,
  BadgesTable,
  // New tables
  DataPrivacySettingsTable,
  SocialConnectionsTable,
  SocialInteractionsTable,
  FriendRequestsTable,
  UserBlocksTable,
  SharedContentTable,
  UserPreferencesTable,
  FeedbackEffectivenessTable,
  ChallengesTable,
  UserChallengesTable,
  StreaksTable,
  LeaderboardEntriesTable,
  ExternalIntegrationsTable,
  SyncStatusTable
])
class AppDatabase extends _$AppDatabase {
  final Logger _logger = Logger('AppDatabase');

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Incremented for the new tables
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        _logger.info('Upgrading database from version $from to $to');
        
        if (from == 1) {
          // Add new tables when upgrading from version 1
          await m.createTable(dataPrivacySettingsTable);
          await m.createTable(socialConnectionsTable);
          await m.createTable(socialInteractionsTable);
          await m.createTable(friendRequestsTable);
          await m.createTable(userBlocksTable);
          await m.createTable(sharedContentTable);
          await m.createTable(userPreferencesTable);
          await m.createTable(feedbackEffectivenessTable);
          await m.createTable(challengesTable);
          await m.createTable(userChallengesTable);
          await m.createTable(streaksTable);
          await m.createTable(leaderboardEntriesTable);
          await m.createTable(externalIntegrationsTable);
          await m.createTable(syncStatusTable);
        }
      },
      beforeOpen: (details) async {
        // Run validation or data consistency checks before opening the DB
        _logger.info('Opening database version ${details.versionNow}');
        
        // Verify foreign key constraints are enforced
        await customStatement('PRAGMA foreign_keys = ON');
        
        // Optional: Add default data when database is first created
        if (details.wasCreated) {
          _logger.info('Database was created, adding default data...');
          // Add default challenges, etc.
          await batch((batch) {
            // Example of adding default system challenges
            batch.insert(challengesTable, ChallengesTableCompanion.insert(
              id: '00000000-0000-4000-a000-000000000001', // UUID format
              title: 'Eco-Driving Novice',
              description: 'Maintain an eco-score above 70 for 5 consecutive trips',
              type: 'achievement',
              targetValue: 5,
              metricType: 'eco_score',
            ));
            
            batch.insert(challengesTable, ChallengesTableCompanion.insert(
              id: '00000000-0000-4000-a000-000000000002', // UUID format
              title: 'Smooth Operator',
              description: 'Complete a trip with zero aggressive acceleration events',
              type: 'daily',
              targetValue: 1,
              metricType: 'smooth_driving',
            ));
          });
        }
      },
    );
  }
  
  // Trip related methods
  Future<int> saveTrip(Trip trip) async {
    return into(tripsTable).insert(
      TripsTableCompanion.insert(
        id: trip.id,
        startTime: trip.startTime,
        endTime: Value(trip.endTime),
        distanceKm: Value(trip.distanceKm),
        averageSpeedKmh: Value(trip.averageSpeedKmh),
        maxSpeedKmh: Value(trip.maxSpeedKmh),
        fuelUsedL: Value(trip.fuelUsedL),
        idlingEvents: Value(trip.idlingEvents),
        aggressiveAccelerationEvents: Value(trip.aggressiveAccelerationEvents),
        hardBrakingEvents: Value(trip.hardBrakingEvents),
        excessiveSpeedEvents: Value(trip.excessiveSpeedEvents),
        stopEvents: Value(trip.stopEvents),
        averageRPM: Value(trip.averageRPM),
        isCompleted: Value(trip.isCompleted),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Stream<List<Trip>> watchAllTrips() {
    return (select(tripsTable)..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
      .watch()
      .map((rows) => rows.map(_mapToTrip).toList());
  }
  
  Future<List<Trip>> getAllTrips() {
    return (select(tripsTable)..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
      .get()
      .then((rows) => rows.map(_mapToTrip).toList());
  }
  
  Trip _mapToTrip(TripsTableData data) {
    return Trip(
      id: data.id,
      startTime: data.startTime,
      endTime: data.endTime,
      distanceKm: data.distanceKm,
      averageSpeedKmh: data.averageSpeedKmh,
      maxSpeedKmh: data.maxSpeedKmh,
      fuelUsedL: data.fuelUsedL,
      idlingEvents: data.idlingEvents,
      aggressiveAccelerationEvents: data.aggressiveAccelerationEvents,
      hardBrakingEvents: data.hardBrakingEvents,
      excessiveSpeedEvents: data.excessiveSpeedEvents,
      stopEvents: data.stopEvents,
      averageRPM: data.averageRPM,
      isCompleted: data.isCompleted,
    );
  }
  
  // Trip data points methods
  Future<int> saveTripDataPoint(String tripId, CombinedDrivingData dataPoint) async {
    // Get speed value - ensure it's double or null
    double? speedValue = dataPoint.obdData?.vehicleSpeed?.toDouble() ?? 
                        dataPoint.sensorData?.gpsSpeed;
    
    // Get acceleration value - ensure it's double or null
    double? accelValue = dataPoint.calculatedAcceleration ?? 
                        dataPoint.sensorData?.accelerationX;
    
    // RPM value - ensure it's double or null
    double? rpmValue = dataPoint.obdData?.rpm?.toDouble();
    
    // Throttle position - ensure it's double or null
    double? throttleValue = dataPoint.obdData?.throttlePosition;
    
    // Engine load - ensure it's double or null
    double? engineLoadValue = dataPoint.obdData?.engineLoad;
    
    // Fuel rate - ensure it's double or null
    double? fuelRateValue = dataPoint.obdData?.fuelRate;
    
    return into(tripDataPointsTable).insert(
      TripDataPointsTableCompanion.insert(
        tripId: tripId,
        timestamp: dataPoint.timestamp,
        latitude: Value(dataPoint.sensorData?.latitude),
        longitude: Value(dataPoint.sensorData?.longitude),
        speed: Value(speedValue),
        acceleration: Value(accelValue),
        rpm: Value(rpmValue),
        throttlePosition: Value(throttleValue),
        engineLoad: Value(engineLoadValue),
        fuelRate: Value(fuelRateValue),
        rawDataJson: Value(dataPoint.toJson().toString()),
      ),
    );
  }
  
  // Driving events methods
  Future<int> saveDrivingEvent(String tripId, DrivingEvent event) async {
    return into(drivingEventsTable).insert(
      DrivingEventsTableCompanion.insert(
        tripId: tripId,
        timestamp: event.timestamp,
        eventType: event.eventType,
        severity: Value(event.severity),
        latitude: Value(event.latitude),
        longitude: Value(event.longitude),
        detailsJson: Value(event.toJson().toString()),
      ),
    );
  }
  
  // User profile methods
  Future<void> saveUserProfile(String userId, String name, bool isPublic, bool allowDataUpload) async {
    final now = DateTime.now();
    
    // Use a transaction to ensure data consistency
    await transaction(() async {
      // First check if user already exists
      final existingUser = await (select(userProfilesTable)
        ..where((t) => t.id.equals(userId)))
        .getSingleOrNull();
        
      if (existingUser != null) {
        // Update existing user
        await (update(userProfilesTable)..where((t) => t.id.equals(userId)))
          .write(UserProfilesTableCompanion(
            name: Value(name),
            lastUpdatedAt: Value(now),
            isPublic: Value(isPublic),
            allowDataUpload: Value(allowDataUpload),
          ));
      } else {
        // Insert new user
        await into(userProfilesTable).insert(
          UserProfilesTableCompanion.insert(
            id: userId,
            name: Value(name),
            createdAt: now,
            lastUpdatedAt: now,
            isPublic: Value(isPublic),
            allowDataUpload: Value(allowDataUpload),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
  
  /// Get a user profile by ID
  Future<UserProfile?> getUserProfileById(String userId) async {
    final query = select(userProfilesTable)
      ..where((t) => t.id.equals(userId));
    
    final result = await query.getSingleOrNull();
    
    if (result == null) {
      return null;
    }
    
    return UserProfile(
      id: result.id,
      name: result.name ?? 'Anonymous',
      createdAt: result.createdAt,
      lastUpdatedAt: result.lastUpdatedAt,
      isPublic: result.isPublic,
      allowDataUpload: result.allowDataUpload,
      preferences: result.preferencesJson != null ? jsonDecode(result.preferencesJson!) : null,
    );
  }
  
  // Badge-related methods
  
  /// Save a badge for a user
  Future<void> saveBadge(
    String userId, 
    String badgeType, 
    DateTime earnedDate, 
    int level, 
    String? metadataJson
  ) async {
    // Use a transaction to ensure data consistency
    await transaction(() async {
      // Check if the badge already exists
      final existingBadge = await (select(badgesTable)
        ..where((t) => t.userId.equals(userId) & t.badgeType.equals(badgeType)))
        .getSingleOrNull();
        
      if (existingBadge != null) {
        // Only update if the new level is higher
        if (level > existingBadge.level) {
          await (update(badgesTable)
            ..where((t) => t.userId.equals(userId) & t.badgeType.equals(badgeType)))
            .write(BadgesTableCompanion(
              level: Value(level),
              earnedDate: Value(earnedDate),
              metadataJson: Value(metadataJson),
            ));
        }
      } else {
        // Insert new badge
        await into(badgesTable).insert(
          BadgesTableCompanion.insert(
            userId: userId,
            badgeType: badgeType,
            earnedDate: earnedDate,
            level: Value(level),
            metadataJson: Value(metadataJson),
          ),
        );
      }
    });
  }
  
  /// Get all badges for a user
  Future<List<BadgesTableData>> getUserBadges(String userId) async {
    final query = select(badgesTable)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.earnedDate, mode: OrderingMode.desc)]);
    
    return await query.get();
  }
  
  // Performance metrics methods
  Future<int> savePerformanceMetrics(DriverPerformanceMetrics metrics, String userId) async {
    return into(performanceMetricsTable).insert(
      PerformanceMetricsTableCompanion.insert(
        userId: userId,
        generatedAt: metrics.generatedAt,
        periodStart: metrics.periodStart,
        periodEnd: metrics.periodEnd,
        totalTrips: metrics.totalTrips,
        totalDistanceKm: metrics.totalDistanceKm,
        totalDrivingTimeMinutes: metrics.totalDrivingTimeMinutes,
        averageSpeedKmh: metrics.averageSpeedKmh,
        estimatedFuelSavingsPercent: Value(metrics.estimatedFuelSavingsL),
        estimatedCO2ReductionKg: Value(metrics.estimatedCO2ReductionKg),
        calmDrivingScore: Value(metrics.calmDrivingScore),
        speedOptimizationScore: Value(metrics.speedOptimizationScore),
        idlingScore: Value(metrics.idlingScore),
        shortDistanceScore: Value(metrics.shortDistanceScore),
        rpmManagementScore: Value(metrics.rpmManagementScore),
        stopManagementScore: Value(metrics.stopManagementScore),
        followDistanceScore: Value(metrics.followDistanceScore),
        overallScore: metrics.overallEcoScore,
        improvementTipsJson: Value(metrics.improvementRecommendations.toString()),
      ),
    );
  }
  
  /// Update trip with end details
  Future<void> updateTripWithEndDetails(
    String tripId, {
    double? distanceKm,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    double? fuelUsedL,
    int? idlingEvents,
    int? aggressiveAccelerationEvents,
    int? hardBrakingEvents,
    int? excessiveSpeedEvents,
    int? stopEvents,
    double? averageRPM,
    int? ecoScore,
  }) async {
    // Create a companion object with all the values to update
    final updateValues = TripsTableCompanion(
      endTime: Value(DateTime.now()),
      isCompleted: const Value(true),
      distanceKm: distanceKm != null ? Value(distanceKm) : const Value.absent(),
      averageSpeedKmh: averageSpeedKmh != null ? Value(averageSpeedKmh) : const Value.absent(),
      maxSpeedKmh: maxSpeedKmh != null ? Value(maxSpeedKmh) : const Value.absent(),
      fuelUsedL: fuelUsedL != null ? Value(fuelUsedL) : const Value.absent(),
      idlingEvents: idlingEvents != null ? Value(idlingEvents) : const Value.absent(),
      aggressiveAccelerationEvents: aggressiveAccelerationEvents != null ? Value(aggressiveAccelerationEvents) : const Value.absent(),
      hardBrakingEvents: hardBrakingEvents != null ? Value(hardBrakingEvents) : const Value.absent(),
      excessiveSpeedEvents: excessiveSpeedEvents != null ? Value(excessiveSpeedEvents) : const Value.absent(),
      stopEvents: stopEvents != null ? Value(stopEvents) : const Value.absent(),
      averageRPM: averageRPM != null ? Value(averageRPM) : const Value.absent(),
      ecoScore: ecoScore != null ? Value(ecoScore) : const Value.absent(),
    );
    
    // Perform the update by ID
    await (update(tripsTable)..where((t) => t.id.equals(tripId))).write(updateValues);
    
    _logger.info('Trip $tripId marked as completed');
  }
  
  // New methods for data privacy settings
  Future<int> saveDataPrivacySettings(DataPrivacySettings settings) async {
    return into(dataPrivacySettingsTable).insert(
      DataPrivacySettingsTableCompanion.insert(
        id: settings.id,
        userId: settings.userId,
        dataType: settings.dataType,
        allowLocalStorage: Value(settings.allowLocalStorage),
        allowCloudSync: Value(settings.allowCloudSync),
        allowSharing: Value(settings.allowSharing),
        allowAnonymizedAnalytics: Value(settings.allowAnonymizedAnalytics),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<DataPrivacySettings>> getDataPrivacySettingsForUser(String userId) async {
    final query = select(dataPrivacySettingsTable)
      ..where((t) => t.userId.equals(userId));
    
    final results = await query.get();
    
    return results.map((row) => DataPrivacySettings(
      id: row.id,
      userId: row.userId,
      dataType: row.dataType,
      allowLocalStorage: row.allowLocalStorage,
      allowCloudSync: row.allowCloudSync,
      allowSharing: row.allowSharing,
      allowAnonymizedAnalytics: row.allowAnonymizedAnalytics,
    )).toList();
  }
  
  // New methods for social features
  Future<int> saveSocialConnection(SocialConnection connection) async {
    return into(socialConnectionsTable).insert(
      SocialConnectionsTableCompanion.insert(
        id: connection.id,
        userId: connection.userId,
        connectedUserId: connection.connectedUserId,
        connectionType: connection.connectionType,
        connectedSince: connection.connectedSince,
        isMutual: Value(connection.isMutual),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<SocialConnection>> getSocialConnectionsForUser(String userId) async {
    final query = select(socialConnectionsTable)
      ..where((t) => t.userId.equals(userId));
    
    final results = await query.get();
    
    return results.map((row) => SocialConnection(
      id: row.id,
      userId: row.userId,
      connectedUserId: row.connectedUserId,
      connectionType: row.connectionType,
      connectedSince: row.connectedSince,
      isMutual: row.isMutual,
    )).toList();
  }
  
  // New methods for challenges
  Future<int> saveChallenge(Challenge challenge) async {
    return into(challengesTable).insert(
      ChallengesTableCompanion.insert(
        id: challenge.id,
        title: challenge.title,
        description: challenge.description,
        type: challenge.type,
        targetValue: challenge.targetValue,
        metricType: challenge.metricType,
        isSystem: Value(challenge.isSystem),
        creatorId: Value(challenge.creatorId),
        isActive: Value(challenge.isActive),
        difficultyLevel: Value(challenge.difficultyLevel),
        iconName: Value(challenge.iconName),
        rewardType: Value(challenge.rewardType),
        rewardValue: Value(challenge.rewardValue),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<Challenge>> getAllChallenges() async {
    final query = select(challengesTable)
      ..where((t) => t.isActive.equals(true));
    
    final results = await query.get();
    
    return results.map((row) => Challenge(
      id: row.id,
      title: row.title,
      description: row.description,
      type: row.type,
      targetValue: row.targetValue,
      metricType: row.metricType,
      isSystem: row.isSystem,
      creatorId: row.creatorId,
      isActive: row.isActive,
      difficultyLevel: row.difficultyLevel,
      iconName: row.iconName,
      rewardType: row.rewardType,
      rewardValue: row.rewardValue,
    )).toList();
  }
  
  // New methods for user challenges
  Future<int> saveUserChallenge(UserChallenge userChallenge) async {
    return into(userChallengesTable).insert(
      UserChallengesTableCompanion.insert(
        id: userChallenge.id,
        userId: userChallenge.userId,
        challengeId: userChallenge.challengeId,
        startedAt: userChallenge.startedAt,
        completedAt: Value(userChallenge.completedAt),
        progress: Value(userChallenge.progress),
        isCompleted: Value(userChallenge.isCompleted),
        rewardClaimed: Value(userChallenge.rewardClaimed),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<UserChallenge>> getUserChallengesForUser(String userId) async {
    final query = select(userChallengesTable)
      ..where((t) => t.userId.equals(userId));
    
    final results = await query.get();
    
    return results.map((row) => UserChallenge(
      id: row.id,
      userId: row.userId,
      challengeId: row.challengeId,
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      progress: row.progress,
      isCompleted: row.isCompleted,
      rewardClaimed: row.rewardClaimed,
    )).toList();
  }
  
  // Friend request methods
  Future<int> saveFriendRequest(String id, String fromUserId, String toUserId, DateTime requestedAt, String status) async {
    return into(friendRequestsTable).insert(
      FriendRequestsTableCompanion.insert(
        id: id,
        fromUserId: fromUserId,
        toUserId: toUserId,
        requestedAt: requestedAt,
        status: status,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<String>> getReceivedFriendRequests(String userId) async {
    final query = select(friendRequestsTable)
      ..where((t) => t.toUserId.equals(userId) & t.status.equals('pending'));
    
    final results = await query.get();
    
    return results.map((row) => row.fromUserId).toList();
  }
  
  Future<List<String>> getSentFriendRequests(String userId) async {
    final query = select(friendRequestsTable)
      ..where((t) => t.fromUserId.equals(userId) & t.status.equals('pending'));
    
    final results = await query.get();
    
    return results.map((row) => row.toUserId).toList();
  }
  
  Future<int> updateFriendRequestStatus(String fromUserId, String toUserId, String status) async {
    final query = update(friendRequestsTable)
      ..where((t) => t.fromUserId.equals(fromUserId) & t.toUserId.equals(toUserId));
      
    return query.write(FriendRequestsTableCompanion(
      status: Value(status),
    ));
  }
  
  Future<int> deleteFriendRequest(String fromUserId, String toUserId) async {
    final query = delete(friendRequestsTable)
      ..where((t) => t.fromUserId.equals(fromUserId) & t.toUserId.equals(toUserId));
      
    return query.go();
  }
  
  // Social connection management
  Future<void> removeSocialConnection(String userId, String connectedUserId, String connectionType) async {
    final query = delete(socialConnectionsTable)
      ..where((t) => t.userId.equals(userId) & 
                      t.connectedUserId.equals(connectedUserId) &
                      t.connectionType.equals(connectionType));
                      
    await query.go();
  }
  
  // User blocks methods
  Future<int> saveUserBlock(String id, String userId, String blockedUserId, DateTime blockedAt) async {
    return into(userBlocksTable).insert(
      UserBlocksTableCompanion.insert(
        id: id,
        userId: userId,
        blockedUserId: blockedUserId,
        blockedAt: blockedAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<void> removeUserBlock(String userId, String blockedUserId) async {
    final query = delete(userBlocksTable)
      ..where((t) => t.userId.equals(userId) & t.blockedUserId.equals(blockedUserId));
      
    await query.go();
  }
  
  Future<bool> isUserBlocked(String userId, String blockedUserId) async {
    final query = select(userBlocksTable)
      ..where((t) => t.userId.equals(userId) & t.blockedUserId.equals(blockedUserId));
    
    final results = await query.get();
    return results.isNotEmpty;
  }
  
  Future<List<String>> getBlockedUsers(String userId) async {
    final query = select(userBlocksTable)
      ..where((t) => t.userId.equals(userId));
    
    final results = await query.get();
    return results.map((row) => row.blockedUserId).toList();
  }
  
  // Leaderboard methods
  Future<int> saveLeaderboardEntry(LeaderboardEntry entry) async {
    return into(leaderboardEntriesTable).insert(
      LeaderboardEntriesTableCompanion.insert(
        id: entry.id,
        leaderboardType: entry.leaderboardType,
        timeframe: entry.timeframe,
        userId: entry.userId,
        regionCode: Value(entry.regionCode),
        rank: entry.rank,
        score: entry.score,
        recordedAt: entry.recordedAt,
        daysRetained: Value(entry.daysRetained),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<LeaderboardEntry>> getLeaderboardEntries(String leaderboardType, String timeframe, {String? regionCode, int limit = 100, int offset = 0}) async {
    var query = select(leaderboardEntriesTable)
      ..where((t) => t.leaderboardType.equals(leaderboardType) & t.timeframe.equals(timeframe))
      ..orderBy([(t) => OrderingTerm.asc(t.rank)])
      ..limit(limit, offset: offset);
      
    if (regionCode != null) {
      query = select(leaderboardEntriesTable)
        ..where((t) => t.leaderboardType.equals(leaderboardType) & 
                        t.timeframe.equals(timeframe) &
                        t.regionCode.equals(regionCode))
        ..orderBy([(t) => OrderingTerm.asc(t.rank)])
        ..limit(limit, offset: offset);
    }
    
    final results = await query.get();
    
    return results.map((row) => LeaderboardEntry(
      id: row.id,
      leaderboardType: row.leaderboardType,
      timeframe: row.timeframe,
      userId: row.userId,
      regionCode: row.regionCode,
      rank: row.rank,
      score: row.score,
      recordedAt: row.recordedAt,
      daysRetained: row.daysRetained,
    )).toList();
  }
  
  Future<LeaderboardEntry?> getUserLeaderboardEntry(String userId, String leaderboardType, String timeframe, {String? regionCode}) async {
    var query = select(leaderboardEntriesTable)
      ..where((t) => t.userId.equals(userId) & 
                      t.leaderboardType.equals(leaderboardType) & 
                      t.timeframe.equals(timeframe));
                      
    if (regionCode != null) {
      query = select(leaderboardEntriesTable)
        ..where((t) => t.userId.equals(userId) & 
                        t.leaderboardType.equals(leaderboardType) & 
                        t.timeframe.equals(timeframe) &
                        t.regionCode.equals(regionCode));
    }
    
    final results = await query.get();
    
    if (results.isEmpty) {
      return null;
    }
    
    final row = results.first;
    return LeaderboardEntry(
      id: row.id,
      leaderboardType: row.leaderboardType,
      timeframe: row.timeframe,
      userId: row.userId,
      regionCode: row.regionCode,
      rank: row.rank,
      score: row.score,
      recordedAt: row.recordedAt,
      daysRetained: row.daysRetained,
    );
  }
  
  // Shared content methods
  Future<int> saveSharedContent(SharedContent content) async {
    return into(sharedContentTable).insert(
      SharedContentTableCompanion.insert(
        id: content.id,
        userId: content.userId,
        contentType: content.contentType,
        contentId: content.contentId,
        shareType: content.shareType,
        externalPlatform: Value(content.externalPlatform),
        shareUrl: Value(content.shareUrl),
        sharedAt: content.sharedAt,
        isActive: Value(content.isActive),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
  
  Future<List<SharedContent>> getSharedContentForUser(String userId) async {
    final query = select(sharedContentTable)
      ..where((t) => t.userId.equals(userId) & t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.sharedAt)]);
      
    final results = await query.get();
    
    return results.map((row) => SharedContent(
      id: row.id,
      userId: row.userId,
      contentType: row.contentType,
      contentId: row.contentId,
      shareType: row.shareType,
      externalPlatform: row.externalPlatform,
      shareUrl: row.shareUrl,
      sharedAt: row.sharedAt,
      isActive: row.isActive,
    )).toList();
  }
  
  // User search method
  Future<List<UserProfile>> searchUserProfiles(String query) async {
    // Case-insensitive search for users by name, limit to 20 results
    final results = await customSelect(
      'SELECT * FROM user_profiles_table WHERE name LIKE ? LIMIT 20',
      variables: [Variable('%$query%')],
      readsFrom: {userProfilesTable},
    ).get();
    
    return results.map((row) {
      final data = userProfilesTable.map(row.data);
      return UserProfile(
        id: data.id,
        name: data.name ?? '',
        createdAt: data.createdAt,
        lastUpdatedAt: data.lastUpdatedAt,
        isPublic: data.isPublic,
        allowDataUpload: data.allowDataUpload,
      );
    }).toList();
  }
  
  // Data deletion methods
  
  /// Delete all trips for a user
  Future<int> deleteUserTrips(String userId) async {
    final query = delete(tripsTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all driving events for a user
  Future<int> deleteUserDrivingEvents(String userId) async {
    // First get all trips for this user
    final userTrips = await (select(tripsTable)..where((t) => t.userId.equals(userId))).get();
    
    // If no trips, nothing to delete
    if (userTrips.isEmpty) {
      return 0;
    }
    
    // Get all trip IDs
    final tripIds = userTrips.map((t) => t.id).toList();
    
    // Delete all driving events associated with these trips
    int deletedCount = 0;
    for (final tripId in tripIds) {
      final query = delete(drivingEventsTable)
        ..where((t) => t.tripId.equals(tripId));
      
      deletedCount += await query.go();
    }
    
    return deletedCount;
  }
  
  /// Delete all performance metrics for a user
  Future<int> deleteUserPerformanceMetrics(String userId) async {
    final query = delete(performanceMetricsTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all badges for a user
  Future<int> deleteUserBadges(String userId) async {
    final query = delete(badgesTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all privacy settings for a user
  Future<int> deleteUserDataPrivacySettings(String userId) async {
    final query = delete(dataPrivacySettingsTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all social connections for a user
  Future<int> deleteUserSocialConnections(String userId) async {
    final query = delete(socialConnectionsTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all social interactions for a user
  Future<int> deleteUserSocialInteractions(String userId) async {
    final query = delete(socialInteractionsTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all friend requests for a user
  Future<int> deleteUserFriendRequests(String userId) async {
    // Delete requests sent by user
    final query1 = delete(friendRequestsTable)
      ..where((t) => t.fromUserId.equals(userId));
    
    // Delete requests received by user
    final query2 = delete(friendRequestsTable)
      ..where((t) => t.toUserId.equals(userId));
    
    final count1 = await query1.go();
    final count2 = await query2.go();
    
    return count1 + count2;
  }
  
  /// Delete all user blocks by a user
  Future<int> deleteUserBlocks(String userId) async {
    final query = delete(userBlocksTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all shared content for a user
  Future<int> deleteUserSharedContent(String userId) async {
    final query = delete(sharedContentTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all user preferences
  Future<int> deleteUserPreferences(String userId) async {
    final query = delete(userPreferencesTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all user challenges
  Future<int> deleteUserChallenges(String userId) async {
    final query = delete(userChallengesTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all streaks for a user
  Future<int> deleteUserStreaks(String userId) async {
    final query = delete(streaksTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all leaderboard entries for a user
  Future<int> deleteUserLeaderboardEntries(String userId) async {
    final query = delete(leaderboardEntriesTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Delete all external integrations for a user
  Future<int> deleteUserExternalIntegrations(String userId) async {
    final query = delete(externalIntegrationsTable)
      ..where((t) => t.userId.equals(userId));
    
    return await query.go();
  }
  
  /// Close the database connection
  @override
  Future<void> close() async {
    return executor.close();
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [
    tripsTable,
    tripDataPointsTable,
    drivingEventsTable,
    userProfilesTable,
    dataPrivacySettingsTable,
    socialConnectionsTable,
    socialInteractionsTable,
    friendRequestsTable,
    userBlocksTable,
    sharedContentTable,
    performanceMetricsTable,
    badgesTable,
    userPreferencesTable,
    feedbackEffectivenessTable,
    challengesTable,
    userChallengesTable,
    streaksTable,
    leaderboardEntriesTable,
    externalIntegrationsTable,
    syncStatusTable
  ];
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'going50_db.sqlite'));
    return NativeDatabase(file);
  });
} 