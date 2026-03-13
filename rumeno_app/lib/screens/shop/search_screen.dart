import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import 'shop_home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  ProductCategory? _filterCategory;

  @override
  void initState() {
    super.initState();
    final ecommerce = context.read<EcommerceProvider>();
    _searchController.text = ecommerce.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();

    // Apply local filter
    var products = ecommerce.products;
    if (_filterCategory != null) {
      products = products.where((p) => p.category == _filterCategory).toList();
    }

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      ecommerce.setSearchQuery('');
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            ecommerce.setSearchQuery(val);
            setState(() {});
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ecommerce.setSearchQuery('');
            context.go('/shop');
          },
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filterCategory == null,
                  onTap: () => setState(() => _filterCategory = null),
                ),
                _FilterChip(
                  label: 'Feed',
                  isSelected: _filterCategory == ProductCategory.animalFeed,
                  onTap: () => setState(() => _filterCategory = ProductCategory.animalFeed),
                ),
                _FilterChip(
                  label: 'Supplements',
                  isSelected: _filterCategory == ProductCategory.supplements,
                  onTap: () => setState(() => _filterCategory = ProductCategory.supplements),
                ),
                _FilterChip(
                  label: 'Medicines',
                  isSelected: _filterCategory == ProductCategory.veterinaryMedicines,
                  onTap: () => setState(() => _filterCategory = ProductCategory.veterinaryMedicines),
                ),
                _FilterChip(
                  label: 'Equipment',
                  isSelected: _filterCategory == ProductCategory.farmEquipment,
                  onTap: () => setState(() => _filterCategory = ProductCategory.farmEquipment),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: RumenoTheme.textLight),
                        const SizedBox(height: 12),
                        Text('No products found', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _SearchResultCard(product: product);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const ShopBottomBar(currentIndex: 1),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? RumenoTheme.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? RumenoTheme.primaryGreen : Colors.grey.shade300),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : RumenoTheme.textGrey,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Product product;
  const _SearchResultCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/shop/product/${product.id}'),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(_getCategoryIcon(product.category), size: 30, color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                    if (product.isRumenoOwned)
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text('R', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
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
                    Text('${product.vendorName} · ${product.unit}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 4),
                          Text('₹${product.mrp!.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.textLight, fontSize: 11, decoration: TextDecoration.lineThrough)),
                        ],
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            Text(' ${product.rating}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (product.inStock)
                IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: RumenoTheme.primaryGreen, size: 22),
                  onPressed: () {
                    ecommerce.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating),
                    );
                  },
                )
              else
                Text('Out of Stock', style: TextStyle(color: RumenoTheme.errorRed, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _getCategoryIcon(ProductCategory category) {
  switch (category) {
    case ProductCategory.animalFeed:
      return Icons.grass;
    case ProductCategory.supplements:
      return Icons.science;
    case ProductCategory.veterinaryMedicines:
      return Icons.medication;
    case ProductCategory.farmEquipment:
      return Icons.construction;
  }
}
