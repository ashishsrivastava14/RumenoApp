import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_finance.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/expense_card.dart';
import '../../../widgets/common/search_bar_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('All Expenses')),
      body: Column(
        children: [
          SearchBarWidget(hintText: 'Search expenses...', onChanged: (v) => setState(() => _search = v)),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip('All', _selectedCategory == null, () => setState(() => _selectedCategory = null)),
                ...ExpenseCategory.values.map((c) => _chip(c.name, _selectedCategory == c, () => setState(() => _selectedCategory = c))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) => ExpenseCard(expense: _filtered[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label, style: TextStyle(color: selected ? Colors.white : RumenoTheme.textDark, fontSize: 12)),
          backgroundColor: selected ? RumenoTheme.primaryGreen : Colors.white,
          side: BorderSide(color: selected ? RumenoTheme.primaryGreen : Colors.grey.shade300),
        ),
      ),
    );
  }
}
