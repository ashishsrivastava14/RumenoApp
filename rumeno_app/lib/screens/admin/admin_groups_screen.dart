import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_farmers.dart';
import '../../models/models.dart';
import '../../providers/group_provider.dart';

class AdminGroupsScreen extends StatefulWidget {
  const AdminGroupsScreen({super.key});

  @override
  State<AdminGroupsScreen> createState() => _AdminGroupsScreenState();
}

class _AdminGroupsScreenState extends State<AdminGroupsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  Species? _speciesFilter;
  String? _selectedFarmerId;

  Farmer? get _selectedFarmer => _selectedFarmerId == null
      ? null
      : mockFarmers.firstWhere((f) => f.id == _selectedFarmerId,
          orElse: () => mockFarmers.first);

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
    final selectedFarmer = _selectedFarmer;
    final subtitle = selectedFarmer != null
        ? '${selectedFarmer.farmName}'
        : 'All farmer animal groups';

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00695C), Color(0xFF26A69A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('🐾', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Group Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text(subtitle,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // ── Farmer Filter Dropdown ──
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
                          dropdownColor: const Color(0xFF00695C),
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                          hint: const Row(
                            children: [
                              Icon(Icons.agriculture_rounded, color: Colors.white70, size: 20),
                              SizedBox(width: 8),
                              Text('All Farmers', style: TextStyle(color: Colors.white70, fontSize: 15)),
                            ],
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Row(
                                children: [
                                  Icon(Icons.select_all_rounded, color: Colors.white70, size: 20),
                                  SizedBox(width: 8),
                                  Text('All Farmers', style: TextStyle(color: Colors.white)),
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
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(
                    icon: Text('📋', style: TextStyle(fontSize: 16)),
                    text: 'Groups'),
                Tab(
                    icon: Text('🔔', style: TextStyle(fontSize: 16)),
                    text: 'Alerts'),
                Tab(
                    icon: Text('📊', style: TextStyle(fontSize: 16)),
                    text: 'Stats'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _GroupsListTab(
              speciesFilter: _speciesFilter,
              onFilterChanged: (s) => setState(() => _speciesFilter = s),
              farmerIdFilter: _selectedFarmerId,
            ),
            const _AlertsTab(),
            const _GroupStatsTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Groups List Tab ──────────────────────────────────────────────────────────
class _GroupsListTab extends StatelessWidget {
  final Species? speciesFilter;
  final ValueChanged<Species?> onFilterChanged;
  final String? farmerIdFilter;

  const _GroupsListTab(
      {required this.speciesFilter,
      required this.onFilterChanged,
      this.farmerIdFilter});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GroupProvider>();
    var groups = farmerIdFilter != null
        ? gp.groups.where((g) => g.farmerId == farmerIdFilter).toList()
        : gp.groups;
    if (speciesFilter != null) {
      groups = groups.where((g) => g.species == speciesFilter).toList();
    }

    // Group by farmer
    final byFarmer = <String, List<AnimalGroup>>{};
    for (final g in groups) {
      byFarmer.putIfAbsent(g.farmerId, () => []).add(g);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Species filter chips
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _SpeciesChip(
                label: 'All',
                emoji: '🐾',
                selected: speciesFilter == null,
                onTap: () => onFilterChanged(null),
              ),
              _SpeciesChip(
                label: 'Cow',
                emoji: '🐄',
                selected: speciesFilter == Species.cow,
                onTap: () => onFilterChanged(Species.cow),
              ),
              _SpeciesChip(
                label: 'Buffalo',
                emoji: '🐃',
                selected: speciesFilter == Species.buffalo,
                onTap: () => onFilterChanged(Species.buffalo),
              ),
              _SpeciesChip(
                label: 'Goat',
                emoji: '🐐',
                selected: speciesFilter == Species.goat,
                onTap: () => onFilterChanged(Species.goat),
              ),
              _SpeciesChip(
                label: 'Sheep',
                emoji: '🐑',
                selected: speciesFilter == Species.sheep,
                onTap: () => onFilterChanged(Species.sheep),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // KPIs
        Row(
          children: [
            _GroupKpi(
                emoji: '📋',
                label: 'Groups',
                value: '${groups.length}',
                color: const Color(0xFF00695C)),
            const SizedBox(width: 10),
            _GroupKpi(
                emoji: '🐾',
                label: 'Animals',
                value:
                    '${groups.fold<int>(0, (s, g) => s + g.animalIds.length)}',
                color: const Color(0xFF2E7D32)),
            const SizedBox(width: 10),
            _GroupKpi(
                emoji: '👨‍🌾',
                label: 'Farmers',
                value: '${byFarmer.keys.length}',
                color: const Color(0xFF1565C0)),
          ],
        ),
        const SizedBox(height: 16),

        // Groups by farmer
        if (groups.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('No groups found',
                      style: TextStyle(color: Colors.grey[500]))),
            ),
          )
        else
          ...byFarmer.entries.map((entry) {
            final farmer = mockFarmers
                .where((f) => f.id == entry.key)
                .firstOrNull;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Text('👨‍🌾', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(farmer?.name ?? entry.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      if (farmer != null) ...[
                        const SizedBox(width: 6),
                        Text('• ${farmer.farmName}',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600])),
                      ],
                    ],
                  ),
                ),
                ...entry.value.map((g) => _GroupCard(group: g)),
              ],
            );
          }),
      ],
    );
  }
}

class _SpeciesChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  const _SpeciesChip(
      {required this.label,
      required this.emoji,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00695C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: selected
                    ? const Color(0xFF00695C)
                    : Colors.grey[300]!),
          ),
          child: Text('$emoji $label',
              style: TextStyle(
                  color: selected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ),
      ),
    );
  }
}

class _GroupKpi extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _GroupKpi(
      {required this.emoji,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05)
          ]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: color.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final AnimalGroup group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final speciesEmoji = switch (group.species) {
      Species.cow => '🐄',
      Species.buffalo => '🐃',
      Species.goat => '🐐',
      Species.sheep => '🐑',
      Species.pig => '🐷',
      Species.horse => '🐴',
      null => '🐾',
    };
    // Look up a few animal names for preview
    final previewAnimals = group.animalIds.take(3).map((id) {
      final a = getAnimalById(id);
      return a?.tagId ?? id;
    }).join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(speciesEmoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(previewAnimals,
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00695C).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${group.animalIds.length} 🐾',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00695C),
                      fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Alerts Tab ───────────────────────────────────────────────────────────────
class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GroupProvider>();
    final alerts = gp.alerts;
    final now = DateTime.now();

    final overdue =
        alerts.where((a) => !a.isDone && a.dueDate.isBefore(now)).toList();
    final upcoming =
        alerts.where((a) => !a.isDone && !a.dueDate.isBefore(now)).toList();
    final completed = alerts.where((a) => a.isDone).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // KPIs
        Row(
          children: [
            _GroupKpi(
                emoji: '🔴',
                label: 'Overdue',
                value: '${overdue.length}',
                color: Colors.red),
            const SizedBox(width: 10),
            _GroupKpi(
                emoji: '🟡',
                label: 'Upcoming',
                value: '${upcoming.length}',
                color: Colors.orange),
            const SizedBox(width: 10),
            _GroupKpi(
                emoji: '✅',
                label: 'Done',
                value: '${completed.length}',
                color: Colors.green),
          ],
        ),
        const SizedBox(height: 16),

        if (overdue.isNotEmpty) ...[
          const Text('🔴 Overdue Alerts',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          const SizedBox(height: 8),
          ...overdue.map((a) => _AlertCard(alert: a, isOverdue: true)),
          const SizedBox(height: 16),
        ],

        if (upcoming.isNotEmpty) ...[
          const Text('🟡 Upcoming Alerts',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange)),
          const SizedBox(height: 8),
          ...upcoming.map((a) => _AlertCard(alert: a, isOverdue: false)),
          const SizedBox(height: 16),
        ],

        if (completed.isNotEmpty) ...[
          const Text('✅ Completed',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const SizedBox(height: 8),
          ...completed.map((a) => _AlertCard(alert: a, isOverdue: false)),
        ],

        if (alerts.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('No group alerts',
                      style: TextStyle(color: Colors.grey[500]))),
            ),
          ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final GroupAlert alert;
  final bool isOverdue;
  const _AlertCard({required this.alert, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    final gp = context.read<GroupProvider>();
    final group = gp.getGroupById(alert.groupId);
    final bgColor = alert.isDone
        ? Colors.green[50]
        : isOverdue
            ? Colors.red[50]
            : Colors.orange[50];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: bgColor,
      child: ListTile(
        leading:
            Text(alert.typeEmoji, style: const TextStyle(fontSize: 22)),
        title: Text(alert.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '${group?.name ?? alert.groupId} • Due: ${alert.dueDate.day}/${alert.dueDate.month}/${alert.dueDate.year}'),
        trailing: alert.isDone
            ? const Text('✅', style: TextStyle(fontSize: 18))
            : Icon(
                isOverdue ? Icons.warning_amber : Icons.schedule,
                color: isOverdue ? Colors.red : Colors.orange,
              ),
      ),
    );
  }
}

// ─── Stats Tab ────────────────────────────────────────────────────────────────
class _GroupStatsTab extends StatelessWidget {
  const _GroupStatsTab();

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GroupProvider>();
    final groups = gp.groups;

    // Species breakdown
    final speciesCounts = <Species, int>{};
    final speciesAnimalCounts = <Species, int>{};
    for (final g in groups) {
      if (g.species != null) {
        speciesCounts[g.species!] = (speciesCounts[g.species!] ?? 0) + 1;
        speciesAnimalCounts[g.species!] =
            (speciesAnimalCounts[g.species!] ?? 0) + g.animalIds.length;
      }
    }

    final mixedGroups = groups.where((g) => g.species == null).length;

    // Farmer breakdown
    final farmerGroupCounts = <String, int>{};
    for (final g in groups) {
      farmerGroupCounts[g.farmerId] =
          (farmerGroupCounts[g.farmerId] ?? 0) + 1;
    }

    // Size distribution
    final small = groups.where((g) => g.animalIds.length <= 3).length;
    final medium = groups
        .where((g) => g.animalIds.length > 3 && g.animalIds.length <= 10)
        .length;
    final large = groups.where((g) => g.animalIds.length > 10).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overview card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF26A69A)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📊 Group Overview',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                      value: '${groups.length}',
                      label: 'Total Groups',
                      emoji: '📋'),
                  _StatItem(
                      value:
                          '${groups.fold<int>(0, (s, g) => s + g.animalIds.length)}',
                      label: 'Animals',
                      emoji: '🐾'),
                  _StatItem(
                      value: '${farmerGroupCounts.keys.length}',
                      label: 'Farmers',
                      emoji: '👨‍🌾'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Species breakdown
        const Text('🐾 By Species',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...speciesCounts.entries.map((e) {
          final emoji = switch (e.key) {
            Species.cow => '🐄',
            Species.buffalo => '🐃',
            Species.goat => '🐐',
            Species.sheep => '🐑',
            Species.pig => '🐷',
            Species.horse => '🐴',
          };
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              leading: Text(emoji, style: const TextStyle(fontSize: 22)),
              title: Text(e.key.name[0].toUpperCase() + e.key.name.substring(1),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${speciesAnimalCounts[e.key]} animals across ${e.value} groups'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF00695C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${e.value}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00695C))),
              ),
            ),
          );
        }),
        if (mixedGroups > 0)
          Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              leading:
                  const Text('🐾', style: TextStyle(fontSize: 22)),
              title: const Text('Mixed Species',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('$mixedGroups groups'),
            ),
          ),

        const SizedBox(height: 20),

        // Size distribution
        const Text('📐 Group Sizes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            _GroupKpi(
                emoji: '🔹',
                label: 'Small (≤3)',
                value: '$small',
                color: Colors.blue),
            const SizedBox(width: 10),
            _GroupKpi(
                emoji: '🔸',
                label: 'Medium (4-10)',
                value: '$medium',
                color: Colors.orange),
            const SizedBox(width: 10),
            _GroupKpi(
                emoji: '🔶',
                label: 'Large (>10)',
                value: '$large',
                color: Colors.red),
          ],
        ),
        const SizedBox(height: 20),

        // Per-farmer breakdown
        const Text('👨‍🌾 By Farmer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...farmerGroupCounts.entries.map((entry) {
          final farmer = mockFarmers
              .where((f) => f.id == entry.key)
              .firstOrNull;
          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              leading:
                  const Text('👨‍🌾', style: TextStyle(fontSize: 22)),
              title: Text(farmer?.name ?? entry.key,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(farmer?.farmName ?? ''),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF1565C0).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${entry.value} groups',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                        fontSize: 12)),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _StatItem(
      {required this.value, required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }
}
