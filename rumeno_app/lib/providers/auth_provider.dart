import 'package:flutter/material.dart';
import '../models/models.dart';
import '../mock/mock_users.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  UserRole? _activeRole;
  bool _isAuthenticated = false;

  AppUser? get currentUser => _currentUser;
  UserRole? get activeRole => _activeRole;

  /// Kept for compatibility — returns the active role.
  UserRole? get selectedRole => _activeRole;
  bool get isAuthenticated => _isAuthenticated;

  /// All roles the logged-in user has.
  List<UserRole> get roles => _currentUser?.roles ?? [];

  /// Whether the current user has more than one role.
  bool get isMultiRole => roles.length > 1;

  /// Select/switch to a specific role (post-login).
  void selectRole(UserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  /// Look up the user by phone number.
  /// Returns the roles assigned to that number, or empty if unknown.
  List<UserRole> lookupRoles(String phone) {
    final user = mockUsersByPhone[phone];
    return user?.roles ?? [];
  }

  /// Log in with a phone number. Sets the user and, if only one role, auto-selects it.
  /// Returns the list of roles so the caller can decide whether to show a role picker.
  List<UserRole> login(String phone) {
    final user = mockUsersByPhone[phone];
    if (user != null) {
      _currentUser = user;
      _isAuthenticated = true;
      if (user.roles.length == 1) {
        _activeRole = user.roles.first;
      }
      notifyListeners();
      return user.roles;
    }
    // Unknown phone — still mark as logged in with farmer role as default
    _currentUser = AppUser(
      id: 'UNKNOWN',
      name: 'User',
      phone: phone,
      roles: [UserRole.farmer],
    );
    _activeRole = UserRole.farmer;
    _isAuthenticated = true;
    notifyListeners();
    return [UserRole.farmer];
  }

  void logout() {
    _currentUser = null;
    _activeRole = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
