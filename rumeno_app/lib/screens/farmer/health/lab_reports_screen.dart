import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/common/marketplace_button.dart';

class LabReportsScreen extends StatefulWidget {
  const LabReportsScreen({super.key});

  @override
  State<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends State<LabReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<LabReport> _reports;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _reports = List.from(mockLabReports);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Add Lab Report Dialog ────────────────────
  void _showAddLabReportDialog(BuildContext context) {
    String selTest = 'Complete Blood Count';
    final animalIdCtrl = TextEditingController();
    final labNameCtrl = TextEditingController();
    final vetNameCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    const testItems = [
      {'v': 'Complete Blood Count', 'e': '🩸', 'd': 'CBC'},
      {'v': 'Brucella Test', 'e': '🔬', 'd': 'Brucellosis'},
      {'v': 'Milk Culture & Sensitivity', 'e': '🥛', 'd': 'Mastitis'},
      {'v': 'Fecal Egg Count', 'e': '🪱', 'd': 'Parasites'},
      {'v': 'Liver Function Test', 'e': '🫀', 'd': 'LFT'},
      {'v': 'Tuberculin Test', 'e': '🫁', 'd': 'TB test'},
      {'v': 'Pregnancy Confirmation', 'e': '🤰', 'd': 'Pregnancy'},
      {'v': 'Blood Smear', 'e': '💉', 'd': 'Blood parasites'},
      {'v': 'Urine Analysis', 'e': '🧪', 'd': 'Urinalysis'},
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
                    Text('🔬', style: TextStyle(fontSize: 26)),
                    SizedBox(width: 10),
                    Text('Add Lab Report',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Select Test',
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
                  children: testItems.map((item) {
                    final sel = selTest == item['v'];
                    return GestureDetector(
                      onTap: () => setModalState(
                          () => selTest = item['v'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: sel
                              ? RumenoTheme.warmBrown
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel
                                ? RumenoTheme.warmBrown
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
                            Text(item['d'] as String,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: sel
                                        ? Colors.white
                                        : RumenoTheme.textDark),
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
                _dialogField(labNameCtrl, '🏥  Lab Name (optional)',
                    TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(vetNameCtrl,
                    '👨‍⚕️  Vet Name (optional)', TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(notesCtrl, '📝  Notes (optional)',
                    TextInputType.text),
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
                      final record = LabReport(
                        id: 'LR_${DateTime.now().millisecondsSinceEpoch}',
                        animalId: animalIdCtrl.text.trim(),
                        testName: selTest,
                        testDate: DateTime.now(),
                        labName: labNameCtrl.text.trim().isEmpty
                            ? null
                            : labNameCtrl.text.trim(),
                        vetName: vetNameCtrl.text.trim().isEmpty
                            ? null
                            : vetNameCtrl.text.trim(),
                        status: LabReportStatus.pending,
                        notes: notesCtrl.text.trim().isEmpty
                            ? null
                            : notesCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                      setState(() => _reports.insert(0, record));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Lab report added! 🔬'),
                          ]),
                          backgroundColor: RumenoTheme.successGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Report',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.warmBrown,
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
                color: RumenoTheme.warmBrown, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final pending =
        _reports.where((r) => r.status == LabReportStatus.pending).toList();
    final completed =
        _reports.where((r) => r.status == LabReportStatus.completed).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Lab Reports'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: '⏳ Pending (${pending.length})'),
            Tab(text: '✅ Completed (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(pending, 'pending'),
          _buildList(completed, 'completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLabReportDialog(context),
        backgroundColor: RumenoTheme.warmBrown,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Report',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildList(List<LabReport> reports, String type) {
    if (reports.isEmpty) {
      return _emptyState(
        type == 'pending' ? '⏳' : '✅',
        type == 'pending' ? 'No pending reports' : 'No completed reports yet',
        type == 'pending'
            ? 'Tap + to add a new lab test'
            : 'Results will appear here once ready',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: reports.length,
      itemBuilder: (_, i) => _LabReportCard(report: reports[i]),
    );
  }

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

class _LabReportCard extends StatelessWidget {
  final LabReport report;

  const _LabReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final isPending = report.status == LabReportStatus.pending;
    final statusColor =
        isPending ? RumenoTheme.warningYellow : RumenoTheme.successGreen;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border:
            Border(left: BorderSide(color: statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(report.testName,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                    isPending ? 'Pending' : 'Completed',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
              'Animal: ${report.animalId}${report.labName != null ? ' • ${report.labName}' : ''}${report.vetName != null ? ' • ${report.vetName}' : ''}',
              style: Theme.of(context).textTheme.bodySmall),
          if (report.result != null) ...[
            const SizedBox(height: 4),
            Text('Result: ${report.result}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                        color: RumenoTheme.primaryGreen,
                        fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 4),
          Text(
              'Date: ${DateFormat('dd MMM yyyy').format(report.testDate)}${report.notes != null ? ' • ${report.notes}' : ''}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: RumenoTheme.textLight)),
        ],
      ),
    );
  }
}
