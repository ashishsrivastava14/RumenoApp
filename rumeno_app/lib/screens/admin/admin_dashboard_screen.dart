import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../mock/mock_health.dart';
import '../../providers/admin_provider.dart';
import '../../providers/ecommerce_provider.dart';
import '../../providers/group_provider.dart';
import '../../models/models.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  String _formatCurrency(double val) {
    if (val >= 100000) return '₹${(val / 100000).toStringAsFixed(1)}L';
    if (val >= 1000) return '₹${(val / 1000).toStringAsFixed(1)}K';
    return '₹${val.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
    final greeting = _getGreeting();
    final admin = context.watch<AdminProvider>();
    final eco = context.watch<EcommerceProvider>();
    final gp = context.watch<GroupProvider>();
    final pendingOrders = eco.orders.where((o) => o.status == OrderStatus.pending).length;
    final pendingVendors = eco.pendingVendors.length;

    // Cross-module stats
    final shopRevenue = eco.orders
        .where((o) => o.status == OrderStatus.delivered)
        .fold<double>(0, (s, o) => s + o.totalAmount);
    final lowStockCount = eco.allProductsUnfiltered.where((p) => p.stockQuantity <= 10).length;
    final activeVets = admin.vets.where((v) => v.status == VetStatus.active).length;
    final pendingVetsCount = admin.vets.where((v) => v.status == VetStatus.pending).length;
    final scheduledConsults = admin.consultations.where((c) => c.status == ConsultStatus.scheduled).length;
    final now = DateTime.now();
    final overdueVax = mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).length;
    final activeTreatments = mockTreatments.where((t) => t.status == TreatmentStatus.active).length;
    final overdueGroupAlerts = gp.alerts.where((a) => !a.isDone && a.dueDate.isBefore(now)).length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          // ─── Welcome Header ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.admin_panel_settings_rounded,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting 👋',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                today,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        // Notification bell
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.notifications_rounded,
                                  color: Colors.white, size: 24),
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Overview KPI Cards (Big, Colorful, Icon-Heavy) ─────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      _BigKpiCard(
                        emoji: '👨‍🌾',
                        label: 'Farmers',
                        value: '${admin.totalFarmers}',
                        color: const Color(0xFF1565C0),
                        trend: '+3 this week',
                        onTap: () => context.go('/admin/farmers'),
                      ),
                      _BigKpiCard(
                        emoji: '🐄',
                        label: 'Animals',
                        value: '${admin.totalAnimals}',
                        color: const Color(0xFF2E7D32),
                        trend: '+12 this month',
                        onTap: () => context.go('/admin/farm'),
                      ),
                      _BigKpiCard(
                        emoji: '👨‍⚕️',
                        label: 'Vets',
                        value: '${admin.vets.length}',
                        color: const Color(0xFFAD1457),
                        trend: '$activeVets active',
                        onTap: () => context.go('/admin/vets'),
                      ),
                      _BigKpiCard(
                        emoji: '💰',
                        label: 'Revenue',
                        value: _formatCurrency(admin.totalRevenue),
                        color: const Color(0xFFE65100),
                        trend: '₹${(admin.monthlyRevenue / 1000).toStringAsFixed(1)}k/mo',
                        onTap: () => context.go('/admin/more/payments'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ─── Shop KPIs (Mini Row) ───────────────────────────────
                  _MiniKpiRow(
                    title: '🛒 Shop',
                    items: [
                      _MiniKpiItem(emoji: '📦', label: 'Products', value: '${eco.allProductsUnfiltered.length}'),
                      _MiniKpiItem(emoji: '📄', label: 'Orders', value: '${eco.orders.length}'),
                      _MiniKpiItem(emoji: '🚨', label: 'Low Stock', value: '$lowStockCount', isAlert: lowStockCount > 0),
                      _MiniKpiItem(emoji: '💰', label: 'Revenue', value: _formatCurrency(shopRevenue)),
                    ],
                    onTap: () => context.go('/admin/shop'),
                  ),
                  const SizedBox(height: 10),

                  // ─── Vet KPIs (Mini Row) ────────────────────────────────
                  _MiniKpiRow(
                    title: '🩺 Veterinary',
                    items: [
                      _MiniKpiItem(emoji: '👨‍⚕️', label: 'Active', value: '$activeVets'),
                      _MiniKpiItem(emoji: '📋', label: 'Scheduled', value: '$scheduledConsults'),
                      _MiniKpiItem(emoji: '⏳', label: 'Pending', value: '$pendingVetsCount', isAlert: pendingVetsCount > 0),
                    ],
                    onTap: () => context.go('/admin/vets'),
                  ),
                  const SizedBox(height: 10),

                  // ─── Farm Health KPIs (Mini Row) ────────────────────────
                  _MiniKpiRow(
                    title: '🏥 Farm Health',
                    items: [
                      _MiniKpiItem(emoji: '💉', label: 'Vax Overdue', value: '$overdueVax', isAlert: overdueVax > 0),
                      _MiniKpiItem(emoji: '💊', label: 'Treatments', value: '$activeTreatments', isAlert: activeTreatments > 0),
                      _MiniKpiItem(emoji: '🐾', label: 'Groups', value: '${gp.groups.length}'),
                    ],
                    onTap: () => context.go('/admin/farm'),
                  ),

                  const SizedBox(height: 24),

                  // ─── Quick Actions (Big Visual Tiles) ───────────────────
                  Text(
                    '⚡ Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _QuickActionTile(
                        icon: Icons.people_rounded,
                        emoji: '👥',
                        label: 'Farmers',
                        color: const Color(0xFF1565C0),
                        onTap: () => context.go('/admin/farmers'),
                      ),
                      _QuickActionTile(
                        icon: Icons.pets_rounded,
                        emoji: '🐾',
                        label: 'Animals',
                        color: const Color(0xFF2E7D32),
                        onTap: () => context.go('/admin/farm'),
                      ),
                      _QuickActionTile(
                        icon: Icons.storefront_rounded,
                        emoji: '🛒',
                        label: 'Shop',
                        color: const Color(0xFF1976D2),
                        onTap: () => context.go('/admin/shop'),
                      ),
                      _QuickActionTile(
                        icon: Icons.medical_services_rounded,
                        emoji: '🩺',
                        label: 'Vets',
                        color: const Color(0xFFAD1457),
                        onTap: () => context.go('/admin/vets'),
                      ),
                      _QuickActionTile(
                        icon: Icons.card_membership_rounded,
                        emoji: '💳',
                        label: 'Plans',
                        color: const Color(0xFF6A1B9A),
                        onTap: () => context.go('/admin/more/subscriptions'),
                      ),
                      _QuickActionTile(
                        icon: Icons.bar_chart_rounded,
                        emoji: '📊',
                        label: 'Reports',
                        color: const Color(0xFF00838F),
                        onTap: () => context.go('/admin/more/reports'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Alerts Section ─────────────────────────────────────
                  Text(
                    '🔔 Alerts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (pendingOrders > 0) ...[
                    _AlertBanner(
                      emoji: '📦',
                      icon: Icons.pending_actions_rounded,
                      title: '$pendingOrders Pending Order${pendingOrders > 1 ? 's' : ''}',
                      subtitle: 'Review and process orders',
                      color: RumenoTheme.warningYellow,
                      onTap: () => context.go('/admin/shop'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (pendingVendors > 0) ...[
                    _AlertBanner(
                      emoji: '🏪',
                      icon: Icons.store_mall_directory_rounded,
                      title: '$pendingVendors Vendor${pendingVendors > 1 ? 's' : ''} Waiting Approval',
                      subtitle: 'New vendor registration',
                      color: RumenoTheme.infoBlue,
                      onTap: () => context.go('/admin/more/vendors'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (admin.failedPayments > 0) ...[
                    _AlertBanner(
                      emoji: '⚠️',
                      icon: Icons.warning_rounded,
                      title: '${admin.failedPayments} Failed Payment${admin.failedPayments > 1 ? 's' : ''}',
                      subtitle: 'Needs attention',
                      color: RumenoTheme.errorRed,
                      onTap: () => context.go('/admin/more/payments'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (pendingOrders == 0 && pendingVendors == 0 && admin.failedPayments == 0)
                    _AlertBanner(
                      emoji: '✅',
                      icon: Icons.check_circle_rounded,
                      title: 'All Clear!',
                      subtitle: 'No pending actions',
                      color: Colors.green,
                      onTap: () {},
                    ),
                  if (overdueVax > 0) ...[                    _AlertBanner(
                      emoji: '💉',
                      icon: Icons.vaccines_rounded,
                      title: '$overdueVax Vaccination${overdueVax > 1 ? 's' : ''} Overdue',
                      subtitle: 'Animals need immediate attention',
                      color: Colors.red,
                      onTap: () => context.go('/admin/farm'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (overdueGroupAlerts > 0) ...[                    _AlertBanner(
                      emoji: '🐾',
                      icon: Icons.group_work_rounded,
                      title: '$overdueGroupAlerts Group Alert${overdueGroupAlerts > 1 ? 's' : ''} Overdue',
                      subtitle: 'Review group health actions',
                      color: Colors.orange,
                      onTap: () => context.go('/admin/more/groups'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (lowStockCount > 0) ...[                    _AlertBanner(
                      emoji: '📦',
                      icon: Icons.inventory_2_rounded,
                      title: '$lowStockCount Product${lowStockCount > 1 ? 's' : ''} Low/Out of Stock',
                      subtitle: 'Restock needed',
                      color: const Color(0xFFE65100),
                      onTap: () => context.go('/admin/shop'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 24),

                  // ─── Subscription Overview ──────────────────────────────
                  Text(
                    '📋 Subscription Plans',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: admin.plans.map((plan) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _PlanPill(label: plan.name, count: plan.userCount, color: plan.color),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ─── Recent Activity ────────────────────────────────────
                  Text(
                    '🕐 Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...admin.recentActivity.map((a) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (a['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(a['emoji'] as String, style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a['text'] as String,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2D2D2D))),
                              const SizedBox(height: 2),
                              Text(a['time'] as String,
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

// ─── Big KPI Card ─────────────────────────────────────────────────────────────
class _BigKpiCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String? trend;
  final Color color;
  final VoidCallback onTap;

  const _BigKpiCard({
    required this.emoji,
    required this.label,
    required this.value,
    this.trend,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                if (trend != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up_rounded,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 3),
                        Text(trend!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Action Tile ────────────────────────────────────────────────────────
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Alert Banner ─────────────────────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final String emoji;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AlertBanner({
    required this.emoji,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  color: color, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Plan Pill ────────────────────────────────────────────────────────────────
class _PlanPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _PlanPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mini KPI Row ─────────────────────────────────────────────────────────────
class _MiniKpiRow extends StatelessWidget {
  final String title;
  final List<_MiniKpiItem> items;
  final VoidCallback? onTap;

  const _MiniKpiRow({required this.title, required this.items, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: items
                  .map((item) => Expanded(child: item))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mini KPI Item ────────────────────────────────────────────────────────────
class _MiniKpiItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final bool isAlert;

  const _MiniKpiItem({
    required this.emoji,
    required this.label,
    required this.value,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isAlert ? Colors.red.shade700 : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
