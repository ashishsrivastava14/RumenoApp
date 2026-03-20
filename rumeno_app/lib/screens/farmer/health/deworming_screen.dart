import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
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
    final animalIdCtrl = TextEditingController();
    final vetNameCtrl = TextEditingController();
    final doseCtrl = TextEditingController();
    final bodyWeightCtrl = TextEditingController();
    final medicineBrandCtrl = TextEditingController();
    final medicineSaltCtrl = TextEditingController();
    final List<Map<String, String>> medicines = [];
    DateTime selDate = DateTime.now();
    bool isGivenToday = true;

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
                _stepHeader('1', 'Animal ID / Tag Number'),
                const SizedBox(height: 8),
                _dialogField(
                  animalIdCtrl,
                  '🐄  Example: 1 or C-001',
                  TextInputType.text,
                ),
                const SizedBox(height: 14),
                _stepHeader('2', 'Add Medicine Name'),
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
                _stepHeader('3', 'Dose and Body Weight'),
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
                _stepHeader('4', 'Deworming Date'),
                const SizedBox(height: 8),
                const Text(
                  'Choose when medicine is given',
                  style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isGivenToday = true),
                        child: _toggleTile(
                          '✅',
                          'Given Today',
                          isGivenToday,
                          RumenoTheme.successGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final d = await showDatePicker(
                            context: ctx,
                            initialDate: selDate.isBefore(DateTime.now())
                                ? DateTime.now()
                                : selDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (d != null) {
                            setModalState(() {
                              selDate = d;
                              isGivenToday = false;
                            });
                          }
                        },
                        child: _toggleTile(
                          '📅',
                          isGivenToday
                              ? 'Schedule Later'
                              : '${selDate.day}/${selDate.month}/${selDate.year}',
                          !isGivenToday,
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
                      final animalInput = animalIdCtrl.text.trim();
                      if (animalInput.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter Animal ID'),
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
                      if (bodyWeight == null || bodyWeight <= 0) {
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

                      final animal =
                          getAnimalById(animalInput) ??
                          getAnimalByTag(animalInput);
                      if (animal == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Animal not found. Enter valid ID or tag',
                            ),
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }

                      final now = DateTime.now();
                      final actualDate = isGivenToday ? now : selDate;
                      final isDone = !actualDate.isAfter(now);
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
                      _updateAnimalWeight(animal.id, bodyWeight);
                      Navigator.pop(ctx);
                      setState(() => _records.add(record));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Deworming saved. Weight updated to ${bodyWeight.toStringAsFixed(1)} kg',
                              ),
                            ],
                          ),
                          backgroundColor: RumenoTheme.successGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Save Record',
                      style: TextStyle(
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
    final upcoming = _records
        .where((r) => r.status != DewormingStatus.done)
        .toList();
    final done = _records
        .where((r) => r.status == DewormingStatus.done)
        .toList();
    final overdue = _records
        .where((r) => r.status == DewormingStatus.overdue)
        .toList();
    final due = _records.where((r) => r.status == DewormingStatus.due).toList();

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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScheduleTab(upcoming),
          _buildHistoryTab(done),
          _buildRemindersTab(overdue, due),
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
