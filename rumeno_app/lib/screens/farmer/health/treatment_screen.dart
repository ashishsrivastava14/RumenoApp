import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/cards/health_record_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  late List<TreatmentRecord> _treatments;
  TreatmentStatus? _filter; // null = All

  // ── Group / Category Filters ──
  Species? _selectedCategory;
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _treatments = List.from(mockTreatments);
  }

  List<TreatmentRecord> get _filtered {
    var list = _treatments;
    if (_selectedGroupId != null) {
      final provider = context.read<GroupProvider>();
      final group = provider.getGroupById(_selectedGroupId!);
      if (group != null) {
        final tagIds = mockAnimals
            .where((a) => group.animalIds.contains(a.id))
            .map((a) => a.tagId)
            .toSet();
        list = list.where((t) => tagIds.contains(t.animalId)).toList();
      }
    } else if (_selectedCategory != null) {
      final tagIds = mockAnimals
          .where((a) => a.species == _selectedCategory)
          .map((a) => a.tagId)
          .toSet();
      list = list.where((t) => tagIds.contains(t.animalId)).toList();
    }
    if (_filter != null) {
      list = list.where((t) => t.status == _filter).toList();
    }
    return list;
  }

  // ── Add Treatment Dialog ─────────────────────
  void _showAddTreatmentDialog(BuildContext context) {
    Animal? selectedAnimal;
    final diagnosisCtrl = TextEditingController();
    final treatmentCtrl = TextEditingController();
    final vetCtrl = TextEditingController();
    final withdrawalCtrl = TextEditingController();
    final otherSymptomsCtrl = TextEditingController();
    final selectedSymptoms = <String>{};

    // Group-based state
    final groupProvider = context.read<GroupProvider>();
    String applyMode = 'single'; // 'single' or 'group'
    String? selectedGroupIdInDialog;
    Set<String> selectedAnimalIdsInGroup = {};
    bool applyToEntireGroup = true;

    const symptomItems = [
      {'e': '🌡️', 's': 'Fever'},
      {'e': '💧', 's': 'Diarrhea'},
      {'e': '🦵', 's': 'Limping'},
      {'e': '🍽️', 's': 'No appetite'},
      {'e': '😷', 's': 'Coughing'},
      {'e': '🫃', 's': 'Bloating'},
      {'e': '👁️', 's': 'Eye discharge'},
      {'e': '🤧', 's': 'Nasal discharge'},
      {'e': '🔴', 's': 'Skin lesions'},
      {'e': '🥛', 's': 'Less milk'},
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
                    Text('🩺', style: TextStyle(fontSize: 26)),
                    SizedBox(width: 10),
                    Text('Report Sick Animal',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
                            RumenoTheme.errorRed),
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
                            ? RumenoTheme.errorRed
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
                                    ? RumenoTheme.errorRed.withValues(alpha: 0.15)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? RumenoTheme.errorRed
                                      : RumenoTheme.textLight,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Icon(Icons.check_circle,
                                        size: 14, color: RumenoTheme.errorRed),
                                  if (isSelected) const SizedBox(width: 4),
                                  Text(
                                    '${_animalEmoji(a.species)} ${a.tagId}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? RumenoTheme.errorRed
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
                          color: RumenoTheme.errorRed,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
                // ── Single animal picker (only in single mode) ──
                if (applyMode == 'single')
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
                                      prefixIcon: const Icon(Icons.search),
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
                                            separatorBuilder: (_, __) =>
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
                            ? RumenoTheme.errorRed
                            : Colors.grey.shade300,
                        width: selectedAnimal != null ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: selectedAnimal != null
                          ? RumenoTheme.errorRed.withOpacity(0.06)
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
                const SizedBox(height: 16),
                // Symptoms
                const Text('What symptoms do you see?',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: symptomItems.map((s) {
                    final sym = s['s'] as String;
                    final emoji = s['e'] as String;
                    final sel = selectedSymptoms.contains(sym);
                    return GestureDetector(
                      onTap: () => setModalState(() {
                        if (sel) {
                          selectedSymptoms.remove(sym);
                        } else {
                          selectedSymptoms.add(sym);
                        }
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel
                              ? RumenoTheme.errorRed
                                  .withValues(alpha: 0.12)
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: sel
                                  ? RumenoTheme.errorRed
                                  : RumenoTheme.textLight,
                              width: sel ? 2 : 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(sym,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: sel
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: sel
                                      ? RumenoTheme.errorRed
                                      : RumenoTheme.textDark,
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: otherSymptomsCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '✏️  Other symptoms (e.g. Swollen leg, Trembling)',
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
                ),
                const SizedBox(height: 16),
                _dialogField(
                    diagnosisCtrl,
                    '🔍  Diagnosis (e.g. Fever & infection)',
                    TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(treatmentCtrl,
                    '💊  Medicine / Treatment', TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(
                    vetCtrl, '👨‍⚕️  Vet Name', TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(
                    withdrawalCtrl,
                    '⏳  Withdrawal period in days (optional)',
                    TextInputType.number),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Lab report upload coming soon!'))),
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach Lab Report (optional)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RumenoTheme.primaryGreen,
                    side: const BorderSide(color: RumenoTheme.primaryGreen),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
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
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      if (applyMode == 'group' && selectedAnimalIdsInGroup.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please select a group and animals'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      if (diagnosisCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a diagnosis'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      final withdrawal =
                          int.tryParse(withdrawalCtrl.text.trim());
                      final symptoms = () {
                        final extra = otherSymptomsCtrl.text.trim();
                        final all = <String>{...selectedSymptoms};
                        if (extra.isNotEmpty) all.add(extra);
                        return all.isEmpty ? ['General illness'] : all.toList();
                      }();

                      if (applyMode == 'group') {
                        final records = <TreatmentRecord>[];
                        for (final animalId in selectedAnimalIdsInGroup) {
                          final animal = mockAnimals.where((a) => a.id == animalId).firstOrNull;
                          records.add(TreatmentRecord(
                            id: 'TR_${DateTime.now().millisecondsSinceEpoch}_$animalId',
                            animalId: animal?.tagId ?? animalId,
                            symptoms: symptoms,
                            diagnosis: diagnosisCtrl.text.trim(),
                            treatment: treatmentCtrl.text.trim().isEmpty
                                ? 'Treatment pending'
                                : treatmentCtrl.text.trim(),
                            startDate: DateTime.now(),
                            vetName: vetCtrl.text.trim().isEmpty
                                ? 'Pending vet assignment'
                                : vetCtrl.text.trim(),
                            status: TreatmentStatus.active,
                            withdrawalDays: withdrawal,
                          ));
                        }
                        Navigator.pop(ctx);
                        setState(() => _treatments.insertAll(0, records));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Treatment added for ${records.length} animals! 🩺'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      } else {
                        final record = TreatmentRecord(
                          id: 'TR_${DateTime.now().millisecondsSinceEpoch}',
                          animalId: selectedAnimal!.tagId,
                          symptoms: symptoms,
                          diagnosis: diagnosisCtrl.text.trim(),
                          treatment: treatmentCtrl.text.trim().isEmpty
                              ? 'Treatment pending'
                              : treatmentCtrl.text.trim(),
                          startDate: DateTime.now(),
                          vetName: vetCtrl.text.trim().isEmpty
                              ? 'Pending vet assignment'
                              : vetCtrl.text.trim(),
                          status: TreatmentStatus.active,
                          withdrawalDays: withdrawal,
                        );
                        Navigator.pop(ctx);
                        setState(() => _treatments.insert(0, record));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Treatment record added!'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: Text(
                        applyMode == 'group'
                            ? 'Save for ${selectedAnimalIdsInGroup.length} animals'
                            : 'Save Treatment',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.errorRed,
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
      case Species.cow: return '🐄';
      case Species.buffalo: return '🐃';
      case Species.goat: return '🐐';
      case Species.sheep: return '🐑';
      case Species.pig: return '🐷';
      default: return '🐾';
    }
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
                  color: selected ? color : RumenoTheme.textGrey,
                ),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
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

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final activeCount =
        _treatments.where((t) => t.status == TreatmentStatus.active).length;
    final followUpCount = _treatments
        .where((t) => t.status == TreatmentStatus.followUp)
        .length;
    final completedCount = _treatments
        .where((t) => t.status == TreatmentStatus.completed)
        .length;
    final groupProvider = context.watch<GroupProvider>();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).treatmentTitle),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: Column(
        children: [
          // Status summary row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _MiniStat('🤒', 'Active', activeCount, RumenoTheme.errorRed),
                const SizedBox(width: 10),
                _MiniStat('🔄', 'Follow-up', followUpCount,
                    RumenoTheme.warningYellow),
                const SizedBox(width: 10),
                _MiniStat('✅', 'Recovered', completedCount,
                    RumenoTheme.successGreen),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // ── Category & Group Filter Bar ──
          _buildFilterBar(groupProvider),
          // Filter chips
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(null, '🗂️ All (${_treatments.length})'),
                  const SizedBox(width: 8),
                  _filterChip(TreatmentStatus.active,
                      '🤒 Active ($activeCount)',
                      color: RumenoTheme.errorRed),
                  const SizedBox(width: 8),
                  _filterChip(TreatmentStatus.followUp,
                      '🔄 Follow-up ($followUpCount)',
                      color: RumenoTheme.warningYellow),
                  const SizedBox(width: 8),
                  _filterChip(TreatmentStatus.completed,
                      '✅ Recovered ($completedCount)',
                      color: RumenoTheme.successGreen),
                ],
              ),
            ),
          ),
          // Treatment list
          Expanded(
            child: filtered.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        HealthRecordCard(record: filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTreatmentDialog(context),
        backgroundColor: RumenoTheme.errorRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Report Sick Animal',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _filterChip(TreatmentStatus? status, String label,
      {Color? color}) {
    final sel = _filter == status;
    final c = color ?? RumenoTheme.primaryGreen;
    return GestureDetector(
      onTap: () => setState(() => _filter = status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? c.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: sel ? c : RumenoTheme.textLight,
              width: sel ? 2 : 1),
          boxShadow: sel
              ? [
                  BoxShadow(
                      color: c.withValues(alpha: 0.15), blurRadius: 6)
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: sel ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: sel ? c : RumenoTheme.textGrey,
          ),
        ),
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
                          ? RumenoTheme.errorRed
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
        selectedColor: RumenoTheme.errorRed.withValues(alpha: 0.2),
        checkmarkColor: RumenoTheme.errorRed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? RumenoTheme.errorRed : RumenoTheme.textDark,
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
            color: RumenoTheme.errorRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: RumenoTheme.errorRed.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${_animalEmoji(a.species)} ${a.tagId}',
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: RumenoTheme.errorRed),
          ),
        );
      }).toList(),
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('🎉', style: TextStyle(fontSize: 60)),
            SizedBox(height: 16),
            Text('No treatments found',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: RumenoTheme.textDark)),
            SizedBox(height: 8),
            Text('All animals look healthy!',
                style: TextStyle(
                    color: RumenoTheme.textGrey, fontSize: 14)),
          ],
        ),
      );
}

class _MiniStat extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final Color color;

  const _MiniStat(this.emoji, this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text('$count',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: RumenoTheme.textGrey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
