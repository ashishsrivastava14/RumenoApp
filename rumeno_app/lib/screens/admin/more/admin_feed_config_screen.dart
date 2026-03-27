import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';

class AdminFeedConfigScreen extends StatefulWidget {
  const AdminFeedConfigScreen({super.key});

  @override
  State<AdminFeedConfigScreen> createState() => _AdminFeedConfigScreenState();
}

class _AdminFeedConfigScreenState extends State<AdminFeedConfigScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF33691E), Color(0xFF689F38)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 60),
                child: Row(
                  children: [
                    const Text('🌾', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Feed Formula Config',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${admin.activeFeedIngredients} ingredients · ${admin.activeFeedAnimalTypes} animal types',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(
                    icon: Text('🌽', style: TextStyle(fontSize: 24)),
                    text: 'Ingredients'),
                Tab(
                    icon: Text('🐄', style: TextStyle(fontSize: 24)),
                    text: 'Animal Types'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _IngredientsTab(),
            _AnimalTypesTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tab.index == 0
            ? _showAddIngredientDialog(context)
            : _showAddAnimalTypeDialog(context),
        backgroundColor: const Color(0xFF33691E),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: Text(_tab.index == 0 ? 'Add Ingredient' : 'Add Animal Type',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
      ),
    );
  }

  // ─── Add Ingredient Dialog ─────────────────────────────────────────────
  void _showAddIngredientDialog(BuildContext context) {
    final nameC = TextEditingController();
    final emojiC = TextEditingController(text: '🌾');
    final priceC = TextEditingController();
    final proteinC = TextEditingController();
    final fiberC = TextEditingController();
    final energyC = TextEditingController();
    final carbC = TextEditingController();
    final fatC = TextEditingController();
    final moistureC = TextEditingController();
    final ashC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🌽', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text('Add Ingredient'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                        controller: emojiC,
                        decoration:
                            const InputDecoration(labelText: 'Emoji'),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                        controller: nameC,
                        decoration:
                            const InputDecoration(labelText: 'Name *')),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: priceC,
                  decoration:
                      const InputDecoration(labelText: 'Price/kg (₹) *'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: proteinC,
                        decoration:
                            const InputDecoration(labelText: 'Protein %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: fiberC,
                        decoration:
                            const InputDecoration(labelText: 'Fiber %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: energyC,
                        decoration:
                            const InputDecoration(labelText: 'Energy %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: carbC,
                        decoration:
                            const InputDecoration(labelText: 'Carbs %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: fatC,
                        decoration:
                            const InputDecoration(labelText: 'Fat %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: moistureC,
                        decoration:
                            const InputDecoration(labelText: 'Moisture %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: ashC,
                  decoration: const InputDecoration(labelText: 'Ash %'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF33691E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (nameC.text.isEmpty || priceC.text.isEmpty) return;
              context.read<AdminProvider>().addFeedIngredient(FeedIngredient(
                    id: 'FI${DateTime.now().millisecondsSinceEpoch}',
                    name: nameC.text,
                    emoji: emojiC.text.isEmpty ? '🌾' : emojiC.text,
                    pricePerKg: double.tryParse(priceC.text) ?? 0,
                    protein: double.tryParse(proteinC.text) ?? 0,
                    fiber: double.tryParse(fiberC.text) ?? 0,
                    energy: double.tryParse(energyC.text) ?? 0,
                    carbohydrate: double.tryParse(carbC.text) ?? 0,
                    fat: double.tryParse(fatC.text) ?? 0,
                    moisture: double.tryParse(moistureC.text) ?? 0,
                    ash: double.tryParse(ashC.text) ?? 0,
                  ));
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Add Animal Type Dialog ────────────────────────────────────────────
  void _showAddAnimalTypeDialog(BuildContext context) {
    final nameC = TextEditingController();
    final emojiC = TextEditingController(text: '🐄');
    final bodyWeightC = TextEditingController();
    final dailyFeedC = TextEditingController();
    final greenC = TextEditingController();
    final dryC = TextEditingController();
    final concentrateC = TextEditingController();
    final proteinC = TextEditingController();
    final fiberC = TextEditingController();
    final energyC = TextEditingController();
    final tipC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🐄', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text('Add Animal Type'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                        controller: emojiC,
                        decoration:
                            const InputDecoration(labelText: 'Emoji'),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                        controller: nameC,
                        decoration:
                            const InputDecoration(labelText: 'Name *')),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: bodyWeightC,
                        decoration:
                            const InputDecoration(labelText: 'Body wt (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: dailyFeedC,
                        decoration:
                            const InputDecoration(labelText: 'Daily feed (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: greenC,
                        decoration:
                            const InputDecoration(labelText: 'Green (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: dryC,
                        decoration:
                            const InputDecoration(labelText: 'Dry (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: concentrateC,
                        decoration:
                            const InputDecoration(labelText: 'Conc. (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: proteinC,
                        decoration:
                            const InputDecoration(labelText: 'Target protein %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: fiberC,
                        decoration:
                            const InputDecoration(labelText: 'Target fiber %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: energyC,
                  decoration:
                      const InputDecoration(labelText: 'Target energy %'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(
                  controller: tipC,
                  decoration:
                      const InputDecoration(labelText: 'Feeding tip'),
                  maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF33691E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (nameC.text.isEmpty) return;
              context.read<AdminProvider>().addFeedAnimalType(FeedAnimalType(
                    id: 'FA${DateTime.now().millisecondsSinceEpoch}',
                    name: nameC.text,
                    emoji: emojiC.text.isEmpty ? '🐄' : emojiC.text,
                    bodyWeightKg:
                        double.tryParse(bodyWeightC.text) ?? 0,
                    dailyFeedKg:
                        double.tryParse(dailyFeedC.text) ?? 0,
                    greenFodderKg:
                        double.tryParse(greenC.text) ?? 0,
                    dryFodderKg: double.tryParse(dryC.text) ?? 0,
                    concentrateKg:
                        double.tryParse(concentrateC.text) ?? 0,
                    targetProtein:
                        double.tryParse(proteinC.text) ?? 0,
                    targetFiber:
                        double.tryParse(fiberC.text) ?? 0,
                    targetEnergy:
                        double.tryParse(energyC.text) ?? 0,
                    tip: tipC.text,
                  ));
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Ingredients Tab
// ═════════════════════════════════════════════════════════════════════════════
class _IngredientsTab extends StatelessWidget {
  const _IngredientsTab();

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.feedIngredients;

    if (items.isEmpty) {
      return const Center(
          child: Text('No feed ingredients configured',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: item.isActive
                ? null
                : Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.isActive
                    ? const Color(0xFF33691E).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child:
                      Text(item.emoji, style: const TextStyle(fontSize: 24))),
            ),
            title: Text(item.name,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: item.isActive ? null : Colors.grey)),
            subtitle: Text(
                '₹${item.pricePerKg.toStringAsFixed(0)}/kg · P:${item.protein}% F:${item.fiber}% E:${item.energy}%',
                style: TextStyle(
                    fontSize: 12,
                    color: item.isActive ? Colors.grey[600] : Colors.grey)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: item.isActive,
                  activeColor: const Color(0xFF33691E),
                  onChanged: (val) => admin.updateFeedIngredient(item.id,
                      isActive: val),
                ),
                PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'edit') {
                      _showEditIngredientDialog(context, item);
                    } else if (action == 'delete') {
                      _showDeleteDialog(context, item.id, item.name);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('✏️ Edit')),
                    PopupMenuItem(value: 'delete', child: Text('🗑️ Delete')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditIngredientDialog(BuildContext context, FeedIngredient item) {
    final nameC = TextEditingController(text: item.name);
    final emojiC = TextEditingController(text: item.emoji);
    final priceC =
        TextEditingController(text: item.pricePerKg.toStringAsFixed(0));
    final proteinC =
        TextEditingController(text: item.protein.toStringAsFixed(1));
    final fiberC =
        TextEditingController(text: item.fiber.toStringAsFixed(1));
    final energyC =
        TextEditingController(text: item.energy.toStringAsFixed(1));
    final carbC =
        TextEditingController(text: item.carbohydrate.toStringAsFixed(1));
    final fatC = TextEditingController(text: item.fat.toStringAsFixed(1));
    final moistureC =
        TextEditingController(text: item.moisture.toStringAsFixed(1));
    final ashC = TextEditingController(text: item.ash.toStringAsFixed(1));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            const Text('Edit Ingredient'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                        controller: emojiC,
                        decoration:
                            const InputDecoration(labelText: 'Emoji'),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                        controller: nameC,
                        decoration:
                            const InputDecoration(labelText: 'Name *')),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: priceC,
                  decoration:
                      const InputDecoration(labelText: 'Price/kg (₹) *'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: proteinC,
                        decoration:
                            const InputDecoration(labelText: 'Protein %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: fiberC,
                        decoration:
                            const InputDecoration(labelText: 'Fiber %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: energyC,
                        decoration:
                            const InputDecoration(labelText: 'Energy %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: carbC,
                        decoration:
                            const InputDecoration(labelText: 'Carbs %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: fatC,
                        decoration:
                            const InputDecoration(labelText: 'Fat %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: moistureC,
                        decoration:
                            const InputDecoration(labelText: 'Moisture %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: ashC,
                  decoration: const InputDecoration(labelText: 'Ash %'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF33691E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<AdminProvider>().updateFeedIngredient(
                    item.id,
                    name: nameC.text,
                    emoji: emojiC.text,
                    pricePerKg: double.tryParse(priceC.text),
                    protein: double.tryParse(proteinC.text),
                    fiber: double.tryParse(fiberC.text),
                    energy: double.tryParse(energyC.text),
                    carbohydrate: double.tryParse(carbC.text),
                    fat: double.tryParse(fatC.text),
                    moisture: double.tryParse(moistureC.text),
                    ash: double.tryParse(ashC.text),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Ingredient?'),
        content: Text('Remove "$name" from the feed library?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<AdminProvider>().deleteFeedIngredient(id);
              Navigator.pop(ctx);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Animal Types Tab
// ═════════════════════════════════════════════════════════════════════════════
class _AnimalTypesTab extends StatelessWidget {
  const _AnimalTypesTab();

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.feedAnimalTypes;

    if (items.isEmpty) {
      return const Center(
          child: Text('No animal types configured',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: item.isActive
                ? null
                : Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.isActive
                    ? const Color(0xFF33691E).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child:
                      Text(item.emoji, style: const TextStyle(fontSize: 24))),
            ),
            title: Text(item.name,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: item.isActive ? null : Colors.grey)),
            subtitle: Text(
                '${item.bodyWeightKg.toStringAsFixed(0)} kg · ${item.dailyFeedKg.toStringAsFixed(1)} kg/day',
                style: TextStyle(
                    fontSize: 12,
                    color: item.isActive ? Colors.grey[600] : Colors.grey)),
            shape: const Border(),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow('Green Fodder',
                        '${item.greenFodderKg.toStringAsFixed(1)} kg/day'),
                    _detailRow('Dry Fodder',
                        '${item.dryFodderKg.toStringAsFixed(1)} kg/day'),
                    _detailRow('Concentrate',
                        '${item.concentrateKg.toStringAsFixed(1)} kg/day'),
                    const Divider(height: 16),
                    _detailRow('Target Protein',
                        '${item.targetProtein.toStringAsFixed(0)}%'),
                    _detailRow('Target Fiber',
                        '${item.targetFiber.toStringAsFixed(0)}%'),
                    _detailRow('Target Energy',
                        '${item.targetEnergy.toStringAsFixed(0)}%'),
                    if (item.tip.isNotEmpty) ...[
                      const Divider(height: 16),
                      Text('💡 ${item.tip}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic)),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch(
                          value: item.isActive,
                          activeColor: const Color(0xFF33691E),
                          onChanged: (val) => context
                              .read<AdminProvider>()
                              .updateFeedAnimalType(item.id,
                                  isActive: val),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, size: 20),
                          onPressed: () =>
                              _showEditAnimalTypeDialog(context, item),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_rounded,
                              size: 20, color: RumenoTheme.errorRed),
                          onPressed: () =>
                              _showDeleteDialog(context, item.id, item.name),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showEditAnimalTypeDialog(
      BuildContext context, FeedAnimalType item) {
    final nameC = TextEditingController(text: item.name);
    final emojiC = TextEditingController(text: item.emoji);
    final bodyWeightC =
        TextEditingController(text: item.bodyWeightKg.toStringAsFixed(0));
    final dailyFeedC =
        TextEditingController(text: item.dailyFeedKg.toStringAsFixed(1));
    final greenC =
        TextEditingController(text: item.greenFodderKg.toStringAsFixed(1));
    final dryC =
        TextEditingController(text: item.dryFodderKg.toStringAsFixed(1));
    final concentrateC =
        TextEditingController(text: item.concentrateKg.toStringAsFixed(1));
    final proteinC =
        TextEditingController(text: item.targetProtein.toStringAsFixed(0));
    final fiberC =
        TextEditingController(text: item.targetFiber.toStringAsFixed(0));
    final energyC =
        TextEditingController(text: item.targetEnergy.toStringAsFixed(0));
    final tipC = TextEditingController(text: item.tip);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            const Text('Edit Animal Type'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: TextField(
                        controller: emojiC,
                        decoration:
                            const InputDecoration(labelText: 'Emoji'),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                        controller: nameC,
                        decoration:
                            const InputDecoration(labelText: 'Name *')),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: bodyWeightC,
                        decoration:
                            const InputDecoration(labelText: 'Body wt (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: dailyFeedC,
                        decoration:
                            const InputDecoration(labelText: 'Daily feed (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: greenC,
                        decoration:
                            const InputDecoration(labelText: 'Green (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: dryC,
                        decoration:
                            const InputDecoration(labelText: 'Dry (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: concentrateC,
                        decoration:
                            const InputDecoration(labelText: 'Conc. (kg)'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: proteinC,
                        decoration:
                            const InputDecoration(labelText: 'Target protein %'),
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: fiberC,
                        decoration:
                            const InputDecoration(labelText: 'Target fiber %'),
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                  controller: energyC,
                  decoration:
                      const InputDecoration(labelText: 'Target energy %'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(
                  controller: tipC,
                  decoration:
                      const InputDecoration(labelText: 'Feeding tip'),
                  maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF33691E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<AdminProvider>().updateFeedAnimalType(
                    item.id,
                    name: nameC.text,
                    emoji: emojiC.text,
                    bodyWeightKg: double.tryParse(bodyWeightC.text),
                    dailyFeedKg: double.tryParse(dailyFeedC.text),
                    greenFodderKg: double.tryParse(greenC.text),
                    dryFodderKg: double.tryParse(dryC.text),
                    concentrateKg: double.tryParse(concentrateC.text),
                    targetProtein: double.tryParse(proteinC.text),
                    targetFiber: double.tryParse(fiberC.text),
                    targetEnergy: double.tryParse(energyC.text),
                    tip: tipC.text,
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Animal Type?'),
        content: Text('Remove "$name" from the feed calculator?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<AdminProvider>().deleteFeedAnimalType(id);
              Navigator.pop(ctx);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
