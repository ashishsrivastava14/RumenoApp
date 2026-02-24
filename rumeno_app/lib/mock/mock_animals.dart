import '../models/models.dart';

final List<Animal> mockAnimals = [
  // 8 Cows
  Animal(id: '1', tagId: 'C-001', species: Species.cow, breed: 'Gir', dateOfBirth: DateTime(2020, 3, 15), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 420, heightCm: 130, color: 'Reddish Brown', shedNumber: 'A1', farmerId: 'F001'),
  Animal(id: '2', tagId: 'C-002', species: Species.cow, breed: 'Sahiwal', dateOfBirth: DateTime(2019, 7, 22), gender: Gender.female, status: AnimalStatus.pregnant, purpose: AnimalPurpose.dairy, weightKg: 450, heightCm: 135, color: 'Light Brown', shedNumber: 'A1', farmerId: 'F001'),
  Animal(id: '3', tagId: 'C-003', species: Species.cow, breed: 'Holstein Friesian', dateOfBirth: DateTime(2021, 1, 10), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 550, heightCm: 145, color: 'Black & White', shedNumber: 'A2', farmerId: 'F001'),
  Animal(id: '4', tagId: 'C-004', species: Species.cow, breed: 'Jersey', dateOfBirth: DateTime(2020, 11, 5), gender: Gender.female, status: AnimalStatus.dry, purpose: AnimalPurpose.dairy, weightKg: 380, heightCm: 125, color: 'Fawn', shedNumber: 'A2', farmerId: 'F001'),
  Animal(id: '5', tagId: 'C-005', species: Species.cow, breed: 'Red Sindhi', dateOfBirth: DateTime(2022, 5, 18), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 350, heightCm: 120, color: 'Red', shedNumber: 'A3', farmerId: 'F001'),
  Animal(id: '6', tagId: 'C-006', species: Species.cow, breed: 'Tharparkar', dateOfBirth: DateTime(2018, 8, 30), gender: Gender.female, status: AnimalStatus.pregnant, purpose: AnimalPurpose.mixed, weightKg: 400, heightCm: 128, color: 'White', shedNumber: 'A3', farmerId: 'F001'),
  Animal(id: '7', tagId: 'C-007', species: Species.cow, breed: 'Gir', dateOfBirth: DateTime(2023, 2, 14), gender: Gender.male, status: AnimalStatus.active, purpose: AnimalPurpose.breeding, weightKg: 500, heightCm: 140, color: 'Dark Red', shedNumber: 'B1', farmerId: 'F001'),
  Animal(id: '8', tagId: 'C-008', species: Species.cow, breed: 'Sahiwal', dateOfBirth: DateTime(2021, 9, 7), gender: Gender.female, status: AnimalStatus.sick, purpose: AnimalPurpose.dairy, weightKg: 410, heightCm: 132, color: 'Brown', shedNumber: 'A1', farmerId: 'F001'),

  // 5 Buffalos
  Animal(id: '9', tagId: 'B-001', species: Species.buffalo, breed: 'Murrah', dateOfBirth: DateTime(2019, 4, 20), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 550, heightCm: 140, color: 'Black', shedNumber: 'C1', farmerId: 'F001'),
  Animal(id: '10', tagId: 'B-002', species: Species.buffalo, breed: 'Murrah', dateOfBirth: DateTime(2020, 6, 12), gender: Gender.female, status: AnimalStatus.pregnant, purpose: AnimalPurpose.dairy, weightKg: 580, heightCm: 142, color: 'Black', shedNumber: 'C1', farmerId: 'F001'),
  Animal(id: '11', tagId: 'B-003', species: Species.buffalo, breed: 'Jaffarabadi', dateOfBirth: DateTime(2021, 3, 8), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 600, heightCm: 145, color: 'Dark Grey', shedNumber: 'C2', farmerId: 'F001'),
  Animal(id: '12', tagId: 'B-004', species: Species.buffalo, breed: 'Surti', dateOfBirth: DateTime(2022, 1, 25), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 480, heightCm: 135, color: 'Brown-Black', shedNumber: 'C2', farmerId: 'F001'),
  Animal(id: '13', tagId: 'B-005', species: Species.buffalo, breed: 'Murrah', dateOfBirth: DateTime(2020, 10, 3), gender: Gender.male, status: AnimalStatus.active, purpose: AnimalPurpose.breeding, weightKg: 700, heightCm: 155, color: 'Jet Black', shedNumber: 'D1', farmerId: 'F001'),

  // 4 Goats
  Animal(id: '14', tagId: 'G-001', species: Species.goat, breed: 'Jamunapari', dateOfBirth: DateTime(2023, 4, 10), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 45, heightCm: 80, color: 'White', shedNumber: 'E1', farmerId: 'F001'),
  Animal(id: '15', tagId: 'G-002', species: Species.goat, breed: 'Boer', dateOfBirth: DateTime(2023, 6, 22), gender: Gender.male, status: AnimalStatus.active, purpose: AnimalPurpose.meat, weightKg: 55, heightCm: 75, color: 'Brown & White', shedNumber: 'E1', farmerId: 'F001'),
  Animal(id: '16', tagId: 'G-003', species: Species.goat, breed: 'Sirohi', dateOfBirth: DateTime(2022, 11, 15), gender: Gender.female, status: AnimalStatus.pregnant, purpose: AnimalPurpose.mixed, weightKg: 40, heightCm: 72, color: 'Brown', shedNumber: 'E2', farmerId: 'F001'),
  Animal(id: '17', tagId: 'G-012', species: Species.goat, breed: 'Beetal', dateOfBirth: DateTime(2024, 1, 5), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.dairy, weightKg: 38, heightCm: 70, color: 'Black & Tan', shedNumber: 'E2', farmerId: 'F001'),

  // 2 Sheep
  Animal(id: '18', tagId: 'S-001', species: Species.sheep, breed: 'Marwari', dateOfBirth: DateTime(2023, 3, 20), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.mixed, weightKg: 35, heightCm: 65, color: 'White', shedNumber: 'F1', farmerId: 'F001'),
  Animal(id: '19', tagId: 'S-002', species: Species.sheep, breed: 'Nellore', dateOfBirth: DateTime(2023, 8, 14), gender: Gender.male, status: AnimalStatus.active, purpose: AnimalPurpose.meat, weightKg: 42, heightCm: 68, color: 'White-Brown', shedNumber: 'F1', farmerId: 'F001'),

  // 1 Pig
  Animal(id: '20', tagId: 'P-001', species: Species.pig, breed: 'Large White Yorkshire', dateOfBirth: DateTime(2024, 2, 1), gender: Gender.female, status: AnimalStatus.active, purpose: AnimalPurpose.meat, weightKg: 85, heightCm: 60, color: 'Pink-White', shedNumber: 'G1', farmerId: 'F001'),
];

List<Animal> getAnimalsBySpecies(Species species) {
  return mockAnimals.where((a) => a.species == species).toList();
}

Animal? getAnimalById(String id) {
  try {
    return mockAnimals.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
}

Animal? getAnimalByTag(String tagId) {
  try {
    return mockAnimals.firstWhere((a) => a.tagId == tagId);
  } catch (_) {
    return null;
  }
}
