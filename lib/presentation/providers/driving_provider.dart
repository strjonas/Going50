import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:going50/core_models/combined_driving_data.dart';
import 'package:going50/core_models/driving_event.dart';
import 'package:going50/core_models/trip.dart';
import 'package:going50/obd_lib/models/bluetooth_device.dart';
import 'package:going50/services/driving/driving_service.dart';

/// Provider for driving-related state and actions
///
/// This provider exposes the state of the DrivingService to the UI
/// and provides methods to interact with it.
class DrivingProvider extends ChangeNotifier {
  final DrivingService _drivingService;
  
  // Subscription management
  StreamSubscription<DrivingEvent>? _eventSubscription;
  StreamSubscription<double>? _ecoScoreSubscription;
  
  // State
  double _currentEcoScore = 0.0;
  List<DrivingEvent> _recentEvents = [];
  bool _preferOBD = true; // Default to preferring OBD connection if available
  
  /// Constructor
  DrivingProvider(this._drivingService) {
    _subscribeToStreams();
    
    // Listen for changes in the driving service
    _drivingService.addListener(() {
      notifyListeners();
    });
  }
  
  // Public getters that expose state from the driving service
  
  /// Current driving status (notReady, ready, recording, error)
  DrivingStatus get drivingStatus => _drivingService.drivingStatus;
  
  /// Whether a trip is currently being recorded
  bool get isRecording => _drivingService.drivingStatus == DrivingStatus.recording;
  
  /// Whether the app is currently collecting data
  bool get isCollecting => _drivingService.isCollecting;
  
  /// Whether an OBD device is connected
  bool get isObdConnected => _drivingService.isObdConnected;
  
  /// The current trip, if any
  Trip? get currentTrip => _drivingService.currentTrip;
  
  /// The current eco-score (0-100)
  double get currentEcoScore => _currentEcoScore;
  
  /// Recent driving events
  List<DrivingEvent> get recentEvents => _recentEvents;
  
  /// Any error message from the driving service
  String? get errorMessage => _drivingService.errorMessage;
  
  /// Whether the user prefers to use OBD when available
  bool get preferOBD => _preferOBD;
  
  // Public methods that delegate to the driving service
  
  /// Start a new trip
  Future<bool> startTrip({bool skipPermissionChecks = false}) async {
    final success = await _drivingService.startTrip(skipPermissionChecks: skipPermissionChecks) != null;
    return success;
  }
  
  /// End the current trip
  Future<bool> endTrip() async {
    final success = await _drivingService.endTrip() != null;
    return success;
  }
  
  /// Scan for OBD devices
  Stream<List<BluetoothDevice>> scanForObdDevices() {
    _drivingService.startScanningForDevices();
    return _drivingService.deviceStream;
  }
  
  /// Connect to an OBD device
  Future<bool> connectToObdDevice(String deviceId) async {
    return await _drivingService.connectToObdDevice(deviceId);
  }
  
  /// Disconnect from the OBD device
  Future<void> disconnectObdDevice() async {
    await _drivingService.disconnectFromObdDevice();
  }
  
  /// Set whether the user prefers to use OBD when available
  void setPreferOBD(bool prefer) {
    _preferOBD = prefer;
    // TODO: Store this preference in persistent storage when user service is implemented
    notifyListeners();
  }
  
  /// Get the trip history
  Future<List<Trip>> getTrips({int limit = 10, int offset = 0}) async {
    return await _drivingService.getTrips(limit: limit, offset: offset);
  }
  
  /// Get a specific trip by ID
  Future<Trip?> getTrip(String tripId) async {
    return await _drivingService.getTrip(tripId);
  }
  
  /// Get the latest combined driving data
  Future<CombinedDrivingData?> getLatestDrivingData() async {
    // We need to access the data stream and get the latest value
    final dataStream = _drivingService.dataStream;
    try {
      return await dataStream.first;
    } catch (e) {
      return null;
    }
  }
  
  /// Force update notification (for debugging purposes)
  void forceUpdate() {
    notifyListeners();
  }
  
  /// Force reinitialize all services (for troubleshooting)
  Future<bool> forceReinitializeServices() async {
    return await _drivingService.forceReinitializeServices();
  }
  
  /// Subscribe to streams from the driving service
  void _subscribeToStreams() {
    // Subscribe to driving events
    _eventSubscription = _drivingService.drivingEventStream.listen((event) {
      _recentEvents = [event, ..._recentEvents];
      if (_recentEvents.length > 10) {
        _recentEvents = _recentEvents.sublist(0, 10);
      }
      notifyListeners();
    });
    
    // Subscribe to eco-score updates
    _ecoScoreSubscription = _drivingService.ecoScoreStream.listen((score) {
      _currentEcoScore = score;
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    // Cancel subscriptions
    _eventSubscription?.cancel();
    _ecoScoreSubscription?.cancel();
    
    // Remove listener from driving service
    _drivingService.removeListener(() {});
    
    super.dispose();
  }
} 