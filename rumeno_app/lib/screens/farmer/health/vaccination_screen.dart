import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<VaccinationRecord> _vaccinations;

  // ── Filters ──
  Species? _selectedCategory;
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _vaccinations = List.from(mockVaccinations);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<VaccinationRecord> get _filteredVaccinations {
    var list = _vaccinations;
    if (_selectedGroupId != null) {
      final provider = context.read<GroupProvider>();
      final group = provider.getGroupById(_selectedGroupId!);
      if (group != null) {
        list = list.where((v) => group.animalIds.contains(v.animalId)).toList();
      }
    } else if (_selectedCategory != null) {
      final animalIds = mockAnimals
          .where((a) => a.species == _selectedCategory)
          .map((a) => a.id)
          .toSet();
      list = list.where((v) => animalIds.contains(v.animalId)).toList();
    }
    return list;
  }

  // ── Add Vaccination Dialog ───────────────────
  void _showAddVaccinationDialog(BuildContext context) {
    String selVaccine = 'FMD';
    Animal? selectedAnimal;
    final vetNameCtrl = TextEditingController();
    List<TextEditingController> otherMedCtrls = [TextEditingController()];
    DateTime selDate = DateTime.now();
    String dateMode = 'today'; // 'today', 'past', 'future'

    // Group-based vaccination state
    final groupProvider = context.read<GroupProvider>();
    String vaccinationMode = 'single'; // 'single' or 'group'
    String? selectedGroupIdInDialog;
    Set<String> selectedAnimalIdsInGroup = {};
    bool applyToEntireGroup = true;

    const vaccineItems = [
      {'v': 'FMD', 'e': '🐄', 'd': 'Foot & Mouth'},
      {'v': 'BQ', 'e': '🦴', 'd': 'Black Quarter'},
      {'v': 'HS', 'e': '🫀', 'd': 'Hemorrhagic Sep.'},
      {'v': 'PPR', 'e': '🐐', 'd': 'Sheep / Goat'},
      {'v': 'Brucella', 'e': '🔬', 'd': 'Brucellosis'},
      {'v': 'Other', 'e': '💊', 'd': 'Other Vaccine'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill handle
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
                    Text('💉', style: TextStyle(fontSize: 26)),
                    SizedBox(width: 10),
                    Text('Add Vaccination Record',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                // Vaccine type grid
                const Text('Select Vaccine',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.15,
                  children: vaccineItems.map((item) {
                    final sel = selVaccine == item['v'];
                    return GestureDetector(
                      onTap: () => setModalState(
                          () => selVaccine = item['v'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: sel
                              ? RumenoTheme.primaryGreen
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel
                                ? RumenoTheme.primaryGreen
                                : RumenoTheme.textLight,
                            width: sel ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['e'] as String,
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 2),
                            Text(item['v'] as String,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: sel
                                        ? Colors.white
                                        : RumenoTheme.textDark)),
                            Text(item['d'] as String,
                                style: TextStyle(
                                    fontSize: 8,
                                    color: sel
                                        ? Colors.white70
                                        : RumenoTheme.textGrey),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
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
                          vaccinationMode = 'single';
                          selectedGroupIdInDialog = null;
                          selectedAnimalIdsInGroup.clear();
                        }),
                        child: _toggleTile('🐄', 'Single Animal',
                            vaccinationMode == 'single',
                            RumenoTheme.primaryGreen),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() {
                          vaccinationMode = 'group';
                          selectedAnimal = null;
                        }),
                        child: _toggleTile('👥', 'Group',
                            vaccinationMode == 'group',
                            RumenoTheme.infoBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // ── Group-based selection ──
                if (vaccinationMode == 'group') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedGroupIdInDialog != null
                            ? RumenoTheme.primaryGreen
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
                    // Apply to entire group or select individuals
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
                    // Show animals in group as checkable chips
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
                                        selectedAnimalIdsInGroup
                                            .remove(a.id);
                                      } else {
                                        selectedAnimalIdsInGroup
                                            .add(a.id);
                                      }
                                    }),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? RumenoTheme.primaryGreen
                                        .withValues(alpha: 0.15)
                                    : Colors.grey.shade100,
                                borderRadius:
                                    BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? RumenoTheme.primaryGreen
                                      : RumenoTheme.textLight,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: RumenoTheme
                                            .primaryGreen),
                                  if (isSelected)
                                    const SizedBox(width: 4),
                                  Text(
                                    '${_animalEmoji(a.species)} ${a.tagId}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? RumenoTheme.primaryGreen
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
                          color: RumenoTheme.primaryGreen,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
                // ── Single animal picker (only in single mode) ──
                if (vaccinationMode == 'single')
                GestureDetector(
                  onTap: () async {
                    final searchCtrl = TextEditingController();
                    Animal? picked;
                    await showDialog<Animal>(
                      context: ctx,
                      builder: (dCtx) => StatefulBuilder(
                        builder: (dCtx, setDialogState) {
                          final query = searchCtrl.text.toLowerCase();
                          final filtered = mockAnimals
                              .where((a) =>
                                  a.status != AnimalStatus.deceased &&
                                  (a.tagId.toLowerCase().contains(query) ||
                                      a.breed.toLowerCase().contains(query) ||
                                      a.species.name.toLowerCase().contains(query)))
                              .toList();
                          return AlertDialog(
                            title: const Text('Select Animal'),
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 400,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: searchCtrl,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search by tag, breed or species…',
                                      prefixIcon:
                                          const Icon(Icons.search),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (_) =>
                                        setDialogState(() {}),
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
                                              return ListTile(
                                                dense: true,
                                                leading: Text(
                                                  _animalEmoji(a.species),
                                                  style: const TextStyle(
                                                      fontSize: 22),
                                                ),
                                                title: Text(
                                                  a.tagId,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                subtitle: Text(
                                                    '${a.breed} · ${a.weightKg} kg'),
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
                      setModalState(() => selectedAnimal = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedAnimal != null
                            ? RumenoTheme.primaryGreen
                            : Colors.grey.shade300,
                        width: selectedAnimal != null ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: selectedAnimal != null
                          ? RumenoTheme.primaryGreen.withOpacity(0.06)
                          : Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedAnimal != null
                              ? _animalEmoji(selectedAnimal!.species)
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
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '${selectedAnimal!.breed} · ${selectedAnimal!.weightKg} kg',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Tap to select animal',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14),
                                ),
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: Colors.grey.shade500),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _dialogField(vetNameCtrl,
                    '👨‍⚕️  Vet Name (optional)', TextInputType.text),
                const SizedBox(height: 16),
                // ── Other Medicines ───────────────────────────
                if (selVaccine == 'Other') Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Other Vaccine',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: RumenoTheme.textDark)),
                    GestureDetector(
                      onTap: () => setModalState(() {
                        otherMedCtrls.add(TextEditingController());
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: RumenoTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...otherMedCtrls.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ctrl = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _dialogField(
                              ctrl,
                              '💊  Vaccine name (optional)',
                              TextInputType.text),
                        ),
                        if (otherMedCtrls.length > 1) ...
                          [
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setModalState(() {
                                otherMedCtrls.removeAt(index);
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: RumenoTheme.errorRed
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: RumenoTheme.errorRed
                                          .withValues(alpha: 0.3)),
                                ),
                                child: const Icon(Icons.remove,
                                    color: RumenoTheme.errorRed, size: 18),
                              ),
                            ),
                          ],
                      ],
                    ),
                  );
                }),
                if (selVaccine == 'Other') const SizedBox(height: 16),
                const Text('Vaccination Date',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => dateMode = 'today'),
                        child: _toggleTile('✅', 'Today',
                            dateMode == 'today', RumenoTheme.successGreen),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final yesterday = now.subtract(const Duration(days: 1));
                          final initial = (dateMode == 'past' && selDate.isBefore(now))
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
                          final initial = (dateMode == 'future' && selDate.isAfter(now))
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
                      if (vaccinationMode == 'single' && selectedAnimal == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please select an Animal'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      if (vaccinationMode == 'group' && selectedAnimalIdsInGroup.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please select a group and animals'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      final now = DateTime.now();
                      final actualDate =
                          dateMode == 'today' ? now : selDate;
                      final isDone = dateMode != 'future';

                      if (vaccinationMode == 'group') {
                        // Create vaccination records for all selected animals in group
                        final records = <VaccinationRecord>[];
                        for (final animalId in selectedAnimalIdsInGroup) {
                          records.add(VaccinationRecord(
                            id: 'VAC_${now.millisecondsSinceEpoch}_$animalId',
                            animalId: animalId,
                            vaccineName: selVaccine,
                            dueDate: actualDate,
                            dateAdministered: isDone ? actualDate : null,
                            vetName: vetNameCtrl.text.trim().isEmpty
                                ? null
                                : vetNameCtrl.text.trim(),
                            status: isDone
                                ? VaccinationStatus.done
                                : VaccinationStatus.due,
                          ));
                        }
                        Navigator.pop(ctx);
                        setState(() => _vaccinations.addAll(records));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Text('$selVaccine added for ${records.length} animals! 💉'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      } else {
                        final record = VaccinationRecord(
                          id: 'VAC_${now.millisecondsSinceEpoch}',
                          animalId: selectedAnimal!.id,
                          vaccineName: selVaccine,
                          dueDate: actualDate,
                          dateAdministered: isDone ? actualDate : null,
                          vetName: vetNameCtrl.text.trim().isEmpty
                              ? null
                              : vetNameCtrl.text.trim(),
                          status: isDone
                              ? VaccinationStatus.done
                              : VaccinationStatus.due,
                        );
                        Navigator.pop(ctx);
                        setState(() => _vaccinations.add(record));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Text('$selVaccine vaccination added! 💉'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: Text(
                        vaccinationMode == 'group'
                            ? 'Save for ${selectedAnimalIdsInGroup.length} animals'
                            : AppLocalizations.of(context).commonSaveRecord,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _animalEmoji(Species species) {
    switch (species) {
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
      default:
        return '🐾';
    }
  }

  Widget _dialogField(
      TextEditingController ctrl, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: RumenoTheme.backgroundCream,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: RumenoTheme.primaryGreen, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _toggleTile(
      String emoji, String label, bool selected, Color color) {
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
            width: selected ? 2 : 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      selected ? color : RumenoTheme.textGrey,
                ),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVaccinations;
    final upcoming =
        filtered.where((v) => v.status != VaccinationStatus.done).toList();
    final done =
        filtered.where((v) => v.status == VaccinationStatus.done).toList();
    final overdue =
        filtered.where((v) => v.status == VaccinationStatus.overdue).toList();
    final due =
        filtered.where((v) => v.status == VaccinationStatus.due).toList();
    final groupProvider = context.watch<GroupProvider>();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vaccinationTitle),
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
        onPressed: () => _showAddVaccinationDialog(context),
        backgroundColor: RumenoTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Record',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

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
                          ? RumenoTheme.primaryGreen
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
          _selectedGroupId = null; // reset group when category changes
        }),
        selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
        checkmarkColor: RumenoTheme.primaryGreen,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
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
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${_animalEmoji(a.species)} ${a.tagId}',
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: RumenoTheme.primaryGreen),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScheduleTab(List<VaccinationRecord> records) {
    if (records.isEmpty) {
      return _emptyState(
          '💉', 'No upcoming vaccinations', 'Tap + to schedule one');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (_, i) => VaccinationCard(record: records[i]),
    );
  }

  Widget _buildHistoryTab(List<VaccinationRecord> records) {
    if (records.isEmpty) {
      return _emptyState('✅', 'No vaccination history yet',
          'Records appear here after administration');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (_, i) => VaccinationCard(record: records[i]),
    );
  }

  Widget _buildRemindersTab(
      List<VaccinationRecord> overdue, List<VaccinationRecord> due) {
    if (overdue.isEmpty && due.isEmpty) {
      return _emptyState('🎉', 'All vaccinations up to date!',
          'Great job keeping your animals healthy');
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (overdue.isNotEmpty) ...[
          _listHeader(
              '⚠️  Overdue (${overdue.length})', RumenoTheme.errorRed),
          ...overdue.map((v) => VaccinationCard(record: v)),
        ],
        if (due.isNotEmpty) ...[
          _listHeader('📅  Upcoming (${due.length})',
              RumenoTheme.warningYellow),
          ...due.map((v) => VaccinationCard(record: v)),
        ],
      ],
    );
  }

  Widget _listHeader(String title, Color color) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: color)),
      );

  Widget _emptyState(String emoji, String title, String sub) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: RumenoTheme.textDark)),
            const SizedBox(height: 8),
            Text(sub,
                style: const TextStyle(
                    color: RumenoTheme.textGrey, fontSize: 14),
                textAlign: TextAlign.center),
          ],
        ),
      );
}
