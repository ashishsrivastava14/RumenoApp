import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class VaccinationCard extends StatelessWidget {
  final VaccinationRecord record;
  final VoidCallback? onTap;

  const VaccinationCard({super.key, required this.record, this.onTap});

  Color _statusColor(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.done: return RumenoTheme.successGreen;
      case VaccinationStatus.due: return RumenoTheme.warningYellow;
      case VaccinationStatus.overdue: return RumenoTheme.errorRed;
    }
  }

  String _statusLabel(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.done: return 'Done';
      case VaccinationStatus.due: return 'Due';
      case VaccinationStatus.overdue: return 'Overdue';
    }
  }

  IconData _statusIcon(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.done: return Icons.check_circle;
      case VaccinationStatus.due: return Icons.schedule;
      case VaccinationStatus.overdue: return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _statusColor(record.status).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.vaccines, color: _statusColor(record.status), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.vaccineName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Animal: ${record.animalId}${record.vetName != null ? ' • ${record.vetName}' : ''}', style: Theme.of(context).textTheme.bodySmall),
                  Text('Due: ${DateFormat('dd MMM yyyy').format(record.dueDate)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight)),
                ],
              ),
            ),
            Column(
              children: [
                Icon(_statusIcon(record.status), color: _statusColor(record.status), size: 20),
                const SizedBox(height: 4),
                Text(_statusLabel(record.status), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(record.status))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
