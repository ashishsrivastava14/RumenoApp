import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/charts/bar_chart_widget.dart';
import '../../widgets/common/marketplace_button.dart';

class VetEarningsScreen extends StatelessWidget {
  const VetEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.vetEarningsTitle),
        actions: const [FarmButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(child: StatCard(title: '💰 ${l10n.vetEarningsStatThisMonth}', value: '₹12,500', icon: Icons.currency_rupee)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: '💳 ${l10n.vetEarningsStatTotalEarned}', value: '₹68,400', icon: Icons.account_balance_wallet)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(title: '⏳ ${l10n.vetEarningsStatPending}', value: '₹3,200', icon: Icons.hourglass_top)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(title: '📊 ${l10n.vetEarningsStatCommission}', value: '15%', icon: Icons.percent)),
              ],
            ),
            const SizedBox(height: 24),

            // Monthly earnings chart
            Row(
              children: [
                const Text('📈 ', style: TextStyle(fontSize: 20)),
                Text(l10n.vetEarningsChartTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
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
            Row(
              children: [
                const Text('💸 ', style: TextStyle(fontSize: 20)),
                Text(l10n.vetEarningsCommissionBreakdown, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChartWidget(
                values: const [4500, 3200, 2800, 1200, 800],
                labels: [l10n.vetEarningsBarConsults, l10n.vetEarningsBarReferrals, l10n.vetEarningsBarVaccinations, l10n.vetEarningsBarTreatments, l10n.vetEarningsBarProducts],
                barColor: RumenoTheme.accentOlive,
              ),
            ),
            const SizedBox(height: 24),

            // Payout history
            Row(
              children: [
                const Text('💵 ', style: TextStyle(fontSize: 20)),
                Text(l10n.vetEarningsPayoutHistory, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ..._buildPayouts(context, l10n),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPayouts(BuildContext context, AppLocalizations l10n) {
    final payouts = [
      {'month': 'June 2025', 'amount': '₹11,800', 'date': '01 Jul 2025', 'status': 'Paid'},
      {'month': 'May 2025', 'amount': '₹10,200', 'date': '01 Jun 2025', 'status': 'Paid'},
      {'month': 'April 2025', 'amount': '₹9,800', 'date': '01 May 2025', 'status': 'Paid'},
      {'month': 'March 2025', 'amount': '₹10,400', 'date': '01 Apr 2025', 'status': 'Paid'},
      {'month': 'February 2025', 'amount': '₹8,800', 'date': '01 Mar 2025', 'status': 'Paid'},
    ];
    return payouts.map((p) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: Colors.green, width: 4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.green.withValues(alpha: 0.12),
            child: const Text('✅', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📅 ${p['month']!}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(l10n.vetEarningsPayoutPaidOn(p['date']!), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(p['amount']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RumenoTheme.primaryGreen)),
        ],
      ),
    )).toList();
  }
}
