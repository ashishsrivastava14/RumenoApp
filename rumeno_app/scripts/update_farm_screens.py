"""
Script to update admin farm management screens for illiterate-friendly UI.
Key changes:
- Bigger emojis as primary visual cues
- Color-coded status indicators
- Larger touch targets (min 48dp)
- Status emojis for instant recognition
- Bigger fonts and buttons
- Visual-first design
"""
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ============================================================================
# 1. admin_farm_screen.dart
# ============================================================================
farm_screen = r"""import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_farmers.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';

class AdminFarmScreen extends StatefulWidget {
  const AdminFarmScreen({super.key});

  @override
  State<AdminFarmScreen> createState() => _AdminFarmScreenState();
}

class _AdminFarmScreenState extends State<AdminFarmScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('🐄', style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Farm Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            Text('All Farms & Animals',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
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
                Tab(icon: Text('🐾', style: TextStyle(fontSize: 24)), text: 'Animals'),
                Tab(icon: Text('💊', style: TextStyle(fontSize: 24)), text: 'Health'),
                Tab(icon: Text('📊', style: TextStyle(fontSize: 24)), text: 'Stats'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _AnimalsTab(),
            _HealthTab(),
            _StatsTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Animals Tab ──────────────────────────────────────────────────────────────
class _AnimalsTab extends StatefulWidget {
  const _AnimalsTab();

  @override
  State<_AnimalsTab> createState() => _AnimalsTabState();
}

class _AnimalsTabState extends State<_AnimalsTab> {
  String _search = '';
  Species? _speciesFilter;

  @override
  Widget build(BuildContext context) {
    final filtered = mockAnimals.where((a) {
      final matchSearch =
          a.breed.toLowerCase().contains(_search.toLowerCase()) ||
              a.tagId.toLowerCase().contains(_search.toLowerCase());
      final matchSpecies =
          _speciesFilter == null || a.species == _speciesFilter;
      return matchSearch && matchSpecies;
    }).toList();

    final speciesCounts = <Species, int>{};
    for (final a in mockAnimals) {
      speciesCounts[a.species] = (speciesCounts[a.species] ?? 0) + 1;
    }

    return Column(
      children: [
        // BIG species filter cards with large animal emojis
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            children: Species.values.map((s) {
              final count = speciesCounts[s] ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return _SpeciesCard(
                species: s,
                count: count,
                selected: _speciesFilter == s,
                onTap: () => setState(
                    () => _speciesFilter = _speciesFilter == s ? null : s),
              );
            }).toList(),
          ),
        ),
        // Large search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: TextField(
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Search by tag ID or breed...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              prefixIcon: const Icon(Icons.search_rounded, size: 24, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        // Count + Big Add button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pets_rounded, size: 18, color: RumenoTheme.primaryGreen),
                    const SizedBox(width: 6),
                    Text('${filtered.length}',
                        style: const TextStyle(fontSize: 16, color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddAnimalDialog(context),
                icon: const Icon(Icons.add_rounded, size: 22, color: Colors.white),
                label: const Text('Add Animal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (ctx, i) => _AnimalTile(
              animal: filtered[i],
              onTap: () => _showAnimalDetail(ctx, filtered[i]),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddAnimalDialog(BuildContext context) {
    final tagCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🐾', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 12),
            const Text('Add Animal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tagCtrl,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Tag ID',
                labelStyle: const TextStyle(fontSize: 16),
                prefixIcon: const Icon(Icons.tag, size: 24),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.06),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RumenoTheme.infoBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: RumenoTheme.infoBlue, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: Text('Full form available in farmer app', style: TextStyle(fontSize: 13, color: RumenoTheme.infoBlue))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  label: const Text('Cancel', style: TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('Animal ${tagCtrl.text} added!'),
                      ]),
                      backgroundColor: RumenoTheme.successGreen,
                    ));
                  },
                  icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
                  label: const Text('Add', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAnimalDetail(BuildContext context, Animal animal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AnimalDetailSheet(animal: animal),
    );
  }
}

class _SpeciesCard extends StatelessWidget {
  final Species species;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _SpeciesCard({
    required this.species,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  static const _icons = {
    Species.cow: '🐄',
    Species.buffalo: '🐃',
    Species.goat: '🐐',
    Species.sheep: '🐑',
    Species.pig: '🐷',
    Species.horse: '🐴',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? RumenoTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: selected ? RumenoTheme.primaryGreen : Colors.grey.shade200,
              width: selected ? 2.5 : 1),
          boxShadow: [
            if (selected)
              BoxShadow(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))
            else
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Text(_icons[species] ?? '🐾', style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(species.name.capitalize(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: selected ? Colors.white : Colors.black87)),
                Text('$count',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: selected ? Colors.white : RumenoTheme.primaryGreen)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimalTile extends StatelessWidget {
  final Animal animal;
  final VoidCallback onTap;

  const _AnimalTile({required this.animal, required this.onTap});

  Color _statusColor() {
    switch (animal.status) {
      case AnimalStatus.active: return RumenoTheme.successGreen;
      case AnimalStatus.pregnant: return Colors.pink;
      case AnimalStatus.sick:
      case AnimalStatus.underTreatment: return RumenoTheme.errorRed;
      case AnimalStatus.quarantine: return Colors.orange;
      case AnimalStatus.dry: return Colors.blueGrey;
      case AnimalStatus.deceased: return Colors.grey;
    }
  }

  String _statusEmoji() {
    switch (animal.status) {
      case AnimalStatus.active: return '✅';
      case AnimalStatus.pregnant: return '🤰';
      case AnimalStatus.sick: return '🤒';
      case AnimalStatus.underTreatment: return '💊';
      case AnimalStatus.quarantine: return '⚠️';
      case AnimalStatus.dry: return '💤';
      case AnimalStatus.deceased: return '🕊️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text(_SpeciesCard._icons[animal.species] ?? '🐾', style: const TextStyle(fontSize: 30))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(animal.tagId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_statusEmoji(), style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(animal.statusLabel, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${animal.breed} · ${animal.ageString}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.monitor_weight_rounded, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${animal.weightKg.toStringAsFixed(0)} kg',
                            style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimalDetailSheet extends StatelessWidget {
  final Animal animal;
  const _AnimalDetailSheet({required this.animal});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (ctx, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: sc,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(_SpeciesCard._icons[animal.species] ?? '🐾', style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 8),
                  Text(animal.tagId, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('${animal.speciesName} · ${animal.breed}', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _detailCard(Icons.cake_rounded, Colors.purple, 'Age', animal.ageString),
            _detailCard(
                animal.gender == Gender.male ? Icons.male_rounded : Icons.female_rounded,
                animal.gender == Gender.male ? Colors.blue : Colors.pink,
                'Gender', animal.gender.name.capitalize()),
            _detailCard(Icons.favorite_rounded, _statusDetailColor(animal.status), 'Status', animal.statusLabel),
            _detailCard(Icons.agriculture_rounded, Colors.teal, 'Purpose', animal.purpose.name.capitalize()),
            _detailCard(Icons.monitor_weight_rounded, Colors.orange, 'Weight', '${animal.weightKg.toStringAsFixed(1)} kg'),
            _detailCard(Icons.person_rounded, RumenoTheme.primaryGreen, 'Farmer', animal.farmerId),
            if (animal.shedNumber != null) _detailCard(Icons.home_rounded, Colors.brown, 'Shed', animal.shedNumber!),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, size: 22),
                    label: const Text('Close', style: TextStyle(fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [
                          const Icon(Icons.open_in_full_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Opening full profile for ${animal.tagId}'),
                        ]),
                      ));
                    },
                    icon: const Icon(Icons.open_in_full_rounded, size: 22, color: Colors.white),
                    label: const Text('Full Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusDetailColor(AnimalStatus s) {
    switch (s) {
      case AnimalStatus.active: return RumenoTheme.successGreen;
      case AnimalStatus.pregnant: return Colors.pink;
      case AnimalStatus.sick:
      case AnimalStatus.underTreatment: return RumenoTheme.errorRed;
      case AnimalStatus.quarantine: return Colors.orange;
      case AnimalStatus.dry: return Colors.blueGrey;
      case AnimalStatus.deceased: return Colors.grey;
    }
  }

  Widget _detailCard(IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Health Tab ───────────────────────────────────────────────────────────────
class _HealthTab extends StatelessWidget {
  const _HealthTab();

  @override
  Widget build(BuildContext context) {
    final overdueVax = mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).toList();
    final dueVax = mockVaccinations.where((v) => v.status == VaccinationStatus.due).toList();
    final activeTreatments = mockTreatments.where((t) => t.endDate == null || t.endDate!.isAfter(DateTime.now())).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (overdueVax.isNotEmpty)
            _AlertCard(
              emoji: '🚨',
              color: RumenoTheme.errorRed,
              title: '${overdueVax.length} Overdue Vaccination${overdueVax.length > 1 ? 's' : ''}',
              subtitle: 'Immediate attention required',
              onTap: () {},
            ),
          if (dueVax.isNotEmpty)
            _AlertCard(
              emoji: '⏰',
              color: RumenoTheme.warningYellow,
              title: '${dueVax.length} Vaccination${dueVax.length > 1 ? 's' : ''} Due Soon',
              subtitle: 'Schedule within the week',
              onTap: () {},
            ),
          if (activeTreatments.isNotEmpty)
            _AlertCard(
              emoji: '🏥',
              color: RumenoTheme.infoBlue,
              title: '${activeTreatments.length} Active Treatment${activeTreatments.length > 1 ? 's' : ''}',
              subtitle: 'Animals currently under care',
              onTap: () {},
            ),
          const SizedBox(height: 20),

          const Text('⚡ Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickActionCard(emoji: '💉', icon: Icons.vaccines_rounded, color: RumenoTheme.primaryGreen, label: 'Health Config', onTap: () => context.push('/admin/farm/health-config')),
              const SizedBox(width: 12),
              _QuickActionCard(emoji: '🐛', icon: Icons.pest_control_rounded, color: Colors.teal, label: 'Dewormings', onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Row(children: [Icon(Icons.info_outline_rounded, color: Colors.white), SizedBox(width: 8), Text('Deworming records coming soon')]),
                  backgroundColor: RumenoTheme.infoBlue,
                ));
              }),
            ],
          ),
          const SizedBox(height: 24),

          Row(children: [
            const Text('💉', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('Vaccination Records (${mockVaccinations.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...mockVaccinations.take(8).map((v) => _VaccinationTile(vaccination: v)),
          if (mockVaccinations.length > 8)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.expand_more_rounded),
                  label: Text('View all ${mockVaccinations.length} records', style: const TextStyle(fontSize: 14)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RumenoTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),

          Row(children: [
            const Text('🏥', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('Treatment Records (${mockTreatments.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...mockTreatments.take(6).map((t) => _TreatmentTile(treatment: t)),
          if (mockTreatments.length > 6)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.expand_more_rounded),
                  label: Text('View all ${mockTreatments.length} records', style: const TextStyle(fontSize: 14)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RumenoTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String emoji;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AlertCard({required this.emoji, required this.color, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String emoji;
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({required this.emoji, required this.icon, required this.color, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _VaccinationTile extends StatelessWidget {
  final VaccinationRecord vaccination;
  const _VaccinationTile({required this.vaccination});

  String _statusEmoji() {
    switch (vaccination.status) {
      case VaccinationStatus.overdue: return '🔴';
      case VaccinationStatus.due: return '🟡';
      case VaccinationStatus.done: return '🟢';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (vaccination.status) {
      case VaccinationStatus.overdue: statusColor = RumenoTheme.errorRed; break;
      case VaccinationStatus.due: statusColor = RumenoTheme.warningYellow; break;
      case VaccinationStatus.done: statusColor = RumenoTheme.successGreen; break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Text(_statusEmoji(), style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.vaccines_rounded, color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vaccination.vaccineName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.pets_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(vaccination.animalId, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(_formatDate(vaccination.dueDate), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(vaccination.status.name.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';
  static const _months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
}

class _TreatmentTile extends StatelessWidget {
  final TreatmentRecord treatment;
  const _TreatmentTile({required this.treatment});

  @override
  Widget build(BuildContext context) {
    final isActive = treatment.endDate == null || treatment.endDate!.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Text(isActive ? '🔴' : '✅', style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isActive ? RumenoTheme.errorRed : RumenoTheme.successGreen).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.medical_services_rounded, color: isActive ? RumenoTheme.errorRed : RumenoTheme.successGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(treatment.treatment, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.pets_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(treatment.animalId, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(width: 8),
                    Expanded(child: Text(treatment.diagnosis, style: TextStyle(fontSize: 12, color: Colors.grey[500]), overflow: TextOverflow.ellipsis)),
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: (isActive ? RumenoTheme.errorRed : RumenoTheme.successGreen).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(isActive ? 'ACTIVE' : 'DONE',
                  style: TextStyle(color: isActive ? RumenoTheme.errorRed : RumenoTheme.successGreen, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Tab ────────────────────────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    final total = mockAnimals.length;
    final active = mockAnimals.where((a) => a.status == AnimalStatus.active).length;
    final pregnant = mockAnimals.where((a) => a.status == AnimalStatus.pregnant).length;
    final sick = mockAnimals.where((a) => a.status == AnimalStatus.sick || a.status == AnimalStatus.underTreatment).length;

    final purposeCounts = <AnimalPurpose, int>{};
    for (final a in mockAnimals) {
      purposeCounts[a.purpose] = (purposeCounts[a.purpose] ?? 0) + 1;
    }

    final farmerCounts = <String, int>{};
    for (final a in mockAnimals) {
      farmerCounts[a.farmerId] = (farmerCounts[a.farmerId] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _KpiCard(emoji: '🐾', label: 'Total Animals', value: '$total', color: RumenoTheme.primaryGreen),
              _KpiCard(emoji: '✅', label: 'Healthy', value: '$active', color: RumenoTheme.successGreen),
              _KpiCard(emoji: '🤰', label: 'Pregnant', value: '$pregnant', color: Colors.pink),
              _KpiCard(emoji: '🤒', label: 'Sick / Treatment', value: '$sick', color: RumenoTheme.errorRed),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Purpose Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          ...AnimalPurpose.values.map((purpose) {
            final count = purposeCounts[purpose] ?? 0;
            if (count == 0) return const SizedBox.shrink();
            return _ProgressRow(emoji: _purposeEmoji(purpose), label: purpose.name.capitalize(), count: count, total: total, color: _purposeColor(purpose));
          }),
          const SizedBox(height: 24),
          Row(children: [
            const Text('🏠', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text('Farm Distribution (${mockFarmers.length} farms)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...mockFarmers.take(6).map((farmer) {
            final count = farmerCounts[farmer.id] ?? 0;
            return _FarmDistributionRow(name: farmer.name, animalCount: count, maxCount: farmerCounts.values.fold(0, (a, b) => a > b ? a : b));
          }),
        ],
      ),
    );
  }

  String _purposeEmoji(AnimalPurpose p) {
    switch (p) {
      case AnimalPurpose.dairy: return '🥛';
      case AnimalPurpose.meat: return '🥩';
      case AnimalPurpose.breeding: return '🐣';
      case AnimalPurpose.mixed: return '🔀';
    }
  }

  Color _purposeColor(AnimalPurpose p) {
    switch (p) {
      case AnimalPurpose.dairy: return RumenoTheme.infoBlue;
      case AnimalPurpose.meat: return Colors.orange;
      case AnimalPurpose.breeding: return Colors.purple;
      case AnimalPurpose.mixed: return Colors.teal;
    }
  }
}

class _KpiCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _KpiCard({required this.emoji, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final int total;
  final Color color;

  const _ProgressRow({required this.emoji, required this.label, required this.count, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
              Text('$count', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('${(pct * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(value: pct, backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation(color), minHeight: 10),
          ),
        ],
      ),
    );
  }
}

class _FarmDistributionRow extends StatelessWidget {
  final String name;
  final int animalCount;
  final int maxCount;

  const _FarmDistributionRow({required this.name, required this.animalCount, required this.maxCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
              child: Text(name[0], style: const TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: maxCount > 0 ? animalCount / maxCount : 0,
                      backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation(RumenoTheme.primaryGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text('$animalCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: RumenoTheme.primaryGreen)),
                Text('animals', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension _StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
"""

with open(os.path.join(BASE, 'lib', 'screens', 'admin', 'admin_farm_screen.dart'), 'w', encoding='utf-8') as f:
    f.write(farm_screen)
print("✅ admin_farm_screen.dart written")

# ============================================================================
# 2. admin_health_config_screen.dart - Complete rewrite for visual accessibility
# ============================================================================
health_config = r"""import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/admin_provider.dart';

class AdminHealthConfigScreen extends StatefulWidget {
  const AdminHealthConfigScreen({super.key});

  @override
  State<AdminHealthConfigScreen> createState() => _AdminHealthConfigScreenState();
}

class _AdminHealthConfigScreenState extends State<AdminHealthConfigScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  static const _tabEmojis = ['💉', '🦠', '💊'];
  static const _tabLabels = ['Vaccines', 'Diseases', 'Medicines'];
  static const _tabColors = [Color(0xFF2E7D32), Color(0xFFE53935), Color(0xFF1565C0)];

  @override
  Widget build(BuildContext context) {
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
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 60),
                child: Row(
                  children: [
                    const Text('⚕️', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Health Config',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Vaccines, Diseases & Medicines',
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
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
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: List.generate(3, (i) => Tab(
                icon: Text(_tabEmojis[i], style: const TextStyle(fontSize: 24)),
                text: _tabLabels[i],
              )),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _ConfigList(type: 'Vaccine', emoji: '💉', color: Color(0xFF2E7D32)),
            _ConfigList(type: 'Disease', emoji: '🦠', color: Color(0xFFE53935)),
            _ConfigList(type: 'Medicine', emoji: '💊', color: Color(0xFF1565C0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: _tabColors[_tab.index.clamp(0, 2)],
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: Text('Add ${_tabLabels[_tab.index.clamp(0, 2)]}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final types = ['Vaccine', 'Disease', 'Medicine'];
    final emojis = ['💉', '🦠', '💊'];
    final nameCtrl = TextEditingController();
    final speciesCtrl = TextEditingController();
    final infoCtrl = TextEditingController();
    final type = types[_tab.index];
    final emoji = emojis[_tab.index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                // Header with emoji
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Text('Add $type', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),

                // Name field
                _buildFormField(
                  icon: Icons.label_rounded,
                  label: 'Name',
                  controller: nameCtrl,
                  hint: '$type name',
                ),
                const SizedBox(height: 16),

                // Species field
                _buildFormField(
                  icon: Icons.pets_rounded,
                  label: 'Applicable Species',
                  controller: speciesCtrl,
                  hint: 'e.g. All, Cow, Buffalo',
                ),
                const SizedBox(height: 16),

                // Info field
                _buildFormField(
                  icon: _tab.index == 0 ? Icons.schedule_rounded : _tab.index == 1 ? Icons.warning_rounded : Icons.category_rounded,
                  label: _tab.index == 0 ? 'Schedule' : _tab.index == 1 ? 'Severity' : 'Category',
                  controller: infoCtrl,
                  hint: _tab.index == 0 ? 'e.g. Every 6 months' : _tab.index == 1 ? 'e.g. High, Medium, Low' : 'e.g. Antibiotic, Vitamin',
                ),
                const SizedBox(height: 28),

                // Big action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        label: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Row(children: [
                                Icon(Icons.warning_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Please enter a name'),
                              ]),
                              backgroundColor: Colors.orange,
                            ));
                            return;
                          }
                          context.read<AdminProvider>().addHealthConfig(HealthConfigItem(
                            id: '${type[0]}${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            species: speciesCtrl.text.trim().isEmpty ? 'All' : speciesCtrl.text.trim(),
                            info: infoCtrl.text.trim(),
                            type: type,
                          ));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('$type added!'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ));
                        },
                        icon: const Icon(Icons.add_rounded, size: 22, color: Colors.white),
                        label: const Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RumenoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildFormField({required IconData icon, required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.06),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
          ),
        ),
      ],
    );
  }
}

class _ConfigList extends StatelessWidget {
  final String type;
  final String emoji;
  final Color color;

  const _ConfigList({required this.type, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.getConfigListByType(type);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text('No ${type.toLowerCase()}s configured',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            const SizedBox(height: 8),
            Text('Tap + to add one',
                style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              // Main content - big and visual
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Big emoji indicator
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.pets_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(item.species, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                          if (item.info.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  type == 'Vaccine' ? Icons.schedule_rounded : type == 'Disease' ? Icons.warning_rounded : Icons.category_rounded,
                                  size: 14, color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(item.info, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons strip - big and color-coded
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showEditDialog(context, item),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_rounded, size: 20, color: RumenoTheme.infoBlue),
                              const SizedBox(width: 6),
                              Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RumenoTheme.infoBlue)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 30, color: Colors.grey.withValues(alpha: 0.15)),
                    Expanded(
                      child: InkWell(
                        onTap: () => _confirmDelete(context, item),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_rounded, size: 20, color: RumenoTheme.errorRed),
                              const SizedBox(width: 6),
                              Text('Delete', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RumenoTheme.errorRed)),
                            ],
                          ),
                        ),
                      ),
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

  void _showEditDialog(BuildContext context, HealthConfigItem item) {
    final nameCtrl = TextEditingController(text: item.name);
    final speciesCtrl = TextEditingController(text: item.species);
    final infoCtrl = TextEditingController(text: item.info);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Text('Edit $type', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                _editFormField(icon: Icons.label_rounded, label: 'Name', controller: nameCtrl, hint: '$type name'),
                const SizedBox(height: 16),
                _editFormField(icon: Icons.pets_rounded, label: 'Applicable Species', controller: speciesCtrl, hint: 'e.g. All, Cow'),
                const SizedBox(height: 16),
                _editFormField(
                  icon: type == 'Vaccine' ? Icons.schedule_rounded : type == 'Disease' ? Icons.warning_rounded : Icons.category_rounded,
                  label: type == 'Vaccine' ? 'Schedule' : type == 'Disease' ? 'Severity' : 'Category',
                  controller: infoCtrl,
                  hint: type == 'Vaccine' ? 'e.g. Every 6 months' : type == 'Disease' ? 'e.g. High' : 'e.g. Antibiotic',
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        label: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AdminProvider>().updateHealthConfig(
                            item.id, type,
                            name: nameCtrl.text.trim(),
                            species: speciesCtrl.text.trim(),
                            info: infoCtrl.text.trim(),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('${item.name} updated!'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ));
                        },
                        icon: const Icon(Icons.save_rounded, size: 22, color: Colors.white),
                        label: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RumenoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _editFormField({required IconData icon, required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.06),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, HealthConfigItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: RumenoTheme.errorRed.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.delete_forever_rounded, color: RumenoTheme.errorRed, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Delete "${item.name}"?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('This cannot be undone',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Cancel', style: TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AdminProvider>().deleteHealthConfig(item.id, type);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(children: [
                        const Icon(Icons.delete_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('${item.name} deleted'),
                      ]),
                      backgroundColor: RumenoTheme.errorRed,
                    ));
                  },
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                  label: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.errorRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
"""

with open(os.path.join(BASE, 'lib', 'screens', 'admin', 'admin_health_config_screen.dart'), 'w', encoding='utf-8') as f:
    f.write(health_config)
print("✅ admin_health_config_screen.dart written")

# ============================================================================
# 3. farmer_card.dart - Enhanced for visual accessibility
# ============================================================================
farmer_card = r"""import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class FarmerCard extends StatelessWidget {
  final Farmer farmer;
  final VoidCallback? onTap;
  final VoidCallback? onCall;

  const FarmerCard({super.key, required this.farmer, this.onTap, this.onCall});

  Color _planColor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return RumenoTheme.planFree;
      case SubscriptionPlan.starter: return RumenoTheme.planStarter;
      case SubscriptionPlan.pro: return RumenoTheme.planPro;
      case SubscriptionPlan.business: return RumenoTheme.planBusiness;
    }
  }

  IconData _planIcon(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return Icons.card_giftcard_rounded;
      case SubscriptionPlan.starter: return Icons.rocket_launch_rounded;
      case SubscriptionPlan.pro: return Icons.star_rounded;
      case SubscriptionPlan.business: return Icons.diamond_rounded;
    }
  }

  String _planEmoji(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return '🆓';
      case SubscriptionPlan.starter: return '🚀';
      case SubscriptionPlan.pro: return '⭐';
      case SubscriptionPlan.business: return '💎';
    }
  }

  @override
  Widget build(BuildContext context) {
    final planClr = _planColor(farmer.plan);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: farmer.isActive ? Colors.transparent : RumenoTheme.errorRed.withValues(alpha: 0.3),
            width: farmer.isActive ? 0 : 2,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            // Main card content - bigger, more visual
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Large avatar with prominent status ring
                  Stack(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                          child: Text(
                            farmer.name[0],
                            style: const TextStyle(
                              color: RumenoTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      // Bigger status indicator with emoji
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: Icon(
                            farmer.isActive ? Icons.check : Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Farmer info - bigger text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farmer.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.home_work_rounded, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                farmer.farmName,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 5),
                            Text(
                              farmer.state,
                              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Big call button - obvious and tappable
                  if (onCall != null)
                    Material(
                      color: RumenoTheme.successGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: onCall,
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(Icons.phone_rounded, color: RumenoTheme.successGreen, size: 26),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Bottom strip - visual indicators
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.04),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  // Animal count with big icon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🐾', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Text('${farmer.animalCount}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF8D6E63))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Plan badge with emoji
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: planClr.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_planEmoji(farmer.plan), style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          farmer.planName,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: planClr),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Status text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(farmer.isActive ? '✅' : '❌', style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        Text(
                          farmer.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tap arrow
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
"""

with open(os.path.join(BASE, 'lib', 'widgets', 'cards', 'farmer_card.dart'), 'w', encoding='utf-8') as f:
    f.write(farmer_card)
print("✅ farmer_card.dart written")

print("\n✅ All 3 files updated for illiterate-friendly UI!")
