import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartEntry> entries;
  final String? title;
  final double radius;

  const PieChartWidget({
    super.key,
    required this.entries,
    this.title,
    this.radius = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(title!, style: Theme.of(context).textTheme.titleMedium),
            ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: entries
                          .map((e) => PieChartSectionData(
                                value: e.value,
                                color: e.color,
                                title: '${e.value.toStringAsFixed(0)}%',
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                radius: radius,
                              ))
                          .toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                    ),
                    duration: const Duration(milliseconds: 800),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: e.color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                e.label,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PieChartEntry {
  final String label;
  final double value;
  final Color color;

  const PieChartEntry({
    required this.label,
    required this.value,
    required this.color,
  });
}
