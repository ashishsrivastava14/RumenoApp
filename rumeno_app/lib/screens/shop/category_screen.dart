import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryKey;
  const CategoryScreen({super.key, required this.categoryKey});

  ProductCategory? _parseCategory() {
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
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final category = _parseCategory();

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Category')),
        body: const Center(child: Text('Invalid category')),
      );
    }

    final products = ecommerce.getProductsByCategory(category);
    final String categoryName;
    switch (category) {
      case ProductCategory.animalFeed:
        categoryName = 'Animal Feed';
        break;
      case ProductCategory.supplements:
        categoryName = 'Supplements';
        break;
      case ProductCategory.veterinaryMedicines:
        categoryName = 'Veterinary Medicines';
        break;
      case ProductCategory.farmEquipment:
        categoryName = 'Farm Equipment';
        break;
    }

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(categoryName),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.go('/shop/cart'),
              ),
              if (ecommerce.cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: RumenoTheme.errorRed, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${ecommerce.cartItemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 60, color: RumenoTheme.textLight),
                  const SizedBox(height: 12),
                  Text('No products in this category', style: TextStyle(color: RumenoTheme.textGrey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductGridCard(product: product);
              },
            ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  final Product product;
  const _ProductGridCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();

    return GestureDetector(
      onTap: () => context.go('/shop/product/${product.id}'),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Container(
                height: 110,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(_getCategoryIcon(product.category), size: 44, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    if (product.isRumenoOwned)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: RumenoTheme.primaryGreen, borderRadius: BorderRadius.circular(4)),
                          child: const Text('Rumeno', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (!product.inStock)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          alignment: Alignment.center,
                          child: const Text('OUT OF STOCK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    if (product.discountPercent > 0 && product.inStock)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(color: RumenoTheme.errorRed, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            '${product.discountPercent.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(product.unit, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 10)),
                    const Spacer(),
                    Row(
                      children: [
                        Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 4),
                          Text('₹${product.mrp!.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.textLight, fontSize: 10, decoration: TextDecoration.lineThrough)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 13),
                        Text(' ${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        if (product.inStock)
                          SizedBox(
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                ecommerce.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating),
                                );
                              },
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10), textStyle: const TextStyle(fontSize: 11)),
                              child: const Text('Add'),
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
