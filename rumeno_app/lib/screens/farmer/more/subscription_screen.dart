import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/subscription_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('My Subscription')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current plan banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Plan', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text('Starter', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('₹499 / month', style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: const Text('Renews on 15 Aug 2025', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Available Plans', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SubscriptionCard(
              plan: SubscriptionPlan.free,
              price: '₹0',
              animalLimit: '5 animals',
              features: const ['Up to 5 animals', 'Basic health records', 'Community support'],
              isCurrentPlan: false,
              onSelect: () {},
            ),
            SubscriptionCard(
              plan: SubscriptionPlan.starter,
              price: '₹499/mo',
              animalLimit: '25 animals',
              features: const ['Up to 25 animals', 'Health + Finance tracking', 'SMS reminders', 'Vet consultations (3/mo)'],
              isCurrentPlan: true,
              onSelect: () {},
            ),
            SubscriptionCard(
              plan: SubscriptionPlan.pro,
              price: '₹999/mo',
              animalLimit: '100 animals',
              features: const ['Up to 100 animals', 'Advanced analytics', 'Breeding management', 'Unlimited vet consults', 'Export reports'],
              isCurrentPlan: false,
              onSelect: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upgrade request sent!'), backgroundColor: Colors.green),
                );
              },
            ),
            SubscriptionCard(
              plan: SubscriptionPlan.business,
              price: '₹2499/mo',
              animalLimit: 'Unlimited',
              features: const ['Unlimited animals', 'Multi-farm support', 'Team management', 'Priority support', 'API access', 'Custom reports'],
              isCurrentPlan: false,
              onSelect: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Upgrade request sent!'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
