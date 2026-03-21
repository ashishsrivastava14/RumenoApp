import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_sales.dart';
import '../../../models/models.dart';

/// Illiterate-friendly sell-an-animal wizard.
/// 3 steps: pick animal → set price & buyer → payment method & confirm.
class SellAnimalScreen extends StatefulWidget {
  const SellAnimalScreen({super.key});

  @override
  State<SellAnimalScreen> createState() => _SellAnimalScreenState();
}

class _SellAnimalScreenState extends State<SellAnimalScreen> {
  int _step = 0; // 0 = pick, 1 = price+buyer, 2 = payment+confirm

  Animal? _selected;
  final _priceCtrl = TextEditingController();
  final _buyerCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  PaymentMode _payment = PaymentMode.cash;
  bool _saving = false;

  // Only show non-deceased, non-sold animals
  List<Animal> get _availableAnimals =>
      mockAnimals.where((a) => !a.isDead && !a.isSold).toList();

  @override
  void dispose() {
    _priceCtrl.dispose();
    _buyerCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('🐄 पशु बेचें / Sell Animal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.of(context).pop(false);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // ── Step indicator ──
          _StepIndicator(current: _step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _step == 0
                    ? _StepPickAnimal(
                        key: const ValueKey('step0'),
                        animals: _availableAnimals,
                        selected: _selected,
                        onSelect: (a) => setState(() => _selected = a),
                        onNext: _goNext,
                      )
                    : _step == 1
                        ? _StepPriceBuyer(
                            key: const ValueKey('step1'),
                            animal: _selected!,
                            priceCtrl: _priceCtrl,
                            buyerCtrl: _buyerCtrl,
                            phoneCtrl: _phoneCtrl,
                            notesCtrl: _notesCtrl,
                            onNext: _goNext,
                          )
                        : _StepPaymentConfirm(
                            key: const ValueKey('step2'),
                            animal: _selected!,
                            price: double.tryParse(_priceCtrl.text) ?? 0,
                            buyerName: _buyerCtrl.text,
                            buyerPhone: _phoneCtrl.text,
                            notes: _notesCtrl.text,
                            payment: _payment,
                            onPaymentChange: (p) => setState(() => _payment = p),
                            saving: _saving,
                            onConfirm: _confirm,
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goNext() {
    if (_step == 0 && _selected == null) {
      _showError('पहले पशु चुनें\nPlease select an animal first');
      return;
    }
    if (_step == 1) {
      final price = double.tryParse(_priceCtrl.text);
      if (price == null || price <= 0) {
        _showError('कीमत डालें\nPlease enter a valid price');
        return;
      }
      if (_buyerCtrl.text.trim().isEmpty) {
        _showError('ग्राहक का नाम डालें\nPlease enter buyer\'s name');
        return;
      }
    }
    setState(() => _step++);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: RumenoTheme.errorRed,
      ),
    );
  }

  void _confirm() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate save

    final sale = SaleRecord(
      id: 'SALE_${DateTime.now().millisecondsSinceEpoch}',
      type: SaleType.animal,
      date: DateTime.now(),
      amount: double.tryParse(_priceCtrl.text) ?? 0,
      paymentMode: _payment,
      buyerName: _buyerCtrl.text.trim(),
      buyerPhone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      animalId: _selected!.id,
      animalTag: _selected!.tagId,
      animalSpecies: _selected!.speciesName,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      farmerId: 'F001',
    );
    mockSales.insert(0, sale);

    setState(() => _saving = false);
    if (!mounted) return;

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
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
            const Text(
              'बिक्री सफल!\nSale Recorded!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_selected!.tagId} — ₹${_priceCtrl.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: RumenoTheme.textGrey),
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
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(true); // return true to parent
            },
            child: const Text(
              '🏠 वापस जाएँ / Go Back',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step Indicator ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int current;
  const _StepIndicator({required this.current});

  @override
  Widget build(BuildContext context) {
    const steps = ['🐄 पशु चुनें', '💰 कीमत', '✅ पक्का करें'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: List.generate(steps.length, (i) {
          final active = i == current;
          final done = i < current;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? RumenoTheme.successGreen
                              : active
                                  ? RumenoTheme.primaryGreen
                                  : Colors.grey[200],
                        ),
                        child: Center(
                          child: done
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: active ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: active ? RumenoTheme.primaryGreen : RumenoTheme.textGrey,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1)
                  Container(
                    width: 24,
                    height: 2,
                    color: i < current ? RumenoTheme.successGreen : Colors.grey[300],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Step 0: Pick Animal ──────────────────────────────────────────────────────

class _StepPickAnimal extends StatelessWidget {
  final List<Animal> animals;
  final Animal? selected;
  final ValueChanged<Animal> onSelect;
  final VoidCallback onNext;

  const _StepPickAnimal({
    super.key,
    required this.animals,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  String _speciesEmoji(Species s) {
    switch (s) {
      case Species.cow:
        return '🐄';
      case Species.buffalo:
        return '🐃';
      case Species.goat:
        return '🐐';
      case Species.sheep:
        return '🐑';
      case Species.pig:
        return '🐖';
      case Species.horse:
        return '🐎';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'कौन सा पशु बेचना है?\nWhich animal to sell?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...animals.map((a) {
          final isSelected = selected?.id == a.id;
          return GestureDetector(
            onTap: () => onSelect(a),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? RumenoTheme.primaryGreen.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? RumenoTheme.primaryGreen : Colors.grey[200]!,
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? RumenoTheme.primaryGreen.withValues(alpha: 0.15)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _speciesEmoji(a.species),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              a.tagId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                a.genderLabel,
                                style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${a.speciesName} • ${a.breed}',
                          style: const TextStyle(fontSize: 13, color: RumenoTheme.textGrey),
                        ),
                        Text(
                          '⚖️ ${a.weightKg.toStringAsFixed(0)} kg  •  🎂 ${a.ageString}',
                          style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded, color: RumenoTheme.primaryGreen, size: 28),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        _NextButton(label: 'आगे / Next ➜', onTap: onNext, enabled: selected != null),
      ],
    );
  }
}

extension on Animal {
  String get genderLabel => gender == Gender.male ? '♂ Male' : '♀ Female';
}

// ─── Step 1: Price & Buyer ────────────────────────────────────────────────────

class _StepPriceBuyer extends StatelessWidget {
  final Animal animal;
  final TextEditingController priceCtrl;
  final TextEditingController buyerCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController notesCtrl;
  final VoidCallback onNext;

  const _StepPriceBuyer({
    super.key,
    required this.animal,
    required this.priceCtrl,
    required this.buyerCtrl,
    required this.phoneCtrl,
    required this.notesCtrl,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animal summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Text('🐄', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.tagId,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('${animal.speciesName} • ${animal.breed}',
                      style: const TextStyle(color: RumenoTheme.textGrey)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Price
        const _FieldLabel(emoji: '💰', label: 'कीमत डालें / Enter Price (₹)'),
        const SizedBox(height: 8),
        TextField(
          controller: priceCtrl,
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
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),

        // Buyer name
        const _FieldLabel(emoji: '👤', label: 'ग्राहक का नाम / Buyer Name'),
        const SizedBox(height: 8),
        _BigTextField(controller: buyerCtrl, hint: 'जैसे: Ramesh Patel'),
        const SizedBox(height: 16),

        // Phone
        const _FieldLabel(emoji: '📱', label: 'फोन नंबर / Phone (optional)'),
        const SizedBox(height: 8),
        _BigTextField(
          controller: phoneCtrl,
          hint: '9876543210',
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),

        // Notes
        const _FieldLabel(emoji: '📝', label: 'नोट / Notes (optional)'),
        const SizedBox(height: 8),
        TextField(
          controller: notesCtrl,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'कोई खास बात लिखें...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 24),

        _NextButton(label: 'आगे / Next ➜', onTap: onNext, enabled: true),
      ],
    );
  }
}

// ─── Step 2: Payment & Confirm ────────────────────────────────────────────────

class _StepPaymentConfirm extends StatelessWidget {
  final Animal animal;
  final double price;
  final String buyerName;
  final String buyerPhone;
  final String notes;
  final PaymentMode payment;
  final ValueChanged<PaymentMode> onPaymentChange;
  final bool saving;
  final VoidCallback onConfirm;

  const _StepPaymentConfirm({
    super.key,
    required this.animal,
    required this.price,
    required this.buyerName,
    required this.buyerPhone,
    required this.notes,
    required this.payment,
    required this.onPaymentChange,
    required this.saving,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'भुगतान का तरीका\nPayment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Payment options
        Row(
          children: [
            _PaymentOption(
              emoji: '💵',
              label: 'नकद\nCash',
              mode: PaymentMode.cash,
              selected: payment,
              onTap: onPaymentChange,
            ),
            const SizedBox(width: 10),
            _PaymentOption(
              emoji: '📲',
              label: 'UPI\nPaytm/GPay',
              mode: PaymentMode.upi,
              selected: payment,
              onTap: onPaymentChange,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _PaymentOption(
              emoji: '🏦',
              label: 'बैंक\nBank',
              mode: PaymentMode.bank,
              selected: payment,
              onTap: onPaymentChange,
            ),
            const SizedBox(width: 10),
            _PaymentOption(
              emoji: '💳',
              label: 'उधार\nCredit',
              mode: PaymentMode.credit,
              selected: payment,
              onTap: onPaymentChange,
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Summary
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📋 बिक्री विवरण / Sale Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(height: 20),
              _SummaryRow(label: '🐄 पशु', value: '${animal.tagId} (${animal.speciesName})'),
              _SummaryRow(label: '💰 कीमत', value: '₹${price.toStringAsFixed(0)}'),
              _SummaryRow(label: '👤 ग्राहक', value: buyerName),
              if (buyerPhone.isNotEmpty) _SummaryRow(label: '📱 फोन', value: buyerPhone),
              _SummaryRow(
                label: '💳 भुगतान',
                value: _paymentLabel(payment),
              ),
              if (notes.isNotEmpty) _SummaryRow(label: '📝 नोट', value: notes),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Confirm button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: saving ? null : onConfirm,
            child: saving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    '✅ बिक्री दर्ज करें / Confirm Sale',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  String _paymentLabel(PaymentMode m) {
    switch (m) {
      case PaymentMode.cash:
        return '💵 नकद (Cash)';
      case PaymentMode.upi:
        return '📲 UPI';
      case PaymentMode.bank:
        return '🏦 बैंक (Bank)';
      case PaymentMode.credit:
        return '💳 उधार (Credit)';
    }
  }
}

// ─── Reusable sub-widgets ─────────────────────────────────────────────────────

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

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const _NextButton({required this.label, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? RumenoTheme.primaryGreen : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: enabled ? onTap : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: enabled ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String emoji;
  final String label;
  final PaymentMode mode;
  final PaymentMode selected;
  final ValueChanged<PaymentMode> onTap;

  const _PaymentOption({
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
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? RumenoTheme.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? RumenoTheme.primaryGreen : Colors.grey[300]!,
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
