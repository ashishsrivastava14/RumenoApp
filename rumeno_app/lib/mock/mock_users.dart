import '../models/models.dart';

const mockFarmerUser = AppUser(
  id: 'F001',
  name: 'Rajesh Patel',
  phone: '9876543210',
  role: UserRole.farmer,
  farmName: 'Patel Dairy Farm',
);

const mockVetUser = AppUser(
  id: 'V001',
  name: 'Dr. Anita Sharma',
  phone: '9876543211',
  role: UserRole.vet,
  specialization: 'Large Animal Medicine',
  licenseNumber: 'VET-MH-2019-0456',
  referralCode: 'DRANITA20',
);

const mockAdminUser = AppUser(
  id: 'A001',
  name: 'System Admin',
  phone: '9876543200',
  role: UserRole.admin,
);

const mockFarmProductsUser = AppUser(
  id: 'FP001',
  name: 'Product Buyer',
  phone: '9876543212',
  role: UserRole.farmProducts,
);
