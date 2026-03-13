import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  int _selectedAddressIndex = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'label': 'UPI', 'icon': Icons.account_balance, 'subtitle': 'Google Pay, PhonePe, Paytm'},
    {'label': 'Card', 'icon': Icons.credit_card, 'subtitle': 'Credit / Debit Card'},
    {'label': 'Net Banking', 'icon': Icons.language, 'subtitle': 'All major banks'},
    {'label': 'EMI', 'icon': Icons.calendar_month, 'subtitle': 'No-cost & low-cost EMI'},
  ];

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final addresses = ecommerce.addresses;
    final cartItems = ecommerce.cartItems;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Your cart is empty')),
      );
    }

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Delivery Address ───
            Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (addresses.isEmpty)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.add_location_alt),
                  title: const Text('Add delivery address'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAddAddressDialog(context),
                ),
              )
            else
              ...addresses.asMap().entries.map((entry) {
                final idx = entry.key;
                final addr = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedAddressIndex == idx ? RumenoTheme.primaryGreen : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: RadioListTile<int>(
                    value: idx,
                    groupValue: _selectedAddressIndex,
                    onChanged: (val) => setState(() => _selectedAddressIndex = val!),
                    activeColor: RumenoTheme.primaryGreen,
                    title: Text(addr.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(addr.fullAddress, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                        Text('Phone: ${addr.phone}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }),
            TextButton.icon(
              onPressed: () => _showAddAddressDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
            ),

            const SizedBox(height: 16),

            // ─── Order Summary ───
            Text('Order Summary', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
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
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
            Text('Payment Method', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...List.generate(_paymentMethods.length, (idx) {
              final method = _paymentMethods[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _selectedPaymentMethod == method['label']
                        ? RumenoTheme.primaryGreen
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: RadioListTile<String>(
                  value: method['label'] as String,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                  activeColor: RumenoTheme.primaryGreen,
                  title: Row(
                    children: [
                      Icon(method['icon'] as IconData, color: RumenoTheme.primaryGreen, size: 22),
                      const SizedBox(width: 10),
                      Text(method['label'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(method['subtitle'] as String, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // ─── Price Breakdown ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row('Subtotal', '₹${ecommerce.cartSubtotal.toStringAsFixed(0)}'),
                    if (ecommerce.cartDiscount > 0)
                      _row('Discount', '-₹${ecommerce.cartDiscount.toStringAsFixed(0)}', color: RumenoTheme.successGreen),
                    _row(
                      'Delivery',
                      ecommerce.deliveryCharge == 0 ? 'FREE' : '₹${ecommerce.deliveryCharge.toStringAsFixed(0)}',
                      color: ecommerce.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Text('Total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(
                          '₹${ecommerce.cartTotal.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
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
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              child: Text('Pay ₹${ecommerce.cartTotal.toStringAsFixed(0)}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: color)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Address', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 10),
                TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number')),
                const SizedBox(height: 10),
                TextField(controller: addr1C, decoration: const InputDecoration(labelText: 'Address Line 1')),
                const SizedBox(height: 10),
                TextField(controller: addr2C, decoration: const InputDecoration(labelText: 'Address Line 2 (Optional)')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: cityC, decoration: const InputDecoration(labelText: 'City'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: stateC, decoration: const InputDecoration(labelText: 'State'))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: pinC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Pincode')),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameC.text.isEmpty || phoneC.text.isEmpty || addr1C.text.isEmpty || cityC.text.isEmpty || stateC.text.isEmpty || pinC.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all required fields'), behavior: SnackBarBehavior.floating),
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
                    child: const Text('Save Address'),
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
