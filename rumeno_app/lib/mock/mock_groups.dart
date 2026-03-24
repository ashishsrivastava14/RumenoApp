import '../models/models.dart';

final List<AnimalGroup> mockGroups = [
  // Cow groups
  AnimalGroup(
    id: 'GRP001',
    name: 'Dairy Cows - Shed A',
    species: Species.cow,
    animalIds: ['1', '2', '3', '4', '5'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 6, 1),
  ),
  AnimalGroup(
    id: 'GRP002',
    name: 'Breeding Bulls',
    species: Species.cow,
    animalIds: ['7', '21', '23'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 7, 15),
  ),
  AnimalGroup(
    id: 'GRP003',
    name: 'Pregnant Cows',
    species: Species.cow,
    animalIds: ['2', '6'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 9, 20),
  ),

  // Buffalo groups
  AnimalGroup(
    id: 'GRP004',
    name: 'Murrah Buffalos',
    species: Species.buffalo,
    animalIds: ['9', '10', '13'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 8, 10),
  ),
  AnimalGroup(
    id: 'GRP005',
    name: 'All Buffalos',
    species: Species.buffalo,
    animalIds: ['9', '10', '11', '12', '13'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 6, 5),
  ),

  // Goat groups
  AnimalGroup(
    id: 'GRP006',
    name: 'Dairy Goats',
    species: Species.goat,
    animalIds: ['14', '17'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 10, 1),
  ),
  AnimalGroup(
    id: 'GRP007',
    name: 'All Goats',
    species: Species.goat,
    animalIds: ['14', '15', '16', '17'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 10, 1),
  ),

  // Sheep group
  AnimalGroup(
    id: 'GRP008',
    name: 'Sheep Flock',
    species: Species.sheep,
    animalIds: ['18', '19'],
    farmerId: 'F001',
    createdAt: DateTime(2025, 11, 5),
  ),

  // Mixed / cross-species
  AnimalGroup(
    id: 'GRP009',
    name: 'FMD Vaccination Batch',
    species: null,
    animalIds: ['1', '3', '5', '9', '11', '12'],
    farmerId: 'F001',
    createdAt: DateTime(2026, 1, 10),
  ),
];

final List<GroupAlert> mockGroupAlerts = [
  GroupAlert(
    id: 'GA001',
    groupId: 'GRP001',
    title: 'FMD Vaccination Due',
    description: 'Annual FMD vaccination for all dairy cows in Shed A',
    type: GroupAlertType.vaccination,
    dueDate: DateTime(2026, 4, 10),
  ),
  GroupAlert(
    id: 'GA002',
    groupId: 'GRP005',
    title: 'Deworming Schedule',
    description: 'Quarterly deworming for all buffalos',
    type: GroupAlertType.deworming,
    dueDate: DateTime(2026, 4, 15),
  ),
  GroupAlert(
    id: 'GA003',
    groupId: 'GRP003',
    title: 'Pregnancy Checkup',
    description: 'Monthly pregnancy monitoring for pregnant cows',
    type: GroupAlertType.checkup,
    dueDate: DateTime(2026, 3, 25),
  ),
  GroupAlert(
    id: 'GA004',
    groupId: 'GRP007',
    title: 'PPR Vaccination',
    description: 'PPR vaccination for all goats',
    type: GroupAlertType.vaccination,
    dueDate: DateTime(2026, 5, 1),
  ),
  GroupAlert(
    id: 'GA005',
    groupId: 'GRP009',
    title: 'FMD Booster',
    description: 'FMD booster shot for vaccination batch',
    type: GroupAlertType.vaccination,
    dueDate: DateTime(2026, 7, 10),
  ),
];
