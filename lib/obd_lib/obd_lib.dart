// OBD Library for Flutter
//
// This library provides a simplified interface for working with OBD-II adapters
// in Flutter applications. It handles Bluetooth connectivity, protocol
// communication, and data parsing.

library;

// Main service class
export 'obd_service.dart';

// Factory for creating connections and protocols
export 'obd_factory.dart';

// Protocols
export 'protocol/obd_protocol.dart';
export 'protocol/elm327_protocol.dart';

// Bluetooth
export 'bluetooth/bluetooth_scanner.dart';
export 'bluetooth/bluetooth_connection.dart';
export 'models/bluetooth_device.dart';

// Data models
export 'models/obd_data.dart';
export 'models/obd_command.dart';
export 'models/obd_pid_config.dart';
export 'models/adapter_config.dart';
export 'models/adapter_config_factory.dart';
export 'models/adapter_config_validator.dart';

// Constants
export 'protocol/obd_constants.dart';

// Response processors
export 'protocol/response_processor/obd_response_processor.dart';
export 'protocol/response_processor/base_response_processor.dart';
export 'protocol/response_processor/cheap_elm327_processor.dart';
export 'protocol/response_processor/premium_elm327_processor.dart';
export 'protocol/response_processor/processor_factory.dart';

// Profiles
export 'profiles/adapter_profile.dart';
export 'profiles/cheap_elm327_profile.dart';
export 'profiles/premium_elm327_profile.dart';
export 'profiles/profile_manager.dart'; 