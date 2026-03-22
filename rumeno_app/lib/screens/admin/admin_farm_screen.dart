import 'package:flutter/material.dart';
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
            expandedHeight: 240,
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
  const _HealthTab();

  @override
  State<_HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends State<_HealthTab> {
  bool _showAllVax = false;
  bool _showAllTreatments = false;
  bool _showAllDeworming = false;
  bool _showAllBreeding = false;
  bool _showAllLab = false;

  @override
  Widget build(BuildContext context) {
    final overdueVax = mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).toList();
    final dueVax = mockVaccinations.where((v) => v.status == VaccinationStatus.due).toList();
    final activeTreatments = mockTreatments.where((t) => t.endDate == null || t.endDate!.isAfter(DateTime.now())).toList();
    final overdueDeworm = mockDewormingRecords.where((d) => d.status == DewormingStatus.overdue).toList();
    final pregnantAnimals = mockBreedingRecords.where((b) => b.isPregnant == true).toList();
    final pendingLabs = mockLabReports.where((l) => l.status == LabReportStatus.pending).toList();

    final vaxToShow = _showAllVax ? mockVaccinations : mockVaccinations.take(5).toList();
    final treatToShow = _showAllTreatments ? mockTreatments : mockTreatments.take(4).toList();
    final dewormToShow = _showAllDeworming ? mockDewormingRecords : mockDewormingRecords.take(4).toList();
    final breedToShow = _showAllBreeding ? mockBreedingRecords : mockBreedingRecords.take(4).toList();
    final labToShow = _showAllLab ? mockLabReports : mockLabReports.take(4).toList();

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
            Text('Injections (${mockVaccinations.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...vaxToShow.map((v) => _VaccinationTile(vaccination: v)),
          if (mockVaccinations.length > 5)
            _ShowMoreButton(
              expanded: _showAllVax,
              total: mockVaccinations.length,
              onTap: () => setState(() => _showAllVax = !_showAllVax),
            ),
          const SizedBox(height: 20),

          // ─── Treatment Records ───
          Row(children: [
            const Icon(Icons.medical_services_rounded, size: 22, color: RumenoTheme.errorRed),
            const SizedBox(width: 8),
            Text('Treatments (${mockTreatments.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...treatToShow.map((t) => _TreatmentTile(treatment: t)),
          if (mockTreatments.length > 4)
            _ShowMoreButton(
              expanded: _showAllTreatments,
              total: mockTreatments.length,
              onTap: () => setState(() => _showAllTreatments = !_showAllTreatments),
            ),
          const SizedBox(height: 20),

          // ─── Deworming Records ───
          Row(children: [
            const Icon(Icons.pest_control_rounded, size: 22, color: Colors.teal),
            const SizedBox(width: 8),
            Text('Deworming (${mockDewormingRecords.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...dewormToShow.map((d) => _DewormingTile(deworming: d)),
          if (mockDewormingRecords.length > 4)
            _ShowMoreButton(
              expanded: _showAllDeworming,
              total: mockDewormingRecords.length,
              onTap: () => setState(() => _showAllDeworming = !_showAllDeworming),
            ),
          const SizedBox(height: 20),

          // ─── Breeding Records ───
          Row(children: [
            const Icon(Icons.child_friendly_rounded, size: 22, color: Colors.pink),
            const SizedBox(width: 8),
            Text('Breeding (${mockBreedingRecords.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...breedToShow.map((b) => _BreedingTile(breeding: b)),
          if (mockBreedingRecords.length > 4)
            _ShowMoreButton(
              expanded: _showAllBreeding,
              total: mockBreedingRecords.length,
              onTap: () => setState(() => _showAllBreeding = !_showAllBreeding),
            ),
          const SizedBox(height: 20),

          // ─── Lab Reports ───
          Row(children: [
            const Icon(Icons.science_rounded, size: 22, color: Colors.purple),
            const SizedBox(width: 8),
            Text('Lab Reports (${mockLabReports.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          ...labToShow.map((l) => _LabReportTile(labReport: l)),
          if (mockLabReports.length > 4)
            _ShowMoreButton(
              expanded: _showAllLab,
              total: mockLabReports.length,
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

// ─── Stats Tab ────────────────────────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    final total = mockAnimals.length;
    final active = mockAnimals.where((a) => a.status == AnimalStatus.active).length;
    final pregnant = mockAnimals.where((a) => a.status == AnimalStatus.pregnant).length;
    final sick = mockAnimals.where((a) => a.status == AnimalStatus.sick || a.status == AnimalStatus.underTreatment).length;
    final deceased = mockAnimals.where((a) => a.status == AnimalStatus.deceased).length;
    final overdueVax = mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).length;
    final overdueDeworm = mockDewormingRecords.where((d) => d.status == DewormingStatus.overdue).length;
    final pendingLabs = mockLabReports.where((l) => l.status == LabReportStatus.pending).length;

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
              _KpiCard(emoji: '🕊️', label: 'Deceased', value: '$deceased', color: Colors.grey),
              _KpiCard(emoji: '🚨', label: 'Overdue Tasks', value: '${overdueVax + overdueDeworm}', color: Colors.orange),
            ],
          ),
          const SizedBox(height: 24),

          // Health summary
          const Text('Health Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _ProgressRow(emoji: '💉', label: 'Overdue Injections', count: overdueVax, total: mockVaccinations.length, color: RumenoTheme.errorRed),
          _ProgressRow(emoji: '🐛', label: 'Overdue Deworming', count: overdueDeworm, total: mockDewormingRecords.length, color: Colors.orange),
          _ProgressRow(emoji: '🔬', label: 'Pending Lab Reports', count: pendingLabs, total: mockLabReports.length, color: Colors.purple),
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
