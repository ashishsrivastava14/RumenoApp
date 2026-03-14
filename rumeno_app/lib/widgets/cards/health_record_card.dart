import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../models/models.dart';

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

class HealthRecordCard extends StatefulWidget {
  final TreatmentRecord record;
  final VoidCallback? onTap;

  const HealthRecordCard({super.key, required this.record, this.onTap});

  @override
  State<HealthRecordCard> createState() => _HealthRecordCardState();
}

class _HealthRecordCardState extends State<HealthRecordCard> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return RumenoTheme.errorRed;
      case TreatmentStatus.completed: return RumenoTheme.successGreen;
      case TreatmentStatus.followUp:  return RumenoTheme.warningYellow;
    }
  }

  String get _statusLabel {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return 'Active';
      case TreatmentStatus.completed: return 'Completed';
      case TreatmentStatus.followUp:  return 'Follow-up';
    }
  }

  IconData get _statusIcon {
    switch (widget.record.status) {
      case TreatmentStatus.active:    return Icons.local_hospital_rounded;
      case TreatmentStatus.completed: return Icons.check_circle_rounded;
      case TreatmentStatus.followUp:  return Icons.schedule_rounded;
    }
  }

  Animal? get _animal {
    try { return mockAnimals.firstWhere((a) => a.id == widget.record.animalId); } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    final animal = _animal;
    return GestureDetector(
      onTap: widget.onTap ?? () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: _statusColor, width: 5)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animal + status row
                  Row(
                    children: [
                      if (animal != null) ...[
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: _speciesColor(animal.species).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(11),
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
                              Text(animal.speciesName, style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                            ],
                          ),
                        ),
                      ] else
                        Expanded(child: Text('Animal #${widget.record.animalId}', style: const TextStyle(fontWeight: FontWeight.w700))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(color: _statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon, size: 13, color: _statusColor),
                            const SizedBox(width: 4),
                            Text(_statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Diagnosis
                  Row(
                    children: [
                      Icon(Icons.biotech_rounded, size: 15, color: RumenoTheme.primaryGreen),
                      const SizedBox(width: 6),
                      Expanded(child: Text(widget.record.diagnosis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RumenoTheme.textDark))),
                    ],
                  ),
                  // Symptoms
                  if (widget.record.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6, runSpacing: 4,
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
                  // Vet + dates
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person_rounded, size: 12, color: RumenoTheme.textGrey),
                      const SizedBox(width: 4),
                      Text(widget.record.vetName, style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                      const SizedBox(width: 10),
                      Icon(Icons.calendar_today_rounded, size: 12, color: RumenoTheme.textGrey),
                      const SizedBox(width: 4),
                      Text(DateFormat('d MMM yyyy').format(widget.record.startDate),
                          style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                    ],
                  ),
                  if (widget.record.followUpDate != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.event_repeat_rounded, size: 12, color: RumenoTheme.warningYellow),
                        const SizedBox(width: 4),
                        Text('Follow-up: ${DateFormat('d MMM').format(widget.record.followUpDate!)}',
                            style: const TextStyle(fontSize: 11, color: RumenoTheme.warningYellow, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Expand toggle
            if (widget.onTap == null)
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
                      Text(_expanded ? 'Hide' : 'Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor)),
                      Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: _statusColor),
                    ],
                  ),
                ),
              ),
            if (_expanded && widget.onTap == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 14),
                    _Row(icon: Icons.vaccines_rounded, label: 'Treatment', value: widget.record.treatment),
                    if (widget.record.withdrawalDays != null)
                      _Row(icon: Icons.do_not_disturb_on_rounded, label: 'Withdrawal', value: '${widget.record.withdrawalDays} days'),
                    if (widget.record.endDate != null)
                      _Row(icon: Icons.event_available_rounded, label: 'Ended', value: DateFormat('d MMM yyyy').format(widget.record.endDate!)),
                    if (widget.record.notes != null)
                      _Row(icon: Icons.notes_rounded, label: 'Notes', value: widget.record.notes!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: RumenoTheme.primaryGreen),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey))),
        ],
      ),
    );
  }
}

