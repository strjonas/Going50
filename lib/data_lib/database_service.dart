import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:logging/logging.dart';

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
  
  /// Close the database connection
  @override
  Future<void> close() async {
    return executor.close();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'going50_db.sqlite'));
    return NativeDatabase(file);
  });
} 