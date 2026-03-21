import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_farmers.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vetFarmsTitle),
        actions: const [FarmButton(), MarketplaceButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).vetFarmsSearchHint,
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _planColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                child: const Text('🌾', style: TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(farmer.farmName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Text('👤 ', style: TextStyle(fontSize: 14)),
                        Text(farmer.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: _planColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(farmer.planName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _planColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('📍', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(child: Text('${farmer.address}, ${farmer.state}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13))),
              const Text('🐾', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(AppLocalizations.of(context).vetFarmsAnimalCount(farmer.animalCount), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('📞', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(farmer.phone, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => context.go('/vet/farms/${farmer.id}'),
                icon: const Icon(Icons.visibility_rounded, size: 20),
                label: Text('👁️ ${AppLocalizations.of(context).vetFarmsViewAnimalsButton}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
