import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Admin Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Admin profile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: RumenoTheme.primaryDarkGreen,
                  child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Admin', style: Theme.of(context).textTheme.titleMedium),
                    Text('admin@rumeno.in', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _menuSection(context, 'Management', [
            _MenuItem(Icons.card_membership_rounded, 'Subscription Plans', () => context.go('/admin/more/subscriptions')),
            _MenuItem(Icons.payment_rounded, 'Payments', () => context.go('/admin/more/payments')),
            _MenuItem(Icons.people_alt_rounded, 'Partners / Vets', () => context.go('/admin/more/partners')),
          ]),
          const SizedBox(height: 12),

          _menuSection(context, 'Communication', [
            _MenuItem(Icons.notifications_rounded, 'Push Notifications', () => context.go('/admin/more/notifications')),
            _MenuItem(Icons.analytics_rounded, 'Reports', () => context.go('/admin/more/reports')),
          ]),
          const SizedBox(height: 12),

          _menuSection(context, 'System', [
            _MenuItem(Icons.settings_rounded, 'App Settings', () => context.go('/admin/more/settings')),
            _MenuItem(Icons.logout_rounded, 'Logout', () => context.go('/')),
          ]),
        ],
      ),
    );
  }

  Widget _menuSection(BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: items.asMap().entries.map((e) {
              final item = e.value;
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: RumenoTheme.primaryGreen),
                    title: Text(item.label, style: const TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: item.onTap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  if (!isLast) const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(this.icon, this.label, this.onTap);
}
