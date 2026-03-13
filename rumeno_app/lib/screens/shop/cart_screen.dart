import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../providers/auth_provider.dart';
import 'shop_home_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final cartItems = ecommerce.cartItems;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text('Cart (${ecommerce.cartItemCount} items)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/shop'),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: RumenoTheme.textLight),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Add products to get started', style: TextStyle(color: RumenoTheme.textGrey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/shop'),
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _CartItemCard(item: item);
                    },
                  ),
                ),
                // Coupon section
                _CouponSection(),
                // Price summary
                _PriceSummary(),
              ],
            ),
      bottomNavigationBar: cartItems.isEmpty ? ShopBottomBar(currentIndex: 2) : _CheckoutButton(),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final dynamic item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();
    final product = item.product;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(_getCategoryIcon(product.category), size: 32, color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(product.unit, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (product.mrp != null && product.mrp > product.price) ...[
                        const SizedBox(width: 4),
                        Text(
                          '₹${product.mrp.toStringAsFixed(0)}',
                          style: TextStyle(color: RumenoTheme.textLight, fontSize: 11, decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Remove button
                IconButton(
                  icon: Icon(Icons.delete_outline, color: RumenoTheme.errorRed, size: 20),
                  onPressed: () => ecommerce.removeFromCart(product.id),
                ),
                // Quantity controls
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => ecommerce.updateCartQuantity(product.id, item.quantity - 1),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.remove, size: 16, color: RumenoTheme.textGrey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      InkWell(
                        onTap: () => ecommerce.updateCartQuantity(product.id, item.quantity + 1),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.add, size: 16, color: RumenoTheme.primaryGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final coupon = ecommerce.appliedCoupon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: coupon != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: RumenoTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RumenoTheme.successGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: RumenoTheme.successGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coupon.code, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.successGreen, fontSize: 13)),
                        Text(
                          'You save ₹${ecommerce.cartDiscount.toStringAsFixed(0)}',
                          style: TextStyle(color: RumenoTheme.successGreen, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => ecommerce.removeCoupon(),
                    child: Text('Remove', style: TextStyle(color: RumenoTheme.errorRed, fontSize: 12)),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () => _showCouponDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer_outlined, color: RumenoTheme.primaryGreen),
                    const SizedBox(width: 8),
                    const Text('Apply Coupon', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: RumenoTheme.textGrey),
                  ],
                ),
              ),
            ),
    );
  }

  void _showCouponDialog(BuildContext context) {
    final controller = TextEditingController();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apply Coupon', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Enter coupon code',
                  prefixIcon: Icon(Icons.local_offer_outlined),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final error = context.read<EcommerceProvider>().applyCoupon(controller.text);
                    Navigator.pop(context);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error), behavior: SnackBarBehavior.floating),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coupon applied!'), behavior: SnackBarBehavior.floating),
                      );
                    }
                  },
                  child: const Text('Apply'),
                ),
              ),
              const SizedBox(height: 12),
              Text('Available Coupons:', style: TextStyle(fontWeight: FontWeight.w600, color: RumenoTheme.textGrey, fontSize: 13)),
              const SizedBox(height: 8),
              ..._availableCoupons(context),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _availableCoupons(BuildContext context) {
    return [
      _couponTile(context, 'WELCOME20', '20% off on first order (max ₹200)', 'Min order: ₹500'),
      _couponTile(context, 'FLAT100', '₹100 off', 'Min order: ₹999'),
      _couponTile(context, 'FEED15', '15% off on feed (max ₹500)', 'Min order: ₹1500'),
    ];
  }

  Widget _couponTile(BuildContext context, String code, String desc, String condition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen, fontSize: 13)),
                Text(desc, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
                Text(condition, style: TextStyle(color: RumenoTheme.textLight, fontSize: 10)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              final error = context.read<EcommerceProvider>().applyCoupon(code);
              Navigator.pop(context);
              if (error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error), behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: const Text('APPLY', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '₹${ecommerce.cartSubtotal.toStringAsFixed(0)}'),
          if (ecommerce.cartDiscount > 0)
            _priceRow('Discount', '-₹${ecommerce.cartDiscount.toStringAsFixed(0)}', color: RumenoTheme.successGreen),
          _priceRow(
            'Delivery',
            ecommerce.deliveryCharge == 0 ? 'FREE' : '₹${ecommerce.deliveryCharge.toStringAsFixed(0)}',
            color: ecommerce.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
          ),
          const Divider(height: 16),
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
    );
  }

  Widget _priceRow(String label, String value, {Color? color}) {
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
}

class _CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final ecommerce = context.watch<EcommerceProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (!auth.isAuthenticated) {
                // Redirect to login before checkout
                context.go('/login');
              } else {
                context.go('/shop/checkout');
              }
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: Text(
              auth.isAuthenticated
                  ? 'Proceed to Checkout (₹${ecommerce.cartTotal.toStringAsFixed(0)})'
                  : 'Login to Checkout',
            ),
          ),
        ),
      ),
    );
  }
}

IconData _getCategoryIcon(dynamic category) {
  switch (category) {
    case ProductCategory.animalFeed:
      return Icons.grass;
    case ProductCategory.supplements:
      return Icons.science;
    case ProductCategory.veterinaryMedicines:
      return Icons.medication;
    case ProductCategory.farmEquipment:
      return Icons.construction;
    default:
      return Icons.shopping_bag;
  }
}
