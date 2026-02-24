import '../models/models.dart';

final List<VaccinationRecord> mockVaccinations = [
  VaccinationRecord(id: 'VAC001', animalId: '1', vaccineName: 'FMD', dateAdministered: DateTime(2025, 12, 10), dueDate: DateTime(2025, 12, 10), nextDueDate: DateTime(2026, 6, 10), vetName: 'Dr. Anita Sharma', dose: '5ml', batchNumber: 'FMD-2025-1234', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC002', animalId: '1', vaccineName: 'BQ', dueDate: DateTime(2026, 2, 24), status: VaccinationStatus.due, vetName: 'Dr. Anita Sharma'),
  VaccinationRecord(id: 'VAC003', animalId: '2', vaccineName: 'HS', dateAdministered: DateTime(2025, 11, 5), dueDate: DateTime(2025, 11, 5), nextDueDate: DateTime(2026, 5, 5), vetName: 'Dr. Anita Sharma', dose: '5ml', batchNumber: 'HS-2025-5678', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC004', animalId: '3', vaccineName: 'Brucella', dueDate: DateTime(2026, 1, 15), status: VaccinationStatus.overdue, vetName: 'Dr. Anita Sharma'),
  VaccinationRecord(id: 'VAC005', animalId: '4', vaccineName: 'FMD', dateAdministered: DateTime(2026, 1, 20), dueDate: DateTime(2026, 1, 20), nextDueDate: DateTime(2026, 7, 20), vetName: 'Dr. Pradeep Rao', dose: '5ml', batchNumber: 'FMD-2026-0101', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC006', animalId: '5', vaccineName: 'Deworming', dueDate: DateTime(2026, 2, 28), status: VaccinationStatus.due),
  VaccinationRecord(id: 'VAC007', animalId: '9', vaccineName: 'HS', dateAdministered: DateTime(2025, 10, 15), dueDate: DateTime(2025, 10, 15), nextDueDate: DateTime(2026, 4, 15), vetName: 'Dr. Anita Sharma', dose: '5ml', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC008', animalId: '10', vaccineName: 'BQ', dueDate: DateTime(2026, 3, 1), status: VaccinationStatus.due),
  VaccinationRecord(id: 'VAC009', animalId: '14', vaccineName: 'PPR', dateAdministered: DateTime(2026, 1, 5), dueDate: DateTime(2026, 1, 5), nextDueDate: DateTime(2027, 1, 5), vetName: 'Dr. Anita Sharma', dose: '1ml', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC010', animalId: '15', vaccineName: 'PPR', dueDate: DateTime(2026, 2, 15), status: VaccinationStatus.due),
  VaccinationRecord(id: 'VAC011', animalId: '6', vaccineName: 'FMD', dueDate: DateTime(2026, 3, 10), status: VaccinationStatus.due),
  VaccinationRecord(id: 'VAC012', animalId: '7', vaccineName: 'BQ', dateAdministered: DateTime(2026, 2, 1), dueDate: DateTime(2026, 2, 1), nextDueDate: DateTime(2026, 8, 1), vetName: 'Dr. Pradeep Rao', dose: '5ml', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC013', animalId: '11', vaccineName: 'FMD', dueDate: DateTime(2026, 2, 20), status: VaccinationStatus.overdue),
  VaccinationRecord(id: 'VAC014', animalId: '16', vaccineName: 'Deworming', dateAdministered: DateTime(2026, 2, 10), dueDate: DateTime(2026, 2, 10), nextDueDate: DateTime(2026, 5, 10), vetName: 'Dr. Anita Sharma', status: VaccinationStatus.done),
  VaccinationRecord(id: 'VAC015', animalId: '18', vaccineName: 'PPR', dueDate: DateTime(2026, 3, 5), status: VaccinationStatus.due),
];

final List<TreatmentRecord> mockTreatments = [
  TreatmentRecord(id: 'TR001', animalId: '8', symptoms: ['Fever', 'Loss of appetite', 'Nasal discharge'], diagnosis: 'Upper Respiratory Infection', treatment: 'Oxytetracycline 10mg/kg IM for 5 days', startDate: DateTime(2026, 2, 18), vetName: 'Dr. Anita Sharma', status: TreatmentStatus.active, withdrawalDays: 14, followUpDate: DateTime(2026, 2, 25)),
  TreatmentRecord(id: 'TR002', animalId: '3', symptoms: ['Limping', 'Swollen hoof'], diagnosis: 'Foot Rot', treatment: 'Oxytetracycline spray + foot bath with CuSO4', startDate: DateTime(2026, 2, 10), vetName: 'Dr. Pradeep Rao', status: TreatmentStatus.active, followUpDate: DateTime(2026, 2, 24)),
  TreatmentRecord(id: 'TR003', animalId: '1', symptoms: ['Reduced milk yield', 'Swollen udder'], diagnosis: 'Subclinical Mastitis', treatment: 'Cephalexin intramammary infusion', startDate: DateTime(2026, 1, 25), endDate: DateTime(2026, 2, 5), vetName: 'Dr. Anita Sharma', status: TreatmentStatus.completed, withdrawalDays: 7),
  TreatmentRecord(id: 'TR004', animalId: '14', symptoms: ['Diarrhea', 'Dehydration'], diagnosis: 'Enteritis', treatment: 'ORS + Metronidazole', startDate: DateTime(2026, 2, 15), vetName: 'Dr. Anita Sharma', status: TreatmentStatus.active, followUpDate: DateTime(2026, 2, 23)),
  TreatmentRecord(id: 'TR005', animalId: '9', symptoms: ['Bloating', 'Distended abdomen'], diagnosis: 'Ruminal Tympany', treatment: 'Trocarization + anti-bloat medicine', startDate: DateTime(2026, 1, 20), endDate: DateTime(2026, 1, 22), vetName: 'Dr. Anita Sharma', status: TreatmentStatus.completed),
  TreatmentRecord(id: 'TR006', animalId: '5', symptoms: ['Skin lesions', 'Itching'], diagnosis: 'Mange', treatment: 'Ivermectin 0.2mg/kg SC', startDate: DateTime(2026, 2, 12), vetName: 'Dr. Pradeep Rao', status: TreatmentStatus.followUp, followUpDate: DateTime(2026, 2, 26)),
  TreatmentRecord(id: 'TR007', animalId: '12', symptoms: ['Eye discharge', 'Corneal opacity'], diagnosis: 'Infectious Bovine Keratoconjunctivitis', treatment: 'Oxytetracycline eye ointment', startDate: DateTime(2026, 2, 5), endDate: DateTime(2026, 2, 15), vetName: 'Dr. Anita Sharma', status: TreatmentStatus.completed),
  TreatmentRecord(id: 'TR008', animalId: '20', symptoms: ['Loss of appetite', 'Coughing'], diagnosis: 'Pneumonia', treatment: 'Enrofloxacin 5mg/kg IM', startDate: DateTime(2026, 2, 20), vetName: 'Dr. Anita Sharma', status: TreatmentStatus.active, withdrawalDays: 10, followUpDate: DateTime(2026, 2, 27)),
];

final List<BreedingRecord> mockBreedingRecords = [
  BreedingRecord(id: 'BR001', animalId: '2', heatDate: DateTime(2025, 9, 15), intensity: HeatIntensity.strong, aiDone: true, bullSemenId: 'GIR-BULL-2024', technicianName: 'Mohan Lal', matingDate: DateTime(2025, 9, 16), isPregnant: true, expectedDelivery: DateTime(2026, 6, 15)),
  BreedingRecord(id: 'BR002', animalId: '6', heatDate: DateTime(2025, 8, 20), intensity: HeatIntensity.moderate, aiDone: true, bullSemenId: 'SAHIWAL-BULL-001', technicianName: 'Mohan Lal', matingDate: DateTime(2025, 8, 21), isPregnant: true, expectedDelivery: DateTime(2026, 5, 20)),
  BreedingRecord(id: 'BR003', animalId: '10', heatDate: DateTime(2025, 10, 5), intensity: HeatIntensity.strong, aiDone: false, matingDate: DateTime(2025, 10, 6), isPregnant: true, expectedDelivery: DateTime(2026, 7, 15), notes: 'Natural mating with B-005'),
  BreedingRecord(id: 'BR004', animalId: '16', heatDate: DateTime(2025, 11, 10), intensity: HeatIntensity.moderate, aiDone: false, matingDate: DateTime(2025, 11, 10), isPregnant: true, expectedDelivery: DateTime(2026, 4, 10)),
  BreedingRecord(id: 'BR005', animalId: '4', heatDate: DateTime(2026, 2, 10), intensity: HeatIntensity.mild, aiDone: false, isPregnant: false, notes: 'Heat detected, waiting for next cycle'),
];

final List<AlertItem> mockAlerts = [
  AlertItem(id: 'ALT001', message: 'Vaccination due: Cow #C-001 - Tomorrow', severity: AlertSeverity.high, date: DateTime(2026, 2, 23), animalId: '1'),
  AlertItem(id: 'ALT002', message: 'Pregnancy alert: Buffalo #B-003 - 7 days to delivery', severity: AlertSeverity.medium, date: DateTime(2026, 2, 23), animalId: '10'),
  AlertItem(id: 'ALT003', message: 'Health check done: Goat #G-012', severity: AlertSeverity.low, date: DateTime(2026, 2, 22), animalId: '17'),
  AlertItem(id: 'ALT004', message: 'FMD vaccination overdue: Cow #C-003', severity: AlertSeverity.high, date: DateTime(2026, 2, 22), animalId: '3'),
  AlertItem(id: 'ALT005', message: 'Treatment follow-up due: Cow #C-008', severity: AlertSeverity.high, date: DateTime(2026, 2, 25), animalId: '8'),
];

final List<UpcomingEvent> mockUpcomingEvents = [
  UpcomingEvent(id: 'EVT001', title: 'FMD Vaccination - C-005', eventType: 'Vaccination', date: DateTime(2026, 2, 28), animalId: '5'),
  UpcomingEvent(id: 'EVT002', title: 'Pregnancy Check - C-002', eventType: 'Breeding', date: DateTime(2026, 2, 25), animalId: '2'),
  UpcomingEvent(id: 'EVT003', title: 'Deworming - G-003', eventType: 'Health', date: DateTime(2026, 2, 26), animalId: '16'),
  UpcomingEvent(id: 'EVT004', title: 'Follow-up - C-008', eventType: 'Treatment', date: DateTime(2026, 2, 25), animalId: '8'),
  UpcomingEvent(id: 'EVT005', title: 'Weight Check - All Goats', eventType: 'General', date: DateTime(2026, 3, 1)),
];
