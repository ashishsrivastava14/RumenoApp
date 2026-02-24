import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_finance.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/expense_card.dart';
import '../../../widgets/charts/line_chart_widget.dart';
import '../../../widgets/charts/pie_chart_widget.dart';
import '../../../widgets/common/section_header.dart';

class FinanceDashboardScreen extends StatelessWidget {
  const FinanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalExp = totalExpensesThisMonth;
    final totalInc = totalIncomeThisMonth;
    final net = totalInc - totalExp;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Finance'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.go('/farmer/finance/reports'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Monthly summary
            Row(
              children: [
                _SummaryCard(label: 'Expenses', value: '₹${totalExp.toStringAsFixed(0)}', color: RumenoTheme.errorRed, icon: Icons.arrow_downward),
                const SizedBox(width: 10),
                _SummaryCard(label: 'Income', value: '₹${totalInc.toStringAsFixed(0)}', color: RumenoTheme.successGreen, icon: Icons.arrow_upward),
                const SizedBox(width: 10),
                _SummaryCard(label: 'Net P&L', value: '₹${net.toStringAsFixed(0)}', color: net >= 0 ? RumenoTheme.successGreen : RumenoTheme.errorRed, icon: net >= 0 ? Icons.trending_up : Icons.trending_down),
              ],
            ),
            const SizedBox(height: 16),
            // Expense breakdown
            PieChartWidget(
              title: 'Expense Breakdown',
              entries: const [
                PieChartEntry(label: 'Feed', value: 45, color: Colors.green),
                PieChartEntry(label: 'Labour', value: 25, color: Colors.orange),
                PieChartEntry(label: 'Medicine', value: 12, color: Colors.red),
                PieChartEntry(label: 'Veterinary', value: 8, color: Colors.blue),
                PieChartEntry(label: 'Equipment', value: 6, color: Colors.purple),
                PieChartEntry(label: 'Other', value: 4, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),
            // Monthly trend
            LineChartWidget(
              title: 'Monthly Expense Trend',
              spots: List.generate(
                monthlyExpenseSummary.length,
                (i) => FlSpot(i.toDouble(), (monthlyExpenseSummary[i]['amount'] as double) / 1000),
              ),
              bottomLabels: monthlyExpenseSummary.map((m) => (m['month'] as String).substring(0, 3)).toList(),
              lineColor: RumenoTheme.errorRed,
            ),
            const SizedBox(height: 16),
            SectionHeader(
              title: 'Recent Expenses',
              onAction: () => context.go('/farmer/finance/expenses'),
            ),
            ...mockExpenses.take(5).map((e) => ExpenseCard(expense: e)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    ExpenseCategory category = ExpenseCategory.feed;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Expense', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExpenseCategory>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ExpenseCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
                onChanged: (v) => category = v!,
              ),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Amount (₹)', prefixText: '₹ '), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Vendor Name')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: 'Cash',
                decoration: const InputDecoration(labelText: 'Payment Mode'),
                items: ['Cash', 'UPI', 'Bank', 'Credit'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Notes'), maxLines: 2),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Expense added!'), backgroundColor: Colors.green));
                  },
                  child: const Text('Save Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ]),
            const SizedBox(height: 4),
            FittedBox(child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color))),
          ],
        ),
      ),
    );
  }
}
