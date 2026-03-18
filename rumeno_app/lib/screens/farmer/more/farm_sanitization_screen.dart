import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/marketplace_button.dart';

// ── Model ────────────────────────────────────────────────────────────────────

class SanitizationRecord {
  final String id;
  final DateTime date;
  final List<String> sanitizerNames;
  final DateTime? nextDate;
  final List<String> areas;
  final String? notes;

  SanitizationRecord({
    required this.id,
    required this.date,
    required this.sanitizerNames,
    this.nextDate,
    this.areas = const [],
    this.notes,
  });
}

// ── Options ───────────────────────────────────────────────────────────────────

class _Option {
  final String emoji;
  final String name;
  const _Option(this.emoji, this.name);
}

const List<_Option> _sanitizerOptions = [
  _Option('🧴', 'Bleach (Sodium Hypochlorite)'),
  _Option('🫧', 'Phenyl'),
  _Option('🟡', 'Dettol Antiseptic'),
  _Option('🟤', 'Iodine Solution'),
  _Option('⬜', 'Quicklime (Chuna)'),
  _Option('🧪', 'Formalin'),
  _Option('🟣', 'Potassium Permanganate'),
  _Option('💧', 'Hydrogen Peroxide'),
  _Option('🔴', 'Virkon-S'),
];

const List<_Option> _areaOptions = [
  _Option('🏠', 'Full Farm'),
  _Option('🐄', 'Cow Shed'),
  _Option('🐐', 'Goat Pen'),
  _Option('🐷', 'Pig Pen'),
  _Option('🐔', 'Poultry Area'),
  _Option('🚿', 'Water Trough'),
  _Option('🌾', 'Feed Storage'),
  _Option('🚪', 'Entry Gate'),
];

// ── Mock Data ─────────────────────────────────────────────────────────────────

final List<SanitizationRecord> _mockSanitizationRecords = [
  SanitizationRecord(
    id: 'san1',
    date: DateTime.now().subtract(const Duration(days: 12)),
    sanitizerNames: ['Bleach (Sodium Hypochlorite)', 'Phenyl'],
    nextDate: DateTime.now().add(const Duration(days: 18)),
    areas: ['Cow Shed', 'Water Trough'],
    notes: 'Full wash done after rain',
  ),
  SanitizationRecord(
    id: 'san2',
    date: DateTime.now().subtract(const Duration(days: 43)),
    sanitizerNames: ['Quicklime (Chuna)', 'Iodine Solution'],
    nextDate: DateTime.now().subtract(const Duration(days: 13)),
    areas: ['Full Farm'],
  ),
  SanitizationRecord(
    id: 'san3',
    date: DateTime.now().subtract(const Duration(days: 80)),
    sanitizerNames: ['Virkon-S'],
    nextDate: DateTime.now().subtract(const Duration(days: 50)),
    areas: ['Cow Shed', 'Goat Pen', 'Entry Gate'],
    notes: 'After disease outbreak scare',
  ),
];

// ── Top-level helpers ─────────────────────────────────────────────────────────

Widget _buildStepLabel(String step, String emoji, String title) {
  return Row(
    children: [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: RumenoTheme.primaryGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(step,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(width: 10),
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: RumenoTheme.textDark)),
    ],
  );
}

Widget _buildDatePickerButton({
  required DateTime? date,
  required String emptyLabel,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  VoidCallback? onClear,
}) {
  final hasDate = date != null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  String dayLabel = '';
  if (hasDate) {
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) {
      dayLabel = 'Today  •  ${DateFormat('d MMM yyyy').format(date)}';
    } else if (d == today.subtract(const Duration(days: 1))) {
      dayLabel = 'Yesterday  •  ${DateFormat('d MMM yyyy').format(date)}';
    } else if (d == today.add(const Duration(days: 1))) {
      dayLabel = 'Tomorrow  •  ${DateFormat('d MMM yyyy').format(date)}';
    } else {
      dayLabel = DateFormat('EEE,  d MMM yyyy').format(date);
    }
  }

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: hasDate ? 0.07 : 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: hasDate ? 0.5 : 0.25),
          width: hasDate ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: hasDate
                ? Text(
                    dayLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                : Text(emptyLabel,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: color.withValues(alpha: 0.7))),
          ),
          if (hasDate && onClear != null)
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close_rounded,
                    color: RumenoTheme.errorRed, size: 18),
              ),
            )
          else
            Icon(Icons.edit_calendar_rounded,
                color: color.withValues(alpha: 0.5), size: 20),
        ],
      ),
    ),
  );
}

// ── Screen ────────────────────────────────────────────────────────────────────

class FarmSanitizationScreen extends StatefulWidget {
  const FarmSanitizationScreen({super.key});

  @override
  State<FarmSanitizationScreen> createState() => _FarmSanitizationScreenState();
}

class _FarmSanitizationScreenState extends State<FarmSanitizationScreen> {
  late List<SanitizationRecord> _records;

  @override
  void initState() {
    super.initState();
    _records = List.from(_mockSanitizationRecords);
    _records.sort((a, b) => b.date.compareTo(a.date));
  }

  // ── Summary helpers ──────────────────────────────────────────────────

  SanitizationRecord? get _lastRecord => _records.isNotEmpty ? _records.first : null;

  DateTime? get _nextDueDate {
    final upcoming = _records
        .where((r) => r.nextDate != null && r.nextDate!.isAfter(DateTime.now()))
        .toList();
    if (upcoming.isEmpty) return null;
    upcoming.sort((a, b) => a.nextDate!.compareTo(b.nextDate!));
    return upcoming.first.nextDate;
  }

  bool get _hasOverdue => _records.any((r) =>
      r.nextDate != null &&
      r.nextDate!.isBefore(DateTime.now()));

  // ── Add Record Bottom Sheet ───────────────────────────────────────────

  void _showAddDialog() {
    DateTime selectedDate = DateTime.now();
    DateTime? nextDate;
    final List<String> selectedSanitizers = [];
    final List<String> selectedAreas = [];
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.93,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // ── Handle ──
              const SizedBox(height: 14),
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),

              // ── Sheet Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('🧹',
                          style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add Sanitization',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 24, color: Colors.grey.shade200),

              // ── Form ──
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      20, 0, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Step 1: Date Done ───────────────────────────
                      _buildStepLabel('1', '🗓️', 'Sanitization Date'),
                      const SizedBox(height: 10),
                      _buildDatePickerButton(
                        date: selectedDate,
                        emptyLabel: 'Select Date',
                        icon: Icons.event_rounded,
                        color: const Color(0xFF2196F3),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // ─── Step 2: Sanitizer Names (Multi-select) ──────
                      _buildStepLabel('2', '🧴', 'Sanitizer Used'),
                      const SizedBox(height: 6),
                      Text('Tap to select — select multiple',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: _sanitizerOptions.map((opt) {
                          final isSelected =
                              selectedSanitizers.contains(opt.name);
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  selectedSanitizers.remove(opt.name);
                                } else {
                                  selectedSanitizers.add(opt.name);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 11),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF2196F3)
                                              .withValues(alpha: 0.28),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(opt.emoji,
                                      style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 7),
                                  Text(
                                    opt.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : RumenoTheme.textDark,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 5),
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 16),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (selectedSanitizers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Text('⚠️',
                                  style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text('Select at least one sanitizer',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: RumenoTheme.errorRed
                                          .withValues(alpha: 0.8))),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ─── Step 3: Area Cleaned ────────────────────────
                      _buildStepLabel('3', '📍', 'Area Cleaned'),
                      const SizedBox(height: 6),
                      Text('Tap to select — select multiple',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: _areaOptions.map((opt) {
                          final isSelected =
                              selectedAreas.contains(opt.name);
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (opt.name == 'Full Farm') {
                                  if (isSelected) {
                                    selectedAreas.clear();
                                  } else {
                                    selectedAreas.clear();
                                    selectedAreas.add('Full Farm');
                                  }
                                } else {
                                  selectedAreas.remove('Full Farm');
                                  if (isSelected) {
                                    selectedAreas.remove(opt.name);
                                  } else {
                                    selectedAreas.add(opt.name);
                                  }
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 11),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? RumenoTheme.primaryGreen
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? RumenoTheme.primaryGreen
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: RumenoTheme.primaryGreen
                                              .withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(opt.emoji,
                                      style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 7),
                                  Text(
                                    opt.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : RumenoTheme.textDark,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 5),
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 16),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // ─── Step 4: Next Sanitization Date ─────────────
                      _buildStepLabel('4', '⏰', 'Next Sanitization Date'),
                      const SizedBox(height: 8),

                      // Alert info
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            const Text('🔔',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Set a date — you will get an alert reminder on that day.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.amber.shade900),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildDatePickerButton(
                        date: nextDate,
                        emptyLabel: 'Set Next Date (Optional)',
                        icon: Icons.alarm_on_rounded,
                        color: Colors.orange,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate
                                .add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => nextDate = picked);
                          }
                        },
                        onClear: nextDate != null
                            ? () => setModalState(() => nextDate = null)
                            : null,
                      ),

                      const SizedBox(height: 24),

                      // ─── Step 5: Notes (optional) ────────────────────
                      _buildStepLabel('5', '📝', 'Notes (Optional)'),
                      const SizedBox(height: 10),
                      TextField(
                        controller: notesCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Full wash done after disease scare…',
                          hintStyle:
                              const TextStyle(color: RumenoTheme.textLight),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: RumenoTheme.primaryGreen, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ─── Save Button ─────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedSanitizers.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      '⚠️  Please select at least one sanitizer'),
                                  backgroundColor: RumenoTheme.errorRed,
                                ),
                              );
                              return;
                            }
                            final rec = SanitizationRecord(
                              id: 'san${DateTime.now().millisecondsSinceEpoch}',
                              date: selectedDate,
                              sanitizerNames: List.from(selectedSanitizers),
                              nextDate: nextDate,
                              areas: List.from(selectedAreas),
                              notes: notesCtrl.text.trim().isEmpty
                                  ? null
                                  : notesCtrl.text.trim(),
                            );
                            setState(() {
                              _records.insert(0, rec);
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅  Sanitization record saved!'),
                                backgroundColor: RumenoTheme.successGreen,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('💾', style: TextStyle(fontSize: 22)),
                              SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Save Record',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lastDone = _lastRecord;
    final nextDue = _nextDueDate;
    final overdue = _hasOverdue;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🧹', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Farm Sanitization'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/farmer/more');
            }
          },
        ),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        icon: const Text('➕', style: TextStyle(fontSize: 18)),
        label: const Text('Add Record',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  // ── Info Banner ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF2196F3).withValues(alpha: 0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('🧼',
                            style: TextStyle(fontSize: 44)),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Farm Sanitization',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 3),
                              Text(
                                'Keep animals healthy by cleaning the farm regularly.',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Overdue Alert ──
                  if (overdue)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: RumenoTheme.errorRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: RumenoTheme.errorRed.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        children: [
                          Text('⚠️', style: TextStyle(fontSize: 22)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sanitization Overdue!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: RumenoTheme.errorRed,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Summary Cards ──
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryTile(
                          emoji: '📅',
                          label: 'Last Done',
                          value: lastDone != null
                              ? _daysAgoLabel(lastDone.date)
                              : 'Not done yet',
                          color: RumenoTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryTile(
                          emoji: '⏰',
                          label: 'Next Due',
                          value: nextDue != null
                              ? _daysFromNowLabel(nextDue)
                              : 'Not set',
                          color: nextDue != null &&
                                  nextDue.isBefore(DateTime.now()
                                      .add(const Duration(days: 3)))
                              ? Colors.orange
                              : const Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Section Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Text('📋',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  const Text('Sanitization History',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: RumenoTheme.textDark)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${_records.length} records',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2196F3))),
                  ),
                ],
              ),
            ),
          ),

          // ── Record List ──
          _records.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    child: Column(
                      children: [
                        const Text('🧹',
                            style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        const Text('No sanitization records yet',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: RumenoTheme.textDark)),
                        const SizedBox(height: 8),
                        Text(
                            'Tap the ➕ button below to add your first sanitization record.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,
                                color: RumenoTheme.textGrey)),
                        const SizedBox(height: 6),
                        Text('नीचे बटन दबाएं - साफाई का रिकॉर्ड जोड़ें।',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12,
                                color: RumenoTheme.textLight)),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _RecordCard(record: _records[i]),
                    childCount: _records.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }

  String _daysAgoLabel(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  String _daysFromNowLabel(DateTime date) {
    final diff = date.difference(DateTime.now()).inDays;
    if (diff < 0) return '${diff.abs()}d overdue';
    if (diff == 0) return 'Today!';
    if (diff == 1) return 'Tomorrow';
    return 'In $diff days';
  }
}

// ── Summary Tile Widget ───────────────────────────────────────────────────────

class _SummaryTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.13),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: RumenoTheme.textGrey)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Record Card Widget ────────────────────────────────────────────────────────

class _RecordCard extends StatelessWidget {
  final SanitizationRecord record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isNextOverdue =
        record.nextDate != null && record.nextDate!.isBefore(now);
    final bool isNextSoon = record.nextDate != null &&
        !isNextOverdue &&
        record.nextDate!.isBefore(now.add(const Duration(days: 7)));

    Color nextBadgeColor = RumenoTheme.successGreen;
    String nextBadgeText = '';
    if (isNextOverdue) {
      nextBadgeColor = RumenoTheme.errorRed;
      final days = now.difference(record.nextDate!).inDays;
      nextBadgeText = '$days day${days == 1 ? '' : 's'} overdue';
    } else if (isNextSoon) {
      nextBadgeColor = RumenoTheme.warningYellow;
      final days = record.nextDate!.difference(now).inDays;
      nextBadgeText = days == 0 ? 'Due Today!' : 'Due in $days day${days == 1 ? '' : 's'}';
    } else if (record.nextDate != null) {
      final days = record.nextDate!.difference(now).inDays;
      nextBadgeText = 'In $days days';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withValues(alpha: 0.07),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                const Text('🧹', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(record.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: RumenoTheme.textDark,
                        ),
                      ),
                      Text(
                        _daysAgo(record.date),
                        style: const TextStyle(
                            fontSize: 12, color: RumenoTheme.textGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Done ✅',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2196F3))),
                ),
              ],
            ),
          ),

          // ── Sanitizers Used ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🧴', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    const Text('Sanitizers Used',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: RumenoTheme.textGrey)),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: record.sanitizerNames.map((name) {
                    final opt = _sanitizerOptions
                        .where((o) => o.name == name)
                        .firstOrNull;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF2196F3)
                                .withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (opt != null) ...[
                            Text(opt.emoji,
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 5),
                          ],
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1565C0))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ── Areas ──
          if (record.areas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('📍', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      const Text('Areas Cleaned',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: RumenoTheme.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: record.areas.map((area) {
                      final opt = _areaOptions
                          .where((o) => o.name == area)
                          .firstOrNull;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: RumenoTheme.primaryGreen
                              .withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: RumenoTheme.primaryGreen
                                  .withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (opt != null) ...[
                              Text(opt.emoji,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 5),
                            ],
                            Text(area,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: RumenoTheme.primaryDarkGreen)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // ── Next Date ──
          if (record.nextDate != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isNextOverdue
                      ? RumenoTheme.errorRed.withValues(alpha: 0.07)
                      : isNextSoon
                          ? RumenoTheme.warningYellow.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: nextBadgeColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Text(isNextOverdue ? '⚠️' : '🔔',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next: ${DateFormat('d MMM yyyy').format(record.nextDate!)}',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: nextBadgeColor),
                          ),
                          Text(nextBadgeText,
                              style: TextStyle(
                                  fontSize: 11, color: nextBadgeColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Notes ──
          if (record.notes != null && record.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📝', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(record.notes!,
                        style: const TextStyle(
                            fontSize: 12, color: RumenoTheme.textGrey)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }

  String _daysAgo(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}
