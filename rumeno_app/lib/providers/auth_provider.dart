import 'package:flutter/material.dart';
import '../models/models.dart';
import '../mock/mock_users.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  UserRole? _selectedRole;
  bool _isAuthenticated = false;

  AppUser? get currentUser => _currentUser;
  UserRole? get selectedRole => _selectedRole;
  bool get isAuthenticated => _isAuthenticated;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void login(String phone, UserRole role) {
    switch (role) {
      case UserRole.farmer:
        _currentUser = mockFarmerUser;
        break;
      case UserRole.vet:
        _currentUser = mockVetUser;
        break;
      case UserRole.admin:
        _currentUser = mockAdminUser;
        break;
    }
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _selectedRole = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
