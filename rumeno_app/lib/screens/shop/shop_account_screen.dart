import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ecommerce_provider.dart';
import 'shop_home_screen.dart';

class ShopAccountScreen extends StatelessWidget {
  const ShopAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.person_rounded, size: 24),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Profile Card - bigger
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                      child: Text(
                        user?.name.isNotEmpty == true ? user!.name[0] : 'U',
                        style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'User', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone_rounded, size: 14, color: RumenoTheme.textGrey),
                              const SizedBox(width: 4),
                              Text(user?.phone ?? '', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Quick Actions - Shopping related
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'My Orders',
                  color: const Color(0xFF2196F3),
                  onTap: () => context.go('/shop/orders'),
                ),
                _MenuItem(
                  icon: Icons.location_on_rounded,
                  label: 'Saved Addresses',
                  color: const Color(0xFF4CAF50),
                  onTap: () => _showAddressesBottomSheet(context),
                ),
                _MenuItem(
                  icon: Icons.favorite_rounded,
                  label: 'Wishlist',
                  color: const Color(0xFFE91E63),
                  onTap: () => _showWishlistBottomSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Switch apps
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.agriculture_rounded,
                  label: 'Switch to Farm',
                  color: const Color(0xFF8BC34A),
                  onTap: () => context.go('/farmer/dashboard'),
                ),
                _MenuItem(
                  icon: Icons.medical_services_rounded,
                  label: 'Switch to Vet',
                  color: const Color(0xFF009688),
                  onTap: () => context.go('/vet/dashboard'),
                ),
                _MenuItem(
                  icon: Icons.storefront_rounded,
                  label: 'Become a Vendor',
                  color: const Color(0xFFFF9800),
                  onTap: () => context.go('/shop/vendor-register'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Support
            _MenuCard(
              items: [
                _MenuItem(
                  icon: Icons.help_rounded,
                  label: 'Help & Support',
                  color: const Color(0xFF00BCD4),
                  onTap: () => _showHelpBottomSheet(context),
                ),
                _MenuItem(
                  icon: Icons.info_rounded,
                  label: 'About Rumeno',
                  color: const Color(0xFF607D8B),
                  onTap: () => _showAboutBottomSheet(context),
                ),
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: RumenoTheme.errorRed,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Row(
                          children: [
                            Icon(Icons.logout_rounded, color: RumenoTheme.errorRed),
                            const SizedBox(width: 10),
                            const Text('Logout?'),
                          ],
                        ),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              auth.logout();
                              context.go('/shop');
                            },
                            child: Text('Logout', style: TextStyle(color: RumenoTheme.errorRed)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ShopBottomBar(currentIndex: 4),
    );
  }

  void _showAddressesBottomSheet(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();
    final addresses = ecommerce.addresses;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, color: RumenoTheme.primaryGreen, size: 24),
                  const SizedBox(width: 8),
                  const Text('Saved Addresses', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: addresses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off_rounded, size: 50, color: RumenoTheme.textLight),
                          const SizedBox(height: 12),
                          const Text('No saved addresses'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: addresses.length,
                      itemBuilder: (_, i) {
                        final addr = addresses[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.home_rounded, color: RumenoTheme.primaryGreen, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(addr.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                          if (addr.isDefault) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text('Default', style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(addr.fullAddress, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.phone_rounded, size: 13, color: RumenoTheme.textGrey),
                                          const SizedBox(width: 4),
                                          Text(addr.phone, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWishlistBottomSheet(BuildContext context) {
    final ecommerce = context.read<EcommerceProvider>();
    final wishlist = ecommerce.wishlistProducts;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.favorite_rounded, color: const Color(0xFFE91E63), size: 24),
                  const SizedBox(width: 8),
                  const Text('Wishlist', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: wishlist.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline_rounded, size: 50, color: RumenoTheme.textLight),
                          const SizedBox(height: 12),
                          const Text('No wishlist items'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: wishlist.length,
                      itemBuilder: (_, i) {
                        final product = wishlist[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pop(ctx);
                              context.go('/shop/product/${product.id}');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.image_rounded, size: 28, color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  if (product.inStock)
                                    GestureDetector(
                                      onTap: () {
                                        ecommerce.addToCart(product);
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                                                const SizedBox(width: 8),
                                                Text('${product.name} added to cart!'),
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
                                        child: Icon(Icons.add_shopping_cart_rounded, color: RumenoTheme.primaryGreen, size: 22),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Row(
              children: [
                Icon(Icons.help_rounded, color: const Color(0xFF00BCD4), size: 28),
                const SizedBox(width: 10),
                const Text('Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            _HelpItem(
              icon: Icons.phone_rounded,
              color: RumenoTheme.successGreen,
              title: 'Call Us',
              subtitle: '+91 98765 43210',
            ),
            _HelpItem(
              icon: Icons.email_rounded,
              color: RumenoTheme.infoBlue,
              title: 'Email',
              subtitle: 'support@rumeno.com',
            ),
            _HelpItem(
              icon: Icons.chat_rounded,
              color: const Color(0xFF9C27B0),
              title: 'WhatsApp',
              subtitle: '+91 98765 43210',
            ),
            _HelpItem(
              icon: Icons.access_time_rounded,
              color: RumenoTheme.warningYellow,
              title: 'Working Hours',
              subtitle: 'Mon-Sat, 9 AM - 6 PM',
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showAboutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            // Logo
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/Rumeno_logo-rb.png',
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) => Icon(Icons.store_rounded, color: RumenoTheme.primaryGreen, size: 36),
              ),
            ),
            const SizedBox(height: 12),
            Text('Rumeno Shop', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
            const SizedBox(height: 4),
            Text('Version 1.0.0', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RumenoTheme.backgroundCream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Rumeno is your one-stop shop for animal feed, supplements, medicines, and farm equipment. We deliver quality products at the best prices.',
                style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text('Made with ❤️ in India', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (item.color ?? RumenoTheme.primaryGreen).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color ?? RumenoTheme.primaryGreen, size: 22),
                ),
                title: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.chevron_right_rounded, color: RumenoTheme.textLight, size: 24),
                onTap: item.onTap,
              ),
              if (idx < items.length - 1) const Divider(height: 1, indent: 60),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color});
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _HelpItem({required this.icon, required this.color, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(subtitle, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
