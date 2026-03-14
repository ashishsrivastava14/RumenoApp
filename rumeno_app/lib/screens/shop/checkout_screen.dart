import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../widgets/common/marketplace_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  int _selectedAddressIndex = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'label': 'UPI', 'icon': Icons.account_balance_rounded, 'subtitle': 'Google Pay, PhonePe, Paytm', 'color': const Color(0xFF4CAF50)},
    {'label': 'Card', 'icon': Icons.credit_card_rounded, 'subtitle': 'Credit / Debit Card', 'color': const Color(0xFF2196F3)},
    {'label': 'Net Banking', 'icon': Icons.language_rounded, 'subtitle': 'All major banks', 'color': const Color(0xFF9C27B0)},
    {'label': 'Cash on Delivery', 'icon': Icons.money_rounded, 'subtitle': 'Pay when delivered', 'color': const Color(0xFFFF9800)},
  ];

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final addresses = ecommerce.addresses;
    final cartItems = ecommerce.cartItems;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          actions: const [VeterinarianButton(), FarmButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: RumenoTheme.textLight),
              const SizedBox(height: 16),
              const Text('Your cart is empty', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/shop/cart');
            }
          },
        ),
        actions: const [VeterinarianButton(), FarmButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Step Indicators ───
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _StepIndicator(icon: Icons.location_on_rounded, label: 'Address', stepNum: 1, isActive: true),
                  Expanded(child: Container(height: 2, color: RumenoTheme.primaryGreen)),
                  _StepIndicator(icon: Icons.payment_rounded, label: 'Payment', stepNum: 2, isActive: true),
                  Expanded(child: Container(height: 2, color: RumenoTheme.primaryGreen)),
                  _StepIndicator(icon: Icons.check_circle_rounded, label: 'Confirm', stepNum: 3, isActive: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Delivery Address ───
            Row(
              children: [
                Icon(Icons.location_on_rounded, color: RumenoTheme.primaryGreen, size: 22),
                const SizedBox(width: 6),
                Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 10),
            if (addresses.isEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _showAddAddressDialog(context),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add_location_alt_rounded, color: RumenoTheme.primaryGreen, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Add delivery address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: RumenoTheme.primaryGreen, size: 28),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...addresses.asMap().entries.map((entry) {
                final idx = entry.key;
                final addr = entry.value;
                final isSelected = _selectedAddressIndex == idx;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAddressIndex = idx),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSelected ? RumenoTheme.primaryGreen : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? RumenoTheme.primaryGreen : RumenoTheme.textLight,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: RumenoTheme.primaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : const SizedBox(width: 12, height: 12),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person_rounded, size: 16, color: RumenoTheme.primaryGreen),
                                    const SizedBox(width: 4),
                                    Text(addr.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(addr.fullAddress, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.phone_rounded, size: 14, color: RumenoTheme.textGrey),
                                    const SizedBox(width: 4),
                                    Text(addr.phone, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: RumenoTheme.primaryGreen, size: 24),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            GestureDetector(
              onTap: () => _showAddAddressDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_rounded, color: RumenoTheme.primaryGreen, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      'Add New Address',
                      style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Order Summary ───
            Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: RumenoTheme.primaryGreen, size: 22),
                const SizedBox(width: 6),
                Text('Order Summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Icon(Icons.shopping_bag_rounded, color: Colors.grey.shade400, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${item.product.name} x ${item.quantity}',
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '₹${item.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Payment Method ───
            Row(
              children: [
                Icon(Icons.payment_rounded, color: RumenoTheme.primaryGreen, size: 22),
                const SizedBox(width: 6),
                Text('Payment Method', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 10),
            ...List.generate(_paymentMethods.length, (idx) {
              final method = _paymentMethods[idx];
              final isSelected = _selectedPaymentMethod == method['label'];
              final color = method['color'] as Color;
              return GestureDetector(
                onTap: () => setState(() => _selectedPaymentMethod = method['label'] as String),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isSelected ? color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(method['icon'] as IconData, color: color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(method['label'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              Text(method['subtitle'] as String, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? color : RumenoTheme.textLight, width: 2),
                          ),
                          child: isSelected
                              ? Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle))
                              : const SizedBox(width: 12, height: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // ─── Price Breakdown ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row(Icons.receipt_rounded, 'Subtotal', '₹${ecommerce.cartSubtotal.toStringAsFixed(0)}'),
                    if (ecommerce.cartDiscount > 0)
                      _row(Icons.local_offer_rounded, 'Discount', '-₹${ecommerce.cartDiscount.toStringAsFixed(0)}', color: RumenoTheme.successGreen),
                    _row(
                      Icons.local_shipping_rounded,
                      'Delivery',
                      ecommerce.deliveryCharge == 0 ? 'FREE' : '₹${ecommerce.deliveryCharge.toStringAsFixed(0)}',
                      color: ecommerce.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Icon(Icons.payments_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 6),
                        Text('Total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(
                          '₹${ecommerce.cartTotal.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -3))],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: addresses.isEmpty
                  ? null
                  : () {
                      final order = ecommerce.placeOrder(
                        address: addresses[_selectedAddressIndex],
                        paymentMethod: _selectedPaymentMethod,
                        paymentId: 'PAY_MOCK_${DateTime.now().millisecondsSinceEpoch}',
                      );
                      context.go('/shop/order-success/${order.id}');
                    },
              icon: const Icon(Icons.check_circle_rounded, size: 24),
              label: Text(
                addresses.isEmpty
                    ? 'Add Address First'
                    : 'Pay ₹${ecommerce.cartTotal.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: RumenoTheme.primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? RumenoTheme.textGrey),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final addr1C = TextEditingController();
    final addr2C = TextEditingController();
    final cityC = TextEditingController();
    final stateC = TextEditingController();
    final pinC = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: RumenoTheme.primaryGreen, size: 26),
                    const SizedBox(width: 8),
                    Text('Add Address', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: nameC,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneC,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addr1C,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addr2C,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Landmark (Optional)',
                    prefixIcon: Icon(Icons.place_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cityC,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: stateC,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.map_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pinC,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    prefixIcon: Icon(Icons.pin_drop_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (nameC.text.isEmpty || phoneC.text.isEmpty || addr1C.text.isEmpty || cityC.text.isEmpty || stateC.text.isEmpty || pinC.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Expanded(child: Text('Please fill all required fields')),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: RumenoTheme.errorRed,
                          ),
                        );
                        return;
                      }
                      context.read<EcommerceProvider>().addAddress(
                            ShippingAddress(
                              id: 'ADDR_${DateTime.now().millisecondsSinceEpoch}',
                              name: nameC.text,
                              phone: phoneC.text,
                              addressLine1: addr1C.text,
                              addressLine2: addr2C.text.isNotEmpty ? addr2C.text : null,
                              city: cityC.text,
                              state: stateC.text,
                              pincode: pinC.text,
                            ),
                          );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Save Address', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final int stepNum;
  final bool isActive;

  const _StepIndicator({
    required this.icon,
    required this.label,
    required this.stepNum,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? RumenoTheme.primaryGreen : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? RumenoTheme.primaryGreen : RumenoTheme.textGrey,
          ),
        ),
      ],
    );
  }
}
