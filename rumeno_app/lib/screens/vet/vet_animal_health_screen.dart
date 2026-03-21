import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';

// ──────────────────────────────────────
//  Helpers
// ──────────────────────────────────────

Animal? _animalById(String id) {
  try {
    return mockAnimals.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
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

Color _speciesColor(Species s) {
  switch (s) {
    case Species.cow:    return const Color(0xFFEF6C00);
    case Species.buffalo: return const Color(0xFF455A64);
    case Species.goat:   return const Color(0xFF558B2F);
    case Species.sheep:  return const Color(0xFF0288D1);
    case Species.pig:    return const Color(0xFFE91E63);
    case Species.horse:  return const Color(0xFF6D4C41);
  }
}

const Map<String, IconData> _symptomIcons = {
  'Fever':             Icons.thermostat_rounded,
  'Loss of appetite':  Icons.no_food_rounded,
  'Lethargy':          Icons.battery_0_bar_rounded,
  'Lameness':          Icons.accessibility_new_rounded,
  'Swelling':          Icons.bubble_chart_rounded,
  'Diarrhea':          Icons.water_drop_rounded,
  'Cough':             Icons.air_rounded,
  'Nasal discharge':   Icons.opacity_rounded,
  'Reduced milk':      Icons.water_outlined,
};

// ──────────────────────────────────────
//  Main Screen
// ──────────────────────────────────────

class VetAnimalHealthScreen extends StatefulWidget {
  const VetAnimalHealthScreen({super.key});

  @override
  State<VetAnimalHealthScreen> createState() => _VetAnimalHealthScreenState();
}

class _VetAnimalHealthScreenState extends State<VetAnimalHealthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vetAnimalHealthTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/vet/dashboard');
            }
          },
        ),
        actions: const [FarmButton(), MarketplaceButton()],
        bottom: TabBar(
          controller: _tab,
          isScrollable: false,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: [
            Tab(icon: Column(mainAxisSize: MainAxisSize.min, children: [const Text('📊', style: TextStyle(fontSize: 18)), Icon(Icons.dashboard_rounded, size: 16)]), text: AppLocalizations.of(context).vetAnimalHealthTabOverview),
            Tab(icon: Column(mainAxisSize: MainAxisSize.min, children: [const Text('📄', style: TextStyle(fontSize: 18)), Icon(Icons.medical_information_rounded, size: 16)]), text: AppLocalizations.of(context).vetAnimalHealthTabRecords),
            Tab(icon: Column(mainAxisSize: MainAxisSize.min, children: [const Text('💉', style: TextStyle(fontSize: 18)), Icon(Icons.vaccines_rounded, size: 16)]), text: AppLocalizations.of(context).vetAnimalHealthTabVaccines),
            Tab(icon: Column(mainAxisSize: MainAxisSize.min, children: [const Text('➕', style: TextStyle(fontSize: 18)), Icon(Icons.add_circle_rounded, size: 16)]), text: AppLocalizations.of(context).vetAnimalHealthTabConsult),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _OverviewTab(onConsultTap: () => _tab.animateTo(3)),
          const _RecordsTab(),
          const _VaccinationsTab(),
          _ConsultTab(onSaved: () => _tab.animateTo(1)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────
//  Tab 1 – Overview
// ──────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final VoidCallback onConsultTap;
  const _OverviewTab({required this.onConsultTap});

  @override
  Widget build(BuildContext context) {
    final sickCount       = mockAnimals.where((a) => a.status == AnimalStatus.sick).length;
    final activeRx        = mockTreatments.where((t) => t.status == TreatmentStatus.active).length;
    final overdueVax      = mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).length;
    final dueVax          = mockVaccinations.where((v) => v.status == VaccinationStatus.due).length;
    final highAlerts      = mockAlerts.where((a) => a.severity == AlertSeverity.high).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // ── Stats ──────────────────────────────────
        _SectionHeader(icon: Icons.bar_chart_rounded, label: AppLocalizations.of(context).vetAnimalHealthSummaryTitle, emoji: '📊'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.55,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _StatCard(
              icon: Icons.pets_rounded,
              label: AppLocalizations.of(context).vetAnimalHealthStatTotalAnimals,
              value: '${mockAnimals.length}',
              color: RumenoTheme.primaryGreen,
              emoji: '🐾',
            ),
            _StatCard(
              icon: Icons.sick_rounded,
              label: AppLocalizations.of(context).vetAnimalHealthStatSickTreating,
              value: '$sickCount active, $activeRx Rx',
              color: RumenoTheme.errorRed,
              emoji: '🤒',
            ),
            _StatCard(
              icon: Icons.vaccines_rounded,
              label: AppLocalizations.of(context).vetAnimalHealthStatVaccinesOverdue,
              value: '$overdueVax overdue, $dueVax due',
              color: overdueVax > 0 ? RumenoTheme.errorRed : RumenoTheme.warningYellow,
              emoji: '💉',
            ),
            _StatCard(
              icon: Icons.warning_amber_rounded,
              label: AppLocalizations.of(context).vetAnimalHealthStatUrgentAlerts,
              value: highAlerts > 0 ? '$highAlerts alerts' : 'All clear',
              color: highAlerts > 0 ? RumenoTheme.errorRed : RumenoTheme.successGreen,
              emoji: highAlerts > 0 ? '🚨' : '✅',
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Quick Actions ───────────────────────────
        _SectionHeader(icon: Icons.flash_on_rounded, label: AppLocalizations.of(context).commonQuickActions, emoji: '⚡'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _QuickActionBtn(icon: Icons.add_circle_rounded, label: AppLocalizations.of(context).vetAnimalHealthQuickActionNewConsult, color: RumenoTheme.primaryGreen, onTap: onConsultTap, emoji: '🆕')),
            const SizedBox(width: 10),
            Expanded(child: _QuickActionBtn(icon: Icons.vaccines_rounded, label: AppLocalizations.of(context).vetAnimalHealthQuickActionLogVaccine, color: RumenoTheme.infoBlue, onTap: () {}, emoji: '💉')),
            const SizedBox(width: 10),
            Expanded(child: _QuickActionBtn(icon: Icons.science_rounded, label: AppLocalizations.of(context).vetAnimalHealthQuickActionLabReport, color: RumenoTheme.accentOlive, onTap: () {}, emoji: '🧪')),
          ],
        ),
        const SizedBox(height: 20),

        // ── Alerts ─────────────────────────────────
        if (mockAlerts.isNotEmpty) ...[
          _SectionHeader(icon: Icons.notifications_active_rounded, label: AppLocalizations.of(context).vetAnimalHealthAlertsSection, emoji: '🚨'),
          const SizedBox(height: 10),
          ...mockAlerts.map((alert) => _AlertTile(alert: alert)),
          const SizedBox(height: 20),
        ],

        // ── Upcoming Events ─────────────────────────
        _SectionHeader(icon: Icons.event_rounded, label: AppLocalizations.of(context).vetAnimalHealthUpcomingEventsSection, emoji: '📅'),
        const SizedBox(height: 10),
        ...mockUpcomingEvents.map((evt) => _EventTile(evt: evt)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? emoji;
  const _SectionHeader({required this.icon, required this.label, this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
        ],
        Icon(icon, size: 18, color: RumenoTheme.primaryGreen),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: RumenoTheme.textDark)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String emoji;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? emoji;
  const _QuickActionBtn({required this.icon, required this.label, required this.color, required this.onTap, this.emoji});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            if (emoji != null)
              Text(emoji!, style: const TextStyle(fontSize: 26))
            else
              Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final AlertItem alert;
  const _AlertTile({required this.alert});

  Color get _col {
    switch (alert.severity) {
      case AlertSeverity.high:   return RumenoTheme.errorRed;
      case AlertSeverity.medium: return RumenoTheme.warningYellow;
      case AlertSeverity.low:    return RumenoTheme.successGreen;
    }
  }

  IconData get _icon {
    switch (alert.severity) {
      case AlertSeverity.high:   return Icons.error_rounded;
      case AlertSeverity.medium: return Icons.warning_amber_rounded;
      case AlertSeverity.low:    return Icons.info_rounded;
    }
  }

  String get _emoji {
    switch (alert.severity) {
      case AlertSeverity.high:   return '🚨';
      case AlertSeverity.medium: return '⚠️';
      case AlertSeverity.low:    return 'ℹ️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _col.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _col, width: 5)),
      ),
      child: Row(
        children: [
          Text(_emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text(alert.message, style: TextStyle(fontSize: 14, color: RumenoTheme.textDark, fontWeight: FontWeight.w500))),
          Text('📅 ${DateFormat('d MMM').format(alert.date)}', style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final UpcomingEvent evt;
  const _EventTile({required this.evt});

  Color _typeColor(String t) {
    switch (t) {
      case 'Vaccination': return RumenoTheme.infoBlue;
      case 'Treatment':   return RumenoTheme.errorRed;
      case 'Breeding':    return const Color(0xFF9C27B0);
      case 'Health':      return RumenoTheme.primaryGreen;
      default:            return RumenoTheme.accentOlive;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Vaccination': return Icons.vaccines_rounded;
      case 'Treatment':   return Icons.medical_services_rounded;
      case 'Breeding':    return Icons.favorite_rounded;
      case 'Health':      return Icons.health_and_safety_rounded;
      default:            return Icons.event_rounded;
    }
  }

  String _typeEmoji(String t) {
    switch (t) {
      case 'Vaccination': return '💉';
      case 'Treatment':   return '💊';
      case 'Breeding':    return '❤️';
      case 'Health':      return '🩺';
      default:            return '📅';
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = evt.date.difference(DateTime.now()).inDays;
    final color = _typeColor(evt.eventType);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Text(_typeEmoji(evt.eventType), style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(evt.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
                Text(evt.eventType, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(DateFormat('d MMM').format(evt.date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
              Text(daysLeft <= 0 ? '🟢 Today' : daysLeft == 1 ? '🟡 Tomorrow' : '📅 in $daysLeft days',
                  style: TextStyle(fontSize: 12, color: daysLeft <= 1 ? RumenoTheme.errorRed : RumenoTheme.textGrey, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────
//  Tab 2 – Health Records
// ──────────────────────────────────────

class _RecordsTab extends StatefulWidget {
  const _RecordsTab();

  @override
  State<_RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<_RecordsTab> {
  TreatmentStatus? _filter;  // null = all

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == null
        ? mockTreatments
        : mockTreatments.where((t) => t.status == _filter).toList();

    return Column(
      children: [
        // Filter bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: AppLocalizations.of(context).commonAll,
                  icon: Icons.list_rounded,
                  selected: _filter == null,
                  color: RumenoTheme.primaryGreen,
                  onTap: () => setState(() => _filter = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: AppLocalizations.of(context).commonActive,
                  icon: Icons.local_hospital_rounded,
                  selected: _filter == TreatmentStatus.active,
                  color: RumenoTheme.errorRed,
                  onTap: () => setState(() => _filter = TreatmentStatus.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: AppLocalizations.of(context).commonFollowUp,
                  icon: Icons.schedule_rounded,
                  selected: _filter == TreatmentStatus.followUp,
                  color: RumenoTheme.warningYellow,
                  onTap: () => setState(() => _filter = TreatmentStatus.followUp),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: AppLocalizations.of(context).commonCompleted,
                  icon: Icons.check_circle_rounded,
                  selected: _filter == TreatmentStatus.completed,
                  color: RumenoTheme.successGreen,
                  onTap: () => setState(() => _filter = TreatmentStatus.completed),
                ),
              ],
            ),
          ),
        ),
        // List
        Expanded(
          child: filtered.isEmpty
              ? _EmptyState(emoji: '🩺', message: AppLocalizations.of(context).vetAnimalHealthNoRecords)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _TreatmentCard(record: filtered[i]),
                ),
        ),
      ],
    );
  }
}

class _TreatmentCard extends StatefulWidget {
  final TreatmentRecord record;
  const _TreatmentCard({required this.record});

  @override
  State<_TreatmentCard> createState() => _TreatmentCardState();
}

class _TreatmentCardState extends State<_TreatmentCard> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return RumenoTheme.errorRed;
      case TreatmentStatus.completed: return RumenoTheme.successGreen;
      case TreatmentStatus.followUp:  return RumenoTheme.warningYellow;
    }
  }

  String get _statusEmoji {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return '🚨';
      case TreatmentStatus.completed: return '✅';
      case TreatmentStatus.followUp:  return '🔄';
    }
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return l10n.commonActive;
      case TreatmentStatus.completed: return l10n.commonCompleted;
      case TreatmentStatus.followUp:  return l10n.commonFollowUp;
    }
  }

  IconData get _statusIcon {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return Icons.local_hospital_rounded;
      case TreatmentStatus.completed: return Icons.check_circle_rounded;
      case TreatmentStatus.followUp:  return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final animal = _animalById(widget.record.animalId);
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: _statusColor, width: 5)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Animal icon
                      if (animal != null) ...[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _speciesColor(animal.species).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text(_speciesEmoji(animal.species), style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${animal.breed}  •  ${animal.tagId}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: RumenoTheme.textDark)),
                              Text('${animal.speciesName} • ${animal.statusLabel}',
                                  style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                            ],
                          ),
                        ),
                      ] else
                        Expanded(child: Text('Animal #${widget.record.animalId}', style: const TextStyle(fontWeight: FontWeight.w700))),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_statusEmoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(_statusLabel(l10n), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _statusColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Diagnosis
                  Row(
                    children: [
                      const Text('🧬 ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(widget.record.diagnosis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
                      ),
                    ],
                  ),
                  // Symptoms chips
                  if (widget.record.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: widget.record.symptoms.map((s) {
                        final ic = _symptomIcons[s] ?? Icons.circle;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: RumenoTheme.errorRed.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: RumenoTheme.errorRed.withValues(alpha: 0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(ic, size: 12, color: RumenoTheme.errorRed),
                              const SizedBox(width: 4),
                              Text(s, style: const TextStyle(fontSize: 11, color: RumenoTheme.errorRed, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  // Dates row
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('📅 ', style: TextStyle(fontSize: 14)),
                      Text(l10n.vetAnimalHealthTreatmentStarted(DateFormat('d MMM yyyy').format(widget.record.startDate)),
                          style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
                      if (widget.record.followUpDate != null) ...[
                        const SizedBox(width: 10),
                        const Text('🔄 ', style: TextStyle(fontSize: 14)),
                        Text(l10n.vetFarmDetailFollowUpDate(DateFormat('d MMM').format(widget.record.followUpDate!)),
                            style: const TextStyle(fontSize: 12, color: RumenoTheme.warningYellow, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // ── Expand button ──
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_expanded ? l10n.vetAnimalHealthHideDetails : l10n.vetAnimalHealthViewDetails,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor)),
                    Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: _statusColor),
                  ],
                ),
              ),
            ),
            // ── Expanded details ──
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 14),
                    _DetailRow(icon: Icons.vaccines_rounded, label: l10n.vetAnimalHealthDetailTreatmentLabel, value: widget.record.treatment, emoji: '💊'),
                    if (widget.record.vetName.isNotEmpty)
                      _DetailRow(icon: Icons.person_rounded, label: l10n.vetAnimalHealthDetailVetLabel, value: widget.record.vetName, emoji: '👨‍⚕️'),
                    if (widget.record.withdrawalDays != null)
                      _DetailRow(icon: Icons.do_not_disturb_on_rounded, label: l10n.vetAnimalHealthDetailWithdrawalLabel, value: l10n.vetAnimalHealthWithdrawalValue(widget.record.withdrawalDays!), emoji: '⚠️'),
                    if (widget.record.endDate != null)
                      _DetailRow(icon: Icons.event_available_rounded, label: l10n.vetAnimalHealthDetailEndedLabel, value: DateFormat('d MMM yyyy').format(widget.record.endDate!), emoji: '📅'),
                    if (widget.record.notes != null)
                      _DetailRow(icon: Icons.notes_rounded, label: l10n.commonNotes, value: widget.record.notes!, emoji: '📝'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? emoji;
  const _DetailRow({required this.icon, required this.label, required this.value, this.emoji});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
          ] else ...[
            Icon(icon, size: 14, color: RumenoTheme.primaryGreen),
            const SizedBox(width: 6),
          ],
          Text('$label: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: RumenoTheme.textGrey))),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────
//  Tab 3 – Vaccinations
// ──────────────────────────────────────

class _VaccinationsTab extends StatefulWidget {
  const _VaccinationsTab();

  @override
  State<_VaccinationsTab> createState() => _VaccinationsTabState();
}

class _VaccinationsTabState extends State<_VaccinationsTab> {
  VaccinationStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == null
        ? mockVaccinations
        : mockVaccinations.where((v) => v.status == _filter).toList();

    return Column(
      children: [
        // Filter bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: AppLocalizations.of(context).commonAll, icon: Icons.list_rounded, selected: _filter == null, color: RumenoTheme.primaryGreen, onTap: () => setState(() => _filter = null)),
                const SizedBox(width: 8),
                _FilterChip(label: AppLocalizations.of(context).commonOverdue, icon: Icons.warning_rounded, selected: _filter == VaccinationStatus.overdue, color: RumenoTheme.errorRed, onTap: () => setState(() => _filter = VaccinationStatus.overdue)),
                const SizedBox(width: 8),
                _FilterChip(label: AppLocalizations.of(context).commonDueSoon, icon: Icons.schedule_rounded, selected: _filter == VaccinationStatus.due, color: RumenoTheme.warningYellow, onTap: () => setState(() => _filter = VaccinationStatus.due)),
                const SizedBox(width: 8),
                _FilterChip(label: AppLocalizations.of(context).commonDone, icon: Icons.check_circle_rounded, selected: _filter == VaccinationStatus.done, color: RumenoTheme.successGreen, onTap: () => setState(() => _filter = VaccinationStatus.done)),
              ],
            ),
          ),
        ),
        // Summary row
        Container(
          color: const Color(0xFFF8F8F8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _VaxStat(count: mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).length, label: AppLocalizations.of(context).commonOverdue, color: RumenoTheme.errorRed),
              _VaxStat(count: mockVaccinations.where((v) => v.status == VaccinationStatus.due).length, label: AppLocalizations.of(context).commonDue, color: RumenoTheme.warningYellow),
              _VaxStat(count: mockVaccinations.where((v) => v.status == VaccinationStatus.done).length, label: AppLocalizations.of(context).commonDone, color: RumenoTheme.successGreen),
            ],
          ),
        ),
        // List
        Expanded(
          child: filtered.isEmpty
              ? _EmptyState(emoji: '💉', message: AppLocalizations.of(context).vetAnimalHealthNoVaccinations)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _VaccineCard(record: filtered[i]),
                ),
        ),
      ],
    );
  }
}

class _VaxStat extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _VaxStat({required this.count, required this.label, required this.color});

  String get _emoji {
    if (color == RumenoTheme.errorRed) return '🚨';
    if (color == RumenoTheme.warningYellow) return '⏳';
    return '✅';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 5),
        Text('$count $label', style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _VaccineCard extends StatelessWidget {
  final VaccinationRecord record;
  const _VaccineCard({required this.record});

  Color get _col {
    switch (record.status) {
      case VaccinationStatus.done:    return RumenoTheme.successGreen;
      case VaccinationStatus.due:     return RumenoTheme.warningYellow;
      case VaccinationStatus.overdue: return RumenoTheme.errorRed;
    }
  }

  IconData get _icon {
    switch (record.status) {
      case VaccinationStatus.done:    return Icons.check_circle_rounded;
      case VaccinationStatus.due:     return Icons.schedule_rounded;
      case VaccinationStatus.overdue: return Icons.warning_rounded;
    }
  }

  String get _statusEmoji {
    switch (record.status) {
      case VaccinationStatus.done:    return '✅';
      case VaccinationStatus.due:     return '⏳';
      case VaccinationStatus.overdue: return '🚨';
    }
  }

  String _labelFor(AppLocalizations l10n) {
    switch (record.status) {
      case VaccinationStatus.done:    return '✅ ${l10n.commonDone}';
      case VaccinationStatus.due:     return '⏳ ${l10n.commonDueSoon}';
      case VaccinationStatus.overdue: return '🚨 ${l10n.commonOverdue}!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final animal = _animalById(record.animalId);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
        border: Border.all(color: _col.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          // Vaccine icon
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: _col.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.vaccines_rounded, color: _col, size: 22),
                if (record.dose != null)
                  Text(record.dose!, style: TextStyle(fontSize: 9, color: _col, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.vaccineName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: RumenoTheme.textDark)),
                const SizedBox(height: 2),
                if (animal != null)
                  Row(
                    children: [
                      Text(_speciesEmoji(animal.species), style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text('${animal.breed}  •  ${animal.tagId}',
                          style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('📅 ', style: TextStyle(fontSize: 14)),
                    Text(
                      record.status == VaccinationStatus.done
                          ? l10n.vetFarmDetailGivenDate(DateFormat('d MMM yyyy').format(record.dateAdministered!))
                          : l10n.vetFarmDetailDueDate(DateFormat('d MMM yyyy').format(record.dueDate)),
                      style: TextStyle(fontSize: 12, color: record.status == VaccinationStatus.overdue ? RumenoTheme.errorRed : RumenoTheme.textGrey, fontWeight: record.status == VaccinationStatus.overdue ? FontWeight.w700 : FontWeight.normal),
                    ),
                  ],
                ),
                if (record.nextDueDate != null) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text('🔄 ', style: TextStyle(fontSize: 14)),
                      Text(l10n.vetFarmDetailNextDate(DateFormat('d MMM yyyy').format(record.nextDueDate!)),
                          style: const TextStyle(fontSize: 12, color: RumenoTheme.infoBlue)),
                    ],
                  ),
                ],
                if (record.vetName != null) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text('👨‍⚕️ ', style: TextStyle(fontSize: 14)),
                      Text(record.vetName!, style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Status column
          Column(
            children: [
              Text(_statusEmoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: _col.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(_labelFor(l10n), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _col)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────
//  Tab 4 – New Consultation
// ──────────────────────────────────────

class _ConsultTab extends StatefulWidget {
  final VoidCallback onSaved;
  const _ConsultTab({required this.onSaved});

  @override
  State<_ConsultTab> createState() => _ConsultTabState();
}

class _ConsultTabState extends State<_ConsultTab> {
  final _diagnosisCtrl   = TextEditingController();
  final _treatmentCtrl   = TextEditingController();
  final _medicinesCtrl   = TextEditingController();
  final _notesCtrl       = TextEditingController();
  Animal? _selectedAnimal = mockAnimals.first;
  String? _selectedFollowUp;
  final _symptoms = <String>{};

  static const _allSymptoms = [
    'Fever', 'Loss of appetite', 'Lethargy', 'Lameness',
    'Swelling', 'Diarrhea', 'Cough', 'Nasal discharge', 'Reduced milk',
  ];

  static const _followUpOptions = [
    'No follow-up', 'After 3 days', 'After 1 week', 'After 2 weeks', 'After 1 month',
  ];

  String _symptomLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Loss of appetite':  return l10n.vetAnimalHealthSymptomLossOfAppetite;
      case 'Lethargy':          return l10n.vetAnimalHealthSymptomLethargy;
      case 'Lameness':          return l10n.vetAnimalHealthSymptomLameness;
      case 'Swelling':          return l10n.vetAnimalHealthSymptomSwelling;
      case 'Diarrhea':          return l10n.vetAnimalHealthSymptomDiarrhea;
      case 'Cough':             return l10n.vetAnimalHealthSymptomCough;
      case 'Nasal discharge':   return l10n.vetAnimalHealthSymptomNasalDischarge;
      case 'Reduced milk':      return l10n.vetAnimalHealthSymptomReducedMilk;
      default:                  return l10n.vetAnimalHealthSymptomFever;
    }
  }

  String _followUpLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'After 3 days':   return l10n.vetAnimalHealthConsultFollowUp3Days;
      case 'After 1 week':   return l10n.vetAnimalHealthConsultFollowUp1Week;
      case 'After 2 weeks':  return l10n.vetAnimalHealthConsultFollowUp2Weeks;
      case 'After 1 month':  return l10n.vetAnimalHealthConsultFollowUp1Month;
      default:               return l10n.vetAnimalHealthConsultFollowUpNone;
    }
  }
  @override
  void dispose() {
    _diagnosisCtrl.dispose();
    _treatmentCtrl.dispose();
    _medicinesCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    if (_diagnosisCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 8), Text(l10n.vetAnimalHealthConsultErrorDiagnosis)]),
          backgroundColor: RumenoTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // Reset form
    _diagnosisCtrl.clear();
    _treatmentCtrl.clear();
    _medicinesCtrl.clear();
    _notesCtrl.clear();
    setState(() {
      _symptoms.clear();
      _selectedFollowUp = null;
      _selectedAnimal = mockAnimals.first;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.white), const SizedBox(width: 8), Text(l10n.vetAnimalHealthConsultSaveSuccess)]),
        backgroundColor: RumenoTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header banner ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [RumenoTheme.primaryGreen, RumenoTheme.accentOlive], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 6),
                const Text('🩺', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(
                  child: Builder(
                    builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.vetAnimalHealthConsultTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(l10n.vetAnimalHealthConsultSubtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Step 1: Select Animal ──
          _StepLabel(step: '1', icon: Icons.pets_rounded, label: AppLocalizations.of(context).vetAnimalHealthConsultStepSelectAnimal),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.4)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Animal>(
                value: _selectedAnimal,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded, color: RumenoTheme.primaryGreen),
                onChanged: (a) => setState(() => _selectedAnimal = a),
                selectedItemBuilder: (ctx) => mockAnimals.map((a) => Row(
                  children: [
                    Text(_speciesEmoji(a.species), style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(a.breed, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('${a.speciesName}  •  ${a.tagId}', style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                      ],
                    ),
                  ],
                )).toList(),
                items: mockAnimals.map((a) => DropdownMenuItem<Animal>(
                  value: a,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: _speciesColor(a.species).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: Text(_speciesEmoji(a.species), style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${a.breed}  •  ${a.tagId}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('${a.speciesName}  •  ${a.ageString}  •  ${a.statusLabel}',
                              style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                        ],
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Step 2: Symptoms ──
          _StepLabel(step: '2', icon: Icons.sick_rounded, label: AppLocalizations.of(context).vetAnimalHealthConsultStepSymptoms),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _allSymptoms.map((s) {
              final selected = _symptoms.contains(s);
              final ic = _symptomIcons[s] ?? Icons.circle;
              final displayLabel = _symptomLabel(s, AppLocalizations.of(context));
              return GestureDetector(
                onTap: () => setState(() => selected ? _symptoms.remove(s) : _symptoms.add(s)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: selected ? RumenoTheme.errorRed.withValues(alpha: 0.12) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? RumenoTheme.errorRed : Colors.grey.withValues(alpha: 0.25),
                      width: selected ? 2 : 1,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(ic, size: 24, color: selected ? RumenoTheme.errorRed : RumenoTheme.textGrey),
                      const SizedBox(height: 4),
                      Text(displayLabel, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                              color: selected ? RumenoTheme.errorRed : RumenoTheme.textGrey)),
                      if (selected)
                        const Icon(Icons.check_circle_rounded, size: 12, color: RumenoTheme.errorRed),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // ── Step 3: Diagnosis & Treatment ──
          _StepLabel(step: '3', icon: Icons.biotech_rounded, label: AppLocalizations.of(context).vetAnimalHealthConsultStepDiagnosis),
          const SizedBox(height: 10),
          _InputField(controller: _diagnosisCtrl, label: AppLocalizations.of(context).vetAnimalHealthConsultDiagnosisLabel, icon: Icons.biotech_rounded, hint: AppLocalizations.of(context).vetAnimalHealthConsultDiagnosisHint),
          const SizedBox(height: 12),
          _InputField(controller: _treatmentCtrl, label: AppLocalizations.of(context).vetAnimalHealthConsultTreatmentLabel, icon: Icons.medical_services_rounded, hint: AppLocalizations.of(context).vetAnimalHealthConsultTreatmentHint, maxLines: 2),
          const SizedBox(height: 12),
          _InputField(controller: _medicinesCtrl, label: AppLocalizations.of(context).vetAnimalHealthConsultMedicinesLabel, icon: Icons.medication_rounded, hint: AppLocalizations.of(context).vetAnimalHealthConsultMedicinesHint),
          const SizedBox(height: 12),
          _InputField(controller: _notesCtrl, label: AppLocalizations.of(context).commonNotes, icon: Icons.notes_rounded, hint: AppLocalizations.of(context).vetAnimalHealthConsultNotesHint, maxLines: 3),
          const SizedBox(height: 20),

          // ── Step 4: Follow-up ──
          _StepLabel(step: '4', icon: Icons.event_repeat_rounded, label: AppLocalizations.of(context).vetAnimalHealthConsultStepFollowUp),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _followUpOptions.map((f) {
              final sel = _selectedFollowUp == f;
              final displayLabel = _followUpLabel(f, AppLocalizations.of(context));
              return GestureDetector(
                onTap: () => setState(() => _selectedFollowUp = sel ? null : f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? RumenoTheme.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: sel ? RumenoTheme.primaryGreen : Colors.grey.withValues(alpha: 0.3)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(sel ? Icons.event_available_rounded : Icons.event_rounded, size: 16,
                          color: sel ? Colors.white : RumenoTheme.textGrey),
                      const SizedBox(width: 6),
                      Text(displayLabel, style: TextStyle(fontSize: 13, color: sel ? Colors.white : RumenoTheme.textDark,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // ── Save button ──
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: RumenoTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _save,
              icon: const Icon(Icons.save_rounded, size: 24),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✅ ', style: TextStyle(fontSize: 18)),
                  Text(AppLocalizations.of(context).vetAnimalHealthConsultSaveButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String step;
  final IconData icon;
  final String label;
  const _StepLabel({required this.step, required this.icon, required this.label});

  static const _stepEmojis = ['1️⃣', '2️⃣', '3️⃣', '4️⃣'];

  @override
  Widget build(BuildContext context) {
    final idx = int.tryParse(step);
    final stepEmoji = (idx != null && idx >= 1 && idx <= 4) ? _stepEmojis[idx - 1] : step;
    return Row(
      children: [
        Text(stepEmoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Icon(icon, size: 20, color: RumenoTheme.primaryGreen),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: RumenoTheme.textDark)),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final int maxLines;
  const _InputField({required this.controller, required this.label, required this.icon, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: RumenoTheme.primaryGreen, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
      ),
    );
  }
}

// ──────────────────────────────────────
//  Shared Widgets
// ──────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final String? emoji;
  const _FilterChip({required this.label, required this.icon, required this.selected, required this.color, required this.onTap, this.emoji});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: TextStyle(fontSize: 16, color: selected ? Colors.white : null)),
              const SizedBox(width: 5),
            ] else ...[
              Icon(icon, size: 14, color: selected ? Colors.white : color),
              const SizedBox(width: 5),
            ],
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : color)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String message;
  const _EmptyState({required this.emoji, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 15, color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}
