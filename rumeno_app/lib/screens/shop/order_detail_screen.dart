import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../widgets/common/marketplace_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final order = ecommerce.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Detail'),
          actions: const [VeterinarianButton(), FarmButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 60, color: RumenoTheme.textLight),
              const SizedBox(height: 16),
              const Text('Order not found'),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.id}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: const [VeterinarianButton(), FarmButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Order Status Timeline ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timeline_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text('Order Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _TimelineStep(
                      icon: Icons.receipt_long_rounded,
                      title: 'Order Placed',
                      subtitle: dateFormat.format(order.orderDate),
                      isCompleted: true,
                      isFirst: true,
                    ),
                    _TimelineStep(
                      icon: Icons.check_circle_rounded,
                      title: 'Confirmed',
                      subtitle: order.status.index >= OrderStatus.confirmed.index ? 'Order confirmed' : 'Pending',
                      isCompleted: order.status.index >= OrderStatus.confirmed.index,
                    ),
                    _TimelineStep(
                      icon: Icons.inventory_2_rounded,
                      title: 'Packed',
                      subtitle: order.packedDate != null ? dateFormat.format(order.packedDate!) : 'Pending',
                      isCompleted: order.status.index >= OrderStatus.packed.index,
                    ),
                    _TimelineStep(
                      icon: Icons.local_shipping_rounded,
                      title: 'Shipped',
                      subtitle: order.shippedDate != null
                          ? '${dateFormat.format(order.shippedDate!)}\nTracking: ${order.trackingNumber ?? "N/A"}'
                          : 'Pending',
                      isCompleted: order.status.index >= OrderStatus.shipped.index,
                    ),
                    _TimelineStep(
                      icon: Icons.home_rounded,
                      title: 'Delivered',
                      subtitle: order.deliveredDate != null ? dateFormat.format(order.deliveredDate!) : 'Pending',
                      isCompleted: order.status == OrderStatus.delivered,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Items ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text('Items (${order.items.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 20),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              // Larger image
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item.productImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400, size: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    if (item.productDescription.isNotEmpty) ...[                                     
                                      const SizedBox(height: 2),
                                      Text(
                                        item.productDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text('× ${item.quantity}', style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('₹${item.price.toStringAsFixed(0)} each', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text('₹${item.totalPrice.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RumenoTheme.primaryGreen)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Delivery Address ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.home_rounded, color: RumenoTheme.primaryGreen, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.address.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(order.address.fullAddress, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.phone_rounded, size: 14, color: RumenoTheme.textGrey),
                                  const SizedBox(width: 4),
                                  Text(order.address.phone, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Payment & Price ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payments_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text('Payment', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _priceRow(Icons.money_rounded, 'Payment Method', order.paymentMethod),
                    if (order.paymentId != null) _priceRow(Icons.tag_rounded, 'Payment ID', order.paymentId!),
                    const Divider(height: 20),
                    _priceRow(Icons.shopping_cart_rounded, 'Subtotal', '₹${order.subtotal.toStringAsFixed(0)}'),
                    if (order.discount > 0)
                      _priceRow(
                        Icons.local_offer_rounded,
                        'Discount${order.couponCode != null ? ' (${order.couponCode})' : ''}',
                        '-₹${order.discount.toStringAsFixed(0)}',
                        valueColor: RumenoTheme.successGreen,
                      ),
                    _priceRow(
                      Icons.local_shipping_rounded,
                      'Delivery',
                      order.deliveryCharge == 0 ? 'FREE' : '₹${order.deliveryCharge.toStringAsFixed(0)}',
                      valueColor: order.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
                    ),
                    const Divider(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: RumenoTheme.primaryGreen.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet_rounded, color: RumenoTheme.primaryGreen, size: 22),
                          const SizedBox(width: 8),
                          Text('Total Paid', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const Spacer(),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reorder button
            if (order.status == OrderStatus.delivered)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    for (final item in order.items) {
                      final product = ecommerce.getProductById(item.productId);
                      if (product != null && product.inStock) {
                        ecommerce.addToCart(product, quantity: item.quantity);
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            const Text('Items added to cart'),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: RumenoTheme.successGreen,
                      ),
                    );
                    context.go('/shop/cart');
                  },
                  icon: const Icon(Icons.replay_rounded, size: 22),
                  label: const Text('Reorder', style: TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(color: RumenoTheme.primaryGreen, width: 1.5),
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: RumenoTheme.textGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: valueColor)),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 3,
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    ),
                  ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade200,
                    border: Border.all(
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isCompleted ? icon : Icons.circle_outlined,
                    color: isCompleted ? Colors.white : Colors.grey.shade400,
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isCompleted ? RumenoTheme.textDark : RumenoTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? RumenoTheme.textGrey : RumenoTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
