import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/charts/bar_chart_widget.dart';
import '../../../widgets/charts/pie_chart_widget.dart';
import '../../../widgets/common/date_range_picker_widget.dart';
import '../../../widgets/common/marketplace_button.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('📊 Reports'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DateRangePickerWidget(
            onRangeSelected: (_) {},
          ),
          const SizedBox(height: 16),

          // ── Visual Summary Cards ──
          _VisualReportCard(
            emoji: '📉',
            title: 'Total Spent',
            value: '₹3,89,300',
            bgColor: const Color(0xFFFFEBEE),
            textColor: RumenoTheme.errorRed,
          ),
          const SizedBox(height: 10),
          _VisualReportCard(
            emoji: '📈',
            title: 'Total Earned',
            value: '₹5,20,000',
            bgColor: const Color(0xFFE8F5E9),
            textColor: RumenoTheme.successGreen,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _VisualReportCard(
                  emoji: '😊',
                  title: 'Profit',
                  value: '₹1,30,700',
                  bgColor: const Color(0xFFE8F5E9),
                  textColor: RumenoTheme.successGreen,
                  compact: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VisualReportCard(
                  emoji: '📅',
                  title: 'Per Month',
                  value: '₹21,783',
                  bgColor: const Color(0xFFE3F2FD),
                  textColor: RumenoTheme.infoBlue,
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          BarChartWidget(
            title: '🌾 Where Money Goes',
            values: const [175000, 97000, 46300, 24000, 25000, 3500, 18500],
            labels: const ['Feed', 'Labour', 'Medicine', 'Vet', 'Equip', 'Transport', 'Other'],
          ),
          const SizedBox(height: 16),

          PieChartWidget(
            title: '💳 How You Pay',
            entries: const [
              PieChartEntry(label: '💵 Cash', value: 35, color: Colors.orange),
              PieChartEntry(label: '📱 UPI', value: 40, color: Colors.purple),
              PieChartEntry(label: '🏦 Bank', value: 22, color: Colors.blue),
              PieChartEntry(label: '💳 Credit', value: 3, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),

          // ── Export Buttons (visual) ──
          Row(
            children: [
              Expanded(
                child: _ExportButton(
                  icon: Icons.table_chart_rounded,
                  label: 'Download\nSheet',
                  color: Colors.green,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(children: [Icon(Icons.check_circle_rounded, color: Colors.white), SizedBox(width: 10), Text('CSV file downloaded! ✅')]),
                      backgroundColor: RumenoTheme.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExportButton(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'Download\nPDF',
                  color: Colors.red,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(children: [Icon(Icons.check_circle_rounded, color: Colors.white), SizedBox(width: 10), Text('PDF file downloaded! ✅')]),
                      backgroundColor: RumenoTheme.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
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

class _VisualReportCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final Color bgColor;
  final Color textColor;
  final bool compact;

  const _VisualReportCard({
    required this.emoji,
    required this.title,
    required this.value,
    required this.bgColor,
    required this.textColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: compact ? 24 : 32)),
          SizedBox(width: compact ? 10 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: compact ? 12 : 14, color: textColor.withValues(alpha: 0.7), fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: TextStyle(fontSize: compact ? 18 : 22, fontWeight: FontWeight.bold, color: textColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ExportButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
