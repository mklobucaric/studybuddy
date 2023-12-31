import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studybuddy/src/models/user.dart';

/// Controller for managing authentication-related operations.
///
/// This controller handles user authentication processes like registration, login,
/// logout, and checking the current user's status. It uses [AuthService] for
/// the actual authentication operations with Firebase.
class AuthenticationController with ChangeNotifier {
  // Service instance for handling authentication logic.
  final AuthService _authService = AuthService();

  // Fields to store the current user and their JSON representation.
  User? _currentUser;
  UserJson? _currentUserJson;

  // Flag to track loading state.
  bool _isLoading = false;

  // Getter methods to expose private fields.
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  UserJson? get currentUserJson => _currentUserJson;

  // Constructor initializing the authentication state.
  AuthenticationController() {
    _checkCurrentUser();
    _checkCurrentUserJson();
  }

  // Private method to update current user from AuthService.
  void _checkCurrentUser() {
    _currentUser = _authService.currentUser;
    notifyListeners();
  }

  // Private asynchronous method to fetch and update current user's JSON data.
  void _checkCurrentUserJson() async {
    var firebaseUser = _authService.currentUser; // This returns a Firebase User
    if (firebaseUser != null) {
      _currentUserJson = await _authService
          .fetchUserData(firebaseUser.uid); // Fetching custom user data
      notifyListeners();
    }
  }

  /// Registers a new user with the provided email and password.
  ///
  /// On successful registration, updates the current user state.
  /// On failure, returns an error message indicating the reason.
  ///
  /// [context] - BuildContext for UI interaction.
  /// [email] - User's email for registration.
  /// [password] - User's password for registration.
  Future<String?> register(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    String? errorMessage;

    try {
      _currentUser = await _authService.registerWithEmailPassword(
          context, email, password);
      _checkCurrentUserJson();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = 'existing_email';
      }
    } catch (e) {
      // Handle registration error
      errorMessage = 'Registration Error $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return errorMessage;
  }

  /// Logs in a user with the provided email and password.
  ///
  /// Updates the current user state on successful login.
  ///
  /// [email] - User's email for login.
  /// [password] - User's password for login.
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.loginWithEmailPassword(email, password);
      _checkCurrentUserJson();
      notifyListeners();
    } catch (e) {
      // Handle login error
      if (kDebugMode) {
        print('Login Error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logs out the current user.
  ///
  /// Resets the current user state.
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _currentUserJson = null;

    notifyListeners();
  }

  /// Signs in a user using Google authentication.
  ///
  /// On successful sign-in, updates the current user state.
  ///
  /// [context] - BuildContext for UI interaction.
  Future<void> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithGoogle(context);
      await _authService.checkAndStoreUserData(_currentUser!);
      _checkCurrentUserJson();
      // Handle successful sign in
    } catch (e) {
      // Handle sign-in error
      if (kDebugMode) {
        print('Google Sign-In Error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retrieves a valid token for API calls if the user is authenticated.
  ///
  /// Returns `null` if the user is not authenticated.
  Future<String?> getValidTokenForApiCall() async {
    if (_currentUser == null) {
      if (kDebugMode) {
        print("User is null");
      }

      return null;
    }
    return await _authService.checkPermissionsAndGetToken(_currentUser!);
  }

  // Implement additional authentication methods as needed
}
