import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_ecommerce.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';

class AdminShopScreen extends StatefulWidget {
  const AdminShopScreen({super.key});

  @override
  State<AdminShopScreen> createState() => _AdminShopScreenState();
}

class _AdminShopScreenState extends State<AdminShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 192,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('🛒', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Shop Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text('Ecommerce Dashboard',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(icon: Text('📊', style: TextStyle(fontSize: 16)), text: 'Overview'),
                Tab(icon: Text('📦', style: TextStyle(fontSize: 16)), text: 'Products'),
                Tab(icon: Text('📄', style: TextStyle(fontSize: 16)), text: 'Orders'),
                Tab(icon: Text('🏪', style: TextStyle(fontSize: 16)), text: 'Vendors'),
                Tab(icon: Text('🎟️', style: TextStyle(fontSize: 16)), text: 'Coupons'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _OverviewTab(),
            _ProductsTab(),
            _OrdersTab(),
            _VendorsTab(),
            _CouponsTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Overview Tab ─────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final products = eco.allProductsUnfiltered;
    final orders = eco.orders;
    final vendors = eco.vendors;
    final pendingVendors = eco.pendingVendors;

    final totalRevenue = orders
        .where((o) => o.status == OrderStatus.delivered)
        .fold<double>(0, (s, o) => s + o.totalAmount);
    final pendingOrders =
        orders.where((o) => o.status == OrderStatus.pending).length;
    final lowStock = products.where((p) => p.stockQuantity < 5).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Row
          Row(
            children: [
              _KpiCard(
                  label: 'Revenue',
                  value:
                      '₹${(totalRevenue / 1000).toStringAsFixed(1)}K',
                  icon: Icons.currency_rupee_rounded,
                  color: RumenoTheme.primaryGreen),
              const SizedBox(width: 10),
              _KpiCard(
                  label: 'Orders',
                  value: '${orders.length}',
                  icon: Icons.receipt_long_rounded,
                  color: RumenoTheme.infoBlue),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _KpiCard(
                  label: 'Products',
                  value: '${products.length}',
                  icon: Icons.inventory_2_rounded,
                  color: Colors.orange),
              const SizedBox(width: 10),
              _KpiCard(
                  label: 'Pending Vendors',
                  value: '${pendingVendors.length}',
                  icon: Icons.storefront_rounded,
                  color: pendingVendors.isNotEmpty
                      ? RumenoTheme.warningYellow
                      : Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          // Alert banners
          if (pendingOrders > 0)
            _AlertBanner(
              icon: Icons.pending_actions_rounded,
              color: RumenoTheme.warningYellow,
              text: '$pendingOrders pending order${pendingOrders > 1 ? 's' : ''} need attention',
            ),
          if (lowStock > 0)
            _AlertBanner(
              icon: Icons.production_quantity_limits_rounded,
              color: RumenoTheme.errorRed,
              text: '$lowStock product${lowStock > 1 ? 's' : ''} running low on stock',
            ),
          if (pendingVendors.isNotEmpty)
            _AlertBanner(
              icon: Icons.store_mall_directory_rounded,
              color: RumenoTheme.infoBlue,
              text: '${pendingVendors.length} vendor${pendingVendors.length > 1 ? 's' : ''} waiting for approval',
            ),
          const SizedBox(height: 20),
          // Category performance
          Text('Category Performance',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...ProductCategory.values.map((cat) {
            final count =
                products.where((p) => p.category == cat).length;
            if (count == 0) return const SizedBox.shrink();
            return _CategoryRow(
                category: cat,
                count: count,
                total: products.length);
          }),
          const SizedBox(height: 20),
          // Recent orders
          Text('Recent Orders',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...orders.take(5).map((o) => _MiniOrderRow(order: o)),
          if (orders.isEmpty)
            const _EmptyState(
                icon: Icons.receipt_long_rounded,
                message: 'No orders yet'),
          const SizedBox(height: 20),
          // Vendors summary
          Text('Vendor Summary',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatPill(
                  label: 'Approved',
                  value: '${eco.approvedVendors.length}',
                  color: RumenoTheme.successGreen),
              const SizedBox(width: 8),
              _StatPill(
                  label: 'Pending',
                  value: '${pendingVendors.length}',
                  color: RumenoTheme.warningYellow),
              const SizedBox(width: 8),
              _StatPill(
                  label: 'Total',
                  value: '${vendors.length}',
                  color: RumenoTheme.primaryGreen),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Products Tab ─────────────────────────────────────────────────────────────
class _ProductsTab extends StatefulWidget {
  const _ProductsTab();

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  String _search = '';
  ProductCategory? _catFilter;

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    var products = eco.allProductsUnfiltered.where((p) {
      final matchSearch =
          p.name.toLowerCase().contains(_search.toLowerCase()) ||
              p.vendorName.toLowerCase().contains(_search.toLowerCase());
      final matchCat = _catFilter == null || p.category == _catFilter;
      return matchSearch && matchCat;
    }).toList();

    return Column(
      children: [
        // Search + Add
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddProductDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add',
                    style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
        // Category filter chips
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _CatChip('All', _catFilter == null,
                  () => setState(() => _catFilter = null)),
              ...ProductCategory.values.map((c) => _CatChip(
                    c.name,
                    _catFilter == c,
                    () => setState(() =>
                        _catFilter = _catFilter == c ? null : c),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${products.length} products',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500)),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Export feature coming soon')));
                },
                icon: const Icon(Icons.download_rounded, size: 14),
                label: const Text('Export', style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
        Expanded(
          child: products.isEmpty
              ? const _EmptyState(
                  icon: Icons.inventory_2_rounded,
                  message: 'No products found')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) =>
                      _ProductCard(product: products[i]),
                ),
        ),
      ],
    );
  }

  Widget _CatChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: selected,
        selectedColor:
            const Color(0xFF1976D2).withValues(alpha: 0.15),
        onSelected: (_) => onTap(),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_box_rounded, color: Color(0xFF1976D2)),
            SizedBox(width: 8),
            Text('Add Product'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: Icon(Icons.inventory))),
            const SizedBox(height: 8),
            const Text('Full product form available in web portal',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2)),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              context.read<EcommerceProvider>().addProduct(Product(
                id: 'P${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                description: 'New product',
                price: 0,
                mrp: 0,
                category: ProductCategory.supplements,
                vendorId: 'admin',
                vendorName: 'Admin',
                imageUrl: '',
                stockQuantity: 0,
                unit: 'piece',
                createdAt: DateTime.now(),
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '${nameCtrl.text} added!'), backgroundColor: Colors.green));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.stockQuantity < 5;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2_rounded,
                  color: Color(0xFF1976D2), size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (product.isFeatured)
                        _Badge('Featured', Colors.amber),
                      if (!product.isApproved)
                        _Badge('Pending', RumenoTheme.warningYellow),
                    ],
                  ),
                  Text(product.vendorName,
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: RumenoTheme.primaryGreen,
                              fontSize: 14)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isLowStock
                                  ? RumenoTheme.errorRed
                                  : RumenoTheme.successGreen)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isLowStock
                              ? '⚠ ${product.stockQuantity} left'
                              : '${product.stockQuantity} in stock',
                          style: TextStyle(
                              fontSize: 9,
                              color: isLowStock
                                  ? RumenoTheme.errorRed
                                  : RumenoTheme.successGreen,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, size: 18),
              onSelected: (val) {
                final eco = context.read<EcommerceProvider>();
                switch (val) {
                  case 'edit':
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Editing ${product.name}')));
                    break;
                  case 'stock':
                    _showStockDialog(context, product);
                    break;
                  case 'featured':
                    eco.toggleProductFeatured(product.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(product.isFeatured
                            ? '${product.name} removed from featured'
                            : '${product.name} marked as featured')));
                    break;
                  case 'delete':
                    _confirmDelete(context, product);
                    break;
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Edit Product')
                  ]),
                ),
                PopupMenuItem(
                  value: 'stock',
                  child: Row(children: [
                    Icon(Icons.inventory_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Update Stock')
                  ]),
                ),
                PopupMenuItem(
                  value: 'featured',
                  child: Row(children: [
                    Icon(Icons.star_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Toggle Featured')
                  ]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_rounded, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red))
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStockDialog(BuildContext context, Product product) {
    final stockCtrl = TextEditingController(text: '${product.stockQuantity}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Update Stock: ${product.name}'),
        content: TextField(
          controller: stockCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Stock Quantity', prefixIcon: Icon(Icons.inventory)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(stockCtrl.text) ?? product.stockQuantity;
              context.read<EcommerceProvider>().updateProduct(product.id, stockQuantity: qty);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stock updated to $qty'), backgroundColor: Colors.green));
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: RumenoTheme.errorRed),
            const SizedBox(width: 8),
            const Text('Delete Product?'),
          ],
        ),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: RumenoTheme.errorRed),
            onPressed: () {
              context.read<EcommerceProvider>().deleteProduct(product.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} deleted')));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Orders Tab ───────────────────────────────────────────────────────────────
class _OrdersTab extends StatefulWidget {
  const _OrdersTab();

  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab> {
  OrderStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final orders = eco.orders;
    final filtered =
        _filter == null ? orders : orders.where((o) => o.status == _filter).toList();

    final statusCounts = <OrderStatus, int>{};
    for (final o in orders) {
      statusCounts[o.status] = (statusCounts[o.status] ?? 0) + 1;
    }

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            children: [
              _StatusChip('All (${orders.length})', _filter == null,
                  () => setState(() => _filter = null),
                  Colors.grey),
              ...OrderStatus.values.map((s) {
                final count = statusCounts[s] ?? 0;
                if (count == 0) return const SizedBox.shrink();
                return _StatusChip(
                  '${_orderLabel(s)} ($count)',
                  _filter == s,
                  () =>
                      setState(() => _filter = _filter == s ? null : s),
                  _orderStatusColor(s),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text('${filtered.length} order${filtered.length == 1 ? '' : 's'}',
              style:
                  TextStyle(fontSize: 12, color: Colors.grey[600])),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const _EmptyState(
                  icon: Icons.receipt_long_rounded,
                  message: 'No orders in this category')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _OrderCard(order: filtered[i]),
                ),
        ),
      ],
    );
  }

  Widget _StatusChip(String label, bool selected, VoidCallback onTap,
      Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 10)),
        selected: selected,
        selectedColor: color.withValues(alpha: 0.15),
        onSelected: (_) => onTap(),
      ),
    );
  }

  String _orderLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  Color _orderStatusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return RumenoTheme.warningYellow;
      case OrderStatus.confirmed:
        return RumenoTheme.infoBlue;
      case OrderStatus.packed:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.teal;
      case OrderStatus.delivered:
        return RumenoTheme.successGreen;
      case OrderStatus.cancelled:
        return RumenoTheme.errorRed;
      case OrderStatus.returned:
        return Colors.orange;
    }
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  Color _statusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return RumenoTheme.warningYellow;
      case OrderStatus.confirmed:
        return RumenoTheme.infoBlue;
      case OrderStatus.packed:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.teal;
      case OrderStatus.delivered:
        return RumenoTheme.successGreen;
      case OrderStatus.cancelled:
        return RumenoTheme.errorRed;
      case OrderStatus.returned:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#${order.id}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        '${order.items.length} item${order.items.length > 1 ? 's' : ''} · ₹${order.totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: sc.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sc.withValues(alpha: 0.3)),
                  ),
                  child: Text(order.statusLabel,
                      style: TextStyle(
                          color: sc,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              order.address.fullAddress,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (order.status == OrderStatus.pending ||
                order.status == OrderStatus.confirmed)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<EcommerceProvider>().updateOrderStatus(order.id, OrderStatus.cancelled);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Order #${order.id} cancelled')));
                    },
                    icon: const Icon(Icons.cancel_rounded, size: 14),
                    label: const Text('Cancel',
                        style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: RumenoTheme.errorRed,
                        visualDensity: VisualDensity.compact),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      final nextStatus = order.status == OrderStatus.pending ? OrderStatus.confirmed : OrderStatus.packed;
                      context.read<EcommerceProvider>().updateOrderStatus(order.id, nextStatus);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Order #${order.id} ${nextStatus.name}')));
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 14),
                    label: const Text('Confirm',
                        style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.successGreen,
                        visualDensity: VisualDensity.compact),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Vendors Tab ──────────────────────────────────────────────────────────────
class _VendorsTab extends StatelessWidget {
  const _VendorsTab();

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final pendingVendors = eco.pendingVendors;
    final allVendors = eco.vendors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending approval banner
          if (pendingVendors.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: RumenoTheme.warningYellow.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        RumenoTheme.warningYellow.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.pending_rounded,
                      color: RumenoTheme.warningYellow, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pendingVendors.length} Vendor${pendingVendors.length > 1 ? 's' : ''} Awaiting Approval',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: RumenoTheme.warningYellow),
                        ),
                        const Text(
                          'Review and approve vendor registrations',
                          style: TextStyle(
                              fontSize: 11, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Text('All Vendors (${allVendors.length})',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...allVendors.map((v) => _VendorCard(vendor: v)),
          if (allVendors.isEmpty)
            const _EmptyState(
                icon: Icons.store_rounded,
                message: 'No vendors registered yet'),
        ],
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final Vendor vendor;
  const _VendorCard({required this.vendor});

  Color _statusColor() {
    switch (vendor.status) {
      case VendorStatus.pending:
        return RumenoTheme.warningYellow;
      case VendorStatus.approved:
        return RumenoTheme.successGreen;
      case VendorStatus.rejected:
        return RumenoTheme.errorRed;
      case VendorStatus.suspended:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      const Color(0xFF1976D2).withValues(alpha: 0.1),
                  child: Text(
                    vendor.businessName[0],
                    style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.businessName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                          '${vendor.ownerName} · ${vendor.city}, ${vendor.state}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: sc.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sc.withValues(alpha: 0.3)),
                  ),
                  child: Text(vendor.statusLabel,
                      style: TextStyle(
                          color: sc,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (vendor.status == VendorStatus.approved) ...[
              const Divider(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat('${vendor.totalProducts}', 'Products',
                      Icons.inventory_2_rounded),
                  _Stat('${vendor.totalOrders}', 'Orders',
                      Icons.receipt_long_rounded),
                  _Stat('₹${(vendor.totalEarnings / 1000).toStringAsFixed(1)}K',
                      'Earned', Icons.account_balance_wallet_rounded),
                ],
              ),
            ],
            const Divider(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Viewing ${vendor.businessName} profile')));
                  },
                  icon: const Icon(Icons.visibility_rounded, size: 14),
                  label:
                      const Text('View', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact),
                ),
                const SizedBox(width: 8),
                if (vendor.status == VendorStatus.pending)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EcommerceProvider>().approveVendor(vendor.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${vendor.businessName} approved!')));
                    },
                    icon:
                        const Icon(Icons.verified_rounded, size: 14),
                    label: const Text('Approve',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.successGreen,
                        visualDensity: VisualDensity.compact),
                  )
                else if (vendor.status == VendorStatus.approved)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EcommerceProvider>().rejectVendor(vendor.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${vendor.businessName} suspended')));
                    },
                    icon: const Icon(Icons.pause_circle_rounded,
                        size: 14),
                    label: const Text('Suspend',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        visualDensity: VisualDensity.compact),
                  )
                else if (vendor.status == VendorStatus.suspended)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EcommerceProvider>().approveVendor(vendor.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${vendor.businessName} reinstated')));
                    },
                    icon: const Icon(Icons.play_circle_rounded,
                        size: 14),
                    label: const Text('Restore',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.infoBlue,
                        visualDensity: VisualDensity.compact),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _Stat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(height: 2),
        Text(value,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label,
            style: TextStyle(fontSize: 9, color: Colors.grey[500])),
      ],
    );
  }
}

// ─── Coupons Tab ──────────────────────────────────────────────────────────────
class _CouponsTab extends StatelessWidget {
  const _CouponsTab();

  @override
  Widget build(BuildContext context) {
    final coupons = mockCoupons;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${coupons.length} Coupons',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700])),
              ElevatedButton.icon(
                onPressed: () => _showAddCouponDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label:
                    const Text('New Coupon', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    visualDensity: VisualDensity.compact),
              ),
            ],
          ),
        ),
        Expanded(
          child: coupons.isEmpty
              ? const _EmptyState(
                  icon: Icons.local_offer_rounded,
                  message: 'No coupons created yet')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: coupons.length,
                  itemBuilder: (ctx, i) => _CouponCard(coupon: coupons[i]),
                ),
        ),
      ],
    );
  }

  void _showAddCouponDialog(BuildContext context) {
    final codeCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.local_offer_rounded, color: Color(0xFF1976D2)),
            SizedBox(width: 8),
            Text('Create Coupon'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                    labelText: 'Coupon Code (e.g. SAVE20)',
                    prefixIcon: Icon(Icons.discount))),
            const SizedBox(height: 10),
            TextField(
                controller: valueCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Discount % or ₹ value',
                    prefixIcon: Icon(Icons.percent))),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Coupon ${codeCtrl.text.toUpperCase()} created!')));
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final Coupon coupon;
  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (coupon.status) {
      case CouponStatus.active:
        statusColor = RumenoTheme.successGreen;
        break;
      case CouponStatus.expired:
        statusColor = Colors.grey;
        break;
      case CouponStatus.disabled:
        statusColor = RumenoTheme.errorRed;
        break;
    }

    final discountText = coupon.discountType == DiscountType.percentage
        ? '${coupon.discountValue.toStringAsFixed(0)}% OFF'
        : '₹${coupon.discountValue.toStringAsFixed(0)} OFF';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.local_offer_rounded,
                  color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(coupon.code,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'monospace')),
                      const SizedBox(width: 8),
                      _Badge(discountText, const Color(0xFF1976D2)),
                    ],
                  ),
                  Text(
                    'Used: ${coupon.usedCount}/${coupon.usageLimit} times',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  Text(
                    'Valid until: ${_formatDate(coupon.validUntil)}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(coupon.status.name,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 8,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, size: 16),
                  onSelected: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '${coupon.code}: $val action applied')));
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'enable',
                        child: Text('Enable', style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        value: 'disable',
                        child: Text('Disable', style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete',
                            style: TextStyle(
                                fontSize: 12, color: Colors.red))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
}

// ─── Shared Helpers ───────────────────────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text(label,
                    style:
                        TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _AlertBanner({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text, style: TextStyle(color: color, fontSize: 12))),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ProductCategory category;
  final int count;
  final int total;

  const _CategoryRow({
    required this.category,
    required this.count,
    required this.total,
  });

  static const _catColors = {
    ProductCategory.animalFeed: Colors.green,
    ProductCategory.tonic: Colors.purple,
    ProductCategory.supplements: Colors.teal,
    ProductCategory.veterinaryMedicines: Colors.red,
    ProductCategory.farmEquipment: Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    final color = _catColors[category] ?? Colors.grey;
    final pct = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12)),
              Text('$count products',
                  style:
                      TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: (color as Color).withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniOrderRow extends StatelessWidget {
  final Order order;
  const _MiniOrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_rounded, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text('#${order.id}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          Text('₹${order.totalAmount.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: RumenoTheme.primaryGreen)),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(order.statusLabel,
                style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2))),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text('$value $label',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }
}
