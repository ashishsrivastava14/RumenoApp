import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../mock/mock_farmers.dart';
import '../../models/models.dart';

class VetFarmsScreen extends StatefulWidget {
  const VetFarmsScreen({super.key});

  @override
  State<VetFarmsScreen> createState() => _VetFarmsScreenState();
}

class _VetFarmsScreenState extends State<VetFarmsScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mockFarmers.where((f) => f.name.toLowerCase().contains(_search.toLowerCase()) || f.farmName.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Referred Farms')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search farms...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final farmer = filtered[index];
                return _FarmCard(farmer: farmer);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmCard extends StatelessWidget {
  final Farmer farmer;
  const _FarmCard({required this.farmer});

  Color get _planColor {
    switch (farmer.plan) {
      case SubscriptionPlan.free:
        return RumenoTheme.planFree;
      case SubscriptionPlan.starter:
        return RumenoTheme.planStarter;
      case SubscriptionPlan.pro:
        return RumenoTheme.planPro;
      case SubscriptionPlan.business:
        return RumenoTheme.planBusiness;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                child: Text(farmer.name[0], style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(farmer.farmName, style: Theme.of(context).textTheme.titleSmall),
                    Text(farmer.name, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _planColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(farmer.planName, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _planColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text('${farmer.address}, ${farmer.state}', style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Icon(Icons.pets_rounded, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text('${farmer.animalCount} animals', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_rounded, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(farmer.phone, style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility_rounded, size: 16),
                label: const Text('View Animals'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
