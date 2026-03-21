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

  IconData _planIcon(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return Icons.card_giftcard_rounded;
      case SubscriptionPlan.starter: return Icons.rocket_launch_rounded;
      case SubscriptionPlan.pro: return Icons.star_rounded;
      case SubscriptionPlan.business: return Icons.diamond_rounded;
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: farmer.isActive ? Colors.transparent : RumenoTheme.errorRed.withValues(alpha: 0.3),
            width: farmer.isActive ? 0 : 1.5,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            // Main card content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  // Large avatar with status ring
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            width: 2.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                          child: Text(
                            farmer.name[0],
                            style: TextStyle(
                              color: RumenoTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      // Active status dot
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            farmer.isActive ? Icons.check : Icons.close,
                            size: 9,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Farmer info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farmer.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.home_work_rounded, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                farmer.farmName,
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              farmer.state,
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Quick call button
                  if (onCall != null)
                    Material(
                      color: RumenoTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: onCall,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.phone_rounded, color: RumenoTheme.successGreen, size: 22),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Bottom info strip with visual indicators
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.04),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  // Animal count with icon
                  _InfoChip(
                    icon: Icons.pets_rounded,
                    label: '${farmer.animalCount}',
                    color: const Color(0xFF8D6E63),
                  ),
                  const SizedBox(width: 12),
                  // Plan badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: planClr.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_planIcon(farmer.plan), size: 14, color: planClr),
                        const SizedBox(width: 4),
                        Text(
                          farmer.planName,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: planClr),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Arrow indicator for "tap to see more"
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}
