import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final product = ecommerce.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product')),
        body: const Center(child: Text('Product not found')),
      );
    }

    final reviews = ecommerce.getReviewsForProduct(productId);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey.shade100,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(_getCategoryIcon(product.category), size: 100, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    if (product.isRumenoOwned)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Rumeno Product', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (product.discountPercent > 0)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: RumenoTheme.errorRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product.discountPercent.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.categoryName,
                      style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Name
                  Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('by ${product.vendorName}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14)),
                  const SizedBox(height: 12),

                  // Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: RumenoTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      if (product.mrp != null && product.mrp! > product.price) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'MRP ₹${product.mrp!.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: RumenoTheme.textLight,
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Save ₹${(product.mrp! - product.price).toStringAsFixed(0)}',
                            style: TextStyle(color: RumenoTheme.successGreen, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('(Inclusive of all taxes)', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text('Unit: ${product.unit}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                  const SizedBox(height: 12),

                  // Rating & Stock
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.rating >= 4.0 ? RumenoTheme.successGreen : Colors.amber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${product.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(width: 2),
                            const Icon(Icons.star, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${product.reviewCount} reviews', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                      const Spacer(),
                      Icon(
                        product.inStock ? Icons.check_circle : Icons.cancel,
                        color: product.inStock ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.inStock ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          color: product.inStock ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Delivery Info
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: RumenoTheme.primaryGreen),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Free delivery on orders above ₹999', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                          Text('Delivered within 3-5 business days', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, color: RumenoTheme.primaryGreen),
                      const SizedBox(width: 8),
                      const Text('100% Genuine Products', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Description
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14, height: 1.5)),

                  if (product.youtubeVideoUrl != null) ...[
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_circle_outline, color: Colors.red),
                      label: const Text('Watch Product Video'),
                    ),
                  ],

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Reviews
                  Row(
                    children: [
                      Text('Reviews (${reviews.length})', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (reviews.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text('No reviews yet', style: TextStyle(color: RumenoTheme.textGrey)),
                      ),
                    )
                  else
                    ...reviews.map((review) => _ReviewCard(review: review)),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: product.inStock
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ecommerce.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(label: 'View Cart', onPressed: () => context.go('/shop/cart')),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ecommerce.addToCart(product);
                          context.go('/shop/cart');
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text('Buy Now'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                child: Text(review.userName[0], style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(width: 8),
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: review.rating >= 4 ? RumenoTheme.successGreen : Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${review.rating.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    const Icon(Icons.star, color: Colors.white, size: 11),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment != null) ...[
            const SizedBox(height: 8),
            Text(review.comment!, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
          ],
        ],
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
