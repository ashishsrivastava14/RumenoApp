import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../providers/auth_provider.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar with search, Farm/Vet icons ───
          SliverAppBar(
            expandedHeight: 130,
            floating: true,
            pinned: true,
            backgroundColor: RumenoTheme.primaryGreen,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/Rumeno_logo-rb.png',
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.store, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Rumeno',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                // Farm App Icon
                _HeaderIconButton(
                  icon: Icons.agriculture,
                  label: 'Farm',
                  onTap: () {
                    if (auth.isAuthenticated) {
                      context.go('/farmer/dashboard');
                    } else {
                      auth.selectRole(UserRole.farmer);
                      context.go('/login');
                    }
                  },
                ),
                const SizedBox(width: 4),
                // Vet Icon
                _HeaderIconButton(
                  icon: Icons.medical_services,
                  label: 'Vet',
                  onTap: () {
                    if (auth.isAuthenticated) {
                      context.go('/vet/dashboard');
                    } else {
                      auth.selectRole(UserRole.vet);
                      context.go('/login');
                    }
                  },
                ),
                const SizedBox(width: 4),
                // Cart Icon
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      onPressed: () => context.go('/shop/cart'),
                    ),
                    if (ecommerce.cartItemCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: RumenoTheme.errorRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            '${ecommerce.cartItemCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
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
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: GestureDetector(
                  onTap: () => context.go('/shop/search'),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: RumenoTheme.textGrey, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Search feed, medicines, equipment...',
                          style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Categories ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop by Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _CategoryChip(
                        icon: Icons.grass,
                        label: 'Feed',
                        color: const Color(0xFF4CAF50),
                        onTap: () {
                          ecommerce.setCategory(ProductCategory.animalFeed);
                          context.go('/shop/category/animalFeed');
                        },
                      ),
                      _CategoryChip(
                        icon: Icons.science,
                        label: 'Supplements',
                        color: const Color(0xFFFF9800),
                        onTap: () {
                          ecommerce.setCategory(ProductCategory.supplements);
                          context.go('/shop/category/supplements');
                        },
                      ),
                      _CategoryChip(
                        icon: Icons.medication,
                        label: 'Medicines',
                        color: const Color(0xFFE53935),
                        onTap: () {
                          ecommerce.setCategory(ProductCategory.veterinaryMedicines);
                          context.go('/shop/category/veterinaryMedicines');
                        },
                      ),
                      _CategoryChip(
                        icon: Icons.construction,
                        label: 'Equipment',
                        color: const Color(0xFF2196F3),
                        onTap: () {
                          ecommerce.setCategory(ProductCategory.farmEquipment);
                          context.go('/shop/category/farmEquipment');
                        },
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      RumenoTheme.primaryGreen,
                      RumenoTheme.accentOlive,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(Icons.local_offer, size: 120, color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Free Delivery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'On orders above ₹999',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Use code: WELCOME20',
                              style: TextStyle(
                                color: RumenoTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                  Text('Featured Products', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/shop/search'),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('All Products', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
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

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: _ShopBottomBar(currentIndex: 0),
    );
  }
}

// ─── Header Icon Button ───
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

// ─── Category Chip ───
class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        ],
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
      onTap: () => context.go('/shop/product/${product.id}'),
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Rumeno', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (product.discountPercent > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: RumenoTheme.errorRed,
                              borderRadius: BorderRadius.circular(4),
                            ),
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(product.vendorName, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: RumenoTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 4),
                          Text(
                            '₹${product.mrp!.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: RumenoTheme.textLight,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: TextStyle(fontSize: 10, color: RumenoTheme.textGrey),
                        ),
                      ],
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

// ─── Product Grid Card ───
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
            // Image
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
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
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
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(product.unit, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 10)),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (product.mrp != null && product.mrp! > product.price) ...[
                          const SizedBox(width: 4),
                          Text(
                            '₹${product.mrp!.toStringAsFixed(0)}',
                            style: TextStyle(color: RumenoTheme.textLight, fontSize: 10, decoration: TextDecoration.lineThrough),
                          ),
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
                                  SnackBar(
                                    content: Text('${product.name} added to cart'),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                textStyle: const TextStyle(fontSize: 11),
                              ),
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
    final auth = context.watch<AuthProvider>();

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (idx) {
        switch (idx) {
          case 0:
            context.go('/shop');
            break;
          case 1:
            context.go('/shop/search');
            break;
          case 2:
            context.go('/shop/cart');
            break;
          case 3:
            if (auth.isAuthenticated) {
              context.go('/shop/orders');
            } else {
              context.go('/login');
            }
            break;
          case 4:
            if (auth.isAuthenticated) {
              context.go('/shop/account');
            } else {
              context.go('/login');
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
      ],
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
