# OBD Library (obd_lib)

A comprehensive library for interacting with OBD-II adapters over Bluetooth for vehicle data collection, designed specifically for eco-driving applications.

## Overview

The OBD Library provides a high-level, robust interface for communicating with ELM327-based OBD-II adapters via Bluetooth. It handles the complexities of Bluetooth connectivity, protocol negotiation, command formatting, and data parsing, presenting a clean and simple API to consumer services.

This library is a core component of the eco-driving application, providing real-time vehicle data such as RPM, speed, throttle position, and more.

## Architecture

The library follows a layered architecture with clear separation of concerns:

```
┌───────────────────────────────────────────────┐
│               ObdService (Facade)             │
├───────────────────────────────────────────────┤
│    ObdProtocol    │         ObdFactory        │
│  (Elm327Protocol) │                           │
├─────────────┬─────┴───────────────────────────┤
│ ObdConnection (BluetoothConnection)           │
├───────────────────────────────────────────────┤
│          Profiles & Configuration             │
└───────────────────────────────────────────────┘
```

### Key Components

1. **ObdService** - Main facade class that consumer services interact with
2. **ObdProtocol** - Protocol implementation (currently ELM327)
3. **ObdConnection** - Connection implementation (Bluetooth)
4. **AdapterProfile** - Configuration profiles for different OBD adapters
5. **Models** - Data structures for OBD commands, responses, device info, etc.

### Data Flow

1. Consumer services interact with the `ObdService` facade
2. `ObdService` manages the protocol instance and handles data polling
3. `ObdProtocol` sends commands and processes responses from the adapter
4. `ObdConnection` handles the low-level Bluetooth communication
5. Parsed data flows back up to the consumer as `ObdData` objects

## Key Features

- **Adapter Profile System**: Automatic detection and configuration for different ELM327 adapters
- **Robust Connection Handling**: Automatic recovery from connection loss and stalled connections
- **Prioritized Polling**: Smart, dynamic polling system that prioritizes critical PIDs
- **Engine State Detection**: Accurate engine running state detection with multiple indicators
- **Throttle Position Optimization**: Enhanced responsiveness during acceleration
- **Error Handling**: Comprehensive error handling and retry mechanisms
- **Configurable Behavior**: Extensive configuration options for different adapters

## Usage

### Basic Usage

```dart
// 1. Import the library
import 'package:going50/lib/obd_lib/obd_lib.dart';

// 2. Create an instance of ObdService
final obdService = ObdService(isDebugMode: true);

// 3. Scan for Bluetooth devices
Stream<BluetoothDevice> deviceStream = obdService.scanForDevices();
await for (final device in deviceStream) {
  print('Found device: ${device.name} (${device.id})');
}

// 4. Connect to a device
bool connected = await obdService.connect(deviceId);

// 5. Start continuous queries
await obdService.startContinuousQueries();

// 6. Listen for data updates
obdService.addListener(() {
  final rpm = obdService.latestData[ObdConstants.pidEngineRpm];
  final speed = obdService.latestData[ObdConstants.pidVehicleSpeed];
  final throttle = obdService.latestData[ObdConstants.pidThrottlePosition];
  
  // Do something with the data...
});

// 7. Request specific PIDs on demand
ObdData? coolantTemp = await obdService.requestPid(ObdConstants.pidCoolantTemp);

// 8. Disconnect when done
await obdService.disconnect();
```

### Advanced Usage

#### Using Adapter Profiles

```dart
// Get available profiles
List<Map<String, String>> profiles = obdService.getAvailableProfiles();

// Set specific profile for known adapter
obdService.setAdapterProfile('premium_elm327');

// Or enable automatic profile detection
obdService.enableAutomaticProfileDetection();
```

#### Customizing Monitored PIDs

```dart
// Add PIDs to monitor
obdService.addMonitoredPid(ObdConstants.pidFuelLevel);
obdService.addMonitoredPid(ObdConstants.pidIntakeAirTemp);

// Remove PIDs from monitoring
obdService.removeMonitoredPid(ObdConstants.pidCoolantTemp);
```

#### Sending Custom Commands

```dart
// Send a raw command to the adapter
String response = await obdService.sendCustomCommand('010C');
```

## Error Handling

The library implements several error handling and recovery mechanisms:

1. **Command Retries**: Failed commands are automatically retried
2. **Connection Recovery**: Stalled or dropped connections are automatically recovered
3. **PID Failure Tracking**: PIDs that consistently fail are polled less frequently
4. **RPM Validation**: Stale or stuck RPM values are validated with additional checks

## Integration with Driving Service

The OBD library is designed to work seamlessly with the DrivingService, which coordinates data collection from multiple sources (OBD, phone sensors, etc.).

DrivingService should:
1. Create an instance of `ObdService`
2. Connect to an OBD adapter when starting a drive
3. Call `startContinuousQueries()` to begin data collection
4. Register as a listener for data updates
5. Process the OBD data along with other sensor data
6. Call `stopQueries()` and `disconnect()` when the drive ends

## Known Limitations

1. **Adapter Compatibility**: While the library supports multiple adapter profiles, it primarily targets ELM327-based adapters over Bluetooth.
2. **Polling Delay**: There is an inherent delay in the polling system, usually 500-1000ms at best.
3. **Vehicle Compatibility**: Not all vehicles support all PIDs, and some may require specialized configurations.

## Implementation Issues and Recommendations

### Current Issues

1. **Bluetooth Connection Reliability**: The current implementation sometimes struggles with connection reliability, especially during long drives or when encountering Bluetooth interference.

2. **Error Handling Inconsistencies**: Some lower-level errors in the Bluetooth layer are not properly propagated to the ObdService facade.

3. **No Centralized Error Repository**: Error messages are scattered throughout the codebase without a centralized repository, making it difficult to maintain consistent error messages.

4. **Resource Leaks**: In some exceptional cases, resources like StreamSubscriptions might not be properly cleaned up.

5. **Limited Protocol Support**: Currently, only ELM327 protocol is supported, which might limit compatibility with some vehicles.

6. **Connection Recovery Mechanism**: The connection recovery logic could be more aggressive, especially when dealing with cheap Bluetooth adapters that frequently drop connections.

### Important Implementation Notes

1. **Critical Connection Requirements**: The specific ELM327 adapter used in this project requires a strict connection sequence that must be preserved:
   - Always establish Bluetooth connection before protocol initialization
   - Include a 2000ms wait after starting Bluetooth connection
   - Follow the exact initialization command sequence
   - Maintain specific delays between commands (1000ms after reset, 300ms between others)

2. **Adapter-Specific Settings**:
   - Protocol must use ISO 14230-4 KWP (5 baud init) via command `ATSP4`
   - Baud rate must be 10.4 kbaud via command `ATBRD10`
   - Timeout must be 200ms via command `ATST20`

3. **Bluetooth Implementation**:
   - Service UUID must be `FFF0`
   - Notify (read) characteristic UUID must be `FFF1`
   - Write characteristic UUID must be `FFF2`

## Testing

### Manual Testing

1. **Connection Testing**:
   - Test connection to different adapter types
   - Test connection recovery after Bluetooth disconnect
   - Test behavior when out of range

2. **Data Polling Testing**:
   - Verify that critical PIDs (RPM, speed) are updated frequently
   - Test during different driving conditions (idle, acceleration, cruising)
   - Verify that engine state detection works correctly

3. **Error Recovery Testing**:
   - Intentionally disrupt the Bluetooth connection
   - Test with adapter power off/on during a session
   - Test with different vehicles to verify compatibility

### Automated Testing

The library should be tested with automated tests for core functionality:

1. **Unit Tests**:
   - Test protocol command formatting
   - Test response parsing
   - Test profile selection logic

2. **Integration Tests**:
   - Test with mock adapter responses
   - Test error handling and recovery
   - Test different adapter profiles

3. **Performance Tests**:
   - Measure command-response latency
   - Test polling frequency under various conditions
   - Test memory and CPU usage during extended sessions

### Test Fixtures

To facilitate testing, consider implementing:

1. **Mock OBD Connection**: A mock implementation of `ObdConnection` that returns predefined responses for testing.

2. **Mock OBD Protocol**: A mock implementation of `ObdProtocol` that simulates different adapter behaviors.

3. **Virtual OBD Device**: A virtual OBD device that can be used for integration testing without an actual physical adapter.

4. **Scenario-based Test Cases**: Predefined scenarios (e.g., engine start, highway driving, city traffic) with expected data patterns.

## Recommendations for Improvement

1. **Enhanced Diagnostics**: Add comprehensive logging and diagnostics for troubleshooting connection issues.
2. **Protocol Expansion**: Support additional OBD protocols beyond ELM327.
3. **Performance Optimization**: Further optimize the polling system for faster data updates.
4. **Cached PID Support**: Implement a cache for PIDs that change infrequently.
5. **Adapter Detection**: Improve automatic adapter profile detection accuracy.
6. **Testing Infrastructure**: Develop a comprehensive testing suite with mock adapters.
7. **Bluetooth Connection Robustness**: Implement more aggressive connection recovery mechanisms.
8. **Documentation**: Add more inline documentation and examples.
9. **Error Handling Framework**: Develop a centralized error handling and reporting system.
10. **Resource Management**: Implement a more robust resource cleanup mechanism, especially for StreamSubscriptions.

## Conclusion

The OBD Library provides a robust, high-level interface for interacting with OBD-II adapters, abstracting away the complexities of Bluetooth communication and protocol handling. It is designed to be used by the DrivingService as part of the eco-driving application to collect real-time vehicle data. 