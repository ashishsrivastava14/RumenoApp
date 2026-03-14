import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../mock/mock_farmers.dart';
import '../../mock/mock_health.dart';
import '../../mock/mock_users.dart';
import '../../models/models.dart';
import '../../widgets/common/marketplace_button.dart';

class VetDashboardScreen extends StatelessWidget {
  const VetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vet = mockVetUser;
    final today = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
    final vetFarmers = mockFarmers.where((f) => f.vetId == 'V001').toList();
    final totalFarms = vetFarmers.length;
    final totalAnimals = vetFarmers.fold<int>(0, (sum, f) => sum + f.animalCount);
    final activeTreatments = mockTreatments.where((t) => t.status == TreatmentStatus.active).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: RumenoTheme.primaryDarkGreen,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/images/Rumeno_logo-rb.png',
                fit: BoxFit.contain,
              ),
            ),
            actions: const [
              FarmButton(),
              MarketplaceButton(),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3D6B1F), Color(0xFF5B7A2E), Color(0xFF7AA040)],
                        stops: [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    right: -40,
                    top: -30,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    bottom: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 72, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/vetdoctor.png',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Good morning,',
                                    style: TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 0.3),
                                  ),
                                  Text(
                                    vet.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    vet.specialization ?? 'Veterinary Specialist',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // Notification bell
                            GestureDetector(
                              onTap: () => _showNotificationsSheet(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                                child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Info chips row
                        Row(
                          children: [
                            _InfoChip(icon: Icons.calendar_today_rounded, label: today),
                            const SizedBox(width: 8),
                            _InfoChip(icon: Icons.badge_outlined, label: vet.referralCode ?? 'DRANITA20'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Stat Cards ──────────────────────────────────────
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _GradientStatCard(
                          title: 'Referred Farms',
                          value: '$totalFarms',
                          icon: Icons.agriculture_rounded,
                          gradientColors: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        ),
                        const SizedBox(width: 12),
                        _GradientStatCard(
                          title: 'Total Animals',
                          value: '$totalAnimals',
                          icon: Icons.pets_rounded,
                          gradientColors: const [Color(0xFF26C6DA), Color(0xFF00838F)],
                        ),
                        const SizedBox(width: 12),
                        _GradientStatCard(
                          title: 'Active Cases',
                          value: '$activeTreatments',
                          icon: Icons.phone_in_talk_rounded,
                          gradientColors: const [Color(0xFFFF8A65), Color(0xFFE64A19)],
                        ),
                        const SizedBox(width: 12),
                        const _GradientStatCard(
                          title: 'Monthly Earnings',
                          value: '₹12.5K',
                          icon: Icons.currency_rupee_rounded,
                          gradientColors: [Color(0xFFAB47BC), Color(0xFF6A1B9A)],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick Actions ───────────────────────────────────
                  const _SectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.add_circle_outline_rounded,
                        label: 'New Visit',
                        color: const Color(0xFF5B7A2E),
                        onTap: () => _showNewVisitSheet(context),
                      ),
                      const SizedBox(width: 10),
                      _QuickAction(
                        icon: Icons.vaccines_rounded,
                        label: 'Record Health',
                        color: const Color(0xFF00838F),
                        onTap: () => context.go('/vet/health'),
                      ),
                      const SizedBox(width: 10),
                      _QuickAction(
                        icon: Icons.agriculture_rounded,
                        label: 'My Farms',
                        color: const Color(0xFF6D4C41),
                        onTap: () => context.go('/vet/farms'),
                      ),
                      const SizedBox(width: 10),
                      _QuickAction(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'Earnings',
                        color: const Color(0xFF6A1B9A),
                        onTap: () => context.go('/vet/earnings'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Today's Summary Banner ──────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Great work this week!',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'You completed 14 consultations — 40% more than last week.',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Recent Consultations ────────────────────────────
                  _SectionHeader(title: 'Recent Consultations', onSeeAll: () => context.go('/vet/consultations')),
                  const SizedBox(height: 12),
                  ..._buildConsultations(context),

                  const SizedBox(height: 24),

                  // ── Upcoming Visits ─────────────────────────────────
                  _SectionHeader(title: 'Upcoming Visits', onSeeAll: () => context.go('/vet/schedule')),
                  const SizedBox(height: 12),
                  ..._buildVisits(context),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConsultations(BuildContext context) {
    final consults = [
      {
        'farmer': 'Rajesh Patel',
        'animal': 'Lakshmi (GIR-001)',
        'issue': 'Mastitis treatment follow-up',
        'date': '2 hours ago',
        'status': 'ongoing',
        'initials': 'RP',
        'color': 0xFFE53935,
      },
      {
        'farmer': 'Vikram Singh',
        'animal': 'Nandi (MUR-005)',
        'issue': 'Vaccination schedule review',
        'date': 'Yesterday',
        'status': 'resolved',
        'initials': 'VS',
        'color': 0xFF1E88E5,
      },
      {
        'farmer': 'Amit Sharma',
        'animal': 'Gauri (SAH-003)',
        'issue': 'Pregnancy check — 6 months',
        'date': '2 days ago',
        'status': 'resolved',
        'initials': 'AS',
        'color': 0xFF43A047,
      },
    ];
    return consults.map((c) {
      final isOngoing = c['status'] == 'ongoing';
      final avatarColor = Color(c['color'] as int);
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colored left accent bar
                Container(width: 4, color: isOngoing ? const Color(0xFFE53935) : const Color(0xFF4CAF50)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        // Avatar circle
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: avatarColor.withValues(alpha: 0.12),
                          ),
                          child: Center(
                            child: Text(
                              c['initials'] as String,
                              style: TextStyle(
                                color: avatarColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(c['farmer'] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF1A1A1A))),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isOngoing
                                          ? const Color(0xFFFFEBEE)
                                          : const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isOngoing ? 'Ongoing' : 'Resolved',
                                      style: TextStyle(
                                        color: isOngoing
                                            ? const Color(0xFFE53935)
                                            : const Color(0xFF43A047),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                c['animal'] as String,
                                style: const TextStyle(
                                    color: Color(0xFF5B7A2E),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c['issue'] as String,
                                style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      size: 12, color: Color(0xFFAAAAAA)),
                                  const SizedBox(width: 4),
                                  Text(c['date'] as String,
                                      style: const TextStyle(
                                          color: Color(0xFFAAAAAA), fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildVisits(BuildContext context) {
    final visits = [
      {
        'farmer': 'Rajesh Patel',
        'purpose': 'Monthly herd checkup',
        'day': 'TOM',
        'time': '10:00 AM',
        'fullDate': 'Tomorrow',
        'initials': 'RP',
        'urgent': false,
      },
      {
        'farmer': 'Priya Devi',
        'purpose': 'Vaccination drive — FMD',
        'day': '18',
        'time': '09:00 AM',
        'fullDate': 'Mar 18',
        'initials': 'PD',
        'urgent': true,
      },
    ];
    return visits.map((v) {
      final isUrgent = v['urgent'] as bool;
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent
                ? const Color(0xFFFF8A65).withValues(alpha: 0.5)
                : const Color(0xFF5B7A2E).withValues(alpha: 0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Date badge
              Container(
                width: 50,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isUrgent
                        ? [const Color(0xFFFF8A65), const Color(0xFFE64A19)]
                        : [const Color(0xFF5B7A2E), const Color(0xFF3D5A1E)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      v['day'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      v['time'] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          v['farmer'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1A1A1A)),
                        ),
                        if (isUrgent) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Priority',
                              style: TextStyle(
                                  color: Color(0xFFE64A19),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      v['purpose'] as String,
                      style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 11, color: Color(0xFF5B7A2E)),
                        const SizedBox(width: 4),
                        Text(
                          '${v['fullDate']}  ·  ${v['time']}',
                          style: const TextStyle(
                              color: Color(0xFF5B7A2E),
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFCCCCCC)),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ── Helper Widgets ───────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _GradientStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradientColors;

  const _GradientStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.1,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white70, fontSize: 11, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600,
                    height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
          letterSpacing: 0.2),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              letterSpacing: 0.2),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'See all',
            style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5B7A2E),
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ── Bottom Sheet Helpers ─────────────────────────────────────────────────────

void _showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B7A2E).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${mockAlerts.length}',
                      style: const TextStyle(
                          color: Color(0xFF5B7A2E),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: mockAlerts.length,
                itemBuilder: (context, i) {
                  final alert = mockAlerts[i];
                  final Color alertColor;
                  final IconData alertIcon;
                  switch (alert.severity) {
                    case AlertSeverity.high:
                      alertColor = Colors.red;
                      alertIcon = Icons.warning_rounded;
                    case AlertSeverity.medium:
                      alertColor = Colors.orange;
                      alertIcon = Icons.info_rounded;
                    case AlertSeverity.low:
                      alertColor = Colors.green;
                      alertIcon = Icons.check_circle_rounded;
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: alertColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: alertColor.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(alertIcon, color: alertColor, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert.message,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('dd MMM').format(alert.date),
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showNewVisitSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _NewVisitSheet(),
  );
}

// ── New Visit Sheet ──────────────────────────────────────────────────────────

class _NewVisitSheet extends StatefulWidget {
  const _NewVisitSheet();

  @override
  State<_NewVisitSheet> createState() => _NewVisitSheetState();
}

class _NewVisitSheetState extends State<_NewVisitSheet> {
  String? _selectedFarmId;
  DateTime _visitDate = DateTime.now();
  String? _selectedPurpose;
  final _notesController = TextEditingController();

  static const _purposes = <Map<String, Object>>[
    {'label': 'Checkup',     'icon': Icons.health_and_safety_rounded, 'color': 0xFF00ACC1},
    {'label': 'Vaccination', 'icon': Icons.vaccines_rounded,          'color': 0xFF8E24AA},
    {'label': 'Treatment',   'icon': Icons.medical_services_rounded,  'color': 0xFFEF6C00},
    {'label': 'Emergency',   'icon': Icons.warning_amber_rounded,     'color': 0xFFD32F2F},
    {'label': 'Pregnancy',   'icon': Icons.pregnant_woman,            'color': 0xFFC2185B},
    {'label': 'Other',       'icon': Icons.more_horiz_rounded,        'color': 0xFF546E7A},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _visitDate = picked);
  }

  void _save() {
    if (_selectedFarmId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a farm'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_selectedPurpose == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the reason for visit'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅  Visit scheduled successfully!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F8F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1 ─ Farm
                  _buildStepLabel('1', Icons.agriculture_rounded, 'Choose Farm', const Color(0xFF5B7A2E)),
                  const SizedBox(height: 12),
                  _buildFarmSelector(),
                  const SizedBox(height: 26),

                  // Step 2 ─ Date
                  _buildStepLabel('2', Icons.calendar_month_rounded, 'When to Visit?', const Color(0xFF1E88E5)),
                  const SizedBox(height: 12),
                  _buildDateSelector(),
                  const SizedBox(height: 26),

                  // Step 3 ─ Purpose
                  _buildStepLabel('3', Icons.assignment_turned_in_rounded, 'Reason for Visit', const Color(0xFF8E24AA)),
                  const SizedBox(height: 12),
                  _buildPurposeGrid(),
                  const SizedBox(height: 26),

                  // Step 4 ─ Notes
                  _buildStepLabel('4', Icons.edit_note_rounded, 'Extra Notes (Optional)', Colors.grey.shade600),
                  const SizedBox(height: 12),
                  _buildNotesField(),
                  const SizedBox(height: 32),

                  // Submit
                  _buildSubmitButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E5F10), Color(0xFF5B7A2E), Color(0xFF7AA040)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule New Visit',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Follow the 4 simple steps below',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Step label ───────────────────────────────────────────────────────────

  Widget _buildStepLabel(String step, IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }

  // ── Farm selector ────────────────────────────────────────────────────────

  Widget _buildFarmSelector() {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: mockFarmers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final farm = mockFarmers[i];
          final isSelected = farm.id == _selectedFarmId;
          final initials = farm.name
              .split(' ')
              .where((w) => w.isNotEmpty)
              .map((w) => w[0].toUpperCase())
              .take(2)
              .join();
          return GestureDetector(
            onTap: () => setState(() => _selectedFarmId = farm.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 148,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF5B7A2E) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? const Color(0xFF5B7A2E) : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF5B7A2E).withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : const Color(0xFF5B7A2E).withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF5B7A2E),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                        size: 18,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    farm.farmName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.pets_rounded,
                          size: 11, color: isSelected ? Colors.white70 : const Color(0xFF5B7A2E)),
                      const SizedBox(width: 3),
                      Text(
                        '${farm.animalCount} animals',
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Date selector ────────────────────────────────────────────────────────

  Widget _buildDateSelector() {
    final now = DateTime.now();
    final dayNum   = DateFormat('dd').format(_visitDate);
    final monthAbbr = DateFormat('MMM').format(_visitDate);
    final weekday  = DateFormat('EEEE').format(_visitDate);
    final fullDate = DateFormat('d MMMM yyyy').format(_visitDate);
    final isToday  = _visitDate.year == now.year && _visitDate.month == now.month && _visitDate.day == now.day;
    final isTomorrow = _visitDate.difference(DateTime(now.year, now.month, now.day)).inDays == 1;
    final dayLabel = isToday ? '🗓  Today' : isTomorrow ? '🗓  Tomorrow' : '🗓  $weekday';

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E88E5).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Day badge
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNum,
                    style: const TextStyle(
                      color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.0,
                    ),
                  ),
                  Text(monthAbbr,
                      style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dayLabel,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(fullDate,
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tap to change date',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.edit_calendar_rounded, color: Colors.white70, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Purpose grid ─────────────────────────────────────────────────────────

  Widget _buildPurposeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: _purposes.length,
      itemBuilder: (_, i) {
        final p = _purposes[i];
        final label = p['label'] as String;
        final icon  = p['icon']  as IconData;
        final color = Color(p['color'] as int);
        final isSelected = _selectedPurpose == label;

        return GestureDetector(
          onTap: () => setState(() => _selectedPurpose = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.22)
                        : color.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: isSelected ? Colors.white : color, size: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF333333),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Notes field ──────────────────────────────────────────────────────────

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        decoration: InputDecoration(
          hintText: 'Any special instructions or observations…',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10, top: 16),
            child: Icon(Icons.edit_note_rounded, color: Colors.grey.shade400, size: 24),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
        ),
      ),
    );
  }

  // ── Submit button ────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _save,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF2E5F10), Color(0xFF5B7A2E), Color(0xFF7AA040)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B7A2E).withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text(
              'Schedule Visit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
