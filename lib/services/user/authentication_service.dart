import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logging/logging.dart';
import 'package:going50/core_models/user_profile.dart';
import 'package:going50/data_lib/data_storage_manager.dart';
import 'package:going50/services/user/user_service.dart';

/// AuthenticationService handles user authentication operations
///
/// This service provides functionality for:
/// - User registration with email/password
/// - Login with email/password 
/// - Social sign-in (Google, Apple)
/// - Password reset
/// - Authentication state changes
/// - Linking accounts
/// 
/// It serves as a bridge between Firebase Authentication and the app's UserService.
class AuthenticationService {
  // Dependencies
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final DataStorageManager _dataStorageManager;
  final UserService _userService;
  
  // Logging
  final _log = Logger('AuthenticationService');
  
  // Stream controllers
  final _authStateController = StreamController<AuthState>.broadcast();
  
  // Private state
  UserProfile? _authenticatedUserProfile;
  AuthState _currentAuthState = AuthState.notInitialized;
  
  /// Constructor
  AuthenticationService(this._firebaseAuth, this._dataStorageManager, this._userService) {
    _log.info('AuthenticationService created');
    _initialize();
  }
  
  /// Initialize the service and set up listeners
  Future<void> _initialize() async {
    _log.info('Initializing AuthenticationService');
    
    // Set initial state
    _currentAuthState = AuthState.initializing;
    _emitAuthState();
    
    // Start listening to Firebase auth state changes
    _firebaseAuth.authStateChanges().listen(_handleAuthStateChange);
    
    _log.info('AuthenticationService initialized');
  }
  
  /// Handle authentication state changes from Firebase
  Future<void> _handleAuthStateChange(firebase_auth.User? firebaseUser) async {
    _log.info('Auth state changed: ${firebaseUser != null ? 'signed in' : 'signed out'}');
    
    if (firebaseUser == null) {
      // User is signed out
      _authenticatedUserProfile = null;
      _currentAuthState = AuthState.signedOut;
    } else {
      // User is signed in - check if we have a profile for this user
      final userProfile = await _getUserProfileForFirebaseUser(firebaseUser);
      
      if (userProfile == null) {
        // No profile found - this is a new user
        _currentAuthState = AuthState.newUser;
      } else {
        // Profile found - set as current user
        _authenticatedUserProfile = userProfile;
        _currentAuthState = AuthState.signedIn;
        
        // Update UserService with the authenticated user
        await _userService.setCurrentUser(userProfile);
      }
    }
    
    // Emit the new state
    _emitAuthState();
  }
  
  /// Get or create user profile for a Firebase user
  Future<UserProfile?> _getUserProfileForFirebaseUser(firebase_auth.User firebaseUser) async {
    try {
      // Try to get existing profile by Firebase UID
      var userProfile = await _dataStorageManager.getUserProfileByFirebaseId(firebaseUser.uid);
      
      if (userProfile != null) {
        _log.info('Found existing profile for Firebase user: ${firebaseUser.uid}');
        return userProfile;
      }
      
      // No profile found - get current local user
      final currentUser = _userService.currentUser;
      
      if (currentUser != null) {
        // Link existing local user to this Firebase account
        _log.info('Linking existing local user ${currentUser.id} to Firebase user ${firebaseUser.uid}');
        
        // Update the profile with Firebase ID
        userProfile = await _dataStorageManager.updateUserProfileFirebaseId(
          currentUser.id, 
          firebaseUser.uid
        );
        
        return userProfile;
      }
      
      // No local user either - return null and let caller handle new user creation
      return null;
    } catch (e) {
      _log.severe('Error getting user profile for Firebase user: $e');
      return null;
    }
  }
  
  /// Emit the current authentication state to subscribers
  void _emitAuthState() {
    _authStateController.add(_currentAuthState);
  }
  
  /// Get the current authentication state
  AuthState get currentAuthState => _currentAuthState;
  
  /// Stream of authentication state changes
  Stream<AuthState> get authStateStream => _authStateController.stream;
  
  /// Get the current authenticated user profile
  UserProfile? get currentUser => _authenticatedUserProfile;
  
  /// Get the current Firebase user
  firebase_auth.User? get firebaseUser => _firebaseAuth.currentUser;
  
  /// Check if user is authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;
  
  /// Register with email and password
  Future<AuthResult> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      _log.info('Registering new user with email: $email');
      
      // Create the user in Firebase
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(displayName);
      
      // Get or create user profile
      if (credential.user != null) {
        final userProfile = await _getUserProfileForFirebaseUser(credential.user!);
        
        if (userProfile == null) {
          // Create new profile
          final localUserId = _userService.currentUser?.id;
          
          if (localUserId != null) {
            // Update existing local profile
            await _dataStorageManager.updateUserProfile(
              localUserId,
              displayName,
              email: email,
              firebaseId: credential.user!.uid,
            );
          } else {
            // Create completely new profile - this shouldn't happen as we should always have a local user
            _log.warning('No local user found during registration - creating new profile');
            await _dataStorageManager.saveUserProfileWithFirebase(
              credential.user!.uid,
              displayName,
              true, // isPublic 
              true, // allowDataUpload
              email: email,
              firebaseId: credential.user!.uid,
            );
          }
        }
      }
      
      return AuthResult(
        success: true,
        user: credential.user,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase Auth error during registration: ${e.code}: ${e.message}');
      return AuthResult(
        success: false,
        errorCode: e.code,
        errorMessage: _getReadableErrorMessage(e.code),
      );
    } catch (e) {
      _log.severe('Error during registration: $e');
      return AuthResult(
        success: false,
        errorCode: 'unknown_error',
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }
  
  /// Sign in with email and password
  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      _log.info('Signing in user with email: $email');
      
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return AuthResult(
        success: true,
        user: credential.user,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase Auth error during sign in: ${e.code}: ${e.message}');
      return AuthResult(
        success: false,
        errorCode: e.code,
        errorMessage: _getReadableErrorMessage(e.code),
      );
    } catch (e) {
      _log.severe('Error during sign in: $e');
      return AuthResult(
        success: false,
        errorCode: 'unknown_error',
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    try {
      _log.info('Signing out user');
      await _firebaseAuth.signOut();
      
      // The auth state listener will handle updating the state
    } catch (e) {
      _log.severe('Error during sign out: $e');
      rethrow;
    }
  }
  
  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    try {
      _log.info('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      
      return AuthResult(
        success: true,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase Auth error sending reset email: ${e.code}: ${e.message}');
      return AuthResult(
        success: false,
        errorCode: e.code,
        errorMessage: _getReadableErrorMessage(e.code),
      );
    } catch (e) {
      _log.severe('Error sending reset email: $e');
      return AuthResult(
        success: false,
        errorCode: 'unknown_error',
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }
  
  /// Convert Firebase error codes to user-friendly messages
  String _getReadableErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
  
  /// Dispose of resources
  void dispose() {
    _authStateController.close();
  }
}

/// Authentication state
enum AuthState {
  notInitialized,
  initializing,
  signedOut,
  signedIn,
  newUser,
}

/// Authentication result
class AuthResult {
  final bool success;
  final firebase_auth.User? user;
  final String? errorCode;
  final String? errorMessage;
  
  AuthResult({
    required this.success,
    this.user,
    this.errorCode,
    this.errorMessage,
  });
} 