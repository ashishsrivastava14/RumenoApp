import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../models/models.dart';

String _vaccSpeciesEmoji(Species s) {
  switch (s) {
    case Species.cow:    return '🐄';
    case Species.buffalo: return '🐃';
    case Species.goat:   return '🐐';
    case Species.sheep:  return '🐑';
    case Species.pig:    return '🐷';
    case Species.horse:  return '🐴';
  }
}

class VaccinationCard extends StatelessWidget {
  final VaccinationRecord record;
  final VoidCallback? onTap;

  const VaccinationCard({super.key, required this.record, this.onTap});

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

  String get _label {
    switch (record.status) {
      case VaccinationStatus.done:    return 'Done ✓';
      case VaccinationStatus.due:     return 'Due Soon';
      case VaccinationStatus.overdue: return 'Overdue!';
    }
  }

  Animal? get _animal {
    try { return mockAnimals.firstWhere((a) => a.id == record.animalId); } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    final animal = _animal;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _col.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            // Vaccine icon block
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
                  Text(record.vaccineName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: RumenoTheme.textDark)),
                  const SizedBox(height: 3),
                  if (animal != null)
                    Row(
                      children: [
                        Text(_vaccSpeciesEmoji(animal.species), style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text('${animal.breed}  •  ${animal.tagId}',
                            style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: RumenoTheme.textGrey),
                      const SizedBox(width: 4),
                      Text(
                        record.status == VaccinationStatus.done && record.dateAdministered != null
                            ? 'Given: ${DateFormat('d MMM yyyy').format(record.dateAdministered!)}'
                            : 'Due: ${DateFormat('d MMM yyyy').format(record.dueDate)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: record.status == VaccinationStatus.overdue ? RumenoTheme.errorRed : RumenoTheme.textGrey,
                          fontWeight: record.status == VaccinationStatus.overdue ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  if (record.nextDueDate != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.event_repeat_rounded, size: 12, color: RumenoTheme.infoBlue),
                        const SizedBox(width: 4),
                        Text('Next: ${DateFormat('d MMM yyyy').format(record.nextDueDate!)}',
                            style: const TextStyle(fontSize: 11, color: RumenoTheme.infoBlue)),
                      ],
                    ),
                  ],
                  if (record.vetName != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.person_rounded, size: 12, color: RumenoTheme.textGrey),
                        const SizedBox(width: 4),
                        Text(record.vetName!, style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Status indicator
            Column(
              children: [
                Icon(_icon, color: _col, size: 26),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: _col.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(_label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _col)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

