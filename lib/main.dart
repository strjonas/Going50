import 'package:flutter/material.dart';
import 'app.dart';
import 'services/service_locator.dart';
import 'services/driving/driving_service.dart';

/// Main entry point for the Going50 application.
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await setupServiceLocator();
  
  // Connect the DrivingService to the BackgroundService now that both are registered
  await serviceLocator<DrivingService>().setupBackgroundService();
  
  // Run the app
  runApp(const App());
}
