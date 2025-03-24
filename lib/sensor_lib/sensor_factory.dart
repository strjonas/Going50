import 'interfaces/sensor_manager.dart';
import 'interfaces/location_manager.dart';
import 'implementations/sensor_manager_impl.dart';
import 'implementations/location_manager_impl.dart';
import 'models/sensor_config.dart';

/// Factory for creating sensor components
///
/// This factory allows for easy creation of sensor components with different
/// configurations or replacements with mocks for testing.
class SensorFactory {
  /// Create a sensor manager
  static SensorManager createSensorManager({
    SensorConfig? config,
    bool useMock = false,
  }) {
    if (useMock) {
      // Return a mock implementation for testing
      throw UnimplementedError('Mock sensor manager not implemented');
    }
    
    // Return the standard implementation
    return SensorManagerImpl(config: config ?? const SensorConfig());
  }
  
  /// Create a location manager
  static LocationManager createLocationManager({
    SensorConfig? config,
    bool useMock = false,
  }) {
    if (useMock) {
      // Return a mock implementation for testing
      throw UnimplementedError('Mock location manager not implemented');
    }
    
    // Return the standard implementation
    return LocationManagerImpl(config: config ?? const SensorConfig());
  }
  
  /// Create sensor components with shared configuration
  static ({SensorManager sensors, LocationManager location}) createComponents({
    SensorConfig? config,
    bool useMock = false,
  }) {
    final effectiveConfig = config ?? const SensorConfig();
    
    return (
      sensors: createSensorManager(config: effectiveConfig, useMock: useMock),
      location: createLocationManager(config: effectiveConfig, useMock: useMock),
    );
  }
} 