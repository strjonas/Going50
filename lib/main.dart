import 'package:flutter/material.dart';
import 'app.dart';
import 'services/service_locator.dart';
import 'services/driving/driving_service.dart';
import 'firebase/firebase_initializer.dart';
import 'package:logging/logging.dart';

/// Main entry point for the Going50 application.
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logging
  final log = Logger('Main');
  
  // Initialize service locator
  await setupServiceLocator();
  
  // Connect the DrivingService to the BackgroundService now that both are registered
  await serviceLocator<DrivingService>().setupBackgroundService();
  
  // Initialize Firebase (non-blocking)
  // This will attempt to initialize Firebase, but the app will still function
  // if Firebase initialization fails or if the user doesn't have an internet connection
  FirebaseInitializer.initializeFirebase().then((initialized) {
    if (initialized) {
      log.info('Firebase initialized successfully');
    } else {
      log.warning('Firebase initialization failed - app will use local storage only');
    }
  }).catchError((e) {
    log.warning('Error during Firebase initialization: $e');
  });
  
  // Run the app
  runApp(const App());
}
