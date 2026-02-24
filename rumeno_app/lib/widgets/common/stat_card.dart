import 'package:flutter/material.dart';
import '../../config/theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? trend;
  final bool isUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.trend,
    this.isUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? RumenoTheme.primaryGreen;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: cardColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: RumenoTheme.textDark,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: RumenoTheme.textGrey,
                ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: isUp ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                ),
                const SizedBox(width: 4),
                Text(
                  trend!,
                  style: TextStyle(
                    fontSize: 11,
                    color: isUp ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
