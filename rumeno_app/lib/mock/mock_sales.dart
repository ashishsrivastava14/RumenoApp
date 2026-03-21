import '../models/models.dart';

final List<SaleRecord> mockSales = [
  SaleRecord(
    id: 'SALE001',
    type: SaleType.animal,
    date: DateTime(2026, 3, 15),
    amount: 45000,
    paymentMode: PaymentMode.cash,
    buyerName: 'Ramesh Patel',
    buyerPhone: '9876543210',
    animalId: '1',
    animalTag: 'C-001',
    animalSpecies: 'Cow',
    notes: 'HF Cow - Good milking',
    farmerId: 'F001',
  ),
  SaleRecord(
    id: 'SALE002',
    type: SaleType.milk,
    date: DateTime(2026, 3, 18),
    amount: 3200,
    paymentMode: PaymentMode.upi,
    buyerName: 'Meena Dairy',
    buyerPhone: '9812345678',
    produceType: 'Milk',
    quantity: 160,
    unit: 'litre',
    notes: 'Weekly milk supply',
    farmerId: 'F001',
  ),
  SaleRecord(
    id: 'SALE003',
    type: SaleType.animal,
    date: DateTime(2026, 3, 10),
    amount: 18000,
    paymentMode: PaymentMode.bank,
    buyerName: 'Suresh Kumar',
    buyerPhone: '9988776655',
    animalId: '7',
    animalTag: 'G-002',
    animalSpecies: 'Goat',
    farmerId: 'F001',
  ),
  SaleRecord(
    id: 'SALE004',
    type: SaleType.produce,
    date: DateTime(2026, 3, 12),
    amount: 5500,
    paymentMode: PaymentMode.cash,
    buyerName: 'Local Market',
    produceType: 'Ghee',
    quantity: 5,
    unit: 'kg',
    farmerId: 'F001',
  ),
  SaleRecord(
    id: 'SALE005',
    type: SaleType.milk,
    date: DateTime(2026, 3, 20),
    amount: 2800,
    paymentMode: PaymentMode.upi,
    buyerName: 'Meena Dairy',
    buyerPhone: '9812345678',
    produceType: 'Milk',
    quantity: 140,
    unit: 'litre',
    farmerId: 'F001',
  ),
  SaleRecord(
    id: 'SALE006',
    type: SaleType.animal,
    date: DateTime(2026, 2, 28),
    amount: 35000,
    paymentMode: PaymentMode.cash,
    buyerName: 'Harish Dairy Farm',
    buyerPhone: '8765432109',
    animalId: '4',
    animalTag: 'B-001',
    animalSpecies: 'Buffalo',
    notes: 'High-yield buffalo',
    farmerId: 'F001',
  ),
  SaleRecord(
    id: 'SALE007',
    type: SaleType.produce,
    date: DateTime(2026, 2, 25),
    amount: 1200,
    paymentMode: PaymentMode.cash,
    buyerName: 'Neighbour',
    produceType: 'Manure',
    quantity: 200,
    unit: 'kg',
    farmerId: 'F001',
  ),
];

double get totalSalesThisMonth {
  final now = DateTime.now();
  return mockSales
      .where((s) => s.date.month == now.month && s.date.year == now.year)
      .fold(0.0, (sum, s) => sum + s.amount);
}

double get totalAnimalSalesThisMonth {
  final now = DateTime.now();
  return mockSales
      .where((s) =>
          s.type == SaleType.animal &&
          s.date.month == now.month &&
          s.date.year == now.year)
      .fold(0.0, (sum, s) => sum + s.amount);
}

double get totalMilkSalesThisMonth {
  final now = DateTime.now();
  return mockSales
      .where((s) =>
          s.type == SaleType.milk &&
          s.date.month == now.month &&
          s.date.year == now.year)
      .fold(0.0, (sum, s) => sum + s.amount);
}
