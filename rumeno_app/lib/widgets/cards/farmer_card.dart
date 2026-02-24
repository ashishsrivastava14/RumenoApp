import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class FarmerCard extends StatelessWidget {
  final Farmer farmer;
  final VoidCallback? onTap;

  const FarmerCard({super.key, required this.farmer, this.onTap});

  Color _planColor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return RumenoTheme.planFree;
      case SubscriptionPlan.starter: return RumenoTheme.planStarter;
      case SubscriptionPlan.pro: return RumenoTheme.planPro;
      case SubscriptionPlan.business: return RumenoTheme.planBusiness;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.15),
              child: Text(farmer.name[0], style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(farmer.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _planColor(farmer.plan).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(farmer.planName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _planColor(farmer.plan))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${farmer.farmName} • ${farmer.state}', style: Theme.of(context).textTheme.bodySmall),
                  Text('${farmer.animalCount} animals • Joined ${DateFormat('MMM yyyy').format(farmer.joinedDate)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight)),
                ],
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
