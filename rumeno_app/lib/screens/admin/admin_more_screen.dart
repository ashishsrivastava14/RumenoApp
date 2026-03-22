import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.admin_panel_settings_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('System Admin',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text('admin@rumeno.in',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Quick Access Grid ──────────────────────────────────
                  _sectionTitle(context, '⚡ Quick Access'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _ModuleTile(
                        emoji: '👨‍🌾',
                        label: 'Farmers',
                        color: const Color(0xFF1565C0),
                        onTap: () => context.go('/admin/farmers'),
                      ),
                      _ModuleTile(
                        emoji: '🐄',
                        label: 'Farm',
                        color: const Color(0xFF2E7D32),
                        onTap: () => context.go('/admin/farm'),
                      ),
                      _ModuleTile(
                        emoji: '🛒',
                        label: 'Shop',
                        color: const Color(0xFF1976D2),
                        onTap: () => context.go('/admin/shop'),
                      ),
                      _ModuleTile(
                        emoji: '🩺',
                        label: 'Vets',
                        color: const Color(0xFFAD1457),
                        onTap: () => context.go('/admin/vets'),
                      ),
                      _ModuleTile(
                        emoji: '💳',
                        label: 'Plans',
                        color: const Color(0xFF6A1B9A),
                        onTap: () => context.go('/admin/more/subscriptions'),
                      ),
                      _ModuleTile(
                        emoji: '📊',
                        label: 'Reports',
                        color: const Color(0xFF00838F),
                        onTap: () => context.go('/admin/more/reports'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Management ─────────────────────────────────────────
                  _sectionTitle(context, '🔧 Management'),
                  const SizedBox(height: 12),
                  _menuSection(context, [
                    _MenuTile(
                      emoji: '💰',
                      color: const Color(0xFF00695C),
                      label: 'Payments & Billing',
                      subtitle: 'View transactions & invoices',
                      onTap: () => context.go('/admin/more/payments'),
                    ),
                    _MenuTile(
                      emoji: '🏪',
                      color: const Color(0xFF1565C0),
                      label: 'Vendor Management',
                      subtitle: 'Approve, suspend vendors',
                      onTap: () => context.go('/admin/more/vendors'),
                    ),
                    _MenuTile(
                      emoji: '📦',
                      color: const Color(0xFF1976D2),
                      label: 'Marketplace Settings',
                      subtitle: 'Configure products & categories',
                      onTap: () => context.go('/admin/more/marketplace'),
                    ),
                    _MenuTile(
                      emoji: '🤝',
                      color: const Color(0xFFAD1457),
                      label: 'Vet Partners',
                      subtitle: 'Manage vet partnerships',
                      onTap: () => context.go('/admin/more/partners'),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ─── Communication ──────────────────────────────────────
                  _sectionTitle(context, '📢 Communication'),
                  const SizedBox(height: 12),
                  _menuSection(context, [
                    _MenuTile(
                      emoji: '🔔',
                      color: const Color(0xFFE65100),
                      label: 'Push Notifications',
                      subtitle: 'Send alerts to farmers & vets',
                      onTap: () => context.go('/admin/more/notifications'),
                    ),
                    _MenuTile(
                      emoji: '📣',
                      color: const Color(0xFF7B1FA2),
                      label: 'Announcements',
                      subtitle: 'App-wide messages',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      ),
                    ),
                    // Support Tickets hidden for now
                  ]),
                  const SizedBox(height: 20),

                  // ─── System ─────────────────────────────────────────────
                  _sectionTitle(context, '⚙️ System'),
                  const SizedBox(height: 12),
                  _menuSection(context, [
                    _MenuTile(
                      emoji: '🔧',
                      color: Colors.grey[700]!,
                      label: 'App Settings',
                      subtitle: 'Configure app behaviour',
                      onTap: () => context.go('/admin/more/settings'),
                    ),
                    _MenuTile(
                      emoji: '📈',
                      color: const Color(0xFF00838F),
                      label: 'Reports & Analytics',
                      subtitle: 'Revenue, users, health stats',
                      onTap: () => context.go('/admin/more/reports'),
                    ),
                    _MenuTile(
                      emoji: '🔒',
                      color: const Color(0xFF37474F),
                      label: 'Security & Access',
                      subtitle: 'Roles & permissions',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      ),
                    ),
                    _MenuTile(
                      emoji: '💾',
                      color: const Color(0xFF4527A0),
                      label: 'Data Backup',
                      subtitle: 'Export & backup all data',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating backup...')),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Text('🚪', style: TextStyle(fontSize: 20)),
                      label: const Text('Sign Out',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: RumenoTheme.errorRed,
                        side: const BorderSide(color: RumenoTheme.errorRed, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text('Rumeno Admin v2.0',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400])),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17));
  }

  Widget _menuSection(BuildContext context, List<_MenuTile> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          final item = e.value;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                title: Text(item.label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(item.subtitle,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500])),
                trailing: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chevron_right_rounded,
                      size: 20, color: Colors.grey[400]),
                ),
                onTap: item.onTap,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
              if (!isLast) const Divider(height: 1, indent: 70),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Text('🚪', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text('Sign Out'),
          ],
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// ─── Module Tile ──────────────────────────────────────────────────────────────
class _ModuleTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ModuleTile({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}

// ─── Menu Tile Data ───────────────────────────────────────────────────────────
class _MenuTile {
  final String emoji;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuTile({
    required this.emoji,
    required this.color,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });
}
