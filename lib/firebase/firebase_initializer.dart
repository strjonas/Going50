import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:going50/services/service_locator.dart';
import 'package:going50/firebase/firebase_options.dart';

/// FirebaseInitializer handles the initialization of Firebase services
///
/// This class is responsible for:
/// - Initializing Firebase Core
/// - Setting up Crashlytics
/// - Implementing feature flags for Firebase features
class FirebaseInitializer {
  static final _log = Logger('FirebaseInitializer');
  static bool _isInitialized = false;
  
  /// Flag to determine if Firebase is enabled
  static bool get isFirebaseEnabled => _isInitialized;
  
  /// Initialize Firebase
  static Future<bool> initializeFirebase() async {
    if (_isInitialized) {
      _log.info('Firebase already initialized');
      return true;
    }
    
    try {
      _log.info('Initializing Firebase');
      
      // Try to initialize with options
      try {
        // Initialize Firebase with default options
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (optionsError) {
        _log.warning('Failed to initialize Firebase with options: $optionsError');
        _log.info('Attempting to initialize Firebase without options');
        
        // Fall back to initialize without options
        // This will work if the app was registered with the default app name
        await Firebase.initializeApp();
      }
      
      // Configure Crashlytics
      if (!kDebugMode) {
        // Enable Crashlytics only in release mode
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        
        // Pass all uncaught errors to Crashlytics
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        
        _log.info('Crashlytics enabled');
      } else {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
        _log.info('Crashlytics disabled in debug mode');
      }
      
      _isInitialized = true;
      _log.info('Firebase initialized successfully');
      
      // Register Firebase services in service locator
      // Note: setupServiceLocator is already called in main.dart before this
      // This will just ensure the Firebase services are registered
      await _registerFirebaseServices();
      
      return true;
    } catch (e) {
      _log.severe('Failed to initialize Firebase: $e');
      _isInitialized = false;
      return false;
    }
  }
  
  /// Register Firebase services in the service locator
  static Future<void> _registerFirebaseServices() async {
    try {
      // This will trigger the _registerFirebaseServices method in service_locator.dart
      await setupServiceLocator();
    } catch (e) {
      _log.warning('Error registering Firebase services: $e');
    }
  }
  
  /// Check if Firebase authentication is available
  static Future<bool> isAuthenticationAvailable() async {
    if (!_isInitialized) {
      return false;
    }
    
    try {
      // Check if Firebase is initialized
      return Firebase.apps.isNotEmpty;
    } catch (e) {
      _log.warning('Error checking Firebase authentication availability: $e');
      return false;
    }
  }
  
  /// Disable Firebase (for testing or user opt-out)
  static Future<void> disableFirebase() async {
    _log.info('Disabling Firebase functionality');
    _isInitialized = false;
  }
} 