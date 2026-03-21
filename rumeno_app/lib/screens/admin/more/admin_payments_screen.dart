import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/charts/line_chart_widget.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({super.key});

  String _formatCurrency(double val) {
    if (val >= 100000) return '₹${(val / 100000).toStringAsFixed(1)}L';
    if (val >= 1000) return '₹${(val / 1000).toStringAsFixed(1)}K';
    return '₹${val.toStringAsFixed(0)}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Refunded':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final payments = admin.payments;
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Payments')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue summary
            Row(
              children: [
                Expanded(child: _summaryCard(context, _formatCurrency(admin.totalRevenue), 'Total Revenue', Icons.currency_rupee, Colors.green)),
                const SizedBox(width: 10),
                Expanded(child: _summaryCard(context, _formatCurrency(admin.monthlyRevenue), 'This Month', Icons.calendar_today, Colors.blue)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _summaryCard(context, '${admin.failedPayments}', 'Failed', Icons.error_outline, Colors.red)),
                const SizedBox(width: 10),
                Expanded(child: _summaryCard(context, '${admin.refundedPayments}', 'Refunds', Icons.undo, Colors.orange)),
              ],
            ),
            const SizedBox(height: 20),

            // Revenue trend
            Text('Revenue Trend', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: LineChartWidget(
                spots: const [FlSpot(0, 35000), FlSpot(1, 42000), FlSpot(2, 48000), FlSpot(3, 52000), FlSpot(4, 58000), FlSpot(5, 68000)],
                bottomLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                lineColor: RumenoTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 20),

            // Recent payments
            Text('Recent Payments', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...payments.map((p) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _statusColor(p.status).withValues(alpha: 0.12),
                    child: Icon(
                      p.status == 'Success' ? Icons.check : p.status == 'Failed' ? Icons.close : Icons.undo,
                      size: 16,
                      color: _statusColor(p.status),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.userName, style: Theme.of(context).textTheme.titleSmall),
                        Text('${p.plan} • ${p.method}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${p.amount.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _statusColor(p.status))),
                      Text(_formatDate(p.date), style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _summaryCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, size: 16, color: color)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
              Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
