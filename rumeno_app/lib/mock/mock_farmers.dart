import '../models/models.dart';

final List<Farmer> mockFarmers = [
  Farmer(id: 'F001', name: 'John Smith', phone: '9876543210', farmName: 'Smith Dairy Farm', address: 'Village Vadgam, Taluka Palanpur', state: 'Gujarat', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 3, 15), animalCount: 20, isActive: true, vetId: 'V001', managerName: 'Steven Harris'),
  Farmer(id: 'F002', name: 'James Wilson', phone: '9876543212', farmName: 'Wilson Livestock', address: 'Village Khera, Ludhiana', state: 'Punjab', plan: SubscriptionPlan.business, joinedDate: DateTime(2024, 1, 10), animalCount: 85, isActive: true, vetId: 'V001'),
  Farmer(id: 'F003', name: 'Sarah Johnson', phone: '9876543213', farmName: 'Johnson Goat Farm', address: 'Village Bhopal, Sehore', state: 'Madhya Pradesh', plan: SubscriptionPlan.starter, joinedDate: DateTime(2024, 6, 20), animalCount: 30, isActive: true),
  Farmer(id: 'F004', name: 'Michael Brown', phone: '9876543214', farmName: 'Brown Cattle Farm', address: 'Latur District', state: 'Maharashtra', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 2, 5), animalCount: 45, isActive: true, vetId: 'V001'),
  Farmer(id: 'F005', name: 'Lisa Davis', phone: '9876543215', farmName: 'Davis Farm House', address: 'Belgaum District', state: 'Karnataka', plan: SubscriptionPlan.free, joinedDate: DateTime(2025, 1, 12), animalCount: 8, isActive: true),
  Farmer(id: 'F006', name: 'Victor Clark', phone: '9876543216', farmName: 'Clark Dairy', address: 'Jaipur Rural', state: 'Rajasthan', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 4, 18), animalCount: 52, isActive: true),
  Farmer(id: 'F007', name: 'Patricia Miller', phone: '9876543217', farmName: 'Miller Poultry & Dairy', address: 'Warangal District', state: 'Telangana', plan: SubscriptionPlan.starter, joinedDate: DateTime(2024, 8, 25), animalCount: 22, isActive: false),
  Farmer(id: 'F008', name: 'Robert Taylor', phone: '9876543218', farmName: 'Taylor Farms', address: 'Varanasi Rural', state: 'Uttar Pradesh', plan: SubscriptionPlan.business, joinedDate: DateTime(2023, 11, 1), animalCount: 120, isActive: true, managerName: 'Daniel Mitchell'),
  Farmer(id: 'F009', name: 'Andrew Anderson', phone: '9876543219', farmName: 'Anderson Organic Farm', address: 'Pune District', state: 'Maharashtra', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 5, 30), animalCount: 35, isActive: true, vetId: 'V001'),
  Farmer(id: 'F010', name: 'Katherine White', phone: '9876543220', farmName: 'White Cattle Ranch', address: 'Hisar District', state: 'Haryana', plan: SubscriptionPlan.starter, joinedDate: DateTime(2025, 2, 1), animalCount: 15, isActive: true),
];
