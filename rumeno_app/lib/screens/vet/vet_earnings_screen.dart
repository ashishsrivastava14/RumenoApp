import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/charts/bar_chart_widget.dart';

class VetEarningsScreen extends StatelessWidget {
  const VetEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Earnings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: const [
                Expanded(child: StatCard(title: 'This Month', value: '₹12,500', icon: Icons.currency_rupee)),
                SizedBox(width: 10),
                Expanded(child: StatCard(title: 'Total Earned', value: '₹68,400', icon: Icons.account_balance_wallet)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(child: StatCard(title: 'Pending', value: '₹3,200', icon: Icons.hourglass_top)),
                SizedBox(width: 10),
                Expanded(child: StatCard(title: 'Commission %', value: '15%', icon: Icons.percent)),
              ],
            ),
            const SizedBox(height: 24),

            // Monthly earnings chart
            Text('Monthly Earnings', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: LineChartWidget(
                spots: const [
                  FlSpot(0, 8500),
                  FlSpot(1, 9200),
                  FlSpot(2, 11000),
                  FlSpot(3, 10500),
                  FlSpot(4, 12500),
                  FlSpot(5, 14000),
                ],
                bottomLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                lineColor: RumenoTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),

            // Commission breakdown
            Text('Commission Breakdown', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChartWidget(
                values: const [4500, 3200, 2800, 1200, 800],
                labels: const ['Consults', 'Referrals', 'Vaccinations', 'Treatments', 'Products'],
                barColor: RumenoTheme.accentOlive,
              ),
            ),
            const SizedBox(height: 24),

            // Payout history
            Text('Payout History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ..._buildPayouts(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPayouts(BuildContext context) {
    final payouts = [
      {'month': 'June 2025', 'amount': '₹11,800', 'date': '01 Jul 2025', 'status': 'Paid'},
      {'month': 'May 2025', 'amount': '₹10,200', 'date': '01 Jun 2025', 'status': 'Paid'},
      {'month': 'April 2025', 'amount': '₹9,800', 'date': '01 May 2025', 'status': 'Paid'},
      {'month': 'March 2025', 'amount': '₹10,400', 'date': '01 Apr 2025', 'status': 'Paid'},
      {'month': 'February 2025', 'amount': '₹8,800', 'date': '01 Mar 2025', 'status': 'Paid'},
    ];
    return payouts.map((p) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green.withValues(alpha: 0.12),
            child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['month']!, style: Theme.of(context).textTheme.titleSmall),
                Text('Paid on ${p['date']}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(p['amount']!, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
        ],
      ),
    )).toList();
  }
}
