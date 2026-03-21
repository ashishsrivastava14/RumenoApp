import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';

class AdminPartnersScreen extends StatelessWidget {
  const AdminPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final partners = admin.partners;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Partners & Vets')),
      body: partners.isEmpty
          ? Center(child: Text('No partners yet', style: TextStyle(color: Colors.grey[500])))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: partners.length,
              itemBuilder: (context, index) {
                final p = partners[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: (p.type == 'Vet' ? Colors.blue : Colors.purple).withValues(alpha: 0.12),
                            child: Icon(
                              p.type == 'Vet' ? Icons.medical_services_rounded : Icons.handshake_rounded,
                              size: 18,
                              color: p.type == 'Vet' ? Colors.blue : Colors.purple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: Theme.of(context).textTheme.titleSmall),
                                Text(p.code, style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'monospace')),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              admin.togglePartnerStatus(p.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${p.name} ${p.isActive ? "deactivated" : "activated"}')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (p.isActive ? Colors.green : Colors.grey).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(p.isActive ? 'Active' : 'Inactive', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.isActive ? Colors.green : Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _infoChip(Icons.people, '${p.referrals} referrals'),
                          const SizedBox(width: 12),
                          _infoChip(Icons.currency_rupee, '₹${(p.earned / 1000).toStringAsFixed(1)}K'),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (p.type == 'Vet' ? Colors.blue : Colors.purple).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(p.type, style: TextStyle(fontSize: 10, color: p.type == 'Vet' ? Colors.blue : Colors.purple)),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Remove Partner?'),
                                  content: Text('Remove ${p.name} from partners?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () {
                                        admin.removePartner(p.id);
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} removed')));
                                      },
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPartnerDialog(context, admin),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Partner'),
      ),
    );
  }

  void _showAddPartnerDialog(BuildContext context, AdminProvider admin) {
    final nameCtrl = TextEditingController();
    String type = 'Vet';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Partner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Vet', 'Partner'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setDialogState(() => type = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final code = type == 'Vet'
                    ? 'VET-${nameCtrl.text.trim().split(' ').last.toUpperCase()}-${DateTime.now().year}'
                    : 'PTR-${nameCtrl.text.trim().split(' ').first.toUpperCase()}-${DateTime.now().year}';
                admin.addPartner(PartnerModel(
                  id: 'P${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  type: type,
                  code: code,
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameCtrl.text} added!'), backgroundColor: Colors.green));
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ],
    );
  }
}
