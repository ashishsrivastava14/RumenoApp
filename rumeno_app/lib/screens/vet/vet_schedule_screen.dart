import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';

class VetScheduleScreen extends StatelessWidget {
  const VetScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sorted = List<UpcomingEvent>.from(mockUpcomingEvents)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Group events by date string
    final Map<String, List<UpcomingEvent>> grouped = {};
    for (final e in sorted) {
      final key = DateFormat('EEE, dd MMM yyyy').format(e.date);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    // Also include vaccination due/overdue
    final upcomingVaccinations = mockVaccinations
        .where((v) =>
            v.status == VaccinationStatus.due ||
            v.status == VaccinationStatus.overdue)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vetScheduleTitle),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Upcoming Events section
          if (grouped.isNotEmpty) ...[
            _SectionTitle(title: AppLocalizations.of(context).vetScheduleSectionVisits, count: sorted.length, emoji: '📅'),
            const SizedBox(height: 8),
            ...grouped.entries.map((entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DateHeader(label: entry.key),
                    const SizedBox(height: 6),
                    ...entry.value.map((e) => _EventCard(event: e)),
                    const SizedBox(height: 10),
                  ],
                )),
          ],

          // Pending vaccinations
          if (upcomingVaccinations.isNotEmpty) ...[
            const SizedBox(height: 4),
            _SectionTitle(
                title: AppLocalizations.of(context).vetScheduleSectionVaccinations,
                count: upcomingVaccinations.length,
                emoji: '💉'),
            const SizedBox(height: 8),
            ...upcomingVaccinations
                .map((v) => _VaccinationEventCard(record: v)),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;
  final String? emoji;
  const _SectionTitle({required this.title, required this.count, this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
        ],
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: RumenoTheme.primaryGreen)),
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📆 ', style: TextStyle(fontSize: 16)),
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: RumenoTheme.primaryGreen)),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final UpcomingEvent event;
  const _EventCard({required this.event});

  (Color, IconData, String) _typeInfo(String type) {
    switch (type) {
      case 'Vaccination':
        return (Colors.teal, Icons.vaccines_rounded, '💉');
      case 'Breeding':
        return (Colors.purple, Icons.favorite_rounded, '❤️');
      case 'Treatment':
        return (Colors.red, Icons.medical_services_rounded, '💊');
      case 'Health':
        return (Colors.orange, Icons.health_and_safety_rounded, '🩺');
      default:
        return (RumenoTheme.primaryGreen, Icons.event_rounded, '📅');
    }
  }

  String _animalName(String? id) {
    if (id == null) return '';
    try {
      final a = mockAnimals.firstWhere((a) => a.id == id);
      return '${a.breed} (${a.tagId})';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon, emoji) = _typeInfo(event.eventType);
    final animalName = _animalName(event.animalId);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                if (animalName.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Text('🐾 ', style: TextStyle(fontSize: 14)),
                      Text(animalName,
                          style: TextStyle(
                              fontSize: 13, color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(event.eventType,
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              Text('🕒 ${DateFormat('hh:mm a').format(event.date)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}

class _VaccinationEventCard extends StatelessWidget {
  final VaccinationRecord record;
  const _VaccinationEventCard({required this.record});

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
    final isOverdue = record.status == VaccinationStatus.overdue;
    final color = isOverdue ? Colors.red : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Text(isOverdue ? '🚨' : '⏳', style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💉 ${record.vaccineName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Text('🐾 ', style: TextStyle(fontSize: 14)),
                    Text(_animalName(record.animalId),
                        style: TextStyle(
                            fontSize: 13, color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(isOverdue ? '🚨 ${AppLocalizations.of(context).commonOverdue}' : '⏳ ${AppLocalizations.of(context).commonDue}',
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 4),
              Text('📅 ${DateFormat('dd MMM yyyy').format(record.dueDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
