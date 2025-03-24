import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:going50/obd_lib/obd_service.dart';
import 'package:going50/sensor_lib/sensor_service.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/behavior_classifier_lib/managers/eco_driving_manager.dart';
import 'package:logging/logging.dart';

/// Global instance of the service locator
final serviceLocator = GetIt.instance;

/// Initialize the service locator with all required dependencies
Future<void> setupServiceLocator() async {
  // Set up logging
  _setupLogging();
  
  // Register existing libraries as singletons
  _registerExistingLibraries();
  
  // Register services (will be implemented in future days)
  
  // Setup is complete
  debugPrint('Service locator initialized successfully');
}

/// Set up logging for the application
void _setupLogging() {
  // Configure logging based on build mode
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.loggerName}: ${record.time}: ${record.message}');
      if (record.error != null) {
        // ignore: avoid_print
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        // ignore: avoid_print
        print('Stack trace: ${record.stackTrace}');
      }
    });
  } else {
    // In release mode, only show warnings and errors
    Logger.root.level = Level.WARNING;
    Logger.root.onRecord.listen((record) {
      // In a real app, you might want to use a logging service
      // or store logs for later analysis
      if (record.level >= Level.WARNING) {
        debugPrint('${record.level.name}: ${record.message}');
      }
    });
  }
}

/// Register existing library instances as singletons
void _registerExistingLibraries() {
  // Register OBD service
  serviceLocator.registerLazySingleton<ObdService>(
    () => ObdService(isDebugMode: kDebugMode),
  );
  
  // Register Sensor service
  serviceLocator.registerLazySingleton<SensorService>(
    () => SensorService(isDebugMode: kDebugMode),
  );
  
  // Register Data Storage manager
  serviceLocator.registerLazySingleton<DataStorageManager>(
    () => DataStorageManager(),
  );
  
  // Register Eco Driving manager
  serviceLocator.registerLazySingleton<EcoDrivingManager>(
    () => EcoDrivingManager(),
  );
} 