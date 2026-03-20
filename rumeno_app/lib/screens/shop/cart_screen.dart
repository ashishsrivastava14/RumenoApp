import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/marketplace_button.dart';
import 'shop_home_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ecommerce = context.watch<EcommerceProvider>();
    final cartItems = ecommerce.cartItems;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shopping_cart_rounded, size: 22),
            const SizedBox(width: 8),
            Text(l10n.cartTitle(ecommerce.cartItemCount)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/shop'),
        ),
        actions: const [VeterinarianButton(), FarmButton()],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.shopping_cart_outlined, size: 80, color: RumenoTheme.textLight),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.cartEmpty, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(l10n.cartEmptySubtitle, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 15)),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 220,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/shop'),
                      icon: const Icon(Icons.storefront_rounded, size: 22),
                      label: Text(l10n.cartStartShopping, style: const TextStyle(fontSize: 16)),
                    ),
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
      bottomNavigationBar: cartItems.isEmpty ? const ShopBottomBar(currentIndex: 2) : _CheckoutButton(),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();
    final l10n = AppLocalizations.of(context);
    final product = item.product;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image - larger
            GestureDetector(
              onTap: () => context.push('/shop/product/${product.id}'),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(_getCategoryIcon(product.category), size: 36, color: Colors.grey.shade400),
                  ),
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
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  Text(product.unit, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      if (product.mrp != null && product.mrp! > product.price) ...[
                        const SizedBox(width: 6),
                        Text(
                          '₹${product.mrp!.toStringAsFixed(0)}',
                          style: TextStyle(color: RumenoTheme.textLight, fontSize: 12, decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Remove button - larger touch target
                GestureDetector(
                  onTap: () {
                    ecommerce.removeFromCart(product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.cartItemRemovedSnackbar(product.name)),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.delete_rounded, color: RumenoTheme.errorRed, size: 20),
                  ),
                ),
                const SizedBox(height: 10),
                // Quantity controls - LARGE
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3), width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => ecommerce.updateCartQuantity(product.id, item.quantity - 1),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Icon(Icons.remove_rounded, size: 20, color: RumenoTheme.primaryGreen),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      GestureDetector(
                        onTap: () => ecommerce.updateCartQuantity(product.id, item.quantity + 1),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Icon(Icons.add_rounded, size: 20, color: RumenoTheme.primaryGreen),
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
    final l10n = AppLocalizations.of(context);
    final ecommerce = context.watch<EcommerceProvider>();
    final coupon = ecommerce.appliedCoupon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: coupon != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: RumenoTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RumenoTheme.successGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: RumenoTheme.successGreen, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coupon.code, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.successGreen, fontSize: 14)),
                        Text(
                          l10n.cartSavingsLabel(ecommerce.cartDiscount.toStringAsFixed(0)),
                          style: TextStyle(color: RumenoTheme.successGreen, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ecommerce.removeCoupon(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(l10n.cartRemoveCoupon, style: TextStyle(color: RumenoTheme.errorRed, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () => _showCouponDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer_rounded, color: RumenoTheme.primaryGreen, size: 24),
                    const SizedBox(width: 10),
                    Text(l10n.cartApplyCoupon, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const Spacer(),
                    Icon(Icons.chevron_right_rounded, color: RumenoTheme.primaryGreen, size: 26),
                  ],
                ),
              ),
            ),
    );
  }

  void _showCouponDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_offer_rounded, color: RumenoTheme.primaryGreen, size: 26),
                  const SizedBox(width: 8),
                  Text(l10n.cartCouponDialogTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: l10n.cartCouponHint,
                  prefixIcon: const Icon(Icons.local_offer_outlined, size: 24),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final error = context.read<EcommerceProvider>().applyCoupon(controller.text);
                    Navigator.pop(context);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(error)),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: RumenoTheme.errorRed,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(l10n.cartCouponApplied),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: RumenoTheme.successGreen,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: Text(l10n.cartCouponApplyButton, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.cartAvailableCouponsHeader, style: TextStyle(fontWeight: FontWeight.w600, color: RumenoTheme.textGrey, fontSize: 14)),
              const SizedBox(height: 10),
              ..._availableCoupons(context),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _availableCoupons(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      _couponTile(context, 'WELCOME20', l10n.cartCouponWelcome20Desc, l10n.cartCouponWelcome20Condition),
      _couponTile(context, 'FLAT100', l10n.cartCouponFlat100Desc, l10n.cartCouponFlat100Condition),
      _couponTile(context, 'FEED15', l10n.cartCouponFeed15Desc, l10n.cartCouponFeed15Condition),
    ];
  }

  Widget _couponTile(BuildContext context, String code, String desc, String condition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RumenoTheme.primaryGreen.withValues(alpha: 0.05),
        border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.local_offer_rounded, color: RumenoTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen, fontSize: 14)),
                Text(desc, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                Text(condition, style: TextStyle(color: RumenoTheme.textLight, fontSize: 11)),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                final error = context.read<EcommerceProvider>().applyCoupon(code);
                Navigator.pop(context);
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error), behavior: SnackBarBehavior.floating, backgroundColor: RumenoTheme.errorRed),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              child: const Text('APPLY'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ecommerce = context.watch<EcommerceProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          _priceRow(context, Icons.receipt_rounded, l10n.cartSubtotalLabel, '₹${ecommerce.cartSubtotal.toStringAsFixed(0)}'),
          if (ecommerce.cartDiscount > 0)
            _priceRow(context, Icons.local_offer_rounded, l10n.cartDiscountLabel, '-₹${ecommerce.cartDiscount.toStringAsFixed(0)}', color: RumenoTheme.successGreen),
          _priceRow(
            context,
            Icons.local_shipping_rounded,
            l10n.cartDeliveryLabel,
            ecommerce.deliveryCharge == 0 ? 'FREE' : '₹${ecommerce.deliveryCharge.toStringAsFixed(0)}',
            color: ecommerce.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
          ),
          const Divider(height: 20),
          Row(
            children: [
              Icon(Icons.payments_rounded, color: RumenoTheme.primaryGreen, size: 22),
              const SizedBox(width: 6),
              Text(l10n.cartTotalLabel, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text(
                '₹${ecommerce.cartTotal.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, IconData icon, String label, String value, {Color? color}) {
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
}

class _CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final ecommerce = context.watch<EcommerceProvider>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              if (!auth.isAuthenticated) {
                context.go('/login?redirect=${Uri.encodeComponent('/shop/cart')}');
              } else {
                context.go('/shop/checkout');
              }
            },
            icon: Icon(
              auth.isAuthenticated ? Icons.shopping_bag_rounded : Icons.login_rounded,
              size: 24,
            ),
            label: Text(
              auth.isAuthenticated
                  ? l10n.cartCheckoutButton(ecommerce.cartTotal.toStringAsFixed(0))
                  : l10n.cartLoginToCheckout,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.primaryGreen,
              foregroundColor: Colors.white,
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
      return Icons.grass_rounded;
    case ProductCategory.supplements:
      return Icons.science_rounded;
    case ProductCategory.veterinaryMedicines:
      return Icons.medication_rounded;
    case ProductCategory.farmEquipment:
      return Icons.construction_rounded;
    default:
      return Icons.shopping_bag_rounded;
  }
}
