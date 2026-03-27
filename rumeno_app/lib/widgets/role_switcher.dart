import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';

/// A compact role-switch button for the app bar.
/// Only visible when the user has multiple roles.
class RoleSwitcher extends StatelessWidget {
  const RoleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isMultiRole) return const SizedBox.shrink();

    return PopupMenuButton<UserRole>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _emojiFor(auth.activeRole),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.swap_horiz_rounded,
              size: 18,
              color: RumenoTheme.primaryGreen,
            ),
          ],
        ),
      ),
      tooltip: 'Switch Role',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      offset: const Offset(0, 48),
      onSelected: (role) {
        if (role == auth.activeRole) return;
        auth.selectRole(role);
        switch (role) {
          case UserRole.farmer:
            context.go('/farmer/dashboard');
            break;
          case UserRole.vet:
            context.go('/vet/dashboard');
            break;
          case UserRole.admin:
            context.go('/admin/dashboard');
            break;
        }
      },
      itemBuilder: (_) => auth.roles.map((role) {
        final isActive = role == auth.activeRole;
        return PopupMenuItem<UserRole>(
          value: role,
          child: Row(
            children: [
              Text(_emojiFor(role), style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _labelFor(role),
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? RumenoTheme.primaryGreen : null,
                  ),
                ),
              ),
              if (isActive)
                Icon(Icons.check_circle, size: 20, color: RumenoTheme.primaryGreen),
            ],
          ),
        );
      }).toList(),
    );
  }

  static String _emojiFor(UserRole? role) {
    switch (role) {
      case UserRole.farmer: return '🐄';
      case UserRole.vet:    return '🩺';
      case UserRole.admin:  return '🔧';
      case null:            return '👤';
    }
  }

  static String _labelFor(UserRole role) {
    switch (role) {
      case UserRole.farmer: return 'Farm Owner';
      case UserRole.vet:    return 'Veterinarian';
      case UserRole.admin:  return 'Super Admin';
    }
  }
}
