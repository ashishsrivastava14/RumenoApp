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
      case AnimalStatus.deceased:
        return Colors.grey.shade700;
    }
  }

  String _speciesImage(Species species) {
    switch (species) {
      case Species.cow:
        return 'assets/images/animal_cow.png';
      case Species.buffalo:
        return 'assets/images/animal_buffalo.png';
      case Species.goat:
        return 'assets/images/animal_goat.png';
      case Species.sheep:
        return 'assets/images/animal_sheep.png';
      case Species.pig:
        return 'assets/images/animal_pig.png';
      case Species.horse:
        return 'assets/images/animal_horse.png';
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
                // Avatar with gender badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        _speciesImage(animal.species),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: animal.gender == Gender.male
                              ? Colors.blue.shade600
                              : Colors.pink.shade400,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          animal.gender == Gender.male
                              ? Icons.male_rounded
                              : Icons.female_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
                      Row(
                        children: [
                          Text(
                            '${animal.breed} • ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Icon(
                            animal.gender == Gender.male
                                ? Icons.male_rounded
                                : Icons.female_rounded,
                            size: 16,
                            color: animal.gender == Gender.male
                                ? Colors.blue.shade600
                                : Colors.pink.shade400,
                          ),
                          Text(
                            ' • ${animal.ageString}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${animal.weightKg}kg • Shed: ${animal.shedNumber ?? "-"}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: RumenoTheme.textLight,
                                  ),
                            ),
                          ),
                          if (animal.isDead)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                Text('💀', style: TextStyle(fontSize: 11)),
                                SizedBox(width: 3),
                                Text('Dead', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          if (animal.isCastrated)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: RumenoTheme.warningYellow.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('✂️', style: TextStyle(fontSize: 11)),
                            ),
                        ],
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
