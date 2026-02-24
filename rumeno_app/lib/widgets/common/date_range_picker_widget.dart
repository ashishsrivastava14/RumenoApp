import 'package:flutter/material.dart';
import '../../config/theme.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const DateRangePickerWidget({
    super.key,
    this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime(2027),
          initialDateRange: selectedRange,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: RumenoTheme.primaryGreen,
                ),
              ),
              child: child!,
            );
          },
        );
        if (range != null) {
          onRangeSelected(range);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.date_range, color: RumenoTheme.primaryGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              selectedRange != null
                  ? '${_fmt(selectedRange!.start)} - ${_fmt(selectedRange!.end)}'
                  : 'Select Date Range',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
