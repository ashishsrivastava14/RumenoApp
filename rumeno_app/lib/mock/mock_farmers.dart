import '../models/models.dart';

final List<Farmer> mockFarmers = [
  Farmer(id: 'F001', name: 'Rajesh Patel', phone: '9876543210', farmName: 'Patel Dairy Farm', address: 'Village Vadgam, Taluka Palanpur', state: 'Gujarat', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 3, 15), animalCount: 20, isActive: true, vetId: 'V001', managerName: 'Suresh Patel'),
  Farmer(id: 'F002', name: 'Amit Singh', phone: '9876543212', farmName: 'Singh Livestock', address: 'Village Khera, Ludhiana', state: 'Punjab', plan: SubscriptionPlan.business, joinedDate: DateTime(2024, 1, 10), animalCount: 85, isActive: true, vetId: 'V001'),
  Farmer(id: 'F003', name: 'Sunita Devi', phone: '9876543213', farmName: 'Devi Goat Farm', address: 'Village Bhopal, Sehore', state: 'Madhya Pradesh', plan: SubscriptionPlan.starter, joinedDate: DateTime(2024, 6, 20), animalCount: 30, isActive: true),
  Farmer(id: 'F004', name: 'Manoj Yadav', phone: '9876543214', farmName: 'Yadav Cattle Farm', address: 'Latur District', state: 'Maharashtra', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 2, 5), animalCount: 45, isActive: true, vetId: 'V001'),
  Farmer(id: 'F005', name: 'Lakshmi Naik', phone: '9876543215', farmName: 'Naik Farm House', address: 'Belgaum District', state: 'Karnataka', plan: SubscriptionPlan.free, joinedDate: DateTime(2025, 1, 12), animalCount: 8, isActive: true),
  Farmer(id: 'F006', name: 'Vikram Chaudhary', phone: '9876543216', farmName: 'Chaudhary Dairy', address: 'Jaipur Rural', state: 'Rajasthan', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 4, 18), animalCount: 52, isActive: true),
  Farmer(id: 'F007', name: 'Priya Reddy', phone: '9876543217', farmName: 'Reddy Poultry & Dairy', address: 'Warangal District', state: 'Telangana', plan: SubscriptionPlan.starter, joinedDate: DateTime(2024, 8, 25), animalCount: 22, isActive: false),
  Farmer(id: 'F008', name: 'Ramesh Gupta', phone: '9876543218', farmName: 'Gupta Farms', address: 'Varanasi Rural', state: 'Uttar Pradesh', plan: SubscriptionPlan.business, joinedDate: DateTime(2023, 11, 1), animalCount: 120, isActive: true, managerName: 'Deepak Gupta'),
  Farmer(id: 'F009', name: 'Anand Joshi', phone: '9876543219', farmName: 'Joshi Organic Farm', address: 'Pune District', state: 'Maharashtra', plan: SubscriptionPlan.pro, joinedDate: DateTime(2024, 5, 30), animalCount: 35, isActive: true, vetId: 'V001'),
  Farmer(id: 'F010', name: 'Kavita Sharma', phone: '9876543220', farmName: 'Sharma Cattle Ranch', address: 'Hisar District', state: 'Haryana', plan: SubscriptionPlan.starter, joinedDate: DateTime(2025, 2, 1), animalCount: 15, isActive: true),
];
