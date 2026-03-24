import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

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
    final group = provider.getGroupById(groupId);
    if (group == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Group')),
        body: const Center(child: Text('Group not found')),
      );
    }

    final animals = provider.getAnimalsInGroup(groupId);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoTooltip(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          // ── Group Info Header ──
          _buildInfoHeader(group, animals.length),
          const SizedBox(height: 20),

          // ── Animals Section ──
          _sectionHeader(
            context,
            '🐾  Animals (${animals.length})',
            actionLabel: 'Manage',
            onAction: () =>
                _showManageAnimalsSheet(context, provider, group),
          ),
          const SizedBox(height: 8),
          if (animals.isEmpty)
            _emptyCard(
                '🐾', 'No animals in this group', 'Tap "Manage" to add')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: animals
                  .map((a) => _animalChip(context, a, provider, group))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoHeader(AnimalGroup group, int animalCount) {
    final speciesLabel = group.species != null
        ? '${_speciesEmoji(group.species!)} ${group.species!.name[0].toUpperCase()}${group.species!.name.substring(1)}'
        : '🐾 Mixed Species';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.groups_rounded,
                  color: RumenoTheme.primaryGreen, size: 30),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 4),
                Text(speciesLabel,
                    style:
                        const TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                const SizedBox(height: 6),
                _statBadge(Icons.pets, '$animalCount animals',
                    RumenoTheme.primaryGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title,
      {String? actionLabel, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: RumenoTheme.textDark)),
        if (actionLabel != null)
          TextButton.icon(
            onPressed: onAction,
            icon: Icon(
              actionLabel == 'Add' ? Icons.add_circle_outline : Icons.edit,
              size: 18,
            ),
            label: Text(actionLabel),
            style: TextButton.styleFrom(
              foregroundColor: RumenoTheme.primaryGreen,
            ),
          ),
      ],
    );
  }

  Widget _animalChip(BuildContext context, Animal animal,
      GroupProvider provider, AnimalGroup group) {
    return Chip(
      avatar: Text(_speciesEmoji(animal.species),
          style: const TextStyle(fontSize: 16)),
      label: Text(animal.tagId,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () {
        provider.removeAnimalFromGroup(group.id, animal.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${animal.tagId} removed from group'),
            backgroundColor: RumenoTheme.successGreen,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () =>
                  provider.addAnimalsToGroup(group.id, [animal.id]),
            ),
          ),
        );
      },
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _emptyCard(String emoji, String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RumenoTheme.textLight.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
          const SizedBox(height: 4),
          Text(sub,
              style:
                  const TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }

  // ── Manage Animals Sheet ────────────────────────

  void _showManageAnimalsSheet(
      BuildContext context, GroupProvider provider, AnimalGroup group) {
    // Filter animals by species if the group is species-specific
    final availableAnimals = group.species != null
        ? mockAnimals
            .where((a) =>
                a.species == group.species &&
                a.status != AnimalStatus.deceased)
            .toList()
        : mockAnimals
            .where((a) => a.status != AnimalStatus.deceased)
            .toList();

    final selectedIds = Set<String>.from(group.animalIds);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Text('🐾', style: TextStyle(fontSize: 24)),
                              SizedBox(width: 10),
                              Text('Manage Animals',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text('${selectedIds.length} selected',
                              style: const TextStyle(
                                  color: RumenoTheme.primaryGreen,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Select All / Deselect All
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => setModalState(() {
                              selectedIds.addAll(
                                  availableAnimals.map((a) => a.id));
                            }),
                            child: const Text('Select All'),
                          ),
                          TextButton(
                            onPressed: () =>
                                setModalState(() => selectedIds.clear()),
                            child: const Text('Deselect All'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Animal list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: availableAnimals.length,
                    itemBuilder: (_, i) {
                      final animal = availableAnimals[i];
                      final isSelected = selectedIds.contains(animal.id);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (val) {
                          setModalState(() {
                            if (val == true) {
                              selectedIds.add(animal.id);
                            } else {
                              selectedIds.remove(animal.id);
                            }
                          });
                        },
                        secondary: Text(
                          _speciesEmoji(animal.species),
                          style: const TextStyle(fontSize: 22),
                        ),
                        title: Text(animal.tagId,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            '${animal.breed} · ${animal.weightKg} kg · ${animal.statusLabel}'),
                        activeColor: RumenoTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  ),
                ),
                // Save button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.setGroupAnimals(
                            group.id, selectedIds.toList());
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${selectedIds.length} animals updated in group'),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: Text('Save (${selectedIds.length} animals)',
                          style: const TextStyle(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInfoTooltip(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('ℹ️', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text('About Groups'),
          ],
        ),
        content: const Text(
          'Animals can belong to multiple groups. '
          'Removing a group does not delete animals. '
          'Use the "Manage" button to add or remove animals from this group.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
