import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationController with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthenticationController() {
    _checkCurrentUser();
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

  // Implement additional authentication methods as needed
}
