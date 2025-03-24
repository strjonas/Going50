// Sensor Library for Flutter
//
// This library provides a simplified interface for collecting and managing phone sensor data
// in Flutter applications. It handles permissions, sensor registration, and data processing.

// Export the main service class
export 'sensor_service.dart';
export 'sensor_factory.dart';

// Export interfaces
export 'interfaces/sensor_manager.dart';
export 'interfaces/location_manager.dart';

// Export models
export 'models/sensor_config.dart';

// Export implementations for advanced usage
export 'implementations/sensor_manager_impl.dart';
export 'implementations/location_manager_impl.dart';

// Re-export core models for convenience
export '../core_models/phone_sensor_data.dart'; 