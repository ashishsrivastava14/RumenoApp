import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    // Stats for the header
    final totalFarmers = mockFarmers.length;
    final activeFarmers = mockFarmers.where((f) => f.isActive).length;
    final proFarmers = mockFarmers.where((f) => f.planName == 'Pro' || f.planName == 'Business').length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/admin/dashboard');
                }
              },
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting farmer data...')));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Title
                    Row(
                      children: [
                        const Text('👨‍🌾', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Manage Farmers',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Quick stats row
                    Row(
                      children: [
                        _MiniStat(emoji: '👥', value: '$totalFarmers', label: 'Total'),
                        const SizedBox(width: 10),
                        _MiniStat(emoji: '✅', value: '$activeFarmers', label: 'Active'),
                        const SizedBox(width: 10),
                        _MiniStat(emoji: '⭐', value: '$proFarmers', label: 'Premium'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search farmers...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: ['All', 'Free', 'Starter', 'Pro', 'Business'].map((p) {
                      final isSelected = _planFilter == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(p, style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          )),
                          selected: isSelected,
                          selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) => setState(() => _planFilter = p),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('${filtered.length} farmers',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600])),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sort, size: 16),
                        label: const Text('Sort', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final farmer = filtered[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FarmerCard(
                    farmer: farmer,
                    onTap: () => _showFarmerDetail(context, farmer),
                  ),
                );
              },
              childCount: filtered.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showFarmerDetail(BuildContext context, Farmer farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(farmer.name[0],
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(farmer.name, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(farmer.farmName, style: Theme.of(ctx).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _detail(ctx, '📞', 'Phone', farmer.phone),
                _detail(ctx, '📍', 'Location', '${farmer.address}, ${farmer.state}'),
                _detail(ctx, '🐄', 'Animals', '${farmer.animalCount}'),
                _detail(ctx, '💳', 'Plan', farmer.planName),
                _detail(ctx, '📅', 'Joined', '${farmer.joinedDate.day}/${farmer.joinedDate.month}/${farmer.joinedDate.year}'),
                _detail(ctx, farmer.isActive ? '✅' : '❌', 'Status', farmer.isActive ? 'Active' : 'Inactive'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () { Navigator.pop(ctx); },
                        icon: Text(farmer.isActive ? '🚫' : '✅', style: const TextStyle(fontSize: 16)),
                        label: Text(farmer.isActive ? 'Deactivate' : 'Activate'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () { Navigator.pop(ctx); },
                        icon: const Text('✏️', style: TextStyle(fontSize: 16)),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Text('$label:', style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _MiniStat({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text(label,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
