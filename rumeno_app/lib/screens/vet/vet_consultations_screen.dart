import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';

class VetConsultationsScreen extends StatefulWidget {
  const VetConsultationsScreen({super.key});

  @override
  State<VetConsultationsScreen> createState() => _VetConsultationsScreenState();
}

class _VetConsultationsScreenState extends State<VetConsultationsScreen> {
  TreatmentStatus? _filter;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mockTreatments.where((t) {
      final matchStatus = _filter == null || t.status == _filter;
      final matchSearch = _search.isEmpty ||
          t.diagnosis.toLowerCase().contains(_search.toLowerCase()) ||
          t.treatment.toLowerCase().contains(_search.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.vetConsultationsTitle),
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
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.vetConsultationsSearchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusChip(
                    label: l10n.commonAll,
                    selected: _filter == null,
                    color: RumenoTheme.primaryGreen,
                    onTap: () => setState(() => _filter = null),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: l10n.commonActive,
                    selected: _filter == TreatmentStatus.active,
                    color: Colors.red,
                    onTap: () => setState(() => _filter = TreatmentStatus.active),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: l10n.commonFollowUp,
                    selected: _filter == TreatmentStatus.followUp,
                    color: Colors.orange,
                    onTap: () =>
                        setState(() => _filter = TreatmentStatus.followUp),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: l10n.commonCompleted,
                    selected: _filter == TreatmentStatus.completed,
                    color: Colors.green,
                    onTap: () =>
                        setState(() => _filter = TreatmentStatus.completed),
                  ),
                ],
              ),
            ),
          ),
          // Count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} record${filtered.length != 1 ? 's' : ''}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(l10n.vetConsultationsEmpty))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) =>
                        _ConsultationCard(record: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Status Chip ─────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _StatusChip(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : Colors.grey.shade300, width: 1.2),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : RumenoTheme.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 12)),
      ),
    );
  }
}

// ── Consultation Card ───────────────────────────────────────────────────────

class _ConsultationCard extends StatelessWidget {
  final TreatmentRecord record;
  const _ConsultationCard({required this.record});

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
      final a = mockAnimals.firstWhere((a) => a.id == id);
      return '${a.breed} (${a.tagId})';
    } catch (_) {
      return 'Animal #$id';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _statusColor(record.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(record.diagnosis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_statusLabel(record.status, l10n),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.pets_rounded, size: 13, color: RumenoTheme.primaryGreen),
              const SizedBox(width: 4),
              Text(
                _animalName(record.animalId),
                style: TextStyle(
                    fontSize: 12,
                    color: RumenoTheme.primaryGreen,
                    fontWeight: FontWeight.w500),
              ),
              if (record.vetName.isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(Icons.person_rounded, size: 13, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(record.vetName,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(record.treatment,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 12, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(DateFormat('dd MMM yyyy').format(record.startDate),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              if (record.followUpDate != null) ...[
                const SizedBox(width: 10),
                Icon(Icons.update_rounded, size: 12, color: Colors.orange[400]),
                const SizedBox(width: 4),
                Text(
                    'Follow-up: ${DateFormat('dd MMM').format(record.followUpDate!)}',
                    style:
                        TextStyle(fontSize: 11, color: Colors.orange[700])),
              ],
              if (record.withdrawalDays != null) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('WD: ${record.withdrawalDays}d',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ],
          ),
          if (record.symptoms.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: record.symptoms
                  .take(4)
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
