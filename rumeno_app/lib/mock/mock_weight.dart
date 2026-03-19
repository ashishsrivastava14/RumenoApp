import '../models/models.dart';

/// Mock weight records for animals — monthly recordings over 6 months.
final List<WeightRecord> mockWeightRecords = [
  // ── C-001 (Gir Cow, current 420 kg, born 2020-03-15) ──
  WeightRecord(id: 'W1-1', animalId: '1', date: DateTime(2025, 9, 15), weightKg: 350, notes: 'Post-calving'),
  WeightRecord(id: 'W1-2', animalId: '1', date: DateTime(2025, 10, 15), weightKg: 370),
  WeightRecord(id: 'W1-3', animalId: '1', date: DateTime(2025, 11, 15), weightKg: 385),
  WeightRecord(id: 'W1-4', animalId: '1', date: DateTime(2025, 12, 15), weightKg: 400),
  WeightRecord(id: 'W1-5', animalId: '1', date: DateTime(2026, 1, 15), weightKg: 410),
  WeightRecord(id: 'W1-6', animalId: '1', date: DateTime(2026, 2, 15), weightKg: 420),

  // ── C-003 (Holstein Friesian, current 550 kg, born 2021-01-10) ──
  WeightRecord(id: 'W3-1', animalId: '3', date: DateTime(2025, 9, 10), weightKg: 490),
  WeightRecord(id: 'W3-2', animalId: '3', date: DateTime(2025, 10, 10), weightKg: 505),
  WeightRecord(id: 'W3-3', animalId: '3', date: DateTime(2025, 11, 10), weightKg: 518),
  WeightRecord(id: 'W3-4', animalId: '3', date: DateTime(2025, 12, 10), weightKg: 530),
  WeightRecord(id: 'W3-5', animalId: '3', date: DateTime(2026, 1, 10), weightKg: 540),
  WeightRecord(id: 'W3-6', animalId: '3', date: DateTime(2026, 2, 10), weightKg: 550),

  // ── B-001 (Murrah Buffalo, current 550 kg, born 2019-04-20) ──
  WeightRecord(id: 'W9-1', animalId: '9', date: DateTime(2025, 9, 20), weightKg: 520),
  WeightRecord(id: 'W9-2', animalId: '9', date: DateTime(2025, 10, 20), weightKg: 525),
  WeightRecord(id: 'W9-3', animalId: '9', date: DateTime(2025, 11, 20), weightKg: 530),
  WeightRecord(id: 'W9-4', animalId: '9', date: DateTime(2025, 12, 20), weightKg: 538),
  WeightRecord(id: 'W9-5', animalId: '9', date: DateTime(2026, 1, 20), weightKg: 545),
  WeightRecord(id: 'W9-6', animalId: '9', date: DateTime(2026, 2, 20), weightKg: 550),

  // ── G-001 (Jamunapari Goat, current 45 kg, born 2023-04-10) — good growth ──
  WeightRecord(id: 'W14-1', animalId: '14', date: DateTime(2025, 9, 10), weightKg: 32),
  WeightRecord(id: 'W14-2', animalId: '14', date: DateTime(2025, 10, 10), weightKg: 35),
  WeightRecord(id: 'W14-3', animalId: '14', date: DateTime(2025, 11, 10), weightKg: 37),
  WeightRecord(id: 'W14-4', animalId: '14', date: DateTime(2025, 12, 10), weightKg: 40),
  WeightRecord(id: 'W14-5', animalId: '14', date: DateTime(2026, 1, 10), weightKg: 42),
  WeightRecord(id: 'W14-6', animalId: '14', date: DateTime(2026, 2, 10), weightKg: 45),

  // ── G-002 (Boer Goat, current 55 kg, born 2023-06-22) — great growth (meat breed) ──
  WeightRecord(id: 'W15-1', animalId: '15', date: DateTime(2025, 9, 22), weightKg: 38),
  WeightRecord(id: 'W15-2', animalId: '15', date: DateTime(2025, 10, 22), weightKg: 41),
  WeightRecord(id: 'W15-3', animalId: '15', date: DateTime(2025, 11, 22), weightKg: 44),
  WeightRecord(id: 'W15-4', animalId: '15', date: DateTime(2025, 12, 22), weightKg: 48),
  WeightRecord(id: 'W15-5', animalId: '15', date: DateTime(2026, 1, 22), weightKg: 52),
  WeightRecord(id: 'W15-6', animalId: '15', date: DateTime(2026, 2, 22), weightKg: 55),

  // ── S-001 (Marwari Sheep, current 35 kg, born 2023-03-20) — slow growth ──
  WeightRecord(id: 'W18-1', animalId: '18', date: DateTime(2025, 9, 20), weightKg: 30),
  WeightRecord(id: 'W18-2', animalId: '18', date: DateTime(2025, 10, 20), weightKg: 31),
  WeightRecord(id: 'W18-3', animalId: '18', date: DateTime(2025, 11, 20), weightKg: 31.5),
  WeightRecord(id: 'W18-4', animalId: '18', date: DateTime(2025, 12, 20), weightKg: 33),
  WeightRecord(id: 'W18-5', animalId: '18', date: DateTime(2026, 1, 20), weightKg: 34),
  WeightRecord(id: 'W18-6', animalId: '18', date: DateTime(2026, 2, 20), weightKg: 35),

  // ── P-001 (Large White Yorkshire Pig, current 85 kg, born 2024-02-01) — excellent growth ──
  WeightRecord(id: 'W20-1', animalId: '20', date: DateTime(2025, 9, 1), weightKg: 52),
  WeightRecord(id: 'W20-2', animalId: '20', date: DateTime(2025, 10, 1), weightKg: 58),
  WeightRecord(id: 'W20-3', animalId: '20', date: DateTime(2025, 11, 1), weightKg: 65),
  WeightRecord(id: 'W20-4', animalId: '20', date: DateTime(2025, 12, 1), weightKg: 72),
  WeightRecord(id: 'W20-5', animalId: '20', date: DateTime(2026, 1, 1), weightKg: 79),
  WeightRecord(id: 'W20-6', animalId: '20', date: DateTime(2026, 2, 1), weightKg: 85),

  // ── C-005 (Red Sindhi, current 350 kg, born 2022-05-18) — weight loss scenario ──
  WeightRecord(id: 'W5-1', animalId: '5', date: DateTime(2025, 9, 18), weightKg: 365),
  WeightRecord(id: 'W5-2', animalId: '5', date: DateTime(2025, 10, 18), weightKg: 362),
  WeightRecord(id: 'W5-3', animalId: '5', date: DateTime(2025, 11, 18), weightKg: 358),
  WeightRecord(id: 'W5-4', animalId: '5', date: DateTime(2025, 12, 18), weightKg: 355),
  WeightRecord(id: 'W5-5', animalId: '5', date: DateTime(2026, 1, 18), weightKg: 352),
  WeightRecord(id: 'W5-6', animalId: '5', date: DateTime(2026, 2, 18), weightKg: 350),
];

/// Get weight records for a specific animal, sorted by date.
List<WeightRecord> getWeightRecords(String animalId) {
  return mockWeightRecords
      .where((w) => w.animalId == animalId)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
}
