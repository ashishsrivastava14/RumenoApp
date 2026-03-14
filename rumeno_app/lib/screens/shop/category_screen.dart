import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../widgets/common/marketplace_button.dart';
import 'shop_home_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryKey;
  const CategoryScreen({super.key, required this.categoryKey});

  ProductCategory _parseCategory() {
    switch (categoryKey) {
      case 'animalFeed':
        return ProductCategory.animalFeed;
      case 'supplements':
        return ProductCategory.supplements;
      case 'veterinaryMedicines':
        return ProductCategory.veterinaryMedicines;
      case 'farmEquipment':
        return ProductCategory.farmEquipment;
      default:
        return ProductCategory.animalFeed;
    }
  }

  String _categoryDisplayName(ProductCategory cat) {
    switch (cat) {
      case ProductCategory.animalFeed:
        return 'Animal Feed';
      case ProductCategory.supplements:
        return 'Tonic';
      case ProductCategory.veterinaryMedicines:
        return 'Medicine';
      case ProductCategory.farmEquipment:
        return 'Tools';
    }
  }

  IconData _categoryIcon(ProductCategory cat) {
    switch (cat) {
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

  Color _categoryColor(ProductCategory cat) {
    switch (cat) {
      case ProductCategory.animalFeed:
        return const Color(0xFF4CAF50);
      case ProductCategory.supplements:
        return const Color(0xFFFF9800);
      case ProductCategory.veterinaryMedicines:
        return const Color(0xFFE53935);
      case ProductCategory.farmEquipment:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _parseCategory();
    final ecommerce = context.watch<EcommerceProvider>();
    final products = ecommerce.getProductsByCategory(category);
    final catColor = _categoryColor(category);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_categoryIcon(category), size: 22, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _categoryDisplayName(category),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: catColor,
        actions: [
          const VeterinarianButton(),
          const FarmButton(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded, size: 26),
                onPressed: () => context.go('/shop/cart'),
              ),
              if (ecommerce.cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      '${ecommerce.cartItemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_categoryIcon(category), size: 56, color: catColor.withValues(alpha: 0.4)),
                  ),
                  const SizedBox(height: 16),
                  Text('No products in this category', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 16)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _CategoryProductCard(product: products[index], accentColor: catColor);
              },
            ),
      bottomNavigationBar: const ShopBottomBar(currentIndex: 0),
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  final Product product;
  final Color accentColor;
  const _CategoryProductCard({required this.product, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();
    final discount = product.mrp != null && product.mrp! > product.price
        ? ((product.mrp! - product.price) / product.mrp! * 100).round()
        : 0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/shop/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Icon(Icons.image_rounded, size: 44, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  if (discount > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: RumenoTheme.errorRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('$discount% OFF', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (product.isRumenoOwned)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: RumenoTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.verified, color: Colors.white, size: 14),
                      ),
                    ),
                  if (!product.inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                        child: const Center(
                          child: Text('Out of Stock', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
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
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < product.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: Colors.amber,
                        size: 13,
                      )),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        const Spacer(),
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
                                      const Text('Added to cart!'),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: RumenoTheme.successGreen,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text('Add', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
