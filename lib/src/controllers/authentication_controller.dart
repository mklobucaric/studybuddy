import 'package:flutter/foundation.dart';
import 'package:studybuddy/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studybuddy/src/models/user.dart';

class AuthenticationController with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  UserJson? _currentUserJson;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  UserJson? get currentUserJson => _currentUserJson;

  AuthenticationController() {
    _checkCurrentUser();
    _checkCurrentUserJson();
  }

  void _checkCurrentUser() {
    _currentUser = _authService.currentUser;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser =
          await _authService.registerWithEmailPassword(email, password);
    } catch (e) {
      // Handle registration error
      print('Registration Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.loginWithEmailPassword(email, password);
    } catch (e) {
      // Handle login error
      print('Login Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithGoogle();
      // Handle successful sign in
    } catch (e) {
      // Handle sign-in error
      print('Google Sign-In Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _checkCurrentUserJson() async {
    var firebaseUser = _authService.currentUser; // This returns a Firebase User
    if (firebaseUser != null) {
      _currentUserJson = await _authService
          .fetchUserData(firebaseUser.uid); // Fetching custom user data
      notifyListeners();
    }
  }

  // Implement additional authentication methods as needed
}
