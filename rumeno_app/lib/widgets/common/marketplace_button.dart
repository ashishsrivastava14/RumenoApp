import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

void _showHeaderInfoDialog(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.info_rounded, color: RumenoTheme.primaryGreen, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(
        description,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF424242),
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: RumenoTheme.primaryGreen),
          child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

Widget _infoBadge(BuildContext context, String title, String description) {
  return Positioned(
    right: 0,
    top: 0,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showHeaderInfoDialog(context, title, description),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: RumenoTheme.primaryGreen, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'i',
            style: TextStyle(
              color: RumenoTheme.primaryGreen,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
      ),
    ),
  );
}

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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 1, top: 4, bottom: 4),
              child: Image.asset(
                'assets/images/veterinarian-plusicon.png',
                width: 46,
                height: 46,
              ),
            ),
            _infoBadge(
              context,
              'Veterinarian',
              'Connect with licensed veterinarians to book appointments, request farm visits, and get expert advice on your animals\' health and treatments.',
            ),
          ],
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 0, top: 4, bottom: 4),
              child: Image.asset(
                'assets/images/ecommerce-bag.png',
                width: 46,
                height: 46,
              ),
            ),
            _infoBadge(
              context,
              'Marketplace',
              'Browse and purchase farm supplies, animal feed, medicines, and equipment. Sell your farm produce directly to buyers through the Rumeno marketplace.',
            ),
          ],
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 1, top: 4, bottom: 4),
              child: Image.asset(
                'assets/images/farm7.png',
                width: 46,
                height: 46,
              ),
            ),
            _infoBadge(
              context,
              'Farm Dashboard',
              'Return to your Farm Dashboard to manage your animals, track health records, monitor milk production, and oversee all farm operations.',
            ),
          ],
        ),
      ),
    );
  }
}
