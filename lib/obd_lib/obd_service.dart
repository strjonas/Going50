import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'bluetooth/bluetooth_connection.dart';
import 'bluetooth/bluetooth_scanner.dart';
import 'models/bluetooth_device.dart';
import 'models/obd_data.dart';
import 'obd_factory.dart';
import 'protocol/elm327_protocol.dart';
import 'protocol/obd_protocol.dart';
import 'protocol/obd_constants.dart';

/// Main service class for OBD-II communication
///
/// This class provides a facade for the OBD-II library, handling device discovery,
/// connection management, and data retrieval.
class ObdService extends ChangeNotifier {
  final Logger _logger = Logger('ObdService');
  final bool isDebugMode;
  
  // Bluetooth
  final BluetoothScanner _scanner = BluetoothScanner();
  bool _isScanning = false;
  
  // Protocol
  ObdProtocol? _protocol;
  
  // Adapter profile
  String? _selectedProfileId;
  
  // State
  bool _isConnecting = false;
  String? _errorMessage;
  final Map<String, ObdData> _latestData = {};
  final List<String> _monitoredPids = [];
  Timer? _pollingTimer;
  int _currentPollingInterval = ObdConstants.defaultPollingInterval;
  
  // Engine state tracking
  bool _engineRunning = false;
  int _engineCheckCounter = 0;

  // PID tracking
  final Map<String, int> _pidFailureCount = {};
  final int _maxFailureCount = 3;  // Maximum consecutive failures before reducing polling frequency
  final Map<String, DateTime> _lastPidRequestTime = {};
  
  // Polling cycle tracking
  int _pollingCycleCounter = 0;
  
  // Add tracking for RPM staleness detection
  DateTime? _lastRpmChangeTime;
  int? _lastRpmValue;
  // Reduce the threshold to detect staleness sooner - was 30 seconds
  static const _rpmStalenessThresholdMs = 15000; // 15 seconds without RPM change (was 30s)
  // Add counter for consecutive identical RPM readings to detect stuck values
  int _sameRpmCounter = 0;
  // Maximum identical RPM readings before forced verification
  static const _maxIdenticalRpmReadings = 5;
  
  // Add tracking for connection health
  int _consecutivePollingFailures = 0;
  static const _maxPollingFailures = 3;
  DateTime _lastSuccessfulPoll = DateTime.now();
  
  // Add a field to track the last connected device ID
  String? _lastConnectedDeviceId;
  
  /// Creates a new ObdService instance
  ///
  /// Set [isDebugMode] to true to enable debug logging
  /// Set [initLogging] to false to prevent setting up a logging listener
  ObdService({this.isDebugMode = false, bool initLogging = true}) {
    if (isDebugMode && initLogging) {
      Logger.root.level = Level.ALL;
      // No need to add a listener here, it's already set in main.dart
    }
    
    // Add default PIDs to monitor
    _monitoredPids.addAll([
      ObdConstants.pidEngineRpm,
      ObdConstants.pidVehicleSpeed,
      ObdConstants.pidCoolantTemp,
      ObdConstants.pidControlModuleVoltage,
    ]);
  }
  
  /// Whether the service is currently connected to an OBD adapter
  bool get isConnected => _protocol?.isConnected ?? false;
  
  /// Whether the service is currently connecting to an OBD adapter
  bool get isConnecting => _isConnecting;
  
  /// The latest error message, if any occurred
  String? get errorMessage => _errorMessage;
  
  /// The latest data received from the OBD adapter
  Map<String, ObdData> get latestData => Map.unmodifiable(_latestData);
  
  /// The list of PIDs currently being monitored
  List<String> get monitoredPids => List.unmodifiable(_monitoredPids);
  
  /// Whether the engine is currently running, based on RPM readings
  bool get isEngineRunning => _engineRunning;
  
  /// The ID of the currently selected adapter profile, if any
  String? get selectedProfileId => _selectedProfileId;

  /// Set a specific adapter profile to be used
  ///
  /// This will override automatic profile detection
  void setAdapterProfile(String profileId) {
    _logger.info('Setting adapter profile: $profileId');
    _selectedProfileId = profileId;
    ObdFactory.setAdapterProfile(profileId);
  }
  
  /// Clear manual profile selection
  ///
  /// This will re-enable automatic profile detection
  void enableAutomaticProfileDetection() {
    _logger.info('Enabling automatic profile detection');
    _selectedProfileId = null;
    ObdFactory.enableAutomaticProfileDetection();
  }
  
  /// Get a list of available adapter profiles
  List<Map<String, String>> getAvailableProfiles() {
    return ObdFactory.getAvailableProfiles();
  }
  
  /// Scan for available Bluetooth devices
  ///
  /// Returns a stream of discovered devices
  Stream<BluetoothDevice> scanForDevices() async* {
    if (_isScanning) return;
    
    _isScanning = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _logger.info('Starting device scan');
      
      _scanner.startScan();
      
      await for (final devices in _scanner.devices) {
        for (final device in devices) {
          _logger.fine('Found device: ${device.name} (${device.id})');
          yield device;
        }
      }
      
      _scanner.stopScan();
      _logger.info('Device scan completed');
    } catch (e) {
      _errorMessage = 'Error scanning for devices: $e';
      _logger.severe(_errorMessage);
      rethrow;
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }
  
  /// Connect to an OBD adapter
  ///
  /// Returns true if the connection was successful
  Future<bool> connect(String deviceId) async {
    // Store the device ID for recovery purposes
    _lastConnectedDeviceId = deviceId;
    
    if (isConnected) {
      _logger.info('Already connected, disconnecting first');
      disconnect();
    }
    
    _isConnecting = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _logger.info('Connecting to device: $deviceId');
      
      // Use the profile-based protocol creation if a profile is selected
      // or if no profile is selected, use automatic detection
      if (_selectedProfileId != null) {
        _logger.info('Using selected profile: $_selectedProfileId');
        ObdFactory.setAdapterProfile(_selectedProfileId!);
      } else {
        _logger.info('Using automatic profile detection');
        ObdFactory.enableAutomaticProfileDetection();
      }
      
      // Create protocol with the best matching profile
      _protocol = await ObdFactory.createProtocolForDevice(deviceId, isDebugMode: isDebugMode);
      
      if (_protocol == null) {
        _errorMessage = 'Failed to create protocol handler';
        _logger.warning(_errorMessage!);
        _isConnecting = false;
        notifyListeners();
        return false;
      }
      
      // Initialize protocol
      _logger.info('Initializing OBD protocol');
      final initialized = await _protocol!.initialize();
      if (!initialized) {
        _errorMessage = 'Failed to initialize OBD protocol';
        _logger.warning(_errorMessage!);
        _protocol!.dispose();
        _protocol = null;
        _isConnecting = false;
        notifyListeners();
        return false;
      }
      
      // Start data stream
      _protocol!.obdDataStream.listen(_handleObdData);
      
      // Make sure essential PIDs are monitored
      ensureEssentialPidsAreMonitored();
      
      // Start polling
      _startPolling();
      
      _logger.info('Connected successfully');
      _isConnecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      _logger.severe(_errorMessage);
      _protocol?.dispose();
      _protocol = null;
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Disconnect from the OBD adapter
  void disconnect() {
    _logger.info('Disconnecting');
    _stopPolling();
    _protocol?.dispose();
    _protocol = null;
    _latestData.clear();
    notifyListeners();
  }
  
  /// Add a PID to the list of monitored PIDs
  void addMonitoredPid(String pid) {
    if (!_monitoredPids.contains(pid)) {
      _logger.info('Adding monitored PID: $pid');
      _monitoredPids.add(pid);
      notifyListeners();
    }
  }
  
  /// Remove a PID from the list of monitored PIDs
  void removeMonitoredPid(String pid) {
    if (_monitoredPids.contains(pid)) {
      _logger.info('Removing monitored PID: $pid');
      _monitoredPids.remove(pid);
      _latestData.remove(pid);
      notifyListeners();
    }
  }
  
  /// Request data for a specific PID
  ///
  /// Returns the parsed OBD data
  Future<ObdData?> requestPid(String pid) async {
    if (!isConnected) {
      _logger.warning('Cannot request PID, not connected');
      return null;
    }
    
    try {
      _logger.fine('Requesting PID: $pid');
      final data = await _protocol!.requestPid(pid);
      if (data != null) {
        _latestData[pid] = data;
        notifyListeners();
      }
      return data;
    } catch (e) {
      _logger.warning('Error requesting PID $pid: $e');
      return null;
    }
  }
  
  /// Send a custom command to the OBD adapter
  ///
  /// This method allows sending any arbitrary command to the OBD adapter.
  /// Returns the raw response string from the adapter.
  Future<String> sendCustomCommand(String command) async {
    if (!isConnected) {
      _logger.warning('Cannot send command, not connected');
      return 'Not connected';
    }
    
    try {
      _logger.info('Sending custom command: $command');
      final response = await _protocol!.sendCommand(command);
      return response;
    } catch (e) {
      _logger.warning('Error sending custom command: $e');
      return 'Error: $e';
    }
  }
  
  /// Get a list of PIDs to request based on current engine state
  List<String> _getPidsForCurrentState() {
    // Define critical PIDs (requested in every cycle)
    final criticalPids = [
      ObdConstants.pidEngineRpm,
      ObdConstants.pidVehicleSpeed, // Promote speed to critical tier
    ];
    
    // Define high priority PIDs (requested in most cycles)
    final highPriorityPids = [
      ObdConstants.pidThrottlePosition, // Keep this as high priority
    ];
    
    final mediumPriorityPids = [
      ObdConstants.pidCoolantTemp,
      ObdConstants.pidControlModuleVoltage,
      ObdConstants.pidFuelLevel
    ];
    
    // Initialize with empty list
    final pidsToRequest = <String>[];
    
    // Track which polling cycle we're in using a cycle counter
    _pollingCycleCounter = (_pollingCycleCounter + 1) % 10;
    
    // Always request critical PIDs first
    for (final pid in criticalPids) {
      if (_monitoredPids.contains(pid)) {
        pidsToRequest.add(pid);
      }
    }
    
    // Request throttle position more frequently during acceleration
    // If we have RPM data and it's increasing, we're likely accelerating
    bool isAccelerating = false;
    if (_lastRpmValue != null && _lastRpmChangeTime != null) {
      final timeSinceRpmChange = DateTime.now().difference(_lastRpmChangeTime!).inMilliseconds;
      
      // If RPM changed recently (last 2 seconds) and is above idle RPM
      if (timeSinceRpmChange < 2000 && _lastRpmValue! > 1000) {
        isAccelerating = true;
      }
    }
    
    // During acceleration, always include throttle position
    if (isAccelerating && _monitoredPids.contains(ObdConstants.pidThrottlePosition)) {
      if (!pidsToRequest.contains(ObdConstants.pidThrottlePosition)) {
        _logger.fine('Adding throttle position due to acceleration');
        pidsToRequest.add(ObdConstants.pidThrottlePosition);
      }
    } 
    // Otherwise follow normal schedule for high priority PIDs
    else if (_pollingCycleCounter % 2 == 0) {
      for (final pid in _monitoredPids) {
        if (highPriorityPids.contains(pid) && !pidsToRequest.contains(pid)) {
          pidsToRequest.add(pid);
        }
      }
      
      // Add medium priority PIDs less frequently
      if (_pollingCycleCounter % 3 == 0) {
        for (final pid in _monitoredPids) {
          if (mediumPriorityPids.contains(pid) && !pidsToRequest.contains(pid)) {
            pidsToRequest.add(pid);
          }
        }
      }
    }
    
    // Engine state specific logic
    if (!_engineRunning) {
      // When engine is off, only add basic PIDs that work with ignition on
      for (final pid in _monitoredPids) {
        if (pid == ObdConstants.pidSupportedPids || 
            pid == ObdConstants.pidFuelLevel) {
          if (!pidsToRequest.contains(pid)) {
            pidsToRequest.add(pid);
          }
        }
      }
    } else {
      // For engine running state, add remaining low priority PIDs every 5 cycles
      if (_pollingCycleCounter % 5 == 0) {
        final currentTime = DateTime.now();
        
        for (final pid in _monitoredPids) {
          // Skip if already added as priority
          if (pidsToRequest.contains(pid)) continue;
          // Skip high/medium priority PIDs if this isn't their cycle
          if (highPriorityPids.contains(pid) && _pollingCycleCounter % 2 != 0) continue;
          if (mediumPriorityPids.contains(pid) && _pollingCycleCounter % 3 != 0) continue;
          
          final failureCount = _pidFailureCount[pid] ?? 0;
          final lastRequestTime = _lastPidRequestTime[pid];
          
          // If PID has failed too many times, reduce polling frequency
          if (failureCount >= _maxFailureCount && lastRequestTime != null) {
            // More aggressive backoff for problematic PIDs (4 seconds per failure)
            final backoffSeconds = (failureCount - _maxFailureCount + 1) * 4;
            final nextRequestTime = lastRequestTime.add(Duration(seconds: backoffSeconds));
            
            // Skip this PID if we need to wait longer
            if (currentTime.isBefore(nextRequestTime)) {
              continue;
            }
          }
          
          // Limit the number of PIDs per cycle to prevent overwhelming the adapter
          // Only allow 3 PIDs max if RPM is one of them for better responsiveness
          final maxPidsPerCycle = pidsToRequest.contains(ObdConstants.pidEngineRpm) ? 3 : 5;
          if (pidsToRequest.length < maxPidsPerCycle) {
            pidsToRequest.add(pid);
          }
        }
      }
    }
    
    // Log the PIDs being requested
    _logger.fine('Requesting PIDs: ${pidsToRequest.join(', ')} (cycle: $_pollingCycleCounter)');
    
    return pidsToRequest;
  }
  
  /// Poll for data from the OBD adapter
  Future<void> _pollData() async {
    if (!isConnected || _monitoredPids.isEmpty) return;
    
    try {
      _logger.fine('Polling data for ${_monitoredPids.length} PIDs');
      
      // Always check RPM first for engine state tracking
      if (!_engineRunning || _engineCheckCounter % 2 == 0) {
        await _checkEngineState();
      }
      _engineCheckCounter++;
      
      // Determine which PIDs to request this cycle based on engine state and priority
      List<String> pidsToRequest = _getPidsForCurrentState();
      
      if (pidsToRequest.isNotEmpty) {
        // Track which PIDs were processed separately to avoid duplicate requests
        final processedPids = <String>{};
        bool anySeparateRequestSucceeded = false;
        
        // Check if we're likely accelerating (for throttle position priority)
        bool isAccelerating = false;
        if (_lastRpmValue != null && _lastRpmChangeTime != null) {
          final timeSinceRpmChange = DateTime.now().difference(_lastRpmChangeTime!).inMilliseconds;
          // If RPM changed recently and is above idle
          if (timeSinceRpmChange < 2000 && _lastRpmValue! > 1000) {
            isAccelerating = true;
          }
        }
        
        // Handle RPM separately for faster response time if needed
        if (pidsToRequest.contains(ObdConstants.pidEngineRpm) && pidsToRequest.length > 1) {
          if (_engineRunning) {
            pidsToRequest.remove(ObdConstants.pidEngineRpm);
            
            final rpmFailureCount = _pidFailureCount[ObdConstants.pidEngineRpm] ?? 0;
            if (rpmFailureCount < 2) {
              final rpmData = await _protocol!.requestPid(ObdConstants.pidEngineRpm);
              if (rpmData != null) {
                _latestData[ObdConstants.pidEngineRpm] = rpmData;
                _pidFailureCount[ObdConstants.pidEngineRpm] = 0;
                _lastPidRequestTime[ObdConstants.pidEngineRpm] = DateTime.now();
                processedPids.add(ObdConstants.pidEngineRpm);
                anySeparateRequestSucceeded = true;
              } else {
                _pidFailureCount[ObdConstants.pidEngineRpm] = 
                    (_pidFailureCount[ObdConstants.pidEngineRpm] ?? 0) + 1;
                // Add back to batch request
                pidsToRequest.add(ObdConstants.pidEngineRpm);
              }
            } else {
              // Too many failures, add back to batch
              pidsToRequest.add(ObdConstants.pidEngineRpm);
            }
          } else {
            // Keep in batch for non-running engines
            // No change needed here
          }
        }
        
        // Also handle speed separately for improved responsiveness
        if (pidsToRequest.contains(ObdConstants.pidVehicleSpeed) && _engineRunning) {
          pidsToRequest.remove(ObdConstants.pidVehicleSpeed);
          
          final speedFailureCount = _pidFailureCount[ObdConstants.pidVehicleSpeed] ?? 0;
          if (speedFailureCount < 2) {
            final speedData = await _protocol!.requestPid(ObdConstants.pidVehicleSpeed);
            if (speedData != null) {
              _latestData[ObdConstants.pidVehicleSpeed] = speedData;
              _pidFailureCount[ObdConstants.pidVehicleSpeed] = 0;
              _lastPidRequestTime[ObdConstants.pidVehicleSpeed] = DateTime.now();
              processedPids.add(ObdConstants.pidVehicleSpeed);
              anySeparateRequestSucceeded = true;
            } else {
              _pidFailureCount[ObdConstants.pidVehicleSpeed] = 
                  (_pidFailureCount[ObdConstants.pidVehicleSpeed] ?? 0) + 1;
              // Add back to batch request
              pidsToRequest.add(ObdConstants.pidVehicleSpeed);
            }
          } else {
            // Too many failures, add back to batch
            pidsToRequest.add(ObdConstants.pidVehicleSpeed);
          }
        }
        
        // Handle throttle position separately during acceleration
        if (isAccelerating && pidsToRequest.contains(ObdConstants.pidThrottlePosition)) {
          pidsToRequest.remove(ObdConstants.pidThrottlePosition);
          
          final throttleFailureCount = _pidFailureCount[ObdConstants.pidThrottlePosition] ?? 0;
          if (throttleFailureCount < 2) {
            _logger.fine('Requesting throttle position separately during acceleration');
            final throttleData = await _protocol!.requestPid(ObdConstants.pidThrottlePosition);
            if (throttleData != null) {
              _latestData[ObdConstants.pidThrottlePosition] = throttleData;
              _pidFailureCount[ObdConstants.pidThrottlePosition] = 0;
              _lastPidRequestTime[ObdConstants.pidThrottlePosition] = DateTime.now();
              processedPids.add(ObdConstants.pidThrottlePosition);
              anySeparateRequestSucceeded = true;
            } else {
              _pidFailureCount[ObdConstants.pidThrottlePosition] = 
                  (_pidFailureCount[ObdConstants.pidThrottlePosition] ?? 0) + 1;
              // Add back to batch request
              pidsToRequest.add(ObdConstants.pidThrottlePosition);
            }
          } else {
            // Too many failures, add back to batch
            pidsToRequest.add(ObdConstants.pidThrottlePosition);
          }
        }
        
        // Process all remaining PIDs as a batch
        if (pidsToRequest.isNotEmpty) {
          final data = await _protocol!.requestPids(pidsToRequest);
          
          // Update successful PIDs and their last request times
          data.forEach((pid, value) {
            _pidFailureCount[pid] = 0;  // Reset failure count on success
            _lastPidRequestTime[pid] = DateTime.now();
          });
          
          // Check for failures (PIDs that were requested but not returned)
          for (var pid in pidsToRequest) {
            if (!data.containsKey(pid)) {
              _pidFailureCount[pid] = (_pidFailureCount[pid] ?? 0) + 1;
              _logger.fine('PID $pid failed, failure count: ${_pidFailureCount[pid]}');
            }
          }
          
          // Track successful poll
          if (data.isNotEmpty) {
            _consecutivePollingFailures = 0;
            _lastSuccessfulPoll = DateTime.now();
          } else {
            _consecutivePollingFailures++;
            _logger.warning('Empty poll response, consecutive failures: $_consecutivePollingFailures');
          }
          
          _latestData.addAll(data);
          notifyListeners();
        } else if (anySeparateRequestSucceeded) {
          // If we only processed PIDs separately but nothing in batch, still consider this a successful poll
          _consecutivePollingFailures = 0;
          _lastSuccessfulPoll = DateTime.now();
          notifyListeners();
        }
      }
    } catch (e) {
      _logger.warning('Error polling data: $e');
      _consecutivePollingFailures++;
      
      // Check if we need to recover the connection
      final timeSinceLastSuccess = DateTime.now().difference(_lastSuccessfulPoll).inSeconds;
      if (_consecutivePollingFailures >= _maxPollingFailures || timeSinceLastSuccess > 30) {
        _logger.warning('Too many polling failures ($_consecutivePollingFailures) or too long without data (${timeSinceLastSuccess}s). Attempting recovery...');
        _attemptConnectionRecovery();
      }
    }
  }
  
  /// Attempt to recover a stalled connection
  Future<void> _attemptConnectionRecovery() async {
    _logger.info('Attempting connection recovery');
    try {
      // Stop polling during recovery
      _stopPolling();
      
      // Disconnect and reconnect to the same device
      final currentDeviceId = _getCurrentDeviceId();
      if (currentDeviceId != null) {
        _logger.info('Disconnecting from device: $currentDeviceId');
        disconnect(); // No need to await, this method is void
        
        // Wait a moment before reconnecting
        await Future.delayed(const Duration(milliseconds: 1000));
        
        _logger.info('Reconnecting to device: $currentDeviceId');
        final reconnected = await connect(currentDeviceId);
        if (reconnected) {
          _logger.info('Successfully recovered connection');
          _consecutivePollingFailures = 0;
          _lastSuccessfulPoll = DateTime.now();
          _startPolling();
        } else {
          _logger.severe('Failed to recover connection');
        }
      }
    } catch (e) {
      _logger.severe('Error during connection recovery: $e');
    }
  }
  
  /// Get the current device ID from the protocol
  String? _getCurrentDeviceId() {
    // Simply return the last connected device ID that we stored
    // when connect() was called
    return _lastConnectedDeviceId;
  }
  
  /// Checks if the engine is running by requesting RPM
  Future<void> _checkEngineState() async {
    try {
      final currentTime = DateTime.now();
      
      // Request the RPM PID specifically
      final rpmData = await _protocol?.requestPid(ObdConstants.pidEngineRpm);
      
      // Update engine running state based on RPM
      bool newEngineState = false;
      bool rpmResponseValid = false;
      int rpm = 0;
      
      if (rpmData != null && rpmData.value != null) {
        // RPM > 0 means engine is running
        if (rpmData.value is int) {
          rpm = rpmData.value as int;
          rpmResponseValid = true;
        } else if (rpmData.value is double) {
          rpm = (rpmData.value as double).toInt();
          rpmResponseValid = true;
        } else if (rpmData.value is String) {
          try {
            rpm = int.parse(rpmData.value.toString());
            rpmResponseValid = true;
          } catch (_) {
            // Failed to parse as int, leave rpm as 0
            _logger.warning('Failed to parse RPM value: ${rpmData.value}');
          }
        }
        
        // Check if RPM has changed since last time
        if (rpmResponseValid) {
          if (_lastRpmValue != rpm) {
            _lastRpmChangeTime = currentTime;
            _lastRpmValue = rpm;
            _sameRpmCounter = 0; // Reset counter when RPM changes
            _logger.fine('RPM changed to: $rpm');
          } else {
            // Same RPM value as before
            _sameRpmCounter++;
            _logger.fine('Same RPM value ($rpm) for $_sameRpmCounter consecutive readings');
            
            // Check if we need to verify due to too many identical readings
            bool needsVerification = false;
            
            if (_sameRpmCounter >= _maxIdenticalRpmReadings) {
              _logger.info('RPM value ($rpm) unchanged for $_sameRpmCounter consecutive readings, verifying');
              needsVerification = true;
              _sameRpmCounter = 0; // Reset counter after verification
            } else if (_lastRpmChangeTime != null && rpm > 0) {
              // Check for RPM staleness (no change for a while) - only if RPM > 0
              final staleDuration = currentTime.difference(_lastRpmChangeTime!).inMilliseconds;
              if (staleDuration > _rpmStalenessThresholdMs) {
                _logger.info('RPM value ($rpm) has not changed for ${staleDuration}ms, verifying engine state');
                needsVerification = true;
              }
            }
            
            // Perform verification if needed
            if (needsVerification) {
              // Less aggressive verification - don't rely only on other indicators
              // For a cheap adapter, constant RPM value might be valid for a long time at idle
              
              // Check vehicle speed - if speed > 0, engine must be running
              final speedData = _latestData[ObdConstants.pidVehicleSpeed];
              if (speedData != null && speedData.value != null) {
                final speed = _asInt(speedData.value) ?? 0;
                if (speed > 0) {
                  // Vehicle is moving, definitely engine running, no need for verification
                  _logger.fine('Vehicle is moving (${speed}km/h), engine must be on despite stale RPM');
                  newEngineState = true;
                  // Skip further verification
                  _lastRpmChangeTime = currentTime; // Reset staleness timer
                } else {
                  // Only do a single verification request for very stale RPM at idle
                  _logger.info('Requesting RPM again to verify idle engine state');
                  final verifyRpmData = await _protocol?.requestPid(ObdConstants.pidEngineRpm);
                  
                  // Trust any valid response
                  if (verifyRpmData != null && verifyRpmData.value != null) {
                    final verifyRpm = _asInt(verifyRpmData.value) ?? 0;
                    rpm = verifyRpm; // Use the newest value
                    _lastRpmValue = rpm;
                    _lastRpmChangeTime = currentTime; // Reset staleness timer
                    _logger.info('RPM verified: $rpm');
                  }
                }
              }
            }
          }
        }
        
        // If we got any valid RPM value > 0, trust it
        newEngineState = rpm > 0;
        _logger.fine('Current RPM: $rpm, engine state: ${newEngineState ? "running" : "off"}');
      } else {
        // No RPM data received - could indicate engine is off or adapter issue
        _logger.info('No valid RPM data received, checking alternative indicators');
        
        // If we had a previous RPM value but now getting no data, likely engine off
        // But be more conservative about declaring engine off based on a single failed reading
        if (_lastRpmValue != null && _lastRpmValue! > 0) {
          // Check other indicators before concluding engine is off
          
          // Check vehicle speed
          final speedData = _latestData[ObdConstants.pidVehicleSpeed];
          if (speedData != null && speedData.value != null) {
            final speed = _asInt(speedData.value) ?? 0;
            if (speed > 0) {
              // If vehicle is moving, engine must be running despite RPM issue
              newEngineState = true;
              _logger.info('Engine still running based on speed: $speed km/h despite no RPM data');
            } else {
              // Try one more RPM request to be sure before declaring engine off
              _logger.info('No speed, trying RPM again before concluding engine off');
              final retryRpmData = await _protocol?.requestPid(ObdConstants.pidEngineRpm);
              if (retryRpmData != null && retryRpmData.value != null) {
                final retryRpm = _asInt(retryRpmData.value) ?? 0;
                if (retryRpm > 0) {
                  newEngineState = true;
                  rpm = retryRpm;
                  _lastRpmValue = rpm;
                  _lastRpmChangeTime = currentTime;
                  _logger.info('Engine confirmed running on retry: RPM $rpm');
                } else {
                  // Now we're more confident the engine is off
                  _logger.info('Engine confirmed off: RPM 0 on verification');
                  _lastRpmValue = 0;
                }
              } else {
                // Two failed RPM requests in a row, likely engine off
                _logger.info('Two failed RPM requests, engine likely off');
                _lastRpmValue = 0;
              }
            }
          } else {
            // No speed data and no RPM data - check other indicators
            // But be more conservative about declaring engine off
            
            // Check throttle position
            final throttleData = _latestData[ObdConstants.pidThrottlePosition];
            if (throttleData != null && throttleData.value != null) {
              final throttle = _asInt(throttleData.value) ?? 0;
              if (throttle > 0) {
                newEngineState = true;
                _logger.info('Engine likely running based on throttle position: $throttle%');
              }
            }
            
            // Check engine load as last resort
            if (!newEngineState) {
              final loadData = _latestData[ObdConstants.pidEngineLoad];
              if (loadData != null && loadData.value != null) {
                final load = _asInt(loadData.value) ?? 0;
                if (load > 0) {
                  newEngineState = true;
                  _logger.info('Engine likely running based on engine load: $load%');
                } else {
                  // Multiple indicators suggest engine off
                  _logger.info('Multiple indicators suggest engine off');
                  _lastRpmValue = 0;
                }
              }
            }
          }
        }
      }
      
      // Only notify if state changed
      if (_engineRunning != newEngineState) {
        _logger.info('Engine state changed from ${_engineRunning ? "running" : "off"} to ${newEngineState ? "running" : "off"}');
        _engineRunning = newEngineState;
        notifyListeners();
      }
    } catch (e) {
      _logger.warning('Error checking engine state: $e');
    }
  }
  
  /// Handle data received from the OBD adapter
  void _handleObdData(ObdData data) {
    _logger.fine('Received OBD data: $data');
    
    // Store previous value to check for changes
    dynamic previousValue = _latestData[data.pid]?.value;
    
    // Update latest data
    _latestData[data.pid] = data;
    
    // Special handling for RPM data for engine state tracking
    if (data.pid == ObdConstants.pidEngineRpm && data.value != null) {
      int rpm = 0;
      
      if (data.value is int) {
        rpm = data.value as int;
      } else if (data.value is double) {
        rpm = (data.value as double).toInt();
      } else if (data.value is String) {
        try {
          rpm = int.parse(data.value.toString());
        } catch (_) {
          // Failed to parse as int
          _logger.warning('Failed to parse RPM in _handleObdData: ${data.value}');
        }
      }
      
      // Track RPM changes for staleness detection
      if (_lastRpmValue != rpm) {
        _lastRpmValue = rpm;
        _lastRpmChangeTime = DateTime.now();
      }
      
      bool newEngineState = rpm > 0;
      
      // Always update and notify if RPM data received, regardless of previous state
      if (_engineRunning != newEngineState) {
        _logger.info('Engine state changed to: ${newEngineState ? "running" : "off"} (RPM: $rpm)');
        _engineRunning = newEngineState;
        notifyListeners();
      }
    }
    
    // Special handling for speed data for eco-driving
    if (data.pid == ObdConstants.pidVehicleSpeed && data.value != null) {
      int speed = 0;
      
      if (data.value is int) {
        speed = data.value as int;
      } else if (data.value is double) {
        speed = (data.value as double).toInt();
      } else if (data.value is String) {
        try {
          speed = int.parse(data.value.toString());
        } catch (_) {
          // Failed to parse as int
          _logger.warning('Failed to parse speed: ${data.value}');
        }
      }
      
      // Log when speed changes to help with debugging
      if (previousValue != data.value) {
        _logger.info('Speed changed from $previousValue to $speed km/h');
      }
    }
    
    // Special handling for throttle position
    if (data.pid == ObdConstants.pidThrottlePosition && data.value != null) {
      double throttle = 0;
      
      if (data.value is int) {
        throttle = (data.value as int).toDouble();
      } else if (data.value is double) {
        throttle = data.value as double;
      } else if (data.value is String) {
        try {
          throttle = double.parse(data.value.toString());
        } catch (_) {
          // Failed to parse as double
          _logger.warning('Failed to parse throttle position: ${data.value}');
        }
      }
      
      // Log throttle position changes for debugging
      if (previousValue != data.value) {
        _logger.info('Throttle position changed from $previousValue to $throttle%');
      }
    }
    
    notifyListeners();
  }
  
  /// Helper method to safely convert a value to double 
  double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
  
  /// Helper method to safely convert a value to int
  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
  
  /// Start polling for data
  void _startPolling() {
    _stopPolling();
    _logger.info('Starting polling');
    
    // Start with safer, slightly longer polling interval for cheap adapters
    _currentPollingInterval = ObdConstants.slowPollingInterval;
    _pollingTimer = Timer.periodic(
      Duration(milliseconds: _currentPollingInterval),
      (_) {
        _pollData();
        _updatePollingInterval();
      },
    );
  }
  
  /// Stop polling for data
  void _stopPolling() {
    if (_pollingTimer != null) {
      _logger.info('Stopping polling');
      _pollingTimer!.cancel();
      _pollingTimer = null;
    }
  }
  
  /// Update polling interval based on engine state and adapter performance
  void _updatePollingInterval() {
    if (_pollingTimer == null) return;
    
    // Track the number of consecutive timeouts to dynamically adjust polling
    int timeoutCount = 0;
    _pidFailureCount.forEach((pid, count) {
      if (count >= _maxFailureCount) timeoutCount++;
    });
    
    // Determine appropriate polling interval
    int desiredInterval;
    
    // Base polling interval selection on engine state first
    if (!_engineRunning) {
      // Engine off - use longer polling interval to conserve resources
      desiredInterval = ObdConstants.engineOffPollingInterval;
    } else {
      // Start with the base polling interval for running engine
      // Higher timeout counts mean the adapter is struggling
      if (timeoutCount > 3) {
        // Multiple timeouts - increase interval to give adapter more time
        // But don't go as high as before - increment by smaller amounts now
        desiredInterval = ObdConstants.slowPollingInterval + 300; 
        _logger.info('Increasing polling interval due to multiple timeouts');
      } else if (timeoutCount > 1) {
        // Some timeouts - use the standard slow polling interval
        desiredInterval = ObdConstants.slowPollingInterval;
      } else {
        // No or few timeouts - can use default polling, which is already optimized
        desiredInterval = ObdConstants.defaultPollingInterval;
        
        // If we have recent RPM changes (active driving), try to be even more responsive
        if (_lastRpmChangeTime != null) {
          final timeSinceRpmChange = 
              DateTime.now().difference(_lastRpmChangeTime!).inMilliseconds;
              
          // If RPM changed recently (last 5 seconds), try to use faster polling
          // But only if we have no timeouts at all
          if (timeSinceRpmChange < 5000 && timeoutCount == 0) {
            desiredInterval = ObdConstants.fastPollingInterval;
            _logger.fine('Using fast polling due to recent RPM changes');
          }
        }
      }
      
      // Safety check to ensure we don't go too fast
      if (desiredInterval < 500) { // Don't go below 500ms minimum for any adapter
        desiredInterval = 500;
      }
    }
    
    // Update polling timer if interval needs to change
    if (_currentPollingInterval != desiredInterval) {
      _logger.info('Changing polling interval from $_currentPollingInterval ms to $desiredInterval ms');
      _stopPolling();
      _currentPollingInterval = desiredInterval;
      _pollingTimer = Timer.periodic(
        Duration(milliseconds: _currentPollingInterval),
        (_) {
          _pollData();
          _updatePollingInterval();
        },
      );
    }
  }
  
  /// Start continuous queries for monitored PIDs
  /// This is used by the DrivingService to begin data collection
  Future<void> startContinuousQueries() async {
    _logger.info('Starting continuous queries for ${_monitoredPids.length} PIDs');
    ensureEssentialPidsAreMonitored();
    _startPolling();
    return Future.value();
  }
  
  /// Stop all queries
  /// This is used by the DrivingService to end data collection
  Future<void> stopQueries() async {
    _logger.info('Stopping all queries');
    _stopPolling();
    return Future.value();
  }
  
  @override
  void dispose() {
    _logger.info('Disposing ObdService');
    _stopPolling();
    _protocol?.dispose();
    _scanner.dispose();
    super.dispose();
  }

  /// Make sure throttle position is monitored
  void ensureEssentialPidsAreMonitored() {
    // Essential PIDs for eco-driving that should always be monitored
    final essentialPids = [
      ObdConstants.pidEngineRpm,
      ObdConstants.pidVehicleSpeed,
      ObdConstants.pidThrottlePosition,
    ];
    
    // Add any missing essential PIDs
    for (final pid in essentialPids) {
      if (!_monitoredPids.contains(pid)) {
        _logger.info('Adding missing essential PID: $pid');
        _monitoredPids.add(pid);
      }
    }
  }
} 

/// Extension methods for testing
extension ObdServiceTestExtensions on ObdService {
  /// Injects a protocol instance for testing purposes
  void injectProtocolForTesting(ObdProtocol protocol) {
    _protocol = protocol;
  }
  
  /// Runs the engine state check directly for testing
  Future<void> checkEngineStateForTesting() async {
    await _checkEngineState();
  }
  
  /// Simulates consecutive polling failures for testing
  void simulatePollingFailureForTesting(int failureCount) {
    _consecutivePollingFailures = failureCount;
    _updatePollingInterval();
  }
  
  /// Get the current polling interval for testing
  int get currentPollingIntervalForTesting => _currentPollingInterval;
  
  /// Directly trigger a polling cycle for testing
  Future<void> triggerPollingCycleForTesting() async {
    await _pollData();
  }
  
  /// Get the current protocol for testing
  ObdProtocol? get protocolForTesting => _protocol;
}