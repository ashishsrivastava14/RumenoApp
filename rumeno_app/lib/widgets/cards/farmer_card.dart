import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class FarmerCard extends StatelessWidget {
  final Farmer farmer;
  final VoidCallback? onTap;
  final VoidCallback? onCall;

  const FarmerCard({super.key, required this.farmer, this.onTap, this.onCall});

  Color _planColor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return RumenoTheme.planFree;
      case SubscriptionPlan.starter: return RumenoTheme.planStarter;
      case SubscriptionPlan.pro: return RumenoTheme.planPro;
      case SubscriptionPlan.business: return RumenoTheme.planBusiness;
    }
  }

  String _planEmoji(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return '🆓';
      case SubscriptionPlan.starter: return '🚀';
      case SubscriptionPlan.pro: return '⭐';
      case SubscriptionPlan.business: return '💎';
    }
  }

  @override
  Widget build(BuildContext context) {
    final planClr = _planColor(farmer.plan);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: farmer.isActive ? Colors.transparent : RumenoTheme.errorRed.withValues(alpha: 0.3),
            width: farmer.isActive ? 0 : 2,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            // Main card content - bigger, more visual
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Large avatar with prominent status ring
                  Stack(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                          child: Text(
                            farmer.name[0],
                            style: const TextStyle(
                              color: RumenoTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      // Bigger status indicator with emoji
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: Icon(
                            farmer.isActive ? Icons.check : Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Farmer info - bigger text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farmer.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.home_work_rounded, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                farmer.farmName,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 5),
                            Text(
                              farmer.state,
                              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Big call button - obvious and tappable
                  if (onCall != null)
                    Material(
                      color: RumenoTheme.successGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: onCall,
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(Icons.phone_rounded, color: RumenoTheme.successGreen, size: 26),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Bottom strip - visual indicators
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.04),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  // Animal count with big icon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🐾', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Text('${farmer.animalCount}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF8D6E63))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Plan badge with emoji
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: planClr.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_planEmoji(farmer.plan), style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          farmer.planName,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: planClr),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Status text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(farmer.isActive ? '✅' : '❌', style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        Text(
                          farmer.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tap arrow
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
