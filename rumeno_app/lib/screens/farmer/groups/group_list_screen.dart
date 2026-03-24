import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/common/marketplace_button.dart';
import 'group_detail_screen.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  Species? _selectedSpecies;

  String _speciesEmoji(Species s) {
    switch (s) {
      case Species.cow:
        return '🐄';
      case Species.buffalo:
        return '🐃';
      case Species.goat:
        return '🐐';
      case Species.sheep:
        return '🐑';
      case Species.pig:
        return '🐷';
      case Species.horse:
        return '🐴';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final groups = _selectedSpecies != null
        ? provider.groups
            .where((g) =>
                g.species == _selectedSpecies || g.species == null)
            .toList()
        : provider.groups;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Animal Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip:
                'Animals can belong to multiple groups.\nRemoving a group does not delete animals.',
            onPressed: () => _showGroupInfoDialog(context),
          ),
          const VeterinarianButton(),
          const MarketplaceButton(),
        ],
      ),
      body: Column(
        children: [
          // ── Species Filter Chips ──
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _filterChip(null, '🐾', 'All'),
                ...Species.values.map(
                  (s) => _filterChip(s, _speciesEmoji(s), s.name[0].toUpperCase() + s.name.substring(1)),
                ),
              ],
            ),
          ),
          // ── Group List ──
          Expanded(
            child: groups.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                    itemCount: groups.length,
                    itemBuilder: (_, i) =>
                        _buildGroupCard(context, groups[i], provider),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context, provider),
        backgroundColor: RumenoTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Group',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _filterChip(Species? species, String emoji, String label) {
    final selected = _selectedSpecies == species;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        label: Text('$emoji $label'),
        onSelected: (_) => setState(() =>
            _selectedSpecies = selected ? null : species),
        selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
        checkmarkColor: RumenoTheme.primaryGreen,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
        ),
      ),
    );
  }

  Widget _buildGroupCard(
      BuildContext context, AnimalGroup group, GroupProvider provider) {
    final animalCount = group.animalIds.length;
    final alertCount = provider.getAlertsForGroup(group.id).length;
    final speciesLabel = group.species != null
        ? '${_speciesEmoji(group.species!)} ${group.species!.name[0].toUpperCase()}${group.species!.name.substring(1)}'
        : '🐾 Mixed';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GroupDetailScreen(groupId: group.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(Icons.groups_rounded,
                      color: RumenoTheme.primaryGreen, size: 26),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: RumenoTheme.textDark)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(speciesLabel,
                            style: const TextStyle(
                                fontSize: 12, color: RumenoTheme.textGrey)),
                        const SizedBox(width: 12),
                        const Icon(Icons.pets, size: 13, color: RumenoTheme.textGrey),
                        const SizedBox(width: 3),
                        Text('$animalCount',
                            style: const TextStyle(
                                fontSize: 12, color: RumenoTheme.textGrey)),
                        if (alertCount > 0) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.notifications_active,
                              size: 13, color: RumenoTheme.warningYellow),
                          const SizedBox(width: 3),
                          Text('$alertCount',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: RumenoTheme.warningYellow)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: RumenoTheme.textGrey),
                onSelected: (val) {
                  if (val == 'edit') {
                    _showEditGroupDialog(context, provider, group);
                  } else if (val == 'delete') {
                    _showDeleteConfirmation(context, provider, group);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('✏️  Rename')),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Text('🗑️  Delete Group',
                          style: TextStyle(color: RumenoTheme.errorRed))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Dialogs ─────────────────────────────────────

  void _showGroupInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('ℹ️', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text('About Groups'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Animals can belong to multiple groups.',
                style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('• Removing a group does NOT delete the animals.',
                style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('• Use groups to organize vaccinations, checkups, and other activities.',
                style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('• You can set reminders/alerts for entire groups.',
                style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, GroupProvider provider) {
    final nameCtrl = TextEditingController();
    Species? species;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('📂', style: TextStyle(fontSize: 26)),
                  SizedBox(width: 10),
                  Text('Create New Group',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Group name (e.g., "Dairy Cows")',
                  filled: true,
                  fillColor: RumenoTheme.backgroundCream,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: RumenoTheme.textLight)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: RumenoTheme.textLight)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: RumenoTheme.primaryGreen, width: 2)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Category (optional)',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: RumenoTheme.textDark)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _speciesChoiceChip(null, '🐾 Mixed', species == null,
                      () => setModalState(() => species = null)),
                  ...Species.values.map((s) => _speciesChoiceChip(
                      s,
                      '${_speciesEmoji(s)} ${s.name[0].toUpperCase()}${s.name.substring(1)}',
                      species == s,
                      () => setModalState(() => species = s))),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a group name'),
                            backgroundColor: RumenoTheme.errorRed),
                      );
                      return;
                    }
                    final group = AnimalGroup(
                      id: 'GRP_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      species: species,
                      animalIds: [],
                      farmerId: 'F001',
                      createdAt: DateTime.now(),
                    );
                    provider.addGroup(group);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Group "$name" created!'),
                        ]),
                        backgroundColor: RumenoTheme.successGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Create Group',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _speciesChoiceChip(
      Species? species, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? RumenoTheme.primaryGreen.withValues(alpha: 0.15)
              : RumenoTheme.backgroundCream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? RumenoTheme.primaryGreen : RumenoTheme.textLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color:
                  selected ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
              fontSize: 13,
            )),
      ),
    );
  }

  void _showEditGroupDialog(
      BuildContext context, GroupProvider provider, AnimalGroup group) {
    final nameCtrl = TextEditingController(text: group.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Rename Group'),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'New group name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              provider.updateGroupName(group.id, name);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Group renamed to "$name"'),
                  backgroundColor: RumenoTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, GroupProvider provider, AnimalGroup group) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Group?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${group.name}"?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RumenoTheme.infoBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: RumenoTheme.infoBlue.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Text('ℹ️', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This will NOT delete any animal data. Animals will remain in your records.',
                      style: TextStyle(
                          fontSize: 12, color: RumenoTheme.infoBlue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteGroup(group.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Group "${group.name}" deleted'),
                  backgroundColor: RumenoTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📂', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('No groups yet',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: RumenoTheme.textDark)),
            const SizedBox(height: 8),
            const Text('Create groups to organize your animals',
                style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14),
                textAlign: TextAlign.center),
          ],
        ),
      );
}
