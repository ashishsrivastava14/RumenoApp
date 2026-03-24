import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/common/marketplace_button.dart';

class DewormingScreen extends StatefulWidget {
  const DewormingScreen({super.key});

  @override
  State<DewormingScreen> createState() => _DewormingScreenState();
}

class _DewormingScreenState extends State<DewormingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DewormingRecord> _records;

  // ── Group / Category Filters ──
  Species? _selectedCategory;
  String? _selectedGroupId;

  List<DewormingRecord> get _filteredRecords {
    var list = _records;
    if (_selectedGroupId != null) {
      final provider = context.read<GroupProvider>();
      final group = provider.getGroupById(_selectedGroupId!);
      if (group != null) {
        list = list.where((r) => group.animalIds.contains(r.animalId)).toList();
      }
    } else if (_selectedCategory != null) {
      final animalIds = mockAnimals
          .where((a) => a.species == _selectedCategory)
          .map((a) => a.id)
          .toSet();
      list = list.where((r) => animalIds.contains(r.animalId)).toList();
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _records = List.from(mockDewormingRecords);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Add Deworming Dialog ─────────────────────
  void _showAddDewormingDialog(BuildContext context) {
    Animal? selectedAnimal;
    final vetNameCtrl = TextEditingController();
    final doseCtrl = TextEditingController();
    final bodyWeightCtrl = TextEditingController();
    final medicineBrandCtrl = TextEditingController();
    final medicineSaltCtrl = TextEditingController();
    final List<Map<String, String>> medicines = [];
    DateTime selDate = DateTime.now();
    // dateMode: 'today' | 'past' | 'future'
    String dateMode = 'today';

    // Group-based state
    final groupProvider = context.read<GroupProvider>();
    String applyMode = 'single'; // 'single' or 'group'
    String? selectedGroupIdInDialog;
    Set<String> selectedAnimalIdsInGroup = {};
    bool applyToEntireGroup = true;

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
            20,
            12,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text('🪱', style: TextStyle(fontSize: 26)),
                    SizedBox(width: 10),
                    Text(
                      'Add Deworming Record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ── Single / Group Mode Toggle ──
                const Text('Apply To',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() {
                          applyMode = 'single';
                          selectedGroupIdInDialog = null;
                          selectedAnimalIdsInGroup.clear();
                        }),
                        child: _toggleTile('🐄', 'Single Animal',
                            applyMode == 'single',
                            RumenoTheme.accentOlive),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() {
                          applyMode = 'group';
                          selectedAnimal = null;
                        }),
                        child: _toggleTile('👥', 'Group',
                            applyMode == 'group',
                            RumenoTheme.infoBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ── Group-based selection ──
                if (applyMode == 'group') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedGroupIdInDialog != null
                            ? RumenoTheme.accentOlive
                            : RumenoTheme.textLight,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: selectedGroupIdInDialog,
                        hint: const Text('📂 Select Group'),
                        isExpanded: true,
                        items: groupProvider.groups
                            .map((g) => DropdownMenuItem<String?>(
                                  value: g.id,
                                  child: Text(
                                    '${g.name} (${g.animalIds.length} animals)',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setModalState(() {
                            selectedGroupIdInDialog = val;
                            applyToEntireGroup = true;
                            if (val != null) {
                              final group = groupProvider.getGroupById(val);
                              selectedAnimalIdsInGroup =
                                  Set<String>.from(group?.animalIds ?? []);
                            } else {
                              selectedAnimalIdsInGroup.clear();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  if (selectedGroupIdInDialog != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(() {
                              applyToEntireGroup = true;
                              final group = groupProvider
                                  .getGroupById(selectedGroupIdInDialog!);
                              selectedAnimalIdsInGroup =
                                  Set<String>.from(group?.animalIds ?? []);
                            }),
                            child: _toggleTile('✅', 'Entire Group',
                                applyToEntireGroup,
                                RumenoTheme.successGreen),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(
                                () => applyToEntireGroup = false),
                            child: _toggleTile('☑️', 'Select Animals',
                                !applyToEntireGroup,
                                RumenoTheme.warningYellow),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Builder(builder: (bCtx) {
                      final groupAnimals = groupProvider
                          .getAnimalsInGroup(selectedGroupIdInDialog!);
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: groupAnimals.map((a) {
                          final isSelected =
                              selectedAnimalIdsInGroup.contains(a.id);
                          return GestureDetector(
                            onTap: applyToEntireGroup
                                ? null
                                : () => setModalState(() {
                                      if (isSelected) {
                                        selectedAnimalIdsInGroup.remove(a.id);
                                      } else {
                                        selectedAnimalIdsInGroup.add(a.id);
                                      }
                                    }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? RumenoTheme.accentOlive.withValues(alpha: 0.15)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? RumenoTheme.accentOlive
                                      : RumenoTheme.textLight,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Icon(Icons.check_circle,
                                        size: 14, color: RumenoTheme.accentOlive),
                                  if (isSelected) const SizedBox(width: 4),
                                  Text(
                                    '${_animalEmoji(a.species)} ${a.tagId}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? RumenoTheme.accentOlive
                                          : RumenoTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 4),
                    Text(
                      '${selectedAnimalIdsInGroup.length} animal(s) selected',
                      style: const TextStyle(
                          fontSize: 12,
                          color: RumenoTheme.accentOlive,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
                // ── Single animal picker (only in single mode) ──
                if (applyMode == 'single') ...[
                _stepHeader('1', 'Select Animal'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final searchCtrl = TextEditingController();
                    Animal? picked;
                    await showDialog<Animal>(
                      context: ctx,
                      builder: (dCtx) => StatefulBuilder(
                        builder: (dCtx, setDialogState) {
                          final query = searchCtrl.text.toLowerCase();
                          final filtered = mockAnimals.where((a) {
                            return a.tagId.toLowerCase().contains(query) ||
                                a.breed.toLowerCase().contains(query) ||
                                a.species.name.toLowerCase().contains(query);
                          }).toList();
                          return AlertDialog(
                            title: const Text('Select Animal'),
                            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 400,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: searchCtrl,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: 'Search by tag, breed or species…',
                                      prefixIcon: const Icon(Icons.search),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (_) => setDialogState(() {}),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: filtered.isEmpty
                                        ? const Center(
                                            child: Text('No animals found'),
                                          )
                                        : ListView.separated(
                                            itemCount: filtered.length,
                                            separatorBuilder: (_, _) =>
                                                const Divider(height: 1),
                                            itemBuilder: (_, i) {
                                              final a = filtered[i];
                                              final speciesEmoji = {
                                                Species.cow: '🐄',
                                                Species.buffalo: '🐃',
                                                Species.goat: '🐐',
                                                Species.sheep: '🐑',
                                                Species.pig: '🐷',
                                                Species.horse: '🐴',
                                              }[a.species] ?? '🐾';
                                              return ListTile(
                                                dense: true,
                                                leading: Text(
                                                  speciesEmoji,
                                                  style: const TextStyle(
                                                    fontSize: 22),
                                                ),
                                                title: Text(
                                                  a.tagId,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600),
                                                ),
                                                subtitle: Text(
                                                  '${a.breed} · ${a.weightKg} kg',
                                                ),
                                                onTap: () {
                                                  picked = a;
                                                  Navigator.pop(dCtx);
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dCtx),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                    if (picked != null) {
                      setModalState(() {
                        selectedAnimal = picked;
                        bodyWeightCtrl.text =
                            picked!.weightKg.toStringAsFixed(1);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedAnimal != null
                            ? RumenoTheme.accentOlive
                            : Colors.grey.shade300,
                        width: selectedAnimal != null ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: selectedAnimal != null
                          ? RumenoTheme.accentOlive.withOpacity(0.06)
                          : Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedAnimal != null
                              ? {
                                  Species.cow: '🐄',
                                  Species.buffalo: '🐃',
                                  Species.goat: '🐐',
                                  Species.sheep: '🐑',
                                  Species.pig: '🐷',
                                  Species.horse: '🐴',
                                }[selectedAnimal!.species] ?? '🐾'
                              : '🐄',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: selectedAnimal != null
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedAnimal!.tagId,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${selectedAnimal!.breed} · ${selectedAnimal!.weightKg} kg',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Tap to select animal',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
                ],
                const SizedBox(height: 14),
                _stepHeader(applyMode == 'single' ? '2' : '1', 'Add Medicine Name'),
                const SizedBox(height: 8),
                _dialogField(
                  medicineBrandCtrl,
                  '🏷️  Medicine brand name',
                  TextInputType.text,
                ),
                const SizedBox(height: 10),
                _dialogField(
                  medicineSaltCtrl,
                  '🧪  Medicine salt name',
                  TextInputType.text,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final brand = medicineBrandCtrl.text.trim();
                      final salt = medicineSaltCtrl.text.trim();
                      if (brand.isEmpty && salt.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Enter brand or salt name to add medicine',
                            ),
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }
                      setModalState(() {
                        medicines.add({'brand': brand, 'salt': salt});
                        medicineBrandCtrl.clear();
                        medicineSaltCtrl.clear();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Medicine'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RumenoTheme.accentOlive,
                      side: const BorderSide(color: RumenoTheme.accentOlive),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (medicines.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: medicines.asMap().entries.map((entry) {
                      final i = entry.key;
                      final med = entry.value;
                      final brand = med['brand'] ?? '';
                      final salt = med['salt'] ?? '';
                      final label = brand.isNotEmpty && salt.isNotEmpty
                          ? '$brand ($salt)'
                          : brand.isNotEmpty
                          ? brand
                          : salt;
                      return Chip(
                        label: Text(label),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () =>
                            setModalState(() => medicines.removeAt(i)),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 14),
                _stepHeader(applyMode == 'single' ? '3' : '2', 'Dose and Body Weight'),
                const SizedBox(height: 8),
                _dialogField(
                  doseCtrl,
                  '💧  Dose (Example: 10ml)',
                  TextInputType.text,
                ),
                const SizedBox(height: 10),
                _dialogField(
                  bodyWeightCtrl,
                  '⚖️  Body weight in KG (Example: 245)',
                  const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                const Text(
                  '👨‍⚕️ Vet Name (optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: RumenoTheme.textDark,
                  ),
                ),
                _dialogField(
                  vetNameCtrl,
                  'Name (optional)',
                  TextInputType.text,
                ),
                const SizedBox(height: 16),
                _stepHeader(applyMode == 'single' ? '4' : '3', 'Deworming Date'),
                const SizedBox(height: 8),
                const Text(
                  'Choose when medicine is / will be given',
                  style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() {
                          dateMode = 'today';
                          selDate = DateTime.now();
                        }),
                        child: _toggleTile(
                          '✅',
                          'Today',
                          dateMode == 'today',
                          RumenoTheme.successGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final yesterday = now.subtract(
                            const Duration(days: 1),
                          );
                          final initial = dateMode == 'past' &&
                                  selDate.isBefore(now)
                              ? selDate
                              : yesterday;
                          final d = await showDatePicker(
                            context: ctx,
                            initialDate: initial,
                            firstDate: DateTime(2000),
                            lastDate: yesterday,
                          );
                          if (d != null) {
                            setModalState(() {
                              selDate = d;
                              dateMode = 'past';
                            });
                          }
                        },
                        child: _toggleTile(
                          '🕐',
                          dateMode == 'past'
                              ? '${selDate.day}/${selDate.month}/${selDate.year}'
                              : 'Past Date',
                          dateMode == 'past',
                          RumenoTheme.warningYellow,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final tomorrow = now.add(const Duration(days: 1));
                          final initial = dateMode == 'future' &&
                                  selDate.isAfter(now)
                              ? selDate
                              : tomorrow;
                          final d = await showDatePicker(
                            context: ctx,
                            initialDate: initial,
                            firstDate: tomorrow,
                            lastDate: DateTime(2030),
                          );
                          if (d != null) {
                            setModalState(() {
                              selDate = d;
                              dateMode = 'future';
                            });
                          }
                        },
                        child: _toggleTile(
                          '📅',
                          dateMode == 'future'
                              ? '${selDate.day}/${selDate.month}/${selDate.year}'
                              : 'Schedule',
                          dateMode == 'future',
                          RumenoTheme.infoBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (applyMode == 'single' && selectedAnimal == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an animal'),
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }
                      if (applyMode == 'group' && selectedAnimalIdsInGroup.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a group and animals'),
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }

                      if (medicines.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Add at least one medicine'),
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }

                      final bodyWeight = double.tryParse(
                        bodyWeightCtrl.text.trim(),
                      );
                      if (applyMode == 'single' && (bodyWeight == null || bodyWeight <= 0)) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter valid body weight in KG',
                            ),
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }

                      final now = DateTime.now();
                      final actualDate = dateMode == 'today' ? now : selDate;
                      final isDone = dateMode != 'future';
                      final medSummary = medicines
                          .map((med) {
                            final brand = med['brand'] ?? '';
                            final salt = med['salt'] ?? '';
                            if (brand.isNotEmpty && salt.isNotEmpty) {
                              return '$brand ($salt)';
                            }
                            return brand.isNotEmpty ? brand : salt;
                          })
                          .join(', ');

                      if (applyMode == 'group') {
                        final records = <DewormingRecord>[];
                        for (final animalId in selectedAnimalIdsInGroup) {
                          records.add(DewormingRecord(
                            id: 'DW_${now.millisecondsSinceEpoch}_$animalId',
                            animalId: animalId,
                            medicineName: medSummary,
                            dose: doseCtrl.text.trim().isEmpty
                                ? null
                                : doseCtrl.text.trim(),
                            dueDate: actualDate,
                            dateAdministered: isDone ? actualDate : null,
                            nextDueDate: isDone
                                ? actualDate.add(const Duration(days: 90))
                                : null,
                            vetName: vetNameCtrl.text.trim().isEmpty
                                ? null
                                : vetNameCtrl.text.trim(),
                            status: isDone
                                ? DewormingStatus.done
                                : DewormingStatus.due,
                          ));
                        }
                        Navigator.pop(ctx);
                        setState(() => _records.addAll(records));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Text('Deworming added for ${records.length} animals! 🪱'),
                              ],
                            ),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      } else {
                        final animal = selectedAnimal!;
                        final record = DewormingRecord(
                          id: 'DW_${now.millisecondsSinceEpoch}',
                          animalId: animal.id,
                          medicineName: medSummary,
                          dose: doseCtrl.text.trim().isEmpty
                              ? null
                              : doseCtrl.text.trim(),
                          dueDate: actualDate,
                          dateAdministered: isDone ? actualDate : null,
                          nextDueDate: isDone
                              ? actualDate.add(const Duration(days: 90))
                              : null,
                          vetName: vetNameCtrl.text.trim().isEmpty
                              ? null
                              : vetNameCtrl.text.trim(),
                          status: isDone
                              ? DewormingStatus.done
                              : DewormingStatus.due,
                        );
                        _updateAnimalWeight(animal.id, bodyWeight!);
                        Navigator.pop(ctx);
                        setState(() => _records.add(record));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Deworming saved. Weight updated to ${bodyWeight.toStringAsFixed(1)} kg',
                                ),
                              ],
                            ),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: Text(
                      applyMode == 'group'
                          ? 'Save for ${selectedAnimalIdsInGroup.length} animals'
                          : 'Save Record',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.accentOlive,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepHeader(String step, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: RumenoTheme.accentOlive,
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: RumenoTheme.textDark,
          ),
        ),
      ],
    );
  }

  void _updateAnimalWeight(String animalId, double weightKg) {
    final index = mockAnimals.indexWhere((a) => a.id == animalId);
    if (index == -1) {
      return;
    }

    final old = mockAnimals[index];
    mockAnimals[index] = Animal(
      id: old.id,
      tagId: old.tagId,
      species: old.species,
      breed: old.breed,
      dateOfBirth: old.dateOfBirth,
      gender: old.gender,
      status: old.status,
      purpose: old.purpose,
      weightKg: weightKg,
      heightCm: old.heightCm,
      color: old.color,
      shedNumber: old.shedNumber,
      fatherId: old.fatherId,
      motherId: old.motherId,
      purchaseDate: old.purchaseDate,
      purchasePrice: old.purchasePrice,
      farmerId: old.farmerId,
    );
  }

  Widget _dialogField(
    TextEditingController ctrl,
    String hint,
    TextInputType type,
  ) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: RumenoTheme.backgroundCream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RumenoTheme.textLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RumenoTheme.textLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: RumenoTheme.accentOlive,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _toggleTile(String emoji, String label, bool selected, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: 0.12)
            : RumenoTheme.backgroundCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? color : RumenoTheme.textLight,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: selected ? color : RumenoTheme.textGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;
    final upcoming = filtered
        .where((r) => r.status != DewormingStatus.done)
        .toList();
    final done = filtered
        .where((r) => r.status == DewormingStatus.done)
        .toList();
    final overdue = filtered
        .where((r) => r.status == DewormingStatus.overdue)
        .toList();
    final due = filtered.where((r) => r.status == DewormingStatus.due).toList();
    final groupProvider = context.watch<GroupProvider>();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).healthCardDeworming),
        actions: const [VeterinarianButton(), MarketplaceButton()],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: '📅 Schedule (${upcoming.length})'),
            Tab(text: '✅ History (${done.length})'),
            Tab(text: '🔔 Alerts (${overdue.length + due.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Category & Group Filter Bar ──
          _buildFilterBar(groupProvider),
          // ── Tabs ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleTab(upcoming),
                _buildHistoryTab(done),
                _buildRemindersTab(overdue, due),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDewormingDialog(context),
        backgroundColor: RumenoTheme.accentOlive,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Record',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildScheduleTab(List<DewormingRecord> records) {
    if (records.isEmpty) {
      return _emptyState(
        '🪱',
        'No upcoming deworming',
        'Tap + to schedule one',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (_, i) => _DewormingCard(record: records[i]),
    );
  }

  Widget _buildHistoryTab(List<DewormingRecord> records) {
    if (records.isEmpty) {
      return _emptyState(
        '✅',
        'No deworming history yet',
        'Records appear here after administration',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (_, i) => _DewormingCard(record: records[i]),
    );
  }

  Widget _buildRemindersTab(
    List<DewormingRecord> overdue,
    List<DewormingRecord> due,
  ) {
    if (overdue.isEmpty && due.isEmpty) {
      return _emptyState(
        '🎉',
        'All deworming up to date!',
        'Great job keeping your animals healthy',
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (overdue.isNotEmpty) ...[
          _listHeader('⚠️  Overdue (${overdue.length})', RumenoTheme.errorRed),
          ...overdue.map((r) => _DewormingCard(record: r)),
        ],
        if (due.isNotEmpty) ...[
          _listHeader(
            '📅  Upcoming (${due.length})',
            RumenoTheme.warningYellow,
          ),
          ...due.map((r) => _DewormingCard(record: r)),
        ],
      ],
    );
  }

  Widget _listHeader(String title, Color color) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
    ),
  );

  Widget _emptyState(String emoji, String title, String sub) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: RumenoTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sub,
          style: const TextStyle(color: RumenoTheme.textGrey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  // ── Filter Bar ──────────────────────────────
  Widget _buildFilterBar(GroupProvider groupProvider) {
    final groups = _selectedCategory != null
        ? groupProvider.getGroupsBySpecies(_selectedCategory!)
        : groupProvider.groups;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryChip(null, '🐾', 'All'),
                ...Species.values.map(
                  (s) => _categoryChip(
                      s,
                      _animalEmoji(s),
                      s.name[0].toUpperCase() + s.name.substring(1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Group dropdown
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGroupId != null
                          ? RumenoTheme.accentOlive
                          : RumenoTheme.textLight,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedGroupId,
                      hint: const Text('📂 Filter by Group',
                          style: TextStyle(
                              fontSize: 14, color: RumenoTheme.textGrey)),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: RumenoTheme.textGrey),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Animals',
                              style: TextStyle(fontSize: 14)),
                        ),
                        ...groups.map((g) => DropdownMenuItem<String?>(
                              value: g.id,
                              child: Text(
                                '${g.name} (${g.animalIds.length})',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedGroupId = val),
                    ),
                  ),
                ),
              ),
              if (_selectedGroupId != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _selectedGroupId = null),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: RumenoTheme.errorRed),
                  ),
                ),
              ],
            ],
          ),
          // Show animals in selected group
          if (_selectedGroupId != null) ...[
            const SizedBox(height: 8),
            _buildGroupAnimalsPreview(groupProvider),
          ],
        ],
      ),
    );
  }

  Widget _categoryChip(Species? species, String emoji, String label) {
    final selected = _selectedCategory == species;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: selected,
        label: Text('$emoji $label', style: const TextStyle(fontSize: 12)),
        onSelected: (_) => setState(() {
          _selectedCategory = selected ? null : species;
          _selectedGroupId = null;
        }),
        selectedColor: RumenoTheme.accentOlive.withValues(alpha: 0.2),
        checkmarkColor: RumenoTheme.accentOlive,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? RumenoTheme.accentOlive : RumenoTheme.textDark,
        ),
      ),
    );
  }

  Widget _buildGroupAnimalsPreview(GroupProvider provider) {
    final animals = provider.getAnimalsInGroup(_selectedGroupId!);
    if (animals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text('No animals in this group',
            style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: animals.map((a) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: RumenoTheme.accentOlive.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: RumenoTheme.accentOlive.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${_animalEmoji(a.species)} ${a.tagId}',
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: RumenoTheme.accentOlive),
          ),
        );
      }).toList(),
    );
  }

  String _animalEmoji(Species species) {
    switch (species) {
      case Species.cow: return '🐄';
      case Species.buffalo: return '🐃';
      case Species.goat: return '🐐';
      case Species.sheep: return '🐑';
      case Species.pig: return '🐷';
      default: return '🐾';
    }
  }
}

class _DewormingCard extends StatelessWidget {
  final DewormingRecord record;

  const _DewormingCard({required this.record});

  Color _statusColor(DewormingStatus s) {
    switch (s) {
      case DewormingStatus.done:
        return RumenoTheme.successGreen;
      case DewormingStatus.due:
        return RumenoTheme.warningYellow;
      case DewormingStatus.overdue:
        return RumenoTheme.errorRed;
    }
  }

  String _statusLabel(DewormingStatus s) {
    switch (s) {
      case DewormingStatus.done:
        return 'Done';
      case DewormingStatus.due:
        return 'Due';
      case DewormingStatus.overdue:
        return 'Overdue';
    }
  }

  IconData _statusIcon(DewormingStatus s) {
    switch (s) {
      case DewormingStatus.done:
        return Icons.check_circle;
      case DewormingStatus.due:
        return Icons.schedule;
      case DewormingStatus.overdue:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _statusColor(record.status).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.bug_report,
              color: _statusColor(record.status),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.medicineName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'Animal: ${record.animalId}${record.dose != null ? ' • ${record.dose}' : ''}${record.vetName != null ? ' • ${record.vetName}' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Due: ${DateFormat('dd MMM yyyy').format(record.dueDate)}${record.nextDueDate != null ? ' • Next: ${DateFormat('dd MMM').format(record.nextDueDate!)}' : ''}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Icon(
                _statusIcon(record.status),
                color: _statusColor(record.status),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                _statusLabel(record.status),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _statusColor(record.status),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
