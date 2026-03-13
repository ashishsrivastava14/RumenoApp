import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import 'shop_home_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final orders = ecommerce.orders;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/shop')),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: RumenoTheme.textLight),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Your orders will appear here', style: TextStyle(color: RumenoTheme.textGrey)),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: () => context.go('/shop'), child: const Text('Start Shopping')),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(order: order);
              },
            ),
      bottomNavigationBar: const ShopBottomBar(currentIndex: 3),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.go('/shop/order/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Spacer(),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(dateFormat.format(order.orderDate), style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
              const Divider(height: 16),
              ...order.items.take(2).map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.productName} x ${item.quantity}',
                            style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  )),
              if (order.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text('+${order.items.length - 2} more items', style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 12)),
                ),
              const Divider(height: 16),
              Row(
                children: [
                  Text('Total', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const Spacer(),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RumenoTheme.primaryGreen),
                  ),
                ],
              ),
              if (order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, size: 14, color: RumenoTheme.infoBlue),
                    const SizedBox(width: 4),
                    Text(
                      order.trackingNumber != null ? 'Tracking: ${order.trackingNumber}' : 'Tracking will be updated soon',
                      style: TextStyle(color: RumenoTheme.infoBlue, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = RumenoTheme.warningYellow;
        break;
      case OrderStatus.confirmed:
        color = RumenoTheme.infoBlue;
        break;
      case OrderStatus.packed:
        color = const Color(0xFF9C27B0);
        break;
      case OrderStatus.shipped:
        color = const Color(0xFF00BCD4);
        break;
      case OrderStatus.delivered:
        color = RumenoTheme.successGreen;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        color = RumenoTheme.errorRed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
