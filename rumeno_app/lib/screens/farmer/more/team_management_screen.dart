import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class TeamManagementScreen extends StatelessWidget {
  const TeamManagementScreen({super.key});

  static final _members = [
    {'name': 'Rajesh Patel', 'phone': '9876543210', 'role': 'Owner'},
    {'name': 'Suresh Patel', 'phone': '9876543221', 'role': 'Manager'},
    {'name': 'Mohan Lal', 'phone': '9876543222', 'role': 'Staff (Edit)'},
    {'name': 'Ramu', 'phone': '9876543223', 'role': 'Staff (View)'},
  ];

  Color _roleColor(String role) {
    if (role.contains('Owner')) return RumenoTheme.planBusiness;
    if (role.contains('Manager')) return RumenoTheme.planPro;
    if (role.contains('Edit')) return RumenoTheme.planStarter;
    return RumenoTheme.planFree;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Team Members')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final m = _members[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _roleColor(m['role']!).withValues(alpha: 0.15),
                  child: Text(m['name']![0], style: TextStyle(color: _roleColor(m['role']!), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['name']!, style: Theme.of(context).textTheme.titleSmall),
                      Text(m['phone']!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _roleColor(m['role']!).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(m['role']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _roleColor(m['role']!))),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (ctx) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Team Member', style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  const TextField(decoration: InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: ['Manager', 'Staff (Edit)', 'Staff (View)'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Member added!'), backgroundColor: Colors.green));
                      },
                      child: const Text('Add Member'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Member'),
      ),
    );
  }
}
