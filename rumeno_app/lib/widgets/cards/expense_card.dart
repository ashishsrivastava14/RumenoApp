import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseRecord expense;
  final VoidCallback? onTap;

  const ExpenseCard({super.key, required this.expense, this.onTap});

  IconData _categoryIcon(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.feed: return Icons.grass;
      case ExpenseCategory.medicine: return Icons.medication;
      case ExpenseCategory.veterinary: return Icons.local_hospital;
      case ExpenseCategory.labour: return Icons.people;
      case ExpenseCategory.equipment: return Icons.build;
      case ExpenseCategory.transport: return Icons.local_shipping;
      case ExpenseCategory.other: return Icons.more_horiz;
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _categoryColor(expense.category).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_categoryIcon(expense.category), color: _categoryColor(expense.category), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.categoryName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    '${expense.subCategory ?? ''} ${expense.vendorName != null ? '• ${expense.vendorName}' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(DateFormat('dd MMM yyyy').format(expense.date), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textLight)),
                ],
              ),
            ),
            Text(
              '₹${expense.amount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: RumenoTheme.errorRed),
            ),
          ],
        ),
      ),
    );
  }
}
