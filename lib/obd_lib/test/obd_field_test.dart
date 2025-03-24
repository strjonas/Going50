import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../obd_service.dart';
import '../protocol/obd_constants.dart';

/// A utility for real-world testing of OBD adapters
/// 
/// This class provides a comprehensive set of tests for validating
/// OBD adapter performance and reliability in real-world conditions.
class ObdFieldTest {
  final ObdService obdService;
  final Battery battery = Battery();
  final String deviceId;
  
  // Test configuration
  bool _isRunningTest = false;
  final _testResults = <Map<String, dynamic>>[];
  final _eventLog = <Map<String, dynamic>>[];
  
  // Test metrics
  int _connectionAttempts = 0;
  int _successfulConnections = 0;
  int _connectionDrops = 0;
  int _autoReconnects = 0;
  
  // Performance metrics
  final Map<String, List<int>> _pidResponseTimes = {};
  final Map<int, double> _pollingIntervalSuccessRates = {};
  
  // Status reporting
  final StreamController<String> _statusStreamController = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusStreamController.stream;
  
  /// Create a new instance for testing a specific adapter
  ObdFieldTest({
    required this.obdService,
    required this.deviceId,
  });
  
  /// Whether a test is currently running
  bool get isRunningTest => _isRunningTest;
  
  /// Returns the test results
  List<Map<String, dynamic>> get testResults => List.unmodifiable(_testResults);
  
  /// Logs an event during testing
  void _logEvent(String type, String description, [Map<String, dynamic>? details]) {
    final event = {
      'timestamp': DateTime.now().toIso8601String(),
      'type': type,
      'description': description,
      'details': details ?? {},
    };
    
    _eventLog.add(event);
    _statusStreamController.add(description);
    debugPrint('[$type] $description');
  }
  
  /// Run a basic connectivity test
  /// 
  /// Attempts to connect to the adapter multiple times and
  /// records success rate and connection time statistics.
  Future<void> runConnectivityTest({
    int attempts = 10,
    int delayBetweenAttemptsMs = 2000,
  }) async {
    if (_isRunningTest) {
      throw Exception('A test is already running');
    }
    
    _isRunningTest = true;
    _connectionAttempts = 0;
    _successfulConnections = 0;
    final connectionTimes = <int>[];
    
    _logEvent('test', 'Starting connectivity test with $attempts attempts');
    
    for (int i = 0; i < attempts; i++) {
      _connectionAttempts++;
      
      try {
        _logEvent('connection', 'Attempting connection #$i');
        
        final startTime = DateTime.now();
        final connected = await obdService.connect(deviceId);
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        
        if (connected) {
          _successfulConnections++;
          connectionTimes.add(duration);
          _logEvent('connection', 'Connection successful (${duration}ms)');
          
          // Verify we can get some basic data
          try {
            final rpmData = await obdService.requestPid(ObdConstants.pidEngineRpm);
            final voltageData = await obdService.requestPid(ObdConstants.pidControlModuleVoltage);
            
            _logEvent('data', 'Basic data check', {
              'rpm': rpmData?.value,
              'voltage': voltageData?.value,
            });
          } catch (e) {
            _logEvent('error', 'Failed to get basic data: $e');
          }
        } else {
          _logEvent('connection', 'Connection failed');
        }
      } catch (e) {
        _logEvent('error', 'Connection error: $e');
      } finally {
        if (obdService.isConnected) {
          obdService.disconnect();
        }
        await Future.delayed(Duration(milliseconds: delayBetweenAttemptsMs));
      }
    }
    
    // Calculate results
    final successRate = _successfulConnections / _connectionAttempts;
    final avgConnectionTime = connectionTimes.isEmpty 
        ? 0 
        : connectionTimes.reduce((a, b) => a + b) / connectionTimes.length;
    
    final results = {
      'test_type': 'connectivity',
      'timestamp': DateTime.now().toIso8601String(),
      'attempts': attempts,
      'successful_connections': _successfulConnections,
      'success_rate': successRate,
      'average_connection_time_ms': avgConnectionTime,
      'connection_times': connectionTimes,
    };
    
    _testResults.add(results);
    _isRunningTest = false;
    
    _logEvent('test', 'Connectivity test completed. Success rate: ${(successRate * 100).toStringAsFixed(1)}%, Avg time: ${avgConnectionTime.toStringAsFixed(0)}ms');
  }
  
  /// Run a performance test with different polling rates
  /// 
  /// Tests how the adapter performs with different polling intervals
  /// and numbers of PIDs requested.
  Future<void> runPerformanceTest({
    List<int> pollingIntervals = const [500, 1000, 2000],
    List<int> pidCounts = const [1, 3, 5, 10],
    int testDurationSeconds = 30,
  }) async {
    if (_isRunningTest) {
      throw Exception('A test is already running');
    }
    
    _isRunningTest = true;
    _pidResponseTimes.clear();
    _pollingIntervalSuccessRates.clear();
    
    _logEvent('test', 'Starting performance test');
    
    // First connect to the adapter
    final connected = await obdService.connect(deviceId);
    if (!connected) {
      _isRunningTest = false;
      throw Exception('Failed to connect to adapter');
    }
    
    final performanceData = <Map<String, dynamic>>[];
    final startBattery = await battery.batteryLevel;
    
    try {
      // Test each polling interval
      for (final intervalMs in pollingIntervals) {
        // Test each PID count
        for (final pidCount in pidCounts) {
          // Select PIDs to test
          final pids = _selectTestPids(pidCount);
          
          _logEvent('test', 'Testing with interval=${intervalMs}ms, PIDs=$pidCount');
          
          final testResults = await _runPollingIntervalTest(
            pids: pids,
            pollingIntervalMs: intervalMs,
            durationSeconds: testDurationSeconds,
          );
          
          performanceData.add({
            'polling_interval_ms': intervalMs,
            'pid_count': pidCount,
            'success_rate': testResults['success_rate'],
            'avg_response_time_ms': testResults['avg_response_time_ms'],
            'data_points_received': testResults['data_points_received'],
            'response_times_by_pid': testResults['response_times_by_pid'],
          });
          
          // Update overall metrics
          _pollingIntervalSuccessRates[intervalMs] = testResults['success_rate'];
        }
      }
    } finally {
      obdService.disconnect();
    }
    
    final endBattery = await battery.batteryLevel;
    final batteryDrain = startBattery - endBattery;
    
    // Calculate optimal settings
    final optimalInterval = _findOptimalPollingInterval();
    final optimalPidCount = _findOptimalPidCount();
    
    final results = {
      'test_type': 'performance',
      'timestamp': DateTime.now().toIso8601String(),
      'test_duration_seconds': testDurationSeconds * pollingIntervals.length * pidCounts.length,
      'performance_data': performanceData,
      'battery_drain_percent': batteryDrain,
      'recommendations': {
        'optimal_polling_interval_ms': optimalInterval,
        'optimal_pid_count': optimalPidCount,
      }
    };
    
    _testResults.add(results);
    _isRunningTest = false;
    
    _logEvent('test', 'Performance test completed. Optimal settings: interval=${optimalInterval}ms, PIDs=$optimalPidCount');
  }
  
  /// Run a stability test for a longer duration
  /// 
  /// Tests the adapter's stability over an extended period,
  /// including how it handles reconnections.
  Future<void> runStabilityTest({
    int durationMinutes = 30,
    int pollingIntervalMs = 1000,
    int pidCount = 5,
    bool simulateDisconnects = true,
    int disconnectIntervalMinutes = 5,
  }) async {
    if (_isRunningTest) {
      throw Exception('A test is already running');
    }
    
    _isRunningTest = true;
    _connectionDrops = 0;
    _autoReconnects = 0;
    
    _logEvent('test', 'Starting stability test for $durationMinutes minutes');
    
    // Connect to the adapter
    final connected = await obdService.connect(deviceId);
    if (!connected) {
      _isRunningTest = false;
      throw Exception('Failed to connect to adapter');
    }
    
    final pids = _selectTestPids(pidCount);
    final startTime = DateTime.now();
    final dataPoints = <DateTime, Map<String, dynamic>>{};
    final startBattery = await battery.batteryLevel;
    
    // Setup memory tracking
    final memorySnapshots = <DateTime, int>{}; 
    
    // Create a timer for simulating disconnects if enabled
    Timer? disconnectTimer;
    if (simulateDisconnects) {
      disconnectTimer = Timer.periodic(
        Duration(minutes: disconnectIntervalMinutes),
        (_) async {
          if (_isRunningTest) {
            _logEvent('test', 'Simulating disconnect');
            _connectionDrops++;
            obdService.disconnect();
            
            // Wait a few seconds before reconnecting
            await Future.delayed(const Duration(seconds: 3));
            
            // Try to reconnect
            final reconnected = await obdService.connect(deviceId);
            if (reconnected) {
              _autoReconnects++;
              _logEvent('connection', 'Successfully reconnected');
            } else {
              _logEvent('error', 'Failed to reconnect');
            }
          }
        },
      );
    }
    
    // Track whether we're still running the test
    bool isTestRunning = true;
    final testCompleteTimer = Timer(Duration(minutes: durationMinutes), () {
      isTestRunning = false;
    });
    
    // Create a polling mechanism
    int successfulPolls = 0;
    int failedPolls = 0;
    
    try {
      while (isTestRunning) {
        if (obdService.isConnected) {
          // Collect data for all PIDs
          final pollStartTime = DateTime.now();
          final dataMap = <String, dynamic>{};
          bool pollSucceeded = false;
          
          try {
            // Request each PID
            for (final pid in pids) {
              final responseStartTime = DateTime.now();
              final data = await obdService.requestPid(pid);
              
              if (data != null) {
                final responseTime = DateTime.now().difference(responseStartTime).inMilliseconds;
                dataMap[pid] = {
                  'value': data.value,
                  'unit': data.unit,
                  'response_time_ms': responseTime,
                };
                
                // Add to response times tracking
                _pidResponseTimes.putIfAbsent(pid, () => []).add(responseTime);
              }
            }
            
            // If we got any data, consider the poll successful
            if (dataMap.isNotEmpty) {
              pollSucceeded = true;
              successfulPolls++;
            } else {
              failedPolls++;
            }
          } catch (e) {
            _logEvent('error', 'Error polling data: $e');
            failedPolls++;
          }
          
          final pollDuration = DateTime.now().difference(pollStartTime).inMilliseconds;
          
          // Record data point
          dataPoints[DateTime.now()] = {
            'poll_duration_ms': pollDuration,
            'data': dataMap,
            'successful': pollSucceeded,
          };
          
          // Take a memory snapshot every 5 minutes
          final sinceStart = DateTime.now().difference(startTime).inMinutes;
          if (sinceStart % 5 == 0 && !memorySnapshots.containsKey(DateTime.now())) {
            // In a real implementation, you'd use a platform channel to get actual memory usage
            // Here we're just simulating it
            memorySnapshots[DateTime.now()] = 0;
          }
          
          // Log progress periodically
          if (successfulPolls % 10 == 0) {
            final elapsedMinutes = DateTime.now().difference(startTime).inMinutes;
            final remainingMinutes = durationMinutes - elapsedMinutes;
            final testProgress = 'Test running: $elapsedMinutes/${durationMinutes}min, $successfulPolls polls completed, $remainingMinutes min remaining';
            _logEvent('progress', testProgress);
          }
        } else {
          _logEvent('connection', 'Not connected, waiting...');
        }
        
        // Wait for the polling interval
        await Future.delayed(Duration(milliseconds: pollingIntervalMs));
      }
    } finally {
      disconnectTimer?.cancel();
      testCompleteTimer.cancel();
      obdService.disconnect();
    }
    
    final endBattery = await battery.batteryLevel;
    final batteryDrain = startBattery - endBattery;
    final totalRuntime = DateTime.now().difference(startTime).inMinutes;
    final successRate = successfulPolls / (successfulPolls + failedPolls);
    
    final results = {
      'test_type': 'stability',
      'timestamp': DateTime.now().toIso8601String(),
      'planned_duration_minutes': durationMinutes,
      'actual_duration_minutes': totalRuntime,
      'polling_interval_ms': pollingIntervalMs,
      'pid_count': pidCount,
      'data_points_count': dataPoints.length,
      'successful_polls': successfulPolls,
      'failed_polls': failedPolls,
      'success_rate': successRate,
      'connection_drops': _connectionDrops,
      'successful_reconnects': _autoReconnects,
      'battery_drain_percent': batteryDrain,
    };
    
    _testResults.add(results);
    _isRunningTest = false;
    
    _logEvent('test', 'Stability test completed. Success rate: ${(successRate * 100).toStringAsFixed(1)}%, Battery drain: $batteryDrain%');
  }
  
  /// Save test results to a file
  Future<String> saveTestResults() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final fileName = 'obd_test_results_$timestamp.json';
    final file = File('${directory.path}/$fileName');
    
    final results = {
      'device_id': deviceId,
      'timestamp': DateTime.now().toIso8601String(),
      'test_results': _testResults,
      'event_log': _eventLog,
    };
    
    await file.writeAsString(jsonEncode(results));
    return file.path;
  }
  
  /// Run a test with a specific polling interval
  Future<Map<String, dynamic>> _runPollingIntervalTest({
    required List<String> pids,
    required int pollingIntervalMs,
    required int durationSeconds,
  }) async {
    final startTime = DateTime.now();
    final endTime = startTime.add(Duration(seconds: durationSeconds));
    
    int dataPointsReceived = 0;
    int successfulRequests = 0;
    int failedRequests = 0;
    final pidResponses = <String, List<int>>{};
    
    while (DateTime.now().isBefore(endTime)) {
      // Request each PID
      for (final pid in pids) {
        try {
          final requestStartTime = DateTime.now();
          final data = await obdService.requestPid(pid);
          
          if (data != null) {
            final responseTime = DateTime.now().difference(requestStartTime).inMilliseconds;
            pidResponses.putIfAbsent(pid, () => []).add(responseTime);
            successfulRequests++;
            dataPointsReceived++;
          } else {
            failedRequests++;
          }
        } catch (e) {
          _logEvent('error', 'Error requesting PID $pid: $e');
          failedRequests++;
        }
      }
      
      // Wait for the polling interval
      await Future.delayed(Duration(milliseconds: pollingIntervalMs));
    }
    
    // Calculate average response times by PID
    final avgResponseTimesByPid = <String, double>{};
    double totalAvgResponseTime = 0;
    int pidCount = 0;
    
    pidResponses.forEach((pid, times) {
      if (times.isNotEmpty) {
        final avg = times.reduce((a, b) => a + b) / times.length;
        avgResponseTimesByPid[pid] = avg;
        totalAvgResponseTime += avg;
        pidCount++;
      }
    });
    
    final overallAvgResponseTime = pidCount > 0 ? totalAvgResponseTime / pidCount : 0;
    final successRate = successfulRequests / (successfulRequests + failedRequests);
    
    return {
      'polling_interval_ms': pollingIntervalMs,
      'pid_count': pids.length,
      'duration_seconds': durationSeconds,
      'data_points_received': dataPointsReceived,
      'successful_requests': successfulRequests,
      'failed_requests': failedRequests,
      'success_rate': successRate,
      'avg_response_time_ms': overallAvgResponseTime,
      'response_times_by_pid': avgResponseTimesByPid,
    };
  }
  
  /// Select a set of test PIDs based on count
  List<String> _selectTestPids(int count) {
    // Define available PIDs to test with
    final availablePids = [
      ObdConstants.pidEngineRpm,
      ObdConstants.pidVehicleSpeed,
      ObdConstants.pidThrottlePosition,
      ObdConstants.pidCoolantTemp,
      ObdConstants.pidControlModuleVoltage,
      ObdConstants.pidFuelLevel,
      ObdConstants.pidEngineLoad,
      // Remove undefined PIDs (intake temp and timing spark)
      ObdConstants.pidSupportedPids,
    ];
    
    // Always include RPM and speed in the selected PIDs
    final criticalPids = [
      ObdConstants.pidEngineRpm,
      ObdConstants.pidVehicleSpeed,
    ];
    
    // If count is less than or equal to critical PIDs, just return those
    if (count <= criticalPids.length) {
      return criticalPids.sublist(0, count);
    }
    
    // Start with critical PIDs
    final result = List<String>.from(criticalPids);
    
    // Add remaining PIDs until we reach the desired count
    final remainingPids = availablePids
        .where((pid) => !criticalPids.contains(pid))
        .toList();
    
    final additionalCount = min(count - criticalPids.length, remainingPids.length);
    result.addAll(remainingPids.sublist(0, additionalCount));
    
    return result;
  }
  
  /// Find the optimal polling interval based on test results
  int _findOptimalPollingInterval() {
    if (_pollingIntervalSuccessRates.isEmpty) {
      return 1000; // Default
    }
    
    // Find the fastest interval with at least 90% success rate
    int optimalInterval = 1000;
    double bestScore = 0;
    
    _pollingIntervalSuccessRates.forEach((interval, successRate) {
      // Calculate a score that favors faster intervals with good success rates
      // This biases toward faster intervals but only if they're reliable
      final reliabilityFactor = successRate >= 0.9 ? 1.0 : successRate / 0.9;
      final speedFactor = 1000 / interval; // Faster intervals get higher scores
      final score = reliabilityFactor * speedFactor;
      
      if (score > bestScore) {
        bestScore = score;
        optimalInterval = interval;
      }
    });
    
    return optimalInterval;
  }
  
  /// Find the optimal PID count based on test results
  int _findOptimalPidCount() {
    if (_pidResponseTimes.isEmpty) {
      return 5; // Default
    }
    
    // Analyze response time vs. PID count from test data
    // This is a simplified approximation - in a real implementation,
    // you would do more sophisticated analysis of the test results
    
    return 5; // Simplified implementation
  }
  
  /// Dispose resources used by this test utility
  void dispose() {
    _statusStreamController.close();
  }
}

/// A widget for displaying and running OBD field tests
class ObdFieldTestScreen extends StatefulWidget {
  final ObdService obdService;
  final String deviceId;
  
  const ObdFieldTestScreen({
    super.key,
    required this.obdService,
    required this.deviceId,
  });
  
  @override
  State<ObdFieldTestScreen> createState() => _ObdFieldTestScreenState();
}

class _ObdFieldTestScreenState extends State<ObdFieldTestScreen> {
  late ObdFieldTest _fieldTest;
  final List<String> _statusMessages = [];
  Map<String, dynamic>? _lastTestResult;
  bool _isTesting = false;
  String _selectedTest = 'connectivity';
  
  @override
  void initState() {
    super.initState();
    _fieldTest = ObdFieldTest(
      obdService: widget.obdService,
      deviceId: widget.deviceId,
    );
    
    _fieldTest.statusStream.listen((message) {
      setState(() {
        _statusMessages.add(message);
        // Keep the status list at a reasonable size
        if (_statusMessages.length > 100) {
          _statusMessages.removeAt(0);
        }
      });
    });
  }
  
  @override
  void dispose() {
    _fieldTest.dispose();
    super.dispose();
  }
  
  Future<void> _runSelectedTest() async {
    if (_isTesting) return;
    
    setState(() {
      _isTesting = true;
      _statusMessages.clear();
    });
    
    try {
      switch (_selectedTest) {
        case 'connectivity':
          await _fieldTest.runConnectivityTest();
          _lastTestResult = _fieldTest.testResults.last;
          break;
        case 'performance':
          await _fieldTest.runPerformanceTest();
          _lastTestResult = _fieldTest.testResults.last;
          break;
        case 'stability':
          await _fieldTest.runStabilityTest(
            durationMinutes: 5, // Short duration for demo purposes
          );
          _lastTestResult = _fieldTest.testResults.last;
          break;
        default:
          // Add default case to handle other cases
          break;
      }
      
      // Save results to file
      if (_lastTestResult != null) {
        final filePath = await _fieldTest.saveTestResults();
        setState(() {
          _statusMessages.add('Test results saved to: $filePath');
        });
      }
    } catch (e) {
      setState(() {
        _statusMessages.add('Error: $e');
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD Field Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isTesting ? null : () async {
              try {
                if (_fieldTest.testResults.isNotEmpty) {
                  final path = await _fieldTest.saveTestResults();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Results saved to: $path')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No test results to save')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving results: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Test selection and controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedTest,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'connectivity', child: Text('Connectivity Test')),
                      DropdownMenuItem(value: 'performance', child: Text('Performance Test')),
                      DropdownMenuItem(value: 'stability', child: Text('Stability Test')),
                    ],
                    onChanged: _isTesting ? null : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedTest = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isTesting ? null : _runSelectedTest,
                  child: _isTesting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Run Test'),
                ),
              ],
            ),
          ),
          
          // Test status and logs
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Test Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: _statusMessages.length,
                        itemBuilder: (context, index) {
                          return Text(
                            _statusMessages[index],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Results preview (simplified)
          if (_lastTestResult != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Results',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Type: ${_lastTestResult!['test_type']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (_lastTestResult!['test_type'] == 'connectivity')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Success rate: ${(_lastTestResult!['success_rate'] * 100).toStringAsFixed(1)}%'),
                        Text('Avg connection time: ${_lastTestResult!['average_connection_time_ms'].toStringAsFixed(0)}ms'),
                      ],
                    )
                  else if (_lastTestResult!['test_type'] == 'performance')
                    Text('Optimal polling: ${_lastTestResult!['recommendations']['optimal_polling_interval_ms']}ms'),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 