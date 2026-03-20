import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Big animated-like success icon
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: RumenoTheme.successGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: RumenoTheme.successGreen.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle_rounded, color: RumenoTheme.successGreen, size: 70),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  l10n.orderSuccessTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: RumenoTheme.successGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Order ID card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tag_rounded, size: 18, color: RumenoTheme.textGrey),
                      const SizedBox(width: 8),
                      Text(l10n.orderSuccessOrderId(orderId), style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Confirmation message with icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_active_rounded, color: RumenoTheme.warningYellow, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.orderSuccessConfirmationPrompt,
                              style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.local_shipping_rounded, color: RumenoTheme.infoBlue, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.orderSuccessDeliveryUpdates,
                              style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Track Order button - big
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/shop/orders'),
                    icon: const Icon(Icons.local_shipping_rounded, size: 22),
                    label: Text(l10n.orderSuccessTrackButton, style: const TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Continue Shopping button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/shop'),
                    icon: const Icon(Icons.shopping_bag_rounded, size: 22),
                    label: Text(l10n.orderSuccessContinueButton, style: const TextStyle(fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: RumenoTheme.primaryGreen, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
