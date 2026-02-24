import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/charts/pie_chart_widget.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [RumenoTheme.primaryDarkGreen, RumenoTheme.primaryGreen],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Admin Dashboard', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(today, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
                  // KPI Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.7,
                    children: const [
                      StatCard(title: 'Total Farmers', value: '248', icon: Icons.people, trend: '+12 this month'),
                      StatCard(title: 'Total Animals', value: '3,456', icon: Icons.pets, trend: '+89 this month'),
                      StatCard(title: 'Active Vets', value: '18', icon: Icons.medical_services),
                      StatCard(title: 'Revenue', value: '₹4.2L', icon: Icons.currency_rupee, trend: '+18%'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // User growth chart
                  SectionHeader(title: 'User Growth', onAction: () {}),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: LineChartWidget(
                      spots: const [
                        FlSpot(0, 120),
                        FlSpot(1, 145),
                        FlSpot(2, 168),
                        FlSpot(3, 190),
                        FlSpot(4, 220),
                        FlSpot(5, 248),
                      ],
                      bottomLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                      lineColor: RumenoTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Subscription distribution
                  SectionHeader(title: 'Subscription Plans', onAction: () {}),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: PieChartWidget(
                      entries: [
                        PieChartEntry(label: 'Free', value: 98, color: RumenoTheme.planFree),
                        PieChartEntry(label: 'Starter', value: 82, color: RumenoTheme.planStarter),
                        PieChartEntry(label: 'Pro', value: 45, color: RumenoTheme.planPro),
                        PieChartEntry(label: 'Business', value: 23, color: RumenoTheme.planBusiness),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recent activity
                  SectionHeader(title: 'Recent Activity', onAction: () {}),
                  const SizedBox(height: 8),
                  ..._buildActivity(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActivity(BuildContext context) {
    final activities = [
      {'text': 'Rajesh Patel upgraded to Pro plan', 'time': '2 min ago', 'icon': Icons.upgrade_rounded, 'color': Colors.green},
      {'text': 'New farmer registration: Meera Devi', 'time': '15 min ago', 'icon': Icons.person_add_rounded, 'color': Colors.blue},
      {'text': 'Dr. Anita Sharma referred 2 new farms', 'time': '1 hr ago', 'icon': Icons.share_rounded, 'color': Colors.orange},
      {'text': 'Payment received: ₹999 from Vikram Singh', 'time': '2 hrs ago', 'icon': Icons.payment_rounded, 'color': Colors.green},
      {'text': 'Support ticket #145 resolved', 'time': '3 hrs ago', 'icon': Icons.check_circle_rounded, 'color': Colors.teal},
    ];
    return activities.map((a) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: (a['color'] as Color).withValues(alpha: 0.12),
            child: Icon(a['icon'] as IconData, size: 18, color: a['color'] as Color),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(a['text'] as String, style: Theme.of(context).textTheme.bodySmall)),
          Text(a['time'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ],
      ),
    )).toList();
  }
}
