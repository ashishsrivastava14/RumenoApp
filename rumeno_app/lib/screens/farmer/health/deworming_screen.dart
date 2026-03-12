import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
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
    String selMedicine = 'Albendazole';
    final animalIdCtrl = TextEditingController();
    final vetNameCtrl = TextEditingController();
    final doseCtrl = TextEditingController();
    DateTime selDate = DateTime.now();
    bool isGivenToday = true;

    const medicineItems = [
      {'v': 'Albendazole', 'e': '💊', 'd': 'Broad spectrum'},
      {'v': 'Fenbendazole', 'e': '🧪', 'd': 'GI worms'},
      {'v': 'Ivermectin', 'e': '💉', 'd': 'Internal & external'},
      {'v': 'Oxfendazole', 'e': '🔬', 'd': 'Roundworms'},
      {'v': 'Levamisole', 'e': '⚗️', 'd': 'Nematodes'},
      {'v': 'Praziquantel', 'e': '🪱', 'd': 'Tapeworms'},
    ];

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
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text('🪱', style: TextStyle(fontSize: 26)),
                    SizedBox(width: 10),
                    Text('Add Deworming Record',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Select Medicine',
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
                  children: medicineItems.map((item) {
                    final sel = selMedicine == item['v'];
                    return GestureDetector(
                      onTap: () => setModalState(
                          () => selMedicine = item['v'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: sel
                              ? RumenoTheme.accentOlive
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel
                                ? RumenoTheme.accentOlive
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
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: sel
                                        ? Colors.white
                                        : RumenoTheme.textDark),
                                textAlign: TextAlign.center),
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
                _dialogField(doseCtrl, '💧  Dose (e.g. 10ml)',
                    TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(vetNameCtrl,
                    '👨‍⚕️  Vet Name (optional)', TextInputType.text),
                const SizedBox(height: 16),
                const Text('Deworming Date',
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
                      if (animalIdCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter Animal ID'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      final now = DateTime.now();
                      final actualDate = isGivenToday ? now : selDate;
                      final isDone = !actualDate.isAfter(now);
                      final record = DewormingRecord(
                        id: 'DW_${now.millisecondsSinceEpoch}',
                        animalId: animalIdCtrl.text.trim(),
                        medicineName: selMedicine,
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
                      Navigator.pop(ctx);
                      setState(() => _records.add(record));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text('$selMedicine deworming added! 🪱'),
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
                      backgroundColor: RumenoTheme.accentOlive,
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
                color: RumenoTheme.accentOlive, width: 2)),
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
                  color: selected ? color : RumenoTheme.textGrey,
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
        _records.where((r) => r.status != DewormingStatus.done).toList();
    final done =
        _records.where((r) => r.status == DewormingStatus.done).toList();
    final overdue =
        _records.where((r) => r.status == DewormingStatus.overdue).toList();
    final due =
        _records.where((r) => r.status == DewormingStatus.due).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Deworming'),
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
        label: const Text('Add Record',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildScheduleTab(List<DewormingRecord> records) {
    if (records.isEmpty) {
      return _emptyState(
          '🪱', 'No upcoming deworming', 'Tap + to schedule one');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (_, i) => _DewormingCard(record: records[i]),
    );
  }

  Widget _buildHistoryTab(List<DewormingRecord> records) {
    if (records.isEmpty) {
      return _emptyState('✅', 'No deworming history yet',
          'Records appear here after administration');
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (_, i) => _DewormingCard(record: records[i]),
    );
  }

  Widget _buildRemindersTab(
      List<DewormingRecord> overdue, List<DewormingRecord> due) {
    if (overdue.isEmpty && due.isEmpty) {
      return _emptyState('🎉', 'All deworming up to date!',
          'Great job keeping your animals healthy');
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (overdue.isNotEmpty) ...[
          _listHeader(
              '⚠️  Overdue (${overdue.length})', RumenoTheme.errorRed),
          ...overdue.map((r) => _DewormingCard(record: r)),
        ],
        if (due.isNotEmpty) ...[
          _listHeader('📅  Upcoming (${due.length})',
              RumenoTheme.warningYellow),
          ...due.map((r) => _DewormingCard(record: r)),
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
              offset: const Offset(0, 2))
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
            child: Icon(Icons.bug_report,
                color: _statusColor(record.status), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.medicineName,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                    'Animal: ${record.animalId}${record.dose != null ? ' • ${record.dose}' : ''}${record.vetName != null ? ' • ${record.vetName}' : ''}',
                    style: Theme.of(context).textTheme.bodySmall),
                Text(
                    'Due: ${DateFormat('dd MMM yyyy').format(record.dueDate)}${record.nextDueDate != null ? ' • Next: ${DateFormat('dd MMM').format(record.nextDueDate!)}' : ''}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: RumenoTheme.textLight)),
              ],
            ),
          ),
          Column(
            children: [
              Icon(_statusIcon(record.status),
                  color: _statusColor(record.status), size: 20),
              const SizedBox(height: 4),
              Text(_statusLabel(record.status),
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(record.status))),
            ],
          ),
        ],
      ),
    );
  }
}
