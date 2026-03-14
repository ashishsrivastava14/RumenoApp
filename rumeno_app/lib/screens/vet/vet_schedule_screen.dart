import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
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
        title: const Text('Upcoming Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/vet');
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
            _SectionTitle(title: 'Visits & Events', count: sorted.length),
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
                title: 'Pending Vaccinations',
                count: upcomingVaccinations.length),
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
  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 11,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: RumenoTheme.primaryGreen)),
    );
  }
}

class _EventCard extends StatelessWidget {
  final UpcomingEvent event;
  const _EventCard({required this.event});

  (Color, IconData) _typeInfo(String type) {
    switch (type) {
      case 'Vaccination':
        return (Colors.teal, Icons.vaccines_rounded);
      case 'Breeding':
        return (Colors.purple, Icons.favorite_rounded);
      case 'Treatment':
        return (Colors.red, Icons.medical_services_rounded);
      case 'Health':
        return (Colors.orange, Icons.health_and_safety_rounded);
      default:
        return (RumenoTheme.primaryGreen, Icons.event_rounded);
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
    final (color, icon) = _typeInfo(event.eventType);
    final animalName = _animalName(event.animalId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                if (animalName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(animalName,
                      style: TextStyle(
                          fontSize: 11, color: RumenoTheme.primaryGreen)),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(event.eventType,
                    style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              Text(DateFormat('hh:mm a').format(event.date),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500])),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.vaccines_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.vaccineName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text(_animalName(record.animalId),
                    style: TextStyle(
                        fontSize: 11, color: RumenoTheme.primaryGreen)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isOverdue ? 'Overdue' : 'Due',
                    style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              Text(DateFormat('dd MMM yyyy').format(record.dueDate),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }
}
