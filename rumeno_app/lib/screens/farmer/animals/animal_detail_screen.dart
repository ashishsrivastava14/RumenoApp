import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/charts/line_chart_widget.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/cards/health_record_card.dart';

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
      length: 6,
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
