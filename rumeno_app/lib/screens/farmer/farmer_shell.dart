import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';

class FarmerShell extends StatefulWidget {
  final Widget child;

  const FarmerShell({super.key, required this.child});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _currentIndex = 0;

  static const _tabs = [
    '/farmer/dashboard',
    '/farmer/animals',
    '/farmer/health',
    '/farmer/finance',
    '/farmer/more',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/farmer/animals')) {
      _currentIndex = 1;
    } else if (location.startsWith('/farmer/health')) {
      _currentIndex = 2;
    } else if (location.startsWith('/farmer/finance')) {
      _currentIndex = 3;
    } else if (location.startsWith('/farmer/more')) {
      _currentIndex = 4;
    } else {
      _currentIndex = 0;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          context.go(_tabs[index]);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: RumenoTheme.primaryGreen,
        unselectedItemColor: RumenoTheme.textGrey,
        iconSize: 30,
        selectedFontSize: 13,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_rounded, size: 28), activeIcon: const Icon(Icons.home_rounded, size: 32), label: l10n.navHome),
          BottomNavigationBarItem(icon: const Icon(Icons.pets_rounded, size: 28), activeIcon: const Icon(Icons.pets_rounded, size: 32), label: l10n.navAnimals),
          BottomNavigationBarItem(icon: const Icon(Icons.favorite_rounded, size: 28), activeIcon: const Icon(Icons.favorite_rounded, size: 32), label: l10n.navHealth),
          BottomNavigationBarItem(icon: const Icon(Icons.account_balance_wallet_rounded, size: 28), activeIcon: const Icon(Icons.account_balance_wallet_rounded, size: 32), label: l10n.navFinance),
          BottomNavigationBarItem(icon: const Icon(Icons.grid_view_rounded, size: 28), activeIcon: const Icon(Icons.grid_view_rounded, size: 32), label: l10n.navMore),
        ],
      ),
    );
  }
}
