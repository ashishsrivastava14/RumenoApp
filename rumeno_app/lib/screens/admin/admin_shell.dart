import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/admin/farmers')) return 1;
    if (loc.startsWith('/admin/animals')) return 2;
    if (loc.startsWith('/admin/health')) return 3;
    if (loc.startsWith('/admin/more')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: idx,
              extended: MediaQuery.of(context).size.width > 900,
              backgroundColor: Colors.white,
              onDestinationSelected: (i) => _navigate(context, i),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(Icons.admin_panel_settings_rounded, color: RumenoTheme.primaryGreen, size: 32),
                    const SizedBox(height: 4),
                    const Text('Rumeno', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_rounded), label: Text('Dashboard')),
                NavigationRailDestination(icon: Icon(Icons.people_rounded), label: Text('Farmers')),
                NavigationRailDestination(icon: Icon(Icons.pets_rounded), label: Text('Animals')),
                NavigationRailDestination(icon: Icon(Icons.health_and_safety_rounded), label: Text('Health')),
                NavigationRailDestination(icon: Icon(Icons.more_horiz_rounded), label: Text('More')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => _navigate(context, i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Farmers'),
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded), label: 'Animals'),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety_rounded), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz_rounded), label: 'More'),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/admin/dashboard');
      case 1:
        context.go('/admin/farmers');
      case 2:
        context.go('/admin/animals');
      case 3:
        context.go('/admin/health');
      case 4:
        context.go('/admin/more');
    }
  }
}
