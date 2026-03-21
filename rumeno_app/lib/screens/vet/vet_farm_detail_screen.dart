import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_farmers.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';
import '../../l10n/app_localizations.dart';

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
          tabs: [
            Tab(text: AppLocalizations.of(context).vetFarmDetailTabAnimals),
            Tab(text: AppLocalizations.of(context).vetFarmDetailTabTreatments),
            Tab(text: AppLocalizations.of(context).vetFarmDetailTabVaccinations),
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
            radius: 28,
            backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
            child: const Text('🌾', style: TextStyle(fontSize: 28)),
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
              Text(AppLocalizations.of(context).vetFarmDetailAnimalsLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
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
      case AnimalStatus.deceased:
        return Colors.grey;
    }
  }

  String _speciesEmoji(Species s) {
    switch (s) {
      case Species.cow:    return '🐄';
      case Species.buffalo: return '🐃';
      case Species.goat:   return '🐐';
      case Species.sheep:  return '🐑';
      case Species.pig:    return '🐷';
      case Species.horse:  return '🐴';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (animals.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).vetFarmDetailNoAnimals));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: animals.length,
      itemBuilder: (context, i) {
        final a = animals[i];
        final color = _statusColor(a.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Text(_speciesEmoji(a.species), style: const TextStyle(fontSize: 28)),
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
                      '${a.breed} · ${a.speciesName} · ${a.gender == Gender.male ? AppLocalizations.of(context).commonMale : AppLocalizations.of(context).commonFemale}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${a.weightKg.toInt()} kg · Age: ${a.ageString}${a.shedNumber != null ? ' · ${AppLocalizations.of(context).vetFarmDetailShed} ${a.shedNumber}' : ''}',
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

  String _statusLabel(TreatmentStatus s, AppLocalizations l10n) {
    switch (s) {
      case TreatmentStatus.active:
        return l10n.commonActive;
      case TreatmentStatus.completed:
        return l10n.commonCompleted;
      case TreatmentStatus.followUp:
        return l10n.commonFollowUp;
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

  String _statusEmoji(TreatmentStatus s) {
    switch (s) {
      case TreatmentStatus.active:
        return '🚨';
      case TreatmentStatus.completed:
        return '✅';
      case TreatmentStatus.followUp:
        return '🔄';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (treatments.isEmpty) {
      return Center(child: Text(l10n.vetFarmDetailNoTreatments));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: treatments.length,
      itemBuilder: (context, i) {
        final t = treatments[i];
        final color = _statusColor(t.status);
        final emoji = _statusEmoji(t.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(t.diagnosis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_statusLabel(t.status, l10n),
                        style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('🐾 ', style: TextStyle(fontSize: 14)),
                  Text(_animalName(t.animalId),
                      style: TextStyle(
                          fontSize: 12,
                          color: RumenoTheme.primaryGreen,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 4),
              Text(t.treatment,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('📅 ', style: TextStyle(fontSize: 14)),
                  Text(DateFormat('dd MMM yyyy').format(t.startDate),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  if (t.followUpDate != null) ...[
                    const SizedBox(width: 10),
                    const Text('🔄 ', style: TextStyle(fontSize: 14)),
                    Text(
                        l10n.vetFarmDetailFollowUpDate(DateFormat('dd MMM').format(t.followUpDate!)),
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

  String _statusLabel(VaccinationStatus s, AppLocalizations l10n) {
    switch (s) {
      case VaccinationStatus.done:
        return l10n.commonDone;
      case VaccinationStatus.due:
        return l10n.commonDue;
      case VaccinationStatus.overdue:
        return l10n.commonOverdue;
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
    final l10n = AppLocalizations.of(context);
    if (vaccinations.isEmpty) {
      return Center(child: Text(l10n.vetFarmDetailNoVaccinations));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: vaccinations.length,
      itemBuilder: (context, i) {
        final v = vaccinations[i];
        final color = _statusColor(v.status);
        final emoji = v.status == VaccinationStatus.done ? '✅' : v.status == VaccinationStatus.overdue ? '🚨' : '⏳';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
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
                          child: Text(_statusLabel(v.status, l10n),
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
                              ? l10n.vetFarmDetailGivenDate(DateFormat('dd MMM yyyy').format(v.dateAdministered!))
                              : l10n.vetFarmDetailDueDate(DateFormat('dd MMM yyyy').format(v.dueDate)),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500]),
                        ),
                        if (v.nextDueDate != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            l10n.vetFarmDetailNextDate(DateFormat('dd MMM yyyy').format(v.nextDueDate!)),
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
