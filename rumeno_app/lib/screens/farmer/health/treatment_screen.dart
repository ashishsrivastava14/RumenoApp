import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
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

  @override
  void initState() {
    super.initState();
    _treatments = List.from(mockTreatments);
  }

  List<TreatmentRecord> get _filtered {
    if (_filter == null) return _treatments;
    return _treatments.where((t) => t.status == _filter).toList();
  }

  // ── Add Treatment Dialog ─────────────────────
  void _showAddTreatmentDialog(BuildContext context) {
    final animalIdCtrl = TextEditingController();
    final diagnosisCtrl = TextEditingController();
    final treatmentCtrl = TextEditingController();
    final vetCtrl = TextEditingController();
    final withdrawalCtrl = TextEditingController();
    final selectedSymptoms = <String>{};

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
                _dialogField(animalIdCtrl,
                    '🐄  Animal ID (e.g. C-001)', TextInputType.text),
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
                      if (animalIdCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter Animal ID'),
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
                      final record = TreatmentRecord(
                        id: 'TR_${DateTime.now().millisecondsSinceEpoch}',
                        animalId: animalIdCtrl.text.trim(),
                        symptoms: selectedSymptoms.isEmpty
                            ? ['General illness']
                            : selectedSymptoms.toList(),
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
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Treatment',
                        style: TextStyle(
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

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Disease & Treatment'),
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
