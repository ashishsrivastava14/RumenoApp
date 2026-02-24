import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../mock/mock_users.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/section_header.dart';
import 'package:intl/intl.dart';

class VetDashboardScreen extends StatelessWidget {
  const VetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vet = mockVetUser;
    final today = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Welcome, ${vet.name}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(today, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Referral Code: VET-ANITA-2024', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        StatCard(title: 'Referred Farms', value: '10', icon: Icons.agriculture),
                        SizedBox(width: 10),
                        StatCard(title: 'Active Animals', value: '156', icon: Icons.pets),
                        SizedBox(width: 10),
                        StatCard(title: 'Consults Today', value: '3', icon: Icons.phone_in_talk),
                        SizedBox(width: 10),
                        StatCard(title: 'This Month ₹', value: '12,500', icon: Icons.currency_rupee),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recent consultations
                  SectionHeader(title: 'Recent Consultations', onAction: () {}),
                  const SizedBox(height: 8),
                  ..._buildConsultations(context),

                  const SizedBox(height: 20),
                  SectionHeader(title: 'Upcoming Visits', onAction: () {}),
                  const SizedBox(height: 8),
                  ..._buildVisits(context),
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
      {'farmer': 'Rajesh Patel', 'animal': 'Lakshmi (GIR-001)', 'issue': 'Mastitis treatment follow-up', 'date': '2 hours ago'},
      {'farmer': 'Vikram Singh', 'animal': 'Nandi (MUR-005)', 'issue': 'Vaccination schedule review', 'date': 'Yesterday'},
      {'farmer': 'Amit Sharma', 'animal': 'Gauri (SAH-003)', 'issue': 'Pregnancy check - 6 months', 'date': '2 days ago'},
    ];
    return consults.map((c) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
            child: Icon(Icons.medical_services_rounded, color: RumenoTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['farmer']!, style: Theme.of(context).textTheme.titleSmall),
                Text(c['animal']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.primaryGreen)),
                Text(c['issue']!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(c['date']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        ],
      ),
    )).toList();
  }

  List<Widget> _buildVisits(BuildContext context) {
    final visits = [
      {'farmer': 'Rajesh Patel', 'purpose': 'Monthly herd checkup', 'date': 'Tomorrow, 10:00 AM'},
      {'farmer': 'Priya Devi', 'purpose': 'Vaccination drive - FMD', 'date': '18 Jul, 9:00 AM'},
    ];
    return visits.map((v) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RumenoTheme.accentOlive.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: RumenoTheme.accentOlive.withValues(alpha: 0.12),
            child: Icon(Icons.calendar_today_rounded, color: RumenoTheme.accentOlive, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v['farmer']!, style: Theme.of(context).textTheme.titleSmall),
                Text(v['purpose']!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(v['date']!, style: TextStyle(fontSize: 10, color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600)),
        ],
      ),
    )).toList();
  }
}
