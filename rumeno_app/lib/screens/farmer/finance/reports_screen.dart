import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/charts/bar_chart_widget.dart';
import '../../../widgets/charts/pie_chart_widget.dart';
import '../../../widgets/common/date_range_picker_widget.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Financial Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DateRangePickerWidget(
            onRangeSelected: (_) {},
          ),
          const SizedBox(height: 16),
          // Summary
          Row(
            children: [
              _ReportCard(title: 'Total Expenses', value: '₹3,89,300'),
              const SizedBox(width: 10),
              _ReportCard(title: 'Total Income', value: '₹5,20,000'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ReportCard(title: 'Net Profit', value: '₹1,30,700'),
              const SizedBox(width: 10),
              _ReportCard(title: 'Avg Monthly', value: '₹21,783'),
            ],
          ),
          const SizedBox(height: 16),
          BarChartWidget(
            title: 'Category-wise Expenses',
            values: const [175000, 97000, 46300, 24000, 25000, 3500, 18500],
            labels: const ['Feed', 'Labour', 'Medicine', 'Vet', 'Equip', 'Transport', 'Other'],
          ),
          const SizedBox(height: 16),
          PieChartWidget(
            title: 'Payment Mode Distribution',
            entries: const [
              PieChartEntry(label: 'Cash', value: 35, color: Colors.orange),
              PieChartEntry(label: 'UPI', value: 40, color: Colors.purple),
              PieChartEntry(label: 'Bank', value: 22, color: Colors.blue),
              PieChartEntry(label: 'Credit', value: 3, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export CSV (mock)'))),
                  icon: const Icon(Icons.download),
                  label: const Text('Export CSV'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export PDF (mock)'))),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  const _ReportCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
