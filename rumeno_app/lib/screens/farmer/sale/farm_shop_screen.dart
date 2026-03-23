import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_sales.dart';
import '../../../models/models.dart';
import '../../../widgets/common/marketplace_button.dart';

/// Main Farm Shop Management screen.
/// Designed for illiterate users: large emoji tiles, colour coding, minimal text.
class FarmShopScreen extends StatefulWidget {
  const FarmShopScreen({super.key});

  @override
  State<FarmShopScreen> createState() => _FarmShopScreenState();
}

class _FarmShopScreenState extends State<FarmShopScreen> {
  List<SaleRecord> _sales = [];

  @override
  void initState() {
    super.initState();
    _sales = List.from(mockSales);
  }

  void _refresh() => setState(() => _sales = List.from(mockSales));

  @override
  Widget build(BuildContext context) {
    final totalThisMonth = _sales
        .where((s) {
          final now = DateTime.now();
          return s.date.month == now.month && s.date.year == now.year;
        })
        .fold(0.0, (sum, s) => sum + s.amount);

    final animalSales = _sales.where((s) => s.type == SaleType.animal).length;
    final milkSales = _sales.where((s) => s.type == SaleType.milk).length;
    final recentSales = _sales.take(5).toList();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text('🛒 ${l10n.farmShopTitle}'),
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          _refresh();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Earnings banner ──
            _EarningsBanner(total: totalThisMonth),
            const SizedBox(height: 20),

            // ── Quick stat row ──
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    emoji: '🐄',
                    label: l10n.farmShopAnimalsSold,
                    value: '$animalSales',
                    color: const Color(0xFFE8F5E9),
                    valueColor: RumenoTheme.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    emoji: '🥛',
                    label: l10n.farmShopMilkSales,
                    value: '$milkSales',
                    color: const Color(0xFFE3F2FD),
                    valueColor: RumenoTheme.infoBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    emoji: '📋',
                    label: l10n.farmShopTotalRecords,
                    value: '${_sales.length}',
                    color: const Color(0xFFFFF8E1),
                    valueColor: RumenoTheme.warningYellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Section: What do you want to sell? ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.farmShopWhatToSell,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: RumenoTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BigActionTile(
                          emoji: '🐄',
                          label: l10n.farmShopSellAnimal,
                          color: const Color(0xFF43A047),
                          onTap: () async {
                            final result = await context.push('/farmer/sale/sell-animal');
                            if (result == true) _refresh();
                          },
                        ),
                        const SizedBox(width: 12),
                        _BigActionTile(
                          emoji: '🥛',
                          label: l10n.farmShopSellMilk,
                          color: const Color(0xFF1E88E5),
                          onTap: () async {
                            final result = await context.push(
                              '/farmer/sale/sell-produce',
                              extra: 'Milk',
                            );
                            if (result == true) _refresh();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _BigActionTile(
                          emoji: '🌾',
                          label: l10n.farmShopSellProduce,
                          color: const Color(0xFFF57C00),
                          onTap: () async {
                            final result = await context.push(
                              '/farmer/sale/sell-produce',
                              extra: 'Produce',
                            );
                            if (result == true) _refresh();
                          },
                        ),
                        const SizedBox(width: 12),
                        _BigActionTile(
                          emoji: '📋',
                          label: l10n.farmShopSaleHistory,
                          color: const Color(0xFF6D4C41),
                          onTap: () => context.push('/farmer/sale/history'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Recent Sales ──
            if (recentSales.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🕐 ${l10n.farmShopRecentSales}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: RumenoTheme.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/farmer/sale/history'),
                    child: Text(l10n.farmShopViewAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...recentSales.map((sale) => _SaleCard(sale: sale)),
            ],
          ],
        ),
      ),
      // ── FAB: Quick Sell ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickSellPicker(context),
        backgroundColor: RumenoTheme.primaryGreen,
        icon: const Text('💰', style: TextStyle(fontSize: 20)),
        label: Text(
          l10n.farmShopQuickSell,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _showQuickSellPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _QuickSellSheet(
        onAnimal: () async {
          Navigator.pop(context);
          final result = await context.push('/farmer/sale/sell-animal');
          if (result == true) _refresh();
        },
        onMilk: () async {
          Navigator.pop(context);
          final result = await context.push('/farmer/sale/sell-produce', extra: 'Milk');
          if (result == true) _refresh();
        },
        onProduce: () async {
          Navigator.pop(context);
          final result = await context.push('/farmer/sale/sell-produce', extra: 'Produce');
          if (result == true) _refresh();
        },
      ),
    );
  }
}

// ─── Earnings Banner ─────────────────────────────────────────────────────────

class _EarningsBanner extends StatelessWidget {
  final double total;
  const _EarningsBanner({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 ${AppLocalizations.of(context).farmShopEarningsBannerLabel}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${total.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mini Stat Card ───────────────────────────────────────────────────────────

class _MiniStatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  final Color valueColor;

  const _MiniStatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
          ),
        ],
      ),
    );
  }
}

// ─── Big Action Tile ──────────────────────────────────────────────────────────

class _BigActionTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BigActionTile({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sale Card ────────────────────────────────────────────────────────────────

class _SaleCard extends StatelessWidget {
  final SaleRecord sale;
  const _SaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final borderColor = _borderColor(sale.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: borderColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(sale.typeEmoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        title: Text(
          sale.animalTag ??
              (sale.produceType != null
                  ? '${sale.produceType} - ${sale.quantity?.toStringAsFixed(0) ?? ''} ${sale.unit ?? ''}'
                  : sale.typeLabel),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: RumenoTheme.textGrey),
                const SizedBox(width: 4),
                Text(sale.buyerName, style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              _formatDate(sale.date),
              style: const TextStyle(fontSize: 12, color: RumenoTheme.textLight),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${sale.amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: RumenoTheme.successGreen,
              ),
            ),
            const SizedBox(height: 2),
            _PaymentBadge(mode: sale.paymentMode),
          ],
        ),
      ),
    );
  }

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

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ─── Payment Badge ────────────────────────────────────────────────────────────

class _PaymentBadge extends StatelessWidget {
  final PaymentMode mode;
  const _PaymentBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
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

// ─── Quick Sell Bottom Sheet ──────────────────────────────────────────────────

class _QuickSellSheet extends StatelessWidget {
  final VoidCallback onAnimal;
  final VoidCallback onMilk;
  final VoidCallback onProduce;

  const _QuickSellSheet({
    required this.onAnimal,
    required this.onMilk,
    required this.onProduce,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '💰 ${AppLocalizations.of(context).farmShopWhatToSell}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _SheetTile(
                emoji: '🐄',
                label: AppLocalizations.of(context).farmShopAnimal,
                color: const Color(0xFF43A047),
                onTap: onAnimal,
              ),
              const SizedBox(width: 12),
              _SheetTile(
                emoji: '🥛',
                label: AppLocalizations.of(context).farmShopMilk,
                color: const Color(0xFF1E88E5),
                onTap: onMilk,
              ),
              const SizedBox(width: 12),
              _SheetTile(
                emoji: '🌾',
                label: AppLocalizations.of(context).farmShopProduce,
                color: const Color(0xFFF57C00),
                onTap: onProduce,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetTile({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
