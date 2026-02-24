import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class HealthRecordCard extends StatelessWidget {
  final TreatmentRecord record;
  final VoidCallback? onTap;

  const HealthRecordCard({super.key, required this.record, this.onTap});

  Color _statusColor(TreatmentStatus s) {
    switch (s) {
      case TreatmentStatus.active:
        return RumenoTheme.errorRed;
      case TreatmentStatus.completed:
        return RumenoTheme.successGreen;
      case TreatmentStatus.followUp:
        return RumenoTheme.warningYellow;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: _statusColor(record.status), width: 4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(record.diagnosis, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(record.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_statusLabel(record.status), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(record.status))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Animal: ${record.animalId} • Vet: ${record.vetName}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('Treatment: ${record.treatment}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('Started: ${DateFormat('dd MMM yyyy').format(record.startDate)}${record.followUpDate != null ? ' • Follow-up: ${DateFormat('dd MMM').format(record.followUpDate!)}' : ''}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight)),
          ],
        ),
      ),
    );
  }
}
