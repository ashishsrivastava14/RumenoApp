import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_health.dart';
import '../../../widgets/common/marketplace_button.dart';
import '../../../models/models.dart';
import '../../../widgets/common/stat_card.dart';
import '../../../widgets/charts/progress_indicator_card.dart';

class BreedingDashboardScreen extends StatefulWidget {
  const BreedingDashboardScreen({super.key});

  @override
  State<BreedingDashboardScreen> createState() => _BreedingDashboardScreenState();
}

class _BreedingDashboardScreenState extends State<BreedingDashboardScreen> {
  late List<BreedingRecord> _allRecords;

  @override
  void initState() {
    super.initState();
    _allRecords = List.from(mockBreedingRecords);
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Add Breeding Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _menuItem(ctx, '🔥', 'Record Heat', 'Observe heat in an animal', () { Navigator.pop(ctx); _showAddHeatDialog(); }),
            _menuItem(ctx, '💉', 'Artificial Insemination', 'Record AI procedure', () { Navigator.pop(ctx); _showAddAIDialog(); }),
            _menuItem(ctx, '🤰', 'Pregnancy Check', 'Update pregnancy status', () { Navigator.pop(ctx); _showAddPregnancyDialog(); }),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext ctx, String emoji, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
      trailing: const Icon(Icons.chevron_right, color: RumenoTheme.textGrey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showAddHeatDialog() {
    final animalIdCtrl = TextEditingController();
    DateTime heatDate = DateTime.now();
    HeatIntensity intensity = HeatIntensity.moderate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🔥', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Record Heat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                _formField(animalIdCtrl, '🐄 Animal ID (e.g. 1)', TextInputType.text),
                const SizedBox(height: 12),
                const Text('Heat Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, heatDate, (d) => setModalState(() => heatDate = d)),
                const SizedBox(height: 16),
                const Text('Intensity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: HeatIntensity.values.map((hi) {
                    final sel = intensity == hi;
                    final color = switch (hi) { HeatIntensity.strong => RumenoTheme.errorRed, HeatIntensity.moderate => RumenoTheme.warningYellow, HeatIntensity.mild => RumenoTheme.successGreen, HeatIntensity.repeatHeat => Colors.red.shade900 };
                    final label = hi == HeatIntensity.repeatHeat ? 'Repeat Heat' : hi.name[0].toUpperCase() + hi.name.substring(1);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => intensity = hi),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: sel ? color.withValues(alpha: 0.15) : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sel ? color : RumenoTheme.textLight, width: sel ? 2 : 1),
                          ),
                          child: Column(children: [
                            Icon(Icons.whatshot, color: sel ? color : RumenoTheme.textGrey, size: 24),
                            const SizedBox(height: 4),
                            Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: sel ? color : RumenoTheme.textGrey)),
                          ]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save Heat Record', () {
                  if (animalIdCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter Animal ID'), backgroundColor: RumenoTheme.errorRed));
                    return;
                  }
                  final record = BreedingRecord(
                    id: 'BR_${DateTime.now().millisecondsSinceEpoch}',
                    animalId: animalIdCtrl.text.trim(),
                    heatDate: heatDate,
                    intensity: intensity,
                    aiDone: false,
                    isPregnant: false,
                  );
                  Navigator.pop(ctx);
                  setState(() => _allRecords.add(record));
                  _showSavedSnackBar('Heat record added!');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddAIDialog() {
    final animalIdCtrl = TextEditingController();
    final bullSemenCtrl = TextEditingController();
    final technicianCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    DateTime aiDate = DateTime.now();
    HeatIntensity intensity = HeatIntensity.moderate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('💉', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Add AI Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                _formField(animalIdCtrl, '🐄 Animal ID (e.g. 1)', TextInputType.text),
                const SizedBox(height: 12),
                const Text('AI Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, aiDate, (d) => setModalState(() => aiDate = d)),
                const SizedBox(height: 12),
                _formField(bullSemenCtrl, '🐂 Bull / Semen ID', TextInputType.text),
                const SizedBox(height: 12),
                _formField(technicianCtrl, '👨‍⚕️ Technician Name', TextInputType.text),
                const SizedBox(height: 16),
                const Text('Heat Intensity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: HeatIntensity.values.map((hi) {
                    final sel = intensity == hi;
                    final color = switch (hi) { HeatIntensity.strong => RumenoTheme.errorRed, HeatIntensity.moderate => RumenoTheme.warningYellow, HeatIntensity.mild => RumenoTheme.successGreen, HeatIntensity.repeatHeat => Colors.red.shade900 };
                    final label = hi == HeatIntensity.repeatHeat ? 'Repeat Heat' : hi.name[0].toUpperCase() + hi.name.substring(1);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => intensity = hi),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? color.withValues(alpha: 0.15) : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sel ? color : RumenoTheme.textLight, width: sel ? 2 : 1),
                          ),
                          child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: sel ? color : RumenoTheme.textGrey))),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                _formField(notesCtrl, '📝 Notes (optional)', TextInputType.text),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save AI Record', () {
                  if (animalIdCtrl.text.trim().isEmpty || bullSemenCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter Animal ID and Bull/Semen ID'), backgroundColor: RumenoTheme.errorRed));
                    return;
                  }
                  final record = BreedingRecord(
                    id: 'BR_${DateTime.now().millisecondsSinceEpoch}',
                    animalId: animalIdCtrl.text.trim(),
                    heatDate: aiDate,
                    intensity: intensity,
                    aiDone: true,
                    bullSemenId: bullSemenCtrl.text.trim(),
                    technicianName: technicianCtrl.text.trim().isEmpty ? null : technicianCtrl.text.trim(),
                    matingDate: aiDate,
                    isPregnant: false,
                    notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                  setState(() => _allRecords.add(record));
                  _showSavedSnackBar('AI record added!');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddPregnancyDialog() {
    final animalIdCtrl = TextEditingController();
    DateTime matingDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime expectedDelivery = DateTime.now().add(const Duration(days: 250));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🤰', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Pregnancy Check', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                _formField(animalIdCtrl, '🐄 Animal ID (e.g. 1)', TextInputType.text),
                const SizedBox(height: 12),
                const Text('Mating Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, matingDate, (d) => setModalState(() => matingDate = d)),
                const SizedBox(height: 12),
                const Text('Expected Delivery', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, expectedDelivery, (d) => setModalState(() => expectedDelivery = d)),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save Pregnancy Record', () {
                  if (animalIdCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter Animal ID'), backgroundColor: RumenoTheme.errorRed));
                    return;
                  }
                  final record = BreedingRecord(
                    id: 'BR_${DateTime.now().millisecondsSinceEpoch}',
                    animalId: animalIdCtrl.text.trim(),
                    heatDate: matingDate,
                    intensity: HeatIntensity.strong,
                    aiDone: false,
                    matingDate: matingDate,
                    isPregnant: true,
                    expectedDelivery: expectedDelivery,
                  );
                  Navigator.pop(ctx);
                  setState(() => _allRecords.add(record));
                  _showSavedSnackBar('Pregnancy record added!');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Shared helpers ──
  Widget _pillHandle() => Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))));

  Widget _formField(TextEditingController ctrl, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint, filled: true, fillColor: RumenoTheme.backgroundCream,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _datePickerTile(BuildContext ctx, DateTime current, ValueChanged<DateTime> onPicked) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: ctx, initialDate: current, firstDate: DateTime(2020), lastDate: DateTime(2030));
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: RumenoTheme.backgroundCream, borderRadius: BorderRadius.circular(12), border: Border.all(color: RumenoTheme.textLight)),
        child: Row(children: [
          const Icon(Icons.calendar_today, size: 18, color: RumenoTheme.primaryGreen),
          const SizedBox(width: 10),
          Text(DateFormat('dd MMM yyyy').format(current), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          const Icon(Icons.edit, size: 16, color: RumenoTheme.textGrey),
        ]),
      ),
    );
  }

  Widget _saveButton(BuildContext ctx, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: RumenoTheme.primaryGreen, foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _showSavedSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(msg))]),
      backgroundColor: RumenoTheme.successGreen,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pregnantRecords = _allRecords.where((b) => b.isPregnant).toList();
    final heatRecords = _allRecords.where((b) => !b.isPregnant).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: RumenoTheme.backgroundCream,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).breedingTitle),
          actions: const [VeterinarianButton(), MarketplaceButton()],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: AppLocalizations.of(context).breedingTabDashboard),
              Tab(text: AppLocalizations.of(context).breedingTabHeatTracking),
              Tab(text: AppLocalizations.of(context).breedingTabPregnancy),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BreedingOverview(pregnantRecords: pregnantRecords),
            _HeatTrackingTab(heatRecords: heatRecords),
            _PregnancyTab(pregnantRecords: pregnantRecords),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddMenu,
          backgroundColor: RumenoTheme.primaryGreen,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(AppLocalizations.of(context).breedingAddRecordFab, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _BreedingOverview extends StatelessWidget {
  final List<BreedingRecord> pregnantRecords;
  const _BreedingOverview({required this.pregnantRecords});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              StatCard(title: 'In Heat', value: '3', icon: Icons.favorite, color: Colors.pink),
              SizedBox(width: 12),
              StatCard(title: 'Pregnant', value: '8', icon: Icons.pregnant_woman, color: Colors.blue),
              SizedBox(width: 12),
              StatCard(title: 'Due This Week', value: '2', icon: Icons.child_care, color: Colors.green),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Pregnancy Timeline', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...pregnantRecords.map((r) {
          final totalDays = r.expectedDelivery != null ? r.expectedDelivery!.difference(r.heatDate).inDays : 280;
          final elapsed = DateTime.now().difference(r.heatDate).inDays;
          final progress = (elapsed / totalDays).clamp(0.0, 1.0);
          final remaining = r.expectedDelivery != null ? r.expectedDelivery!.difference(DateTime.now()).inDays : 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ProgressIndicatorCard(
              title: 'Animal ${r.animalId}',
              subtitle: '${remaining > 0 ? remaining : 0} days remaining',
              progress: progress,
              progressText: '${(progress * 100).toInt()}%',
              progressColor: remaining < 30 ? RumenoTheme.warningYellow : RumenoTheme.primaryGreen,
            ),
          );
        }),
      ],
    );
  }
}

class _HeatTrackingTab extends StatelessWidget {
  final List<BreedingRecord> heatRecords;
  const _HeatTrackingTab({required this.heatRecords});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...heatRecords.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Animal ${r.animalId}', style: Theme.of(context).textTheme.titleSmall),
                  Text('Last heat: ${DateFormat('dd MMM yyyy').format(r.heatDate)}', style: Theme.of(context).textTheme.bodySmall),
                  Text('Intensity: ${r.intensity.name}', style: Theme.of(context).textTheme.bodySmall),
                  if (r.notes != null) Text(r.notes!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight)),
                ],
              ),
            )),
        if (heatRecords.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No heat records'))),
      ],
    );
  }
}

class _PregnancyTab extends StatelessWidget {
  final List<BreedingRecord> pregnantRecords;
  const _PregnancyTab({required this.pregnantRecords});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pregnantRecords.length,
      itemBuilder: (context, index) {
        final r = pregnantRecords[index];
        final remaining = r.expectedDelivery?.difference(DateTime.now()).inDays ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Animal ${r.animalId}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: remaining < 14 ? RumenoTheme.errorRed.withValues(alpha: 0.1) : RumenoTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${remaining > 0 ? remaining : 0} days left', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: remaining < 14 ? RumenoTheme.errorRed : RumenoTheme.successGreen)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Mating: ${r.matingDate != null ? DateFormat('dd MMM yyyy').format(r.matingDate!) : "-"}', style: Theme.of(context).textTheme.bodySmall),
              Text('Expected: ${r.expectedDelivery != null ? DateFormat('dd MMM yyyy').format(r.expectedDelivery!) : "-"}', style: Theme.of(context).textTheme.bodySmall),
              if (r.aiDone) Text('AI: ${r.bullSemenId ?? ""}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight)),
            ],
          ),
        );
      },
    );
  }
}
