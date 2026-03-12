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
import '../../../widgets/common/marketplace_button.dart';

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
        title: const Text('💰 Finance'),
        automaticallyImplyLeading: false,
        actions: [
          const VeterinarianButton(),
          const MarketplaceButton(),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Reports',
            onPressed: () => context.go('/farmer/finance/reports'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Big visual summary cards ──
            _BigSummaryCard(
              emoji: '📉',
              label: 'Money Spent',
              value: '₹${totalExp.toStringAsFixed(0)}',
              color: const Color(0xFFFFEBEE),
              textColor: RumenoTheme.errorRed,
              icon: Icons.arrow_downward_rounded,
            ),
            const SizedBox(height: 12),
            _BigSummaryCard(
              emoji: '📈',
              label: 'Money Earned',
              value: '₹${totalInc.toStringAsFixed(0)}',
              color: const Color(0xFFE8F5E9),
              textColor: RumenoTheme.successGreen,
              icon: Icons.arrow_upward_rounded,
            ),
            const SizedBox(height: 12),
            _BigSummaryCard(
              emoji: net >= 0 ? '😊' : '😟',
              label: net >= 0 ? 'Profit' : 'Loss',
              value: '₹${net.abs().toStringAsFixed(0)}',
              color: net >= 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              textColor: net >= 0 ? RumenoTheme.successGreen : RumenoTheme.errorRed,
              icon: net >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            ),
            const SizedBox(height: 24),

            // ── Quick Actions (icon grid for illiterate users) ──
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Quick Add Expense', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
            ),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
              children: [
                _QuickActionTile(icon: Icons.grass_rounded, label: 'Feed', color: Colors.green, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.feed)),
                _QuickActionTile(icon: Icons.medication_rounded, label: 'Medicine', color: Colors.red, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.medicine)),
                _QuickActionTile(icon: Icons.local_hospital_rounded, label: 'Doctor', color: Colors.blue, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.veterinary)),
                _QuickActionTile(icon: Icons.people_rounded, label: 'Labour', color: Colors.orange, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.labour)),
                _QuickActionTile(icon: Icons.build_rounded, label: 'Equipment', color: Colors.purple, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.equipment)),
                _QuickActionTile(icon: Icons.local_shipping_rounded, label: 'Transport', color: Colors.teal, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.transport)),
                _QuickActionTile(icon: Icons.more_horiz_rounded, label: 'Other', color: Colors.grey, onTap: () => _showAddExpenseSteps(context, preselectedCategory: ExpenseCategory.other)),
                _QuickActionTile(icon: Icons.list_alt_rounded, label: 'All\nExpenses', color: RumenoTheme.primaryGreen, onTap: () => context.go('/farmer/finance/expenses')),
              ],
            ),
            const SizedBox(height: 24),

            // ── Expense breakdown ──
            PieChartWidget(
              title: 'Where Money Goes',
              entries: const [
                PieChartEntry(label: '🌾 Feed', value: 45, color: Colors.green),
                PieChartEntry(label: '👷 Labour', value: 25, color: Colors.orange),
                PieChartEntry(label: '💊 Medicine', value: 12, color: Colors.red),
                PieChartEntry(label: '🏥 Doctor', value: 8, color: Colors.blue),
                PieChartEntry(label: '🔧 Equipment', value: 6, color: Colors.purple),
                PieChartEntry(label: '📦 Other', value: 4, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),

            // ── Monthly trend ──
            LineChartWidget(
              title: 'Monthly Spending',
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
        onPressed: () => _showAddExpenseSteps(context),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
        label: const Text('Add Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }

  void _showAddExpenseSteps(BuildContext context, {ExpenseCategory? preselectedCategory}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddExpenseWizard(preselectedCategory: preselectedCategory),
    );
  }
}

// ── Step-by-step Add Expense Wizard ──
class _AddExpenseWizard extends StatefulWidget {
  final ExpenseCategory? preselectedCategory;
  const _AddExpenseWizard({this.preselectedCategory});

  @override
  State<_AddExpenseWizard> createState() => _AddExpenseWizardState();
}

class _AddExpenseWizardState extends State<_AddExpenseWizard> {
  int _step = 0; // 0=category, 1=amount, 2=payment, 3=details
  ExpenseCategory? _category;
  String _amount = '';
  String _paymentMode = '';
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.preselectedCategory != null) {
      _category = widget.preselectedCategory;
      _step = 1;
    }
  }

  @override
  void dispose() {
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _categoryLabel(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.feed: return '🌾 Feed';
      case ExpenseCategory.medicine: return '💊 Medicine';
      case ExpenseCategory.veterinary: return '🏥 Doctor';
      case ExpenseCategory.labour: return '👷 Labour';
      case ExpenseCategory.equipment: return '🔧 Equipment';
      case ExpenseCategory.transport: return '🚛 Transport';
      case ExpenseCategory.other: return '📦 Other';
    }
  }

  IconData _categoryIcon(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.feed: return Icons.grass_rounded;
      case ExpenseCategory.medicine: return Icons.medication_rounded;
      case ExpenseCategory.veterinary: return Icons.local_hospital_rounded;
      case ExpenseCategory.labour: return Icons.people_rounded;
      case ExpenseCategory.equipment: return Icons.build_rounded;
      case ExpenseCategory.transport: return Icons.local_shipping_rounded;
      case ExpenseCategory.other: return Icons.more_horiz_rounded;
    }
  }

  Color _categoryColor(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.feed: return Colors.green;
      case ExpenseCategory.medicine: return Colors.red;
      case ExpenseCategory.veterinary: return Colors.blue;
      case ExpenseCategory.labour: return Colors.orange;
      case ExpenseCategory.equipment: return Colors.purple;
      case ExpenseCategory.transport: return Colors.teal;
      case ExpenseCategory.other: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),

              // Step indicator
              _StepIndicator(currentStep: _step, totalSteps: 4),
              const SizedBox(height: 20),

              if (_step == 0) _buildCategoryStep(),
              if (_step == 1) _buildAmountStep(),
              if (_step == 2) _buildPaymentStep(),
              if (_step == 3) _buildDetailsStep(),
            ],
          ),
        ),
      ),
    );
  }

  // Step 1: Pick category with big icons
  Widget _buildCategoryStep() {
    return Column(
      children: [
        Text('What did you spend on?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
        const SizedBox(height: 8),
        Text('Tap to select', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: RumenoTheme.textLight, fontSize: 15)),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: ExpenseCategory.values.map((c) {
            final selected = _category == c;
            return GestureDetector(
              onTap: () {
                setState(() { _category = c; _step = 1; });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? _categoryColor(c).withValues(alpha: 0.15) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? _categoryColor(c) : Colors.grey.shade200, width: selected ? 2.5 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_categoryIcon(c), color: _categoryColor(c), size: 40),
                    const SizedBox(height: 8),
                    Text(_categoryLabel(c), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: _categoryColor(c)), textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 2: Enter amount with big number pad
  Widget _buildAmountStep() {
    return Column(
      children: [
        if (_category != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: _categoryColor(_category!).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(_categoryIcon(_category!), color: _categoryColor(_category!), size: 22),
              const SizedBox(width: 8),
              Text(_categoryLabel(_category!), style: TextStyle(fontWeight: FontWeight.w600, color: _categoryColor(_category!))),
            ]),
          ),
          const SizedBox(height: 16),
        ],
        Text('How much did you pay?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
        const SizedBox(height: 20),
        // Big amount display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RumenoTheme.primaryGreen, width: 2),
          ),
          child: Center(
            child: Text(
              _amount.isEmpty ? '₹ 0' : '₹ $_amount',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: _amount.isEmpty ? Colors.grey.shade400 : RumenoTheme.textDark),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Number pad
        _buildNumberPad(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _step = 0),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back', style: TextStyle(fontSize: 16)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _amount.isNotEmpty ? () => setState(() => _step = 2) : null,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        for (final row in [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9'], ['.', '0', '⌫']])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: row.map((key) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: key == '⌫' ? Colors.red.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          if (key == '⌫') {
                            if (_amount.isNotEmpty) _amount = _amount.substring(0, _amount.length - 1);
                          } else if (key == '.') {
                            if (!_amount.contains('.')) _amount += '.';
                          } else {
                            if (_amount.length < 8) _amount += key;
                          }
                        });
                      },
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        child: key == '⌫'
                            ? Icon(Icons.backspace_rounded, color: Colors.red.shade700, size: 24)
                            : Text(key, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
      ],
    );
  }

  // Step 3: Payment mode with big icons
  Widget _buildPaymentStep() {
    final modes = [
      {'label': 'Cash', 'icon': Icons.money_rounded, 'emoji': '💵', 'value': 'Cash', 'color': Colors.green},
      {'label': 'UPI', 'icon': Icons.phone_android_rounded, 'emoji': '📱', 'value': 'UPI', 'color': Colors.purple},
      {'label': 'Bank', 'icon': Icons.account_balance_rounded, 'emoji': '🏦', 'value': 'Bank', 'color': Colors.blue},
      {'label': 'Credit', 'icon': Icons.credit_card_rounded, 'emoji': '💳', 'value': 'Credit', 'color': Colors.orange},
    ];

    return Column(
      children: [
        Text('How did you pay?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
        const SizedBox(height: 8),
        Text('Tap to select', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: RumenoTheme.textLight, fontSize: 15)),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: modes.map((m) {
            final selected = _paymentMode == m['value'];
            final color = m['color'] as Color;
            return GestureDetector(
              onTap: () {
                setState(() { _paymentMode = m['value'] as String; _step = 3; });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected ? color.withValues(alpha: 0.15) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? color : Colors.grey.shade200, width: selected ? 2.5 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m['emoji'] as String, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 6),
                    Text(m['label'] as String, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: selected ? color : RumenoTheme.textDark)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _step = 1),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back', style: TextStyle(fontSize: 16)),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
      ],
    );
  }

  // Step 4: Optional details + save
  Widget _buildDetailsStep() {
    return Column(
      children: [
        Text('Almost Done! ✅', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
        const SizedBox(height: 8),
        Text('Add details (optional)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: RumenoTheme.textLight, fontSize: 15)),
        const SizedBox(height: 20),

        // Summary of selections
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Row(children: [
                if (_category != null) Icon(_categoryIcon(_category!), color: _categoryColor(_category!), size: 28),
                const SizedBox(width: 10),
                Text(_category != null ? _categoryLabel(_category!) : '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('₹$_amount', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.errorRed)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.payment_rounded, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Payment: $_paymentMode', style: TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _vendorController,
          decoration: InputDecoration(
            labelText: 'Shop / Person Name',
            hintText: 'Who did you pay?',
            prefixIcon: const Icon(Icons.store_rounded),
            labelStyle: const TextStyle(fontSize: 16),
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: 'Notes',
            hintText: 'Any extra details...',
            prefixIcon: const Icon(Icons.note_alt_rounded),
            labelStyle: const TextStyle(fontSize: 16),
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          maxLines: 2,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _step = 2),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back', style: TextStyle(fontSize: 16)),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Text('₹$_amount expense saved! ✅'),
                      ]),
                      backgroundColor: RumenoTheme.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.save_rounded, size: 24),
                label: const Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Step Indicator Widget ──
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final labels = ['Type', 'Amount', 'Payment', 'Save'];
    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i <= currentStep;
        final isCurrent = i == currentStep;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (i > 0) Expanded(child: Container(height: 3, color: isActive ? RumenoTheme.primaryGreen : Colors.grey.shade300)),
                  CircleAvatar(
                    radius: isCurrent ? 16 : 12,
                    backgroundColor: isActive ? RumenoTheme.primaryGreen : Colors.grey.shade300,
                    child: i < currentStep
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                        : Text('${i + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  if (i < totalSteps - 1) Expanded(child: Container(height: 3, color: i < currentStep ? RumenoTheme.primaryGreen : Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 4),
              Text(labels[i], style: TextStyle(fontSize: 11, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, color: isActive ? RumenoTheme.primaryGreen : Colors.grey)),
            ],
          ),
        );
      }),
    );
  }
}

// ── Big Summary Card ──
class _BigSummaryCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final IconData icon;

  const _BigSummaryCard({required this.emoji, required this.label, required this.value, required this.color, required this.textColor, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 15, color: textColor.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
              ],
            ),
          ),
          Icon(icon, color: textColor.withValues(alpha: 0.5), size: 32),
        ],
      ),
    );
  }
}

// ── Quick Action Tile ──
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }
}
