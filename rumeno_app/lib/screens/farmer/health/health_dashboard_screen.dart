import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/cards/health_record_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overdueCount =
        mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).length;
    final activeCount =
        mockTreatments.where((t) => t.status == TreatmentStatus.active).length;
    final followUpCount =
        mockTreatments.where((t) => t.status == TreatmentStatus.followUp).length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.healthDashboardTitle),
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
              l10n.commonSeeAll,
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
              l10n.commonSeeAll,
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
    final l10n = AppLocalizations.of(context);
    final items = [
      {
        'e': '💉',
        'l': l10n.healthCardVaccinations,
        's': 'Schedule & records',
        'c': RumenoTheme.infoBlue,
        'r': '/farmer/health/vaccination'
      },
      {
        'e': '🩺',
        'l': l10n.healthCardTreatments,
        's': 'Medicines & diagnosis',
        'c': RumenoTheme.errorRed,
        'r': '/farmer/health/treatment'
      },
      {
        'e': '🪱',
        'l': l10n.healthCardDeworming,
        's': 'Antiparasitic schedule',
        'c': RumenoTheme.accentOlive,
        'r': '/farmer/health/deworming'
      },
      {
        'e': '🔬',
        'l': l10n.healthCardLabReports,
        's': 'Test results & history',
        'c': RumenoTheme.warmBrown,
        'r': '/farmer/health/lab-reports'
      },
      {
        'e': '🦶',
        'l': l10n.healthCardHoofCutting,
        's': 'Trim & schedule',
        'c': const Color(0xFF8D6E63),
        'r': null,
        'action': 'hoof'
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
              if (a['action'] == 'hoof') {
                _showHoofCuttingSheet(context);
              } else if (a['r'] != null) {
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

  void _showHoofCuttingSheet(BuildContext context) {
    final animalIdCtrl = TextEditingController();
    String? selectedAnimal;
    DateTime? cuttingDate;
    DateTime? nextScheduleDate;

    const animalOptions = [
      {'emoji': '🐄', 'label': 'Cow'},
      {'emoji': '🐃', 'label': 'Buffalo'},
      {'emoji': '🐐', 'label': 'Goat'},
      {'emoji': '🐑', 'label': 'Sheep'},
      {'emoji': '🐖', 'label': 'Pig'},
      {'emoji': '🐴', 'label': 'Horse'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D6E63).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🦶', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hoof Cutting',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Record hoof trimming details',
                              style: TextStyle(
                                  fontSize: 13, color: RumenoTheme.textGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ─── Animal Type ───
                _hoofLabel('🐾', 'Which animal?'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: animalOptions.map((a) {
                    final label = a['label'] as String;
                    final emoji = a['emoji'] as String;
                    final isSelected = selectedAnimal == label;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedAnimal = label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8D6E63).withValues(alpha: 0.15)
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8D6E63)
                                  : RumenoTheme.textLight,
                              width: isSelected ? 2 : 1),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 4),
                            Text(label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF8D6E63)
                                      : RumenoTheme.textDark,
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ─── Animal ID ───
                _hoofLabel('🏷️', 'Animal ID / Tag'),
                const SizedBox(height: 8),
                TextField(
                  controller: animalIdCtrl,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'e.g. C-001, G-005, H-002',
                    hintStyle: const TextStyle(color: RumenoTheme.textLight),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Text(
                        selectedAnimal != null
                            ? animalOptions.firstWhere(
                                (a) => a['label'] == selectedAnimal)['emoji'] as String
                            : '🏷️',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: RumenoTheme.textLight)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: RumenoTheme.textLight)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFF8D6E63), width: 2)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Date (when it was done) ───
                _hoofLabel('📅', 'When was it done?'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: cuttingDate ?? DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                      helpText: 'PICK THE DATE',
                      confirmText: 'DONE ✅',
                      cancelText: 'CANCEL ❌',
                    );
                    if (picked != null) {
                      setModalState(() => cuttingDate = picked);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: cuttingDate != null
                          ? const Color(0xFF8D6E63).withValues(alpha: 0.08)
                          : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: cuttingDate != null
                              ? const Color(0xFF8D6E63)
                              : RumenoTheme.textLight,
                          width: cuttingDate != null ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        const Text('📅', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          cuttingDate != null
                              ? '${cuttingDate!.day.toString().padLeft(2, '0')} / '
                                '${cuttingDate!.month.toString().padLeft(2, '0')} / '
                                '${cuttingDate!.year}'
                              : 'Tap to pick date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: cuttingDate != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: cuttingDate != null
                                ? RumenoTheme.textDark
                                : RumenoTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Next Schedule ───
                _hoofLabel('🗓️', 'Next hoof cutting date?'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: nextScheduleDate ??
                          DateTime.now().add(const Duration(days: 60)),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                      helpText: 'PICK NEXT DATE',
                      confirmText: 'DONE ✅',
                      cancelText: 'CANCEL ❌',
                    );
                    if (picked != null) {
                      setModalState(() => nextScheduleDate = picked);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: nextScheduleDate != null
                          ? RumenoTheme.successGreen.withValues(alpha: 0.08)
                          : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: nextScheduleDate != null
                              ? RumenoTheme.successGreen
                              : RumenoTheme.textLight,
                          width: nextScheduleDate != null ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        const Text('🗓️', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          nextScheduleDate != null
                              ? '${nextScheduleDate!.day.toString().padLeft(2, '0')} / '
                                '${nextScheduleDate!.month.toString().padLeft(2, '0')} / '
                                '${nextScheduleDate!.year}'
                              : 'Tap to pick date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: nextScheduleDate != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: nextScheduleDate != null
                                ? RumenoTheme.textDark
                                : RumenoTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ─── Save Button ───
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (selectedAnimal == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please select animal type'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      if (animalIdCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter Animal ID'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      if (cuttingDate == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please pick the hoof cutting date'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Hoof cutting record saved! ✅'),
                          ]),
                          backgroundColor: RumenoTheme.successGreen,
                        ),
                      );
                    },
                    icon: const Text('✅', style: TextStyle(fontSize: 20)),
                    label: Text(AppLocalizations.of(ctx).commonSaveRecord,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hoofLabel(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: RumenoTheme.textDark)),
      ],
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
