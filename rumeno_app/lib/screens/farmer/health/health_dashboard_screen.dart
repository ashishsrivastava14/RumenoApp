import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/cards/health_record_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overdueCount =
        mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).length;
    final activeCount =
        mockTreatments.where((t) => t.status == TreatmentStatus.active).length;
    final followUpCount =
        mockTreatments.where((t) => t.status == TreatmentStatus.followUp).length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Health Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/farmer/dashboard');
            }
          },
        ),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            if (overdueCount > 0) _alertBanner(context, overdueCount),
            // Status row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _StatTile(emoji: '✅', label: 'Healthy', count: 38, color: RumenoTheme.successGreen),
                  const SizedBox(width: 10),
                  _StatTile(emoji: '🤒', label: 'Sick', count: activeCount, color: RumenoTheme.errorRed),
                  const SizedBox(width: 10),
                  _StatTile(emoji: '⚠️', label: 'Follow-up', count: followUpCount, color: RumenoTheme.warningYellow),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('What do you need?'),
            const SizedBox(height: 10),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _sectionTitle('🔔  Alerts'),
            const SizedBox(height: 6),
            _buildAlerts(context),
            const SizedBox(height: 8),
            _sectionTitleWithAction(
              '💉  Upcoming Vaccinations',
              'See All',
              () => context.go('/farmer/health/vaccination'),
            ),
            const SizedBox(height: 4),
            ...mockVaccinations
                .where((v) => v.status != VaccinationStatus.done)
                .take(3)
                .map((v) => VaccinationCard(
                      record: v,
                      onTap: () => context.go('/farmer/health/vaccination'),
                    )),
            const SizedBox(height: 8),
            _sectionTitleWithAction(
              '🩺  Active Treatments',
              'See All',
              () => context.go('/farmer/health/treatment'),
            ),
            const SizedBox(height: 4),
            ...mockTreatments
                .where((t) => t.status == TreatmentStatus.active)
                .take(3)
                .map((t) => HealthRecordCard(
                      record: t,
                      onTap: () => context.go('/farmer/health/treatment'),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _alertBanner(BuildContext context, int count) {
    return GestureDetector(
      onTap: () => context.go('/farmer/health/vaccination'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: RumenoTheme.errorRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RumenoTheme.errorRed.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_rounded,
                  color: RumenoTheme.errorRed, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count Vaccination${count > 1 ? 's' : ''} Overdue!',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: RumenoTheme.errorRed,
                        fontSize: 15),
                  ),
                  const Text(
                    'Tap to take action now',
                    style: TextStyle(color: RumenoTheme.errorRed, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: RumenoTheme.errorRed),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final items = [
      {
        'e': '💉',
        'l': 'Vaccinations',
        's': 'Schedule & records',
        'c': RumenoTheme.infoBlue,
        'r': '/farmer/health/vaccination'
      },
      {
        'e': '🩺',
        'l': 'Treatments',
        's': 'Medicines & diagnosis',
        'c': RumenoTheme.errorRed,
        'r': '/farmer/health/treatment'
      },
      {
        'e': '🪱',
        'l': 'Deworming',
        's': 'Antiparasitic schedule',
        'c': RumenoTheme.accentOlive,
        'r': '/farmer/health/deworming'
      },
      {
        'e': '🔬',
        'l': 'Lab Reports',
        's': 'Test results & history',
        'c': RumenoTheme.warmBrown,
        'r': '/farmer/health/lab-reports'
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.65,
        children: items.map((a) {
          final col = a['c'] as Color;
          return GestureDetector(
            onTap: () {
              if (a['r'] != null) {
                context.go(a['r'] as String);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${a['l']} coming soon'),
                    backgroundColor: col,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: col.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: col.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(color: col.withValues(alpha: 0.08), blurRadius: 8)
                ],
              ),
              child: Row(
                children: [
                  Text(a['e'] as String, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(a['l'] as String,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: col)),
                        Text(a['s'] as String,
                            style: const TextStyle(
                                fontSize: 10, color: RumenoTheme.textGrey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAlerts(BuildContext context) {
    return Column(
      children: mockAlerts.take(4).map((a) {
        Color c;
        IconData ic;
        switch (a.severity) {
          case AlertSeverity.high:
            c = RumenoTheme.errorRed;
            ic = Icons.warning_rounded;
            break;
          case AlertSeverity.medium:
            c = RumenoTheme.warningYellow;
            ic = Icons.info_rounded;
            break;
          case AlertSeverity.low:
            c = RumenoTheme.successGreen;
            ic = Icons.check_circle_rounded;
            break;
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: c, width: 4)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)
            ],
          ),
          child: Row(
            children: [
              Icon(ic, color: c, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(a.message,
                    style: const TextStyle(
                        fontSize: 13, color: RumenoTheme.textDark)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(t,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: RumenoTheme.textDark)),
      );

  Widget _sectionTitleWithAction(String t, String action, VoidCallback onTap) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: RumenoTheme.textDark)),
            GestureDetector(
              onTap: onTap,
              child: Text(action,
                  style: const TextStyle(
                      color: RumenoTheme.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final Color color;

  const _StatTile(
      {required this.emoji,
      required this.label,
      required this.count,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text('$count',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: RumenoTheme.textGrey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
