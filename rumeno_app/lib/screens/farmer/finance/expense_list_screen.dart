import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_finance.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/expense_card.dart';
import '../../../widgets/common/search_bar_widget.dart';
import '../../../widgets/common/marketplace_button.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  ExpenseCategory? _selectedCategory;
  String _search = '';

  List<ExpenseRecord> get _filtered {
    var list = mockExpenses.toList();
    if (_selectedCategory != null) {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }
    if (_search.isNotEmpty) {
      list = list.where((e) =>
          e.categoryName.toLowerCase().contains(_search.toLowerCase()) ||
          (e.vendorName ?? '').toLowerCase().contains(_search.toLowerCase())).toList();
    }
    return list;
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

  String _categoryLabel(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.feed: return '🌾 Feed';
      case ExpenseCategory.medicine: return '💊 Medicine';
      case ExpenseCategory.veterinary: return '🏥 Doctor';
      case ExpenseCategory.labour: return '👷 Labour';
      case ExpenseCategory.equipment: return '🔧 Equip';
      case ExpenseCategory.transport: return '🚛 Travel';
      case ExpenseCategory.other: return '📦 Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalAmount = filtered.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('📋 All Expenses'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: Column(
        children: [
          SearchBarWidget(hintText: 'Search expenses...', onChanged: (v) => setState(() => _search = v)),

          // Total amount banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('📉', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Spent', style: TextStyle(fontSize: 13, color: RumenoTheme.errorRed.withValues(alpha: 0.7))),
                    Text('₹${totalAmount.toStringAsFixed(0)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.errorRed)),
                  ],
                ),
                const Spacer(),
                Text('${filtered.length} items', style: TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
              ],
            ),
          ),

          // Visual category filter chips with icons
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _visualChip('🔍 All', null, _selectedCategory == null, () => setState(() => _selectedCategory = null)),
                ...ExpenseCategory.values.map((c) => _visualChip(
                  _categoryLabel(c),
                  _categoryIcon(c),
                  _selectedCategory == c,
                  () => setState(() => _selectedCategory = _selectedCategory == c ? null : c),
                  color: _categoryColor(c),
                )),
              ],
            ),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No expenses found', style: TextStyle(fontSize: 16, color: RumenoTheme.textGrey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => ExpenseCard(expense: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _visualChip(String label, IconData? icon, bool selected, VoidCallback onTap, {Color? color}) {
    final chipColor = color ?? RumenoTheme.primaryGreen;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? chipColor.withValues(alpha: 0.15) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: selected ? chipColor : Colors.grey.shade300, width: selected ? 2 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && selected) ...[
                Icon(icon, size: 18, color: chipColor),
                const SizedBox(width: 4),
              ],
              Text(label, style: TextStyle(color: selected ? chipColor : RumenoTheme.textDark, fontSize: 13, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}
