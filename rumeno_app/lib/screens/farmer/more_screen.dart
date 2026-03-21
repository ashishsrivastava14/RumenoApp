import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/common/language_selector.dart';
import '../../widgets/common/marketplace_button.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final currentLang = localeProvider.locale.languageCode == 'hi' ? 'हिन्दी' : 'English';

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.moreTitle),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.morePlanPro,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
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
                  label: l10n.moreMyFarm,
                  sublabel: l10n.moreMyFarmSubtitle,
                  color: const Color(0xFF4CAF50),
                  onTap: () => context.go('/farmer/more/profile'),
                ),
                _BigMenuTile(
                  emoji: '👥',
                  label: l10n.moreMyTeam,
                  sublabel: l10n.moreMyTeamSubtitle,
                  color: const Color(0xFF2196F3),
                  onTap: () => context.go('/farmer/more/team'),
                ),
                _BigMenuTile(
                  emoji: '💳',
                  label: l10n.moreMyPlan,
                  sublabel: l10n.moreMyPlanSubtitle,
                  color: const Color(0xFFFF9800),
                  onTap: () => context.go('/farmer/more/subscription'),
                ),
                _BigMenuTile(
                  emoji: '🔔',
                  label: l10n.moreAlerts,
                  sublabel: l10n.moreAlertsSubtitle,
                  color: const Color(0xFFE91E63),
                  onTap: () => context.go('/farmer/more/notifications'),
                ),
                _BigMenuTile(
                  emoji: '🌐',
                  label: l10n.moreLanguage,
                  sublabel: currentLang,
                  color: const Color(0xFF9C27B0),
                  onTap: () => showLanguageSelectorSheet(context),
                ),
                _BigMenuTile(
                  emoji: '📋',
                  label: l10n.moreExport,
                  sublabel: l10n.moreExportSubtitle,
                  color: const Color(0xFF00BCD4),
                  onTap: () => context.go('/farmer/more/export'),
                ),
                _BigMenuTile(
                  emoji: '🧹',
                  label: l10n.moreSanitization,
                  sublabel: l10n.moreSanitizationSubtitle,
                  color: const Color(0xFF2196F3),
                  onTap: () => context.go('/farmer/more/sanitization'),
                ),
                _BigMenuTile(
                  emoji: '🛒',
                  label: 'मेरी दुकान',
                  sublabel: 'My Shop / Sale',
                  color: const Color(0xFF43A047),
                  onTap: () => context.push('/farmer/sale'),
                ),
                _BigMenuTile(
                  emoji: '❓',
                  label: l10n.moreHelp,
                  sublabel: l10n.moreHelpSubtitle,
                  color: const Color(0xFF607D8B),
                  onTap: () => context.go('/farmer/more/help'),
                ),
                _BigMenuTile(
                  emoji: '🚪',
                  label: l10n.moreLogout,
                  sublabel: l10n.moreLogoutSubtitle,
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
                    l10n.moreVersion,
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🚪', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Text(l10n.logoutDialogTitle),
          ],
        ),
        content: Text(
          l10n.logoutDialogMessage,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.logoutDialogStay, style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: RumenoTheme.errorRed),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              context.go('/role-selection');
            },
            child: Text(l10n.logoutDialogConfirm, style: const TextStyle(fontSize: 16)),
          ),
        ],
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
