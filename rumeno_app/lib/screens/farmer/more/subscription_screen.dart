import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';
import '../../../widgets/common/marketplace_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionPlan _currentPlan = SubscriptionPlan.starter;

  static const _plans = [
    {
      'plan': SubscriptionPlan.free,
      'emoji': '🌱',
      'name': 'Free',
      'price': '₹0',
      'period': 'Forever',
      'animals': '5',
      'color': Color(0xFF9E9E9E),
      'features': ['5 animals', 'Basic records', 'Community help'],
      'featureIcons': ['🐄', '📋', '🤝'],
    },
    {
      'plan': SubscriptionPlan.starter,
      'emoji': '⭐',
      'name': 'Starter',
      'price': '₹499',
      'period': '/month',
      'animals': '25',
      'color': Color(0xFF2196F3),
      'features': ['25 animals', 'Health + Money tracking', 'SMS reminders', '3 Vet calls/month'],
      'featureIcons': ['🐄', '💰', '📱', '🩺'],
    },
    {
      'plan': SubscriptionPlan.pro,
      'emoji': '🏆',
      'name': 'Pro',
      'price': '₹999',
      'period': '/month',
      'animals': '100',
      'color': Color(0xFFFFB300),
      'features': ['100 animals', 'Advanced reports', 'Breeding records', 'Unlimited vet calls', 'Export data'],
      'featureIcons': ['🐄', '📊', '🐣', '🩺', '📋'],
    },
    {
      'plan': SubscriptionPlan.business,
      'emoji': '👑',
      'name': 'Business',
      'price': '₹2499',
      'period': '/month',
      'animals': '∞',
      'color': Color(0xFF7B1FA2),
      'features': ['Unlimited animals', 'Multi-farm', 'Team management', 'Priority support', 'Custom reports'],
      'featureIcons': ['🐄', '🏡', '👥', '🎯', '📊'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('My Plan'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current plan banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
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
              child: Column(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  const Text('Your Current Plan', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('Starter', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('₹499 / month', style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Renews on 15 Aug 2025', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Row(
              children: [
                Text('📋', style: TextStyle(fontSize: 22)),
                SizedBox(width: 8),
                Text('All Plans', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 14),

            // Plans
            ..._plans.map((p) {
              final plan = p['plan'] as SubscriptionPlan;
              final isCurrent = plan == _currentPlan;
              final color = p['color'] as Color;
              final features = p['features'] as List<String>;
              final featureIcons = p['featureIcons'] as List<String>;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isCurrent ? Border.all(color: color, width: 2.5) : null,
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    // Plan header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.06),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Text(p['emoji'] as String, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['name'] as String,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      p['price'] as String,
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.textDark),
                                    ),
                                    Text(p['period'] as String, style: const TextStyle(color: RumenoTheme.textGrey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Animal count badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text('🐄', style: TextStyle(fontSize: 18)),
                                Text(
                                  p['animals'] as String,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Features list
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: List.generate(features.length, (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(featureIcons[i], style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(features[i], style: const TextStyle(fontSize: 14)),
                              ),
                              Icon(Icons.check_circle_rounded, color: color, size: 18),
                            ],
                          ),
                        )),
                      ),
                    ),

                    // Action button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: isCurrent
                            ? OutlinedButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.check_circle, color: color),
                                label: Text('Current Plan', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: color),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => _currentPlan = plan);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✅ Switched to ${p['name']} plan!'),
                                      backgroundColor: RumenoTheme.successGreen,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.upgrade_rounded),
                                label: Text(
                                  plan.index > _currentPlan.index ? 'Upgrade' : 'Select',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
