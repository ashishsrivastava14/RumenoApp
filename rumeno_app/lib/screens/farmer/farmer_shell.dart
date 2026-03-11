import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class FarmerShell extends StatefulWidget {
  final Widget child;

  const FarmerShell({super.key, required this.child});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _currentIndex = 0;

  static const _tabs = [
    '/farmer',
    '/farmer/animals',
    '/farmer/health',
    '/farmer/finance',
    '/farmer/more',
  ];

  @override
  Widget build(BuildContext context) {
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 28), activeIcon: Icon(Icons.home_rounded, size: 32), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded, size: 28), activeIcon: Icon(Icons.pets_rounded, size: 32), label: 'Animals'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded, size: 28), activeIcon: Icon(Icons.favorite_rounded, size: 32), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded, size: 28), activeIcon: Icon(Icons.account_balance_wallet_rounded, size: 32), label: 'Finance'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded, size: 28), activeIcon: Icon(Icons.grid_view_rounded, size: 32), label: 'More'),
        ],
      ),
    );
  }
}
