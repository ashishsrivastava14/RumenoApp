import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class AdminSubscriptionsScreen extends StatelessWidget {
  const AdminSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                _stat(context, '248', 'Total Users'),
                const SizedBox(width: 10),
                _stat(context, '98', 'Free'),
                const SizedBox(width: 10),
                _stat(context, '82', 'Starter'),
                const SizedBox(width: 10),
                _stat(context, '45', 'Pro'),
                const SizedBox(width: 10),
                _stat(context, '23', 'Business'),
              ],
            ),
            const SizedBox(height: 20),
            Text('Plan Configuration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            _editablePlanCard(context, 'Free', '₹0', 'forever', RumenoTheme.planFree, ['5 animals', 'Basic records', 'Community support'], 98),
            _editablePlanCard(context, 'Starter', '₹499', '/month', RumenoTheme.planStarter, ['25 animals', 'Health + Finance', 'SMS reminders', '3 vet consults/mo'], 82),
            _editablePlanCard(context, 'Pro', '₹999', '/month', RumenoTheme.planPro, ['100 animals', 'Analytics', 'Breeding mgmt', 'Unlimited consults', 'Export reports'], 45),
            _editablePlanCard(context, 'Business', '₹2499', '/month', RumenoTheme.planBusiness, ['Unlimited animals', 'Multi-farm', 'Team management', 'Priority support', 'API access'], 23),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add new plan')));
        },
        icon: const Icon(Icons.add),
        label: const Text('New Plan'),
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: RumenoTheme.primaryGreen)),
            Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[600]), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _editablePlanCard(BuildContext context, String name, String price, String period, Color color, List<String> features, int userCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              Text('$price$period', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const Spacer(),
              Text('$userCount users', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit $name plan')));
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: features.map((f) => Chip(
              label: Text(f, style: const TextStyle(fontSize: 10)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
        ],
      ),
    );
  }
}
