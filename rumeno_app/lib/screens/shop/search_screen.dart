import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../widgets/common/marketplace_button.dart';
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
    ecommerce.setCategory(null);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();

    var products = ecommerce.products;
    if (_filterCategory != null) {
      products = products.where((p) => p.category == _filterCategory).toList();
    }

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: SizedBox(
          height: 44,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.15),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        ecommerce.setSearchQuery('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              ecommerce.setSearchQuery(val);
              setState(() {});
            },
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            ecommerce.setSearchQuery('');
            context.go('/shop');
          },
        ),
        actions: const [VeterinarianButton(), FarmButton()],
      ),
      body: Column(
        children: [
          // Filter chips - larger
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _FilterChip(
                  icon: Icons.grid_view_rounded,
                  label: 'All',
                  isSelected: _filterCategory == null,
                  onTap: () => setState(() => _filterCategory = null),
                ),
                _FilterChip(
                  icon: Icons.grass_rounded,
                  label: 'Feed',
                  isSelected: _filterCategory == ProductCategory.animalFeed,
                  onTap: () => setState(() => _filterCategory = ProductCategory.animalFeed),
                  color: const Color(0xFF4CAF50),
                ),
                _FilterChip(
                  icon: Icons.science_rounded,
                  label: 'Supplements',
                  isSelected: _filterCategory == ProductCategory.supplements,
                  onTap: () => setState(() => _filterCategory = ProductCategory.supplements),
                  color: const Color(0xFFFF9800),
                ),
                _FilterChip(
                  icon: Icons.medication_rounded,
                  label: 'Medicine',
                  isSelected: _filterCategory == ProductCategory.veterinaryMedicines,
                  onTap: () => setState(() => _filterCategory = ProductCategory.veterinaryMedicines),
                  color: const Color(0xFFE53935),
                ),
                _FilterChip(
                  icon: Icons.construction_rounded,
                  label: 'Tools',
                  isSelected: _filterCategory == ProductCategory.farmEquipment,
                  onTap: () => setState(() => _filterCategory = ProductCategory.farmEquipment),
                  color: const Color(0xFF2196F3),
                ),
              ],
            ),
          ),

          // Results count
          if (products.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${products.length} products found',
                    style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13),
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
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.search_off_rounded, size: 60, color: RumenoTheme.textLight),
                        ),
                        const SizedBox(height: 16),
                        Text('No products found', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 17)),
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
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({required this.icon, required this.label, required this.isSelected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? RumenoTheme.primaryGreen;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? chipColor : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: isSelected ? chipColor : Colors.grey.shade300, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : chipColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : RumenoTheme.textGrey,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
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
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/shop/product/${product.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product image - larger
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(_getCategoryIcon(product.category), size: 36, color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                    if (product.isRumenoOwned)
                      Positioned(
                        top: 3,
                        left: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.verified, color: Colors.white, size: 10),
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
                    Text('${product.vendorName} · ${product.unit}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 17)),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 6),
                          Text('₹${product.mrp!.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.textLight, fontSize: 12, decoration: TextDecoration.lineThrough)),
                        ],
                        const Spacer(),
                        ...List.generate(5, (i) => Icon(
                          i < product.rating.floor() ? Icons.star_rounded :
                          (i < product.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                          color: Colors.amber,
                          size: 14,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (product.inStock)
                GestureDetector(
                  onTap: () {
                    ecommerce.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('${product.name} added!'),
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: RumenoTheme.successGreen,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add_shopping_cart_rounded, color: RumenoTheme.primaryGreen, size: 24),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Out of Stock', style: TextStyle(color: RumenoTheme.errorRed, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
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
      return Icons.grass_rounded;
    case ProductCategory.supplements:
      return Icons.science_rounded;
    case ProductCategory.veterinaryMedicines:
      return Icons.medication_rounded;
    case ProductCategory.farmEquipment:
      return Icons.construction_rounded;
  }
}
