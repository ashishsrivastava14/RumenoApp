import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_ecommerce.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import 'admin_categories_screen.dart';

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
    _tab = TabController(length: 8, vsync: this);
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
                Tab(icon: Text('🚚', style: TextStyle(fontSize: 16)), text: 'Delivery'),
                Tab(icon: Text('⭐', style: TextStyle(fontSize: 16)), text: 'Reviews'),
                Tab(icon: Text('🏪', style: TextStyle(fontSize: 16)), text: 'Vendors'),
                Tab(icon: Text('🎟️', style: TextStyle(fontSize: 16)), text: 'Coupons'),
                Tab(icon: Text('🚨', style: TextStyle(fontSize: 16)), text: 'Stock'),
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
            _DeliveryTab(),
            _ReviewsTab(),
            _VendorsTab(),
            _CouponsTab(),
            _StockAlertsTab(),
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

// Category display helpers
String _catEmoji(ProductCategory c) {
  switch (c) {
    case ProductCategory.animalFeed: return '🌾';
    case ProductCategory.tonic: return '💊';
    case ProductCategory.supplements: return '🧴';
    case ProductCategory.veterinaryMedicines: return '💉';
    case ProductCategory.farmEquipment: return '🔧';
  }
}

String _catLabel(ProductCategory c) {
  switch (c) {
    case ProductCategory.animalFeed: return 'Feed';
    case ProductCategory.tonic: return 'Tonic';
    case ProductCategory.supplements: return 'Supplements';
    case ProductCategory.veterinaryMedicines: return 'Medicines';
    case ProductCategory.farmEquipment: return 'Equipment';
  }
}

Color _catColor(ProductCategory c) {
  switch (c) {
    case ProductCategory.animalFeed: return Colors.green;
    case ProductCategory.tonic: return Colors.purple;
    case ProductCategory.supplements: return Colors.teal;
    case ProductCategory.veterinaryMedicines: return Colors.red;
    case ProductCategory.farmEquipment: return Colors.orange;
  }
}

enum _SortMode { nameAsc, priceAsc, priceDesc, stockAsc, newest }

class _ProductsTab extends StatefulWidget {
  const _ProductsTab();

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  String _search = '';
  ProductCategory? _catFilter;
  _SortMode _sort = _SortMode.nameAsc;
  bool _showOnlyLowStock = false;
  bool _showOnlyFeatured = false;

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    var products = eco.allProductsUnfiltered.where((p) {
      final matchSearch =
          p.name.toLowerCase().contains(_search.toLowerCase()) ||
              p.vendorName.toLowerCase().contains(_search.toLowerCase()) ||
              p.tags.any((t) => t.toLowerCase().contains(_search.toLowerCase()));
      final matchCat = _catFilter == null || p.category == _catFilter;
      final matchLow = !_showOnlyLowStock || p.stockQuantity < 5;
      final matchFeat = !_showOnlyFeatured || p.isFeatured;
      return matchSearch && matchCat && matchLow && matchFeat;
    }).toList();

    // Sort
    switch (_sort) {
      case _SortMode.nameAsc:
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SortMode.priceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SortMode.priceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortMode.stockAsc:
        products.sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));
        break;
      case _SortMode.newest:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    final lowStockCount = eco.allProductsUnfiltered.where((p) => p.stockQuantity < 5).length;
    final outOfStockCount = eco.allProductsUnfiltered.where((p) => p.stockQuantity == 0).length;

    return Column(
      children: [
        // ── Summary pills ──
        if (lowStockCount > 0 || outOfStockCount > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                if (outOfStockCount > 0) ...[
                  _QuickFilterPill(
                    emoji: '🚫',
                    label: '$outOfStockCount Out of Stock',
                    color: RumenoTheme.errorRed,
                    active: false,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                ],
                if (lowStockCount > 0)
                  _QuickFilterPill(
                    emoji: '⚠️',
                    label: '$lowStockCount Low Stock',
                    color: RumenoTheme.warningYellow,
                    active: _showOnlyLowStock,
                    onTap: () => setState(() => _showOnlyLowStock = !_showOnlyLowStock),
                  ),
              ],
            ),
          ),
        // ── Search + Add ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products / vendor...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => _openAddEditProductSheet(context, null),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ── Manage Categories button ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminCategoriesScreen()),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Text('📂', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Manage Categories',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1565C0))),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF1565C0)),
                ],
              ),
            ),
          ),
        ),
        // ── Category filter chips ──
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _CatFilterChip(
                emoji: '📦',
                label: 'All',
                selected: _catFilter == null,
                onTap: () => setState(() => _catFilter = null),
              ),
              ...ProductCategory.values.map((c) => _CatFilterChip(
                    emoji: _catEmoji(c),
                    label: _catLabel(c),
                    selected: _catFilter == c,
                    onTap: () => setState(() => _catFilter = _catFilter == c ? null : c),
                  )),
              // Featured filter
              _CatFilterChip(
                emoji: '⭐',
                label: 'Featured',
                selected: _showOnlyFeatured,
                onTap: () => setState(() => _showOnlyFeatured = !_showOnlyFeatured),
              ),
            ],
          ),
        ),
        // ── Sort + Count row ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text('${products.length} product${products.length == 1 ? '' : 's'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              const Spacer(),
              // Sort dropdown
              Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<_SortMode>(
                    value: _sort,
                    isDense: true,
                    icon: const Icon(Icons.sort_rounded, size: 14),
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    items: const [
                      DropdownMenuItem(value: _SortMode.nameAsc, child: Text('Name A-Z')),
                      DropdownMenuItem(value: _SortMode.priceAsc, child: Text('Price Low-High')),
                      DropdownMenuItem(value: _SortMode.priceDesc, child: Text('Price High-Low')),
                      DropdownMenuItem(value: _SortMode.stockAsc, child: Text('Stock Low-High')),
                      DropdownMenuItem(value: _SortMode.newest, child: Text('Newest First')),
                    ],
                    onChanged: (v) => setState(() => _sort = v ?? _SortMode.nameAsc),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ── Product list ──
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('📦', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text('No products found',
                          style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                      if (_search.isNotEmpty || _catFilter != null || _showOnlyLowStock || _showOnlyFeatured) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => setState(() {
                            _search = '';
                            _catFilter = null;
                            _showOnlyLowStock = false;
                            _showOnlyFeatured = false;
                          }),
                          icon: const Icon(Icons.clear_all_rounded, size: 16),
                          label: const Text('Clear Filters'),
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => _ProductCard(
                    product: products[i],
                    onTap: () => _showProductDetail(context, products[i]),
                    onEdit: () => _openAddEditProductSheet(context, products[i]),
                    onStockUpdate: () => _showStockDialog(context, products[i]),
                    onToggleFeatured: () {
                      context.read<EcommerceProvider>().toggleProductFeatured(products[i].id);
                    },
                    onToggleApproval: () {
                      final p = products[i];
                      context.read<EcommerceProvider>().updateProduct(p.id, isApproved: !p.isApproved);
                    },
                    onDelete: () => _confirmDelete(context, products[i]),
                  ),
                ),
        ),
      ],
    );
  }

  // ── Open Add/Edit product full-screen bottom sheet ──
  void _openAddEditProductSheet(BuildContext context, Product? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: RumenoTheme.backgroundCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddEditProductSheet(
        product: existing,
        onSave: (product) {
          if (existing != null) {
            // Update existing
            context.read<EcommerceProvider>().updateProduct(
              existing.id,
              name: product.name,
              description: product.description,
              price: product.price,
              mrp: product.mrp,
              category: product.category,
              stockQuantity: product.stockQuantity,
              unit: product.unit,
              weightKg: product.weightKg,
              hsnCode: product.hsnCode,
              isFeatured: product.isFeatured,
              isApproved: product.isApproved,
              tags: product.tags,
              targetAnimals: product.targetAnimals,
              nameTranslations: product.nameTranslations,
              descriptionTranslations: product.descriptionTranslations,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ ${product.name} updated!'), backgroundColor: RumenoTheme.successGreen),
            );
          } else {
            // Add new
            context.read<EcommerceProvider>().addProduct(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ ${product.name} added!'), backgroundColor: RumenoTheme.successGreen),
            );
          }
        },
      ),
    );
  }

  // ── Stock update dialog ──
  void _showStockDialog(BuildContext context, Product product) {
    final stockCtrl = TextEditingController(text: '${product.stockQuantity}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: RumenoTheme.infoBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.inventory_rounded, color: Color(0xFF1976D2), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('Update Stock', style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            Text('Current: ${product.stockQuantity} ${product.unit}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 16),
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'New Stock Quantity',
                prefixIcon: const Icon(Icons.numbers_rounded),
                suffixText: product.unit,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            // Quick adjust buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _QuickStockBtn('-50', () {
                  final v = (int.tryParse(stockCtrl.text) ?? 0) - 50;
                  stockCtrl.text = '${v < 0 ? 0 : v}';
                }),
                _QuickStockBtn('-10', () {
                  final v = (int.tryParse(stockCtrl.text) ?? 0) - 10;
                  stockCtrl.text = '${v < 0 ? 0 : v}';
                }),
                _QuickStockBtn('+10', () {
                  stockCtrl.text = '${(int.tryParse(stockCtrl.text) ?? 0) + 10}';
                }),
                _QuickStockBtn('+50', () {
                  stockCtrl.text = '${(int.tryParse(stockCtrl.text) ?? 0) + 50}';
                }),
                _QuickStockBtn('+100', () {
                  stockCtrl.text = '${(int.tryParse(stockCtrl.text) ?? 0) + 100}';
                }),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Update Stock'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2)),
            onPressed: () {
              final qty = int.tryParse(stockCtrl.text);
              if (qty == null || qty < 0) return;
              context.read<EcommerceProvider>().updateProduct(product.id, stockQuantity: qty);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Stock updated to $qty'), backgroundColor: RumenoTheme.successGreen),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _QuickStockBtn(String label, VoidCallback onTap) {
    final isNeg = label.startsWith('-');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: (isNeg ? RumenoTheme.errorRed : RumenoTheme.successGreen).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isNeg ? RumenoTheme.errorRed : RumenoTheme.successGreen).withValues(alpha: 0.3),
            ),
          ),
          child: Text(label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isNeg ? RumenoTheme.errorRed : RumenoTheme.successGreen,
              )),
        ),
      ),
    );
  }

  // ── Delete confirmation ──
  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Text('🗑️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            const Expanded(child: Text('Delete Product?', style: TextStyle(fontSize: 16))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(_catEmoji(product.category), style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('₹${product.price.toStringAsFixed(0)} · ${product.stockQuantity} in stock',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('This action cannot be undone. The product will be permanently removed.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever_rounded, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: RumenoTheme.errorRed),
            onPressed: () {
              context.read<EcommerceProvider>().deleteProduct(product.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} deleted'), backgroundColor: RumenoTheme.errorRed),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Product detail bottom sheet ──
  void _showProductDetail(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              // Product header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: _catColor(product.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(child: Text(_catEmoji(product.category), style: const TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _Badge(_catLabel(product.category), _catColor(product.category)),
                            if (product.isFeatured) ...[
                              const SizedBox(width: 4),
                              _Badge('⭐ Featured', Colors.amber),
                            ],
                            if (product.isRumenoOwned) ...[
                              const SizedBox(width: 4),
                              _Badge('Rumeno', RumenoTheme.primaryGreen),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Price section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selling Price', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('₹${product.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
                      ],
                    ),
                    const SizedBox(width: 24),
                    if (product.mrp != null && product.mrp! > product.price) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('MRP', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text('₹${product.mrp!.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: RumenoTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('${product.discountPercent.toStringAsFixed(0)}% OFF',
                            style: TextStyle(color: RumenoTheme.successGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Per', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(product.unit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stock & Status row
              Row(
                children: [
                  Expanded(child: _DetailInfoCard(
                    icon: Icons.inventory_2_rounded,
                    label: 'Stock',
                    value: '${product.stockQuantity}',
                    color: product.stockQuantity == 0
                        ? RumenoTheme.errorRed
                        : product.stockQuantity < 5
                            ? RumenoTheme.warningYellow
                            : RumenoTheme.successGreen,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _DetailInfoCard(
                    icon: Icons.star_rounded,
                    label: 'Rating',
                    value: '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                    color: RumenoTheme.warningYellow,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _DetailInfoCard(
                    icon: product.isApproved ? Icons.check_circle_rounded : Icons.pending_rounded,
                    label: 'Status',
                    value: product.isApproved ? 'Approved' : 'Pending',
                    color: product.isApproved ? RumenoTheme.successGreen : RumenoTheme.warningYellow,
                  )),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[800])),
              const SizedBox(height: 6),
              Text(product.description, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5)),
              const SizedBox(height: 16),
              // Details grid
              Text('Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[800])),
              const SizedBox(height: 8),
              _DetailRow('Vendor', product.vendorName),
              _DetailRow('Category', product.categoryName),
              _DetailRow('Unit', product.unit),
              if (product.weightKg != null) _DetailRow('Weight', '${product.weightKg} kg'),
              if (product.hsnCode != null) _DetailRow('HSN Code', product.hsnCode!),
              _DetailRow('Created', '${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}'),
              if (product.targetAnimals.isNotEmpty)
                _DetailRow('Target Animals', product.targetAnimals.map((a) => a.name).join(', ')),
              if (product.tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: product.tags.map((t) => Chip(
                    label: Text(t, style: const TextStyle(fontSize: 10)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: const Color(0xFF1976D2).withValues(alpha: 0.08),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 20),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openAddEditProductSheet(context, product);
                      },
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showStockDialog(context, product);
                      },
                      icon: const Icon(Icons.inventory_rounded, size: 18),
                      label: const Text('Update Stock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _DetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

// ── Quick filter pill ──
class _QuickFilterPill extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const _QuickFilterPill({
    required this.emoji,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: active ? 0.5 : 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Category filter chip ──
class _CatFilterChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CatFilterChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1976D2).withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? const Color(0xFF1976D2) : Colors.grey.shade300,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? const Color(0xFF1976D2) : Colors.grey[700],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Enhanced Product Card ──
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onStockUpdate;
  final VoidCallback onToggleFeatured;
  final VoidCallback onToggleApproval;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onStockUpdate,
    required this.onToggleFeatured,
    required this.onToggleApproval,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.stockQuantity > 0 && product.stockQuantity < 5;
    final isOutOfStock = product.stockQuantity == 0;
    final catColor = _catColor(product.category);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon with color
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: catColor.withValues(alpha: 0.2)),
                    ),
                    child: Center(child: Text(_catEmoji(product.category), style: const TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + badges
                        Row(
                          children: [
                            Expanded(
                              child: Text(product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Vendor + category
                        Row(
                          children: [
                            if (product.isRumenoOwned)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text('RUMENO', style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
                              ),
                            Expanded(
                              child: Text(product.vendorName,
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Price row
                        Row(
                          children: [
                            Text('₹${product.price.toStringAsFixed(0)}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen, fontSize: 16)),
                            if (product.mrp != null && product.mrp! > product.price) ...[
                              const SizedBox(width: 6),
                              Text('₹${product.mrp!.toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: Colors.grey[400])),
                              const SizedBox(width: 4),
                              Text('${product.discountPercent.toStringAsFixed(0)}% off',
                                  style: TextStyle(fontSize: 10, color: RumenoTheme.successGreen, fontWeight: FontWeight.bold)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // More menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onSelected: (val) {
                      switch (val) {
                        case 'edit': onEdit(); break;
                        case 'stock': onStockUpdate(); break;
                        case 'featured': onToggleFeatured(); break;
                        case 'approve': onToggleApproval(); break;
                        case 'delete': onDelete(); break;
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Row(children: [
                        Icon(Icons.edit_rounded, size: 18, color: Color(0xFF1976D2)),
                        SizedBox(width: 10), Text('Edit Product'),
                      ])),
                      const PopupMenuItem(value: 'stock', child: Row(children: [
                        Icon(Icons.inventory_rounded, size: 18, color: Colors.teal),
                        SizedBox(width: 10), Text('Update Stock'),
                      ])),
                      PopupMenuItem(value: 'featured', child: Row(children: [
                        Icon(product.isFeatured ? Icons.star_rounded : Icons.star_border_rounded,
                            size: 18, color: Colors.amber),
                        const SizedBox(width: 10),
                        Text(product.isFeatured ? 'Remove Featured' : 'Make Featured'),
                      ])),
                      PopupMenuItem(value: 'approve', child: Row(children: [
                        Icon(product.isApproved ? Icons.unpublished_rounded : Icons.check_circle_rounded,
                            size: 18, color: product.isApproved ? Colors.orange : RumenoTheme.successGreen),
                        const SizedBox(width: 10),
                        Text(product.isApproved ? 'Unpublish' : 'Approve'),
                      ])),
                      const PopupMenuItem(value: 'delete', child: Row(children: [
                        Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Bottom row: badges + stock
              Row(
                children: [
                  if (product.isFeatured)
                    _ProductBadge(icon: Icons.star_rounded, label: 'Featured', color: Colors.amber),
                  if (!product.isApproved)
                    _ProductBadge(icon: Icons.pending_rounded, label: 'Pending', color: RumenoTheme.warningYellow),
                  if (product.isApproved && !product.isFeatured)
                    _ProductBadge(icon: Icons.check_circle_rounded, label: 'Active', color: RumenoTheme.successGreen),
                  const Spacer(),
                  // Stock indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOutOfStock
                          ? RumenoTheme.errorRed.withValues(alpha: 0.1)
                          : isLowStock
                              ? RumenoTheme.warningYellow.withValues(alpha: 0.1)
                              : RumenoTheme.successGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isOutOfStock
                            ? RumenoTheme.errorRed.withValues(alpha: 0.3)
                            : isLowStock
                                ? RumenoTheme.warningYellow.withValues(alpha: 0.3)
                                : RumenoTheme.successGreen.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOutOfStock ? Icons.error_rounded
                              : isLowStock ? Icons.warning_amber_rounded
                              : Icons.check_circle_rounded,
                          size: 12,
                          color: isOutOfStock
                              ? RumenoTheme.errorRed
                              : isLowStock ? RumenoTheme.warningYellow : RumenoTheme.successGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOutOfStock ? 'Out of Stock'
                              : isLowStock ? '${product.stockQuantity} left!'
                              : '${product.stockQuantity} in stock',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isOutOfStock
                                ? RumenoTheme.errorRed
                                : isLowStock ? RumenoTheme.warningYellow : RumenoTheme.successGreen,
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
      ),
    );
  }
}

class _ProductBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ProductBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// ── Product detail info card ──
class _DetailInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailInfoCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

// ─── Add / Edit Product Bottom Sheet ──────────────────────────────────────────
class _AddEditProductSheet extends StatefulWidget {
  final Product? product;
  final ValueChanged<Product> onSave;

  const _AddEditProductSheet({this.product, required this.onSave});

  @override
  State<_AddEditProductSheet> createState() => _AddEditProductSheetState();
}

class _AddEditProductSheetState extends State<_AddEditProductSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _mrpCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _hsnCtrl;

  // Translation controllers  (hi = Hindi, ur = Urdu)
  late final TextEditingController _nameHiCtrl;
  late final TextEditingController _descHiCtrl;
  late final TextEditingController _nameUrCtrl;
  late final TextEditingController _descUrCtrl;

  late ProductCategory _category;
  late bool _isFeatured;
  late bool _isApproved;
  late Set<ProductAnimal> _targetAnimals;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toStringAsFixed(2) : '');
    _mrpCtrl = TextEditingController(text: p?.mrp?.toStringAsFixed(2) ?? '');
    _stockCtrl = TextEditingController(text: p != null ? '${p.stockQuantity}' : '0');
    _unitCtrl = TextEditingController(text: p?.unit ?? 'piece');
    _weightCtrl = TextEditingController(text: p?.weightKg?.toString() ?? '');
    _hsnCtrl = TextEditingController(text: p?.hsnCode ?? '');
    _nameHiCtrl = TextEditingController(text: p?.nameTranslations['hi'] ?? '');
    _descHiCtrl = TextEditingController(text: p?.descriptionTranslations['hi'] ?? '');
    _nameUrCtrl = TextEditingController(text: p?.nameTranslations['ur'] ?? '');
    _descUrCtrl = TextEditingController(text: p?.descriptionTranslations['ur'] ?? '');
    _category = p?.category ?? ProductCategory.supplements;
    _isFeatured = p?.isFeatured ?? false;
    _isApproved = p?.isApproved ?? true;
    _targetAnimals = Set<ProductAnimal>.from(p?.targetAnimals ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _mrpCtrl.dispose();
    _stockCtrl.dispose();
    _unitCtrl.dispose();
    _weightCtrl.dispose();
    _hsnCtrl.dispose();
    _nameHiCtrl.dispose();
    _descHiCtrl.dispose();
    _nameUrCtrl.dispose();
    _descUrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(isEditing ? '✏️' : '➕', style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isEditing ? 'Edit Product' : 'Add New Product',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Form body
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // ── Section: Basic Info ──
                      _SectionTitle(emoji: '📝', title: 'Basic Information'),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1976D2).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Text('🇬🇧', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            const Text('English (Primary)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Icon(Icons.info_outline_rounded, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text('Enter content in English first', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: _inputDecor('Product Name (English)', Icons.shopping_bag_rounded),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descCtrl,
                        decoration: _inputDecor('Description (English)', Icons.description_rounded),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 20),

                      // ── Section: Translations ──
                      _SectionTitle(emoji: '🌐', title: 'Translations'),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          children: [
                            const Text('🤖', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('AI Auto-Translation Coming Soon',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
                                  Text('You can manually enter translations below. In future, AI will auto-fill these from English.',
                                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Hindi translations
                      _LangTranslationSection(
                        flag: '🇮🇳',
                        language: 'Hindi',
                        localeCode: 'hi',
                        nameCtrl: _nameHiCtrl,
                        descCtrl: _descHiCtrl,
                        nameDecor: _inputDecor('Product Name (Hindi)', Icons.shopping_bag_outlined),
                        descDecor: _inputDecor('Description (Hindi)', Icons.description_outlined),
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: 14),

                      // Urdu translations
                      _LangTranslationSection(
                        flag: '🇵🇰',
                        language: 'Urdu',
                        localeCode: 'ur',
                        nameCtrl: _nameUrCtrl,
                        descCtrl: _descUrCtrl,
                        nameDecor: _inputDecor('Product Name (Urdu)', Icons.shopping_bag_outlined),
                        descDecor: _inputDecor('Description (Urdu)', Icons.description_outlined),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 20),

                      // ── Section: Category ──
                      _SectionTitle(emoji: '📂', title: 'Category'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: ProductCategory.values.map((c) {
                          final selected = _category == c;
                          return GestureDetector(
                            onTap: () => setState(() => _category = c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? _catColor(c).withValues(alpha: 0.15) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected ? _catColor(c) : Colors.grey.shade300,
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_catEmoji(c), style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  Text(_catLabel(c), style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                                    color: selected ? _catColor(c) : Colors.grey[700],
                                  )),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // ── Section: Pricing ──
                      _SectionTitle(emoji: '💰', title: 'Pricing'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceCtrl,
                              decoration: _inputDecor('Selling Price (₹)', Icons.currency_rupee_rounded),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Required';
                                if (double.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _mrpCtrl,
                              decoration: _inputDecor('MRP (₹)', Icons.sell_rounded),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Section: Stock & Unit ──
                      _SectionTitle(emoji: '📦', title: 'Stock & Unit'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _stockCtrl,
                              decoration: _inputDecor('Stock Quantity', Icons.inventory_rounded),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Required';
                                if (int.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _unitCtrl,
                              decoration: _inputDecor('Unit (kg/piece/L)', Icons.straighten_rounded),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _weightCtrl,
                              decoration: _inputDecor('Weight (kg)', Icons.scale_rounded),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _hsnCtrl,
                              decoration: _inputDecor('HSN Code', Icons.qr_code_rounded),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Section: Target Animals ──
                      _SectionTitle(emoji: '🐄', title: 'Target Animals'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: ProductAnimal.values.map((a) {
                          final selected = _targetAnimals.contains(a);
                          final emoji = _animalEmoji(a);
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (selected) {
                                _targetAnimals.remove(a);
                              } else {
                                _targetAnimals.add(a);
                              }
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? RumenoTheme.primaryGreen.withValues(alpha: 0.12) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected ? RumenoTheme.primaryGreen : Colors.grey.shade300,
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(emoji, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  Text(a.name[0].toUpperCase() + a.name.substring(1),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                                        color: selected ? RumenoTheme.primaryGreen : Colors.grey[700],
                                      )),
                                  if (selected) ...[
                                    const SizedBox(width: 4),
                                    Icon(Icons.check_circle_rounded, size: 14, color: RumenoTheme.primaryGreen),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // ── Section: Visibility toggles ──
                      _SectionTitle(emoji: '👁️', title: 'Visibility'),
                      const SizedBox(height: 10),
                      _ToggleTile(
                        icon: Icons.star_rounded,
                        color: Colors.amber,
                        title: 'Featured Product',
                        subtitle: 'Show on homepage carousel',
                        value: _isFeatured,
                        onChanged: (v) => setState(() => _isFeatured = v),
                      ),
                      const SizedBox(height: 8),
                      _ToggleTile(
                        icon: Icons.check_circle_rounded,
                        color: RumenoTheme.successGreen,
                        title: 'Approved / Published',
                        subtitle: 'Visible to customers in store',
                        value: _isApproved,
                        onChanged: (v) => setState(() => _isApproved = v),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                // Save button
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: Icon(isEditing ? Icons.save_rounded : Icons.add_rounded, size: 20),
                        label: Text(
                          isEditing ? 'Save Changes' : 'Add Product',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _save,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final nameTranslations = <String, String>{
      if (_nameHiCtrl.text.trim().isNotEmpty) 'hi': _nameHiCtrl.text.trim(),
      if (_nameUrCtrl.text.trim().isNotEmpty) 'ur': _nameUrCtrl.text.trim(),
    };
    final descriptionTranslations = <String, String>{
      if (_descHiCtrl.text.trim().isNotEmpty) 'hi': _descHiCtrl.text.trim(),
      if (_descUrCtrl.text.trim().isNotEmpty) 'ur': _descUrCtrl.text.trim(),
    };

    final product = Product(
      id: widget.product?.id ?? 'P${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? 'No description' : _descCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text) ?? 0,
      mrp: double.tryParse(_mrpCtrl.text),
      category: _category,
      vendorId: widget.product?.vendorId ?? 'RUMENO',
      vendorName: widget.product?.vendorName ?? 'Rumeno',
      isRumenoOwned: widget.product?.isRumenoOwned ?? true,
      stockQuantity: int.tryParse(_stockCtrl.text) ?? 0,
      imageUrl: widget.product?.imageUrl ?? '',
      unit: _unitCtrl.text.trim().isEmpty ? 'piece' : _unitCtrl.text.trim(),
      weightKg: double.tryParse(_weightCtrl.text),
      hsnCode: _hsnCtrl.text.trim().isEmpty ? null : _hsnCtrl.text.trim(),
      createdAt: widget.product?.createdAt ?? DateTime.now(),
      tags: const [],
      targetAnimals: _targetAnimals.toList(),
      isFeatured: _isFeatured,
      isApproved: _isApproved,
      nameTranslations: nameTranslations,
      descriptionTranslations: descriptionTranslations,
    );

    widget.onSave(product);
    Navigator.pop(context);
  }

  InputDecoration _inputDecor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
      ),
    );
  }

  String _animalEmoji(ProductAnimal a) {
    switch (a) {
      case ProductAnimal.cattle: return '🐄';
      case ProductAnimal.goat: return '🐐';
      case ProductAnimal.sheep: return '🐑';
      case ProductAnimal.poultry: return '🐔';
      case ProductAnimal.pig: return '🐷';
      case ProductAnimal.horse: return '🐴';
    }
  }
}

class _LangTranslationSection extends StatefulWidget {
  final String flag;
  final String language;
  final String localeCode;
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final InputDecoration nameDecor;
  final InputDecoration descDecor;
  final TextDirection textDirection;

  const _LangTranslationSection({
    required this.flag,
    required this.language,
    required this.localeCode,
    required this.nameCtrl,
    required this.descCtrl,
    required this.nameDecor,
    required this.descDecor,
    required this.textDirection,
  });

  @override
  State<_LangTranslationSection> createState() => _LangTranslationSectionState();
}

class _LangTranslationSectionState extends State<_LangTranslationSection> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand if there is already content saved
    _expanded = widget.nameCtrl.text.isNotEmpty || widget.descCtrl.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: _expanded
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(widget.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(widget.language,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(width: 8),
                  if (widget.nameCtrl.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Filled', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  const Spacer(),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: Colors.grey[500]),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Directionality(
                textDirection: widget.textDirection,
                child: Column(
                  children: [
                    TextField(
                      controller: widget.nameCtrl,
                      decoration: widget.nameDecor,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: widget.descCtrl,
                      decoration: widget.descDecor,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionTitle({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: value ? color.withValues(alpha: 0.3) : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? color : Colors.grey, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: value ? color : Colors.grey[700])),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeTrackColor: color.withValues(alpha: 0.4), activeThumbColor: color),
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

// ─── Delivery Tab ─────────────────────────────────────────────────────────────
class _DeliveryTab extends StatelessWidget {
  const _DeliveryTab();

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final orders = eco.orders;

    final shipped = orders.where((o) => o.status == OrderStatus.shipped).toList();
    final packed = orders.where((o) => o.status == OrderStatus.packed).toList();
    final confirmed = orders.where((o) => o.status == OrderStatus.confirmed).toList();
    final delivered = orders.where((o) => o.status == OrderStatus.delivered).toList();
    final pendingDispatch = [...confirmed, ...packed];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI row
          Row(
            children: [
              _DeliveryKpi(emoji: '📦', label: 'To Dispatch', value: '${pendingDispatch.length}', color: Colors.orange),
              const SizedBox(width: 10),
              _DeliveryKpi(emoji: '🚚', label: 'In Transit', value: '${shipped.length}', color: const Color(0xFF1565C0)),
              const SizedBox(width: 10),
              _DeliveryKpi(emoji: '✅', label: 'Delivered', value: '${delivered.length}', color: Colors.green),
            ],
          ),
          const SizedBox(height: 20),

          // In transit
          if (shipped.isNotEmpty) ...[
            const Text('🚚 In Transit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...shipped.map((o) => _DeliveryOrderCard(order: o, statusColor: const Color(0xFF1565C0))),
            const SizedBox(height: 16),
          ],

          // Pending dispatch
          if (pendingDispatch.isNotEmpty) ...[
            const Text('📦 Pending Dispatch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...pendingDispatch.map((o) => _DeliveryOrderCard(order: o, statusColor: Colors.orange)),
            const SizedBox(height: 16),
          ],

          // Recently delivered
          const Text('✅ Recently Delivered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (delivered.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('No deliveries yet', style: TextStyle(color: Colors.grey[500]))),
              ),
            )
          else
            ...delivered.take(10).map((o) => _DeliveryOrderCard(order: o, statusColor: Colors.green)),
        ],
      ),
    );
  }
}

class _DeliveryKpi extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _DeliveryKpi({required this.emoji, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

class _DeliveryOrderCard extends StatelessWidget {
  final Order order;
  final Color statusColor;
  const _DeliveryOrderCard({required this.order, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final eco = context.read<EcommerceProvider>();
    final itemCount = order.items.length;
    final statusEmoji = switch (order.status) {
      OrderStatus.confirmed => '🔵',
      OrderStatus.packed => '📦',
      OrderStatus.shipped => '🚚',
      OrderStatus.delivered => '✅',
      _ => '⏳',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(statusEmoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('$itemCount item${itemCount > 1 ? 's' : ''} • ₹${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(order.statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                ),
              ],
            ),
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 6),
              Text('📍 Tracking: ${order.trackingNumber}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
            const SizedBox(height: 6),
            Text('🏠 ${order.address.addressLine1}, ${order.address.city}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            if (order.status == OrderStatus.confirmed || order.status == OrderStatus.packed) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (order.status == OrderStatus.confirmed)
                    _ActionChip(
                      label: 'Mark Packed',
                      color: Colors.orange,
                      onTap: () => eco.updateOrderStatus(order.id, OrderStatus.packed),
                    ),
                  if (order.status == OrderStatus.packed) ...[
                    _ActionChip(
                      label: 'Mark Shipped',
                      color: const Color(0xFF1565C0),
                      onTap: () => eco.updateOrderStatus(order.id, OrderStatus.shipped),
                    ),
                  ],
                ],
              ),
            ],
            if (order.status == OrderStatus.shipped)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ActionChip(
                      label: 'Mark Delivered',
                      color: Colors.green,
                      onTap: () => eco.updateOrderStatus(order.id, OrderStatus.delivered),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─── Reviews Tab ──────────────────────────────────────────────────────────────
class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final products = eco.allProductsUnfiltered;
    final allReviews = <ProductReview>[];
    for (final p in products) {
      allReviews.addAll(eco.getReviewsForProduct(p.id));
    }
    allReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Stats
    final avgRating = allReviews.isNotEmpty
        ? allReviews.map((r) => r.rating).reduce((a, b) => a + b) / allReviews.length
        : 0.0;
    final fiveStar = allReviews.where((r) => r.rating == 5).length;
    final lowRating = allReviews.where((r) => r.rating <= 2).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF1976D2)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ReviewKpi(value: '${allReviews.length}', label: 'Total', emoji: '📝'),
                _ReviewKpi(value: avgRating.toStringAsFixed(1), label: 'Avg Rating', emoji: '⭐'),
                _ReviewKpi(value: '$fiveStar', label: '5-Star', emoji: '🌟'),
                _ReviewKpi(value: '$lowRating', label: 'Low (≤2)', emoji: '⚠️'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Rating distribution
          const Text('📊 Rating Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(5, (i) {
            final star = 5 - i;
            final count = allReviews.where((r) => r.rating.round() == star).length;
            final pct = allReviews.isNotEmpty ? count / allReviews.length : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(width: 24, child: Text('$star⭐', style: const TextStyle(fontSize: 11))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(star >= 4 ? Colors.green : star == 3 ? Colors.orange : Colors.red),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(width: 24, child: Text('$count', style: TextStyle(fontSize: 11, color: Colors.grey[600]))),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // Recent reviews
          const Text('💬 All Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (allReviews.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('No reviews yet', style: TextStyle(color: Colors.grey[500]))),
              ),
            )
          else
            ...allReviews.map((r) {
              final product = products.where((p) => p.id == r.productId).firstOrNull;
              return _ReviewCard(review: r, productName: product?.name ?? 'Unknown Product');
            }),
        ],
      ),
    );
  }
}

class _ReviewKpi extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _ReviewKpi({required this.value, required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;
  final String productName;
  const _ReviewCard({required this.review, required this.productName});

  @override
  Widget build(BuildContext context) {
    final stars = '⭐' * review.rating.round();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF1565C0).withValues(alpha: 0.1),
                  child: Text(review.userName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(productName, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Text(stars, style: const TextStyle(fontSize: 12)),
              ],
            ),
            if (review.comment != null) ...[
              const SizedBox(height: 8),
              Text(review.comment!, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
            const SizedBox(height: 4),
            Text('${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                style: TextStyle(fontSize: 10, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}

// ─── Stock Alerts Tab ─────────────────────────────────────────────────────────
class _StockAlertsTab extends StatelessWidget {
  const _StockAlertsTab();

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final products = eco.allProductsUnfiltered;

    final outOfStock = products.where((p) => p.stockQuantity == 0).toList();
    final lowStock = products.where((p) => p.stockQuantity > 0 && p.stockQuantity <= 10).toList();
    final healthyStock = products.where((p) => p.stockQuantity > 10).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs
          Row(
            children: [
              _StockKpi(emoji: '🔴', label: 'Out of Stock', value: '${outOfStock.length}', color: Colors.red),
              const SizedBox(width: 10),
              _StockKpi(emoji: '🟡', label: 'Low Stock', value: '${lowStock.length}', color: Colors.orange),
              const SizedBox(width: 10),
              _StockKpi(emoji: '🟢', label: 'Healthy', value: '${healthyStock.length}', color: Colors.green),
            ],
          ),
          const SizedBox(height: 20),

          // Out of stock
          if (outOfStock.isNotEmpty) ...[
            const Text('🔴 Out of Stock — Needs Immediate Restock', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            ...outOfStock.map((p) => _StockProductCard(product: p, severity: _StockSeverity.outOfStock)),
            const SizedBox(height: 16),
          ],

          // Low stock
          if (lowStock.isNotEmpty) ...[
            const Text('🟡 Low Stock — Reorder Soon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 8),
            ...lowStock.map((p) => _StockProductCard(product: p, severity: _StockSeverity.low)),
            const SizedBox(height: 16),
          ],

          // Healthy stock summary
          const Text('🟢 Healthy Stock', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 8),
          if (healthyStock.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('No products with healthy stock', style: TextStyle(color: Colors.grey[500]))),
              ),
            )
          else
            ...healthyStock.map((p) => _StockProductCard(product: p, severity: _StockSeverity.healthy)),
        ],
      ),
    );
  }
}

enum _StockSeverity { outOfStock, low, healthy }

class _StockKpi extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _StockKpi({required this.emoji, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

class _StockProductCard extends StatelessWidget {
  final Product product;
  final _StockSeverity severity;
  const _StockProductCard({required this.product, required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      _StockSeverity.outOfStock => Colors.red,
      _StockSeverity.low => Colors.orange,
      _StockSeverity.healthy => Colors.green,
    };
    final emoji = switch (severity) {
      _StockSeverity.outOfStock => '🔴',
      _StockSeverity.low => '🟡',
      _StockSeverity.healthy => '🟢',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: severity == _StockSeverity.outOfStock ? Colors.red[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text('${product.vendorName} • ${product.categoryName}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text('${product.stockQuantity} ${product.unit}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
                ),
                const SizedBox(height: 2),
                Text('₹${product.price.toStringAsFixed(0)}/${product.unit}', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
