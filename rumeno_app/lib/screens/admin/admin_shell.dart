import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/admin/farmers')) return 1;
    if (loc.startsWith('/admin/farm')) return 2;
    if (loc.startsWith('/admin/shop')) return 3;
    if (loc.startsWith('/admin/vets')) return 4;
    if (loc.startsWith('/admin/more')) return 5;
    return 0;
  }

  static const _destinations = [
    _NavItem(Icons.dashboard_rounded, Icons.dashboard_outlined, '📊', 'Home', '/admin/dashboard'),
    _NavItem(Icons.people_rounded, Icons.people_outline_rounded, '👨‍🌾', 'Farmers', '/admin/farmers'),
    _NavItem(Icons.agriculture_rounded, Icons.agriculture_outlined, '🐄', 'Farm', '/admin/farm'),
    _NavItem(Icons.storefront_rounded, Icons.storefront_outlined, '🛒', 'Shop', '/admin/shop'),
    _NavItem(Icons.medical_services_rounded, Icons.medical_services_outlined, '🩺', 'Vets', '/admin/vets'),
    _NavItem(Icons.more_horiz_rounded, Icons.more_horiz_rounded, '⚙️', 'More', '/admin/more'),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    final width = MediaQuery.of(context).size.width;

    if (width > 700) {
      return Scaffold(
        body: Row(
          children: [
            _buildRail(context, idx, width > 960),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNav(context, idx),
    );
  }

  Widget _buildRail(BuildContext context, int idx, bool extended) {
    return NavigationRail(
      selectedIndex: idx,
      extended: extended,
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(color: RumenoTheme.primaryGreen, size: 26),
      selectedLabelTextStyle: TextStyle(
        color: RumenoTheme.primaryGreen,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 24),
      unselectedLabelTextStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      onDestinationSelected: (i) => context.go(_destinations[i].path),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [RumenoTheme.primaryDarkGreen, RumenoTheme.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 26),
            ),
            if (extended) ...[
              const SizedBox(height: 8),
              Text(
                'Rumeno Admin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: RumenoTheme.primaryDarkGreen,
                ),
              ),
            ],
          ],
        ),
      ),
      destinations: _destinations
          .map((d) => NavigationRailDestination(
                icon: Icon(d.outlinedIcon),
                selectedIcon: Icon(d.filledIcon),
                label: Text(d.label),
              ))
          .toList(),
    );
  }

  Widget _buildBottomNav(BuildContext context, int idx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 72,
          child: Row(
            children: _destinations.asMap().entries.map((e) {
              final selected = e.key == idx;
              final item = e.value;
              return Expanded(
                child: InkWell(
                  onTap: () => context.go(item.path),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected
                              ? RumenoTheme.primaryGreen.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.emoji,
                          style: TextStyle(fontSize: selected ? 24 : 20),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                          color: selected ? RumenoTheme.primaryGreen : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData filledIcon;
  final IconData outlinedIcon;
  final String emoji;
  final String label;
  final String path;
  const _NavItem(this.filledIcon, this.outlinedIcon, this.emoji, this.label, this.path);
}
