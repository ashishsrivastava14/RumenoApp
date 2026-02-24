import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/models.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final VoidCallback? onTap;
  final VoidCallback? onHealthTap;
  final VoidCallback? onBreedTap;

  const AnimalCard({
    super.key,
    required this.animal,
    this.onTap,
    this.onHealthTap,
    this.onBreedTap,
  });

  Color _statusColor(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.active:
        return RumenoTheme.successGreen;
      case AnimalStatus.pregnant:
        return RumenoTheme.infoBlue;
      case AnimalStatus.dry:
        return RumenoTheme.warningYellow;
      case AnimalStatus.sick:
        return RumenoTheme.errorRed;
      case AnimalStatus.underTreatment:
        return Colors.orange;
      case AnimalStatus.quarantine:
        return Colors.purple;
    }
  }

  IconData _speciesIcon(Species species) {
    switch (species) {
      case Species.cow:
      case Species.buffalo:
        return Icons.pets;
      case Species.goat:
      case Species.sheep:
        return Icons.grass;
      case Species.pig:
        return Icons.cruelty_free;
      case Species.horse:
        return Icons.directions_run;
    }
  }

  Color _speciesColor(Species species) {
    switch (species) {
      case Species.cow:
        return Colors.brown;
      case Species.buffalo:
        return Colors.blueGrey;
      case Species.goat:
        return Colors.orange;
      case Species.sheep:
        return Colors.teal;
      case Species.pig:
        return Colors.pink;
      case Species.horse:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'animal-${animal.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _speciesColor(animal.species).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _speciesIcon(animal.species),
                    color: _speciesColor(animal.species),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            animal.tagId,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _statusColor(animal.status).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              animal.statusLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(animal.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${animal.breed} • ${animal.gender == Gender.male ? "♂" : "♀"} • ${animal.ageString}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${animal.weightKg}kg • Shed: ${animal.shedNumber ?? "-"}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: RumenoTheme.textLight,
                            ),
                      ),
                    ],
                  ),
                ),
                // Actions
                Column(
                  children: [
                    _ActionIcon(icon: Icons.visibility_outlined, onTap: onTap),
                    const SizedBox(height: 4),
                    _ActionIcon(icon: Icons.medical_services_outlined, onTap: onHealthTap),
                    const SizedBox(height: 4),
                    _ActionIcon(icon: Icons.favorite_outline, onTap: onBreedTap),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: RumenoTheme.primaryGreen),
      ),
    );
  }
}
