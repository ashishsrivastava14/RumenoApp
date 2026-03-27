import '../models/models.dart';

/// Mock user database keyed by phone number.
/// A single phone number can have multiple roles.
const mockUsersByPhone = <String, AppUser>{
  '9876543210': AppUser(
    id: 'U001',
    name: 'John Smith',
    phone: '9876543210',
    roles: [UserRole.farmer, UserRole.admin, UserRole.vet],
    farmName: 'Smith Dairy Farm',
  ),
  '9876543211': AppUser(
    id: 'U002',
    name: 'Dr. Emily Thompson',
    phone: '9876543211',
    roles: [UserRole.vet],
    specialization: 'Large Animal Medicine',
    licenseNumber: 'VET-MH-2019-0456',
    referralCode: 'DREMILY20',
  ),
  '9876543200': AppUser(
    id: 'U003',
    name: 'System Admin',
    phone: '9876543200',
    roles: [UserRole.admin],
  ),
};

// Legacy constants kept for backward-compat (single-role views)
const mockFarmerUser = AppUser(
  id: 'U001',
  name: 'John Smith',
  phone: '9876543210',
  roles: [UserRole.farmer, UserRole.admin],
  farmName: 'Smith Dairy Farm',
);

const mockVetUser = AppUser(
  id: 'U002',
  name: 'Dr. Emily Thompson',
  phone: '9876543211',
  roles: [UserRole.vet],
  specialization: 'Large Animal Medicine',
  licenseNumber: 'VET-MH-2019-0456',
  referralCode: 'DREMILY20',
);

const mockAdminUser = AppUser(
  id: 'U003',
  name: 'System Admin',
  phone: '9876543200',
  roles: [UserRole.admin],
);
