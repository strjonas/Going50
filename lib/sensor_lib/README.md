# Sensor Library

This library provides a simplified interface for collecting phone sensor data in Flutter applications. It handles sensor registration, permissions, and data processing.

## Features

- Accelerometer, gyroscope, and magnetometer data collection
- GPS location tracking with configurable accuracy
- Flexible configuration options for data collection frequency
- Streams for real-time data updates
- Battery-efficient operation modes
- Clean modular architecture

## Usage

```dart
import 'package:going50/sensor_lib/sensor_lib.dart';

// Create a sensor service
final sensorService = SensorService(
  config: SensorConfig.ecoDrivingConfig,
  isDebugMode: true,
);

// Initialize the service
await sensorService.initialize();

// Start collecting data
await sensorService.startCollection(collectionIntervalMs: 200);

// Get real-time updates
sensorService.dataStream.listen((data) {
  print('New sensor data: ${data.timestamp}');
  print('Location: ${data.latitude}, ${data.longitude}');
  print('Acceleration: ${data.accelerationX}, ${data.accelerationY}, ${data.accelerationZ}');
});

// Get the latest data on demand
final latestData = await sensorService.getLatestSensorData();

// Stop collection when done
sensorService.stopCollection();

// Clean up resources
sensorService.dispose();
```

## Architecture

The library is built with a modular architecture:

- **sensor_service.dart**: Main facade that coordinates sensors and provides the API
- **interfaces/**: Abstract interfaces for each component
- **implementations/**: Concrete implementations of the interfaces
- **models/**: Data models and configuration options
- **sensor_factory.dart**: Factory for creating components with dependency injection

## Advanced Usage

For more advanced usage, you can create and provide custom implementations:

```dart
import 'package:going50/sensor_lib/sensor_lib.dart';

// Create custom components
final customConfig = SensorConfig(
  accelerometerFrequency: 30,
  gyroscopeFrequency: 15,
  locationUpdateIntervalMs: 2000,
);

final components = SensorFactory.createComponents(
  config: customConfig,
);

// Create service with custom components
final sensorService = SensorService(
  config: customConfig,
  sensorManager: components.sensors,
  locationManager: components.location,
);
```

## Testing

The architecture supports easy mocking for testing:

```dart
class MockSensorManager implements SensorManager {
  // Implement with test values
}

final testService = SensorService(
  sensorManager: MockSensorManager(),
  locationManager: MockLocationManager(),
);
```
