import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VetShell extends StatelessWidget {
  final Widget child;
  const VetShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/vet/farms')) return 1;
    if (loc.startsWith('/vet/health')) return 2;
    if (loc.startsWith('/vet/earnings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/vet/dashboard');
            case 1:
              context.go('/vet/farms');
            case 2:
              context.go('/vet/health');
            case 3:
              context.go('/vet/earnings');
          }
        },
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFF5B7A2E).withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF5B7A2E)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.agriculture_outlined),
            selectedIcon: Icon(Icons.agriculture_rounded, color: Color(0xFF5B7A2E)),
            label: 'Farms',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services_rounded, color: Color(0xFF5B7A2E)),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF5B7A2E)),
            label: 'Earnings',
          ),
        ],
      ),
    );
  }
}
