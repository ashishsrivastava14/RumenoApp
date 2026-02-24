import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String>? bottomLabels;
  final String? title;
  final Color? lineColor;
  final double? minY;
  final double? maxY;

  const LineChartWidget({
    super.key,
    required this.spots,
    this.bottomLabels,
    this.title,
    this.lineColor,
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final color = lineColor ?? RumenoTheme.primaryGreen;
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
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: bottomLabels != null,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (bottomLabels != null && idx >= 0 && idx < bottomLabels!.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              bottomLabels![idx],
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: spots.length.toDouble() - 1,
                minY: minY ?? 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 800),
            ),
          ),
        ],
      ),
    );
  }
}
