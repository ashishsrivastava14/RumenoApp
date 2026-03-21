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
            expandedHeight: 150,
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
                        const Text('🐄', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Farm Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text('All Farms & Animals',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
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
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(icon: Text('🐾', style: TextStyle(fontSize: 18)), text: 'Animals'),
                Tab(icon: Text('💊', style: TextStyle(fontSize: 18)), text: 'Health'),
                Tab(icon: Text('📊', style: TextStyle(fontSize: 18)), text: 'Stats'),
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

    // Species counts
    final speciesCounts = <Species, int>{};
    for (final a in mockAnimals) {
      speciesCounts[a.species] = (speciesCounts[a.species] ?? 0) + 1;
    }

    return Column(
      children: [
        // Species cards
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            children: Species.values.map((s) {
              final count = speciesCounts[s] ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return _SpeciesCard(
                species: s,
                count: count,
                selected: _speciesFilter == s,
                onTap: () => setState(() =>
                    _speciesFilter = _speciesFilter == s ? null : s),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by tag ID or breed...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filtered.length} animal${filtered.length == 1 ? '' : 's'}',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500),
              ),
              TextButton.icon(
                onPressed: () => _showAddAnimalDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Animal',
                    style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                    foregroundColor: RumenoTheme.primaryGreen,
                    visualDensity: VisualDensity.compact),
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
        title: const Row(
          children: [
            Icon(Icons.pets_rounded, color: Color(0xFF5B7A2E)),
            SizedBox(width: 8),
            Text('Add Animal'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: tagCtrl,
                decoration: const InputDecoration(
                    labelText: 'Tag ID', prefixIcon: Icon(Icons.tag))),
            const SizedBox(height: 10),
            const Text('Full form available in farmer app',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: RumenoTheme.primaryGreen),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Animal ${tagCtrl.text} added successfully!')));
            },
            child: const Text('Add'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? RumenoTheme.primaryGreen
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected
                  ? RumenoTheme.primaryGreen
                  : Colors.grey.shade200,
              width: selected ? 2 : 1),
          boxShadow: [
            if (selected)
              BoxShadow(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            else
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Text(_icons[species] ?? '🐾',
                style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(species.name.capitalize(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: selected ? Colors.white : Colors.black87)),
                Text('$count',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white70
                            : Colors.grey[500])),
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
      case AnimalStatus.active:
        return RumenoTheme.successGreen;
      case AnimalStatus.pregnant:
        return Colors.pink;
      case AnimalStatus.sick:
      case AnimalStatus.underTreatment:
        return RumenoTheme.errorRed;
      case AnimalStatus.quarantine:
        return Colors.orange;
      case AnimalStatus.dry:
        return Colors.blueGrey;
      case AnimalStatus.deceased:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _SpeciesCard._icons[animal.species] ?? '🐾',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(animal.tagId,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(animal.statusLabel,
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Text('${animal.breed} · ${animal.ageString}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                    Text(
                      'Farmer ID: ${animal.farmerId} · ${animal.weightKg.toStringAsFixed(0)} kg',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: Colors.grey, size: 20),
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
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (ctx, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: sc,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(_SpeciesCard._icons[animal.species] ?? '🐾',
                    style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(animal.tagId,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${animal.speciesName} · ${animal.breed}',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            _detailRow('Age', animal.ageString),
            _detailRow('Gender', animal.gender.name.capitalize()),
            _detailRow('Status', animal.statusLabel),
            _detailRow('Purpose', animal.purpose.name.capitalize()),
            _detailRow(
                'Weight', '${animal.weightKg.toStringAsFixed(1)} kg'),
            _detailRow('Farmer', animal.farmerId),
            if (animal.shedNumber != null)
              _detailRow('Shed', animal.shedNumber!),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Opening full profile for ${animal.tagId}')));
                    },
                    icon: const Icon(Icons.open_in_full_rounded),
                    label: const Text('Full Profile'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.primaryGreen),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(
                width: 90,
                child: Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600))),
          ],
        ),
      );
}

// ─── Health Tab ───────────────────────────────────────────────────────────────
class _HealthTab extends StatelessWidget {
  const _HealthTab();

  @override
  Widget build(BuildContext context) {
    final overdueVax =
        mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).toList();
    final dueVax =
        mockVaccinations.where((v) => v.status == VaccinationStatus.due).toList();
    final activeTreatments =
        mockTreatments.where((t) => t.endDate == null || t.endDate!.isAfter(DateTime.now())).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alert cards
          if (overdueVax.isNotEmpty)
            _AlertCard(
              icon: Icons.warning_rounded,
              color: RumenoTheme.errorRed,
              title: '${overdueVax.length} Overdue Vaccination${overdueVax.length > 1 ? 's' : ''}',
              subtitle: 'Immediate attention required',
              onTap: () {},
            ),
          if (dueVax.isNotEmpty)
            _AlertCard(
              icon: Icons.notifications_active_rounded,
              color: RumenoTheme.warningYellow,
              title: '${dueVax.length} Vaccination${dueVax.length > 1 ? 's' : ''} Due Soon',
              subtitle: 'Schedule within the week',
              onTap: () {},
            ),
          if (activeTreatments.isNotEmpty)
            _AlertCard(
              icon: Icons.medical_services_rounded,
              color: RumenoTheme.infoBlue,
              title: '${activeTreatments.length} Active Treatment${activeTreatments.length > 1 ? 's' : ''}',
              subtitle: 'Animals currently under care',
              onTap: () {},
            ),
          const SizedBox(height: 16),
          // Quick actions
          Text('⚡ Quick Actions',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 10),
          Row(
            children: [
              _QuickActionCard(
                icon: Icons.vaccines_rounded,
                color: RumenoTheme.primaryGreen,
                label: 'Health Config',
                onTap: () => context.push('/admin/farm/health-config'),
              ),
              const SizedBox(width: 10),
              _QuickActionCard(
                icon: Icons.pest_control_rounded,
                color: Colors.teal,
                label: 'Dewormings',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Deworming records coming soon')));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Vaccinations list
          Text('💉 Vaccination Records (${mockVaccinations.length})',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 10),
          ...mockVaccinations
              .take(8)
              .map((v) => _VaccinationTile(vaccination: v)),
          if (mockVaccinations.length > 8)
            TextButton(
              onPressed: () {},
              child: Text(
                  'View all ${mockVaccinations.length} records',
                  style: TextStyle(color: RumenoTheme.primaryGreen)),
            ),
          const SizedBox(height: 16),
          // Treatments list
          Text('🏥 Treatment Records (${mockTreatments.length})',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 10),
          ...mockTreatments
              .take(6)
              .map((t) => _TreatmentTile(treatment: t)),
          if (mockTreatments.length > 6)
            TextButton(
              onPressed: () {},
              child: Text(
                  'View all ${mockTreatments.length} records',
                  style: TextStyle(color: RumenoTheme.primaryGreen)),
            ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AlertCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: color)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: color, size: 14),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
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

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (vaccination.status) {
      case VaccinationStatus.overdue:
        statusColor = RumenoTheme.errorRed;
        break;
      case VaccinationStatus.due:
        statusColor = RumenoTheme.warningYellow;
        break;
      case VaccinationStatus.done:
        statusColor = RumenoTheme.successGreen;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.vaccines_rounded,
                  color: statusColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vaccination.vaccineName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(
                    'Animal: ${vaccination.animalId} · Due: ${_formatDate(vaccination.dueDate)}',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                vaccination.status.name,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
}

class _TreatmentTile extends StatelessWidget {
  final TreatmentRecord treatment;
  const _TreatmentTile({required this.treatment});

  @override
  Widget build(BuildContext context) {
    final isActive =
        treatment.endDate == null || treatment.endDate!.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (isActive ? RumenoTheme.errorRed : Colors.grey)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.medical_services_rounded,
                  color: isActive ? RumenoTheme.errorRed : Colors.grey,
                  size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(treatment.treatment,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(
                    'Animal: ${treatment.animalId} · ${treatment.diagnosis}',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: (isActive ? RumenoTheme.errorRed : Colors.grey)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isActive ? 'Active' : 'Completed',
                style: TextStyle(
                    color: isActive ? RumenoTheme.errorRed : Colors.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
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
    final active = mockAnimals
        .where((a) => a.status == AnimalStatus.active)
        .length;
    final pregnant = mockAnimals
        .where((a) => a.status == AnimalStatus.pregnant)
        .length;
    final sick = mockAnimals
        .where((a) =>
            a.status == AnimalStatus.sick ||
            a.status == AnimalStatus.underTreatment)
        .length;

    // Purpose breakdown
    final purposeCounts = <AnimalPurpose, int>{};
    for (final a in mockAnimals) {
      purposeCounts[a.purpose] = (purposeCounts[a.purpose] ?? 0) + 1;
    }

    // Farm distribution (animals per farmer)
    final farmerCounts = <String, int>{};
    for (final a in mockAnimals) {
      farmerCounts[a.farmerId] = (farmerCounts[a.farmerId] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _KpiCard(
                  label: 'Total Animals',
                  value: '$total',
                  icon: Icons.pets_rounded,
                  color: RumenoTheme.primaryGreen),
              _KpiCard(
                  label: 'Healthy',
                  value: '$active',
                  icon: Icons.check_circle_rounded,
                  color: RumenoTheme.successGreen),
              _KpiCard(
                  label: 'Pregnant',
                  value: '$pregnant',
                  icon: Icons.pregnant_woman_rounded,
                  color: Colors.pink),
              _KpiCard(
                  label: 'Sick / In Treatment',
                  value: '$sick',
                  icon: Icons.sick_rounded,
                  color: RumenoTheme.errorRed),
            ],
          ),
          const SizedBox(height: 20),
          Text('Purpose Breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...AnimalPurpose.values.map((purpose) {
            final count = purposeCounts[purpose] ?? 0;
            if (count == 0) return const SizedBox.shrink();
            return _ProgressRow(
              label: purpose.name.capitalize(),
              count: count,
              total: total,
              color: _purposeColor(purpose),
            );
          }),
          const SizedBox(height: 20),
          Text('Farm Distribution (${mockFarmers.length} farms)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...mockFarmers.take(6).map((farmer) {
            final count = farmerCounts[farmer.id] ?? 0;
            return _FarmDistributionRow(
              name: farmer.name,
              animalCount: count,
              maxCount: farmerCounts.values.fold(0, (a, b) => a > b ? a : b),
            );
          }),
        ],
      ),
    );
  }

  Color _purposeColor(AnimalPurpose p) {
    switch (p) {
      case AnimalPurpose.dairy:
        return RumenoTheme.infoBlue;
      case AnimalPurpose.meat:
        return Colors.orange;
      case AnimalPurpose.breeding:
        return Colors.purple;
      case AnimalPurpose.mixed:
        return Colors.teal;
    }
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(label,
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13)),
              Text('$count (${(pct * 100).toStringAsFixed(0)}%)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
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

  const _FarmDistributionRow({
    required this.name,
    required this.animalCount,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  RumenoTheme.primaryGreen.withValues(alpha: 0.1),
              child: Text(
                name[0],
                style: TextStyle(
                    color: RumenoTheme.primaryGreen,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: maxCount > 0 ? animalCount / maxCount : 0,
                      backgroundColor:
                          RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation(
                          RumenoTheme.primaryGreen),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('$animalCount',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
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
