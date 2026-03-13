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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 80, color: RumenoTheme.textLight),
              const SizedBox(height: 16),
              const Text('Product not found', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    final reviews = ecommerce.getReviewsForProduct(productId);
    final isInCart = ecommerce.isInCart(productId);
    final isWishlisted = ecommerce.isInWishlist(productId);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
              ),
            ),
            actions: [
              // Wishlist button
              GestureDetector(
                onTap: () {
                  ecommerce.toggleWishlist(productId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            ecommerce.isInWishlist(productId) ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(ecommerce.isInWishlist(productId) ? 'Added to wishlist!' : 'Removed from wishlist'),
                        ],
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: ecommerce.isInWishlist(productId) ? RumenoTheme.errorRed : RumenoTheme.textGrey,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isWishlisted ? Colors.red : Colors.white,
                    size: 22,
                  ),
                ),
              ),
              // Share button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share link copied!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey.shade50,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(_getCategoryIcon(product.category), size: 120, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    if (product.isRumenoOwned)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text('Rumeno Product', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    if (product.discountPercent > 0)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: RumenoTheme.errorRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discountPercent.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.categoryName,
                      style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name - larger
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text('by ${product.vendorName}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 15)),
                  const SizedBox(height: 16),

                  // Price Row - much bigger
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: RumenoTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MRP ₹${product.mrp!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: RumenoTheme.textLight,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.savings_rounded, color: RumenoTheme.successGreen, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Save ₹${(product.mrp! - product.price).toStringAsFixed(0)}',
                                    style: TextStyle(color: RumenoTheme.successGreen, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('(Inclusive of all taxes)', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text('Unit: ${product.unit}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14)),
                  const SizedBox(height: 14),

                  // Rating & Stock - visual
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: product.rating >= 4.0 ? RumenoTheme.successGreen : Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${product.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(width: 3),
                            const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Visual stars
                      ...List.generate(5, (i) => Icon(
                        i < product.rating.floor() ? Icons.star_rounded :
                        (i < product.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                        color: Colors.amber,
                        size: 20,
                      )),
                      const SizedBox(width: 6),
                      Text('(${product.reviewCount})', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Stock status - prominent
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: product.inStock
                          ? RumenoTheme.successGreen.withValues(alpha: 0.1)
                          : RumenoTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.inStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: product.inStock ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          product.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            color: product.inStock ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Trust badges
                  Row(
                    children: [
                      Expanded(
                        child: _TrustBadge(
                          icon: Icons.local_shipping_rounded,
                          label: 'Free Delivery\n₹999+',
                          color: RumenoTheme.infoBlue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TrustBadge(
                          icon: Icons.verified_user_rounded,
                          label: '100% Genuine\nOriginal Product',
                          color: RumenoTheme.successGreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TrustBadge(
                          icon: Icons.replay_rounded,
                          label: 'Easy Return\n7 Day Policy',
                          color: const Color(0xFF9C27B0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Description
                  Text('Description', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(product.description, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 15, height: 1.6)),

                  if (product.youtubeVideoUrl != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Video will open in YouTube app'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_circle_filled_rounded, color: Colors.red, size: 28),
                        label: const Text('Watch Video', style: TextStyle(fontSize: 15)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Reviews
                  Row(
                    children: [
                      const Icon(Icons.rate_review_rounded, color: Colors.amber, size: 22),
                      const SizedBox(width: 6),
                      Text('Reviews (${reviews.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (reviews.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.rate_review_outlined, size: 48, color: RumenoTheme.textLight),
                            const SizedBox(height: 8),
                            Text('No reviews yet', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 15)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...reviews.map((review) => _ReviewCard(review: review)),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: product.inStock
          ? Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -3))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Add to Cart - large button
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ecommerce.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text('${product.name} added to cart!')),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: RumenoTheme.successGreen,
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  textColor: Colors.white,
                                  onPressed: () => context.go('/shop/cart'),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            isInCart ? Icons.shopping_cart_rounded : Icons.add_shopping_cart_rounded,
                            size: 24,
                          ),
                          label: Text(
                            isInCart ? 'In Cart ✓' : 'Add to Cart',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isInCart ? RumenoTheme.successGreen : RumenoTheme.primaryGreen,
                              width: 2,
                            ),
                            foregroundColor: isInCart ? RumenoTheme.successGreen : RumenoTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Buy Now - large button
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ecommerce.addToCart(product);
                            context.go('/shop/cart');
                          },
                          icon: const Icon(Icons.flash_on_rounded, size: 24),
                          label: const Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RumenoTheme.primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                        ),
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

// ─── Trust Badge ───
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _TrustBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600, height: 1.3),
          ),
        ],
      ),
    );
  }
}

// ─── Review Card ───
class _ReviewCard extends StatelessWidget {
  final ProductReview review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                child: Text(review.userName[0], style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              // Visual star rating
              ...List.generate(5, (i) => Icon(
                i < review.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                color: review.rating >= 4 ? RumenoTheme.successGreen : Colors.amber,
                size: 16,
              )),
            ],
          ),
          if (review.comment != null) ...[
            const SizedBox(height: 10),
            Text(review.comment!, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14, height: 1.4)),
          ],
        ],
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
