import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
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
        destinations: [
          NavigationDestination(
            icon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('📊', style: TextStyle(fontSize: 22)),
                Icon(Icons.dashboard_outlined, size: 18),
              ],
            ),
            selectedIcon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('📊', style: TextStyle(fontSize: 22)),
                Icon(Icons.dashboard_rounded, color: Color(0xFF5B7A2E), size: 18),
              ],
            ),
            label: l10n.navVetDashboard,
          ),
          NavigationDestination(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌾', style: TextStyle(fontSize: 22)),
                Image.asset('assets/images/farm1.png', width: 18, height: 18),
              ],
            ),
            selectedIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌾', style: TextStyle(fontSize: 22)),
                Image.asset('assets/images/farm1.png', width: 18, height: 18),
              ],
            ),
            label: l10n.navVetFarms,
          ),
          NavigationDestination(
            icon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🩺', style: TextStyle(fontSize: 22)),
                Icon(Icons.medical_services_outlined, size: 18),
              ],
            ),
            selectedIcon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🩺', style: TextStyle(fontSize: 22)),
                Icon(Icons.medical_services_rounded, color: Color(0xFF5B7A2E), size: 18),
              ],
            ),
            label: l10n.navVetHealth,
          ),
          NavigationDestination(
            icon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('💰', style: TextStyle(fontSize: 22)),
                Icon(Icons.account_balance_wallet_outlined, size: 18),
              ],
            ),
            selectedIcon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('💰', style: TextStyle(fontSize: 22)),
                Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF5B7A2E), size: 18),
              ],
            ),
            label: l10n.navVetEarnings,
          ),
        ],
      ),
    );
  }
}
