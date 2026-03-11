import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/marketplace_button.dart';
// VeterinarianButton is defined in marketplace_button.dart

class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});

  static String _greeting(int hour) {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final greeting = _greeting(DateTime.now().hour);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      body: Stack(
        children: [
          // Background watermark logo
          Positioned.fill(
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                'assets/images/Rumeno_logo-rb.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          RefreshIndicator(
        color: RumenoTheme.primaryGreen,
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Header(user: user, greeting: greeting),
            ),

            // ── Gradient Stat Cards ──────────────────────────────
            const SliverToBoxAdapter(child: _StatsRow()),

            // ── Farm Overview Grid ───────────────────────────────
            const SliverToBoxAdapter(child: _FarmOverview()),

            // ── Quick Actions ────────────────────────────────────
            SliverToBoxAdapter(child: _QuickActionsSection()),

            // ── Alerts ───────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                child: _SectionTitle(title: 'Active Alerts'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _AlertCard(alert: mockAlerts[index]),
                childCount: mockAlerts.length,
              ),
            ),

            // ── Upcoming Events ──────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: _SectionTitle(title: 'Upcoming Events'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _EventCard(
                  event: mockUpcomingEvents[index],
                  isLast: index == mockUpcomingEvents.length - 1,
                ),
                childCount: mockUpcomingEvents.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 36)),
          ],
        ),
      ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  HEADER  (gradient + wave clip + avatar)
// ─────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final dynamic user;
  final String greeting;

  const _Header({required this.user, required this.greeting});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'F';
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, top + 14, 20, 56),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E4A12), Color(0xFF5B7A2E), Color(0xFF8B9A46)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: farm name + plan badge + actions ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.agriculture_rounded, color: Colors.white54, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      user?.farmName ?? 'Patel Dairy Farm',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Plan badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: RumenoTheme.planPro.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: RumenoTheme.planPro.withValues(alpha: 0.65),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: RumenoTheme.planPro, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            'Pro',
                            style: TextStyle(
                              color: RumenoTheme.planPro,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    _NotifBell(count: 5),
                    const VeterinarianButton(),
                    const MarketplaceButton(),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Greeting row: avatar + name ──
            Row(
              children: [
                // Avatar circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initials(user?.name ?? 'Farmer'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      Text(
                        user?.name ?? 'Farmer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
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

class _NotifBell extends StatelessWidget {
  final int count;
  const _NotifBell({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications coming soon!')),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 17,
              height: 17,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 28)
      ..quadraticBezierTo(
          size.width * 0.25, size.height, size.width * 0.5, size.height - 16)
      ..quadraticBezierTo(
          size.width * 0.75, size.height - 32, size.width, size.height - 16)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(_) => false;
}

// ─────────────────────────────────────────────────────────────
//  GRADIENT STAT CARDS
// ─────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        children: const [
          _StatChip(
            title: 'Total Animals',
            value: '48',
            icon: Icons.pets_rounded,
            gradient: LinearGradient(
                colors: [Color(0xFF3D6B18), Color(0xFF7FB23A)]),
            trend: '+2',
            up: true,
          ),
          SizedBox(width: 10),
          _StatChip(
            title: 'Milk Today',
            value: '120L',
            icon: Icons.water_drop_rounded,
            gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
            trend: '+8L',
            up: true,
          ),
          SizedBox(width: 10),
          _StatChip(
            title: 'Tasks Due',
            value: '3',
            icon: Icons.task_alt_rounded,
            gradient: LinearGradient(
                colors: [Color(0xFFBF360C), Color(0xFFFF7043)]),
            trend: '2 urgent',
            up: false,
          ),
          SizedBox(width: 10),
          _StatChip(
            title: 'Health Alerts',
            value: '5',
            icon: Icons.health_and_safety_rounded,
            gradient: LinearGradient(
                colors: [Color(0xFF880E4F), Color(0xFFE91E63)]),
            trend: '3 high',
            up: false,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final String? trend;
  final bool up;

  const _StatChip({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    this.trend,
    this.up = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.38),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              if (trend != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(up ? Icons.north : Icons.south,
                          color: Colors.white, size: 9),
                      const SizedBox(width: 1),
                      Text(
                        trend!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FARM OVERVIEW  (2 × 2 grid)
// ─────────────────────────────────────────────────────────────

class _FarmOverview extends StatelessWidget {
  const _FarmOverview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Farm Overview'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _OverviewTile(
                  label: 'Milking Cows',
                  value: '24',
                  icon: Icons.local_drink_outlined,
                  color: const Color(0xFF1565C0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewTile(
                  label: 'Pregnant',
                  value: '4',
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFF880E4F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _OverviewTile(
                  label: 'Under Treatment',
                  value: '3',
                  icon: Icons.healing_rounded,
                  color: const Color(0xFFBF360C),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewTile(
                  label: 'Vaccinated (30d)',
                  value: '12',
                  icon: Icons.vaccines_rounded,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3A3A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  QUICK ACTIONS
// ─────────────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Quick Actions'),
          const SizedBox(height: 10),
          Row(
            children: [
              _QuickBtn(
                icon: Icons.add_circle_outline_rounded,
                label: 'Add Animal',
                gradient: const LinearGradient(
                    colors: [Color(0xFF2E4A12), Color(0xFF7FB23A)]),
                onTap: () => context.go('/farmer/animals/add'),
              ),
              const SizedBox(width: 10),
              _QuickBtn(
                icon: Icons.water_drop_outlined,
                label: 'Log Milk',
                gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Milk logging coming soon!')),
                ),
              ),
              const SizedBox(width: 10),
              _QuickBtn(
                icon: Icons.medical_services_outlined,
                label: 'Health',
                gradient: const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF4DB6AC)]),
                onTap: () => context.go('/farmer/health'),
              ),
              const SizedBox(width: 10),
              _QuickBtn(
                icon: Icons.receipt_long_rounded,
                label: 'Finance',
                gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFFCE93D8)]),
                onTap: () => context.go('/farmer/finance'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickBtn({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ALERT CARD  (left accent border)
// ─────────────────────────────────────────────────────────────

class _AlertCard extends StatelessWidget {
  final AlertItem alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final (color, icon, bg) = switch (alert.severity) {
      AlertSeverity.high => (
        const Color(0xFFB71C1C),
        Icons.error_rounded,
        const Color(0xFFFFF3F3),
      ),
      AlertSeverity.medium => (
        const Color(0xFFE65100),
        Icons.warning_rounded,
        const Color(0xFFFFF8F0),
      ),
      AlertSeverity.low => (
        const Color(0xFF1B5E20),
        Icons.check_circle_rounded,
        const Color(0xFFF1F8F1),
      ),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(
          alert.message,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D2D2D),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 13,
          color: color.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  EVENT CARD  (timeline style)
// ─────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final UpcomingEvent event;
  final bool isLast;

  const _EventCard({required this.event, this.isLast = false});

  Color _typeColor(String type) => switch (type) {
        'Vaccination' => const Color(0xFF1565C0),
        'Breeding' => const Color(0xFF6A1B9A),
        'Health' => const Color(0xFF1B5E20),
        'Treatment' => const Color(0xFFBF360C),
        _ => const Color(0xFF37474F),
      };

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(event.eventType);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date badge + timeline connector
            Column(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${event.date.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 15,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(event.date),
                        style: TextStyle(
                          color: color.withValues(alpha: 0.75),
                          fontSize: 10,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: color.withValues(alpha: 0.18),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              event.eventType,
                              style: TextStyle(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFFB0BEC5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SECTION TITLE  (gradient accent bar)
// ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionTitle({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 17,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8B9A46), Color(0xFF3D5A1E)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
          ],
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(60, 32),
            ),
            child: Text(
              actionLabel ?? 'View All',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF5B7A2E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
