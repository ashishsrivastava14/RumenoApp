import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_sales.dart';
import '../../../models/models.dart';

/// Illiterate-friendly screen for recording milk / farm produce sales.
/// The caller passes `initialType`: "Milk" or "Produce" via route extra.
class SellProduceScreen extends StatefulWidget {
  final String initialType;
  const SellProduceScreen({super.key, required this.initialType});

  @override
  State<SellProduceScreen> createState() => _SellProduceScreenState();
}

class _SellProduceScreenState extends State<SellProduceScreen> {
  late String _produceType;
  final _quantityCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  PaymentMode _payment = PaymentMode.cash;
  bool _saving = false;

  // Items: emoji, internal key, unit
  static const _milkProductKeys = [
    ('🥛', 'Milk', 'litre'),
    ('🧴', 'Curd', 'kg'),
    ('🧨', 'Butter', 'kg'),
    ('🪹', 'Ghee', 'kg'),
    ('🥛', 'Paneer', 'kg'),
    ('🥤', 'Lassi', 'litre'),
  ];

  static const _produceProductKeys = [
    ('🌾', 'Fodder', 'kg'),
    ('🥚', 'Eggs', 'dozen'),
    ('💩', 'Manure', 'kg'),
    ('🐑', 'Wool', 'kg'),
    ('🌿', 'Vegetables', 'kg'),
    ('🍃', 'Herbs', 'kg'),
  ];

  @override
  void initState() {
    super.initState();
    _produceType = _getDefaultItem();
  }

  String _getDefaultItem() {
    return widget.initialType == 'Milk' ? 'Milk' : 'Fodder';
  }

  List<(String, String, String)> get _itemKeys =>
      widget.initialType == 'Milk' ? _milkProductKeys : _produceProductKeys;

  String _unitOf(String key) => _itemKeys.firstWhere((i) => i.$2 == _produceType, orElse: () => ('', '', 'unit')).$3;

  String _displayNameOf(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Milk': return l10n.produceItemMilk;
      case 'Curd': return l10n.produceItemCurd;
      case 'Butter': return l10n.produceItemButter;
      case 'Ghee': return l10n.produceItemGhee;
      case 'Paneer': return l10n.produceItemPaneer;
      case 'Lassi': return l10n.produceItemLassi;
      case 'Fodder': return l10n.produceItemFodder;
      case 'Eggs': return l10n.produceItemEggs;
      case 'Manure': return l10n.produceItemManure;
      case 'Wool': return l10n.produceItemWool;
      case 'Vegetables': return l10n.produceItemVegetables;
      case 'Herbs': return l10n.produceItemHerbs;
      default: return key;
    }
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _priceCtrl.dispose();
    _buyerCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMilk = widget.initialType == 'Milk';
    final l10n = AppLocalizations.of(context);
    final gridItems = _itemKeys.map((k) => (k.$1, k.$2, _displayNameOf(k.$2, l10n))).toList();
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(isMilk ? '🥛 ${l10n.sellMilkTitle}' : '🌾 ${l10n.sellProduceTitle}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── What to sell ──
            Text(
              l10n.sellProduceWhatToSell,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _ProductGrid(
              items: gridItems,
              selected: _produceType,
              onSelect: (key) => setState(() => _produceType = key),
            ),
            const SizedBox(height: 24),

            // ── Quantity ──
            _FieldLabel(emoji: '⚖️', label: l10n.sellProduceHowMuch(_unitOf(_produceType))),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                suffixText: _unitOf(_produceType),
                hintText: '0',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),

            // ── Total price ──
            _FieldLabel(emoji: '💰', label: l10n.sellProduceTotalPrice),
            const SizedBox(height: 8),
            TextField(
              controller: _priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                hintText: '00000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            // ── Buyer ──
            _FieldLabel(emoji: '👤', label: l10n.saleBuyerNameLabel),
            const SizedBox(height: 8),
            _BigTextField(controller: _buyerCtrl, hint: 'e.g., Meena Dairy'),
            const SizedBox(height: 14),

            // ── Phone ──
            _FieldLabel(emoji: '📱', label: l10n.salePhoneLabel),
            const SizedBox(height: 8),
            _BigTextField(
              controller: _phoneCtrl,
              hint: '9876543210',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),

            // ── Payment ──
            Text(
              '💳 ${l10n.salePaymentMethodTitle}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _PaymentChip(
                  emoji: '💵',
                  label: l10n.salePaymentCash,
                  mode: PaymentMode.cash,
                  selected: _payment,
                  onTap: (p) => setState(() => _payment = p),
                ),
                const SizedBox(width: 8),
                _PaymentChip(
                  emoji: '📲',
                  label: 'UPI',
                  mode: PaymentMode.upi,
                  selected: _payment,
                  onTap: (p) => setState(() => _payment = p),
                ),
                const SizedBox(width: 8),
                _PaymentChip(
                  emoji: '🏦',
                  label: l10n.salePaymentBank,
                  mode: PaymentMode.bank,
                  selected: _payment,
                  onTap: (p) => setState(() => _payment = p),
                ),
                const SizedBox(width: 8),
                _PaymentChip(
                  emoji: '💳',
                  label: l10n.salePaymentCredit,
                  mode: PaymentMode.credit,
                  selected: _payment,
                  onTap: (p) => setState(() => _payment = p),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Notes ──
            _FieldLabel(emoji: '📝', label: l10n.saleNotesLabel),
            const SizedBox(height: 8),
            TextField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: l10n.sellProduceNotesHint,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 30),

            // ── Save ──
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        '✅ ${isMilk ? l10n.sellProduceRecordMilkSale : l10n.sellProduceRecordSale}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    final price = double.tryParse(_priceCtrl.text);
    if (price == null || price <= 0) {
      _showError(AppLocalizations.of(context).saleErrorInvalidPrice);
      return;
    }
    if (_buyerCtrl.text.trim().isEmpty) {
      _showError(AppLocalizations.of(context).saleErrorBuyerName);
      return;
    }

    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final qty = double.tryParse(_quantityCtrl.text);
    final saleType = widget.initialType == 'Milk' ? SaleType.milk : SaleType.produce;

    final sale = SaleRecord(
      id: 'SALE_${DateTime.now().millisecondsSinceEpoch}',
      type: saleType,
      date: DateTime.now(),
      amount: price,
      paymentMode: _payment,
      buyerName: _buyerCtrl.text.trim(),
      buyerPhone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      produceType: _produceType,
      quantity: qty,
      unit: _unitOf(_produceType),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      farmerId: 'F001',
    );
    mockSales.insert(0, sale);

    setState(() => _saving = false);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✅', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              l10n.sellProduceSuccessTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_produceType${qty != null ? ' — ${qty.toStringAsFixed(0)} ${_unitOf(_produceType)}' : ''}\n₹${price.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: RumenoTheme.textGrey),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.primaryGreen,
              minimumSize: const Size(200, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            child: Text(
              '🏠 ${l10n.saleGoBack}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: RumenoTheme.errorRed),
    );
  }
}

// ─── Product Grid ─────────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<(String, String, String)> items;
  final String selected;
  final ValueChanged<String> onSelect;

  const _ProductGrid({required this.items, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final (emoji, key, displayName) = items[i];
        final isSelected = key == selected;
        return GestureDetector(
          onTap: () => onSelect(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? RumenoTheme.primaryGreen : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? RumenoTheme.primaryGreen : Colors.grey[200]!,
                width: isSelected ? 2.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : RumenoTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Reusable helpers ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String emoji;
  final String label;
  const _FieldLabel({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$emoji  $label',
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}

class _BigTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _BigTextField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final String emoji;
  final String label;
  final PaymentMode mode;
  final PaymentMode selected;
  final ValueChanged<PaymentMode> onTap;

  const _PaymentChip({
    required this.emoji,
    required this.label,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 68,
          decoration: BoxDecoration(
            color: isSelected ? RumenoTheme.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? RumenoTheme.primaryGreen : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : RumenoTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
