import 'dart:async';
import 'dart:math';
import 'package:logging/logging.dart';
import '../interfaces/obd_connection.dart';
import 'obd_protocol.dart';
import '../models/obd_command.dart';
import '../models/obd_data.dart';
import '../models/adapter_config.dart';
import '../models/adapter_config_factory.dart';
import '../models/adapter_config_validator.dart';
import 'obd_constants.dart';
import 'obd_commands.dart';
import 'response_processor/obd_response_processor.dart';
import 'response_processor/processor_factory.dart';
import '../profiles/profile_manager.dart';

/// Helper class for command completion with timeout
class CompleterWithTimeout {
  final Completer<String> completer;
  final Timer timer;
  
  CompleterWithTimeout(this.completer, this.timer);
  
  void complete(String value) {
    if (!completer.isCompleted) {
      completer.complete(value);
    }
  }
  
  void completeError(Object error, [StackTrace? stackTrace]) {
    if (!completer.isCompleted) {
      completer.completeError(error, stackTrace);
    }
  }
  
  void cancel() {
    timer.cancel();
  }
}

/// Unified protocol implementation for all ELM327 adapters
///
/// This class implements the ObdProtocol interface for ELM327 adapters
/// with configuration-driven behavior to support both cheap and premium adapters.
class Elm327Protocol implements ObdProtocol {
  static final Logger _logger = Logger('Elm327Protocol');
  
  /// The underlying connection to the ELM327 adapter
  final ObdConnection connection;
  
  /// The response processor to use for this adapter
  final ObdResponseProcessor responseProcessor;
  
  /// The adapter configuration to use
  final AdapterConfig config;
  
  /// Optional reference to the profile manager for reporting performance metrics
  final ProfileManager? profileManager;
  
  /// Device ID for performance reporting
  final String? deviceId;
  
  /// Configuration validator for runtime monitoring
  final AdapterConfigValidator _configValidator = AdapterConfigValidator();
  
  /// Whether the protocol has been initialized
  bool _isInitialized = false;
  
  /// Whether the protocol is currently connecting
  bool _isConnecting = false;
  
  /// Error message if initialization fails
  String? _errorMessage;
  
  /// Stream controller for decoded OBD data
  final _dataStreamController = StreamController<ObdData>.broadcast();
  
  /// Subscription to the connection's data stream
  StreamSubscription? _connectionSubscription;
  
  /// Debug mode flag
  final bool _isDebugMode;
  
  /// Map to store expected response PIDs
  final Map<String, CompleterWithTimeout> _pendingCommands = {};
  
  /// Currently executing command
  ObdCommand? _currentCommand;
  
  /// Command queue
  final List<ObdCommand> _commandQueue = [];
  
  /// Flag to track if we're currently processing a command
  bool _processingCommand = false;
  
  /// Map to track retried commands and their retry count
  final Map<String, int> _commandRetries = {};
  
  /// Maps to track consecutive identical responses and their timestamps
  final Map<String, String> _lastResponses = {};
  final Map<String, DateTime> _lastResponseTimes = {};
  final Map<String, int> _identicalResponseCounts = {};
  static const int _maxIdenticalResponses = 3;
  
  /// Track recent RPM values to detect acceleration
  final List<int> _lastRpmValues = [];
  final int _maxRpmHistorySize = 3;
  
  /// Track recent speed values to detect anomalies
  final List<int> _lastSpeedValues = [];
  final int _maxSpeedHistorySize = 5;
  
  /// Creates a new ELM327 protocol handler
  /// 
  /// This constructor now handles both cheap and premium adapter types through configuration.
  /// The behavior is driven by the provided adapter configuration rather than subclassing.
  Elm327Protocol(
    this.connection, 
    {
      bool isDebugMode = false,
      String adapterProfile = 'cheap_elm327',
      ObdResponseProcessor? customResponseProcessor,
      AdapterConfig? adapterConfig,
      this.profileManager,
      this.deviceId,
    }) 
    : _isDebugMode = isDebugMode,
      responseProcessor = customResponseProcessor ?? ResponseProcessorFactory.createProcessor(
        adapterProfile,
        (adapterConfig ?? AdapterConfigFactory.createConfig(adapterProfile)).useLenientParsing,
      ),
      config = adapterConfig ?? AdapterConfigFactory.createConfig(adapterProfile) {
    _setupDataStream();
    _logger.info('Created ELM327 protocol handler with profile: ${config.profileId}');
    _logger.info('Using response processor: ${responseProcessor.runtimeType}');
    
    // Log critical configuration values for debugging
    _logger.info('Adapter config: useExtendedInitDelays=${config.useExtendedInitDelays}, '
        'useLenientParsing=${config.useLenientParsing}, '
        'responseTimeout=${config.responseTimeoutMs}ms, '
        'commandTimeout=${config.commandTimeoutMs}ms');
  }
  
  @override
  Stream<ObdData> get obdDataStream => _dataStreamController.stream;
  
  @override
  Stream<String> get dataStream => connection.dataStream;
  
  @override
  bool get isInitialized => _isInitialized;
  
  @override
  bool get isConnected => connection.isConnected;
  
  @override
  bool get isConnecting => _isConnecting;
  
  @override
  String? get errorMessage => _errorMessage;
  
  /// Sets up the data stream from the connection
  void _setupDataStream() {
    _connectionSubscription = connection.dataStream.listen((response) {
      if (_isDebugMode) {
        _logger.fine('Raw response: $response');
      }
      
      // Ignore empty responses and connection status messages
      if (response.isEmpty || 
          response == 'SEARCHING...' || 
          response == 'CONNECTED' || 
          response == 'DISCONNECTED') {
        return;
      }
      
      // Handle the response
      _handleResponse(response);
      
      // Log the received response
      _logger.info('Received: $response');
    });
  }
  
  /// Handle a response from the adapter
  void _handleResponse(String response) {
    // Check for "NO DATA" or "ERROR" messages
    if (response.contains('NO DATA') || response.contains('ERROR')) {
      _logger.warning('Error response: $response');
      
      if (_currentCommand != null) {
        final command = _currentCommand!.command;
        if (_pendingCommands.containsKey(command)) {
          // Check if we should retry
          final retryCount = _commandRetries[command] ?? 0;
          
          if (retryCount < config.maxRetries) {
            // Retry the command
            _logger.info('Retrying command: $command (attempt ${retryCount + 1}/${config.maxRetries})');
            _commandRetries[command] = retryCount + 1;
            _commandQueue.insert(0, _currentCommand!);
            _pendingCommands[command]?.cancel();
            _pendingCommands.remove(command);
          } else {
            // Max retries reached, complete with error
            _logger.warning('Max retries reached for command: $command');
            _pendingCommands[command]?.complete('ERROR');
            _pendingCommands.remove(command);
          }
        }
        
        _currentCommand = null;
        _processingCommand = false;
        
        // Process next command in queue
        Timer(Duration(milliseconds: 100), _processNextCommand);
        return;
      }
    }
    
    // Handle standard responses
    if (_currentCommand != null) {
      final command = _currentCommand!.command;
      
      // Check if this response is for the current command
      if (_pendingCommands.containsKey(command)) {
        // Check for stale or duplicate responses
        final lastResponse = _lastResponses[command];
        final now = DateTime.now();
        
        if (lastResponse == response) {
          // Identical response, increment counter
          _identicalResponseCounts[command] = (_identicalResponseCounts[command] ?? 0) + 1;
          _logger.fine('Identical response for $command: count = ${_identicalResponseCounts[command]}');
          
          // If we've seen too many identical responses, log a warning
          if (_identicalResponseCounts[command]! >= _maxIdenticalResponses) {
            _logger.warning('Too many identical responses for $command: $response');
            
            // For critical commands like RPM, attempt recovery
            if (_currentCommand!.pid == ObdConstants.pidEngineRpm || 
                _currentCommand!.pid == ObdConstants.pidVehicleSpeed) {
              _logger.info('Attempting recovery for important PID: ${_currentCommand!.pid}');
              
              // Reset the counter but continue with this response
              _identicalResponseCounts[command] = 0;
            }
          }
        } else {
          // New response, reset counter
          _identicalResponseCounts[command] = 0;
          _lastResponses[command] = response;
        }
        
        // Track response time for this command
        _lastResponseTimes[command] = now;
        
        // Complete the pending command
        _pendingCommands[command]?.complete(response);
        _pendingCommands.remove(command);
        
        // Reset retry counter on success
        _commandRetries.remove(command);
        
        // Process the data for OBD commands
        if (_currentCommand!.mode == '01') {
          // Process the response to get OBD data
          var data = _processResponseWithValidation(response, _currentCommand!);
          
          if (data != null) {
            // Only add valid data to the stream
            _dataStreamController.add(data);
          }
        }
        
        _currentCommand = null;
        _processingCommand = false;
        
        // Process next command in queue
        Timer(Duration(milliseconds: 100), _processNextCommand);
      }
    }
  }
  
  /// Process the next command in the queue
  Future<void> _processNextCommand() async {
    if (_processingCommand || _commandQueue.isEmpty) {
      return;
    }
    
    _processingCommand = true;
    
    // Prioritize commands in the queue to favor critical values like RPM and speed
    _prioritizeCommandQueue();
    
    final command = _commandQueue.removeAt(0);
    _currentCommand = command;
    
    // Send the command
    await connection.sendCommand(command.command);
  }
  
  /// Prioritize commands in the queue to favor critical values like RPM and speed
  void _prioritizeCommandQueue() {
    if (_commandQueue.isEmpty) return;
    
    // Define critical PIDs to prioritize
    final criticalPids = [ObdConstants.pidEngineRpm, ObdConstants.pidVehicleSpeed];
    
    // Define a second tier of important but non-critical PIDs
    final secondaryPids = [ObdConstants.pidThrottlePosition, ObdConstants.pidEngineLoad];
    
    // Enhanced prioritization algorithm
    // 1. First pass - move critical PIDs to front of queue
    bool movedCritical = false;
    for (int i = 0; i < _commandQueue.length; i++) {
      final command = _commandQueue[i];
      
      // If it's a mode 01 command and has a critical PID
      if (command.mode == '01' && criticalPids.contains(command.pid)) {
        // If it's not already at the front of the queue, move it there
        if (i > 0) {
          _commandQueue.removeAt(i);
          _commandQueue.insert(0, command);
          _logger.fine('Prioritized critical command for PID: ${command.pid}');
          movedCritical = true;
          break; // Only move one command per pass to avoid continuous shuffling
        }
      }
    }
    
    // 2. Second pass - if we didn't move any critical PIDs, try secondary PIDs
    if (!movedCritical) {
      for (int i = 0; i < _commandQueue.length; i++) {
        final command = _commandQueue[i];
        
        // If it's a mode 01 command and has a secondary important PID
        if (command.mode == '01' && secondaryPids.contains(command.pid)) {
          // If it's not already near the front of the queue, move it forward
          if (i > 1) { // Keep at least one spot for critical PIDs
            _commandQueue.removeAt(i);
            _commandQueue.insert(1, command); // Insert after the first item
            _logger.fine('Prioritized secondary command for PID: ${command.pid}');
            break;
          }
        }
      }
    }
    
    // 3. Special handling for throttle position - if engine is accelerating
    // In this case, throttle becomes critical for UI responsiveness
    bool isAccelerating = false;
    
    // Check if RPM is increasing which indicates acceleration
    if (_lastRpmValues.length >= 2) {
      final latestRpm = _lastRpmValues.last;
      final previousRpm = _lastRpmValues[_lastRpmValues.length - 2];
      
      if (latestRpm > previousRpm && latestRpm - previousRpm > 100) {
        isAccelerating = true;
        _logger.fine('Detected acceleration: RPM change from $previousRpm to $latestRpm');
      }
    }
    
    // If accelerating, prioritize throttle position
    if (isAccelerating) {
      for (int i = 0; i < _commandQueue.length; i++) {
        final command = _commandQueue[i];
        
        if (command.mode == '01' && command.pid == ObdConstants.pidThrottlePosition) {
          if (i > 1) { // Keep RPM and speed at front if possible
            _commandQueue.removeAt(i);
            _commandQueue.insert(min(2, _commandQueue.length), command);
            _logger.fine('Prioritized throttle position during acceleration');
          }
          break;
        }
      }
    }
  }
  
  /// Process the response to get OBD data with improved validation
  ObdData? _processResponseWithValidation(String response, ObdCommand command) {
    // Add diagnostic logging for critical PIDs (ADDED)
    if (command.pid == ObdConstants.pidVehicleSpeed || command.pid == ObdConstants.pidEngineRpm) {
      _logDetailedDiagnostics(response, command);
    }
    
    // Process the response to get OBD data
    var data = responseProcessor.processResponse(response, command);
    
    if (data != null) {
      // Apply additional validation based on PID
      if (command.pid == ObdConstants.pidEngineRpm) {
        data = _validateRpmReading(data, response);
        
        // Store valid RPM reading in history for acceleration detection
        if (data != null && data.value is num) {
          final rpm = (data.value as num).toInt();
          _lastRpmValues.add(rpm);
          
          // Keep history at max size
          if (_lastRpmValues.length > _maxRpmHistorySize) {
            _lastRpmValues.removeAt(0);
          }
        }
      } else if (command.pid == ObdConstants.pidVehicleSpeed) {
        data = _validateSpeedReading(data, response);
        
        // Store valid speed reading in history for anomaly detection
        if (data != null && data.value is num) {
          final speed = (data.value as num).toInt();
          _lastSpeedValues.add(speed);
          
          // Keep history at max size
          if (_lastSpeedValues.length > _maxSpeedHistorySize) {
            _lastSpeedValues.removeAt(0);
          }
        }
      } else if (command.pid == ObdConstants.pidThrottlePosition) {
        data = _validateThrottleReading(data, response);
      }
    }
    
    return data;
  }
  
  /// Validate RPM readings to prevent false readings
  /// 
  /// This method detects and corrects known issues with RPM readings:
  /// 1. Premium adapters sometimes return a fixed value (59 RPM) when the engine is off
  /// 2. Some adapters return very low values (1-20 RPM) which aren't physically possible
  /// 3. Cheap adapters might return stale values that need verification
  /// 
  /// Returns null if the reading is determined to be invalid
  ObdData? _validateRpmReading(ObdData data, String rawResponse) {
    // UPDATED: Since we're having OBD issues, this function is modified to pass through
    // all RPM values without restrictive validation to see the raw data coming from the adapter
    
    // Log the raw RPM data for debugging
    _logger.info('Raw RPM data: value=${data.value}, rawBytes=${data.rawData}');
    
    // Extract the RPM value for logging only
    dynamic rpmValue = data.value;
    int rpm = 0;
    
    // Convert to integer just for logging
    if (rpmValue is int) {
      rpm = rpmValue;
    } else if (rpmValue is double) {
      rpm = rpmValue.toInt();
    } else if (rpmValue is String) {
      try {
        rpm = int.parse(rpmValue);
      } catch (e) {
        _logger.warning('Non-integer RPM value: $rpmValue');
      }
    }
    
    // Log the raw response for debugging
    _logger.info('Raw RPM response: "$rawResponse" -> $rpm RPM');
    
    // Return data without validation
    return data.copyWith(timestamp: DateTime.now());
  }
  
  /// Validate speed readings to eliminate erroneous values and reduce lag
  /// 
  /// UPDATED: Made less strict to troubleshoot issues
  ObdData? _validateSpeedReading(ObdData data, String rawResponse) {
    // Log the raw speed data for debugging
    _logger.info('Raw speed data: value=${data.value}, rawBytes=${data.rawData}');
    
    // Extract the speed value for logging only
    dynamic speedValue = data.value;
    int speed = 0;
    
    // Convert to integer just for logging
    if (speedValue is int) {
      speed = speedValue;
    } else if (speedValue is double) {
      speed = speedValue.toInt();
    } else if (speedValue is String) {
      try {
        speed = int.parse(speedValue);
      } catch (e) {
        _logger.warning('Non-integer speed value: $speedValue');
      }
    }
    
    // Log the raw response for debugging
    _logger.info('Raw speed response: "$rawResponse" -> $speed km/h');
    
    // Return data without validation
    return data.copyWith(timestamp: DateTime.now());
  }
  
  /// Validate throttle position readings to filter out anomalous values
  ///
  /// This method checks for physically impossible values or data errors:
  /// 1. Throttle position should be between 0-100%
  /// 2. Some cheap adapters can return erroneous high values
  /// 3. Throttle values sometimes need interpretation depending on the protocol
  ///
  /// Returns null if the reading is determined to be invalid
  ObdData? _validateThrottleReading(ObdData data, String rawResponse) {
    // Extract the throttle value
    dynamic throttleValue = data.value;
    
    if (throttleValue == null) {
      return null;
    }
    
    // Convert to double for easier validation
    double throttle;
    if (throttleValue is int) {
      throttle = throttleValue.toDouble();
    } else if (throttleValue is double) {
      throttle = throttleValue;
    } else if (throttleValue is String) {
      try {
        throttle = double.parse(throttleValue);
      } catch (e) {
        _logger.warning('Invalid throttle value format: $throttleValue');
        return null;
      }
    } else {
      _logger.warning('Unknown throttle value type: ${throttleValue.runtimeType}');
      return null;
    }
    
    // Check for physically impossible values
    // Throttle should be 0-100%
    if (throttle < 0 || throttle > 100) {
      _logger.warning('Ignoring invalid throttle reading: $throttle% (must be 0-100%)');
      return null;
    }
    
    // Some adapters return raw voltage values instead of percentages
    // Raw voltage would typically be between 0-5V
    if (throttle <= 5.0 && rawResponse.toLowerCase().contains('41 11')) {
      // Convert from voltage to percentage (assuming 5V = 100%)
      _logger.info('Converting throttle from voltage ($throttle V) to percentage');
      throttle = (throttle / 5.0) * 100.0;
      
      // Create a new data object with the corrected value
      return ObdData(
        mode: data.mode,
        pid: data.pid,
        rawData: data.rawData,
        name: data.name,
        value: throttle,
        unit: '%',
        timestamp: DateTime.now(),
      );
    }
    
    // Always return a fresh instance with updated timestamp
    return data.copyWith(timestamp: DateTime.now());
  }
  
  @override
  Future<String> sendCommand(String command) async {
    if (!connection.isConnected) {
      _logger.warning('Cannot send command: not connected');
      return '';
    }
    
    final completer = Completer<String>();
    
    // Create a timer to handle timeout
    final timer = Timer(Duration(milliseconds: config.commandTimeoutMs), () {
      if (!completer.isCompleted) {
        _logger.warning('Command timeout: $command');
        completer.complete('TIMEOUT');
        _pendingCommands.remove(command);
        _processingCommand = false;
        _currentCommand = null;
        
        // Process next command in queue
        Timer(Duration(milliseconds: 100), _processNextCommand);
      }
    });
    
    // Store the completer and timer
    _pendingCommands[command] = CompleterWithTimeout(completer, timer);
    
    // Add the command to the queue
    _commandQueue.add(ObdCommand(
      mode: 'AT',
      pid: command.substring(2),
      name: 'Custom Command',
      description: 'Custom command: $command',
    ));
    
    // Process the command queue
    _processNextCommand();
    
    // Wait for the result
    return await completer.future;
  }
  
  @override
  Future<String> sendObdCommand(ObdCommand command) async {
    if (!connection.isConnected) {
      _logger.warning('Cannot send OBD command: not connected');
      return '';
    }
    
    if (!_isInitialized && command != ObdCommands.reset) {
      _logger.warning('Protocol not initialized, initializing now...');
      await initialize();
    }
    
    final completer = Completer<String>();
    
    // Create a timer to handle timeout
    final timer = Timer(Duration(milliseconds: config.commandTimeoutMs), () {
      if (!completer.isCompleted) {
        _logger.warning('Command timeout: ${command.command}');
        completer.complete('TIMEOUT');
        _pendingCommands.remove(command.command);
        _processingCommand = false;
        _currentCommand = null;
        
        // Process next command in queue
        Timer(Duration(milliseconds: 100), _processNextCommand);
      }
    });
    
    // Store the completer and timer
    _pendingCommands[command.command] = CompleterWithTimeout(completer, timer);
    
    // Add the command to the queue
    _commandQueue.add(command);
    
    // Process the command queue
    _processNextCommand();
    
    // Wait for the result
    return await completer.future;
  }
  
  @override
  Future<ObdData?> requestPid(String pid) async {
    if (!connection.isConnected) {
      _logger.warning('Cannot request PID: not connected');
      return null;
    }
    
    if (!_isInitialized) {
      _logger.warning('Protocol not initialized, initializing now...');
      await initialize();
    }
    
    try {
      final command = ObdCommand.mode01(
        pid,
        name: 'PID Request',
        description: 'Request for PID $pid',
      );
      
      final response = await sendObdCommand(command);
      final data = responseProcessor.processResponse(response, command);
      
      // Add special validation for different PIDs
      if (data != null) {
        if (pid == ObdConstants.pidVehicleSpeed) {
          return _validateSpeedReading(data, response);
        } else if (pid == ObdConstants.pidThrottlePosition) {
          return _validateThrottleReading(data, response);
        }
      }
      
      return data;
    } catch (e) {
      _logger.severe('Error requesting PID $pid: $e');
      return null;
    }
  }
  
  @override
  Future<Map<String, ObdData>> requestPids(List<String> pids) async {
    final results = <String, ObdData>{};
    
    for (final pid in pids) {
      final data = await requestPid(pid);
      if (data != null) {
        results[pid] = data;
      }
    }
    
    return results;
  }
  
  /// Execute an OBD command and return the result
  @override
  Future<String> executeCommand(ObdCommand command) async {
    if (!_isInitialized) {
      throw Exception('Protocol not initialized');
    }

    _currentCommand = command;
    
    // Start tracking the command execution time
    final startTime = DateTime.now().millisecondsSinceEpoch;
    String result = '';
    bool isSuccess = false;
    bool isTimeout = false;
    
    try {
      // Use the existing sendObdCommand method
      result = await sendObdCommand(command);
      isSuccess = true;
    } catch (e) {
      _logger.warning('Error executing command ${command.command}: $e');
      
      // Check if the error was a timeout
      isTimeout = e.toString().contains('timeout');
      
      rethrow;
    } finally {
      // Calculate execution time
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final executionTime = endTime - startTime;
      
      // Record command performance metrics
      _recordCommandMetrics(command, isSuccess, executionTime, isTimeout);
      
      // Report to profile manager if available - fix null safety issues
      if (profileManager != null && deviceId != null) {
        if (isSuccess) {
          profileManager?.reportCommandSuccess(deviceId!, config.profileId);
        } else {
          profileManager?.reportCommandFailure(deviceId!, config.profileId);
        }
      }
    }
    
    return result;
  }
  
  /// Record metrics about command execution
  void _recordCommandMetrics(ObdCommand command, bool isSuccess, int executionTime, bool isTimeout) {
    if (deviceId == null) return;
    
    // Estimate response time based on command execution time
    // This is a rough estimate and will be more accurate with real timing data
    final estimatedResponseTime = executionTime ~/ 2;
    
    // Record metrics for this command execution
    _configValidator.recordRuntimeMetrics(deviceId!, config, {
      'success': isSuccess,
      'timeout': isTimeout,
      'responseTime': estimatedResponseTime,
      'commandDuration': executionTime,
      'command': command.command,
    });
    
    // Log performance data for debugging
    if (_isDebugMode) {
      _logger.fine('Command ${command.command} executed in ${executionTime}ms');
      if (isTimeout) {
        _logger.warning('Command ${command.command} timed out');
      }
    }
    
    // If we have a profile manager and device ID, check if we need to adjust the config
    if (profileManager != null && deviceId != null) {
      final stats = _configValidator.getRuntimeStatistics(deviceId!, config.profileId);
      
      if (stats != null) {
        final commandCount = stats['commandCount'] as int;
        final successRate = stats['successRate'] as double;
        
        // If we have enough data and success rate is problematic, log a warning
        if (commandCount >= 20 && successRate < 0.7) {
          _logger.warning('Low success rate (${(successRate * 100).toStringAsFixed(1)}%) '
                        'detected for adapter ${config.profileId}');
          
          // Try to get an optimized configuration based on runtime metrics
          final optimizedConfig = _configValidator.calculateOptimizedConfig(deviceId!, config.profileId);
          
          if (optimizedConfig != null) {
            _logger.info('Optimized configuration available for device: $deviceId');
          }
        }
      }
    }
  }
  
  /// Initialize the protocol
  @override
  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }
    
    if (_isConnecting) {
      return false;
    }
    
    _isConnecting = true;
    
    try {
      // Validate configuration before using it
      final validationResult = _configValidator.validateConfig(config);
      
      if (!validationResult['isValid']) {
        final issues = validationResult['issues'] as List<String>;
        _errorMessage = 'Invalid adapter configuration: ${issues.join(', ')}';
        _logger.severe(_errorMessage);
        return false;
      }
      
      // Use the validated configuration (which might have been adjusted)
      final validatedConfig = validationResult['config'] as AdapterConfig;
      
      // Handle different initialization procedures based on adapter configuration
      try {
        bool initialized;
        
        // Select initialization method based on configuration
        if (validatedConfig.useExtendedInitDelays) {
          _logger.info('Using extended initialization for cheap adapter');
          initialized = await _initializeWithExtendedDelays();
        } else {
          _logger.info('Using standard initialization for premium adapter');
          initialized = await _initializeWithStandardDelays();
        }
        
        if (initialized) {
          _logger.info('Protocol initialized successfully');
          _isInitialized = true;
          _isConnecting = false;
          return true;
        } else {
          _logger.severe('Failed to initialize protocol');
          _errorMessage = 'Failed to initialize protocol';
          
          // Report initialization failure to profile manager
          if (profileManager != null && deviceId != null) {
            profileManager!.reportCommandFailure(deviceId!, config.profileId);
          }
          
          return false;
        }
      } catch (e) {
        _logger.severe('Error initializing protocol: $e');
        _errorMessage = 'Error initializing protocol: $e';
        
        // Report initialization failure to profile manager
        if (profileManager != null && deviceId != null) {
          profileManager!.reportCommandFailure(deviceId!, config.profileId);
        }
        
        return false;
      }
    } catch (e) {
      _errorMessage = 'Initialization failed: $e';
      _logger.severe(_errorMessage);
      _isConnecting = false;
      return false;
    }
  }
  
  /// Initialize with standard delays for premium adapters
  Future<bool> _initializeWithStandardDelays() async {
    _logger.info('Using standard initialization delays');
    
    // Send initialization commands with standard delays
    for (final command in ObdCommands.initializationCommands) {
      _logger.fine('Sending init command: ${command.command}');
      
      try {
        final response = await sendCommandWithTimeout(
          command, 
          timeoutMs: config.commandTimeoutMs,
        );
        
        _logger.fine('Init command response: $response');
        
        // Standard delays between commands
        if (command == ObdCommands.reset) {
          await Future.delayed(Duration(milliseconds: config.resetDelayMs));
        } else {
          await Future.delayed(Duration(milliseconds: config.initCommandDelayMs));
        }
      } catch (e) {
        _logger.warning('Init command failed: ${command.command}', e);
        // Continue with other commands even if one fails
      }
    }
    
    _isInitialized = true;
    return true;
  }
  
  /// Initialize with extended delays for cheap adapters
  ///
  /// This method uses longer delays to ensure reliable initialization 
  /// with cheap or counterfeit adapters.
  Future<bool> _initializeWithExtendedDelays() async {
    _logger.info('Using extended initialization delays for cheap adapter');
    
    // First check if the connection is actually established
    if (!connection.isConnected) {
      _logger.severe('Cannot initialize protocol: connection not established');
      return false;
    }
    
    // Add a larger delay to ensure connection is fully ready for cheap adapters
    await Future.delayed(Duration(milliseconds: 1000));
    
    // Send initialization commands with longer delays
    for (final command in ObdCommands.initializationCommands) {
      _logger.fine('Sending init command: ${command.command}');
      
      try {
        final response = await sendCommandWithTimeout(
          command, 
          timeoutMs: config.commandTimeoutMs + 1000, // Add 1 second for cheap adapters
        );
        
        _logger.fine('Init command response: $response');
        
        // Extended delays for cheap adapters
        if (command == ObdCommands.reset) {
          await Future.delayed(Duration(milliseconds: config.resetDelayMs * 2));
        } else {
          await Future.delayed(Duration(milliseconds: config.initCommandDelayMs * 2));
        }
      } catch (e) {
        _logger.warning('Init command failed: ${command.command}', e);
        // Continue with other commands even if one fails
      }
    }
    
    _isInitialized = true;
    return true;
  }

  /// Send a command with timeout
  Future<String> sendCommandWithTimeout(ObdCommand command, {required int timeoutMs}) async {
    // Adjust timeout for particularly important commands
    int adjustedTimeout = timeoutMs;
    if (command.mode == '01' && 
        (command.pid == ObdConstants.pidEngineRpm || 
         command.pid == ObdConstants.pidVehicleSpeed)) {
      // Use a shorter timeout for critical commands to improve responsiveness
      adjustedTimeout = (timeoutMs * 0.7).toInt(); // 30% faster timeout
      _logger.fine('Using shorter timeout (${adjustedTimeout}ms) for critical command: ${command.command}');
    }
    
    // Special handling for reset command for cheap adapters
    if (command == ObdCommands.reset && config.profileId == 'cheap_elm327') {
      _logger.info('Using special handling for reset command on cheap adapter');
      
      // Send the reset command directly without using the command queue
      await connection.sendCommand(command.command);
      
      // Wait for a longer time after reset for cheap adapters
      await Future.delayed(Duration(milliseconds: config.resetDelayMs * 2));
      
      // Return a mock OK response
      return 'ELM327 v1.5\nOK';
    }
    
    // Normal command handling for other commands
    final completer = Completer<String>();
    
    // Create a timer to handle timeout
    final timer = Timer(Duration(milliseconds: adjustedTimeout), () {
      if (!completer.isCompleted) {
        _logger.warning('Command timeout: ${command.command}');
        completer.complete('TIMEOUT');
      }
    });
    
    // Send the command
    await connection.sendCommand(command.command);
    
    // Set up a subscription to listen for responses
    late StreamSubscription subscription;
    subscription = connection.dataStream.listen((response) {
      if (response.isNotEmpty && 
          response != 'SEARCHING...' && 
          response != 'CONNECTED' && 
          response != 'DISCONNECTED') {
        
        _logger.fine('Received response for ${command.command}: $response');
        
        // Complete the future with the response
        if (!completer.isCompleted) {
          completer.complete(response);
          subscription.cancel();
          timer.cancel();
        }
      }
    });
    
    // Wait for a response or timeout
    final response = await completer.future;
    subscription.cancel();
    
    return response;
  }
  
  @override
  void dispose() {
    _logger.info('Disposing ELM327 protocol');
    
    // Cancel any pending commands
    for (var pendingCommand in _pendingCommands.values) {
      pendingCommand.cancel();
    }
    _pendingCommands.clear();
    
    // Cancel connection subscription
    _connectionSubscription?.cancel();
    
    // Close stream controller
    _dataStreamController.close();
  }

  /// Log detailed diagnostics for critical OBD data
  void _logDetailedDiagnostics(String response, ObdCommand command) {
    _logger.info('📊 DETAILED OBD DIAGNOSTICS 📊');
    _logger.info('PID: ${command.pid} (${command.name})');
    _logger.info('RAW RESPONSE: "${response}"');
    
    // Analyze the response format
    final cleanedResponse = response.replaceAll(RegExp(r'[\r\n>]'), ' ')
                                   .replaceAll(RegExp(r'\s+'), ' ')
                                   .trim()
                                   .toUpperCase();
                                   
    _logger.info('CLEANED: "$cleanedResponse"');
    
    // Try to parse as hex
    try {
      final parts = cleanedResponse.split(' ');
      _logger.info('PARTS: $parts');
      
      // Find the header pattern based on the command
      String expectedHeader;
      if (command.mode == '01') {
        expectedHeader = '41${command.pid.toUpperCase()}';
      } else {
        expectedHeader = '${(int.parse(command.mode, radix: 16) + 40).toRadixString(16).padLeft(2, '0').toUpperCase()}${command.pid.toUpperCase()}';
      }
      
      _logger.info('EXPECTED HEADER: $expectedHeader');
      
      // Look for the header in the response
      bool headerFound = false;
      String? dataSection;
      int dataStartIndex = -1;
      
      // Case 1: Check for the header as a complete part
      for (int i = 0; i < parts.length; i++) {
        if (parts[i] == expectedHeader || parts[i].startsWith(expectedHeader)) {
          headerFound = true;
          if (parts[i] == expectedHeader && i < parts.length - 1) {
            dataStartIndex = i + 1;
            dataSection = parts.sublist(dataStartIndex).join(' ');
          } else if (parts[i].startsWith(expectedHeader)) {
            dataSection = parts[i].substring(expectedHeader.length);
            if (dataSection.isEmpty && i < parts.length - 1) {
              dataStartIndex = i + 1;
              dataSection = parts.sublist(dataStartIndex).join(' ');
            }
          }
          break;
        }
      }
      
      // Case 2: Check for a split header across parts
      if (!headerFound && parts.length >= 2) {
        for (int i = 0; i < parts.length - 1; i++) {
          if (parts[i] == expectedHeader.substring(0, 2) && 
              parts[i+1].startsWith(expectedHeader.substring(2))) {
            headerFound = true;
            dataStartIndex = i + 1;
            String remainder = parts[i+1].substring(expectedHeader.substring(2).length);
            if (remainder.isEmpty) {
              dataStartIndex = i + 2;
              dataSection = parts.sublist(dataStartIndex).join(' ');
            } else {
              dataSection = remainder + (i+2 < parts.length ? ' ' + parts.sublist(i+2).join(' ') : '');
            }
            break;
          }
        }
      }
      
      // Case 3: Check for combined string with header inside
      if (!headerFound) {
        final combined = parts.join('');
        final headerIndex = combined.indexOf(expectedHeader);
        if (headerIndex >= 0) {
          headerFound = true;
          dataSection = combined.substring(headerIndex + expectedHeader.length);
        }
      }
      
      _logger.info('HEADER FOUND: $headerFound');
      _logger.info('DATA SECTION: ${dataSection ?? "None"}');
      
      // Extra analysis for specific PIDs
      if (command.pid == ObdConstants.pidVehicleSpeed) {
        _logger.info('SPEED ANALYSIS:');
        if (dataSection != null && dataSection.isNotEmpty) {
          try {
            // Standard speed calculation: 1st byte * 1 km/h
            int speedByte = -1;
            if (dataSection.length == 2) {
              speedByte = int.parse(dataSection, radix: 16);
            } else {
              // Try to extract the first two characters as a speed byte
              final match = RegExp(r'([0-9A-F]{2})').firstMatch(dataSection);
              if (match != null) {
                speedByte = int.parse(match.group(1)!, radix: 16);
              }
            }
            
            if (speedByte >= 0) {
              _logger.info('SPEED BYTE: $speedByte (hex: 0x${speedByte.toRadixString(16).padLeft(2, '0')})');
              
              // Calculate speed with different multipliers to see what might work
              _logger.info('STANDARD SPEED: ${speedByte * 1} km/h');
              _logger.info('MULTIPLIER 2X: ${speedByte * 2} km/h');
              _logger.info('MULTIPLIER 4X: ${speedByte * 4} km/h');
              _logger.info('MULTIPLIER 0.5X: ${speedByte * 0.5} km/h');
            }
          } catch (e) {
            _logger.info('ERROR PARSING SPEED BYTE: $e');
          }
        }
      } else if (command.pid == ObdConstants.pidEngineRpm) {
        _logger.info('RPM ANALYSIS:');
        if (dataSection != null && dataSection.isNotEmpty) {
          try {
            List<int> rpmBytes = [];
            
            // Try to extract 1 or 2 bytes for RPM
            // Standard format expects 2 bytes
            final matches = RegExp(r'([0-9A-F]{2})').allMatches(dataSection);
            for (final match in matches) {
              if (rpmBytes.length < 2) {
                rpmBytes.add(int.parse(match.group(1)!, radix: 16));
              }
            }
            
            if (rpmBytes.isNotEmpty) {
              _logger.info('RPM BYTES: $rpmBytes');
              
              // Calculate RPM with different formulas
              if (rpmBytes.length >= 2) {
                // Standard formula: ((A * 256) + B) / 4
                final standardRpm = ((rpmBytes[0] * 256) + rpmBytes[1]) / 4;
                _logger.info('STANDARD FORMULA RPM: $standardRpm');
                
                // Alternative formula 1: No division
                final alt1 = (rpmBytes[0] * 256) + rpmBytes[1];
                _logger.info('ALT 1 (NO DIVISION): $alt1');
                
                // Alternative formula 2: Division by 16
                final alt2 = ((rpmBytes[0] * 256) + rpmBytes[1]) / 16;
                _logger.info('ALT 2 (DIV BY 16): $alt2');
                
                // Alternative formula 3: Only use A-byte with multiplier
                final alt3 = rpmBytes[0] * 40;
                _logger.info('ALT 3 (A*40): $alt3');
                
                // Alternative formula 4: Only use B-byte with multiplier
                final alt4 = rpmBytes[1] * 40;
                _logger.info('ALT 4 (B*40): $alt4');
              } else if (rpmBytes.length == 1) {
                // Single byte alternative formulas
                final singleByteA = rpmBytes[0] * 40;
                _logger.info('SINGLE BYTE *40: $singleByteA');
                
                final singleByteB = rpmBytes[0] * 100;
                _logger.info('SINGLE BYTE *100: $singleByteB');
                
                final singleByteC = rpmBytes[0] * 25;
                _logger.info('SINGLE BYTE *25: $singleByteC');
              }
            }
          } catch (e) {
            _logger.info('ERROR PARSING RPM BYTES: $e');
          }
        }
      }
    } catch (e) {
      _logger.info('DIAGNOSTIC PARSING ERROR: $e');
    }
    
    _logger.info('📊 END DIAGNOSTICS 📊');
  }
} 