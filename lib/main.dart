import 'package:flutter/material.dart';
import 'app.dart';
import 'services/service_locator.dart';

/// Main entry point for the Going50 application.
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await setupServiceLocator();
  
  // Run the app
  runApp(const App());
}
