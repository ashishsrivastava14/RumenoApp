import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_kids.dart';
import '../../../models/models.dart';
import '../../../widgets/common/marketplace_button.dart';

class KidManagementScreen extends StatefulWidget {
  const KidManagementScreen({super.key});

  @override
  State<KidManagementScreen> createState() => _KidManagementScreenState();
}

class _KidManagementScreenState extends State<KidManagementScreen> {
  late List<KidRecord> _kids;
  _KidFilter _filter = _KidFilter.all;
  int _currentPage = 0;
  static const int _pageSize = 6; // fewer per page — bigger cards

  @override
  void initState() {
    super.initState();
    _kids = List.from(mockKids);
  }

  // ─── Filtered list ──────────────────────────
  List<KidRecord> get _filtered {
    switch (_filter) {
      case _KidFilter.notWeaned:
        return _kids.where((k) => !k.isWeaned).toList();
      case _KidFilter.weaned:
        return _kids.where((k) => k.isWeaned).toList();
      case _KidFilter.medicineDue:
        return _kids.where((k) => k.coccidisostatDue).toList();
      case _KidFilter.all:
        return _kids;
    }
  }

  List<KidRecord> get _paginated {
    final f = _filtered;
    final start = _currentPage * _pageSize;
    if (start >= f.length) return [];
    return f.skip(start).take(_pageSize).toList();
  }

  int get _totalPages => (_filtered.length / _pageSize).ceil().clamp(1, 999);

  void _resetPage() => setState(() => _currentPage = 0);

  // ─── Add / Edit ─────────────────────────────
  void _openForm({KidRecord? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _KidFormSheet(
        existing: existing,
        onSave: (record) {
          setState(() {
            if (existing != null) {
              final idx = _kids.indexWhere((k) => k.id == record.id);
              if (idx >= 0) _kids[idx] = record;
            } else {
              _kids.insert(0, record);
            }
          });
          _showSnack(
              existing == null ? '✅ Kid added!' : '✅ Updated!',
              RumenoTheme.successGreen);
        },
      ),
    );
  }

  void _confirmDelete(KidRecord kid) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Big visual warning
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🗑️', style: TextStyle(fontSize: 42)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Delete ${kid.kidId} ?',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Big action buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        side:
                            const BorderSide(color: RumenoTheme.textLight),
                      ),
                      child: const Text('✖  No',
                          style: TextStyle(
                              fontSize: 18, color: RumenoTheme.textDark)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.errorRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogCtx);
                        setState(() =>
                            _kids.removeWhere((k) => k.id == kid.id));
                        _showSnack(
                            '🗑️ ${kid.kidId} deleted',
                            RumenoTheme.errorRed);
                      },
                      child: const Text('🗑️  Yes',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showDetail(KidRecord kid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _KidDetailSheet(
        kid: kid,
        onEdit: () {
          Navigator.pop(context);
          _openForm(existing: kid);
        },
        onDelete: () {
          Navigator.pop(context);
          _confirmDelete(kid);
        },
      ),
    );
  }

  // ─── Build ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final paginated = _paginated;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🐐', style: TextStyle(fontSize: 26)),
            SizedBox(width: 8),
            Text('Kid Management',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: Column(
        children: [
          // ── Big visual filter buttons ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _BigFilterBtn(
                  emoji: '🗂️',
                  label: 'All',
                  selected: _filter == _KidFilter.all,
                  color: RumenoTheme.primaryGreen,
                  onTap: () {
                    setState(() => _filter = _KidFilter.all);
                    _resetPage();
                  },
                ),
                const SizedBox(width: 8),
                _BigFilterBtn(
                  emoji: '🍼',
                  label: 'Milk',
                  selected: _filter == _KidFilter.notWeaned,
                  color: RumenoTheme.infoBlue,
                  onTap: () {
                    setState(() => _filter = _KidFilter.notWeaned);
                    _resetPage();
                  },
                ),
                const SizedBox(width: 8),
                _BigFilterBtn(
                  emoji: '✅',
                  label: 'Weaned',
                  selected: _filter == _KidFilter.weaned,
                  color: RumenoTheme.successGreen,
                  onTap: () {
                    setState(() => _filter = _KidFilter.weaned);
                    _resetPage();
                  },
                ),
                const SizedBox(width: 8),
                _BigFilterBtn(
                  emoji: '💊',
                  label: 'Medicine',
                  selected: _filter == _KidFilter.medicineDue,
                  color: RumenoTheme.errorRed,
                  onTap: () {
                    setState(() => _filter = _KidFilter.medicineDue);
                    _resetPage();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Kid list ──
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState(onAdd: () => _openForm())
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 100),
                    itemCount: paginated.length,
                    itemBuilder: (_, i) => _KidCard(
                      kid: paginated[i],
                      onTap: () => _showDetail(paginated[i]),
                      onEdit: () => _openForm(existing: paginated[i]),
                      onDelete: () => _confirmDelete(paginated[i]),
                    ),
                  ),
          ),

          // ── Simple pagination — big arrows ──
          if (_totalPages > 1)
            _SimplePagination(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPrev: _currentPage > 0
                  ? () => setState(() => _currentPage--)
                  : null,
              onNext: _currentPage < _totalPages - 1
                  ? () => setState(() => _currentPage++)
                  : null,
            ),
        ],
      ),
      // Big floating add button
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: () => _openForm(),
          backgroundColor: RumenoTheme.primaryGreen,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22)),
          child:
              const Icon(Icons.add_rounded, color: Colors.white, size: 38),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────────────────────────────────────

enum _KidFilter { all, notWeaned, weaned, medicineDue }

// ─────────────────────────────────────────────────────────────────────────────
// Big Filter Button — large touch target, icon-centric
// ─────────────────────────────────────────────────────────────────────────────

class _BigFilterBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _BigFilterBtn({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.15) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: selected ? color : RumenoTheme.textLight,
                width: selected ? 2.5 : 1),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: color.withValues(alpha: 0.2), blurRadius: 8)
                  ]
                : [],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? color : RumenoTheme.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Kid Card — big visual card with clear action buttons
// ─────────────────────────────────────────────────────────────────────────────

class _KidCard extends StatelessWidget {
  final KidRecord kid;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KidCard({
    required this.kid,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final weaned = kid.isWeaned;
    final medDue = kid.coccidisostatDue;
    final Color statusColor = medDue
        ? RumenoTheme.errorRed
        : weaned
            ? RumenoTheme.successGreen
            : RumenoTheme.infoBlue;
    final String statusEmoji = medDue ? '💊' : weaned ? '✅' : '🍼';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: medDue
              ? Border.all(
                  color: RumenoTheme.errorRed.withValues(alpha: 0.5),
                  width: 2.5)
              : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            // ── Main info section ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  // Big avatar with colored status ring
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withValues(alpha: 0.1),
                      border: Border.all(color: statusColor, width: 3),
                    ),
                    child: const Center(
                      child:
                          Text('🐐', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Kid info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kid ID — large bold
                        Text(
                          kid.kidId,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: RumenoTheme.textDark),
                        ),
                        const SizedBox(height: 6),
                        // Visual info badges
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          children: [
                            if (kid.dateOfBirth != null)
                              _InfoBadge(
                                  emoji: '🎂',
                                  text: _fmtDate(kid.dateOfBirth!)),
                            if (kid.averageWeightKg != null)
                              _InfoBadge(
                                  emoji: '⚖️',
                                  text:
                                      '${kid.averageWeightKg!.toStringAsFixed(1)} kg'),
                            if (kid.coccidisostatNextDate != null)
                              _InfoBadge(
                                emoji: medDue ? '⚠️' : '💊',
                                text: _fmtDate(
                                    kid.coccidisostatNextDate!),
                                color: medDue
                                    ? RumenoTheme.errorRed
                                    : null,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status emoji badge
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text(statusEmoji,
                        style: const TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
            // ── Action buttons — big & visible ──
            Container(
              decoration: BoxDecoration(
                color: RumenoTheme.backgroundCream.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  // View
                  Expanded(
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility_rounded,
                                color: RumenoTheme.infoBlue, size: 22),
                            SizedBox(width: 6),
                            Text('👁️',
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: 1,
                      height: 36,
                      color: Colors.grey.shade300),
                  // Edit
                  Expanded(
                    child: InkWell(
                      onTap: onEdit,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_rounded,
                                color: RumenoTheme.primaryGreen,
                                size: 22),
                            SizedBox(width: 6),
                            Text('✏️',
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: 1,
                      height: 36,
                      color: Colors.grey.shade300),
                  // Delete
                  Expanded(
                    child: InkWell(
                      onTap: onDelete,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_rounded,
                                color: RumenoTheme.errorRed, size: 22),
                            SizedBox(width: 6),
                            Text('🗑️',
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small info badge used inside kid card
class _InfoBadge extends StatelessWidget {
  final String emoji;
  final String text;
  final Color? color;

  const _InfoBadge({required this.emoji, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? RumenoTheme.textGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 13, color: c, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Kid Detail Sheet — big emoji tiles for all info
// ─────────────────────────────────────────────────────────────────────────────

class _KidDetailSheet extends StatelessWidget {
  final KidRecord kid;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KidDetailSheet({
    required this.kid,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final weaned = kid.isWeaned;
    final medDue = kid.coccidisostatDue;
    final Color statusColor = medDue
        ? RumenoTheme.errorRed
        : weaned
            ? RumenoTheme.successGreen
            : RumenoTheme.infoBlue;
    final String statusLabel =
        medDue ? '💊 Medicine Due' : weaned ? '✅ Weaned' : '🍼 On Milk';

    final mother =
        kid.motherId != null ? getAnimalById(kid.motherId!) : null;
    final motherLabel = mother != null
        ? '${mother.tagId} (${mother.breed})'
        : kid.motherId ?? '—';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill handle
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: 18),
            // Header
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 3),
                  ),
                  child: const Center(
                      child:
                          Text('🐐', style: TextStyle(fontSize: 36))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kid.kidId,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: RumenoTheme.textDark)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color:
                                  statusColor.withValues(alpha: 0.35)),
                        ),
                        child: Text(statusLabel,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            // Detail grid
            _detailGrid([
              _DetailCell(
                  emoji: '🏷️', label: 'Kid ID', value: kid.kidId),
              _DetailCell(
                  emoji: '🐐', label: 'Mother', value: motherLabel),
              _DetailCell(
                  emoji: '🧬',
                  label: 'Father (AI)',
                  value: kid.fatherAiId ?? '—'),
              _DetailCell(
                  emoji: '🎂',
                  label: 'Date of Birth',
                  value: kid.dateOfBirth != null
                      ? _fmtDate(kid.dateOfBirth!)
                      : '—'),
              _DetailCell(
                  emoji: '⚖️',
                  label: 'Avg Weight',
                  value: kid.averageWeightKg != null
                      ? '${kid.averageWeightKg!.toStringAsFixed(1)} kg'
                      : '—'),
              _DetailCell(
                  emoji: '💊',
                  label: 'Coccidiostat',
                  value: kid.coccidisostatName ?? '—'),
              _DetailCell(
                  emoji: '🧪',
                  label: 'Salt Name',
                  value: kid.coccidisostatSaltName ?? '—'),
              _DetailCell(
                  emoji: '📅',
                  label: 'Given On',
                  value: kid.coccidisostatGivenDate != null
                      ? _fmtDate(kid.coccidisostatGivenDate!)
                      : '—'),
              _DetailCell(
                  emoji: medDue ? '⚠️' : '📆',
                  label: 'Next Dose',
                  value: kid.coccidisostatNextDate != null
                      ? _fmtDate(kid.coccidisostatNextDate!)
                      : '—',
                  valueColor: medDue ? RumenoTheme.errorRed : null),
              _DetailCell(
                  emoji: '🌱',
                  label: 'Weaning Date',
                  value: kid.weaningDate != null
                      ? _fmtDate(kid.weaningDate!)
                      : '—',
                  valueColor:
                      weaned ? RumenoTheme.successGreen : null),
              _DetailCell(
                  emoji: '🍼',
                  label: 'Milk Replacer From',
                  value: kid.milkReplacerStartDate != null
                      ? _fmtDate(kid.milkReplacerStartDate!)
                      : '—'),
            ]),
            if (kid.notes != null && kid.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: RumenoTheme.backgroundCream,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text('📝',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(kid.notes!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: RumenoTheme.textGrey)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Big action buttons
            Row(
              children: [
                // Delete
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_rounded, size: 22),
                      label: const Text('🗑️',
                          style: TextStyle(fontSize: 20)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: RumenoTheme.errorRed,
                        side: const BorderSide(
                            color: RumenoTheme.errorRed, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Edit
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 22),
                      label: const Text('✏️ Edit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailGrid(List<_DetailCell> cells) {
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 2) {
      rows.add(Row(children: [
        cells[i],
        const SizedBox(width: 10),
        i + 1 < cells.length
            ? cells[i + 1]
            : const Expanded(child: SizedBox()),
      ]));
      if (i + 2 < cells.length) rows.add(const SizedBox(height: 10));
    }
    return Column(children: rows);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Simple Pagination — big arrows + page counter
// ─────────────────────────────────────────────────────────────────────────────

class _SimplePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _SimplePagination({
    required this.currentPage,
    required this.totalPages,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Prev — big arrow
          _BigArrowBtn(
            icon: Icons.arrow_back_rounded,
            enabled: onPrev != null,
            onTap: onPrev,
          ),
          // Page counter
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: RumenoTheme.backgroundCream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${currentPage + 1} / $totalPages',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: RumenoTheme.textDark),
            ),
          ),
          // Next — big arrow
          _BigArrowBtn(
            icon: Icons.arrow_forward_rounded,
            enabled: onNext != null,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _BigArrowBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _BigArrowBtn(
      {required this.icon, required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: enabled
              ? RumenoTheme.primaryGreen
              : RumenoTheme.backgroundCream,
          borderRadius: BorderRadius.circular(18),
          boxShadow: enabled
              ? [
                  BoxShadow(
                      color: RumenoTheme.primaryGreen
                          .withValues(alpha: 0.3),
                      blurRadius: 8)
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 30,
          color: enabled ? Colors.white : RumenoTheme.textLight,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail Cell — big emoji + value
// ─────────────────────────────────────────────────────────────────────────────

class _DetailCell extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailCell({
    required this.emoji,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: RumenoTheme.backgroundCream,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: RumenoTheme.textGrey)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? RumenoTheme.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐐', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            'No Kids Yet',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: RumenoTheme.textDark),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 28),
              label: const Text('Add Kid',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: RumenoTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit Form Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _KidFormSheet extends StatefulWidget {
  final KidRecord? existing;
  final ValueChanged<KidRecord> onSave;

  const _KidFormSheet({this.existing, required this.onSave});

  @override
  State<_KidFormSheet> createState() => _KidFormSheetState();
}

class _KidFormSheetState extends State<_KidFormSheet> {
  final _kidIdCtrl = TextEditingController();
  final _motherIdCtrl = TextEditingController();
  final _fatherAiIdCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _coccNameCtrl = TextEditingController();
  final _coccSaltCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime? _dateOfBirth;
  DateTime? _coccGivenDate;
  DateTime? _coccNextDate;
  DateTime? _weaningDate;
  DateTime? _milkReplacerStartDate;

  // Coccidiostat presets
  static const _coccPresets = [
    {'name': 'Amprolium', 'salt': 'Amprolium HCl'},
    {'name': 'Toltrazuril', 'salt': 'Toltrazuril 5%'},
    {'name': 'Diclazuril', 'salt': 'Diclazuril 0.5%'},
    {'name': 'Sulfonamides', 'salt': 'Sulfadimidine'},
    {'name': 'Decoquinate', 'salt': 'Decoquinate 6%'},
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _kidIdCtrl.text = e.kidId;
      _motherIdCtrl.text = e.motherId ?? '';
      _fatherAiIdCtrl.text = e.fatherAiId ?? '';
      _weightCtrl.text = e.averageWeightKg?.toString() ?? '';
      _coccNameCtrl.text = e.coccidisostatName ?? '';
      _coccSaltCtrl.text = e.coccidisostatSaltName ?? '';
      _notesCtrl.text = e.notes ?? '';
      _dateOfBirth = e.dateOfBirth;
      _coccGivenDate = e.coccidisostatGivenDate;
      _coccNextDate = e.coccidisostatNextDate;
      _weaningDate = e.weaningDate;
      _milkReplacerStartDate = e.milkReplacerStartDate;
    } else {
      // Auto-suggest next kid ID
      final ids = mockKids.map((k) {
        final n = int.tryParse(k.kidId.replaceAll('K-', ''));
        return n ?? 0;
      }).toList()
        ..sort();
      final next = (ids.isEmpty ? 0 : ids.last) + 1;
      _kidIdCtrl.text = 'K-${next.toString().padLeft(3, '0')}';
    }
  }

  @override
  void dispose() {
    _kidIdCtrl.dispose();
    _motherIdCtrl.dispose();
    _fatherAiIdCtrl.dispose();
    _weightCtrl.dispose();
    _coccNameCtrl.dispose();
    _coccSaltCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
      BuildContext ctx, DateTime? current, ValueChanged<DateTime> onPicked,
      {DateTime? firstDate, DateTime? lastDate}) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: current ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      builder: (_, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: RumenoTheme.primaryGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  void _applyPreset(Map<String, String> preset) {
    setState(() {
      _coccNameCtrl.text = preset['name']!;
      _coccSaltCtrl.text = preset['salt']!;
    });
  }

  void _save() {
    if (_kidIdCtrl.text.trim().isEmpty) {
      _showError('Please enter a Kid ID (e.g. K-001)');
      return;
    }
    final weight = double.tryParse(_weightCtrl.text.trim());
    final record = KidRecord(
      id: widget.existing?.id ??
          'kid_${DateTime.now().millisecondsSinceEpoch}',
      kidId: _kidIdCtrl.text.trim().toUpperCase(),
      motherId: _motherIdCtrl.text.trim().isEmpty
          ? null
          : _motherIdCtrl.text.trim().toUpperCase(),
      fatherAiId: _fatherAiIdCtrl.text.trim().isEmpty
          ? null
          : _fatherAiIdCtrl.text.trim().toUpperCase(),
      dateOfBirth: _dateOfBirth,
      coccidisostatName: _coccNameCtrl.text.trim().isEmpty
          ? null
          : _coccNameCtrl.text.trim(),
      coccidisostatSaltName: _coccSaltCtrl.text.trim().isEmpty
          ? null
          : _coccSaltCtrl.text.trim(),
      coccidisostatGivenDate: _coccGivenDate,
      coccidisostatNextDate: _coccNextDate,
      weaningDate: _weaningDate,
      averageWeightKg: weight,
      milkReplacerStartDate: _milkReplacerStartDate,
      farmerId: 'F001',
      notes:
          _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    Navigator.pop(context);
    widget.onSave(record);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: RumenoTheme.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Row(
              children: [
                const Text('🐐', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Text(
                  isEdit ? 'Edit Kid Record' : 'Add New Kid',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Section: Basic Info ──────────
            _SectionHeader(emoji: '🏷️', title: 'Basic Info'),
            const SizedBox(height: 10),
            _FormField(
              controller: _kidIdCtrl,
              hint: 'K-001',
              label: '🐐  Kid ID',
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9\-]'))
              ],
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: _motherIdCtrl,
              hint: 'e.g. G-001',
              label: '🐐  Mother Animal ID (optional)',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: _fatherAiIdCtrl,
              hint: 'e.g. AI-001',
              label: '🧬  Father ID from AI (optional)',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            _DatePickerTile(
              emoji: '🎂',
              label: 'Date of Birth',
              date: _dateOfBirth,
              onTap: () => _pickDate(context, _dateOfBirth,
                  (d) => setState(() => _dateOfBirth = d),
                  lastDate: DateTime.now()),
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: _weightCtrl,
              hint: 'e.g. 5.5',
              label: '⚖️  Birth Weight (kg)',
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
            ),
            const SizedBox(height: 20),

            // ── Section: Coccidiostat ────────
            _SectionHeader(
                emoji: '💊',
                title: 'Coccidiostat (Anti-Parasite Medicine)'),
            const SizedBox(height: 6),
            const Text(
              'Select a common medicine or type your own',
              style:
                  TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
            ),
            const SizedBox(height: 10),
            // Preset chips — big and tappable
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _coccPresets.map((p) {
                final sel = _coccNameCtrl.text == p['name'];
                return GestureDetector(
                  onTap: () => _applyPreset(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel
                          ? RumenoTheme.primaryGreen
                              .withValues(alpha: 0.12)
                          : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: sel
                              ? RumenoTheme.primaryGreen
                              : RumenoTheme.textLight,
                          width: sel ? 2 : 1),
                    ),
                    child: Text(
                      '💊  ${p['name']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            sel ? FontWeight.bold : FontWeight.normal,
                        color: sel
                            ? RumenoTheme.primaryGreen
                            : RumenoTheme.textDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: _coccNameCtrl,
              hint: 'e.g. Amprolium',
              label: '💊  Coccidiostat Name',
              keyboardType: TextInputType.text,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _FormField(
              controller: _coccSaltCtrl,
              hint: 'e.g. Amprolium HCl',
              label: '🧪  Salt / Compound Name',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),
            _DatePickerTile(
              emoji: '📅',
              label: 'Coccidiostat Given On',
              date: _coccGivenDate,
              onTap: () => _pickDate(context, _coccGivenDate,
                  (d) => setState(() {
                        _coccGivenDate = d;
                        _coccNextDate ??= d.add(const Duration(days: 30));
                      })),
            ),
            const SizedBox(height: 12),
            _DatePickerTile(
              emoji: '📆',
              label: 'Next Dose Date',
              date: _coccNextDate,
              highlight: _coccNextDate != null &&
                  !DateTime.now().isBefore(_coccNextDate!),
              onTap: () => _pickDate(context, _coccNextDate,
                  (d) => setState(() => _coccNextDate = d)),
            ),
            const SizedBox(height: 20),

            // ── Section: Feeding ─────────────
            _SectionHeader(emoji: '🍼', title: 'Feeding & Weaning'),
            const SizedBox(height: 10),
            _DatePickerTile(
              emoji: '🍼',
              label: 'Milk Replacer Start Date',
              date: _milkReplacerStartDate,
              onTap: () => _pickDate(context, _milkReplacerStartDate,
                  (d) => setState(() => _milkReplacerStartDate = d)),
            ),
            const SizedBox(height: 12),
            _DatePickerTile(
              emoji: '🌱',
              label: 'Weaning Date (when kid stops milk)',
              date: _weaningDate,
              onTap: () => _pickDate(context, _weaningDate,
                  (d) => setState(() => _weaningDate = d)),
            ),
            const SizedBox(height: 20),

            // ── Notes ──────────────────────────
            _FormField(
              controller: _notesCtrl,
              hint: 'Any extra notes (optional)',
              label: '📝  Notes',
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),
            const SizedBox(height: 28),

            // ── Save Button — big ──────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded, size: 24),
                label: Text(
                  isEdit ? 'Update Record' : 'Save Kid Record',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable form widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionHeader({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: RumenoTheme.textDark),
        ),
      ],
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String emoji;
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool highlight;

  const _DatePickerTile({
    required this.emoji,
    required this.label,
    required this.date,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    final color = highlight
        ? RumenoTheme.errorRed
        : hasDate
            ? RumenoTheme.primaryGreen
            : RumenoTheme.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: highlight
              ? RumenoTheme.errorRed.withValues(alpha: 0.06)
              : RumenoTheme.backgroundCream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: hasDate
                  ? color.withValues(alpha: 0.6)
                  : RumenoTheme.textLight),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13, color: RumenoTheme.textGrey)),
                  const SizedBox(height: 2),
                  Text(
                    hasDate ? _fmtDate(date!) : 'Tap to select date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasDate
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: hasDate ? color : RumenoTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  const _FormField({
    required this.controller,
    required this.hint,
    required this.label,
    required this.keyboardType,
    this.inputFormatters,
    this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 15),
        hintText: hint,
        filled: true,
        fillColor: RumenoTheme.backgroundCream,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: RumenoTheme.primaryGreen, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

String _fmtDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}
