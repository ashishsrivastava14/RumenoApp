import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/charts/bar_chart_widget.dart';
import '../../../widgets/charts/line_chart_widget.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/cards/health_record_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class AnimalDetailScreen extends StatelessWidget {
  final String animalId;
  const AnimalDetailScreen({super.key, required this.animalId});

  @override
  Widget build(BuildContext context) {
    final animal = getAnimalById(animalId);
    if (animal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Animal Not Found')),
        body: const Center(child: Text('Animal not found')),
      );
    }

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: RumenoTheme.backgroundCream,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'animal-${animal.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.pets, color: Colors.white, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(animal.tagId, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              Text('${animal.breed} • ${animal.gender == Gender.male ? "Male ♂" : "Female ♀"}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(animal.statusLabel, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(animal.tagId),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/farmer/animals');
                  }
                },
              ),
              actions: const [VeterinarianButton(), MarketplaceButton()],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Health'),
                    Tab(text: 'Vaccination'),
                    Tab(text: 'Breeding'),
                    Tab(text: 'Reproduction'),
                    Tab(text: 'Production'),
                    Tab(text: 'Finance'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _OverviewTab(animal: animal),
              _HealthTab(animalId: animal.id),
              _VaccinationTab(animalId: animal.id),
              _BreedingTab(animalId: animal.id),
              _ReproductionTab(animal: animal),
              _ProductionTab(animal: animal),
              _FinanceTab(animalId: animal.id),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _OverviewTab extends StatelessWidget {
  final Animal animal;
  const _OverviewTab({required this.animal});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow('Tag ID', animal.tagId),
        _InfoRow('Species', animal.speciesName),
        _InfoRow('Breed', animal.breed),
        _InfoRow('Age', animal.ageString),
        _InfoRow('Weight', '${animal.weightKg} kg'),
        _InfoRow('Height', '${animal.heightCm ?? "-"} cm'),
        _InfoRow('Color', animal.color ?? '-'),
        _InfoRow('Shed', animal.shedNumber ?? '-'),
        _InfoRow('Purpose', animal.purpose.name.toUpperCase()),
        const SizedBox(height: 16),
        LineChartWidget(
          title: 'Weight History',
          spots: const [
            FlSpot(0, 350), FlSpot(1, 370), FlSpot(2, 385), FlSpot(3, 400), FlSpot(4, 410), FlSpot(5, 420),
          ],
          bottomLabels: const ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
        ),
        if (animal.purpose == AnimalPurpose.dairy || animal.purpose == AnimalPurpose.mixed) ...[
          const SizedBox(height: 16),
          BarChartWidget(
            title: 'Milk Performance (L/month)',
            values: const [180, 210, 195, 225, 240, 230],
            labels: const ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
            barColor: RumenoTheme.infoBlue,
          ),
        ],
        const SizedBox(height: 16),
        BarChartWidget(
          title: 'Kidding Performance',
          values: const [1, 2, 1, 2, 1],
          labels: const ['2022', '2023', '2024', '2025', '2026'],
          barColor: RumenoTheme.warningYellow,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.titleSmall)),
        ],
      ),
    );
  }
}

class _HealthTab extends StatelessWidget {
  final String animalId;
  const _HealthTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final records = mockTreatments.where((t) => t.animalId == animalId).toList();
    if (records.isEmpty) {
      return const Center(child: Text('No health records'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (context, index) => HealthRecordCard(record: records[index]),
    );
  }
}

class _VaccinationTab extends StatelessWidget {
  final String animalId;
  const _VaccinationTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final records = mockVaccinations.where((v) => v.animalId == animalId).toList();
    if (records.isEmpty) {
      return const Center(child: Text('No vaccination records'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (context, index) => VaccinationCard(record: records[index]),
    );
  }
}

class _BreedingTab extends StatelessWidget {
  final String animalId;
  const _BreedingTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final records = mockBreedingRecords.where((b) => b.animalId == animalId).toList();
    if (records.isEmpty) {
      return const Center(child: Text('No breeding records'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final r = records[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Heat: ${DateFormat('dd MMM yyyy').format(r.heatDate)}', style: Theme.of(context).textTheme.titleSmall),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: r.isPregnant ? RumenoTheme.infoBlue.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r.isPregnant ? 'Pregnant' : 'Not Pregnant', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: r.isPregnant ? RumenoTheme.infoBlue : Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Intensity: ${r.intensity.name} • AI: ${r.aiDone ? "Yes" : "No"}', style: Theme.of(context).textTheme.bodySmall),
              if (r.expectedDelivery != null)
                Text('Expected Delivery: ${DateFormat('dd MMM yyyy').format(r.expectedDelivery!)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.primaryGreen)),
            ],
          ),
        );
      },
    );
  }
}

class _ProductionTab extends StatelessWidget {
  final Animal animal;
  const _ProductionTab({required this.animal});

  @override
  Widget build(BuildContext context) {
    if (animal.purpose != AnimalPurpose.dairy && animal.purpose != AnimalPurpose.mixed) {
      return const Center(child: Text('Production data for dairy animals only'));
    }

    // Calculate milk dry off date from breeding records
    final breedingRecords = mockBreedingRecords.where((b) => b.animalId == animal.id && b.isPregnant && b.expectedDelivery != null).toList();
    DateTime? milkDryOffDate;
    DateTime? expectedDelivery;
    if (breedingRecords.isNotEmpty) {
      expectedDelivery = breedingRecords.last.expectedDelivery;
      milkDryOffDate = expectedDelivery!.subtract(const Duration(days: 60));
    }

    final now = DateTime.now();
    final dryOffAlert = milkDryOffDate != null && milkDryOffDate.difference(now).inDays <= 7 && milkDryOffDate.isAfter(now);
    final dryOffOverdue = milkDryOffDate != null && milkDryOffDate.isBefore(now);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LineChartWidget(
          title: 'Daily Milk Production (L)',
          spots: const [
            FlSpot(0, 8), FlSpot(1, 9), FlSpot(2, 8.5), FlSpot(3, 10), FlSpot(4, 9.5), FlSpot(5, 11),
          ],
          bottomLabels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          lineColor: RumenoTheme.infoBlue,
        ),
        if (milkDryOffDate != null) ...[
          const SizedBox(height: 16),
          _MilkDryOffCard(
            dryOffDate: milkDryOffDate,
            expectedDelivery: expectedDelivery!,
            isAlert: dryOffAlert,
            isOverdue: dryOffOverdue,
          ),
        ],
      ],
    );
  }
}

class _FinanceTab extends StatelessWidget {
  final String animalId;
  const _FinanceTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ExpenseItem('Vaccination - FMD', '₹500', '10 Dec 2025'),
        _ExpenseItem('Antibiotics', '₹2,500', '18 Feb 2026'),
        _ExpenseItem('Vet Consultation', '₹1,500', '18 Feb 2026'),
      ],
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  const _ExpenseItem(this.title, this.amount, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Text(date, style: Theme.of(context).textTheme.bodySmall),
          ])),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.errorRed)),
        ],
      ),
    );
  }
}

// ─── Reproduction Tab ───

class _ReproductionTab extends StatelessWidget {
  final Animal animal;
  const _ReproductionTab({required this.animal});

  @override
  Widget build(BuildContext context) {
    final breedingRecords = mockBreedingRecords.where((b) => b.animalId == animal.id).toList();
    final currentPregnancy = breedingRecords.where((b) => b.isPregnant).toList();

    // Calculate milk dry off date
    DateTime? milkDryOffDate;
    DateTime? expectedDelivery;
    if (currentPregnancy.isNotEmpty && currentPregnancy.last.expectedDelivery != null) {
      expectedDelivery = currentPregnancy.last.expectedDelivery;
      milkDryOffDate = expectedDelivery!.subtract(const Duration(days: 60));
    }

    final now = DateTime.now();
    final dryOffAlert = milkDryOffDate != null && milkDryOffDate.difference(now).inDays <= 7 && milkDryOffDate.isAfter(now);
    final dryOffOverdue = milkDryOffDate != null && milkDryOffDate.isBefore(now);

    // Mock synchronization records
    final syncRecords = <_SyncRecord>[
      if (breedingRecords.isNotEmpty)
        _SyncRecord(
          date: breedingRecords.first.heatDate.subtract(const Duration(days: 10)),
          protocol: 'Ovsynch',
          status: 'Completed',
          notes: 'GnRH + PGF2α protocol',
        ),
    ];

    // Mock miscarriage records
    final miscarriageRecords = <_MiscarriageRecord>[
      if (animal.id == '6')
        _MiscarriageRecord(
          date: DateTime(2025, 3, 15),
          stage: '4 months',
          cause: 'Unknown',
          notes: 'Vet examined, no infection found',
        ),
    ];

    // Mock lactation data
    final lactationNumber = animal.purpose == AnimalPurpose.dairy || animal.purpose == AnimalPurpose.mixed ? 3 : 0;
    final lactationHistory = <_LactationRecord>[
      if (lactationNumber > 0) ...[
        _LactationRecord(number: 1, startDate: DateTime(2022, 5, 10), endDate: DateTime(2023, 2, 15), totalMilkLitres: 3250, daysInMilk: 281),
        _LactationRecord(number: 2, startDate: DateTime(2023, 8, 20), endDate: DateTime(2024, 5, 10), daysInMilk: 264, totalMilkLitres: 3680),
        _LactationRecord(number: 3, startDate: DateTime(2025, 1, 5), endDate: null, daysInMilk: null, totalMilkLitres: null),
      ],
    ];

    // Mock mastitis history
    final mastitisHistory = <_MastitisRecord>[
      if (animal.id == '1') ...[
        _MastitisRecord(date: DateTime(2026, 1, 25), quarter: 'Rear Left', severity: 'Subclinical', treatment: 'Cephalexin intramammary', resolvedDate: DateTime(2026, 2, 5)),
      ],
      if (animal.id == '2')
        _MastitisRecord(date: DateTime(2025, 6, 10), quarter: 'Front Right', severity: 'Clinical', treatment: 'Amoxicillin + anti-inflammatory', resolvedDate: DateTime(2025, 6, 22)),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Synchronization Section ──
        _ReproSectionHeader(title: 'Synchronization', icon: Icons.sync),
        if (syncRecords.isEmpty)
          _EmptySection(message: 'No synchronization records')
        else
          ...syncRecords.map((s) => _SyncCard(record: s)),

        const SizedBox(height: 20),

        // ── Heat History ──
        _ReproSectionHeader(title: 'Heat History', icon: Icons.whatshot),
        if (breedingRecords.isEmpty)
          _EmptySection(message: 'No heat records')
        else
          ...breedingRecords.map((r) => _HeatCard(record: r)),

        const SizedBox(height: 20),

        // ── Miscarriage History ──
        _ReproSectionHeader(title: 'Miscarriage History', icon: Icons.warning_amber_rounded),
        if (miscarriageRecords.isEmpty)
          _EmptySection(message: 'No miscarriage records')
        else
          ...miscarriageRecords.map((m) => _MiscarriageCard(record: m)),

        const SizedBox(height: 20),

        // ── Artificial Insemination ──
        _ReproSectionHeader(title: 'Artificial Insemination', icon: Icons.medical_services_outlined),
        if (breedingRecords.where((b) => b.aiDone).isEmpty)
          _EmptySection(message: 'No AI records')
        else
          ...breedingRecords.where((b) => b.aiDone).map((r) => _AICard(record: r)),

        const SizedBox(height: 20),

        // ── Pregnancy Status ──
        _ReproSectionHeader(title: 'Pregnancy Status', icon: Icons.pregnant_woman),
        _PregnancyStatusCard(
          isPregnant: currentPregnancy.isNotEmpty,
          record: currentPregnancy.isNotEmpty ? currentPregnancy.last : null,
        ),

        const SizedBox(height: 20),

        // ── Lactation ──
        _ReproSectionHeader(title: 'Lactation', icon: Icons.water_drop_outlined),
        _InfoRow('Current Lactation Number', lactationNumber > 0 ? '$lactationNumber' : 'N/A'),
        const SizedBox(height: 8),
        if (lactationHistory.isEmpty)
          _EmptySection(message: 'No lactation history')
        else
          ...lactationHistory.map((l) => _LactationCard(record: l)),

        const SizedBox(height: 20),

        // ── Mastitis History ──
        _ReproSectionHeader(title: 'Mastitis History', icon: Icons.healing),
        if (mastitisHistory.isEmpty)
          _EmptySection(message: 'No mastitis records')
        else
          ...mastitisHistory.map((m) => _MastitisCard(record: m)),

        const SizedBox(height: 20),

        // ── Milk Dry Off Date ──
        _ReproSectionHeader(title: 'Milk Dry Off', icon: Icons.event),
        if (milkDryOffDate != null)
          _MilkDryOffCard(
            dryOffDate: milkDryOffDate,
            expectedDelivery: expectedDelivery!,
            isAlert: dryOffAlert,
            isOverdue: dryOffOverdue,
          )
        else
          _EmptySection(message: 'No expected delivery date to calculate dry off'),

        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Reproduction Data Classes ───

class _SyncRecord {
  final DateTime date;
  final String protocol;
  final String status;
  final String? notes;
  const _SyncRecord({required this.date, required this.protocol, required this.status, this.notes});
}

class _MiscarriageRecord {
  final DateTime date;
  final String stage;
  final String cause;
  final String? notes;
  const _MiscarriageRecord({required this.date, required this.stage, required this.cause, this.notes});
}

class _LactationRecord {
  final int number;
  final DateTime startDate;
  final DateTime? endDate;
  final int? daysInMilk;
  final double? totalMilkLitres;
  const _LactationRecord({required this.number, required this.startDate, this.endDate, this.daysInMilk, this.totalMilkLitres});
}

class _MastitisRecord {
  final DateTime date;
  final String quarter;
  final String severity;
  final String treatment;
  final DateTime? resolvedDate;
  const _MastitisRecord({required this.date, required this.quarter, required this.severity, required this.treatment, this.resolvedDate});
}

// ─── Reproduction Section Widgets ───

class _ReproSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _ReproSectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: RumenoTheme.primaryGreen),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Center(child: Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey))),
    );
  }
}

class _SyncCard extends StatelessWidget {
  final _SyncRecord record;
  const _SyncCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Protocol: ${record.protocol}', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _StatusChip(label: record.status, color: RumenoTheme.successGreen),
            ],
          ),
          const SizedBox(height: 4),
          Text('Date: ${DateFormat('dd MMM yyyy').format(record.date)}', style: Theme.of(context).textTheme.bodySmall),
          if (record.notes != null)
            Text(record.notes!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _HeatCard extends StatelessWidget {
  final BreedingRecord record;
  const _HeatCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Heat: ${DateFormat('dd MMM yyyy').format(record.heatDate)}', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text('Intensity: ${record.intensity.name[0].toUpperCase()}${record.intensity.name.substring(1)}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          _IntensityIndicator(intensity: record.intensity),
        ],
      ),
    );
  }
}

class _IntensityIndicator extends StatelessWidget {
  final HeatIntensity intensity;
  const _IntensityIndicator({required this.intensity});

  @override
  Widget build(BuildContext context) {
    final color = switch (intensity) {
      HeatIntensity.strong => RumenoTheme.errorRed,
      HeatIntensity.moderate => RumenoTheme.warningYellow,
      HeatIntensity.mild => RumenoTheme.successGreen,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(intensity.name[0].toUpperCase() + intensity.name.substring(1), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _MiscarriageCard extends StatelessWidget {
  final _MiscarriageRecord record;
  const _MiscarriageCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RumenoTheme.errorRed.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: RumenoTheme.errorRed),
              const SizedBox(width: 6),
              Text('Miscarriage - ${DateFormat('dd MMM yyyy').format(record.date)}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: RumenoTheme.errorRed)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Stage: ${record.stage} • Cause: ${record.cause}', style: Theme.of(context).textTheme.bodySmall),
          if (record.notes != null)
            Text(record.notes!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _AICard extends StatelessWidget {
  final BreedingRecord record;
  const _AICard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('AI - ${DateFormat('dd MMM yyyy').format(record.matingDate ?? record.heatDate)}', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _StatusChip(
                label: record.isPregnant ? 'Successful' : 'Pending',
                color: record.isPregnant ? RumenoTheme.successGreen : RumenoTheme.warningYellow,
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (record.bullSemenId != null)
            Text('Bull/Semen ID: ${record.bullSemenId}', style: Theme.of(context).textTheme.bodySmall),
          if (record.technicianName != null)
            Text('Technician: ${record.technicianName}', style: Theme.of(context).textTheme.bodySmall),
          Text('Heat Intensity: ${record.intensity.name[0].toUpperCase()}${record.intensity.name.substring(1)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _PregnancyStatusCard extends StatelessWidget {
  final bool isPregnant;
  final BreedingRecord? record;
  const _PregnancyStatusCard({required this.isPregnant, this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPregnant ? RumenoTheme.infoBlue.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPregnant ? Icons.check_circle : Icons.remove_circle_outline,
                color: isPregnant ? RumenoTheme.infoBlue : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isPregnant ? 'Currently Pregnant' : 'Not Pregnant',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isPregnant ? RumenoTheme.infoBlue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isPregnant && record != null) ...[
            const SizedBox(height: 10),
            _InfoRow('Mating Date', record!.matingDate != null ? DateFormat('dd MMM yyyy').format(record!.matingDate!) : '-'),
            _InfoRow('Expected Delivery', record!.expectedDelivery != null ? DateFormat('dd MMM yyyy').format(record!.expectedDelivery!) : '-'),
            if (record!.expectedDelivery != null)
              _InfoRow('Days Remaining', '${record!.expectedDelivery!.difference(DateTime.now()).inDays} days'),
          ],
        ],
      ),
    );
  }
}

class _LactationCard extends StatelessWidget {
  final _LactationRecord record;
  const _LactationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final isCurrent = record.endDate == null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.4)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Lactation #${record.number}', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              if (isCurrent) _StatusChip(label: 'Current', color: RumenoTheme.primaryGreen),
            ],
          ),
          const SizedBox(height: 6),
          Text('Start: ${DateFormat('dd MMM yyyy').format(record.startDate)}', style: Theme.of(context).textTheme.bodySmall),
          if (record.endDate != null)
            Text('End: ${DateFormat('dd MMM yyyy').format(record.endDate!)}', style: Theme.of(context).textTheme.bodySmall),
          if (record.daysInMilk != null)
            Text('Days in Milk: ${record.daysInMilk}', style: Theme.of(context).textTheme.bodySmall),
          if (record.totalMilkLitres != null)
            Text('Total Yield: ${record.totalMilkLitres!.toStringAsFixed(0)} L', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MastitisCard extends StatelessWidget {
  final _MastitisRecord record;
  const _MastitisCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final isResolved = record.resolvedDate != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isResolved ? Colors.grey.withValues(alpha: 0.2) : RumenoTheme.warningYellow.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${record.severity} Mastitis', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _StatusChip(label: isResolved ? 'Resolved' : 'Active', color: isResolved ? RumenoTheme.successGreen : RumenoTheme.warningYellow),
            ],
          ),
          const SizedBox(height: 6),
          Text('Date: ${DateFormat('dd MMM yyyy').format(record.date)}', style: Theme.of(context).textTheme.bodySmall),
          Text('Quarter: ${record.quarter}', style: Theme.of(context).textTheme.bodySmall),
          Text('Treatment: ${record.treatment}', style: Theme.of(context).textTheme.bodySmall),
          if (isResolved)
            Text('Resolved: ${DateFormat('dd MMM yyyy').format(record.resolvedDate!)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.successGreen)),
        ],
      ),
    );
  }
}

class _MilkDryOffCard extends StatelessWidget {
  final DateTime dryOffDate;
  final DateTime expectedDelivery;
  final bool isAlert;
  final bool isOverdue;
  const _MilkDryOffCard({required this.dryOffDate, required this.expectedDelivery, required this.isAlert, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    final daysUntilDryOff = dryOffDate.difference(DateTime.now()).inDays;

    Color borderColor;
    Color iconColor;
    String alertMessage;
    if (isOverdue) {
      borderColor = RumenoTheme.errorRed;
      iconColor = RumenoTheme.errorRed;
      alertMessage = 'Milk dry off date has passed! Stop milking immediately to ensure proper dry period before delivery.';
    } else if (isAlert) {
      borderColor = RumenoTheme.warningYellow;
      iconColor = RumenoTheme.warningYellow;
      alertMessage = 'Milk dry off approaching in $daysUntilDryOff days. Plan to stop milking by ${DateFormat('dd MMM yyyy').format(dryOffDate)} to allow 60 days dry period before expected delivery.';
    } else {
      borderColor = RumenoTheme.infoBlue;
      iconColor = RumenoTheme.infoBlue;
      alertMessage = 'Dry off scheduled 60 days before expected delivery date.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.4), width: isAlert || isOverdue ? 1.5 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isOverdue ? Icons.error : isAlert ? Icons.warning_amber_rounded : Icons.event, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text('Milk Dry Off Date', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow('Dry Off Date', DateFormat('dd MMM yyyy').format(dryOffDate)),
          _InfoRow('Expected Delivery', DateFormat('dd MMM yyyy').format(expectedDelivery)),
          if (!isOverdue)
            _InfoRow('Days Until Dry Off', '$daysUntilDryOff days'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: borderColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(alertMessage, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: borderColor, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
