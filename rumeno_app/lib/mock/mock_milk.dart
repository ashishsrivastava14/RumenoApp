import '../models/models.dart';

/// In-memory milk records list – mutable so the UI can add new entries.
final List<MilkRecord> mockMilkRecords = [
  // Today's morning entries
  MilkRecord(id: 'MLK001', animalId: '1', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 8.5),
  MilkRecord(id: 'MLK002', animalId: '3', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 12.0),
  MilkRecord(id: 'MLK003', animalId: '5', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 6.5),
  MilkRecord(id: 'MLK004', animalId: '9', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 10.0),
  MilkRecord(id: 'MLK005', animalId: '11', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 11.5),
  MilkRecord(id: 'MLK006', animalId: '12', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 9.0),
  MilkRecord(id: 'MLK007', animalId: '14', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 2.0),
  MilkRecord(id: 'MLK008', animalId: '17', date: DateTime.now(), session: MilkSession.morning, quantityLitres: 1.8),

  // Yesterday's entries
  MilkRecord(id: 'MLK009', animalId: '1', date: DateTime.now().subtract(const Duration(days: 1)), session: MilkSession.morning, quantityLitres: 8.0),
  MilkRecord(id: 'MLK010', animalId: '1', date: DateTime.now().subtract(const Duration(days: 1)), session: MilkSession.evening, quantityLitres: 7.5),
  MilkRecord(id: 'MLK011', animalId: '3', date: DateTime.now().subtract(const Duration(days: 1)), session: MilkSession.morning, quantityLitres: 11.5),
  MilkRecord(id: 'MLK012', animalId: '3', date: DateTime.now().subtract(const Duration(days: 1)), session: MilkSession.evening, quantityLitres: 10.0),
  MilkRecord(id: 'MLK013', animalId: '9', date: DateTime.now().subtract(const Duration(days: 1)), session: MilkSession.morning, quantityLitres: 10.5),
  MilkRecord(id: 'MLK014', animalId: '9', date: DateTime.now().subtract(const Duration(days: 1)), session: MilkSession.evening, quantityLitres: 9.0),
];

/// Get total milk for a given date.
double totalMilkForDate(DateTime date) {
  return mockMilkRecords
      .where((r) => r.date.year == date.year && r.date.month == date.month && r.date.day == date.day)
      .fold(0.0, (sum, r) => sum + r.quantityLitres);
}

/// Get records for a specific date.
List<MilkRecord> milkRecordsForDate(DateTime date) {
  return mockMilkRecords
      .where((r) => r.date.year == date.year && r.date.month == date.month && r.date.day == date.day)
      .toList();
}

/// Get dairy animals (female cows, buffalos, goats with dairy purpose).
List<Animal> getDairyAnimals(List<Animal> animals) {
  return animals.where((a) =>
      a.gender == Gender.female &&
      (a.purpose == AnimalPurpose.dairy || a.purpose == AnimalPurpose.mixed) &&
      a.status != AnimalStatus.dry &&
      a.status != AnimalStatus.quarantine).toList();
}
