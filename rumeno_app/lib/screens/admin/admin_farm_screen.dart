import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_farmers.dart';
import '../../mock/mock_health.dart';
import '../../mock/mock_milk.dart';
import '../../mock/mock_kids.dart';
import '../../mock/mock_finance.dart';
import '../../mock/mock_sales.dart';
import '../../models/models.dart';

class AdminFarmScreen extends StatefulWidget {
  const AdminFarmScreen({super.key});

  @override
  State<AdminFarmScreen> createState() => _AdminFarmScreenState();
}

class _AdminFarmScreenState extends State<AdminFarmScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String? _selectedFarmerId;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  /// Returns the set of animal IDs belonging to the selected farmer.
  /// Returns null when no filter is active (show all).
  Set<String>? get _filteredAnimalIds {
    if (_selectedFarmerId == null) return null;
    return mockAnimals
        .where((a) => a.farmerId == _selectedFarmerId)
        .map((a) => a.id)
        .toSet();
  }

  Farmer? get _selectedFarmer =>
      _selectedFarmerId == null
          ? null
          : mockFarmers.firstWhere((f) => f.id == _selectedFarmerId,
              orElse: () => mockFarmers.first);

  @override
  Widget build(BuildContext context) {
    final selectedFarmer = _selectedFarmer;
    final subtitle = selectedFarmer != null
        ? '${selectedFarmer.farmName}'
        : 'All Farms & Animals';

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
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
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 80),
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
                          children: [
                            const Text('Farm Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            Text(subtitle,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // ── Farm Filter Dropdown ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedFarmerId,
                          isExpanded: true,
                          icon: const Icon(Icons.filter_list_rounded, color: Colors.white, size: 22),
                          dropdownColor: const Color(0xFF2E7D32),
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                          hint: const Row(
                            children: [
                              Icon(Icons.agriculture_rounded, color: Colors.white70, size: 20),
                              SizedBox(width: 8),
                              Text('All Farms', style: TextStyle(color: Colors.white70, fontSize: 15)),
                            ],
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Row(
                                children: [
                                  Icon(Icons.select_all_rounded, color: Colors.white70, size: 20),
                                  SizedBox(width: 8),
                                  Text('All Farms', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            ...mockFarmers.map((f) => DropdownMenuItem<String?>(
                                  value: f.id,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.agriculture_rounded, color: Colors.white70, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${f.farmName} (${f.name})',
                                          style: const TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                          onChanged: (v) => setState(() => _selectedFarmerId = v),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(icon: Text('🐾', style: TextStyle(fontSize: 20)), text: 'Animals'),
                Tab(icon: Text('💊', style: TextStyle(fontSize: 20)), text: 'Health'),
                Tab(icon: Text('🤰', style: TextStyle(fontSize: 20)), text: 'Breeding'),
                Tab(icon: Text('🥛', style: TextStyle(fontSize: 20)), text: 'Milk'),
                Tab(icon: Text('🐐', style: TextStyle(fontSize: 20)), text: 'Kids'),
                Tab(icon: Text('💰', style: TextStyle(fontSize: 20)), text: 'Finance'),
                Tab(icon: Text('📊', style: TextStyle(fontSize: 20)), text: 'Stats'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _AnimalsTab(farmerId: _selectedFarmerId),
            _HealthTab(farmerId: _selectedFarmerId, animalIds: _filteredAnimalIds),
            _BreedingTab(farmerId: _selectedFarmerId, animalIds: _filteredAnimalIds),
            _MilkTab(farmerId: _selectedFarmerId, animalIds: _filteredAnimalIds),
            _KidsTab(farmerId: _selectedFarmerId),
            _FinanceTab(farmerId: _selectedFarmerId),
            _StatsTab(farmerId: _selectedFarmerId, animalIds: _filteredAnimalIds),
          ],
        ),
      ),
    );
  }
}

// ─── Animals Tab ──────────────────────────────────────────────────────────────
class _AnimalsTab extends StatefulWidget {
  final String? farmerId;
  const _AnimalsTab({this.farmerId});

  @override
  State<_AnimalsTab> createState() => _AnimalsTabState();
}

class _AnimalsTabState extends State<_AnimalsTab> {
  String _search = '';
  Species? _speciesFilter;

  @override
  Widget build(BuildContext context) {
    final baseAnimals = widget.farmerId == null
        ? mockAnimals
        : mockAnimals.where((a) => a.farmerId == widget.farmerId).toList();

    final filtered = baseAnimals.where((a) {
      final matchSearch =
          a.breed.toLowerCase().contains(_search.toLowerCase()) ||
              a.tagId.toLowerCase().contains(_search.toLowerCase());
      final matchSpecies =
          _speciesFilter == null || a.species == _speciesFilter;
      return matchSearch && matchSpecies;
    }).toList();

    final speciesCounts = <Species, int>{};
    for (final a in baseAnimals) {
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
            _detailCard(const Icon(Icons.cake_rounded, color: Colors.purple, size: 22), Colors.purple, 'Age', animal.ageString),
            _detailCard(
                Icon(animal.gender == Gender.male ? Icons.male_rounded : Icons.female_rounded,
                    color: animal.gender == Gender.male ? Colors.blue : Colors.pink, size: 22),
                animal.gender == Gender.male ? Colors.blue : Colors.pink,
                'Gender', animal.gender.name.capitalize()),
            _detailCard(Icon(Icons.favorite_rounded, color: _statusDetailColor(animal.status), size: 22), _statusDetailColor(animal.status), 'Status', animal.statusLabel),
            _detailCard(Image.asset('assets/images/farm1.png', width: 22, height: 22), Colors.teal, 'Purpose', animal.purpose.name.capitalize()),
            _detailCard(const Icon(Icons.monitor_weight_rounded, color: Colors.orange, size: 22), Colors.orange, 'Weight', '${animal.weightKg.toStringAsFixed(1)} kg'),
            _detailCard(Icon(Icons.person_rounded, color: RumenoTheme.primaryGreen, size: 22), RumenoTheme.primaryGreen, 'Farmer', animal.farmerId),
            if (animal.shedNumber != null) _detailCard(const Icon(Icons.home_rounded, color: Colors.brown, size: 22), Colors.brown, 'Shed', animal.shedNumber!),
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
                      _showFullAnimalProfile(context, animal);
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

  Widget _detailCard(Widget icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: icon)),
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
class _HealthTab extends StatefulWidget {
  final String? farmerId;
  final Set<String>? animalIds;
  const _HealthTab({this.farmerId, this.animalIds});

  @override
  State<_HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends State<_HealthTab> {
  bool _showAllVax = false;
  bool _showAllTreatments = false;
  bool _showAllDeworming = false;
  bool _showAllBreeding = false;
  bool _showAllLab = false;

  bool _matchAnimal(String animalId) =>
      widget.animalIds == null || widget.animalIds!.contains(animalId);

  @override
  Widget build(BuildContext context) {
    final vax = mockVaccinations.where((v) => _matchAnimal(v.animalId)).toList();
    final treats = mockTreatments.where((t) => _matchAnimal(t.animalId)).toList();
    final deworms = mockDewormingRecords.where((d) => _matchAnimal(d.animalId)).toList();
    final breeds = mockBreedingRecords.where((b) => _matchAnimal(b.animalId)).toList();
    final labs = mockLabReports.where((l) => _matchAnimal(l.animalId)).toList();

    final overdueVax = vax.where((v) => v.status == VaccinationStatus.overdue).toList();
    final dueVax = vax.where((v) => v.status == VaccinationStatus.due).toList();
    final activeTreatments = treats.where((t) => t.endDate == null || t.endDate!.isAfter(DateTime.now())).toList();
    final overdueDeworm = deworms.where((d) => d.status == DewormingStatus.overdue).toList();
    final pregnantAnimals = breeds.where((b) => b.isPregnant == true).toList();
    final pendingLabs = labs.where((l) => l.status == LabReportStatus.pending).toList();

    final vaxToShow = _showAllVax ? vax : vax.take(5).toList();
    final treatToShow = _showAllTreatments ? treats : treats.take(4).toList();
    final dewormToShow = _showAllDeworming ? deworms : deworms.take(4).toList();
    final breedToShow = _showAllBreeding ? breeds : breeds.take(4).toList();
    final labToShow = _showAllLab ? labs : labs.take(4).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Alert Cards ───
          if (overdueVax.isNotEmpty)
            _AlertCard(
              emoji: '🚨',
              color: RumenoTheme.errorRed,
              title: '${overdueVax.length} Overdue Vaccination${overdueVax.length > 1 ? 's' : ''}',
              subtitle: 'Needs injection NOW!',
              onTap: () => _showRecordListSheet(context, 'Overdue Vaccinations', overdueVax.map((v) {
                final animal = getAnimalById(v.animalId);
                return _RecordInfo(tag: animal?.tagId ?? v.animalId, title: v.vaccineName, subtitle: 'Due: ${_fmtDate(v.dueDate)}', color: RumenoTheme.errorRed, emoji: '🔴');
              }).toList()),
            ),
          if (dueVax.isNotEmpty)
            _AlertCard(
              emoji: '⏰',
              color: RumenoTheme.warningYellow,
              title: '${dueVax.length} Vaccination${dueVax.length > 1 ? 's' : ''} Due Soon',
              subtitle: 'Give injection this week',
              onTap: () => _showRecordListSheet(context, 'Due Vaccinations', dueVax.map((v) {
                final animal = getAnimalById(v.animalId);
                return _RecordInfo(tag: animal?.tagId ?? v.animalId, title: v.vaccineName, subtitle: 'Due: ${_fmtDate(v.dueDate)}', color: RumenoTheme.warningYellow, emoji: '🟡');
              }).toList()),
            ),
          if (activeTreatments.isNotEmpty)
            _AlertCard(
              emoji: '🏥',
              color: RumenoTheme.infoBlue,
              title: '${activeTreatments.length} Animals Being Treated',
              subtitle: 'Sick animals getting medicine',
              onTap: () => _showRecordListSheet(context, 'Active Treatments', activeTreatments.map((t) {
                final animal = getAnimalById(t.animalId);
                return _RecordInfo(tag: animal?.tagId ?? t.animalId, title: t.diagnosis, subtitle: t.treatment, color: RumenoTheme.infoBlue, emoji: '💊');
              }).toList()),
            ),
          if (overdueDeworm.isNotEmpty)
            _AlertCard(
              emoji: '🐛',
              color: Colors.orange,
              title: '${overdueDeworm.length} Deworming Overdue',
              subtitle: 'Give worm medicine now!',
              onTap: () => _showRecordListSheet(context, 'Overdue Deworming', overdueDeworm.map((d) {
                final animal = getAnimalById(d.animalId);
                return _RecordInfo(tag: animal?.tagId ?? d.animalId, title: d.medicineName, subtitle: 'Due: ${_fmtDate(d.dueDate)}', color: Colors.orange, emoji: '🔴');
              }).toList()),
            ),
          if (pregnantAnimals.isNotEmpty)
            _AlertCard(
              emoji: '🤰',
              color: Colors.pink,
              title: '${pregnantAnimals.length} Pregnant Animals',
              subtitle: 'Animals expecting babies',
              onTap: () => _showRecordListSheet(context, 'Pregnant Animals', pregnantAnimals.map((b) {
                final animal = getAnimalById(b.animalId);
                return _RecordInfo(tag: animal?.tagId ?? b.animalId, title: 'Due: ${b.expectedDelivery != null ? _fmtDate(b.expectedDelivery!) : 'Unknown'}', subtitle: b.aiDone ? 'AI Done' : 'Natural Mating', color: Colors.pink, emoji: '🤰');
              }).toList()),
            ),
          if (pendingLabs.isNotEmpty)
            _AlertCard(
              emoji: '🔬',
              color: Colors.purple,
              title: '${pendingLabs.length} Lab Results Pending',
              subtitle: 'Waiting for test results',
              onTap: () => _showRecordListSheet(context, 'Pending Lab Reports', pendingLabs.map((l) {
                final animal = getAnimalById(l.animalId);
                return _RecordInfo(tag: animal?.tagId ?? l.animalId, title: l.testName, subtitle: 'Lab: ${l.labName ?? 'Unknown'}', color: Colors.purple, emoji: '⏳');
              }).toList()),
            ),
          const SizedBox(height: 20),

          // ─── Quick Actions ───
          const Text('⚡ Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _QuickActionCard(emoji: '💉', icon: Icons.vaccines_rounded, color: RumenoTheme.primaryGreen, label: 'Health Config', onTap: () => context.push('/admin/farm/health-config')),
              _QuickActionCard(emoji: '🐛', icon: Icons.pest_control_rounded, color: Colors.teal, label: 'Dewormings', onTap: () => _showDewormingSheet(context)),
              _QuickActionCard(emoji: '🤰', icon: Icons.child_friendly_rounded, color: Colors.pink, label: 'Breeding', onTap: () => _showBreedingSheet(context)),
              _QuickActionCard(emoji: '🔬', icon: Icons.science_rounded, color: Colors.purple, label: 'Lab Reports', onTap: () => _showLabReportSheet(context)),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Vaccination Records ───
          Row(children: [
            const Icon(Icons.vaccines_rounded, size: 22, color: RumenoTheme.primaryGreen),
            const SizedBox(width: 8),
            Text('Injections (${vax.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...vaxToShow.map((v) => _VaccinationTile(vaccination: v)),
          if (vax.length > 5)
            _ShowMoreButton(
              expanded: _showAllVax,
              total: vax.length,
              onTap: () => setState(() => _showAllVax = !_showAllVax),
            ),
          const SizedBox(height: 20),

          // ─── Treatment Records ───
          Row(children: [
            const Icon(Icons.medical_services_rounded, size: 22, color: RumenoTheme.errorRed),
            const SizedBox(width: 8),
            Text('Treatments (${treats.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...treatToShow.map((t) => _TreatmentTile(treatment: t)),
          if (treats.length > 4)
            _ShowMoreButton(
              expanded: _showAllTreatments,
              total: treats.length,
              onTap: () => setState(() => _showAllTreatments = !_showAllTreatments),
            ),
          const SizedBox(height: 20),

          // ─── Deworming Records ───
          Row(children: [
            const Icon(Icons.pest_control_rounded, size: 22, color: Colors.teal),
            const SizedBox(width: 8),
            Text('Deworming (${deworms.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...dewormToShow.map((d) => _DewormingTile(deworming: d)),
          if (deworms.length > 4)
            _ShowMoreButton(
              expanded: _showAllDeworming,
              total: deworms.length,
              onTap: () => setState(() => _showAllDeworming = !_showAllDeworming),
            ),
          const SizedBox(height: 20),

          // ─── Breeding Records ───
          Row(children: [
            const Icon(Icons.child_friendly_rounded, size: 22, color: Colors.pink),
            const SizedBox(width: 8),
            Text('Breeding (${breeds.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...breedToShow.map((b) => _BreedingTile(breeding: b)),
          if (breeds.length > 4)
            _ShowMoreButton(
              expanded: _showAllBreeding,
              total: breeds.length,
              onTap: () => setState(() => _showAllBreeding = !_showAllBreeding),
            ),
          const SizedBox(height: 20),

          // ─── Lab Reports ───
          Row(children: [
            const Icon(Icons.science_rounded, size: 22, color: Colors.purple),
            const SizedBox(width: 8),
            Text('Lab Reports (${labs.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...labToShow.map((l) => _LabReportTile(labReport: l)),
          if (labs.length > 4)
            _ShowMoreButton(
              expanded: _showAllLab,
              total: labs.length,
              onTap: () => setState(() => _showAllLab = !_showAllLab),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  void _showRecordListSheet(BuildContext context, String title, List<_RecordInfo> records) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        minChildSize: 0.3,
        builder: (ctx, sc) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: sc,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: records.length,
                  itemBuilder: (ctx, i) {
                    final r = records[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(color: r.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text(r.emoji, style: const TextStyle(fontSize: 24))),
                        ),
                        title: Text(r.tag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.title, style: const TextStyle(fontSize: 14)),
                            Text(r.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDewormingSheet(BuildContext context) {
    _showRecordListSheet(context, 'All Deworming Records', mockDewormingRecords.map((d) {
      final animal = getAnimalById(d.animalId);
      final statusEmoji = d.status == DewormingStatus.done ? '🟢' : d.status == DewormingStatus.overdue ? '🔴' : '🟡';
      final statusText = d.status == DewormingStatus.done ? 'Done' : d.status == DewormingStatus.overdue ? 'OVERDUE!' : 'Due Soon';
      return _RecordInfo(
        tag: animal?.tagId ?? d.animalId,
        title: '${d.medicineName} ${d.dose ?? ''}',
        subtitle: '$statusText · ${_fmtDate(d.dueDate)}',
        color: d.status == DewormingStatus.done ? RumenoTheme.successGreen : d.status == DewormingStatus.overdue ? RumenoTheme.errorRed : RumenoTheme.warningYellow,
        emoji: statusEmoji,
      );
    }).toList());
  }

  void _showBreedingSheet(BuildContext context) {
    _showRecordListSheet(context, 'All Breeding Records', mockBreedingRecords.map((b) {
      final animal = getAnimalById(b.animalId);
      return _RecordInfo(
        tag: animal?.tagId ?? b.animalId,
        title: b.isPregnant == true ? 'Pregnant - Due ${b.expectedDelivery != null ? _fmtDate(b.expectedDelivery!) : 'Unknown'}' : 'Not Pregnant',
        subtitle: '${b.aiDone ? 'AI' : 'Natural'} · Heat: ${_fmtDate(b.heatDate)}',
        color: b.isPregnant == true ? Colors.pink : Colors.grey,
        emoji: b.isPregnant == true ? '🤰' : '🔄',
      );
    }).toList());
  }

  void _showLabReportSheet(BuildContext context) {
    _showRecordListSheet(context, 'All Lab Reports', mockLabReports.map((l) {
      final animal = getAnimalById(l.animalId);
      final statusEmoji = l.status == LabReportStatus.completed ? '✅' : '⏳';
      return _RecordInfo(
        tag: animal?.tagId ?? l.animalId,
        title: l.testName,
        subtitle: '${l.status == LabReportStatus.completed ? 'Result: ${l.result ?? 'N/A'}' : 'Waiting for results'} · ${l.labName ?? ''}',
        color: l.status == LabReportStatus.completed ? RumenoTheme.successGreen : Colors.purple,
        emoji: statusEmoji,
      );
    }).toList());
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
    final animal = getAnimalById(vaccination.animalId);
    Color statusColor;
    String statusLabel;
    switch (vaccination.status) {
      case VaccinationStatus.overdue:
        statusColor = RumenoTheme.errorRed;
        statusLabel = 'OVERDUE';
        break;
      case VaccinationStatus.due:
        statusColor = RumenoTheme.warningYellow;
        statusLabel = 'DUE';
        break;
      case VaccinationStatus.done:
        statusColor = RumenoTheme.successGreen;
        statusLabel = 'DONE';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showVaccinationDetail(context, vaccination),
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
                      Text(animal?.tagId ?? vaccination.animalId, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVaccinationDetail(BuildContext context, VaccinationRecord vax) {
    final animal = getAnimalById(vax.animalId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('💉 Vaccination Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _vaxInfoRow(Icons.pets_rounded, 'Animal', animal?.tagId ?? vax.animalId),
            _vaxInfoRow(Icons.vaccines_rounded, 'Vaccine', vax.vaccineName),
            _vaxInfoRow(Icons.calendar_today_rounded, 'Due Date', '${vax.dueDate.day}/${vax.dueDate.month}/${vax.dueDate.year}'),
            if (vax.dateAdministered != null) _vaxInfoRow(Icons.check_circle_rounded, 'Given On', '${vax.dateAdministered!.day}/${vax.dateAdministered!.month}/${vax.dateAdministered!.year}'),
            if (vax.nextDueDate != null) _vaxInfoRow(Icons.event_rounded, 'Next Due', '${vax.nextDueDate!.day}/${vax.nextDueDate!.month}/${vax.nextDueDate!.year}'),
            if (vax.vetName != null) _vaxInfoRow(Icons.person_rounded, 'Vet', vax.vetName!),
            if (vax.dose != null) _vaxInfoRow(Icons.medical_information_rounded, 'Dose', vax.dose!),
            if (vax.batchNumber != null) _vaxInfoRow(Icons.qr_code_rounded, 'Batch', vax.batchNumber!),
            _vaxInfoRow(Icons.flag_rounded, 'Status', vax.status.name.toUpperCase()),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vaxInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: RumenoTheme.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: RumenoTheme.primaryGreen, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
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
    final animal = getAnimalById(treatment.animalId);
    final isActive = treatment.endDate == null || treatment.endDate!.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showTreatmentDetail(context, treatment),
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
                    Text(treatment.diagnosis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.pets_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(animal?.tagId ?? treatment.animalId, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      Expanded(child: Text(treatment.treatment, style: TextStyle(fontSize: 12, color: Colors.grey[500]), overflow: TextOverflow.ellipsis)),
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
      ),
    );
  }

  void _showTreatmentDetail(BuildContext context, TreatmentRecord tr) {
    final animal = getAnimalById(tr.animalId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('🏥 Treatment Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _trInfoRow(Icons.pets_rounded, 'Animal', animal?.tagId ?? tr.animalId),
            _trInfoRow(Icons.sick_rounded, 'Symptoms', tr.symptoms.join(', ')),
            _trInfoRow(Icons.medical_information_rounded, 'Diagnosis', tr.diagnosis),
            _trInfoRow(Icons.medication_rounded, 'Treatment', tr.treatment),
            _trInfoRow(Icons.calendar_today_rounded, 'Started', '${tr.startDate.day}/${tr.startDate.month}/${tr.startDate.year}'),
            if (tr.endDate != null) _trInfoRow(Icons.event_available_rounded, 'Ended', '${tr.endDate!.day}/${tr.endDate!.month}/${tr.endDate!.year}'),
            _trInfoRow(Icons.person_rounded, 'Vet', tr.vetName),
            if (tr.withdrawalDays != null) _trInfoRow(Icons.timer_rounded, 'Withdrawal', '${tr.withdrawalDays} days'),
            if (tr.followUpDate != null) _trInfoRow(Icons.event_rounded, 'Follow-up', '${tr.followUpDate!.day}/${tr.followUpDate!.month}/${tr.followUpDate!.year}'),
            _trInfoRow(Icons.flag_rounded, 'Status', tr.status.name.toUpperCase()),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.errorRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: RumenoTheme.errorRed.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: RumenoTheme.errorRed, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Breeding Tab ─────────────────────────────────────────────────────────────
class _BreedingTab extends StatefulWidget {
  final String? farmerId;
  final Set<String>? animalIds;
  const _BreedingTab({this.farmerId, this.animalIds});

  @override
  State<_BreedingTab> createState() => _BreedingTabState();
}

class _BreedingTabState extends State<_BreedingTab> {
  String _filter = 'all'; // 'all', 'pregnant', 'ai', 'natural'

  bool _matchAnimal(String animalId) =>
      widget.animalIds == null || widget.animalIds!.contains(animalId);

  @override
  Widget build(BuildContext context) {
    final allRecords = mockBreedingRecords.where((b) => _matchAnimal(b.animalId)).toList();
    final pregnant = allRecords.where((b) => b.isPregnant).length;
    final aiCount = allRecords.where((b) => b.aiDone).length;
    final naturalCount = allRecords.where((b) => !b.aiDone).length;
    final upcoming = allRecords
        .where((b) => b.isPregnant && b.expectedDelivery != null && b.expectedDelivery!.isAfter(DateTime.now()))
        .toList()
      ..sort((a, b) => a.expectedDelivery!.compareTo(b.expectedDelivery!));

    final filtered = allRecords.where((b) {
      if (_filter == 'pregnant') return b.isPregnant;
      if (_filter == 'ai') return b.aiDone;
      if (_filter == 'natural') return !b.aiDone;
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _KpiCard(emoji: '🤰', label: 'Pregnant', value: '$pregnant', color: Colors.pink),
              _KpiCard(emoji: '🔬', label: 'AI Done', value: '$aiCount', color: RumenoTheme.infoBlue),
              _KpiCard(emoji: '💕', label: 'Natural', value: '$naturalCount', color: Colors.purple),
              _KpiCard(emoji: '📅', label: 'Upcoming', value: '${upcoming.length}', color: Colors.orange),
            ],
          ),
          const SizedBox(height: 20),

          // Upcoming Deliveries Alert
          if (upcoming.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🍼', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Text('Upcoming Deliveries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pink)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...upcoming.take(3).map((b) {
                    final animal = getAnimalById(b.animalId);
                    final daysLeft = b.expectedDelivery!.difference(DateTime.now()).inDays;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.pink.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                            child: Text(animal?.tagId ?? b.animalId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.pink)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text('${b.expectedDelivery!.day}/${b.expectedDelivery!.month}/${b.expectedDelivery!.year}', style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: daysLeft < 30 ? RumenoTheme.errorRed.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('$daysLeft days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: daysLeft < 30 ? RumenoTheme.errorRed : Colors.orange)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Filter Chips
          Row(
            children: [
              const Text('🤰 Records ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Spacer(),
              _FilterChip(label: 'All', selected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
              const SizedBox(width: 6),
              _FilterChip(label: 'Pregnant', selected: _filter == 'pregnant', onTap: () => setState(() => _filter = 'pregnant')),
              const SizedBox(width: 6),
              _FilterChip(label: 'AI', selected: _filter == 'ai', onTap: () => setState(() => _filter = 'ai')),
            ],
          ),
          const SizedBox(height: 12),

          // Breeding Records List
          ...filtered.map((b) => _BreedingTile(breeding: b)),
          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text('🤰', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text('No records match filter', style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? RumenoTheme.primaryGreen : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : Colors.grey[600])),
      ),
    );
  }
}

// ─── Milk Tab ─────────────────────────────────────────────────────────────────
class _MilkTab extends StatelessWidget {
  final String? farmerId;
  final Set<String>? animalIds;
  const _MilkTab({this.farmerId, this.animalIds});

  bool _matchAnimal(String animalId) =>
      animalIds == null || animalIds!.contains(animalId);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final allMilkRecords = mockMilkRecords.where((r) => _matchAnimal(r.animalId)).toList();
    final todayTotal = allMilkRecords.where((r) => r.date.year == today.year && r.date.month == today.month && r.date.day == today.day).fold(0.0, (s, r) => s + r.quantityLitres);
    final yesterdayTotal = allMilkRecords.where((r) => r.date.year == yesterday.year && r.date.month == yesterday.month && r.date.day == yesterday.day).fold(0.0, (s, r) => s + r.quantityLitres);
    final todayRecords = allMilkRecords.where((r) => r.date.year == today.year && r.date.month == today.month && r.date.day == today.day).toList();
    final morningTotal = todayRecords.where((r) => r.session == MilkSession.morning).fold(0.0, (s, r) => s + r.quantityLitres);
    final eveningTotal = todayRecords.where((r) => r.session == MilkSession.evening).fold(0.0, (s, r) => s + r.quantityLitres);
    final baseAnimals = farmerId == null ? mockAnimals : mockAnimals.where((a) => a.farmerId == farmerId).toList();
    final dairyAnimals = getDairyAnimals(baseAnimals);
    final change = yesterdayTotal > 0 ? ((todayTotal - yesterdayTotal) / yesterdayTotal * 100) : 0.0;

    // Per-animal milk summary (today)
    final animalMilk = <String, double>{};
    for (final r in todayRecords) {
      animalMilk[r.animalId] = (animalMilk[r.animalId] ?? 0) + r.quantityLitres;
    }
    final sortedAnimals = animalMilk.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Production Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🥛', style: TextStyle(fontSize: 32)),
                    SizedBox(width: 10),
                    Text("Today's Production", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${todayTotal.toStringAsFixed(1)} L', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (change >= 0 ? Colors.green : Colors.red).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _MilkSessionBadge(icon: '🌅', label: 'Morning', value: '${morningTotal.toStringAsFixed(1)} L'),
                    const SizedBox(width: 12),
                    _MilkSessionBadge(icon: '🌙', label: 'Evening', value: '${eveningTotal.toStringAsFixed(1)} L'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Stats
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _MilkStatCard(emoji: '🐄', value: '${dairyAnimals.length}', label: 'Dairy Animals'),
              _MilkStatCard(emoji: '📝', value: '${todayRecords.length}', label: 'Entries Today'),
              _MilkStatCard(emoji: '📅', value: '${yesterdayTotal.toStringAsFixed(0)} L', label: 'Yesterday'),
            ],
          ),
          const SizedBox(height: 20),

          // Per Animal Production
          const Row(
            children: [
              Text('🐄', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('Per Animal (Today)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          if (sortedAnimals.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Text('🥛', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text('No milk entries today', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            ...sortedAnimals.map((entry) {
              final animal = getAnimalById(entry.key);
              final maxMilk = sortedAnimals.first.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: RumenoTheme.infoBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text(_speciesEmoji(animal?.species), style: const TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(animal?.tagId ?? entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: maxMilk > 0 ? entry.value / maxMilk : 0,
                                backgroundColor: RumenoTheme.infoBlue.withValues(alpha: 0.1),
                                valueColor: const AlwaysStoppedAnimation(RumenoTheme.infoBlue),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${entry.value.toStringAsFixed(1)} L', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RumenoTheme.infoBlue)),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  static String _speciesEmoji(Species? species) {
    if (species == null) return '🐾';
    const icons = {Species.cow: '🐄', Species.buffalo: '🐃', Species.goat: '🐐', Species.sheep: '🐑', Species.pig: '🐷', Species.horse: '🐴'};
    return icons[species] ?? '🐾';
  }
}

class _MilkSessionBadge extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _MilkSessionBadge({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MilkStatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _MilkStatCard({required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Kids Tab ─────────────────────────────────────────────────────────────────
class _KidsTab extends StatelessWidget {
  final String? farmerId;
  const _KidsTab({this.farmerId});

  @override
  Widget build(BuildContext context) {
    final kids = farmerId == null
        ? mockKids
        : mockKids.where((k) => k.farmerId == farmerId).toList();
    final totalK = kids.length;
    final weaned = kids.where((k) => k.isWeaned).length;
    final coccDue = kids.where((k) => k.coccidisostatDue).length;
    final onReplacer = kids.where((k) => k.milkReplacerStartDate != null).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _KpiCard(emoji: '🐐', label: 'Total Kids', value: '$totalK', color: RumenoTheme.primaryGreen),
              _KpiCard(emoji: '🍼', label: 'On Replacer', value: '$onReplacer', color: RumenoTheme.infoBlue),
              _KpiCard(emoji: '🌾', label: 'Weaned', value: '$weaned', color: Colors.teal),
              _KpiCard(emoji: '💊', label: 'Coccidiostat Due', value: '$coccDue', color: coccDue > 0 ? RumenoTheme.errorRed : Colors.grey),
            ],
          ),
          const SizedBox(height: 20),

          // Alert: Coccidiostat Due
          if (coccDue > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: RumenoTheme.errorRed.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$coccDue Kid${coccDue > 1 ? 's' : ''} Need Coccidiostat', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: RumenoTheme.errorRed)),
                        Text('Medicine due or overdue', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Kid Cards List
          const Row(
            children: [
              Text('🐐', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('All Kids', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          ...kids.map((kid) {
            final mother = getAnimalById(kid.motherId ?? '');
            final ageInDays = kid.dateOfBirth != null ? DateTime.now().difference(kid.dateOfBirth!).inDays : 0;
            final coccStatus = kid.coccidisostatDue;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showKidDetail(context, kid, mother),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(child: Text('🐐', style: TextStyle(fontSize: 28))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(kid.kidId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(width: 8),
                                if (coccStatus)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: RumenoTheme.errorRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                    child: const Text('💊 DUE', style: TextStyle(fontSize: 10, color: RumenoTheme.errorRed, fontWeight: FontWeight.bold)),
                                  ),
                                if (kid.isWeaned)
                                  Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                    child: const Text('🌾 WEANED', style: TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Mother: ${mother?.tagId ?? 'Unknown'} · $ageInDays days old',
                                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                            if (kid.averageWeightKg != null)
                              Text('${kid.averageWeightKg!.toStringAsFixed(1)} kg',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showKidDetail(BuildContext context, KidRecord kid, Animal? mother) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('🐐 Kid Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _kidInfoRow(Icons.tag_rounded, 'Kid ID', kid.kidId),
            _kidInfoRow(Icons.pets_rounded, 'Mother', mother?.tagId ?? kid.motherId ?? 'Unknown'),
            if (kid.fatherAiId != null) _kidInfoRow(Icons.science_rounded, 'Father AI ID', kid.fatherAiId!),
            if (kid.dateOfBirth != null) _kidInfoRow(Icons.cake_rounded, 'Born', '${kid.dateOfBirth!.day}/${kid.dateOfBirth!.month}/${kid.dateOfBirth!.year}'),
            if (kid.averageWeightKg != null) _kidInfoRow(Icons.monitor_weight_rounded, 'Weight', '${kid.averageWeightKg!.toStringAsFixed(1)} kg'),
            if (kid.coccidisostatName != null) _kidInfoRow(Icons.medication_rounded, 'Coccidiostat', kid.coccidisostatName!),
            if (kid.coccidisostatNextDate != null) _kidInfoRow(Icons.event_rounded, 'Next Dose', '${kid.coccidisostatNextDate!.day}/${kid.coccidisostatNextDate!.month}/${kid.coccidisostatNextDate!.year}'),
            if (kid.weaningDate != null) _kidInfoRow(Icons.grass_rounded, 'Weaning Date', '${kid.weaningDate!.day}/${kid.weaningDate!.month}/${kid.weaningDate!.year}'),
            _kidInfoRow(Icons.check_circle_rounded, 'Weaned', kid.isWeaned ? 'Yes ✅' : 'No ❌'),
            if (kid.milkReplacerStartDate != null) _kidInfoRow(Icons.local_drink_rounded, 'Milk Replacer Since', '${kid.milkReplacerStartDate!.day}/${kid.milkReplacerStartDate!.month}/${kid.milkReplacerStartDate!.year}'),
            if (kid.notes != null) _kidInfoRow(Icons.note_rounded, 'Notes', kid.notes!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kidInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: RumenoTheme.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: RumenoTheme.primaryGreen, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Finance Tab ──────────────────────────────────────────────────────────────
class _FinanceTab extends StatelessWidget {
  final String? farmerId;
  const _FinanceTab({this.farmerId});

  @override
  Widget build(BuildContext context) {
    final expenses = farmerId == null
        ? mockExpenses
        : mockExpenses.where((e) => e.farmerId == farmerId).toList();
    final sales = farmerId == null
        ? mockSales
        : mockSales.where((s) => s.farmerId == farmerId).toList();

    final totalExp = expenses.fold(0.0, (s, e) => s + e.amount);
    final totalSale = sales.fold(0.0, (s, e) => s + e.amount);
    final profit = totalSale - totalExp;

    // Expense by category
    final catExpenses = <ExpenseCategory, double>{};
    for (final e in expenses) {
      catExpenses[e.category] = (catExpenses[e.category] ?? 0) + e.amount;
    }
    final sortedCats = catExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Sales by type
    final saleByType = <SaleType, double>{};
    for (final s in sales) {
      saleByType[s.type] = (saleByType[s.type] ?? 0) + s.amount;
    }

    // Recent transactions (combined, sorted by date)
    final recentExpenses = expenses.take(5).toList();
    final recentSales = sales.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: profit >= 0
                    ? [const Color(0xFF2E7D32), const Color(0xFF66BB6A)]
                    : [const Color(0xFFC62828), const Color(0xFFEF5350)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FinanceSummaryItem(emoji: '📥', label: 'Income', value: '₹${_fmtAmount(totalSale)}'),
                    _FinanceSummaryItem(emoji: '📤', label: 'Expenses', value: '₹${_fmtAmount(totalExp)}'),
                    _FinanceSummaryItem(emoji: profit >= 0 ? '📈' : '📉', label: 'Profit', value: '₹${_fmtAmount(profit.abs())}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Expense Breakdown
          const Row(
            children: [
              Text('📤', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('Expense Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          ...sortedCats.map((entry) {
            final pct = totalExp > 0 ? entry.value / totalExp : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_catEmoji(entry.key), style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entry.key.name[0].toUpperCase() + entry.key.name.substring(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                      Text('₹${_fmtAmount(entry.value)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('${(pct * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: pct, backgroundColor: Colors.orange.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation(Colors.orange), minHeight: 8),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Sales by Type
          const Row(
            children: [
              Text('📥', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('Sales by Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: saleByType.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Text(_saleTypeEmoji(entry.key), style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(entry.key.name[0].toUpperCase() + entry.key.name.substring(1), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('₹${_fmtAmount(entry.value)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Recent Expenses
          Row(
            children: [
              const Text('📤', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('Recent Expenses (${expenses.length} total)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ...recentExpenses.map((e) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(_catEmoji(e.category), style: const TextStyle(fontSize: 20))),
                  ),
                  title: Text(e.subCategory ?? e.categoryName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${e.date.day}/${e.date.month}/${e.date.year} · ${e.vendorName ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  trailing: Text('-₹${_fmtAmount(e.amount)}', style: const TextStyle(color: RumenoTheme.errorRed, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              )),
          const SizedBox(height: 16),

          // Recent Sales
          Row(
            children: [
              const Text('📥', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('Recent Sales (${sales.length} total)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ...recentSales.map((s) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: RumenoTheme.successGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(_saleTypeEmoji(s.type), style: const TextStyle(fontSize: 20))),
                  ),
                  title: Text(s.buyerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${s.date.day}/${s.date.month}/${s.date.year} · ${s.type.name}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  trailing: Text('+₹${_fmtAmount(s.amount)}', style: const TextStyle(color: RumenoTheme.successGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              )),
        ],
      ),
    );
  }

  static String _fmtAmount(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  static String _catEmoji(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.feed: return '🌾';
      case ExpenseCategory.medicine: return '💊';
      case ExpenseCategory.veterinary: return '🩺';
      case ExpenseCategory.labour: return '👷';
      case ExpenseCategory.equipment: return '🔧';
      case ExpenseCategory.transport: return '🚜';
      case ExpenseCategory.other: return '📦';
    }
  }

  static String _saleTypeEmoji(SaleType type) {
    switch (type) {
      case SaleType.animal: return '🐄';
      case SaleType.milk: return '🥛';
      case SaleType.produce: return '🧈';
      case SaleType.other: return '📦';
    }
  }
}

class _FinanceSummaryItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _FinanceSummaryItem({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

// ─── Stats Tab ────────────────────────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  final String? farmerId;
  final Set<String>? animalIds;
  const _StatsTab({this.farmerId, this.animalIds});

  bool _matchAnimal(String animalId) =>
      animalIds == null || animalIds!.contains(animalId);

  @override
  Widget build(BuildContext context) {
    final animals = farmerId == null
        ? mockAnimals
        : mockAnimals.where((a) => a.farmerId == farmerId).toList();
    final vax = mockVaccinations.where((v) => _matchAnimal(v.animalId)).toList();
    final deworms = mockDewormingRecords.where((d) => _matchAnimal(d.animalId)).toList();
    final labs = mockLabReports.where((l) => _matchAnimal(l.animalId)).toList();

    final total = animals.length;
    final active = animals.where((a) => a.status == AnimalStatus.active).length;
    final pregnant = animals.where((a) => a.status == AnimalStatus.pregnant).length;
    final sick = animals.where((a) => a.status == AnimalStatus.sick || a.status == AnimalStatus.underTreatment).length;
    final deceased = animals.where((a) => a.status == AnimalStatus.deceased).length;
    final overdueVax = vax.where((v) => v.status == VaccinationStatus.overdue).length;
    final overdueDeworm = deworms.where((d) => d.status == DewormingStatus.overdue).length;
    final pendingLabs = labs.where((l) => l.status == LabReportStatus.pending).length;

    final purposeCounts = <AnimalPurpose, int>{};
    for (final a in animals) {
      purposeCounts[a.purpose] = (purposeCounts[a.purpose] ?? 0) + 1;
    }

    final farmerCounts = <String, int>{};
    for (final a in animals) {
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
              _KpiCard(emoji: '🕊️', label: 'Deceased', value: '$deceased', color: Colors.grey),
              _KpiCard(emoji: '🚨', label: 'Overdue Tasks', value: '${overdueVax + overdueDeworm}', color: Colors.orange),
            ],
          ),
          const SizedBox(height: 24),

          // Health summary
          const Text('Health Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _ProgressRow(emoji: '💉', label: 'Overdue Injections', count: overdueVax, total: vax.length, color: RumenoTheme.errorRed),
          _ProgressRow(emoji: '🐛', label: 'Overdue Deworming', count: overdueDeworm, total: deworms.length, color: Colors.orange),
          _ProgressRow(emoji: '🔬', label: 'Pending Lab Reports', count: pendingLabs, total: labs.length, color: Colors.purple),
          _ProgressRow(emoji: '🤰', label: 'Pregnant Animals', count: pregnant, total: total, color: Colors.pink),
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

// ─── Show More / Less Button ──────────────────────────────────────────────────
class _ShowMoreButton extends StatelessWidget {
  final bool expanded;
  final int total;
  final VoidCallback onTap;

  const _ShowMoreButton({required this.expanded, required this.total, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 22),
          label: Text(expanded ? 'Show Less' : 'View All $total Records', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: RumenoTheme.primaryGreen,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

// ─── Record Info Model ────────────────────────────────────────────────────────
class _RecordInfo {
  final String tag;
  final String title;
  final String subtitle;
  final Color color;
  final String emoji;

  _RecordInfo({required this.tag, required this.title, required this.subtitle, required this.color, required this.emoji});
}

// ─── Deworming Tile ───────────────────────────────────────────────────────────
class _DewormingTile extends StatelessWidget {
  final DewormingRecord deworming;
  const _DewormingTile({required this.deworming});

  @override
  Widget build(BuildContext context) {
    final animal = getAnimalById(deworming.animalId);
    Color statusColor;
    String statusEmoji;
    String statusText;
    switch (deworming.status) {
      case DewormingStatus.overdue:
        statusColor = RumenoTheme.errorRed;
        statusEmoji = '🔴';
        statusText = 'OVERDUE';
        break;
      case DewormingStatus.due:
        statusColor = RumenoTheme.warningYellow;
        statusEmoji = '🟡';
        statusText = 'DUE';
        break;
      case DewormingStatus.done:
        statusColor = RumenoTheme.successGreen;
        statusEmoji = '🟢';
        statusText = 'DONE';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Text(statusEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.pest_control_rounded, color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deworming.medicineName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.pets_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(animal?.tagId ?? deworming.animalId, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    if (deworming.dose != null) ...[
                      const SizedBox(width: 8),
                      Text(deworming.dose!, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Breeding Tile ────────────────────────────────────────────────────────────
class _BreedingTile extends StatelessWidget {
  final BreedingRecord breeding;
  const _BreedingTile({required this.breeding});

  @override
  Widget build(BuildContext context) {
    final animal = getAnimalById(breeding.animalId);
    final isPregnant = breeding.isPregnant == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showBreedingDetail(context, breeding),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Text(isPregnant ? '🤰' : '🔄', style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isPregnant ? Colors.pink : Colors.grey).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.child_friendly_rounded, color: isPregnant ? Colors.pink : Colors.grey, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(animal?.tagId ?? breeding.animalId, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Row(children: [
                      Icon(breeding.aiDone ? Icons.science_rounded : Icons.favorite_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(breeding.aiDone ? 'AI Done' : 'Natural', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      if (isPregnant && breeding.expectedDelivery != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Due: ${breeding.expectedDelivery!.day}/${breeding.expectedDelivery!.month}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (isPregnant ? Colors.pink : Colors.grey).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isPregnant ? 'PREGNANT' : 'WAITING',
                    style: TextStyle(color: isPregnant ? Colors.pink : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBreedingDetail(BuildContext context, BreedingRecord record) {
    final animal = getAnimalById(record.animalId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('🤰 Breeding Details', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _infoRow(Icons.pets_rounded, 'Animal', animal?.tagId ?? record.animalId),
            _infoRow(Icons.calendar_today_rounded, 'Heat Date', '${record.heatDate.day}/${record.heatDate.month}/${record.heatDate.year}'),
            _infoRow(Icons.thermostat_rounded, 'Heat Intensity', record.intensity.name.capitalize()),
            _infoRow(Icons.science_rounded, 'Method', record.aiDone ? 'Artificial Insemination' : 'Natural Mating'),
            if (record.bullSemenId != null) _infoRow(Icons.qr_code_rounded, 'Bull/Semen ID', record.bullSemenId!),
            if (record.technicianName != null) _infoRow(Icons.person_rounded, 'Technician', record.technicianName!),
            _infoRow(Icons.pregnant_woman_rounded, 'Pregnant', record.isPregnant == true ? 'Yes ✅' : 'No ❌'),
            if (record.expectedDelivery != null) _infoRow(Icons.child_care_rounded, 'Expected Delivery', '${record.expectedDelivery!.day}/${record.expectedDelivery!.month}/${record.expectedDelivery!.year}'),
            if (record.notes != null) _infoRow(Icons.note_rounded, 'Notes', record.notes!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.pink.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.pink, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Lab Report Tile ──────────────────────────────────────────────────────────
class _LabReportTile extends StatelessWidget {
  final LabReport labReport;
  const _LabReportTile({required this.labReport});

  @override
  Widget build(BuildContext context) {
    final animal = getAnimalById(labReport.animalId);
    final isDone = labReport.status == LabReportStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showLabDetail(context, labReport),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Text(isDone ? '✅' : '⏳', style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDone ? RumenoTheme.successGreen : Colors.purple).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.science_rounded, color: isDone ? RumenoTheme.successGreen : Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(labReport.testName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.pets_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(animal?.tagId ?? labReport.animalId, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      Expanded(child: Text(labReport.labName ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[500]), overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (isDone ? RumenoTheme.successGreen : Colors.purple).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isDone ? 'DONE' : 'PENDING',
                    style: TextStyle(color: isDone ? RumenoTheme.successGreen : Colors.purple, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLabDetail(BuildContext context, LabReport report) {
    final animal = getAnimalById(report.animalId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('🔬 Lab Report', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _infoRow(Icons.pets_rounded, 'Animal', animal?.tagId ?? report.animalId),
            _infoRow(Icons.science_rounded, 'Test', report.testName),
            _infoRow(Icons.calendar_today_rounded, 'Test Date', '${report.testDate.day}/${report.testDate.month}/${report.testDate.year}'),
            if (report.labName != null) _infoRow(Icons.business_rounded, 'Lab', report.labName!),
            if (report.vetName != null) _infoRow(Icons.person_rounded, 'Vet', report.vetName!),
            _infoRow(Icons.check_circle_rounded, 'Status', report.status == LabReportStatus.completed ? 'Complete ✅' : 'Pending ⏳'),
            if (report.result != null) _infoRow(Icons.assignment_rounded, 'Result', report.result!),
            if (report.notes != null) _infoRow(Icons.note_rounded, 'Notes', report.notes!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.purple, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Full Animal Profile ──────────────────────────────────────────────────────
void _showFullAnimalProfile(BuildContext context, Animal animal) {
  final vaccinations = mockVaccinations.where((v) => v.animalId == animal.id).toList();
  final treatments = mockTreatments.where((t) => t.animalId == animal.id).toList();
  final dewormings = mockDewormingRecords.where((d) => d.animalId == animal.id).toList();
  final breeding = mockBreedingRecords.where((b) => b.animalId == animal.id).toList();
  final labs = mockLabReports.where((l) => l.animalId == animal.id).toList();
  final children = getChildrenOf(animal.id);
  final siblings = getSiblingsOf(animal);
  final father = animal.fatherId != null ? getAnimalById(animal.fatherId!) : null;
  final mother = animal.motherId != null ? getAnimalById(animal.motherId!) : null;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
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
            const SizedBox(height: 12),
            Center(child: Text(_speciesEmoji(animal.species), style: const TextStyle(fontSize: 56))),
            const SizedBox(height: 8),
            Center(child: Text(animal.tagId, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
            Center(child: Text('${animal.speciesName} · ${animal.breed}', style: TextStyle(color: Colors.grey[600], fontSize: 15))),
            const SizedBox(height: 20),

            // Basic Info
            _sectionHeader(Icons.info_rounded, 'Basic Info', RumenoTheme.primaryGreen),
            _profileRow('Age', animal.ageString),
            _profileRow('Gender', animal.gender.name.capitalize()),
            _profileRow('Status', animal.statusLabel),
            _profileRow('Purpose', animal.purpose.name.capitalize()),
            _profileRow('Weight', '${animal.weightKg.toStringAsFixed(1)} kg'),
            if (animal.heightCm != null) _profileRow('Height', '${animal.heightCm} cm'),
            if (animal.color != null) _profileRow('Color', animal.color!),
            if (animal.shedNumber != null) _profileRow('Shed', animal.shedNumber!),
            _profileRow('Farmer', animal.farmerId),

            // Family
            if (father != null || mother != null || children.isNotEmpty || siblings.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.family_restroom_rounded, 'Family', Colors.brown),
              if (father != null) _profileRow('Father', '${father.tagId} (${father.breed})'),
              if (mother != null) _profileRow('Mother', '${mother.tagId} (${mother.breed})'),
              if (children.isNotEmpty) _profileRow('Children', children.map((c) => c.tagId).join(', ')),
              if (siblings.isNotEmpty) _profileRow('Siblings', siblings.map((s) => s.tagId).join(', ')),
            ],

            // Vaccinations
            if (vaccinations.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.vaccines_rounded, 'Injections (${vaccinations.length})', RumenoTheme.primaryGreen),
              ...vaccinations.map((v) => _miniRecordRow(
                v.status == VaccinationStatus.done ? '🟢' : v.status == VaccinationStatus.overdue ? '🔴' : '🟡',
                v.vaccineName,
                '${v.dueDate.day}/${v.dueDate.month}/${v.dueDate.year}',
              )),
            ],

            // Treatments
            if (treatments.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.medical_services_rounded, 'Treatments (${treatments.length})', RumenoTheme.errorRed),
              ...treatments.map((t) => _miniRecordRow(
                t.status == TreatmentStatus.completed ? '✅' : '🔴',
                t.diagnosis,
                t.treatment,
              )),
            ],

            // Dewormings
            if (dewormings.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.pest_control_rounded, 'Deworming (${dewormings.length})', Colors.teal),
              ...dewormings.map((d) => _miniRecordRow(
                d.status == DewormingStatus.done ? '🟢' : d.status == DewormingStatus.overdue ? '🔴' : '🟡',
                d.medicineName,
                '${d.dueDate.day}/${d.dueDate.month}/${d.dueDate.year}',
              )),
            ],

            // Breeding
            if (breeding.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.child_friendly_rounded, 'Breeding (${breeding.length})', Colors.pink),
              ...breeding.map((b) => _miniRecordRow(
                b.isPregnant == true ? '🤰' : '🔄',
                b.aiDone ? 'AI Done' : 'Natural',
                b.isPregnant == true && b.expectedDelivery != null ? 'Due: ${b.expectedDelivery!.day}/${b.expectedDelivery!.month}/${b.expectedDelivery!.year}' : 'Heat: ${b.heatDate.day}/${b.heatDate.month}/${b.heatDate.year}',
              )),
            ],

            // Lab Reports
            if (labs.isNotEmpty) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.science_rounded, 'Lab Reports (${labs.length})', Colors.purple),
              ...labs.map((l) => _miniRecordRow(
                l.status == LabReportStatus.completed ? '✅' : '⏳',
                l.testName,
                l.result ?? 'Pending',
              )),
            ],

            // Mortality info
            if (animal.status == AnimalStatus.deceased) ...[
              const SizedBox(height: 16),
              _sectionHeader(Icons.warning_rounded, 'Mortality', Colors.grey),
              if (animal.mortalityDate != null) _profileRow('Date', '${animal.mortalityDate!.day}/${animal.mortalityDate!.month}/${animal.mortalityDate!.year}'),
              if (animal.mortalityReason != null) _profileRow('Cause', animal.mortalityReason!),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close_rounded, size: 22, color: Colors.white),
                label: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _sectionHeader(IconData icon, String title, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color)),
      ],
    ),
  );
}

Widget _profileRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 46),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90, child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500]))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}

Widget _miniRecordRow(String emoji, String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 46),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
      ],
    ),
  );
}

String _speciesEmoji(Species species) {
  const icons = {
    Species.cow: '🐄',
    Species.buffalo: '🐃',
    Species.goat: '🐐',
    Species.sheep: '🐑',
    Species.pig: '🐷',
    Species.horse: '🐴',
  };
  return icons[species] ?? '🐾';
}

extension _StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
