import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/marketplace_button.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('More'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/farmer/dashboard');
            }
          },
        ),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Profile Card ──
            GestureDetector(
              onTap: () => context.go('/farmer/more/profile'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                      ),
                      child: const Center(
                        child: Text('👨‍🌾', style: TextStyle(fontSize: 36)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Smith',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Smith Dairy Farm',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Pro Plan',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.edit_rounded, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Main Menu Grid ──
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                _BigMenuTile(
                  emoji: '🏡',
                  label: 'My Farm',
                  sublabel: 'Farm Details',
                  color: const Color(0xFF4CAF50),
                  onTap: () => context.go('/farmer/more/profile'),
                ),
                _BigMenuTile(
                  emoji: '👥',
                  label: 'My Team',
                  sublabel: 'Workers',
                  color: const Color(0xFF2196F3),
                  onTap: () => context.go('/farmer/more/team'),
                ),
                _BigMenuTile(
                  emoji: '💳',
                  label: 'My Plan',
                  sublabel: 'Subscription',
                  color: const Color(0xFFFF9800),
                  onTap: () => context.go('/farmer/more/subscription'),
                ),
                _BigMenuTile(
                  emoji: '🔔',
                  label: 'Alerts',
                  sublabel: 'Notifications',
                  color: const Color(0xFFE91E63),
                  onTap: () => context.go('/farmer/more/notifications'),
                ),
                _BigMenuTile(
                  emoji: '🌐',
                  label: 'Language',
                  sublabel: 'भाषा बदलें',
                  color: const Color(0xFF9C27B0),
                  onTap: () => _showLanguageDialog(context),
                ),
                _BigMenuTile(
                  emoji: '📋',
                  label: 'Export',
                  sublabel: 'Save Data',
                  color: const Color(0xFF00BCD4),
                  onTap: () => context.go('/farmer/more/export'),
                ),
                _BigMenuTile(
                  emoji: '🧹',
                  label: 'Sanitization',
                  sublabel: 'Farm Cleaning',
                  color: const Color(0xFF2196F3),
                  onTap: () => context.go('/farmer/more/sanitization'),
                ),
                _BigMenuTile(
                  emoji: '❓',
                  label: 'Help',
                  sublabel: 'Support',
                  color: const Color(0xFF607D8B),
                  onTap: () => context.go('/farmer/more/help'),
                ),
                _BigMenuTile(
                  emoji: '🚪',
                  label: 'Logout',
                  sublabel: 'Sign Out',
                  color: const Color(0xFFE53935),
                  onTap: () => _showLogoutConfirm(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── App info ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '🐄  Rumeno App',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: RumenoTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🚪', style: TextStyle(fontSize: 28)),
            SizedBox(width: 10),
            Text('Logout?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Stay', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: RumenoTheme.errorRed),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              context.go('/role-selection');
            },
            child: const Text('Yes, Logout', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = [
      {'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
      {'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
      // {'name': 'Gujarati', 'native': 'ગુજરાતી', 'flag': '🇮🇳'},
      // {'name': 'Marathi', 'native': 'मराठी', 'flag': '🇮🇳'},
      // {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ', 'flag': '🇮🇳'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text('🌐', style: TextStyle(fontSize: 28)),
                SizedBox(width: 10),
                Text('Select Language', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            ...languages.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅  Language set to ${l['name']}'),
                      backgroundColor: RumenoTheme.successGreen,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: l['name'] == 'English'
                        ? RumenoTheme.primaryGreen.withValues(alpha: 0.08)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: l['name'] == 'English'
                          ? RumenoTheme.primaryGreen
                          : Colors.grey.shade200,
                      width: l['name'] == 'English' ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(l['flag']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: l['name'] == 'English' ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
                              ),
                            ),
                            Text(
                              l['native']!,
                              style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey),
                            ),
                          ],
                        ),
                      ),
                      if (l['name'] == 'English')
                        const Icon(Icons.check_circle, color: RumenoTheme.primaryGreen, size: 22),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BigMenuTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _BigMenuTile({
    required this.emoji,
    required this.label,
    required this.sublabel,
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: RumenoTheme.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
