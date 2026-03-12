import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/marketplace_button.dart';

class DataExportScreen extends StatefulWidget {
  const DataExportScreen({super.key});

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen> {
  final Set<String> _selected = {};
  String _format = 'PDF';
  bool _exporting = false;

  static const _exportOptions = [
    {'key': 'animals', 'emoji': '🐄', 'title': 'Animals', 'subtitle': 'All animal records', 'color': Color(0xFF4CAF50)},
    {'key': 'health', 'emoji': '🩺', 'title': 'Health', 'subtitle': 'Vaccination & treatment', 'color': Color(0xFFE53935)},
    {'key': 'breeding', 'emoji': '🐣', 'title': 'Breeding', 'subtitle': 'Breeding records', 'color': Color(0xFFFF9800)},
    {'key': 'finance', 'emoji': '💰', 'title': 'Finance', 'subtitle': 'Income & expenses', 'color': Color(0xFF2196F3)},
    {'key': 'milk', 'emoji': '🥛', 'title': 'Milk Records', 'subtitle': 'Daily milk data', 'color': Color(0xFF00BCD4)},
    {'key': 'team', 'emoji': '👥', 'title': 'Team', 'subtitle': 'Team members list', 'color': Color(0xFF9C27B0)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Export Data'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF00838F)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('📋', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 10),
                  const Text(
                    'Save Your Farm Data',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select what you want to download',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Select all button
            Row(
              children: [
                const Text('📂', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                const Text('Select Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_selected.length == _exportOptions.length) {
                        _selected.clear();
                      } else {
                        _selected.addAll(_exportOptions.map((e) => e['key'] as String));
                      }
                    });
                  },
                  child: Text(
                    _selected.length == _exportOptions.length ? 'Deselect All' : 'Select All',
                    style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Export options grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: _exportOptions.map((opt) {
                final key = opt['key'] as String;
                final sel = _selected.contains(key);
                final color = opt['color'] as Color;
                return GestureDetector(
                  onTap: () => setState(() => sel ? _selected.remove(key) : _selected.add(key)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: sel ? color.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: sel ? color : Colors.grey.shade200, width: sel ? 2.5 : 1),
                      boxShadow: sel
                          ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))]
                          : [],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(opt['emoji'] as String, style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 6),
                              Text(
                                opt['title'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: sel ? color : RumenoTheme.textDark,
                                ),
                              ),
                              Text(
                                opt['subtitle'] as String,
                                style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        if (sel)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.check_circle, color: color, size: 22),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Format selection
            Row(
              children: [
                const Text('📄', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                const Text('File Format', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: ['PDF', 'CSV', 'Excel'].map((fmt) {
                final sel = _format == fmt;
                final icons = {'PDF': '📕', 'CSV': '📗', 'Excel': '📊'};
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _format = fmt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: fmt != 'Excel' ? 10 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: sel ? RumenoTheme.primaryGreen.withValues(alpha: 0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel ? RumenoTheme.primaryGreen : Colors.grey.shade200,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(icons[fmt]!, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            fmt,
                            style: TextStyle(
                              fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                              color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
                            ),
                          ),
                          if (sel)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Icon(Icons.check_circle, color: RumenoTheme.primaryGreen, size: 16),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Export button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _selected.isEmpty || _exporting
                    ? null
                    : () async {
                        setState(() => _exporting = true);
                        await Future.delayed(const Duration(seconds: 2));
                        if (!context.mounted) return;
                        setState(() => _exporting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('📥 ${_selected.length} file(s) exported as $_format!'),
                            backgroundColor: RumenoTheme.successGreen,
                          ),
                        );
                      },
                icon: _exporting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Icon(Icons.download_rounded, size: 26),
                label: Text(
                  _exporting
                      ? 'Exporting...'
                      : _selected.isEmpty
                          ? 'Select Data First'
                          : 'Download ${_selected.length} item(s)',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selected.isEmpty ? Colors.grey : RumenoTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
