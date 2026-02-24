import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/cards/health_record_card.dart';
import '../../../widgets/common/section_header.dart';

class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final healthyCount = 38;
    final sickCount = 5;
    final treatmentCount = 5;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Health Center'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.vaccines),
            onPressed: () => context.go('/farmer/health/vaccination'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          children: [
            // Summary cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _StatusCard(label: 'Healthy', count: healthyCount, color: RumenoTheme.successGreen, icon: Icons.check_circle),
                  const SizedBox(width: 10),
                  _StatusCard(label: 'Sick', count: sickCount, color: RumenoTheme.errorRed, icon: Icons.sick),
                  const SizedBox(width: 10),
                  _StatusCard(label: 'Treatment', count: treatmentCount, color: RumenoTheme.warningYellow, icon: Icons.healing),
                ],
              ),
            ),
            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.vaccines,
                      label: 'Vaccinations',
                      onTap: () => context.go('/farmer/health/vaccination'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.local_hospital,
                      label: 'Treatments',
                      onTap: () => context.go('/farmer/health/treatment'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.bug_report,
                      label: 'Deworming',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deworming module'))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Upcoming vaccinations
            SectionHeader(
              title: 'Upcoming Vaccinations',
              onAction: () => context.go('/farmer/health/vaccination'),
            ),
            ...mockVaccinations
                .where((v) => v.status != VaccinationStatus.done)
                .take(3)
                .map((v) => VaccinationCard(record: v)),
            // Recent treatments
            SectionHeader(
              title: 'Active Treatments',
              onAction: () => context.go('/farmer/health/treatment'),
            ),
            ...mockTreatments
                .where((t) => t.status == TreatmentStatus.active)
                .take(3)
                .map((t) => HealthRecordCard(record: t)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatusCard({required this.label, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: RumenoTheme.primaryGreen),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
