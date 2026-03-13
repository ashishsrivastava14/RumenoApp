import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';
import '../../../providers/ecommerce_provider.dart';

class AdminMarketplaceScreen extends StatelessWidget {
  const AdminMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final products = ecommerce.allProductsUnfiltered;
    final orders = ecommerce.orders;

    // Stats
    final totalRevenue = orders.fold<double>(0, (s, o) => s + o.totalAmount);
    final totalOrders = orders.length;
    final pendingOrders = orders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.confirmed).length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Marketplace')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                _StatCard(label: 'Total Revenue', value: '₹${(totalRevenue / 1000).toStringAsFixed(1)}K', icon: Icons.currency_rupee, color: RumenoTheme.successGreen),
                const SizedBox(width: 10),
                _StatCard(label: 'Total Orders', value: '$totalOrders', icon: Icons.receipt, color: RumenoTheme.infoBlue),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(label: 'Products', value: '${products.length}', icon: Icons.inventory_2, color: RumenoTheme.accentOlive),
                const SizedBox(width: 10),
                _StatCard(label: 'Pending Orders', value: '$pendingOrders', icon: Icons.pending_actions, color: RumenoTheme.warningYellow),
              ],
            ),

            const SizedBox(height: 20),

            // Quick Actions
            Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ActionChip(icon: Icons.add_box, label: 'Add Product', onTap: () {}),
                _ActionChip(icon: Icons.local_offer, label: 'Manage Coupons', onTap: () {}),
                _ActionChip(icon: Icons.star, label: 'Featured Products', onTap: () {}),
                _ActionChip(icon: Icons.percent, label: 'Commission Settings', onTap: () {}),
                _ActionChip(icon: Icons.analytics, label: 'Sales Report', onTap: () {}),
                _ActionChip(icon: Icons.category, label: 'Categories', onTap: () {}),
              ],
            ),

            const SizedBox(height: 20),

            // Recent Orders
            Row(
              children: [
                Text('Recent Orders', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            ...orders.take(5).map((order) => _OrderTile(order: order)),

            const SizedBox(height: 20),

            // Products needing attention
            Row(
              children: [
                Text('Product Overview', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            ...products.take(5).map((product) => _ProductTile(product: product)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(label, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: RumenoTheme.primaryGreen),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final Order order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: Icon(
          _statusIcon(order.status),
          color: _statusColor(order.status),
        ),
        title: Text('#${order.id}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Text('${order.items.length} items · ₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _statusColor(order.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            order.statusLabel,
            style: TextStyle(color: _statusColor(order.status), fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return Icons.hourglass_empty;
      case OrderStatus.confirmed: return Icons.check;
      case OrderStatus.packed: return Icons.inventory;
      case OrderStatus.shipped: return Icons.local_shipping;
      case OrderStatus.delivered: return Icons.check_circle;
      case OrderStatus.cancelled: return Icons.cancel;
      case OrderStatus.returned: return Icons.replay;
    }
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return RumenoTheme.warningYellow;
      case OrderStatus.confirmed: return RumenoTheme.infoBlue;
      case OrderStatus.packed: return const Color(0xFF9C27B0);
      case OrderStatus.shipped: return const Color(0xFF00BCD4);
      case OrderStatus.delivered: return RumenoTheme.successGreen;
      case OrderStatus.cancelled:
      case OrderStatus.returned: return RumenoTheme.errorRed;
    }
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_categoryIcon(product.category), color: Colors.grey.shade400, size: 22),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${product.vendorName} · Stock: ${product.stockQuantity}', style: const TextStyle(fontSize: 11)),
        trailing: Text(
          '₹${product.price.toStringAsFixed(0)}',
          style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  IconData _categoryIcon(ProductCategory c) {
    switch (c) {
      case ProductCategory.animalFeed: return Icons.grass;
      case ProductCategory.supplements: return Icons.science;
      case ProductCategory.veterinaryMedicines: return Icons.medication;
      case ProductCategory.farmEquipment: return Icons.construction;
    }
  }
}
