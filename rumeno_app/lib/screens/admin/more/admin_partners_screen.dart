import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class AdminPartnersScreen extends StatelessWidget {
  const AdminPartnersScreen({super.key});

  static final _partners = [
    {'name': 'Dr. Anita Sharma', 'type': 'Vet', 'referrals': '10', 'earned': '₹68,400', 'status': 'Active', 'code': 'VET-ANITA-2024'},
    {'name': 'Dr. Ravi Kumar', 'type': 'Vet', 'referrals': '8', 'earned': '₹52,200', 'status': 'Active', 'code': 'VET-RAVI-2024'},
    {'name': 'Pashudhan NGO', 'type': 'Partner', 'referrals': '25', 'earned': '₹1,20,000', 'status': 'Active', 'code': 'PTR-PASHU-2024'},
    {'name': 'Dr. Meena Soni', 'type': 'Vet', 'referrals': '5', 'earned': '₹28,500', 'status': 'Active', 'code': 'VET-MEENA-2024'},
    {'name': 'KrishiMitra', 'type': 'Partner', 'referrals': '15', 'earned': '₹75,000', 'status': 'Inactive', 'code': 'PTR-KRISHI-2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Partners & Vets')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _partners.length,
        itemBuilder: (context, index) {
          final p = _partners[index];
          final isActive = p['status'] == 'Active';
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
                      backgroundColor: (p['type'] == 'Vet' ? Colors.blue : Colors.purple).withValues(alpha: 0.12),
                      child: Icon(
                        p['type'] == 'Vet' ? Icons.medical_services_rounded : Icons.handshake_rounded,
                        size: 18,
                        color: p['type'] == 'Vet' ? Colors.blue : Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['name']!, style: Theme.of(context).textTheme.titleSmall),
                          Text(p['code']!, style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(p['status']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isActive ? Colors.green : Colors.grey)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _infoChip(Icons.people, '${p['referrals']} referrals'),
                    const SizedBox(width: 12),
                    _infoChip(Icons.currency_rupee, p['earned']!),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (p['type'] == 'Vet' ? Colors.blue : Colors.purple).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(p['type']!, style: TextStyle(fontSize: 10, color: p['type'] == 'Vet' ? Colors.blue : Colors.purple)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add partner/vet')));
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Partner'),
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
