import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _authService.login(username, password);
    if (result != null) {
      _user = await _authService.getProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    debugPrint('Checking auth status...');
    try {
      _user = await _authService.getProfile();
      debugPrint('Auth status check complete. Authenticated: $isAuthenticated');
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }
    notifyListeners();
  }
}
