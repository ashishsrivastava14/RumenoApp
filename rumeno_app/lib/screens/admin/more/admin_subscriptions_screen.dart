import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';

class AdminSubscriptionsScreen extends StatelessWidget {
  const AdminSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final plans = admin.plans;
    final totalUsers = admin.totalUsers;

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
                _stat(context, '$totalUsers', 'Total Users'),
                ...plans.map((p) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text('${p.userCount}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: p.color)),
                        Text(p.name, style: TextStyle(fontSize: 9, color: Colors.grey[600]), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            Text('Plan Configuration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...plans.map((plan) => _editablePlanCard(context, plan, admin)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlanDialog(context, admin),
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

  Widget _editablePlanCard(BuildContext context, SubscriptionPlan plan, AdminProvider admin) {
    final priceStr = plan.price == 0 ? '₹0' : '₹${plan.price.toStringAsFixed(0)}';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: plan.color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: plan.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(plan.name, style: TextStyle(fontWeight: FontWeight.bold, color: plan.color, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              Text('$priceStr${plan.period}', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const Spacer(),
              Text('${plan.userCount} users', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 18),
                onPressed: () => _showEditPlanDialog(context, plan, admin),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: plan.features.map((f) => Chip(
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

  void _showEditPlanDialog(BuildContext context, SubscriptionPlan plan, AdminProvider admin) {
    final nameCtrl = TextEditingController(text: plan.name);
    final priceCtrl = TextEditingController(text: plan.price.toStringAsFixed(0));
    final periodCtrl = TextEditingController(text: plan.period);
    final featuresCtrl = TextEditingController(text: plan.features.join(', '));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${plan.name} Plan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Plan Name')),
              const SizedBox(height: 10),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (₹)')),
              const SizedBox(height: 10),
              TextField(controller: periodCtrl, decoration: const InputDecoration(labelText: 'Period (e.g. /month, forever)')),
              const SizedBox(height: 10),
              TextField(controller: featuresCtrl, decoration: const InputDecoration(labelText: 'Features (comma separated)'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              admin.updatePlan(plan.id,
                name: nameCtrl.text.trim(),
                price: double.tryParse(priceCtrl.text) ?? plan.price,
                period: periodCtrl.text.trim(),
                features: featuresCtrl.text.split(',').map((f) => f.trim()).where((f) => f.isNotEmpty).toList(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameCtrl.text} plan updated!'), backgroundColor: Colors.green));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddPlanDialog(BuildContext context, AdminProvider admin) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final periodCtrl = TextEditingController(text: '/month');
    final featuresCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Plan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Plan Name')),
              const SizedBox(height: 10),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (₹)')),
              const SizedBox(height: 10),
              TextField(controller: periodCtrl, decoration: const InputDecoration(labelText: 'Period')),
              const SizedBox(height: 10),
              TextField(controller: featuresCtrl, decoration: const InputDecoration(labelText: 'Features (comma separated)'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              admin.addPlan(SubscriptionPlan(
                id: 'S${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                price: double.tryParse(priceCtrl.text) ?? 0,
                period: periodCtrl.text.trim(),
                color: Colors.teal,
                features: featuresCtrl.text.split(',').map((f) => f.trim()).where((f) => f.isNotEmpty).toList(),
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameCtrl.text} plan added!'), backgroundColor: Colors.green));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
