import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
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

  // ── Add Vaccination Dialog ───────────────────
  void _showAddVaccinationDialog(BuildContext context) {
    String selVaccine = 'FMD';
    final animalIdCtrl = TextEditingController();
    final vetNameCtrl = TextEditingController();
    DateTime selDate = DateTime.now();
    bool isGivenToday = true;

    const vaccineItems = [
      {'v': 'FMD', 'e': '🐄', 'd': 'Foot & Mouth'},
      {'v': 'BQ', 'e': '🦴', 'd': 'Black Quarter'},
      {'v': 'HS', 'e': '🫀', 'd': 'Hemorrhagic Sep.'},
      {'v': 'PPR', 'e': '🐐', 'd': 'Sheep / Goat'},
      {'v': 'Brucella', 'e': '🔬', 'd': 'Brucellosis'},
      {'v': 'Deworming', 'e': '🪱', 'd': 'Parasites'},
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
                _dialogField(animalIdCtrl, '🐄  Animal ID (e.g. C-001)',
                    TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(vetNameCtrl,
                    '👨‍⚕️  Vet Name (optional)', TextInputType.text),
                const SizedBox(height: 16),
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
                        onTap: () =>
                            setModalState(() => isGivenToday = true),
                        child: _toggleTile('✅', 'Given Today',
                            isGivenToday, RumenoTheme.successGreen),
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
                            setModalState(
                                () {
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
                      if (animalIdCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter Animal ID'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      final now = DateTime.now();
                      final actualDate =
                          isGivenToday ? now : selDate;
                      final isDone = !actualDate.isAfter(now);
                      final record = VaccinationRecord(
                        id: 'VAC_${now.millisecondsSinceEpoch}',
                        animalId: animalIdCtrl.text.trim(),
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
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Record',
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
    final upcoming =
        _vaccinations.where((v) => v.status != VaccinationStatus.done).toList();
    final done =
        _vaccinations.where((v) => v.status == VaccinationStatus.done).toList();
    final overdue =
        _vaccinations.where((v) => v.status == VaccinationStatus.overdue).toList();
    final due =
        _vaccinations.where((v) => v.status == VaccinationStatus.due).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Vaccinations'),
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
        onPressed: () => _showAddVaccinationDialog(context),
        backgroundColor: RumenoTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Record',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
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
