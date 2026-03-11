import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../widgets/common/marketplace_button.dart';
// VeterinarianButton is defined in marketplace_button.dart

/// Simple TTS helper for accessibility – long-press any card to hear its content.
class _DashboardTts {
  static FlutterTts? _tts;
  static Future<void> speak(String text) async {
    _tts ??= FlutterTts();
    await _tts!.setLanguage('en-IN');
    await _tts!.setSpeechRate(0.45);
    await _tts!.speak(text);
  }
}

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
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      body: RefreshIndicator(
        color: RumenoTheme.primaryGreen,
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          slivers: [
            // ── Header (farm image + sticky gradient bar) ────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                user: user,
                greeting: greeting,
                topPadding: topPadding,
              ),
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
                child: _SectionTitle(title: 'Active Alerts', icon: Icons.warning_amber_rounded),
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
                child: _SectionTitle(title: 'Upcoming Events', icon: Icons.event_rounded),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STICKY HEADER DELEGATE  (farm image + animated gradient bar)
// ─────────────────────────────────────────────────────────────

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final dynamic user;
  final String greeting;
  final double topPadding;

  const _StickyHeaderDelegate({
    required this.user,
    required this.greeting,
    required this.topPadding,
  });

  static const double _kExpandedAdd = 210.0;
  static const double _kCollapsedHeight = 62.0;

  @override
  double get minExtent => topPadding + _kCollapsedHeight;

  @override
  double get maxExtent => topPadding + _kExpandedAdd;

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) =>
      old.user != user ||
      old.greeting != greeting ||
      old.topPadding != topPadding;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24 * (1 - t)),
        bottomRight: Radius.circular(24 * (1 - t)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Farm image background (fades as header collapses) ──
          Opacity(
            opacity: (1.0 - t * 1.4).clamp(0.0, 1.0),
            child: Image.asset('assets/images/farm-3.png', fit: BoxFit.cover),
          ),

          // ── Gradient overlay (deepens on collapse) ──
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(const Color(0xEE1B2E0A), const Color(0xFF1A3A0D), t)!,
                  Color.lerp(const Color(0x441B2E0A), const Color(0xFF2B5218), t)!,
                  Color.lerp(const Color(0xCC1B2E0A), const Color(0xFF1A3A0D), t)!,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // ── Expanded greeting (fades out while collapsing) ──
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Opacity(
              opacity: (1.0 - t * 2.8).clamp(0.0, 1.0),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/farm_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.agriculture_rounded, color: Colors.white54, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            user?.farmName ?? 'Patel Dairy Farm',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        greeting,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        user?.name ?? 'Farmer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          shadows: [
                            Shadow(color: Colors.black45, blurRadius: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky top bar (always visible, gradient strengthens on collapse) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPadding + _kCollapsedHeight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, topPadding + 6, 4, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mini avatar – slides in from transparent as we collapse
                  Opacity(
                    opacity: t,
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38, width: 1.5),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/farm_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Farm info text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.agriculture_rounded, color: Colors.white54, size: 12),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                user?.farmName ?? 'Patel Dairy Farm',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Opacity(
                          opacity: t,
                          child: Text(
                            user?.name ?? 'Farmer',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Plan badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: RumenoTheme.planPro.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: RumenoTheme.planPro.withValues(alpha: 0.65)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: RumenoTheme.planPro, size: 11),
                        const SizedBox(width: 3),
                        Text(
                          'Pro',
                          style: TextStyle(
                            color: RumenoTheme.planPro,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _NotifBell(count: 5),
                  const VeterinarianButton(),
                  const MarketplaceButton(),
                ],
              ),
            ),
          ),
        ],
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

// ─────────────────────────────────────────────────────────────
//  GRADIENT STAT CARDS
// ─────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
    return GestureDetector(
      onLongPress: () => _DashboardTts.speak('$title: $value'),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    trend!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
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
          const _SectionTitle(title: 'Farm Overview', icon: Icons.agriculture_rounded),
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
    return GestureDetector(
      onLongPress: () => _DashboardTts.speak('$label: $value'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A3A3A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          const _SectionTitle(title: 'Quick Actions', icon: Icons.touch_app_rounded),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickBtn(
                icon: Icons.add_circle_outline_rounded,
                label: 'Add Animal',
                gradient: const LinearGradient(
                    colors: [Color(0xFF2E4A12), Color(0xFF7FB23A)]),
                onTap: () => context.go('/farmer/animals/add'),
              ),
              const SizedBox(width: 12),
              _QuickBtn(
                icon: Icons.water_drop_outlined,
                label: 'Log Milk',
                gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Milk logging coming soon!')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickBtn(
                icon: Icons.medical_services_outlined,
                label: 'Health',
                gradient: const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF4DB6AC)]),
                onTap: () => context.go('/farmer/health'),
              ),
              const SizedBox(width: 12),
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
        onLongPress: () => _DashboardTts.speak(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 38),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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

    return GestureDetector(
      onLongPress: () => _DashboardTts.speak(alert.message),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: color, width: 5)),
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
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          title: Text(
            alert.message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D2D),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: color.withValues(alpha: 0.5),
          ),
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
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionTitle({required this.title, this.icon, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFF3D5A1E), size: 20),
              const SizedBox(width: 6),
            ],
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
                fontSize: 16,
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
