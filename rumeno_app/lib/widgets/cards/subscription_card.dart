import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String price;
  final String animalLimit;
  final List<String> features;
  final bool isCurrentPlan;
  final VoidCallback? onSelect;

  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.price,
    required this.animalLimit,
    required this.features,
    this.isCurrentPlan = false,
    this.onSelect,
  });

  Color _planColor() {
    switch (plan) {
      case SubscriptionPlan.free: return RumenoTheme.planFree;
      case SubscriptionPlan.starter: return RumenoTheme.planStarter;
      case SubscriptionPlan.pro: return RumenoTheme.planPro;
      case SubscriptionPlan.business: return RumenoTheme.planBusiness;
    }
  }

  String _planName() {
    switch (plan) {
      case SubscriptionPlan.free: return 'Free';
      case SubscriptionPlan.starter: return 'Starter';
      case SubscriptionPlan.pro: return 'Pro';
      case SubscriptionPlan.business: return 'Business';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _planColor();
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentPlan ? Border.all(color: color, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(_planName(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              if (isCurrentPlan) ...[
                const Spacer(),
                Icon(Icons.check_circle, color: color, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(price, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          Text('Up to $animalLimit animals', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.check, color: color, size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 12))),
              ],
            ),
          )),
          const SizedBox(height: 12),
          if (!isCurrentPlan)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onSelect,
                style: OutlinedButton.styleFrom(side: BorderSide(color: color), foregroundColor: color),
                child: const Text('Select Plan'),
              ),
            ),
        ],
      ),
    );
  }
}
