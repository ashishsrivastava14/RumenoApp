import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

/// Veterinarian quick-action button shown in every Farm-Owner page header.
class VeterinarianButton extends StatelessWidget {
  const VeterinarianButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Veterinarian',
      preferBelow: false,
      decoration: BoxDecoration(
        color: RumenoTheme.primaryDarkGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.go('/vet/dashboard'),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 1, top: 4, bottom: 4),
          child: Image.asset(
            'assets/images/veterinarian-plusicon.png',
            width: 46,
            height: 46,
          ),
        ),
      ),
    );
  }
}

/// Ecommerce / marketplace icon button shown in every Farm-Owner page header.
class MarketplaceButton extends StatelessWidget {
  const MarketplaceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Marketplace',
      preferBelow: false,
      decoration: BoxDecoration(
        color: RumenoTheme.primaryDarkGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.go('/shop'),
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 0, top: 4, bottom: 4),
          child: Image.asset(
            'assets/images/ecommerce-bag.png',
            width: 46,
            height: 46,
          ),
        ),
      ),
    );
  }
}

/// Farm quick-action button shown in Vet and Shop page headers.
class FarmButton extends StatelessWidget {
  const FarmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Farm',
      preferBelow: false,
      decoration: BoxDecoration(
        color: RumenoTheme.primaryDarkGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.go('/farmer/dashboard'),
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 1, top: 4, bottom: 4),
          child: Image.asset(
            'assets/images/TractorTrans.png',
            width: 46,
            height: 46,
          ),
        ),
      ),
    );
  }
}
