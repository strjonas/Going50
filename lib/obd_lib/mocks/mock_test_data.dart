import 'dart:math';
import '../protocol/obd_constants.dart';

/// Class for providing test data to mock OBD implementations
class MockTestData {
  /// The name of the pre-defined scenario to use
  final String? scenarioName;
  
  /// Custom data mapping PIDs to values
  final Map<String, List<dynamic>>? customData;
  
  /// Random number generator for simulating data
  final Random _random = Random();
  
  /// Index tracking for each PID in the test data
  final Map<String, int> _dataIndices = {};
  
  /// Last timestamp for data progression
  DateTime _lastUpdateTime = DateTime.now();
  
  /// Last values for each PID to ensure smooth transitions
  final Map<String, dynamic> _lastValues = {};
  
  /// Pre-defined scenarios
  static final Map<String, Map<String, List<dynamic>>> _scenarios = {
    'city_driving': _cityDrivingScenario(),
    'highway_driving': _highwayDrivingScenario(),
    'aggressive_driving': _aggressiveDrivingScenario(),
    'eco_driving': _ecoDrivingScenario(),
    'idle': _idleScenario(),
  };
  
  /// Creates a new MockTestData instance
  MockTestData({this.scenarioName, this.customData});
  
  /// Gets the next data value for the specified PID
  dynamic getDataForPid(String pid) {
    // First, try to get from custom data if provided
    if (customData != null && customData!.containsKey(pid)) {
      return _getNextDataPoint(pid, customData!);
    }
    
    // Next, try to get from the scenario if specified
    if (scenarioName != null && _scenarios.containsKey(scenarioName)) {
      final scenarioData = _scenarios[scenarioName]!;
      if (scenarioData.containsKey(pid)) {
        return _getNextDataPoint(pid, scenarioData);
      }
    }
    
    // Finally, fall back to generating random data
    return _generateRandomDataForPid(pid);
  }
  
  /// Gets the next data point from a sequence, handling cycling through the data
  dynamic _getNextDataPoint(String pid, Map<String, List<dynamic>> dataSource) {
    if (!dataSource.containsKey(pid) || dataSource[pid]!.isEmpty) {
      return null;
    }
    
    final dataList = dataSource[pid]!;
    
    // Initialize index if not present
    _dataIndices[pid] ??= 0;
    
    // Get data at current index
    final data = dataList[_dataIndices[pid]!];
    
    // Progress through the data naturally based on time
    final now = DateTime.now();
    if (now.difference(_lastUpdateTime).inMilliseconds >= 1000) {
      _dataIndices[pid] = (_dataIndices[pid]! + 1) % dataList.length;
      _lastUpdateTime = now;
    }
    
    return data;
  }
  
  /// Generates realistic random data for the specified PID
  dynamic _generateRandomDataForPid(String pid) {
    // Initialize with defaults if not present
    _lastValues[pid] ??= _getDefaultValue(pid);
    
    // Get the last value
    final lastValue = _lastValues[pid];
    
    // Generate a new value that's not too far from the last one
    dynamic newValue;
    
    switch (pid) {
      case ObdConstants.pidEngineRpm:
        // Limit RPM changes to +/- 200 RPM
        newValue = lastValue + (_random.nextInt(400) - 200);
        // Keep within realistic bounds
        newValue = newValue.clamp(800, 5500);
        break;
        
      case ObdConstants.pidVehicleSpeed:
        // Limit speed changes to +/- 5 km/h
        newValue = lastValue + (_random.nextInt(10) - 5);
        // Keep within realistic bounds
        newValue = newValue.clamp(0, 180);
        break;
        
      case ObdConstants.pidThrottlePosition:
        // Limit throttle changes to +/- 5%
        newValue = lastValue + (_random.nextInt(10) - 5);
        // Keep within realistic bounds
        newValue = newValue.clamp(0, 100);
        break;
        
      case ObdConstants.pidControlModuleVoltage:
        // Limit voltage changes to +/- 0.1V
        newValue = lastValue + ((_random.nextDouble() - 0.5) * 0.2);
        // Keep within realistic bounds
        newValue = newValue.clamp(11.5, 14.5);
        break;
        
      case ObdConstants.pidCoolantTemp:
        // Limit temp changes to +/- 1°C
        newValue = lastValue + (_random.nextInt(3) - 1);
        // Keep within realistic bounds
        newValue = newValue.clamp(80, 120);
        break;
        
      case ObdConstants.pidFuelLevel:
        // Fuel level decreases very gradually
        newValue = lastValue - (_random.nextDouble() * 0.5);
        // Keep within realistic bounds
        newValue = newValue.clamp(0, 100);
        break;
        
      default:
        return null;
    }
    
    // Store the new value
    _lastValues[pid] = newValue;
    return newValue;
  }
  
  /// Get default starting value for a PID
  dynamic _getDefaultValue(String pid) {
    switch (pid) {
      case ObdConstants.pidEngineRpm:
        return 1200;
      case ObdConstants.pidVehicleSpeed:
        return 0;
      case ObdConstants.pidThrottlePosition:
        return 15;
      case ObdConstants.pidControlModuleVoltage:
        return 13.8;
      case ObdConstants.pidCoolantTemp:
        return 90;
      case ObdConstants.pidFuelLevel:
        return 75;
      default:
        return 0;
    }
  }
  
  /// Creates a city driving scenario with realistic data patterns
  static Map<String, List<dynamic>> _cityDrivingScenario() {
    return {
      ObdConstants.pidEngineRpm: [
        800, 1200, 1800, 2200, 2500, 2000, 1500, 800, 900, 1500, 2000, 2300, 1800, 1200, 800
      ],
      ObdConstants.pidVehicleSpeed: [
        0, 15, 30, 45, 50, 35, 20, 0, 0, 20, 35, 40, 25, 15, 0
      ],
      ObdConstants.pidThrottlePosition: [
        0, 20, 35, 45, 40, 25, 15, 0, 0, 25, 35, 40, 25, 15, 0
      ],
      ObdConstants.pidCoolantTemp: [
        85, 85, 86, 87, 88, 89, 89, 89, 89, 89, 90, 90, 90, 90, 90
      ],
      ObdConstants.pidControlModuleVoltage: [
        14.2, 14.1, 14.0, 13.9, 14.0, 14.1, 14.2, 14.3, 14.3, 14.2, 14.1, 14.0, 14.1, 14.2, 14.3
      ],
    };
  }
  
  /// Creates a highway driving scenario with realistic data patterns
  static Map<String, List<dynamic>> _highwayDrivingScenario() {
    return {
      ObdConstants.pidEngineRpm: [
        2000, 2200, 2300, 2400, 2500, 2300, 2400, 2500, 2400, 2300, 2400, 2500
      ],
      ObdConstants.pidVehicleSpeed: [
        80, 85, 90, 95, 100, 95, 100, 105, 100, 95, 100, 105
      ],
      ObdConstants.pidThrottlePosition: [
        30, 32, 35, 37, 40, 35, 37, 40, 37, 35, 37, 40
      ],
      ObdConstants.pidCoolantTemp: [
        90, 90, 91, 91, 92, 92, 93, 93, 93, 92, 92, 92
      ],
      ObdConstants.pidControlModuleVoltage: [
        14.1, 14.1, 14.0, 14.0, 14.0, 14.1, 14.1, 14.0, 14.0, 14.1, 14.1, 14.0
      ],
    };
  }
  
  /// Creates an aggressive driving scenario with realistic data patterns
  static Map<String, List<dynamic>> _aggressiveDrivingScenario() {
    return {
      ObdConstants.pidEngineRpm: [
        1000, 2500, 3500, 4500, 5000, 4000, 4500, 5500, 3500, 2500, 3500, 4500
      ],
      ObdConstants.pidVehicleSpeed: [
        0, 30, 60, 90, 110, 90, 100, 120, 80, 60, 80, 100
      ],
      ObdConstants.pidThrottlePosition: [
        0, 50, 70, 90, 95, 70, 85, 95, 60, 40, 70, 90
      ],
      ObdConstants.pidCoolantTemp: [
        85, 87, 90, 93, 95, 97, 98, 99, 99, 99, 99, 99
      ],
      ObdConstants.pidControlModuleVoltage: [
        14.3, 14.1, 13.9, 13.7, 13.6, 13.8, 13.7, 13.6, 13.8, 14.0, 13.8, 13.7
      ],
    };
  }
  
  /// Creates an eco-friendly driving scenario with realistic data patterns
  static Map<String, List<dynamic>> _ecoDrivingScenario() {
    return {
      ObdConstants.pidEngineRpm: [
        800, 1200, 1500, 1800, 2000, 1800, 1700, 1600, 1500, 1400, 1500, 1600
      ],
      ObdConstants.pidVehicleSpeed: [
        0, 20, 40, 60, 70, 65, 60, 55, 50, 45, 50, 55
      ],
      ObdConstants.pidThrottlePosition: [
        0, 15, 25, 30, 35, 30, 25, 20, 15, 10, 15, 20
      ],
      ObdConstants.pidCoolantTemp: [
        85, 86, 87, 88, 89, 89, 89, 89, 89, 89, 89, 89
      ],
      ObdConstants.pidControlModuleVoltage: [
        14.3, 14.2, 14.1, 14.0, 14.0, 14.1, 14.1, 14.2, 14.2, 14.3, 14.2, 14.2
      ],
    };
  }
  
  /// Creates an idle scenario with realistic data patterns
  static Map<String, List<dynamic>> _idleScenario() {
    return {
      ObdConstants.pidEngineRpm: [
        750, 760, 770, 780, 790, 800, 790, 780, 770, 760, 750, 760
      ],
      ObdConstants.pidVehicleSpeed: [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ],
      ObdConstants.pidThrottlePosition: [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ],
      ObdConstants.pidCoolantTemp: [
        90, 90, 90, 91, 91, 91, 91, 91, 91, 90, 90, 90
      ],
      ObdConstants.pidControlModuleVoltage: [
        14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0, 14.0
      ],
    };
  }
  
  /// Allows registration of custom scenarios
  static void registerScenario(String name, Map<String, List<dynamic>> data) {
    _scenarios[name] = data;
  }
  
  /// Lists available scenario names
  static List<String> get availableScenarios => _scenarios.keys.toList();
} 