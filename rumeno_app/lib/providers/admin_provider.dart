import 'package:flutter/material.dart';
import '../mock/mock_animals.dart';

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

// ─── App Settings Model ──────────────────────────────────────────────────────
class AppSettings {
  bool maintenanceMode;
  bool allowNewSignups;
  bool emailNotifications;
  bool smsEnabled;
  String defaultLanguage;

  AppSettings({
    this.maintenanceMode = false,
    this.allowNewSignups = true,
    this.emailNotifications = true,
    this.smsEnabled = true,
    this.defaultLanguage = 'English',
  });
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
  }) {
    if (maintenanceMode != null) _settings.maintenanceMode = maintenanceMode;
    if (allowNewSignups != null) _settings.allowNewSignups = allowNewSignups;
    if (emailNotifications != null) _settings.emailNotifications = emailNotifications;
    if (smsEnabled != null) _settings.smsEnabled = smsEnabled;
    if (defaultLanguage != null) _settings.defaultLanguage = defaultLanguage;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Dashboard Stats (computed from all data)
  // ═══════════════════════════════════════════════════════════════════════════
  int get totalFarmers => _plans.fold<int>(0, (s, p) => s + p.userCount);
  int get totalAnimals => mockAnimals.length;

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
