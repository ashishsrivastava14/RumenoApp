import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../mock/mock_farmers.dart';
import '../../models/models.dart';
import '../../widgets/cards/farmer_card.dart';

class AdminFarmersScreen extends StatefulWidget {
  const AdminFarmersScreen({super.key});

  @override
  State<AdminFarmersScreen> createState() => _AdminFarmersScreenState();
}

class _AdminFarmersScreenState extends State<AdminFarmersScreen> {
  String _search = '';
  String _planFilter = 'All';

  @override
  Widget build(BuildContext context) {
    var filtered = mockFarmers.where((f) {
      final matchSearch = f.name.toLowerCase().contains(_search.toLowerCase()) ||
          f.farmName.toLowerCase().contains(_search.toLowerCase());
      final matchPlan = _planFilter == 'All' || f.planName == _planFilter;
      return matchSearch && matchPlan;
    }).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Manage Farmers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting farmer data...')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search farmers...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'Free', 'Starter', 'Pro', 'Business'].map((p) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(p),
                  selected: _planFilter == p,
                  selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
                  onSelected: (_) => setState(() => _planFilter = p),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${filtered.length} farmers', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort, size: 16),
                  label: const Text('Sort'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final farmer = filtered[index];
                return FarmerCard(
                  farmer: farmer,
                  onTap: () => _showFarmerDetail(context, farmer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFarmerDetail(BuildContext context, Farmer farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                    child: Text(farmer.name[0], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(farmer.name, style: Theme.of(ctx).textTheme.titleLarge),
                        Text(farmer.farmName, style: Theme.of(ctx).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detail(ctx, Icons.phone, 'Phone', farmer.phone),
              _detail(ctx, Icons.location_on, 'Location', '${farmer.address}, ${farmer.state}'),
              _detail(ctx, Icons.pets, 'Animals', '${farmer.animalCount}'),
              _detail(ctx, Icons.card_membership, 'Plan', farmer.planName),
              _detail(ctx, Icons.calendar_today, 'Joined', '${farmer.joinedDate.day}/${farmer.joinedDate.month}/${farmer.joinedDate.year}'),
              _detail(ctx, Icons.toggle_on, 'Status', farmer.isActive ? 'Active' : 'Inactive'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () { Navigator.pop(ctx); },
                      icon: const Icon(Icons.block, size: 16),
                      label: Text(farmer.isActive ? 'Deactivate' : 'Activate'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () { Navigator.pop(ctx); },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$label:', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
