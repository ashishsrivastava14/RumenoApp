import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final order = ecommerce.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Detail')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Order Status Timeline ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Status', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _TimelineStep(
                      title: 'Order Placed',
                      subtitle: dateFormat.format(order.orderDate),
                      isCompleted: true,
                      isFirst: true,
                    ),
                    _TimelineStep(
                      title: 'Confirmed',
                      subtitle: order.status.index >= OrderStatus.confirmed.index ? 'Order confirmed' : 'Pending',
                      isCompleted: order.status.index >= OrderStatus.confirmed.index,
                    ),
                    _TimelineStep(
                      title: 'Packed',
                      subtitle: order.packedDate != null ? dateFormat.format(order.packedDate!) : 'Pending',
                      isCompleted: order.status.index >= OrderStatus.packed.index,
                    ),
                    _TimelineStep(
                      title: 'Shipped',
                      subtitle: order.shippedDate != null
                          ? '${dateFormat.format(order.shippedDate!)}\nTracking: ${order.trackingNumber ?? "N/A"}'
                          : 'Pending',
                      isCompleted: order.status.index >= OrderStatus.shipped.index,
                    ),
                    _TimelineStep(
                      title: 'Delivered',
                      subtitle: order.deliveredDate != null ? dateFormat.format(order.deliveredDate!) : 'Pending',
                      isCompleted: order.status == OrderStatus.delivered,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Items ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Items (${order.items.length})', style: Theme.of(context).textTheme.titleMedium),
                    const Divider(height: 16),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item.productImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    Text('Qty: ${item.quantity}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Delivery Address ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(order.address.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(order.address.fullAddress, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                    Text('Phone: ${order.address.phone}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Payment & Price ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Details', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _row('Payment Method', order.paymentMethod),
                    if (order.paymentId != null) _row('Payment ID', order.paymentId!),
                    const Divider(height: 16),
                    _row('Subtotal', '₹${order.subtotal.toStringAsFixed(0)}'),
                    if (order.discount > 0)
                      _row('Discount${order.couponCode != null ? ' (${order.couponCode})' : ''}',
                          '-₹${order.discount.toStringAsFixed(0)}',
                          color: RumenoTheme.successGreen),
                    _row(
                      'Delivery',
                      order.deliveryCharge == 0 ? 'FREE' : '₹${order.deliveryCharge.toStringAsFixed(0)}',
                      color: order.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Text('Total Paid', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                        ),
                      ],
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
                child: OutlinedButton.icon(
                  onPressed: () {
                    for (final item in order.items) {
                      final product = ecommerce.getProductById(item.productId);
                      if (product != null && product.inStock) {
                        ecommerce.addToCart(product, quantity: item.quantity);
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Items added to cart'), behavior: SnackBarBehavior.floating),
                    );
                    context.go('/shop/cart');
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('Reorder'),
                ),
              ),

            const SizedBox(height: 20),
          ],
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
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
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
            width: 30,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    ),
                  ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    border: Border.all(
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
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
                  const SizedBox(height: 2),
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
