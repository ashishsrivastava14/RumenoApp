import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/marketplace_button.dart';
import '../../widgets/common/welcome_popup.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EcommerceProvider>().resetFilters();
      showWelcomePopupIfNeeded(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ecommerce = context.watch<EcommerceProvider>();
    final allProducts = ecommerce.allProductsUnfiltered;
    final feedCount = allProducts.where((p) => p.category == ProductCategory.animalFeed).length;
    final supplementsCount = allProducts.where((p) => p.category == ProductCategory.supplements).length;
    final medicinesCount = allProducts.where((p) => p.category == ProductCategory.veterinaryMedicines).length;
    final equipmentCount = allProducts.where((p) => p.category == ProductCategory.farmEquipment).length;
    final allCount = allProducts.length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          // ─── Simplified App Bar ───
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: RumenoTheme.primaryGreen,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/Rumeno_logo-rb.png',
                  height: 36,
                  width: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.shopHomeTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                const VeterinarianButton(),
                const FarmButton(),
                // Cart with badge
                _CartIconWithBadge(
                  count: ecommerce.cartItemCount,
                  onTap: () => context.go('/shop/cart'),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      RumenoTheme.primaryGreen,
                      RumenoTheme.primaryDarkGreen,
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(58),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: GestureDetector(
                  onTap: () => context.go('/shop/search'),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(Icons.search, color: RumenoTheme.textGrey, size: 26),
                        const SizedBox(width: 10),
                        Text(
                          l10n.shopSearchHint,
                          style: TextStyle(color: RumenoTheme.textGrey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Categories - Large Grid ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category_rounded, color: RumenoTheme.primaryGreen, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        l10n.shopCategoriesSection,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: [
                      _BigCategoryTile(
                        icon: Icons.grass_rounded,
                        label: l10n.shopCategoryFeed,
                        count: feedCount,
                        color: const Color(0xFF4CAF50),
                        bgColor: const Color(0xFFE8F5E9),
                        onTap: () => context.go('/shop/category/animalFeed'),
                      ),
                      _BigCategoryTile(
                        icon: Icons.science_rounded,
                        label: l10n.shopCategoryTonic,
                        count: supplementsCount,
                        color: const Color(0xFFFF9800),
                        bgColor: const Color(0xFFFFF3E0),
                        onTap: () => context.go('/shop/category/supplements'),
                      ),
                      _BigCategoryTile(
                        icon: Icons.medication_rounded,
                        label: l10n.shopCategoryMedicine,
                        count: medicinesCount,
                        color: const Color(0xFFE53935),
                        bgColor: const Color(0xFFFFEBEE),
                        onTap: () => context.go('/shop/category/veterinaryMedicines'),
                      ),
                      _BigCategoryTile(
                        icon: Icons.construction_rounded,
                        label: l10n.shopCategoryTools,
                        count: equipmentCount,
                        color: const Color(0xFF2196F3),
                        bgColor: const Color(0xFFE3F2FD),
                        onTap: () => context.go('/shop/category/farmEquipment'),
                      ),
                      _BigCategoryTile(
                        icon: Icons.biotech_rounded,
                        label: l10n.shopCategorySupplements,
                        count: supplementsCount,
                        color: const Color(0xFF9C27B0),
                        bgColor: const Color(0xFFF3E5F5),
                        onTap: () => context.go('/shop/category/supplements'),
                      ),
                      _BigCategoryTile(
                        icon: Icons.grid_view_rounded,
                        label: l10n.shopCategoryAll,
                        count: allCount,
                        color: const Color(0xFF607D8B),
                        bgColor: const Color(0xFFECEFF1),
                        onTap: () => context.go('/shop/search'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Promotional Banner ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E7D32),
                      RumenoTheme.primaryGreen,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Icon(Icons.local_shipping_rounded, size: 150, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 28),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.shopBannerFreeDelivery,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.shopBannerFreeDeliveryCondition,
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: 'WELCOME20'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(l10n.shopCouponCopiedSnackbar),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: RumenoTheme.successGreen,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_offer_rounded, color: RumenoTheme.primaryGreen, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.shopBannerCouponCode,
                                    style: TextStyle(
                                      color: RumenoTheme.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.copy_rounded, color: RumenoTheme.primaryGreen, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Featured Products ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                  const SizedBox(width: 6),
                  Text(l10n.shopBestProductsSection, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => context.go('/shop/search'),
                    icon: Text(l10n.commonSeeAll),
                    label: const Icon(Icons.arrow_forward_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 290,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: ecommerce.featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = ecommerce.featuredProducts[index];
                  return _FeaturedProductCard(product: product);
                },
              ),
            ),
          ),

          // ─── All Products Grid ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded, color: RumenoTheme.primaryGreen, size: 24),
                  const SizedBox(width: 6),
                  Text(l10n.shopAllProductsSection, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.52,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = ecommerce.products[index];
                  return _ProductGridCard(product: product);
                },
                childCount: ecommerce.products.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
      bottomNavigationBar: _ShopBottomBar(currentIndex: 0),
    );
  }
}

// ─── Cart Icon with Badge ───
class _CartIconWithBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _CartIconWithBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 26),
            if (count > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: RumenoTheme.errorRed,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  child: Text(
                    '$count',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Big Category Tile ───
class _BigCategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _BigCategoryTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count items',
                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                      ),
                    ),
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

// ─── Featured Product Card (Horizontal) ───
class _FeaturedProductCard extends StatelessWidget {
  final Product product;
  const _FeaturedProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/shop/product/${product.id}'),
      child: Container(
        width: 185,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          elevation: 3,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.grey.shade50,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(_getCategoryIcon(product.category), size: 60, color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      if (product.isRumenoOwned)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: RumenoTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified, color: Colors.white, size: 12),
                                SizedBox(width: 3),
                                Text('Rumeno', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      if (product.discountPercent > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: RumenoTheme.errorRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product.discountPercent.toStringAsFixed(0)}% OFF',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      // Star rating visual
                      Row(
                        children: [
                          ...List.generate(5, (i) => Icon(
                            i < product.rating.floor() ? Icons.star_rounded :
                            (i < product.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                            color: Colors.amber,
                            size: 16,
                          )),
                          const SizedBox(width: 4),
                          Text('(${product.reviewCount})', style: TextStyle(fontSize: 10, color: RumenoTheme.textGrey)),
                        ],
                      ),
                      const Spacer(),
                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: RumenoTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (product.mrp != null && product.mrp! > product.price) ...[
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                '₹${product.mrp!.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: RumenoTheme.textLight,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Product Grid Card ───
class _ProductGridCard extends StatelessWidget {
  final Product product;
  const _ProductGridCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();

    return GestureDetector(
      onTap: () => context.push('/shop/product/${product.id}'),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade50,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Icon(_getCategoryIcon(product.category), size: 50, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    if (product.isRumenoOwned)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: Colors.white, size: 10),
                              SizedBox(width: 2),
                              Text('Rumeno', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    if (!product.inStock)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('OUT OF STOCK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ),
                    if (product.discountPercent > 0 && product.inStock)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: RumenoTheme.errorRed, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            '${product.discountPercent.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                    const SizedBox(height: 2),
                    Text(product.unit, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
                    const Spacer(),
                    // Price row
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 4),
                          Text(
                            '₹${product.mrp!.toStringAsFixed(0)}',
                            style: TextStyle(color: RumenoTheme.textLight, fontSize: 11, decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Rating + Add button
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < product.rating.floor() ? Icons.star_rounded :
                          (i < product.rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                          color: Colors.amber,
                          size: 14,
                        )),
                        const Spacer(),
                        if (product.inStock)
                          GestureDetector(
                            onTap: () {
                              ecommerce.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text('${product.name} added!')),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: RumenoTheme.successGreen,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: RumenoTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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

// ─── Shop Bottom Navigation ───
class ShopBottomBar extends StatelessWidget {
  final int currentIndex;
  const ShopBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return _ShopBottomBar(currentIndex: currentIndex);
  }
}

class _ShopBottomBar extends StatelessWidget {
  final int currentIndex;
  const _ShopBottomBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final ecommerce = context.watch<EcommerceProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_rounded,
                outlineIcon: Icons.home_outlined,
                label: l10n.navShopHome,
                isSelected: currentIndex == 0,
                onTap: () => context.go('/shop'),
              ),
              _BottomNavItem(
                icon: Icons.search_rounded,
                outlineIcon: Icons.search,
                label: l10n.navShopSearch,
                isSelected: currentIndex == 1,
                onTap: () => context.go('/shop/search'),
              ),
              _BottomNavItem(
                icon: Icons.shopping_cart_rounded,
                outlineIcon: Icons.shopping_cart_outlined,
                label: l10n.navShopCart,
                isSelected: currentIndex == 2,
                badge: ecommerce.cartItemCount > 0 ? ecommerce.cartItemCount : null,
                onTap: () => context.go('/shop/cart'),
              ),
              _BottomNavItem(
                icon: Icons.receipt_long_rounded,
                outlineIcon: Icons.receipt_long_outlined,
                label: l10n.navShopOrders,
                isSelected: currentIndex == 3,
                onTap: () {
                  if (auth.isAuthenticated) {
                    context.go('/shop/orders');
                  } else {
                    context.go('/login?redirect=${Uri.encodeComponent('/shop/orders')}');
                  }
                },
              ),
              _BottomNavItem(
                icon: Icons.person_rounded,
                outlineIcon: Icons.person_outline,
                label: l10n.navShopAccount,
                isSelected: currentIndex == 4,
                onTap: () {
                  if (auth.isAuthenticated) {
                    context.go('/shop/account');
                  } else {
                    context.go('/login?redirect=${Uri.encodeComponent('/shop/account')}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData outlineIcon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.outlineIcon,
    required this.label,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? RumenoTheme.primaryGreen.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? icon : outlineIcon,
                  color: isSelected ? RumenoTheme.primaryGreen : RumenoTheme.textGrey,
                  size: 26,
                ),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: RumenoTheme.errorRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$badge',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? RumenoTheme.primaryGreen : RumenoTheme.textGrey,
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
      return Icons.grass_rounded;
    case ProductCategory.tonic:
      return Icons.local_drink_rounded;
    case ProductCategory.supplements:
      return Icons.science_rounded;
    case ProductCategory.veterinaryMedicines:
      return Icons.medication_rounded;
    case ProductCategory.farmEquipment:
      return Icons.construction_rounded;
  }
}
