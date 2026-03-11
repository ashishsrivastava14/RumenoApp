import 'package:flutter/material.dart';
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
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.medical_services_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Veterinarian services coming soon!'),
                ],
              ),
              backgroundColor: RumenoTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 1, top: 4, bottom: 4),
          child: Image.asset(
            'assets/images/veterinarian-yellow.png',
            width: 36,
            height: 36,
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
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Marketplace coming soon!'),
                ],
              ),
              backgroundColor: RumenoTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 0, top: 4, bottom: 4),
          child: Image.asset(
            'assets/images/ecommerce-yellow.png',
            width: 56,
            height: 56,
          ),
        ),
      ),
    );
  }
}
