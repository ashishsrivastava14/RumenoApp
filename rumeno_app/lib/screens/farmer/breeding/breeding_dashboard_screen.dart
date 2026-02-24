import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/common/stat_card.dart';
import '../../../widgets/charts/progress_indicator_card.dart';

class BreedingDashboardScreen extends StatelessWidget {
  const BreedingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pregnantRecords = mockBreedingRecords.where((b) => b.isPregnant).toList();
    final heatRecords = mockBreedingRecords.where((b) => !b.isPregnant).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: RumenoTheme.backgroundCream,
        appBar: AppBar(
          title: const Text('Breeding'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'Heat Tracking'),
              Tab(text: 'Pregnancy'),
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
