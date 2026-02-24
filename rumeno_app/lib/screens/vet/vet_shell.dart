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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture_rounded), label: 'Farms'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_rounded), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Earnings'),
        ],
      ),
    );
  }
}
