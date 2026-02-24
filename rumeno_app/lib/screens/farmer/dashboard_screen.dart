import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/alert_banner.dart';

class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: RumenoTheme.primaryGreen,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${user?.name ?? "Farmer"}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          // Subscription badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: RumenoTheme.planPro.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: RumenoTheme.planPro.withValues(alpha: 0.5)),
                            ),
                            child: Text('Pro Plan', style: TextStyle(color: RumenoTheme.planPro, fontWeight: FontWeight.w600, fontSize: 11)),
                          ),
                          const SizedBox(width: 12),
                          // Notification bell
                          IconButton(
                            icon: Badge(
                              label: const Text('5'),
                              child: const Icon(Icons.notifications_outlined, color: Colors.white),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Notifications coming soon!')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(user?.farmName ?? 'Patel Dairy Farm'),
            ),
            // Summary Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      StatCard(title: 'Total Animals', value: '48', icon: Icons.pets, color: Color(0xFF5B7A2E)),
                      SizedBox(width: 12),
                      StatCard(title: 'Milk Today', value: '120L', icon: Icons.water_drop, color: Color(0xFF2196F3)),
                      SizedBox(width: 12),
                      StatCard(title: 'Tasks Due', value: '3', icon: Icons.task_alt, color: Color(0xFFFF9800)),
                      SizedBox(width: 12),
                      StatCard(title: 'Alerts', value: '5', icon: Icons.warning_amber, color: Color(0xFFE53935)),
                    ],
                  ),
                ),
              ),
            ),
            // Alerts
            SliverToBoxAdapter(
              child: SectionHeader(title: 'Alerts', onAction: () {}),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final alert = mockAlerts[index];
                  switch (alert.severity) {
                    case AlertSeverity.high:
                      return AlertBanner.high(message: alert.message);
                    case AlertSeverity.medium:
                      return AlertBanner.medium(message: alert.message);
                    case AlertSeverity.low:
                      return AlertBanner.low(message: alert.message);
                  }
                },
                childCount: mockAlerts.length,
              ),
            ),
            // Upcoming Events
            SliverToBoxAdapter(
              child: SectionHeader(title: 'Upcoming Events', onAction: () {}),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = mockUpcomingEvents[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${event.date.day}', style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen, fontSize: 16)),
                              Text(DateFormat('MMM').format(event.date), style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 10)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title, style: Theme.of(context).textTheme.titleSmall),
                              Text(event.eventType, style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: RumenoTheme.textLight),
                      ],
                    ),
                  );
                },
                childCount: mockUpcomingEvents.length,
              ),
            ),
            // Quick Actions
            SliverToBoxAdapter(
              child: SectionHeader(title: 'Quick Actions'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _QuickAction(icon: Icons.add, label: 'Add Animal', onTap: () => context.go('/farmer/animals/add')),
                    const SizedBox(width: 12),
                    _QuickAction(icon: Icons.water_drop, label: 'Log Milk', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Milk logging coming soon!')))),
                    const SizedBox(width: 12),
                    _QuickAction(icon: Icons.medical_services, label: 'Record Health', onTap: () => context.go('/farmer/health')),
                    const SizedBox(width: 12),
                    _QuickAction(icon: Icons.receipt_long, label: 'Add Expense', onTap: () => context.go('/farmer/finance')),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: RumenoTheme.primaryGreen, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
