import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_sales.dart';
import '../../../models/models.dart';

/// Full sale history screen — illiterate-friendly with colour coded cards,
/// emoji type indicators, and big filter chips.
class SaleHistoryScreen extends StatefulWidget {
  const SaleHistoryScreen({super.key});

  @override
  State<SaleHistoryScreen> createState() => _SaleHistoryScreenState();
}

class _SaleHistoryScreenState extends State<SaleHistoryScreen> {
  SaleType? _filter; // null = all
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<SaleRecord> get _filtered {
    var list = List<SaleRecord>.from(mockSales);
    if (_filter != null) list = list.where((s) => s.type == _filter).toList();
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((s) {
        return s.buyerName.toLowerCase().contains(q) ||
            (s.animalTag?.toLowerCase().contains(q) ?? false) ||
            (s.produceType?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    // Sort newest first
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get _totalFiltered =>
      _filtered.fold(0.0, (sum, s) => sum + s.amount);

  @override
  Widget build(BuildContext context) {
    final sales = _filtered;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('📋 बिक्री इतिहास / Sale History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: '🔍 खोजें / Search buyer or animal...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Filter chips ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    emoji: '📋',
                    label: 'सभी / All',
                    active: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    emoji: '🐄',
                    label: 'पशु / Animal',
                    active: _filter == SaleType.animal,
                    onTap: () => setState(
                      () => _filter = _filter == SaleType.animal ? null : SaleType.animal,
                    ),
                    color: RumenoTheme.successGreen,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    emoji: '🥛',
                    label: 'दूध / Milk',
                    active: _filter == SaleType.milk,
                    onTap: () => setState(
                      () => _filter = _filter == SaleType.milk ? null : SaleType.milk,
                    ),
                    color: RumenoTheme.infoBlue,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    emoji: '🌾',
                    label: 'उत्पाद / Produce',
                    active: _filter == SaleType.produce,
                    onTap: () => setState(
                      () => _filter = _filter == SaleType.produce ? null : SaleType.produce,
                    ),
                    color: const Color(0xFFF57C00),
                  ),
                ],
              ),
            ),
          ),

          // ── Total banner ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sales.length} बिक्री / Sales',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'कुल: ₹${_totalFiltered.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: RumenoTheme.primaryGreen,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── List ──
          Expanded(
            child: sales.isEmpty
                ? _EmptyState(filter: _filter)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: sales.length,
                    itemBuilder: (_, i) => _SaleDetailCard(
                      sale: sales[i],
                      onDelete: () => _confirmDelete(sales[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(SaleRecord sale) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('🗑️ हटाएँ? / Delete?'),
        content: Text(
          '${sale.typeEmoji} ${sale.animalTag ?? sale.produceType ?? sale.typeLabel}\n₹${sale.amount.toStringAsFixed(0)} — ${sale.buyerName}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('रद्द / Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: RumenoTheme.errorRed),
            onPressed: () {
              Navigator.pop(context);
              setState(() => mockSales.remove(sale));
            },
            child: const Text('हटाएँ / Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.emoji,
    required this.label,
    required this.active,
    required this.onTap,
    this.color = RumenoTheme.primaryGreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : Colors.grey[300]!),
        ),
        child: Text(
          '$emoji $label',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : RumenoTheme.textDark,
          ),
        ),
      ),
    );
  }
}

// ─── Sale Detail Card ─────────────────────────────────────────────────────────

class _SaleDetailCard extends StatelessWidget {
  final SaleRecord sale;
  final VoidCallback onDelete;

  const _SaleDetailCard({required this.sale, required this.onDelete});

  Color _borderColor(SaleType type) {
    switch (type) {
      case SaleType.animal:
        return RumenoTheme.successGreen;
      case SaleType.milk:
        return RumenoTheme.infoBlue;
      case SaleType.produce:
        return const Color(0xFFF57C00);
      case SaleType.other:
        return RumenoTheme.warningYellow;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final border = _borderColor(sale.type);
    final title = sale.animalTag ??
        (sale.produceType != null
            ? '${sale.produceType}${sale.quantity != null ? ' (${sale.quantity!.toStringAsFixed(0)} ${sale.unit ?? ''})' : ''}'
            : sale.typeLabel);

    return Dismissible(
      key: Key(sale.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: RumenoTheme.errorRed,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 28),
            Text('Delete', style: TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        bool? confirm = false;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('हटाएँ? / Delete?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('नहीं / No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: RumenoTheme.errorRed),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('हाँ / Yes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ).then((v) => confirm = v ?? false);
        return confirm;
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: border, width: 5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type emoji
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: border.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(sale.typeEmoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 14, color: RumenoTheme.textGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sale.buyerName,
                            style: const TextStyle(fontSize: 13, color: RumenoTheme.textGrey),
                          ),
                        ),
                      ],
                    ),
                    if (sale.buyerPhone != null) ...[
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () => Clipboard.setData(ClipboardData(text: sale.buyerPhone!)),
                        child: Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 14, color: RumenoTheme.textGrey),
                            const SizedBox(width: 4),
                            Text(
                              sale.buyerPhone!,
                              style: const TextStyle(
                                  fontSize: 12, color: RumenoTheme.infoBlue, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _paymentBadge(sale.paymentMode),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(sale.date),
                          style: const TextStyle(fontSize: 11, color: RumenoTheme.textLight),
                        ),
                      ],
                    ),
                    if (sale.notes != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '📝 ${sale.notes}',
                        style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${sale.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: RumenoTheme.successGreen,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: RumenoTheme.textLight, size: 20),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentBadge(PaymentMode mode) {
    final (label, color) = switch (mode) {
      PaymentMode.cash => ('💵 Cash', const Color(0xFF43A047)),
      PaymentMode.upi => ('📲 UPI', const Color(0xFF7B1FA2)),
      PaymentMode.bank => ('🏦 Bank', const Color(0xFF1E88E5)),
      PaymentMode.credit => ('💳 Credit', const Color(0xFFE64A19)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final SaleType? filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final emoji = filter == null
        ? '📭'
        : filter == SaleType.animal
            ? '🐄'
            : filter == SaleType.milk
                ? '🥛'
                : '🌾';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'कोई बिक्री नहीं मिली\nNo sales found',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: RumenoTheme.textGrey),
          ),
        ],
      ),
    );
  }
}
