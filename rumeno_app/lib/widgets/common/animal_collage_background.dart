import 'dart:math';
import 'package:flutter/material.dart';

/// A decorative background widget that renders scattered animal silhouette icons
/// at various positions, sizes, and rotations with low opacity to create an
/// attractive collage effect.
class AnimalCollageBackground extends StatelessWidget {
  /// The color of the animal icons. Defaults to white.
  final Color iconColor;

  /// The opacity of the animal icons. Keep low (0.04–0.12) for readability.
  final double opacity;

  const AnimalCollageBackground({
    super.key,
    this.iconColor = Colors.white,
    this.opacity = 0.07,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final items = _generateItems(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: items.map((item) {
            return Positioned(
              left: item.x,
              top: item.y,
              child: Transform.rotate(
                angle: item.rotation,
                child: Icon(
                  item.icon,
                  size: item.size,
                  color: iconColor.withValues(alpha: item.opacity),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  List<_AnimalItem> _generateItems(double width, double height) {
    final random = Random(42); // Fixed seed for consistent layout
    final animals = [
      Icons.pets,           // Generic animal / paw
      _cow,                 // Cow-like
      _goat,                // Goat-like
      _pig,                 // Pig-like
      Icons.grass,          // Grass / farm
      Icons.agriculture,    // Tractor / farm
      Icons.eco,            // Leaf / nature
      Icons.yard,           // Plant
      Icons.nature,         // Tree
      Icons.water_drop,     // Water
    ];

    // Pre-defined attractive positions for a balanced collage
    final positions = <_AnimalItem>[];
    final count = (width * height / 18000).clamp(15, 30).toInt();

    for (int i = 0; i < count; i++) {
      final icon = animals[i % animals.length];
      final size = 30.0 + random.nextDouble() * 50; // 30–80
      final x = random.nextDouble() * (width - size);
      final y = random.nextDouble() * (height - size);
      final rotation = (random.nextDouble() - 0.5) * 0.8; // -0.4 to 0.4 rad
      final itemOpacity = opacity * (0.5 + random.nextDouble() * 0.7); // vary per item

      positions.add(_AnimalItem(
        icon: icon,
        x: x,
        y: y,
        size: size,
        rotation: rotation,
        opacity: itemOpacity,
      ));
    }

    return positions;
  }

  // Custom icon references using available Material icons
  static const IconData _cow = Icons.cruelty_free;     // Animal face
  static const IconData _goat = Icons.savings;          // Piggy bank (animal shape)
  static const IconData _pig = Icons.emoji_nature;      // Bee / nature
}

class _AnimalItem {
  final IconData icon;
  final double x;
  final double y;
  final double size;
  final double rotation;
  final double opacity;

  const _AnimalItem({
    required this.icon,
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
    required this.opacity,
  });
}
