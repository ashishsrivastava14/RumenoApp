import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AlertBanner extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;

  const AlertBanner({
    super.key,
    required this.message,
    this.color = const Color(0xFFE53935),
    this.icon = Icons.warning_amber_rounded,
    this.onDismiss,
    this.onTap,
  });

  factory AlertBanner.high({required String message, VoidCallback? onTap}) =>
      AlertBanner(message: message, color: RumenoTheme.errorRed, icon: Icons.error_outline, onTap: onTap);

  factory AlertBanner.medium({required String message, VoidCallback? onTap}) =>
      AlertBanner(message: message, color: RumenoTheme.warningYellow, icon: Icons.warning_amber_rounded, onTap: onTap);

  factory AlertBanner.low({required String message, VoidCallback? onTap}) =>
      AlertBanner(message: message, color: RumenoTheme.successGreen, icon: Icons.check_circle_outline, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RumenoTheme.textDark,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (onDismiss != null)
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close, color: color, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
