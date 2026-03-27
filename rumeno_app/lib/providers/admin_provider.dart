import 'package:flutter/material.dart';
import '../mock/mock_animals.dart';
import '../mock/mock_health.dart';
import '../mock/mock_milk.dart';
import '../mock/mock_kids.dart';
import '../mock/mock_finance.dart';
import '../mock/mock_sales.dart';
import '../models/models.dart';

// ─── Health Config Item Model ─────────────────────────────────────────────────
class HealthConfigItem {
  final String id;
  String name;
  String species;
  String info; // schedule for vaccines, severity for diseases, category for medicines
  final String type; // 'Vaccine', 'Disease', 'Medicine'

  HealthConfigItem({
    required this.id,
    required this.name,
    required this.species,
    required this.info,
    required this.type,
  });
}

// ─── Sanitization Protocol Config Models ──────────────────────────────────────
class SanitizationSanitizer {
  final String id;
  String name;
  String emoji;
  String dilution;
  String safety;
  bool isActive;

  SanitizationSanitizer({
    required this.id,
    required this.name,
    this.emoji = '🧴',
    this.dilution = '',
    this.safety = '',
    this.isActive = true,
  });
}

class SanitizationArea {
  final String id;
  String name;
  String emoji;
  String frequency;
  bool isActive;

  SanitizationArea({
    required this.id,
    required this.name,
    this.emoji = '🏠',
    this.frequency = '',
    this.isActive = true,
  });
}

class SanitizationProtocol {
  final String id;
  String name;
  String areaId;
  List<String> sanitizerIds;
  String frequency;
  String instructions;
  bool isActive;

  SanitizationProtocol({
    required this.id,
    required this.name,
    required this.areaId,
    this.sanitizerIds = const [],
    this.frequency = '',
    this.instructions = '',
    this.isActive = true,
  });
}

// ─── Vet Model ────────────────────────────────────────────────────────────────
enum VetStatus { active, pending, inactive }

class VetModel {
  final String id;
  String name;
  String specialization;
  String licenseNumber;
  VetStatus status;
  int consultations;
  double earnings;
  double rating;
  int commissionPercent;

  VetModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.licenseNumber,
    required this.status,
    this.consultations = 0,
    this.earnings = 0,
    this.rating = 0,
    this.commissionPercent = 80,
  });
}

// ─── Consultation Model ───────────────────────────────────────────────────────
enum ConsultStatus { completed, scheduled, pending }

class ConsultModel {
  final String id;
  final String vetName;
  final String farmName;
  final String type;
  final String date;
  ConsultStatus status;
  final int fee;

  ConsultModel({
    required this.id,
    required this.vetName,
    required this.farmName,
    required this.type,
    required this.date,
    required this.status,
    required this.fee,
  });
}

// ─── Partner Model ────────────────────────────────────────────────────────────
class PartnerModel {
  final String id;
  String name;
  String type; // 'Vet' or 'Partner'
  int referrals;
  double earned;
  bool isActive;
  String code;

  PartnerModel({
    required this.id,
    required this.name,
    required this.type,
    this.referrals = 0,
    this.earned = 0,
    this.isActive = true,
    required this.code,
  });
}

// ─── Notification Model ──────────────────────────────────────────────────────
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String audience;
  final DateTime sentAt;
  final int reach;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.audience,
    required this.sentAt,
    this.reach = 0,
  });
}

// ─── Subscription Plan Model ─────────────────────────────────────────────────
class SubscriptionPlan {
  final String id;
  String name;
  double price;
  String period;
  Color color;
  List<String> features;
  int userCount;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.color,
    required this.features,
    this.userCount = 0,
  });
}

// ─── Payment Model ───────────────────────────────────────────────────────────
class PaymentModel {
  final String id;
  final String userName;
  final String plan;
  final double amount;
  final DateTime date;
  final String status; // 'Success', 'Failed', 'Refunded'
  final String method;

  PaymentModel({
    required this.id,
    required this.userName,
    required this.plan,
    required this.amount,
    required this.date,
    required this.status,
    required this.method,
  });
}
// ─── Feed Formula Models ─────────────────────────────────────────────────
class FeedIngredient {
  final String id;
  String name;
  String emoji;
  double pricePerKg;
  double protein;
  double fiber;
  double energy;
  double carbohydrate;
  double fat;
  double moisture;
  double ash;
  bool isActive;

  FeedIngredient({
    required this.id,
    required this.name,
    this.emoji = '🌾',
    required this.pricePerKg,
    required this.protein,
    required this.fiber,
    required this.energy,
    required this.carbohydrate,
    required this.fat,
    required this.moisture,
    required this.ash,
    this.isActive = true,
  });
}

class FeedAnimalType {
  final String id;
  String name;
  String emoji;
  double bodyWeightKg;
  double dailyFeedKg;
  double greenFodderKg;
  double dryFodderKg;
  double concentrateKg;
  double targetProtein;
  double targetFiber;
  double targetEnergy;
  String tip;
  bool isActive;

  FeedAnimalType({
    required this.id,
    required this.name,
    this.emoji = '🐄',
    required this.bodyWeightKg,
    required this.dailyFeedKg,
    required this.greenFodderKg,
    required this.dryFodderKg,
    required this.concentrateKg,
    required this.targetProtein,
    required this.targetFiber,
    required this.targetEnergy,
    this.tip = '',
    this.isActive = true,
  });
}

// ─── FAQ / Content Model ─────────────────────────────────────────────────
class FaqItem {
  final String id;
  String question;
  String answer;
  String category; // 'General', 'Animals', 'Health', 'Finance', 'Shop', 'Subscription'
  int sortOrder;
  bool isPublished;
  final DateTime createdAt;
  DateTime updatedAt;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.sortOrder = 0,
    this.isPublished = true,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;
}
// ─── App Settings Model ──────────────────────────────────────────────────────
class AppSettings {
  bool maintenanceMode;
  bool allowNewSignups;
  bool emailNotifications;
  bool smsEnabled;
  String defaultLanguage;
  // AI Feed Mix limits per subscription plan
  int aiMixLimitFree;
  int aiMixLimitStarter;
  int aiMixLimitPro;
  int aiMixLimitBusiness;

  AppSettings({
    this.maintenanceMode = false,
    this.allowNewSignups = true,
    this.emailNotifications = true,
    this.smsEnabled = true,
    this.defaultLanguage = 'English',
    this.aiMixLimitFree = 3,
    this.aiMixLimitStarter = 10,
    this.aiMixLimitPro = 50,
    this.aiMixLimitBusiness = -1, // -1 = unlimited
  });

  int getAiMixLimit(String planName) {
    switch (planName.toLowerCase()) {
      case 'free': return aiMixLimitFree;
      case 'starter': return aiMixLimitStarter;
      case 'pro': return aiMixLimitPro;
      case 'business': return aiMixLimitBusiness;
      default: return aiMixLimitFree;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Admin Provider
// ═══════════════════════════════════════════════════════════════════════════════
class AdminProvider extends ChangeNotifier {
  // ─── Health Config ──────────────────────────────────────────────────────
  final List<HealthConfigItem> _vaccines = [];
  final List<HealthConfigItem> _diseases = [];
  final List<HealthConfigItem> _medicines = [];

  // ─── Vets ───────────────────────────────────────────────────────────────
  final List<VetModel> _vets = [];
  final List<ConsultModel> _consultations = [];

  // ─── Partners ───────────────────────────────────────────────────────────
  final List<PartnerModel> _partners = [];

  // ─── Notifications ──────────────────────────────────────────────────────
  final List<NotificationModel> _notifications = [];

  // ─── Subscription Plans ─────────────────────────────────────────────────
  final List<SubscriptionPlan> _plans = [];

  // ─── Payments ───────────────────────────────────────────────────────────
  final List<PaymentModel> _payments = [];

  // ─── Settings ───────────────────────────────────────────────────────────
  final AppSettings _settings = AppSettings();

  // ─── Sanitization Protocols ─────────────────────────────────────────────
  final List<SanitizationSanitizer> _sanitizers = [];
  final List<SanitizationArea> _sanitizationAreas = [];
  final List<SanitizationProtocol> _sanitizationProtocols = [];

  // ─── Feed Formula Config ────────────────────────────────────────────────
  final List<FeedIngredient> _feedIngredients = [];
  final List<FeedAnimalType> _feedAnimalTypes = [];

  // ─── FAQ / Content ──────────────────────────────────────────────────────
  final List<FaqItem> _faqItems = [];

  AdminProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    // Health Configs
    _vaccines.addAll([
      HealthConfigItem(id: 'V1', name: 'FMD Vaccine', species: 'All', info: 'Every 6 months', type: 'Vaccine'),
      HealthConfigItem(id: 'V2', name: 'HS Vaccine', species: 'Cattle, Buffalo', info: 'Annual', type: 'Vaccine'),
      HealthConfigItem(id: 'V3', name: 'BQ Vaccine', species: 'Cattle', info: 'Annual', type: 'Vaccine'),
      HealthConfigItem(id: 'V4', name: 'Brucella Vaccine', species: 'Cattle, Buffalo', info: 'Once (4-8 months age)', type: 'Vaccine'),
      HealthConfigItem(id: 'V5', name: 'PPR Vaccine', species: 'Goat, Sheep', info: 'Annual', type: 'Vaccine'),
      HealthConfigItem(id: 'V6', name: 'Goat Pox Vaccine', species: 'Goat', info: 'Annual', type: 'Vaccine'),
      HealthConfigItem(id: 'V7', name: 'Enterotoxaemia Vaccine', species: 'Goat, Sheep', info: 'Every 6 months', type: 'Vaccine'),
      HealthConfigItem(id: 'V8', name: 'Swine Fever Vaccine', species: 'Pig', info: 'Annual', type: 'Vaccine'),
    ]);

    _diseases.addAll([
      HealthConfigItem(id: 'D1', name: 'Mastitis', species: 'Cattle, Buffalo', info: 'Common', type: 'Disease'),
      HealthConfigItem(id: 'D2', name: 'Foot & Mouth Disease', species: 'All ruminants', info: 'Notifiable', type: 'Disease'),
      HealthConfigItem(id: 'D3', name: 'Brucellosis', species: 'Cattle, Buffalo', info: 'Zoonotic', type: 'Disease'),
      HealthConfigItem(id: 'D4', name: 'Bovine Tuberculosis', species: 'Cattle', info: 'Zoonotic', type: 'Disease'),
      HealthConfigItem(id: 'D5', name: 'Tick Fever', species: 'Cattle', info: 'Seasonal', type: 'Disease'),
      HealthConfigItem(id: 'D6', name: 'Bloat', species: 'All ruminants', info: 'Emergency', type: 'Disease'),
    ]);

    _medicines.addAll([
      HealthConfigItem(id: 'M1', name: 'Ivermectin', species: 'All', info: 'Dewormer', type: 'Medicine'),
      HealthConfigItem(id: 'M2', name: 'Oxytetracycline', species: 'All', info: 'Antibiotic', type: 'Medicine'),
      HealthConfigItem(id: 'M3', name: 'Meloxicam', species: 'Cattle, Buffalo', info: 'Anti-inflammatory', type: 'Medicine'),
      HealthConfigItem(id: 'M4', name: 'Calcium Borogluconate', species: 'Cattle', info: 'Supplement', type: 'Medicine'),
      HealthConfigItem(id: 'M5', name: 'Albendazole', species: 'All', info: 'Dewormer', type: 'Medicine'),
      HealthConfigItem(id: 'M6', name: 'Enrofloxacin', species: 'All', info: 'Antibiotic', type: 'Medicine'),
    ]);

    // Vets
    _vets.addAll([
      VetModel(id: 'V001', name: 'Dr. Emily Thompson', specialization: 'Large Animal Medicine', licenseNumber: 'VET-MH-2019-0456', status: VetStatus.active, consultations: 28, earnings: 12400, rating: 4.9),
      VetModel(id: 'V002', name: 'Dr. Rajesh Kumar', specialization: 'Bovine & Caprine', licenseNumber: 'VET-UP-2018-0231', status: VetStatus.active, consultations: 34, earnings: 15600, rating: 4.7),
      VetModel(id: 'V003', name: 'Dr. Priya Sharma', specialization: 'Small Ruminants', licenseNumber: 'VET-MP-2020-0589', status: VetStatus.active, consultations: 22, earnings: 9800, rating: 4.8),
      VetModel(id: 'V004', name: 'Dr. Anil Verma', specialization: 'Equine Medicine', licenseNumber: 'VET-HR-2017-0123', status: VetStatus.inactive, consultations: 0, earnings: 3200, rating: 4.5),
      VetModel(id: 'V005', name: 'Dr. Meena Patel', specialization: 'Poultry & Swine', licenseNumber: 'VET-GJ-2021-0044', status: VetStatus.pending, consultations: 0, earnings: 0, rating: 0),
      VetModel(id: 'V006', name: 'Dr. Suresh Nair', specialization: 'Large Animal Surgery', licenseNumber: 'VET-KL-2016-0678', status: VetStatus.active, consultations: 41, earnings: 18200, rating: 4.6),
    ]);

    // Consultations
    _consultations.addAll([
      ConsultModel(id: 'C001', vetName: 'Dr. Emily Thompson', farmName: 'Ramesh Patel Farm', type: 'Vaccination - FMD', date: '18 Mar 2026', status: ConsultStatus.completed, fee: 800),
      ConsultModel(id: 'C002', vetName: 'Dr. Rajesh Kumar', farmName: 'Singh Dairy', type: 'Treatment - Mastitis', date: '19 Mar 2026', status: ConsultStatus.completed, fee: 1200),
      ConsultModel(id: 'C003', vetName: 'Dr. Priya Sharma', farmName: 'Green Pastures Farm', type: 'Deworming Check', date: '20 Mar 2026', status: ConsultStatus.scheduled, fee: 600),
      ConsultModel(id: 'C004', vetName: 'Dr. Emily Thompson', farmName: 'Sharma Buffalo Farm', type: 'Pregnancy Check', date: '20 Mar 2026', status: ConsultStatus.scheduled, fee: 900),
      ConsultModel(id: 'C005', vetName: 'Dr. Suresh Nair', farmName: 'Jain Cattle Co.', type: 'Emergency - Bloat', date: '17 Mar 2026', status: ConsultStatus.completed, fee: 2500),
      ConsultModel(id: 'C006', vetName: 'Dr. Rajesh Kumar', farmName: 'Kapoor Dairy', type: 'Annual Health Checkup', date: '21 Mar 2026', status: ConsultStatus.pending, fee: 1000),
    ]);

    // Partners
    _partners.addAll([
      PartnerModel(id: 'P1', name: 'Dr. Emily Thompson', type: 'Vet', referrals: 10, earned: 68400, isActive: true, code: 'VET-EMILY-2024'),
      PartnerModel(id: 'P2', name: 'Dr. Ryan Cooper', type: 'Vet', referrals: 8, earned: 52200, isActive: true, code: 'VET-RYAN-2024'),
      PartnerModel(id: 'P3', name: 'Pashudhan NGO', type: 'Partner', referrals: 25, earned: 120000, isActive: true, code: 'PTR-PASHU-2024'),
      PartnerModel(id: 'P4', name: 'Dr. Michelle Stone', type: 'Vet', referrals: 5, earned: 28500, isActive: true, code: 'VET-MICHELLE-2024'),
      PartnerModel(id: 'P5', name: 'KrishiMitra', type: 'Partner', referrals: 15, earned: 75000, isActive: false, code: 'PTR-KRISHI-2024'),
    ]);

    // Notifications
    _notifications.addAll([
      NotificationModel(id: 'N1', title: 'FMD Vaccination Drive', body: 'Govt. FMD vaccination camp on 20 Jul...', audience: 'All Farmers', sentAt: DateTime(2025, 7, 14), reach: 248),
      NotificationModel(id: 'N2', title: 'New Pro Features!', body: 'Breeding management now available...', audience: 'Pro & Business', sentAt: DateTime(2025, 7, 10), reach: 68),
      NotificationModel(id: 'N3', title: 'Vet Payout Processed', body: 'June payouts have been credited...', audience: 'All Vets', sentAt: DateTime(2025, 7, 1), reach: 18),
      NotificationModel(id: 'N4', title: 'App Update v2.1', body: 'Bug fixes and performance improvements', audience: 'All Users', sentAt: DateTime(2025, 6, 28), reach: 266),
    ]);

    // Subscription Plans
    _plans.addAll([
      SubscriptionPlan(id: 'S1', name: 'Free', price: 0, period: 'forever', color: const Color(0xFF90A4AE), features: ['5 animals', 'Basic records', 'Community support'], userCount: 98),
      SubscriptionPlan(id: 'S2', name: 'Starter', price: 499, period: '/month', color: const Color(0xFF42A5F5), features: ['25 animals', 'Health + Finance', 'SMS reminders', '3 vet consults/mo'], userCount: 82),
      SubscriptionPlan(id: 'S3', name: 'Pro', price: 999, period: '/month', color: const Color(0xFFAB47BC), features: ['100 animals', 'Analytics', 'Breeding mgmt', 'Unlimited consults', 'Export reports'], userCount: 45),
      SubscriptionPlan(id: 'S4', name: 'Business', price: 2499, period: '/month', color: const Color(0xFFFF7043), features: ['Unlimited animals', 'Multi-farm', 'Team management', 'Priority support', 'API access'], userCount: 23),
    ]);

    // Payments
    _payments.addAll([
      PaymentModel(id: 'PAY1', userName: 'John Smith', plan: 'Pro', amount: 999, date: DateTime(2025, 7, 15), status: 'Success', method: 'UPI'),
      PaymentModel(id: 'PAY2', userName: 'Victor Clark', plan: 'Starter', amount: 499, date: DateTime(2025, 7, 14), status: 'Success', method: 'Card'),
      PaymentModel(id: 'PAY3', userName: 'James Wilson', plan: 'Business', amount: 2499, date: DateTime(2025, 7, 13), status: 'Success', method: 'UPI'),
      PaymentModel(id: 'PAY4', userName: 'Patricia Miller', plan: 'Starter', amount: 499, date: DateTime(2025, 7, 12), status: 'Failed', method: 'Net Banking'),
      PaymentModel(id: 'PAY5', userName: 'Lisa Davis', plan: 'Pro', amount: 999, date: DateTime(2025, 7, 11), status: 'Success', method: 'UPI'),
      PaymentModel(id: 'PAY6', userName: 'Robert Taylor', plan: 'Starter', amount: 499, date: DateTime(2025, 7, 10), status: 'Refunded', method: 'Card'),
      PaymentModel(id: 'PAY7', userName: 'Brian Roberts', plan: 'Pro', amount: 999, date: DateTime(2025, 7, 9), status: 'Success', method: 'UPI'),
    ]);

    // Sanitization Sanitizers
    _sanitizers.addAll([
      SanitizationSanitizer(id: 'SAN1', name: 'Bleach (Sodium Hypochlorite)', emoji: '🧴', dilution: '1:10 with water', safety: 'Wear gloves, avoid eyes'),
      SanitizationSanitizer(id: 'SAN2', name: 'Phenyl', emoji: '🫧', dilution: '1:20 with water', safety: 'Keep away from feed'),
      SanitizationSanitizer(id: 'SAN3', name: 'Iodine Solution', emoji: '🩸', dilution: '1:100 with water', safety: 'Stains surfaces'),
      SanitizationSanitizer(id: 'SAN4', name: 'Quicklime (Chuna)', emoji: '🪨', dilution: 'Sprinkle dry', safety: 'Avoid inhalation, use mask'),
      SanitizationSanitizer(id: 'SAN5', name: 'Formalin', emoji: '🧪', dilution: '2-5% solution', safety: 'Toxic — ventilate area, PPE required'),
      SanitizationSanitizer(id: 'SAN6', name: 'Potassium Permanganate', emoji: '🟣', dilution: '1:1000 with water', safety: 'Stains skin, use gloves'),
      SanitizationSanitizer(id: 'SAN7', name: 'Hydrogen Peroxide', emoji: '🫙', dilution: '3% solution', safety: 'Keep away from heat'),
    ]);

    // Sanitization Areas
    _sanitizationAreas.addAll([
      SanitizationArea(id: 'AR1', name: 'Full Farm', emoji: '🏠', frequency: 'Monthly'),
      SanitizationArea(id: 'AR2', name: 'Cow Shed', emoji: '🐄', frequency: 'Every 2 weeks'),
      SanitizationArea(id: 'AR3', name: 'Goat Pen', emoji: '🐐', frequency: 'Every 2 weeks'),
      SanitizationArea(id: 'AR4', name: 'Pig Pen', emoji: '🐷', frequency: 'Weekly'),
      SanitizationArea(id: 'AR5', name: 'Water Tank', emoji: '🛢️', frequency: 'Monthly'),
      SanitizationArea(id: 'AR6', name: 'Feed Storage', emoji: '🌾', frequency: 'Monthly'),
      SanitizationArea(id: 'AR7', name: 'Entry Gate', emoji: '🚪', frequency: 'Weekly'),
    ]);

    // Sanitization Protocols
    _sanitizationProtocols.addAll([
      SanitizationProtocol(id: 'SP1', name: 'Weekly Gate Disinfection', areaId: 'AR7', sanitizerIds: ['SAN1', 'SAN4'], frequency: 'Weekly', instructions: 'Spray bleach at entry, sprinkle lime on footbath area'),
      SanitizationProtocol(id: 'SP2', name: 'Cow Shed Deep Clean', areaId: 'AR2', sanitizerIds: ['SAN1', 'SAN2'], frequency: 'Every 2 weeks', instructions: 'Remove all bedding, wash floors with phenyl, disinfect troughs with bleach'),
      SanitizationProtocol(id: 'SP3', name: 'Water Tank Flush', areaId: 'AR5', sanitizerIds: ['SAN6'], frequency: 'Monthly', instructions: 'Drain tank, scrub walls, add KMnO4 solution, rinse after 30 min'),
    ]);

    // Feed Ingredients
    _feedIngredients.addAll([
      FeedIngredient(id: 'FI1', name: 'Maize', emoji: '🌽', pricePerKg: 27, protein: 8.5, fiber: 2.2, energy: 80, carbohydrate: 72, fat: 4.0, moisture: 12, ash: 1.5),
      FeedIngredient(id: 'FI2', name: 'Soybean Meal', emoji: '🫘', pricePerKg: 52, protein: 44, fiber: 7, energy: 70, carbohydrate: 30, fat: 1.5, moisture: 11, ash: 6.5),
      FeedIngredient(id: 'FI3', name: 'Wheat Bran', emoji: '🌾', pricePerKg: 24, protein: 16, fiber: 11, energy: 60, carbohydrate: 55, fat: 4.5, moisture: 12, ash: 6.0),
      FeedIngredient(id: 'FI4', name: 'Cottonseed Cake', emoji: '🧶', pricePerKg: 36, protein: 24, fiber: 16, energy: 58, carbohydrate: 30, fat: 5.0, moisture: 10, ash: 6.5),
      FeedIngredient(id: 'FI5', name: 'Green Fodder', emoji: '🌿', pricePerKg: 8, protein: 10, fiber: 28, energy: 48, carbohydrate: 40, fat: 2.5, moisture: 75, ash: 10),
      FeedIngredient(id: 'FI6', name: 'Dry Hay', emoji: '🟫', pricePerKg: 12, protein: 6, fiber: 32, energy: 42, carbohydrate: 45, fat: 2.0, moisture: 12, ash: 8),
      FeedIngredient(id: 'FI7', name: 'Mustard Cake', emoji: '🟡', pricePerKg: 32, protein: 34, fiber: 12, energy: 62, carbohydrate: 28, fat: 8.0, moisture: 10, ash: 9),
      FeedIngredient(id: 'FI8', name: 'Mineral Mix', emoji: '🧂', pricePerKg: 85, protein: 0, fiber: 0, energy: 0, carbohydrate: 0, fat: 0, moisture: 5, ash: 90),
    ]);

    // Feed Animal Types
    _feedAnimalTypes.addAll([
      FeedAnimalType(id: 'FA1', name: 'Dairy Cow', emoji: '🐄', bodyWeightKg: 400, dailyFeedKg: 25, greenFodderKg: 15, dryFodderKg: 5, concentrateKg: 5, targetProtein: 16, targetFiber: 18, targetEnergy: 65, tip: 'Give 1 kg extra concentrate for every 2.5 litres of milk above 5 litres.'),
      FeedAnimalType(id: 'FA2', name: 'Buffalo', emoji: '🐃', bodyWeightKg: 500, dailyFeedKg: 30, greenFodderKg: 20, dryFodderKg: 5, concentrateKg: 5, targetProtein: 14, targetFiber: 20, targetEnergy: 60, tip: 'Buffalo needs more green fodder for fat-rich milk production.'),
      FeedAnimalType(id: 'FA3', name: 'Goat', emoji: '🐐', bodyWeightKg: 40, dailyFeedKg: 4, greenFodderKg: 2, dryFodderKg: 1, concentrateKg: 1, targetProtein: 14, targetFiber: 22, targetEnergy: 55, tip: 'Goats prefer browsing – add leaves & shrubs when possible.'),
      FeedAnimalType(id: 'FA4', name: 'Sheep', emoji: '🐑', bodyWeightKg: 45, dailyFeedKg: 4.5, greenFodderKg: 2.5, dryFodderKg: 1, concentrateKg: 1, targetProtein: 12, targetFiber: 24, targetEnergy: 52, tip: 'Sheep do well on good quality hay and pasture grazing.'),
      FeedAnimalType(id: 'FA5', name: 'Horse', emoji: '🐴', bodyWeightKg: 450, dailyFeedKg: 12, greenFodderKg: 5, dryFodderKg: 5, concentrateKg: 2, targetProtein: 10, targetFiber: 28, targetEnergy: 55, tip: 'Horses need high-fiber diet. Feed little and often.'),
      FeedAnimalType(id: 'FA6', name: 'Pig', emoji: '🐷', bodyWeightKg: 90, dailyFeedKg: 3, greenFodderKg: 0.5, dryFodderKg: 0, concentrateKg: 2.5, targetProtein: 16, targetFiber: 8, targetEnergy: 72, tip: 'Pigs grow well on grain-based concentrate with kitchen waste supplement.'),
    ]);

    // FAQ Items
    _faqItems.addAll([
      FaqItem(id: 'FAQ1', question: 'How do I add a new animal?', answer: 'Go to the Animals tab, tap the + button, fill in the details and tap Save.', category: 'Animals', sortOrder: 1, createdAt: DateTime(2025, 6, 1)),
      FaqItem(id: 'FAQ2', question: 'How does the feed calculator work?', answer: 'Select your animal type, choose feed ingredients and quantities. The calculator shows nutritional analysis and cost breakdown. AI Mix suggests optimal combinations.', category: 'Finance', sortOrder: 2, createdAt: DateTime(2025, 6, 1)),
      FaqItem(id: 'FAQ3', question: 'How do I book a vet consultation?', answer: 'Go to Health > Vet Consult, choose a vet, select a time slot and confirm booking. Payment is processed after the consultation.', category: 'Health', sortOrder: 3, createdAt: DateTime(2025, 6, 5)),
      FaqItem(id: 'FAQ4', question: 'What subscription plans are available?', answer: 'We offer Free, Starter (₹499/mo), Pro (₹999/mo), and Business (₹2499/mo) plans. Each tier unlocks more animals, features, and vet consults.', category: 'Subscription', sortOrder: 4, createdAt: DateTime(2025, 6, 5)),
      FaqItem(id: 'FAQ5', question: 'How do I track milk production?', answer: 'Go to Milk Log from the dashboard. Tap + to record daily morning/evening yields per animal. View trends in the analytics section.', category: 'Animals', sortOrder: 5, createdAt: DateTime(2025, 6, 10)),
      FaqItem(id: 'FAQ6', question: 'How do I place a shop order?', answer: 'Browse products in the Shop tab, add items to cart, proceed to checkout, select delivery address and payment method.', category: 'Shop', sortOrder: 6, createdAt: DateTime(2025, 6, 10)),
      FaqItem(id: 'FAQ7', question: 'What is the vaccination schedule?', answer: 'Go to Health > Vaccinations for your animal\u2019s schedule. Upcoming vaccines are shown on the dashboard. We send reminders before due dates.', category: 'Health', sortOrder: 7, createdAt: DateTime(2025, 6, 15)),
      FaqItem(id: 'FAQ8', question: 'How do I export my farm data?', answer: 'Go to More > Data Export. Choose what data to include (animals, health, finance) and tap Export. A CSV/PDF file will be generated.', category: 'General', sortOrder: 8, createdAt: DateTime(2025, 6, 15)),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Health Config Getters & Methods
  // ═══════════════════════════════════════════════════════════════════════════
  List<HealthConfigItem> get vaccines => List.unmodifiable(_vaccines);
  List<HealthConfigItem> get diseases => List.unmodifiable(_diseases);
  List<HealthConfigItem> get medicines => List.unmodifiable(_medicines);

  List<HealthConfigItem> getConfigListByType(String type) {
    switch (type) {
      case 'Vaccine': return _vaccines;
      case 'Disease': return _diseases;
      case 'Medicine': return _medicines;
      default: return [];
    }
  }

  void addHealthConfig(HealthConfigItem item) {
    switch (item.type) {
      case 'Vaccine': _vaccines.add(item); break;
      case 'Disease': _diseases.add(item); break;
      case 'Medicine': _medicines.add(item); break;
    }
    notifyListeners();
  }

  void updateHealthConfig(String id, String type, {String? name, String? species, String? info}) {
    final list = getConfigListByType(type);
    final idx = list.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    if (name != null) list[idx].name = name;
    if (species != null) list[idx].species = species;
    if (info != null) list[idx].info = info;
    notifyListeners();
  }

  void deleteHealthConfig(String id, String type) {
    switch (type) {
      case 'Vaccine': _vaccines.removeWhere((i) => i.id == id); break;
      case 'Disease': _diseases.removeWhere((i) => i.id == id); break;
      case 'Medicine': _medicines.removeWhere((i) => i.id == id); break;
    }
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Vet Management
  // ═══════════════════════════════════════════════════════════════════════════
  List<VetModel> get vets => List.unmodifiable(_vets);
  List<ConsultModel> get consultations => List.unmodifiable(_consultations);

  int get activeVetsCount => _vets.where((v) => v.status == VetStatus.active).length;
  int get pendingVetsCount => _vets.where((v) => v.status == VetStatus.pending).length;
  double get totalVetEarnings => _vets.fold(0, (s, v) => s + v.earnings);

  void addVet(VetModel vet) {
    _vets.add(vet);
    notifyListeners();
  }

  void approveVet(String id) {
    final idx = _vets.indexWhere((v) => v.id == id);
    if (idx == -1) return;
    _vets[idx].status = VetStatus.active;
    notifyListeners();
  }

  void toggleVetStatus(String id) {
    final idx = _vets.indexWhere((v) => v.id == id);
    if (idx == -1) return;
    _vets[idx].status = _vets[idx].status == VetStatus.active ? VetStatus.inactive : VetStatus.active;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Partners Management
  // ═══════════════════════════════════════════════════════════════════════════
  List<PartnerModel> get partners => List.unmodifiable(_partners);

  void addPartner(PartnerModel partner) {
    _partners.add(partner);
    notifyListeners();
  }

  void togglePartnerStatus(String id) {
    final idx = _partners.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    _partners[idx].isActive = !_partners[idx].isActive;
    notifyListeners();
  }

  void removePartner(String id) {
    _partners.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Notifications
  // ═══════════════════════════════════════════════════════════════════════════
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int _estimateReach(String audience) {
    final totalFarmers = _plans.fold<int>(0, (s, p) => s + p.userCount);
    final totalVets = activeVetsCount;
    switch (audience) {
      case 'All Users': return totalFarmers + totalVets;
      case 'All Farmers': return totalFarmers;
      case 'All Vets': return totalVets;
      case 'Free Plan': return _plans.firstWhere((p) => p.name == 'Free').userCount;
      case 'Starter Plan': return _plans.firstWhere((p) => p.name == 'Starter').userCount;
      case 'Pro & Business':
        return _plans.where((p) => p.name == 'Pro' || p.name == 'Business').fold<int>(0, (s, p) => s + p.userCount);
      default: return 0;
    }
  }

  void sendNotification({required String title, required String body, required String audience}) {
    final reach = _estimateReach(audience);
    _notifications.insert(0, NotificationModel(
      id: 'N${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      audience: audience,
      sentAt: DateTime.now(),
      reach: reach,
    ));
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Subscription Plans
  // ═══════════════════════════════════════════════════════════════════════════
  List<SubscriptionPlan> get plans => List.unmodifiable(_plans);

  int get totalUsers => _plans.fold<int>(0, (s, p) => s + p.userCount);

  void updatePlan(String id, {String? name, double? price, String? period, List<String>? features}) {
    final idx = _plans.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    if (name != null) _plans[idx].name = name;
    if (price != null) _plans[idx].price = price;
    if (period != null) _plans[idx].period = period;
    if (features != null) _plans[idx].features = features;
    notifyListeners();
  }

  void addPlan(SubscriptionPlan plan) {
    _plans.add(plan);
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Payments
  // ═══════════════════════════════════════════════════════════════════════════
  List<PaymentModel> get payments => List.unmodifiable(_payments);

  double get totalRevenue => _payments
      .where((p) => p.status == 'Success')
      .fold(0, (s, p) => s + p.amount);

  double get monthlyRevenue {
    final now = DateTime.now();
    return _payments
        .where((p) => p.status == 'Success' && p.date.month == now.month && p.date.year == now.year)
        .fold(0, (s, p) => s + p.amount);
  }

  int get failedPayments => _payments.where((p) => p.status == 'Failed').length;
  int get refundedPayments => _payments.where((p) => p.status == 'Refunded').length;

  // ═══════════════════════════════════════════════════════════════════════════
  // App Settings
  // ═══════════════════════════════════════════════════════════════════════════
  AppSettings get settings => _settings;

  void updateSettings({
    bool? maintenanceMode,
    bool? allowNewSignups,
    bool? emailNotifications,
    bool? smsEnabled,
    String? defaultLanguage,
    int? aiMixLimitFree,
    int? aiMixLimitStarter,
    int? aiMixLimitPro,
    int? aiMixLimitBusiness,
  }) {
    if (maintenanceMode != null) _settings.maintenanceMode = maintenanceMode;
    if (allowNewSignups != null) _settings.allowNewSignups = allowNewSignups;
    if (emailNotifications != null) _settings.emailNotifications = emailNotifications;
    if (smsEnabled != null) _settings.smsEnabled = smsEnabled;
    if (defaultLanguage != null) _settings.defaultLanguage = defaultLanguage;
    if (aiMixLimitFree != null) _settings.aiMixLimitFree = aiMixLimitFree;
    if (aiMixLimitStarter != null) _settings.aiMixLimitStarter = aiMixLimitStarter;
    if (aiMixLimitPro != null) _settings.aiMixLimitPro = aiMixLimitPro;
    if (aiMixLimitBusiness != null) _settings.aiMixLimitBusiness = aiMixLimitBusiness;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Sanitization Protocols Config
  // ═══════════════════════════════════════════════════════════════════════════
  List<SanitizationSanitizer> get sanitizers => List.unmodifiable(_sanitizers);
  List<SanitizationArea> get sanitizationAreas => List.unmodifiable(_sanitizationAreas);
  List<SanitizationProtocol> get sanitizationProtocols => List.unmodifiable(_sanitizationProtocols);

  // Sanitizers
  void addSanitizer(SanitizationSanitizer s) { _sanitizers.add(s); notifyListeners(); }
  void updateSanitizer(String id, {String? name, String? emoji, String? dilution, String? safety, bool? isActive}) {
    final idx = _sanitizers.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    if (name != null) _sanitizers[idx].name = name;
    if (emoji != null) _sanitizers[idx].emoji = emoji;
    if (dilution != null) _sanitizers[idx].dilution = dilution;
    if (safety != null) _sanitizers[idx].safety = safety;
    if (isActive != null) _sanitizers[idx].isActive = isActive;
    notifyListeners();
  }
  void deleteSanitizer(String id) { _sanitizers.removeWhere((s) => s.id == id); notifyListeners(); }

  // Areas
  void addSanitizationArea(SanitizationArea a) { _sanitizationAreas.add(a); notifyListeners(); }
  void updateSanitizationArea(String id, {String? name, String? emoji, String? frequency, bool? isActive}) {
    final idx = _sanitizationAreas.indexWhere((a) => a.id == id);
    if (idx == -1) return;
    if (name != null) _sanitizationAreas[idx].name = name;
    if (emoji != null) _sanitizationAreas[idx].emoji = emoji;
    if (frequency != null) _sanitizationAreas[idx].frequency = frequency;
    if (isActive != null) _sanitizationAreas[idx].isActive = isActive;
    notifyListeners();
  }
  void deleteSanitizationArea(String id) { _sanitizationAreas.removeWhere((a) => a.id == id); notifyListeners(); }

  // Protocols
  void addSanitizationProtocol(SanitizationProtocol p) { _sanitizationProtocols.add(p); notifyListeners(); }
  void updateSanitizationProtocol(String id, {String? name, String? areaId, List<String>? sanitizerIds, String? frequency, String? instructions, bool? isActive}) {
    final idx = _sanitizationProtocols.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    if (name != null) _sanitizationProtocols[idx].name = name;
    if (areaId != null) _sanitizationProtocols[idx].areaId = areaId;
    if (sanitizerIds != null) _sanitizationProtocols[idx].sanitizerIds = sanitizerIds;
    if (frequency != null) _sanitizationProtocols[idx].frequency = frequency;
    if (instructions != null) _sanitizationProtocols[idx].instructions = instructions;
    if (isActive != null) _sanitizationProtocols[idx].isActive = isActive;
    notifyListeners();
  }
  void deleteSanitizationProtocol(String id) { _sanitizationProtocols.removeWhere((p) => p.id == id); notifyListeners(); }

  String sanitizerNameById(String id) => _sanitizers.where((s) => s.id == id).firstOrNull?.name ?? id;
  String areaNameById(String id) => _sanitizationAreas.where((a) => a.id == id).firstOrNull?.name ?? id;

  // ═══════════════════════════════════════════════════════════════════════════
  // Feed Formula Config
  // ═══════════════════════════════════════════════════════════════════════════
  List<FeedIngredient> get feedIngredients => List.unmodifiable(_feedIngredients);
  List<FeedAnimalType> get feedAnimalTypes => List.unmodifiable(_feedAnimalTypes);

  int get activeFeedIngredients => _feedIngredients.where((i) => i.isActive).length;
  int get activeFeedAnimalTypes => _feedAnimalTypes.where((a) => a.isActive).length;

  // Ingredients
  void addFeedIngredient(FeedIngredient item) { _feedIngredients.add(item); notifyListeners(); }
  void updateFeedIngredient(String id, {String? name, String? emoji, double? pricePerKg, double? protein, double? fiber, double? energy, double? carbohydrate, double? fat, double? moisture, double? ash, bool? isActive}) {
    final idx = _feedIngredients.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    if (name != null) _feedIngredients[idx].name = name;
    if (emoji != null) _feedIngredients[idx].emoji = emoji;
    if (pricePerKg != null) _feedIngredients[idx].pricePerKg = pricePerKg;
    if (protein != null) _feedIngredients[idx].protein = protein;
    if (fiber != null) _feedIngredients[idx].fiber = fiber;
    if (energy != null) _feedIngredients[idx].energy = energy;
    if (carbohydrate != null) _feedIngredients[idx].carbohydrate = carbohydrate;
    if (fat != null) _feedIngredients[idx].fat = fat;
    if (moisture != null) _feedIngredients[idx].moisture = moisture;
    if (ash != null) _feedIngredients[idx].ash = ash;
    if (isActive != null) _feedIngredients[idx].isActive = isActive;
    notifyListeners();
  }
  void deleteFeedIngredient(String id) { _feedIngredients.removeWhere((i) => i.id == id); notifyListeners(); }

  // Animal Types
  void addFeedAnimalType(FeedAnimalType item) { _feedAnimalTypes.add(item); notifyListeners(); }
  void updateFeedAnimalType(String id, {String? name, String? emoji, double? bodyWeightKg, double? dailyFeedKg, double? greenFodderKg, double? dryFodderKg, double? concentrateKg, double? targetProtein, double? targetFiber, double? targetEnergy, String? tip, bool? isActive}) {
    final idx = _feedAnimalTypes.indexWhere((a) => a.id == id);
    if (idx == -1) return;
    if (name != null) _feedAnimalTypes[idx].name = name;
    if (emoji != null) _feedAnimalTypes[idx].emoji = emoji;
    if (bodyWeightKg != null) _feedAnimalTypes[idx].bodyWeightKg = bodyWeightKg;
    if (dailyFeedKg != null) _feedAnimalTypes[idx].dailyFeedKg = dailyFeedKg;
    if (greenFodderKg != null) _feedAnimalTypes[idx].greenFodderKg = greenFodderKg;
    if (dryFodderKg != null) _feedAnimalTypes[idx].dryFodderKg = dryFodderKg;
    if (concentrateKg != null) _feedAnimalTypes[idx].concentrateKg = concentrateKg;
    if (targetProtein != null) _feedAnimalTypes[idx].targetProtein = targetProtein;
    if (targetFiber != null) _feedAnimalTypes[idx].targetFiber = targetFiber;
    if (targetEnergy != null) _feedAnimalTypes[idx].targetEnergy = targetEnergy;
    if (tip != null) _feedAnimalTypes[idx].tip = tip;
    if (isActive != null) _feedAnimalTypes[idx].isActive = isActive;
    notifyListeners();
  }
  void deleteFeedAnimalType(String id) { _feedAnimalTypes.removeWhere((a) => a.id == id); notifyListeners(); }

  // ═══════════════════════════════════════════════════════════════════════════
  // FAQ / Content Management
  // ═══════════════════════════════════════════════════════════════════════════
  List<FaqItem> get faqItems => List.unmodifiable(_faqItems);

  List<String> get faqCategories => _faqItems.map((f) => f.category).toSet().toList()..sort();
  int get publishedFaqCount => _faqItems.where((f) => f.isPublished).length;

  void addFaq(FaqItem item) { _faqItems.add(item); notifyListeners(); }
  void updateFaq(String id, {String? question, String? answer, String? category, int? sortOrder, bool? isPublished}) {
    final idx = _faqItems.indexWhere((f) => f.id == id);
    if (idx == -1) return;
    if (question != null) _faqItems[idx].question = question;
    if (answer != null) _faqItems[idx].answer = answer;
    if (category != null) _faqItems[idx].category = category;
    if (sortOrder != null) _faqItems[idx].sortOrder = sortOrder;
    if (isPublished != null) _faqItems[idx].isPublished = isPublished;
    _faqItems[idx].updatedAt = DateTime.now();
    notifyListeners();
  }
  void deleteFaq(String id) { _faqItems.removeWhere((f) => f.id == id); notifyListeners(); }

  // ═══════════════════════════════════════════════════════════════════════════
  // Dashboard Stats (computed from all data)
  // ═══════════════════════════════════════════════════════════════════════════
  int get totalFarmers => _plans.fold<int>(0, (s, p) => s + p.userCount);
  int get totalAnimals => mockAnimals.length;

  // ═══════════════════════════════════════════════════════════════════════════
  // Farm Data Aggregation (Breeding, Milk, Kids, Finance)
  // ═══════════════════════════════════════════════════════════════════════════

  // Breeding
  int get totalBreedingRecords => mockBreedingRecords.length;
  int get pregnantAnimalCount => mockBreedingRecords.where((b) => b.isPregnant).length;
  int get aiBreedingCount => mockBreedingRecords.where((b) => b.aiDone).length;
  List<BreedingRecord> get upcomingDeliveries => mockBreedingRecords
      .where((b) => b.isPregnant && b.expectedDelivery != null && b.expectedDelivery!.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.expectedDelivery!.compareTo(b.expectedDelivery!));

  // Milk
  double get todayMilkTotal => totalMilkForDate(DateTime.now());
  double get yesterdayMilkTotal => totalMilkForDate(DateTime.now().subtract(const Duration(days: 1)));
  int get dairyAnimalCount => getDairyAnimals(mockAnimals).length;

  // Kids
  int get totalKids => mockKids.length;
  int get weanedKidsCount => mockKids.where((k) => k.isWeaned).length;
  int get coccidiostatDueCount => mockKids.where((k) => k.coccidisostatDue).length;

  // Finance
  double get totalExpenses => mockExpenses.fold(0.0, (s, e) => s + e.amount);
  double get totalSales => mockSales.fold(0.0, (s, e) => s + e.amount);
  double get totalProfit => totalSales - totalExpenses;

  List<Map<String, dynamic>> get recentActivity {
    final activities = <Map<String, dynamic>>[];

    // Add recent notifications as activity
    for (final n in _notifications.take(2)) {
      activities.add({
        'emoji': '🔔',
        'text': 'Notification: ${n.title}',
        'time': _timeAgo(n.sentAt),
        'color': Colors.orange,
      });
    }

    // Add recent payments as activity
    for (final p in _payments.take(3)) {
      activities.add({
        'emoji': p.status == 'Success' ? '💸' : '❌',
        'text': 'Payment: ₹${p.amount.toStringAsFixed(0)} from ${p.userName}',
        'time': _timeAgo(p.date),
        'color': p.status == 'Success' ? Colors.green : Colors.red,
      });
    }

    return activities;
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr${diff.inHours > 1 ? 's' : ''} ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return '${diff.inDays ~/ 7} week${diff.inDays ~/ 7 > 1 ? 's' : ''} ago';
  }
}
