import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

// Service imports
import 'package:going50/services/driving/obd_connection_service.dart';
import 'package:going50/services/driving/sensor_service.dart';
import 'package:going50/services/driving/data_collection_service.dart';
import 'package:going50/services/driving/analytics_service.dart';
import 'package:going50/services/driving/trip_service.dart';
import 'package:going50/services/permission_service.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/services/gamification/achievement_service.dart' show AchievementService, BadgeType, AchievementEvent;
import 'package:going50/services/gamification/challenge_service.dart';
import 'package:going50/services/background/background_service.dart';
import 'package:going50/services/background/notification_service.dart';

// Model imports
import 'package:going50/core_models/trip.dart';
import 'package:going50/core_models/driving_event.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';

/// DrivingStatus represents the current state of driving
enum DrivingStatus {
  /// Not ready (services not initialized)
  notReady,
  
  /// Ready to start a trip but not currently recording
  ready,
  
  /// Recording an active trip
  recording,
  
  /// Error state
  error
}

/// DrivingService acts as a facade to coordinate all driving-related services.
/// 
/// This service is responsible for:
/// - Coordinating the initialization and operation of all driving-related services
/// - Managing the overall driving state (not ready, ready, recording, error)
/// - Providing a unified interface to start/stop trips and access driving data
/// - Propagating driving events to consumers
class DrivingService extends ChangeNotifier {
  final Logger _logger = Logger('DrivingService');
  final Uuid _uuid = Uuid();
  
  // Dependencies
  final ObdConnectionService _obdConnectionService;
  final SensorService _sensorService;
  final DataCollectionService _dataCollectionService;
  final AnalyticsService _analyticsService;
  final TripService _tripService;
  late final PermissionService _permissionService;
  late final AchievementService _achievementService;
  late final ChallengeService _challengeService;
  late final NotificationService _notificationService;
  BackgroundService? _backgroundService;
  
  // Service state
  bool _isInitialized = false;
  String? _errorMessage;
  DrivingStatus _drivingStatus = DrivingStatus.notReady;
  
  // Event stream controller
  final StreamController<DrivingEvent> _drivingEventController = 
      StreamController<DrivingEvent>.broadcast();
  
  // Public getters
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  DrivingStatus get drivingStatus => _drivingStatus;
  Trip? get currentTrip => _tripService.currentTrip;
  bool get isObdConnected => _obdConnectionService.isConnected;
  bool get isCollecting => _dataCollectionService.isCollecting;
  double get currentEcoScore => _analyticsService.currentEcoScore;
  
  /// Stream of driving events combining various service events
  Stream<DrivingEvent> get drivingEventStream => _drivingEventController.stream;
  
  /// Constructor
  DrivingService(
    this._obdConnectionService,
    this._sensorService,
    this._dataCollectionService,
    this._analyticsService,
    this._tripService,
  ) {
    _logger.info('DrivingService created');
    _permissionService = serviceLocator<PermissionService>();
    _achievementService = serviceLocator<AchievementService>();
    _challengeService = serviceLocator<ChallengeService>();
    _notificationService = serviceLocator<NotificationService>();
    
    // Access the background service after both services are initialized
    try {
      _backgroundService = serviceLocator<BackgroundService>();
      // Set the notification service in the background service to avoid circular dependencies
      _backgroundService?.setNotificationService(_notificationService);
    } catch (e) {
      _logger.warning('Background service not available: $e');
    }
    
    _setupEventListeners();
    _initializeServices();
  }
  
  /// Setup event listeners from all services
  void _setupEventListeners() {
    // Listen for data collection events
    _dataCollectionService.addListener(_handleDataCollectionStateChange);
    
    // Listen for OBD connection events
    _obdConnectionService.addListener(_handleObdConnectionStateChange);
    
    // Listen for driving behavior events
    _analyticsService.eventStream.listen(_handleDrivingBehaviorEvent);
    
    // Listen for trip state changes
    _tripService.addListener(_updateDrivingStatus);
    
    // Listen for achievement events
    _achievementService.achievementEventStream.listen(_handleAchievementEvent);
    
    // Listen for challenge events
    _challengeService.challengeEventStream.listen(_handleChallengeEvent);
    
    // Subscribe to data stream to forward data to other services
    _dataCollectionService.dataStream.listen(_handleCombinedData);
  }
  
  /// Handle combined data from DataCollectionService and forward to other services
  void _handleCombinedData(CombinedDrivingData data) {
    try {
      // Forward to AnalyticsService for behavior analysis
      _analyticsService.triggerAnalysis();
      
      // Forward to TripService for trip metrics
      if (_tripService.currentTrip != null) {
        _tripService.processDataPoint(data);
      }
    } catch (e) {
      _logger.warning('Error handling combined data: $e');
    }
  }
  
  /// Initializes all required services
  Future<bool> _initializeServices() async {
    _logger.info('Initializing all driving services');
    
    try {
      // Initialize sensor service - this is the core requirement
      final sensorInitialized = await _sensorService.initialize();
      if (!sensorInitialized) {
        _setError('Failed to initialize sensor service');
        return false;
      }
      
      // Initialize data collection service - will use fallback mode if OBD is not available
      final dataCollectionInitialized = await _dataCollectionService.initialize();
      // We don't consider OBD failures as critical errors that prevent initialization
      // since we can still collect data using phone sensors
      
      // Mark as initialized even if data collection had OBD errors
      _isInitialized = dataCollectionInitialized;
      
      // Update driving status
      _updateDrivingStatus();
      
      _logger.info('All driving services initialized successfully. OBD connected: ${_obdConnectionService.isConnected}');
      notifyListeners();
      return dataCollectionInitialized;
    } catch (e) {
      _setError('Error initializing services: $e');
      _logger.severe('Error initializing services', e);
      return false;
    }
  }
  
  /// Updates the driving status based on all services' states
  void _updateDrivingStatus() {
    DrivingStatus oldStatus = _drivingStatus;
    
    if (!_isInitialized) {
      _drivingStatus = DrivingStatus.notReady;
      _logger.info('Setting driving status to notReady because service is not initialized');
    } else if (_errorMessage != null) {
      _drivingStatus = DrivingStatus.error;
      _logger.info('Setting driving status to error due to: $_errorMessage');
    } else if (_tripService.currentTrip != null) {
      _drivingStatus = DrivingStatus.recording;
      _logger.info('Setting driving status to recording because a trip is in progress');
    } else {
      _drivingStatus = DrivingStatus.ready;
      _logger.info('Setting driving status to ready - all conditions met');
    }
    
    if (oldStatus != _drivingStatus) {
      _logger.info('Driving status updated from $oldStatus to: $_drivingStatus');
    }
    
    notifyListeners();
  }
  
  /// Handles data collection state changes
  void _handleDataCollectionStateChange() {
    // If data collection throws an error, propagate it
    if (_dataCollectionService.errorMessage != null) {
      _setError('Data collection error: ${_dataCollectionService.errorMessage}');
    }
    
    // Update driving status
    _updateDrivingStatus();
  }
  
  /// Handles OBD connection state changes
  void _handleObdConnectionStateChange() {
    // If OBD connection throws an error, log it but don't stop functionality
    // (since we have sensor fallback)
    if (_obdConnectionService.errorMessage != null) {
      _logger.warning('OBD connection error: ${_obdConnectionService.errorMessage}');
      
      // Send an event for UI notification
      final tripId = _tripService.currentTrip?.id ?? 'no_trip';
      _drivingEventController.add(DrivingEvent(
        id: _uuid.v4(),
        tripId: tripId,
        timestamp: DateTime.now(),
        eventType: 'obd_connection_error',
        severity: 0.5,
        additionalData: {'message': _obdConnectionService.errorMessage},
      ));
    }
    
    notifyListeners();
  }
  
  /// Handles driving behavior events from analytics service
  void _handleDrivingBehaviorEvent(DrivingBehaviorEvent event) {
    try {
      // Convert behavior event to driving event
      final drivingEvent = DrivingEvent(
        id: _uuid.v4(),
        tripId: _tripService.currentTrip?.id ?? 'no_trip',
        timestamp: event.timestamp,
        eventType: event.behaviorType,
        severity: event.severity,
        additionalData: event.details,
      );
      
      // Forward the event to other services
      if (_tripService.currentTrip != null) {
        _tripService.recordDrivingEvent(drivingEvent);
      }
      
      // Forward event to the public event stream
      _drivingEventController.add(drivingEvent);
      
      // Send notification for significant events
      if (['harsh_acceleration', 'harsh_braking', 'excessive_speed', 'excessive_idling']
          .contains(event.behaviorType)) {
        _notificationService.showDrivingEventNotification(drivingEvent);
      }
    } catch (e) {
      _logger.warning('Error handling driving behavior event: $e');
    }
  }
  
  /// Handles achievement events
  void _handleAchievementEvent(AchievementEvent event) {
    try {
      // Create a driving event for the achievement
      final achievementEvent = DrivingEvent(
        id: _uuid.v4(),
        tripId: _tripService.currentTrip?.id ?? 'no_trip',
        timestamp: DateTime.now(),
        eventType: 'achievement_earned',
        severity: 0.0, // Not a negative event
        additionalData: event.toJson(),
      );
      
      // Forward to event stream
      _drivingEventController.add(achievementEvent);
      
      // Send notification for the achievement
      _notificationService.showAchievementNotification(
        title: 'Achievement Unlocked!',
        message: 'You earned the ${event.badgeName} badge',
        badgeType: event.badgeType,
        level: event.level,
      );
    } catch (e) {
      _logger.warning('Error handling achievement event: $e');
    }
  }
  
  /// Handles challenge events
  void _handleChallengeEvent(ChallengeEvent event) {
    try {
      // Create a driving event for the challenge
      final challengeEvent = DrivingEvent(
        id: _uuid.v4(),
        tripId: _tripService.currentTrip?.id ?? 'no_trip',
        timestamp: DateTime.now(),
        eventType: 'challenge_update',
        severity: 0.0, // Not a negative event
        additionalData: event.toJson(),
      );
      
      // Forward to event stream
      _drivingEventController.add(challengeEvent);
      
      // Send notification for completed challenges
      if (event.eventType == 'completed') {
        _notificationService.showNotification(
          title: 'Challenge Completed!',
          body: 'You completed the ${event.challengeTitle} challenge',
          type: NotificationType.achievement,
          priority: NotificationPriority.high,
          data: {'challengeId': event.challengeId},
        );
      }
    } catch (e) {
      _logger.warning('Error handling challenge event: $e');
    }
  }
  
  /// Handles errors by setting error message and updating status
  void _setError(String message) {
    _errorMessage = message;
    _logger.severe(message);
    _updateDrivingStatus();
    notifyListeners();
  }
  
  /// Starts scanning for OBD devices
  Future<bool> startScanningForDevices() async {
    try {
      return await _obdConnectionService.startScan();
    } catch (e) {
      _logger.warning('Error starting device scan', e);
      return false;
    }
  }
  
  /// Stops scanning for OBD devices
  Future<void> stopScanningForDevices() async {
    try {
      _obdConnectionService.stopScan();
    } catch (e) {
      _logger.warning('Error stopping device scan', e);
    }
  }
  
  /// Stream of discovered Bluetooth devices
  Stream<List<BluetoothDevice>> get deviceStream => _obdConnectionService.deviceStream;
  
  /// Connects to an OBD device
  Future<bool> connectToObdDevice(String deviceId) async {
    try {
      final success = await _obdConnectionService.connectToDevice(deviceId);
      if (success) {
        // Send a successful connection event
        final tripId = _tripService.currentTrip?.id ?? 'no_trip';
        _drivingEventController.add(DrivingEvent(
          id: _uuid.v4(),
          tripId: tripId,
          timestamp: DateTime.now(),
          eventType: 'obd_connected',
          severity: 0.0, // Not a negative event
          additionalData: {'deviceId': deviceId},
        ));
        
        // Award the OBD-connected achievement if user exists
        final userId = _tripService.currentTrip?.userId;
        if (userId != null) {
          _logger.info('Awarding OBD-connected achievement to user $userId');
          await _achievementService.awardSpecialBadge(userId, BadgeType.obdConnected);
        } else {
          _logger.info('Cannot award OBD-connected achievement: User not available');
        }
      }
      return success;
    } catch (e) {
      _logger.warning('Error connecting to OBD device', e);
      return false;
    }
  }
  
  /// Disconnects from an OBD device
  Future<bool> disconnectFromObdDevice() async {
    try {
      final success = await _obdConnectionService.disconnect();
      if (success) {
        // Send a disconnection event
        final tripId = _tripService.currentTrip?.id ?? 'no_trip';
        _drivingEventController.add(DrivingEvent(
          id: _uuid.v4(),
          tripId: tripId,
          timestamp: DateTime.now(),
          eventType: 'obd_disconnected',
          severity: 0.0, // Not a negative event
        ));
      }
      return success;
    } catch (e) {
      _logger.warning('Error disconnecting from OBD device', e);
      return false;
    }
  }
  
  /// Starts a new trip recording
  Future<Trip?> startTrip({bool skipPermissionChecks = false}) async {
    _logger.info('Starting new trip');
    
    if (_drivingStatus == DrivingStatus.recording) {
      _logger.warning('Cannot start trip, already recording');
      return null;
    }
    
    try {
      // Check for required permissions (only if not skipped)
      if (!skipPermissionChecks) {
        // First check for required permissions
        bool hasLocationPermission = await _permissionService.areLocationPermissionsGranted();
        if (!hasLocationPermission) {
          _logger.info('Requesting location permissions');
          await _permissionService.requestLocationPermissions();
          
          // Check again if permissions were granted
          hasLocationPermission = await _permissionService.areLocationPermissionsGranted();
          if (!hasLocationPermission) {
            _setError('Location permission required to start trip');
            return null;
          }
        }
        
        // If using OBD, check for bluetooth permissions 
        if (_obdConnectionService.isConnected) {
          bool hasBluetoothPermission = await _permissionService.areBluetoothPermissionsGranted();
          if (!hasBluetoothPermission) {
            _logger.info('Requesting Bluetooth permissions');
            await _permissionService.requestBluetoothPermissions();
            
            // Check again if permissions were granted
            hasBluetoothPermission = await _permissionService.areBluetoothPermissionsGranted();
            if (!hasBluetoothPermission) {
              _setError('Bluetooth permission required to use OBD device');
              return null;
            }
          }
        }
        
        // Check for activity/motion sensor permissions
        await _permissionService.requestActivityRecognitionPermission();
      } else {
        _logger.info('Skipping permission checks as requested');
      }
      
      // Start background service if available
      if (_backgroundService != null) {
        final canRunInBackground = await _backgroundService!.canRunInBackground();
        if (canRunInBackground) {
          _logger.info('Starting background service');
          await _backgroundService!.startBackgroundService();
        } else {
          _logger.warning('Background service cannot run, continuing without it');
        }
      }
      
      // Then ensure analytics is initialized
      await _analyticsService.initialize();
      
      // Then ensure data collection is started
      final collectionStarted = await _dataCollectionService.startCollection();
      if (!collectionStarted) {
        _setError('Failed to start data collection');
        return null;
      }
      
      // Then start the trip
      final trip = await _tripService.startTrip();
      if (trip != null) {
        // Send trip started event
        _drivingEventController.add(DrivingEvent(
          id: _uuid.v4(),
          tripId: trip.id,
          timestamp: DateTime.now(),
          eventType: 'trip_started',
          severity: 0.0, // Not a negative event
          additionalData: {'tripId': trip.id},
        ));
        
        _updateDrivingStatus();
      }
      
      return trip;
    } catch (e) {
      _setError('Error starting trip: $e');
      _logger.severe('Error starting trip', e);
      return null;
    }
  }
  
  /// Ends the current trip recording
  Future<Trip?> endTrip() async {
    _logger.info('Ending trip');
    
    if (_tripService.currentTrip == null) {
      _logger.warning('Cannot end trip: No trip in progress');
      return null;
    }
    
    try {
      // Stop data collection
      await _dataCollectionService.stopCollection();
      
      // Finish trip and get completed trip
      final completedTrip = await _tripService.endTrip();
      
      if (completedTrip != null) {
        _logger.info('Trip ended successfully: ${completedTrip.id}');
        
        // Check if this is the user's first trip and award achievement
        if (completedTrip.userId != null) {
          final tripCount = await _tripService.getUserTripCount(completedTrip.userId!);
          _logger.info('User ${completedTrip.userId} has completed $tripCount trips');
          
          if (tripCount == 1) {
            _logger.info('Awarding first trip achievement to user ${completedTrip.userId}');
            final achievementEvent = await _achievementService.awardSpecialBadge(completedTrip.userId!, BadgeType.firstTrip);
            if (achievementEvent != null) {
              _logger.info('Successfully awarded first trip achievement!');
            } else {
              _logger.warning('Failed to award first trip achievement to user ${completedTrip.userId}');
            }
          }
          
          // Check for other achievements
          await _achievementService.checkAchievementsAfterTrip(completedTrip, completedTrip.userId!);
          await _challengeService.checkChallengesAfterTrip(completedTrip, completedTrip.userId!);
        } else {
          _logger.warning('Cannot award achievements for trip ${completedTrip.id} - userId is null');
        }
        
        // Send trip summary notification
        _notificationService.showTripSummaryNotification(
          tripId: completedTrip.id,
          ecoScore: 85, // Use a placeholder or calculate from analytics service
          distanceKm: completedTrip.distanceKm ?? 0,
          fuelSavedL: completedTrip.fuelUsedL ?? 0,
        );
        
        // Update driving status
        _updateDrivingStatus();
        
        return completedTrip;
      } else {
        _logger.warning('Failed to end trip');
        return null;
      }
    } catch (e) {
      _setError('Error ending trip: $e');
      _logger.severe('Error ending trip', e);
      return null;
    }
  }
  
  /// Gets the combined data stream from the data collection service
  Stream<CombinedDrivingData> get dataStream => _dataCollectionService.dataStream;
  
  /// Gets the current trip metrics stream
  Stream<Map<String, dynamic>> get tripMetricsStream => _tripService.metricsStream;
  
  /// Gets the eco score stream
  Stream<double> get ecoScoreStream => _analyticsService.ecoScoreStream;
  
  /// Gets the latest detailed analysis from the analytics service
  Map<String, dynamic>? get latestAnalysis => _analyticsService.lastDetailedAnalysis;
  
  /// Gets recent driving behavior events
  List<DrivingBehaviorEvent> get recentBehaviorEvents => _analyticsService.recentEvents;
  
  /// Gets trip history from the trip service
  Future<List<Trip>> getTrips({int limit = 10, int offset = 0}) async {
    final allTrips = await _tripService.getTripHistory();
    
    if (allTrips.isEmpty) return [];
    
    final startIndex = offset.clamp(0, allTrips.length - 1);
    final endIndex = (offset + limit).clamp(startIndex, allTrips.length);
    
    return allTrips.sublist(startIndex, endIndex);
  }
  
  /// Gets a specific trip by ID
  Future<Trip?> getTrip(String tripId) async {
    return await _tripService.getTrip(tripId);
  }
  
  /// Force reinitialize all services
  /// This is useful for troubleshooting
  Future<bool> forceReinitializeServices() async {
    _logger.info('Force reinitializing all driving services');
    
    // Reset error state
    _errorMessage = null;
    
    // Reset initialization flag
    _isInitialized = false;
    
    // Notify listeners of state change
    notifyListeners();
    
    // Reinitialize services
    return await _initializeServices();
  }
  
  /// Clean up resources
  @override
  void dispose() {
    _logger.info('Disposing DrivingService');
    
    // Remove listeners
    _dataCollectionService.removeListener(_handleDataCollectionStateChange);
    _obdConnectionService.removeListener(_handleObdConnectionStateChange);
    _tripService.removeListener(_updateDrivingStatus);
    
    // Close stream controller
    _drivingEventController.close();
    
    super.dispose();
  }
  
  /// Setup the background service connection after initialization
  Future<void> setupBackgroundService() async {
    try {
      _backgroundService = serviceLocator<BackgroundService>();
      _logger.info('Background service found and integrated with DrivingService');
    } catch (e) {
      _logger.info('Background service not available, continuing without it: $e');
    }
  }
} 