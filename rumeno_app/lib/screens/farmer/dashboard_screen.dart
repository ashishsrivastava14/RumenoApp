import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import 'animals/animal_qr_scanner_screen.dart';
import '../../widgets/common/marketplace_button.dart';
import '../../l10n/app_localizations.dart';
// VeterinarianButton is defined in marketplace_button.dart

// Helper function to show info dialog
void _showInfoDialog(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.info_rounded, color: RumenoTheme.primaryGreen, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        description,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF424242),
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: RumenoTheme.primaryGreen,
          ),
          child: Text(
            AppLocalizations.of(context).commonGotIt,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  File? _farmLogoFile;

  static String _greeting(BuildContext context, int hour) {
    final l10n = AppLocalizations.of(context);
    if (hour < 12) return l10n.dashboardGreetingMorning;
    if (hour < 17) return l10n.dashboardGreetingAfternoon;
    return l10n.dashboardGreetingEvening;
  }

  Future<void> _pickImage(BuildContext ctx) async {
    final l10n = AppLocalizations.of(ctx);
    final source = await showModalBottomSheet<ImageSource>(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                l10n.dashboardSetFarmLogoTitle,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.photo_library_rounded, color: RumenoTheme.primaryGreen),
              ),
              title: Text(l10n.commonChooseFromGallery, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(l10n.commonChooseFromGallerySubtitle),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF1565C0)),
              ),
              title: Text(l10n.commonTakeAPhoto, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(l10n.commonTakeAPhotoSubtitle),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (source == null) return;
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked != null) {
      setState(() => _farmLogoFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final l10n = AppLocalizations.of(context);
    final greeting = _greeting(context, DateTime.now().hour);
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
                farmLogoFile: _farmLogoFile,
                onPickLogo: () => _pickImage(context),
              ),
            ),

            // ── Gradient Stat Cards ──────────────────────────────
            const SliverToBoxAdapter(child: _StatsRow()),

            // ── Farm Overview Grid ───────────────────────────────
            const SliverToBoxAdapter(child: _FarmOverview()),

            // ── Quick Actions ────────────────────────────────────
            SliverToBoxAdapter(child: _QuickActionsSection()),

            // ── Alerts ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                child: _SectionTitle(title: l10n.dashboardActiveAlerts, icon: const Icon(Icons.warning_amber_rounded, color: Color(0xFF3D5A1E), size: 20)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _AlertCard(alert: mockAlerts[index]),
                childCount: mockAlerts.length,
              ),
            ),

            // ── Upcoming Events ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: _SectionTitle(title: l10n.dashboardUpcomingEvents, icon: const Icon(Icons.event_rounded, color: Color(0xFF3D5A1E), size: 20)),
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
  final File? farmLogoFile;
  final VoidCallback onPickLogo;

  const _StickyHeaderDelegate({
    required this.user,
    required this.greeting,
    required this.topPadding,
    required this.farmLogoFile,
    required this.onPickLogo,
  });

  static const double _kExpandedAdd = 220.0;
  static const double _kCollapsedHeight = 62.0;

  @override
  double get minExtent => topPadding + _kCollapsedHeight;

  @override
  double get maxExtent => topPadding + _kExpandedAdd;

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) =>
      old.user != user ||
      old.greeting != greeting ||
      old.topPadding != topPadding ||
      old.farmLogoFile != farmLogoFile;

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
            bottom: 24,
            child: Opacity(
              opacity: (1.0 - t * 2.8).clamp(0.0, 1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Large tappable farm logo (left) ──
                  GestureDetector(
                    onTap: onPickLogo,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 156,
                          height: 156,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.65),
                              width: 3.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            image: farmLogoFile != null
                                ? DecorationImage(
                                    image: FileImage(farmLogoFile!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          child: farmLogoFile == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_rounded,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      size: 38,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(context).dashboardAddFarmLogo,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        // Edit badge when logo is set
                        if (farmLogoFile != null)
                          Positioned(
                            right: 2,
                            bottom: 4,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: RumenoTheme.primaryGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 18),

                  // ── Text info (right) ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Farm name row
                        Row(
                          children: [
                            Image.asset('assets/images/farm1.png', width: 13, height: 13),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                user?.farmName ?? 'Smith Dairy Farm',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Greeting
                        Text(
                          greeting,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        // Farmer name
                        Text(
                          user?.name ?? 'Farmer',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Date
                        Text(
                          DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                          style: const TextStyle(color: Colors.white54, fontSize: 10),
                        ),
                      ],
                    ),
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
                        image: farmLogoFile != null
                            ? DecorationImage(
                                image: FileImage(farmLogoFile!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
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
                            Image.asset('assets/images/farm1.png', width: 12, height: 12),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                user?.farmName ?? 'Smith Dairy Farm',
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
          onPressed: () => context.go('/farmer/more/notifications'),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: _StatChip(
                  title: 'Total Animals',
                  value: '48',
                  icon: Icons.pets_rounded,
                  gradient: LinearGradient(
                      colors: [Color(0xFF3D6B18), Color(0xFF7FB23A)]),
                  trend: '+2',
                  up: true,
                  description: 'Total number of animals currently registered in your farm. This includes all cattle types: milking cows, dry cows, heifers, calves, and bulls.',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatChip(
                  title: 'Milk Today',
                  value: '120L',
                  icon: Icons.water_drop_rounded,
                  gradient: LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
                  trend: '+8L',
                  up: true,
                  description: 'Total milk collected today from all milking sessions. The trend shows the change compared to yesterday\'s production.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: _StatChip(
                  title: 'Tasks Due',
                  value: '3',
                  icon: Icons.task_alt_rounded,
                  gradient: LinearGradient(
                      colors: [Color(0xFFBF360C), Color(0xFFFF7043)]),
                  trend: '2 urgent',
                  up: false,
                  description: 'Number of pending tasks that need your attention today, including feeding schedules, vaccinations, treatments, and breeding activities.',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatChip(
                  title: 'Health Alerts',
                  value: '5',
                  icon: Icons.health_and_safety_rounded,
                  gradient: LinearGradient(
                      colors: [Color(0xFF880E4F), Color(0xFFE91E63)]),
                  trend: '3 high',
                  up: false,
                  description: 'Active health alerts for animals requiring attention. This includes sick animals, animals under treatment, and scheduled medical checkups.',
                ),
              ),
            ],
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
  final String? description;

  const _StatChip({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    this.trend,
    this.up = true,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                if (description != null)
                  GestureDetector(
                    onTap: () => _showInfoDialog(context, title, description!),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
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
          _SectionTitle(title: 'Farm Overview', icon: Image.asset('assets/images/farm1.png', width: 20, height: 20)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _OverviewTile(
                  label: 'Milking Cows',
                  value: '24',
                  icon: Icons.local_drink_outlined,
                  color: const Color(0xFF1565C0),
                  description: 'Number of cows currently in lactation period and actively producing milk. These animals are milked daily.',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewTile(
                  label: 'Pregnant',
                  value: '4',
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFF880E4F),
                  description: 'Number of animals confirmed pregnant through examination. Track their gestation period and expected calving dates.',
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
                  description: 'Animals currently receiving medical treatment for illness, injury, or other health conditions. Monitor their recovery progress.',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OverviewTile(
                  label: 'Vaccinated (30d)',
                  value: '12',
                  icon: Icons.vaccines_rounded,
                  color: const Color(0xFF1B5E20),
                  description: 'Number of animals vaccinated in the last 30 days. Regular vaccination helps prevent diseases and maintains herd health.',
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
  final String? description;

  const _OverviewTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        label,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3A3A3A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (description != null)
              GestureDetector(
                onTap: () => _showInfoDialog(context, label, description!),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: color.withValues(alpha: 0.7),
                    size: 22,
                  ),
                ),
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
          const _SectionTitle(title: 'Quick Actions', icon: Icon(Icons.touch_app_rounded, color: Color(0xFF3D5A1E), size: 20)),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickBtn(
                icon: Icons.add_circle_outline_rounded,
                label: 'Add Animal',
                gradient: const LinearGradient(
                    colors: [Color(0xFF2E4A12), Color(0xFF7FB23A)]),
                onTap: () => context.go('/farmer/animals/add'),
                description: 'Register a new animal to your farm. Add their details like tag ID, breed, date of birth, and other important information.',
              ),
              const SizedBox(width: 12),
              _QuickBtn(
                icon: Icons.water_drop_outlined,
                label: 'Log Milk',
                gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
                onTap: () => context.push('/farmer/milk/log'),
                description: 'Record milk production from your milking sessions. Track quantity, quality, and individual animal contributions.',
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
                description: 'Access health records, schedule checkups, log treatments, and monitor the wellbeing of your animals.',
              ),
              const SizedBox(width: 12),
              _QuickBtn(
                icon: Icons.receipt_long_rounded,
                label: 'Finance',
                gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFFCE93D8)]),
                onTap: () => context.go('/farmer/finance'),
                description: 'Track income from milk sales, manage expenses for feed and healthcare, and view your farm\'s financial reports.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickBtn(
                icon: Icons.calculate_rounded,
                label: 'Feed Mix',
                gradient: const LinearGradient(
                    colors: [Color(0xFF795548), Color(0xFFBCAAA4)]),
                onTap: () => context.go('/farmer/finance/feed-calculator'),
                description: 'Calculate the best feed combination for your animals based on nutrition needs and cost.',
              ),
              const SizedBox(width: 12),
              _QuickBtn(
                icon: Icons.storefront_rounded,
                label: 'Sell',
                gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF81C784)]),
                onTap: () => context.push('/farmer/sale'),
                description: 'Record animal, milk, and produce sales. Track buyers, amounts, and payment methods in one place.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ScanAnimalButton(),
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
  final String? description;

  const _QuickBtn({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
              if (description != null)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => _showInfoDialog(context, label, description!),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 18,
                      ),
                    ),
                  ),
                ),
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
//  SCAN ANIMAL BUTTON  (full-width QR scanner CTA)
// ─────────────────────────────────────────────────────────────

class _ScanAnimalButton extends StatelessWidget {
  const _ScanAnimalButton();

  void _openScanner(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AnimalQrScannerScreen(
          onAnimalFound: (animal) => context.go('/farmer/animals/${animal.id}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openScanner(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A3A0D), Color(0xFF4A7A1E)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A3A0D).withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Scan Animal QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Scan a tag to open animal details',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
          ],
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
  final Widget? icon;
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
              icon!,
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
