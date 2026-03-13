import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import 'shop_home_screen.dart';

class ShopAccountScreen extends StatelessWidget {
  const ShopAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('My Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      child: Text(
                        user?.name.isNotEmpty == true ? user!.name[0] : 'U',
                        style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'User', style: Theme.of(context).textTheme.titleMedium),
                          Text(user?.phone ?? '', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Menu Items
            _MenuCard(
              items: [
                _MenuItem(icon: Icons.receipt_long, label: 'My Orders', onTap: () => context.go('/shop/orders')),
                _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () {}),
                _MenuItem(icon: Icons.favorite_outline, label: 'Wishlist', onTap: () {}),
              ],
            ),
            const SizedBox(height: 12),
            _MenuCard(
              items: [
                _MenuItem(icon: Icons.agriculture, label: 'Switch to Farm App', onTap: () {
                  context.go('/farmer/dashboard');
                }),
                _MenuItem(icon: Icons.medical_services_outlined, label: 'Switch to Vet App', onTap: () {
                  context.go('/vet/dashboard');
                }),
                _MenuItem(icon: Icons.storefront, label: 'Become a Vendor', onTap: () => context.go('/shop/vendor-register')),
              ],
            ),
            const SizedBox(height: 12),
            _MenuCard(
              items: [
                _MenuItem(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
                _MenuItem(icon: Icons.info_outline, label: 'About Rumeno', onTap: () {}),
                _MenuItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  color: RumenoTheme.errorRed,
                  onTap: () {
                    auth.logout();
                    context.go('/shop');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ShopBottomBar(currentIndex: 4),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: item.color ?? RumenoTheme.primaryGreen),
                title: Text(item.label, style: TextStyle(fontSize: 14, color: item.color)),
                trailing: Icon(Icons.chevron_right, color: RumenoTheme.textLight),
                onTap: item.onTap,
              ),
              if (idx < items.length - 1) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color});
}
