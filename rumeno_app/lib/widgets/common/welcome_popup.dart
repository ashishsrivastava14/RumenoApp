import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';

const _kWelcomePopupShownKey = 'welcome_popup_shown';

Future<void> showWelcomePopupIfNeeded(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_kWelcomePopupShownKey) == true) return;
  if (!context.mounted) return;

  await prefs.setBool(_kWelcomePopupShownKey, true);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _WelcomePopupDialog(),
  );
}

class _WelcomePopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon row at top ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMiniImage('assets/images/ecommerce-bag.png', const Color(0xFFE8F5E9)),
                const SizedBox(width: 8),
                const Icon(Icons.add, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                _buildMiniImage('assets/images/farm1.png', const Color(0xFFFFF3E0)),
                const SizedBox(width: 8),
                const Icon(Icons.add, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                _buildMiniImage('assets/images/veterinarian-plusicon.png', const Color(0xFFE3F2FD)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                _buildMiniIcon(Icons.apps_rounded, const Color(0xFFF3E5F5), const Color(0xFF7B1FA2)),
              ],
            ),

            const SizedBox(height: 20),

            // ── Title ──
            Text(
              l10n.welcomePopupTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
                height: 1.3,
              ),
            ),

            const SizedBox(height: 20),

            // ── Navigation options ──
            _NavigationOption(
              imageAsset: 'assets/images/ecommerce-bag.png',
              color: RumenoTheme.primaryGreen,
              bgColor: const Color(0xFFE8F5E9),
              title: l10n.welcomePopupShopping,
              subtitle: l10n.welcomePopupShoppingDesc,
              onTap: () {
                Navigator.pop(context);
                context.go('/shop');
              },
            ),
            const SizedBox(height: 12),
            _NavigationOption(
              imageAsset: 'assets/images/farm1.png',
              color: const Color(0xFFE65100),
              bgColor: const Color(0xFFFFF3E0),
              title: l10n.welcomePopupFarm,
              subtitle: l10n.welcomePopupFarmDesc,
              onTap: () {
                Navigator.pop(context);
                context.go('/farmer/dashboard');
              },
            ),
            const SizedBox(height: 12),
            _NavigationOption(
              imageAsset: 'assets/images/veterinarian-plusicon.png',
              color: const Color(0xFF1565C0),
              bgColor: const Color(0xFFE3F2FD),
              title: l10n.welcomePopupDoctor,
              subtitle: l10n.welcomePopupDoctorDesc,
              onTap: () {
                Navigator.pop(context);
                context.go('/vet/dashboard');
              },
            ),

            const SizedBox(height: 20),

            // ── Hint text ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app_rounded, color: Color(0xFF7A7A7A), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.welcomePopupHint,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A7A7A),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── Got it button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  l10n.commonGotIt,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniIcon(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildMiniImage(String assetPath, Color bgColor) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(assetPath, width: 28, height: 28, fit: BoxFit.contain),
      ),
    );
  }
}

class _NavigationOption extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final Color color;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavigationOption({
    this.icon,
    this.imageAsset,
    required this.color,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: imageAsset != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(imageAsset!, width: 32, height: 32, fit: BoxFit.contain),
                      )
                    : Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A7A7A),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
