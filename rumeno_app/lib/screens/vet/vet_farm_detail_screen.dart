import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_farmers.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';

class VetFarmDetailScreen extends StatefulWidget {
  final String farmerId;
  const VetFarmDetailScreen({super.key, required this.farmerId});

  @override
  State<VetFarmDetailScreen> createState() => _VetFarmDetailScreenState();
}

class _VetFarmDetailScreenState extends State<VetFarmDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farmer = mockFarmers.firstWhere(
      (f) => f.id == widget.farmerId,
      orElse: () => mockFarmers.first,
    );
    final farmAnimals =
        mockAnimals.where((a) => a.farmerId == widget.farmerId).toList();
    final farmAnimalIds = farmAnimals.map((a) => a.id).toSet();
    final farmTreatments =
        mockTreatments.where((t) => farmAnimalIds.contains(t.animalId)).toList();
    final farmVaccinations = mockVaccinations
        .where((v) => farmAnimalIds.contains(v.animalId))
        .toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(farmer.farmName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/vet/farms');
            }
          },
        ),
        actions: const [FarmButton(), MarketplaceButton()],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Animals'),
            Tab(text: 'Treatments'),
            Tab(text: 'Vaccinations'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Farm info banner
          _FarmInfoBanner(farmer: farmer, animalCount: farmAnimals.length),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _AnimalsTab(animals: farmAnimals),
                _TreatmentsTab(treatments: farmTreatments, animals: farmAnimals),
                _VaccinationsTab(
                    vaccinations: farmVaccinations, animals: farmAnimals),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Farm Info Banner ────────────────────────────────────────────────────────

class _FarmInfoBanner extends StatelessWidget {
  final Farmer farmer;
  final int animalCount;
  const _FarmInfoBanner({required this.farmer, required this.animalCount});

  Color get _planColor {
    switch (farmer.plan) {
      case SubscriptionPlan.free:
        return RumenoTheme.planFree;
      case SubscriptionPlan.starter:
        return RumenoTheme.planStarter;
      case SubscriptionPlan.pro:
        return RumenoTheme.planPro;
      case SubscriptionPlan.business:
        return RumenoTheme.planBusiness;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
            child: Text(
              farmer.name[0],
              style: TextStyle(
                  color: RumenoTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(farmer.farmName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _planColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(farmer.planName,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _planColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(farmer.name,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${farmer.address}, ${farmer.state}',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$animalCount',
                style: TextStyle(
                    color: RumenoTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              const Text('animals', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Animals Tab ─────────────────────────────────────────────────────────────

class _AnimalsTab extends StatelessWidget {
  final List<Animal> animals;
  const _AnimalsTab({required this.animals});

  Color _statusColor(AnimalStatus s) {
    switch (s) {
      case AnimalStatus.active:
        return Colors.green;
      case AnimalStatus.pregnant:
        return Colors.blue;
      case AnimalStatus.dry:
        return Colors.orange;
      case AnimalStatus.sick:
        return Colors.red;
      case AnimalStatus.underTreatment:
        return Colors.purple;
      case AnimalStatus.quarantine:
        return Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (animals.isEmpty) {
      return const Center(child: Text('No animals recorded for this farm.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: animals.length,
      itemBuilder: (context, i) {
        final a = animals[i];
        final color = _statusColor(a.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: color, width: 3)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Icon(Icons.pets_rounded, color: color, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(a.tagId,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(a.statusLabel,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${a.breed} · ${a.speciesName} · ${a.gender == Gender.male ? 'Male' : 'Female'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${a.weightKg.toInt()} kg · Age: ${a.ageString}${a.shedNumber != null ? ' · Shed ${a.shedNumber}' : ''}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: RumenoTheme.textLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Treatments Tab ──────────────────────────────────────────────────────────

class _TreatmentsTab extends StatelessWidget {
  final List<TreatmentRecord> treatments;
  final List<Animal> animals;
  const _TreatmentsTab({required this.treatments, required this.animals});

  Color _statusColor(TreatmentStatus s) {
    switch (s) {
      case TreatmentStatus.active:
        return Colors.red;
      case TreatmentStatus.completed:
        return Colors.green;
      case TreatmentStatus.followUp:
        return Colors.orange;
    }
  }

  String _statusLabel(TreatmentStatus s) {
    switch (s) {
      case TreatmentStatus.active:
        return 'Active';
      case TreatmentStatus.completed:
        return 'Completed';
      case TreatmentStatus.followUp:
        return 'Follow-up';
    }
  }

  String _animalName(String id) {
    try {
      final a = animals.firstWhere((a) => a.id == id);
      return '${a.breed} (${a.tagId})';
    } catch (_) {
      return 'Animal #$id';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (treatments.isEmpty) {
      return const Center(child: Text('No treatment records for this farm.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: treatments.length,
      itemBuilder: (context, i) {
        final t = treatments[i];
        final color = _statusColor(t.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(t.diagnosis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14))),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(_statusLabel(t.status),
                        style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_animalName(t.animalId),
                  style: TextStyle(
                      fontSize: 12,
                      color: RumenoTheme.primaryGreen,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(t.treatment,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 12, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(DateFormat('dd MMM yyyy').format(t.startDate),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  if (t.followUpDate != null) ...[
                    const SizedBox(width: 10),
                    Icon(Icons.update_rounded,
                        size: 12, color: Colors.orange[400]),
                    const SizedBox(width: 4),
                    Text(
                        'Follow-up: ${DateFormat('dd MMM').format(t.followUpDate!)}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.orange[600])),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Vaccinations Tab ────────────────────────────────────────────────────────

class _VaccinationsTab extends StatelessWidget {
  final List<VaccinationRecord> vaccinations;
  final List<Animal> animals;
  const _VaccinationsTab(
      {required this.vaccinations, required this.animals});

  Color _statusColor(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.done:
        return Colors.green;
      case VaccinationStatus.due:
        return Colors.orange;
      case VaccinationStatus.overdue:
        return Colors.red;
    }
  }

  String _statusLabel(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.done:
        return 'Done';
      case VaccinationStatus.due:
        return 'Due';
      case VaccinationStatus.overdue:
        return 'Overdue';
    }
  }

  String _animalName(String id) {
    try {
      final a = animals.firstWhere((a) => a.id == id);
      return '${a.breed} (${a.tagId})';
    } catch (_) {
      return 'Animal #$id';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (vaccinations.isEmpty) {
      return const Center(child: Text('No vaccination records for this farm.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: vaccinations.length,
      itemBuilder: (context, i) {
        final v = vaccinations[i];
        final color = _statusColor(v.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.vaccines_rounded, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(v.vaccineName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(_statusLabel(v.status),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(_animalName(v.animalId),
                        style: TextStyle(
                            fontSize: 12, color: RumenoTheme.primaryGreen)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          v.dateAdministered != null
                              ? 'Given: ${DateFormat('dd MMM yyyy').format(v.dateAdministered!)}'
                              : 'Due: ${DateFormat('dd MMM yyyy').format(v.dueDate)}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500]),
                        ),
                        if (v.nextDueDate != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            'Next: ${DateFormat('dd MMM yyyy').format(v.nextDueDate!)}',
                            style: TextStyle(
                                fontSize: 11, color: Colors.orange[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
