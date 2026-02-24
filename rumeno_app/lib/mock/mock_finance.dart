import '../models/models.dart';

final List<ExpenseRecord> mockExpenses = [
  ExpenseRecord(id: 'EXP001', category: ExpenseCategory.feed, subCategory: 'Cattle Feed', amount: 12500, date: DateTime(2026, 2, 20), vendorName: 'Amul Feed Store', paymentMode: PaymentMode.upi, notes: 'Monthly cattle feed', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP002', category: ExpenseCategory.feed, subCategory: 'Green Fodder', amount: 8000, date: DateTime(2026, 2, 18), vendorName: 'Local Market', paymentMode: PaymentMode.cash, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP003', category: ExpenseCategory.medicine, subCategory: 'Antibiotics', amount: 2500, date: DateTime(2026, 2, 18), vendorName: 'Vet Pharmacy', paymentMode: PaymentMode.upi, animalId: '8', notes: 'Oxytetracycline for C-008', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP004', category: ExpenseCategory.veterinary, subCategory: 'Consultation', amount: 1500, date: DateTime(2026, 2, 18), vendorName: 'Dr. Anita Sharma', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP005', category: ExpenseCategory.labour, subCategory: 'Farm Hand', amount: 15000, date: DateTime(2026, 2, 1), vendorName: 'Mohan Lal', paymentMode: PaymentMode.bank, notes: 'Monthly salary', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP006', category: ExpenseCategory.labour, subCategory: 'Farm Hand', amount: 12000, date: DateTime(2026, 2, 1), vendorName: 'Ramu', paymentMode: PaymentMode.cash, notes: 'Monthly salary', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP007', category: ExpenseCategory.equipment, subCategory: 'Milking Machine Parts', amount: 3500, date: DateTime(2026, 2, 15), vendorName: 'Agri Equipment Shop', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP008', category: ExpenseCategory.transport, subCategory: 'Feed Transport', amount: 2000, date: DateTime(2026, 2, 20), vendorName: 'Local Transporter', paymentMode: PaymentMode.cash, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP009', category: ExpenseCategory.feed, subCategory: 'Mineral Mixture', amount: 3200, date: DateTime(2026, 2, 10), vendorName: 'Amul Feed Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP010', category: ExpenseCategory.medicine, subCategory: 'Deworming', amount: 800, date: DateTime(2026, 2, 10), vendorName: 'Vet Pharmacy', paymentMode: PaymentMode.cash, animalId: '16', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP011', category: ExpenseCategory.veterinary, subCategory: 'AI Service', amount: 500, date: DateTime(2026, 2, 10), vendorName: 'AI Center Palanpur', paymentMode: PaymentMode.cash, animalId: '4', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP012', category: ExpenseCategory.feed, subCategory: 'Hay', amount: 5500, date: DateTime(2026, 1, 25), vendorName: 'Local Farmer', paymentMode: PaymentMode.cash, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP013', category: ExpenseCategory.other, subCategory: 'Insurance', amount: 8000, date: DateTime(2026, 1, 15), vendorName: 'HDFC Ergo', paymentMode: PaymentMode.bank, notes: 'Annual livestock insurance', farmerId: 'F001'),
  ExpenseRecord(id: 'EXP014', category: ExpenseCategory.equipment, subCategory: 'Water Pump', amount: 6500, date: DateTime(2026, 1, 20), vendorName: 'Hardware Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP015', category: ExpenseCategory.feed, subCategory: 'Cattle Feed', amount: 11800, date: DateTime(2026, 1, 20), vendorName: 'Amul Feed Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP016', category: ExpenseCategory.labour, subCategory: 'Farm Hand', amount: 15000, date: DateTime(2026, 1, 1), vendorName: 'Mohan Lal', paymentMode: PaymentMode.bank, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP017', category: ExpenseCategory.labour, subCategory: 'Farm Hand', amount: 12000, date: DateTime(2026, 1, 1), vendorName: 'Ramu', paymentMode: PaymentMode.cash, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP018', category: ExpenseCategory.medicine, subCategory: 'Vaccines', amount: 3000, date: DateTime(2026, 1, 5), vendorName: 'Vet Pharmacy', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP019', category: ExpenseCategory.veterinary, subCategory: 'Health Checkup', amount: 2000, date: DateTime(2026, 1, 10), vendorName: 'Dr. Anita Sharma', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP020', category: ExpenseCategory.transport, amount: 1500, date: DateTime(2026, 1, 22), vendorName: 'Local Transporter', paymentMode: PaymentMode.cash, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP021', category: ExpenseCategory.feed, subCategory: 'Cattle Feed', amount: 12000, date: DateTime(2025, 12, 20), vendorName: 'Amul Feed Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP022', category: ExpenseCategory.labour, subCategory: 'Farm Hand', amount: 27000, date: DateTime(2025, 12, 1), vendorName: 'Staff', paymentMode: PaymentMode.bank, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP023', category: ExpenseCategory.medicine, amount: 1800, date: DateTime(2025, 12, 15), vendorName: 'Vet Pharmacy', paymentMode: PaymentMode.cash, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP024', category: ExpenseCategory.feed, subCategory: 'Feed Supplements', amount: 4500, date: DateTime(2025, 11, 18), vendorName: 'Agri Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP025', category: ExpenseCategory.labour, subCategory: 'Staff', amount: 27000, date: DateTime(2025, 11, 1), vendorName: 'Staff', paymentMode: PaymentMode.bank, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP026', category: ExpenseCategory.feed, subCategory: 'Cattle Feed', amount: 11500, date: DateTime(2025, 11, 20), vendorName: 'Amul Feed Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP027', category: ExpenseCategory.equipment, subCategory: 'Shed Repair', amount: 15000, date: DateTime(2025, 10, 10), vendorName: 'Local Contractor', paymentMode: PaymentMode.bank, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP028', category: ExpenseCategory.feed, subCategory: 'Cattle Feed', amount: 11000, date: DateTime(2025, 10, 20), vendorName: 'Amul Feed Store', paymentMode: PaymentMode.upi, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP029', category: ExpenseCategory.labour, subCategory: 'Staff', amount: 27000, date: DateTime(2025, 10, 1), vendorName: 'Staff', paymentMode: PaymentMode.bank, farmerId: 'F001'),
  ExpenseRecord(id: 'EXP030', category: ExpenseCategory.veterinary, subCategory: 'Surgery', amount: 5000, date: DateTime(2025, 10, 5), vendorName: 'Dr. Anita Sharma', paymentMode: PaymentMode.upi, animalId: '9', notes: 'Minor hoof surgery', farmerId: 'F001'),
];

// Monthly summaries for charts (last 6 months)
final List<Map<String, dynamic>> monthlyExpenseSummary = [
  {'month': 'Sep 2025', 'amount': 52000.0},
  {'month': 'Oct 2025', 'amount': 58000.0},
  {'month': 'Nov 2025', 'amount': 43000.0},
  {'month': 'Dec 2025', 'amount': 40800.0},
  {'month': 'Jan 2026', 'amount': 81300.0},
  {'month': 'Feb 2026', 'amount': 65000.0},
];

final List<Map<String, dynamic>> monthlyIncomeSummary = [
  {'month': 'Sep 2025', 'amount': 85000.0},
  {'month': 'Oct 2025', 'amount': 92000.0},
  {'month': 'Nov 2025', 'amount': 88000.0},
  {'month': 'Dec 2025', 'amount': 78000.0},
  {'month': 'Jan 2026', 'amount': 95000.0},
  {'month': 'Feb 2026', 'amount': 82000.0},
];

double get totalExpensesThisMonth {
  final now = DateTime.now();
  return mockExpenses
      .where((e) => e.date.month == now.month && e.date.year == now.year)
      .fold(0.0, (sum, e) => sum + e.amount);
}

double get totalIncomeThisMonth => 82000.0;
