import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../widgets/common/marketplace_button.dart';
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
        title: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, size: 24),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 26), onPressed: () => context.go('/shop')),
        actions: const [VeterinarianButton(), FarmButton()],
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.receipt_long_outlined, size: 70, color: RumenoTheme.textLight),
                  ),
                  const SizedBox(height: 20),
                  Text('No Orders Yet', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 50,
                    width: 220,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/shop'),
                      icon: const Icon(Icons.shopping_bag_rounded, size: 22),
                      label: const Text('Start Shopping', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
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
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/shop/order/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status icon & badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_getStatusIcon(order.status), color: _getStatusColor(order.status), size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(dateFormat.format(order.orderDate), style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 10),

              // Visual order progress bar
              if (order.status != OrderStatus.cancelled && order.status != OrderStatus.returned) ...[
                _OrderProgressBar(status: order.status),
                const SizedBox(height: 10),
              ],

              const Divider(height: 1),
              const SizedBox(height: 10),

              // Items with images
              ...order.items.take(2).map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Item thumbnail
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.productImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${item.productName} × ${item.quantity}',
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('₹${item.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )),
              if (order.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('+${order.items.length - 2} more items', style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Total & action
              Row(
                children: [
                  Icon(Icons.payments_rounded, size: 18, color: RumenoTheme.primaryGreen),
                  const SizedBox(width: 6),
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const Spacer(),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: RumenoTheme.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Invoice & View Detail row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/shop/order/${order.id}'),
                      icon: const Icon(Icons.visibility_rounded, size: 16),
                      label: const Text('View Details', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: RumenoTheme.textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/shop/order/${order.id}'),
                      icon: Icon(Icons.receipt_long_rounded, size: 16, color: RumenoTheme.primaryGreen),
                      label: Text('Invoice', style: TextStyle(fontSize: 12, color: RumenoTheme.primaryGreen)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                ],
              ),
              if (order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_shipping_rounded, size: 16, color: RumenoTheme.infoBlue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.trackingNumber != null ? 'Tracking: ${order.trackingNumber}' : 'Tracking will be updated soon',
                        style: TextStyle(color: RumenoTheme.infoBlue, fontSize: 11),
                      ),
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

// Visual progress bar for order status
class _OrderProgressBar extends StatelessWidget {
  final OrderStatus status;
  const _OrderProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'icon': Icons.check_circle_rounded, 'label': 'Placed'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Packed'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Shipped'},
      {'icon': Icons.home_rounded, 'label': 'Delivered'},
    ];

    int activeIndex;
    switch (status) {
      case OrderStatus.pending:
        activeIndex = 0;
        break;
      case OrderStatus.confirmed:
        activeIndex = 0;
        break;
      case OrderStatus.packed:
        activeIndex = 1;
        break;
      case OrderStatus.shipped:
        activeIndex = 2;
        break;
      case OrderStatus.delivered:
        activeIndex = 3;
        break;
      default:
        activeIndex = -1;
    }

    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i <= activeIndex;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (i > 0)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i <= activeIndex ? RumenoTheme.successGreen : Colors.grey.shade300,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isActive ? RumenoTheme.successGreen : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(steps[i]['icon'] as IconData, size: 14, color: Colors.white),
                  ),
                  if (i < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: i < activeIndex ? RumenoTheme.successGreen : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                steps[i]['label'] as String,
                style: TextStyle(fontSize: 9, color: isActive ? RumenoTheme.successGreen : RumenoTheme.textLight, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
        );
      }),
    );
  }
}

IconData _getStatusIcon(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Icons.hourglass_top_rounded;
    case OrderStatus.confirmed:
      return Icons.check_circle_outline_rounded;
    case OrderStatus.packed:
      return Icons.inventory_2_rounded;
    case OrderStatus.shipped:
      return Icons.local_shipping_rounded;
    case OrderStatus.delivered:
      return Icons.home_rounded;
    case OrderStatus.cancelled:
      return Icons.cancel_rounded;
    case OrderStatus.returned:
      return Icons.assignment_return_rounded;
  }
}

Color _getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return RumenoTheme.warningYellow;
    case OrderStatus.confirmed:
      return RumenoTheme.infoBlue;
    case OrderStatus.packed:
      return const Color(0xFF9C27B0);
    case OrderStatus.shipped:
      return const Color(0xFF00BCD4);
    case OrderStatus.delivered:
      return RumenoTheme.successGreen;
    case OrderStatus.cancelled:
    case OrderStatus.returned:
      return RumenoTheme.errorRed;
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
