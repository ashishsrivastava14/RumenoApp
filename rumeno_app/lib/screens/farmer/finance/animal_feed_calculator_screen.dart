import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/theme.dart';
import '../../../mock/mock_ecommerce.dart';
import '../../../mock/mock_farmers.dart';
import '../../../models/models.dart';
import '../../../providers/admin_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/ecommerce_provider.dart';

// ── Data Models ──

class _AnimalType {
  final String id;
  final String name;
  final String emoji;
  final String localName;
  final Color color;
  final double bodyWeightKg;
  final double dailyFeedKg;
  final double greenFodderKg;
  final double dryFodderKg;
  final double concentrateKg;
  final double targetProtein;
  final double targetFiber;
  final double targetEnergy;
  final double targetCarbohydrate;
  final double targetFat;
  final double targetMoisture;
  final double targetAsh;
  final String tip;

  const _AnimalType({
    required this.id,
    required this.name,
    required this.emoji,
    required this.localName,
    required this.color,
    required this.bodyWeightKg,
    required this.dailyFeedKg,
    required this.greenFodderKg,
    required this.dryFodderKg,
    required this.concentrateKg,
    required this.targetProtein,
    required this.targetFiber,
    required this.targetEnergy,
    required this.targetCarbohydrate,
    required this.targetFat,
    required this.targetMoisture,
    required this.targetAsh,
    required this.tip,
  });
}

const _animalTypes = [
  _AnimalType(
    id: 'dairy_cow',
    name: 'Dairy Cow',
    emoji: '🐄',
    localName: 'Milking Cow',
    color: Color(0xFFE8F5E9),
    bodyWeightKg: 400,
    dailyFeedKg: 25,
    greenFodderKg: 15,
    dryFodderKg: 5,
    concentrateKg: 5,
    targetProtein: 16,
    targetFiber: 18,
    targetEnergy: 65,
    targetCarbohydrate: 55,
    targetFat: 3.5,
    targetMoisture: 15,
    targetAsh: 8,
    tip:
        'Give 1 kg extra concentrate for every 2.5 litres of milk above 5 litres.',
  ),
  _AnimalType(
    id: 'buffalo',
    name: 'Buffalo',
    emoji: '🐃',
    localName: 'Water Buffalo',
    color: Color(0xFFEFEBE9),
    bodyWeightKg: 500,
    dailyFeedKg: 30,
    greenFodderKg: 20,
    dryFodderKg: 5,
    concentrateKg: 5,
    targetProtein: 14,
    targetFiber: 20,
    targetEnergy: 60,
    targetCarbohydrate: 50,
    targetFat: 4.0,
    targetMoisture: 15,
    targetAsh: 8,
    tip: 'Buffalo needs more green fodder for fat-rich milk production.',
  ),
  _AnimalType(
    id: 'goat',
    name: 'Goat',
    emoji: '🐐',
    localName: 'Farm Goat',
    color: Color(0xFFFFF3E0),
    bodyWeightKg: 40,
    dailyFeedKg: 4,
    greenFodderKg: 2,
    dryFodderKg: 1,
    concentrateKg: 1,
    targetProtein: 14,
    targetFiber: 22,
    targetEnergy: 55,
    targetCarbohydrate: 50,
    targetFat: 3.0,
    targetMoisture: 15,
    targetAsh: 8,
    tip: 'Goats prefer browsing – add leaves & shrubs when possible.',
  ),
  _AnimalType(
    id: 'sheep',
    name: 'Sheep',
    emoji: '🐑',
    localName: 'Farm Sheep',
    color: Color(0xFFF3E5F5),
    bodyWeightKg: 45,
    dailyFeedKg: 4.5,
    greenFodderKg: 2.5,
    dryFodderKg: 1,
    concentrateKg: 1,
    targetProtein: 12,
    targetFiber: 24,
    targetEnergy: 52,
    targetCarbohydrate: 50,
    targetFat: 3.0,
    targetMoisture: 15,
    targetAsh: 8,
    tip: 'Sheep do well on good quality hay and pasture grazing.',
  ),
  _AnimalType(
    id: 'horse',
    name: 'Horse',
    emoji: '🐴',
    localName: 'Riding Horse',
    color: Color(0xFFE3F2FD),
    bodyWeightKg: 450,
    dailyFeedKg: 12,
    greenFodderKg: 5,
    dryFodderKg: 5,
    concentrateKg: 2,
    targetProtein: 10,
    targetFiber: 28,
    targetEnergy: 55,
    targetCarbohydrate: 55,
    targetFat: 3.0,
    targetMoisture: 15,
    targetAsh: 7,
    tip:
        'Horses need high-fiber diet. Feed little and often \u2013 at least 3 times a day.',
  ),
  _AnimalType(
    id: 'pig',
    name: 'Pig',
    emoji: '🐷',
    localName: 'Farm Pig',
    color: Color(0xFFF8BBD0),
    bodyWeightKg: 90,
    dailyFeedKg: 3,
    greenFodderKg: 0.5,
    dryFodderKg: 0,
    concentrateKg: 2.5,
    targetProtein: 16,
    targetFiber: 8,
    targetEnergy: 72,
    targetCarbohydrate: 60,
    targetFat: 5.0,
    targetMoisture: 12,
    targetAsh: 6,
    tip:
        'Pigs grow well on grain-based concentrate with kitchen waste supplement.',
  ),
];

class _FeedItem {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final double pricePerKg;
  final double protein;
  final double fiber;
  final double energy;
  final double carbohydrate;
  final double fat;
  final double moisture;
  final double ash;

  const _FeedItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.pricePerKg,
    required this.protein,
    required this.fiber,
    required this.energy,
    required this.carbohydrate,
    required this.fat,
    required this.moisture,
    required this.ash,
  });
}

class _SelectedFeed {
  final _FeedItem item;
  final double quantityKg;

  const _SelectedFeed({required this.item, required this.quantityKg});

  _SelectedFeed copyWith({double? quantityKg}) =>
      _SelectedFeed(item: item, quantityKg: quantityKg ?? this.quantityKg);

  double get lineCost => quantityKg * item.pricePerKg;
}

class _AiSuggestion {
  final List<_SelectedFeed> combination;
  final double expectedProtein;
  final double expectedFiber;
  final double expectedEnergy;
  final double expectedCost;
  final double currentCost;

  const _AiSuggestion({
    required this.combination,
    required this.expectedProtein,
    required this.expectedFiber,
    required this.expectedEnergy,
    required this.expectedCost,
    required this.currentCost,
  });

  double get savings => currentCost - expectedCost;
}

// ── Screen ──

class AnimalFeedCalculatorScreen extends StatefulWidget {
  const AnimalFeedCalculatorScreen({super.key});

  @override
  State<AnimalFeedCalculatorScreen> createState() =>
      _AnimalFeedCalculatorScreenState();
}

class _AnimalFeedCalculatorScreenState
    extends State<AnimalFeedCalculatorScreen> {
  final TextEditingController _totalMixController = TextEditingController(
    text: '100',
  );
  final TextEditingController _customNameController = TextEditingController();
  final TextEditingController _customPriceController = TextEditingController();
  final TextEditingController _customProteinController =
      TextEditingController();
  final TextEditingController _customFiberController = TextEditingController();
  final TextEditingController _customEnergyController = TextEditingController();
  final TextEditingController _customCarbController = TextEditingController();
  final TextEditingController _customFatController = TextEditingController();
  final TextEditingController _customMoistureController = TextEditingController();
  final TextEditingController _customAshController = TextEditingController();

  List<_FeedItem> _feedLibrary = const [
    _FeedItem(
      id: 'maize',
      name: 'Maize',
      emoji: '🌽',
      color: Color(0xFFFFF3CD),
      pricePerKg: 27,
      protein: 8.5,
      fiber: 2.2,
      energy: 80,
      carbohydrate: 72,
      fat: 4.0,
      moisture: 12,
      ash: 1.5,
    ),
    _FeedItem(
      id: 'soybean_meal',
      name: 'Soybean Meal',
      emoji: '🫘',
      color: Color(0xFFE8F5E9),
      pricePerKg: 52,
      protein: 44,
      fiber: 7,
      energy: 70,
      carbohydrate: 30,
      fat: 1.5,
      moisture: 11,
      ash: 6.5,
    ),
    _FeedItem(
      id: 'wheat_bran',
      name: 'Wheat Bran',
      emoji: '🌾',
      color: Color(0xFFFFF8E1),
      pricePerKg: 24,
      protein: 16,
      fiber: 11,
      energy: 60,
      carbohydrate: 55,
      fat: 4.5,
      moisture: 12,
      ash: 6.0,
    ),
    _FeedItem(
      id: 'cottonseed_cake',
      name: 'Cottonseed Cake',
      emoji: '🧶',
      color: Color(0xFFF3E5F5),
      pricePerKg: 36,
      protein: 24,
      fiber: 16,
      energy: 58,
      carbohydrate: 30,
      fat: 5.0,
      moisture: 10,
      ash: 6.5,
    ),
    _FeedItem(
      id: 'green_fodder',
      name: 'Green Fodder',
      emoji: '🌿',
      color: Color(0xFFE0F2F1),
      pricePerKg: 8,
      protein: 10,
      fiber: 28,
      energy: 48,
      carbohydrate: 40,
      fat: 2.5,
      moisture: 75,
      ash: 10,
    ),
    _FeedItem(
      id: 'dry_hay',
      name: 'Dry Hay',
      emoji: '🟫',
      color: Color(0xFFEFEBE9),
      pricePerKg: 11,
      protein: 6,
      fiber: 35,
      energy: 40,
      carbohydrate: 45,
      fat: 1.5,
      moisture: 12,
      ash: 8.0,
    ),
    _FeedItem(
      id: 'mustard_cake',
      name: 'Mustard Cake',
      emoji: '🟡',
      color: Color(0xFFFFFDE7),
      pricePerKg: 30,
      protein: 34,
      fiber: 12,
      energy: 62,
      carbohydrate: 30,
      fat: 8.0,
      moisture: 10,
      ash: 9.0,
    ),
    _FeedItem(
      id: 'mineral_mix',
      name: 'Mineral Mix',
      emoji: '💎',
      color: Color(0xFFE3F2FD),
      pricePerKg: 85,
      protein: 0,
      fiber: 0,
      energy: 5,
      carbohydrate: 0,
      fat: 0,
      moisture: 2,
      ash: 95,
    ),
  ];

  final List<_SelectedFeed> _selectedItems = [];
  _AiSuggestion? _suggestion;
  bool _isAiLoading = false;
  _AnimalType _selectedAnimal = _animalTypes[0]; // Dairy Cow default
  int _numberOfAnimals = 1;
  bool _consentChecked = false;
  int _aiUsageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAiUsageCount();
      _checkAndShowConsent();
    });
  }

  Future<void> _checkAndShowConsent() async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.id ?? 'unknown';
    final prefs = await SharedPreferences.getInstance();
    final key = 'feed_calculator_consent_$userId';
    final alreadyAccepted = prefs.getBool(key) ?? false;
    if (!alreadyAccepted && mounted) {
      _showConsentDialog(prefs, key);
    }
  }

  void _showConsentDialog(SharedPreferences prefs, String key) {
    bool checked = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Text('⚠️', style: TextStyle(fontSize: 28)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Important Notice',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color(0xFF8A6A0A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE1C877),
                    width: 1.2,
                  ),
                ),
                child: const Text(
                  'The Feed Calculator provides AI-based suggestions for animal feed composition. '
                  'These are approximate values and should NOT be used as a substitute for professional veterinary advice.\n\n'
                  'Always consult a qualified Veterinary Doctor before making changes to your animal\'s diet. '
                  'Rumeno is not responsible for any outcomes resulting from the use of these suggestions.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF6B4E2E),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('🩺', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Always consult your Veterinary Doctor',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setDialogState(() => checked = !checked);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: checked,
                        activeColor: const Color(0xFF2E7D32),
                        onChanged: (v) {
                          setDialogState(() => checked = v ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'I understand and accept this notice',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: checked
                    ? () async {
                        await prefs.setBool(key, true);
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _totalMixController.dispose();
    _customNameController.dispose();
    _customPriceController.dispose();
    _customProteinController.dispose();
    _customFiberController.dispose();
    _customEnergyController.dispose();
    _customCarbController.dispose();
    _customFatController.dispose();
    _customMoistureController.dispose();
    _customAshController.dispose();
    super.dispose();
  }

  double _toDouble(String value) => double.tryParse(value.trim()) ?? 0;
  double get _totalMixKg => max(1, _toDouble(_totalMixController.text));
  double get _currentTotalQty =>
      _selectedItems.fold(0.0, (sum, e) => sum + e.quantityKg);
  double get _currentCost =>
      _selectedItems.fold(0.0, (sum, e) => sum + e.lineCost);

  double _weightedAverage(double Function(_FeedItem) valueOf) {
    if (_selectedItems.isEmpty || _currentTotalQty <= 0) return 0;
    return _selectedItems.fold<double>(
          0,
          (sum, s) => sum + valueOf(s.item) * s.quantityKg,
        ) /
        _currentTotalQty;
  }

  void _addItem(_FeedItem item) {
    if (_selectedItems.any((s) => s.item.id == item.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Already added! Change quantity below.'),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: RumenoTheme.warmBrown,
        ),
      );
      return;
    }
    setState(() {
      _selectedItems.add(_SelectedFeed(item: item, quantityKg: 10));
      _suggestion = null;
    });
  }

  void _updateQty(String id, double value) {
    setState(() {
      final i = _selectedItems.indexWhere((e) => e.item.id == id);
      if (i == -1) return;
      _selectedItems[i] = _selectedItems[i].copyWith(quantityKg: max(0, value));
      _suggestion = null;
    });
  }

  void _removeItem(String id) {
    setState(() {
      _selectedItems.removeWhere((e) => e.item.id == id);
      _suggestion = null;
    });
  }

  Future<void> _openFeedipedia() async {
    final uri = Uri.parse('https://www.feedipedia.org/');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Feedipedia right now.')),
      );
    }
  }

  void _showAddCustomFeedDialog() {
    _customNameController.clear();
    _customPriceController.clear();
    _customProteinController.clear();
    _customFiberController.clear();
    _customEnergyController.clear();
    _customCarbController.clear();
    _customFatController.clear();
    _customMoistureController.clear();
    _customAshController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '➕ Add Your Own Feed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _customNameController,
                decoration: const InputDecoration(
                  labelText: 'Feed Name',
                  prefixIcon: Icon(Icons.label_rounded),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _customPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per kg (₹)',
                  prefixIcon: Icon(Icons.currency_rupee_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customProteinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Protein %',
                        prefixIcon: Icon(Icons.fitness_center_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _customFiberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Fiber %',
                        prefixIcon: Icon(Icons.grass_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _customEnergyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Energy (0-100)',
                  prefixIcon: Icon(Icons.bolt_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customCarbController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Carb %',
                        prefixIcon: Icon(Icons.grain_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _customFatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Fat %',
                        prefixIcon: Icon(Icons.water_drop_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customMoistureController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Moisture %',
                        prefixIcon: Icon(Icons.opacity_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _customAshController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ash %',
                        prefixIcon: Icon(Icons.local_fire_department_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final name = _customNameController.text.trim();
                    final price = _toDouble(_customPriceController.text);
                    final protein = _toDouble(_customProteinController.text);
                    final fiber = _toDouble(_customFiberController.text);
                    final energy = _toDouble(_customEnergyController.text);
                    final carbohydrate = _toDouble(_customCarbController.text);
                    final fat = _toDouble(_customFatController.text);
                    final moisture = _toDouble(_customMoistureController.text);
                    final ash = _toDouble(_customAshController.text);

                    if (name.isEmpty || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill Feed Name and Price per kg.',
                          ),
                        ),
                      );
                      return;
                    }

                    final id =
                        '${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
                    setState(() {
                      _feedLibrary = [
                        ..._feedLibrary,
                        _FeedItem(
                          id: id,
                          name: name,
                          emoji: '📦',
                          color: const Color(0xFFEDE7F6),
                          pricePerKg: price,
                          protein: protein,
                          fiber: fiber,
                          energy: energy,
                          carbohydrate: carbohydrate,
                          fat: fat,
                          moisture: moisture,
                          ash: ash,
                        ),
                      ];
                    });
                    Navigator.of(ctx).pop();
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Add Feed', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadAiUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final month = '${DateTime.now().year}_${DateTime.now().month}';
    setState(() {
      _aiUsageCount = prefs.getInt('ai_mix_usage_$month') ?? 0;
    });
  }

  Future<void> _incrementAiUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final month = '${DateTime.now().year}_${DateTime.now().month}';
    _aiUsageCount++;
    await prefs.setInt('ai_mix_usage_$month', _aiUsageCount);
  }

  int _getAiMixLimit() {
    final userId = context.read<AuthProvider>().currentUser?.id ?? '';
    final farmer = mockFarmers.cast<Farmer?>().firstWhere(
      (f) => f!.id == userId,
      orElse: () => null,
    );
    final planName = farmer?.planName ?? 'Free';
    return context.read<AdminProvider>().settings.getAiMixLimit(planName);
  }

  String _getCurrentPlanName() {
    final userId = context.read<AuthProvider>().currentUser?.id ?? '';
    final farmer = mockFarmers.cast<Farmer?>().firstWhere(
      (f) => f!.id == userId,
      orElse: () => null,
    );
    return farmer?.planName ?? 'Free';
  }

  Future<void> _runAiSuggestion() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Text('☝️', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Expanded(child: Text('Tap feed items first to add them!')),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: RumenoTheme.warningYellow,
        ),
      );
      return;
    }

    // Check AI usage limit
    final limit = _getAiMixLimit();
    if (limit >= 0 && _aiUsageCount >= limit) {
      _showLimitReachedDialog();
      return;
    }

    setState(() => _isAiLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final targetProtein = _selectedAnimal.targetProtein;
    final targetFiber = _selectedAnimal.targetFiber;
    final targetEnergy = _selectedAnimal.targetEnergy;

    final weighted = _selectedItems.map((selected) {
      final item = selected.item;
      final proteinMatch = 100 - (targetProtein - item.protein).abs() * 3;
      final fiberMatch = 100 - (targetFiber - item.fiber).abs() * 2;
      final energyMatch = 100 - (targetEnergy - item.energy).abs() * 2;
      final costScore = 120 - item.pricePerKg;
      final score = max(
        5.0,
        proteinMatch + fiberMatch + energyMatch + costScore,
      );
      return MapEntry(selected, score);
    }).toList();

    final scoreSum = weighted.fold<double>(0, (s, e) => s + e.value);
    final targetTotalKg = _totalMixKg;

    final suggested = weighted.map((entry) {
      final ratio = scoreSum == 0 ? 0 : entry.value / scoreSum;
      final qty = max(2.0, ratio * targetTotalKg);
      return _SelectedFeed(item: entry.key.item, quantityKg: qty);
    }).toList();

    final totalQty = suggested.fold<double>(0, (s, e) => s + e.quantityKg);
    final normalized = suggested
        .map(
          (s) =>
              s.copyWith(quantityKg: (s.quantityKg / totalQty) * targetTotalKg),
        )
        .toList();

    final expectedCost = normalized.fold<double>(
      0,
      (s, e) => s + e.quantityKg * e.item.pricePerKg,
    );

    setState(() {
      _isAiLoading = false;
      _suggestion = _AiSuggestion(
        combination: normalized,
        expectedProtein: _wf(normalized, (i) => i.protein),
        expectedFiber: _wf(normalized, (i) => i.fiber),
        expectedEnergy: _wf(normalized, (i) => i.energy),
        expectedCost: expectedCost,
        currentCost: _currentCost,
      );
    });
    await _incrementAiUsage();
  }

  double _wf(List<_SelectedFeed> src, double Function(_FeedItem) sel) {
    final q = src.fold<double>(0, (s, e) => s + e.quantityKg);
    if (q <= 0) return 0;
    return src.fold<double>(0, (s, e) => s + sel(e.item) * e.quantityKg) / q;
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final protein = _weightedAverage((i) => i.protein);
    final fiber = _weightedAverage((i) => i.fiber);
    final energy = _weightedAverage((i) => i.energy);
    final carbohydrate = _weightedAverage((i) => i.carbohydrate);
    final fat = _weightedAverage((i) => i.fat);
    final moisture = _weightedAverage((i) => i.moisture);
    final ash = _weightedAverage((i) => i.ash);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🐄 ', style: TextStyle(fontSize: 22)),
            Text('Feed Calculator'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/farmer/finance');
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Feedipedia',
            onPressed: _openFeedipedia,
            icon: const Icon(Icons.menu_book_rounded),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F0E8), Color(0xFFE4F5DA)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Step 0: Choose Animal ──
            _stepHeader('🐾', 'Choose your animal'),
            const SizedBox(height: 8),
            _animalSelector(),
            const SizedBox(height: 12),
            _dailyRequirementCard(),
            const SizedBox(height: 20),

            // ── Step 1: How much feed ──
            _stepHeader('1️⃣', 'How much feed to make?'),
            const SizedBox(height: 8),
            _totalMixCard(),
            const SizedBox(height: 20),

            // ── Step 2: Pick feeds ──
            _stepHeader('2️⃣', 'Choose feed items'),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Tap card to add  •  Long press to drag',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            _feedLibraryGrid(),
            const SizedBox(height: 6),
            _addCustomButton(),
            const SizedBox(height: 20),

            // ── Step 3: Your mix ──
            _stepHeader('3️⃣', 'Your Feed Mix'),
            const SizedBox(height: 8),
            _mixDropZone(),
            const SizedBox(height: 16),

            // ── Summary ──
            if (_selectedItems.isNotEmpty) ...[
              _summaryCard(protein, fiber, energy, carbohydrate, fat, moisture, ash),
              const SizedBox(height: 16),
            ],

            // ── AI Button ──
            _aiButton(),
            const SizedBox(height: 10),
            _feedipediaButton(),
            const SizedBox(height: 16),

            // ── AI Suggestion ──
            if (_suggestion != null) _aiSuggestionCard(_suggestion!),
            if (_suggestion != null) const SizedBox(height: 16),

            // ── Disclaimer ──
            _disclaimerCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ── Step Header ──

  Widget _stepHeader(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
      ],
    );
  }

  // ── Animal Selector ──

  Widget _animalSelector() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _animalTypes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final animal = _animalTypes[index];
          final isSelected = _selectedAnimal.id == animal.id;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedAnimal = animal;
              _suggestion = null;
              _totalMixController.text = (animal.dailyFeedKg * _numberOfAnimals)
                  .toStringAsFixed(0);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 90,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? animal.color : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? RumenoTheme.primaryGreen
                      : const Color(0xFFE0E0E0),
                  width: isSelected ? 2.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: RumenoTheme.primaryGreen.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(animal.emoji, style: const TextStyle(fontSize: 30)),
                  const SizedBox(height: 4),
                  Text(
                    animal.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected
                          ? RumenoTheme.primaryDarkGreen
                          : const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dailyRequirementCard() {
    final a = _selectedAnimal;
    final totalDaily = a.dailyFeedKg * _numberOfAnimals;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: a.color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: a.color),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(a.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${a.name} · ${a.localName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Body weight ~${a.bodyWeightKg.toStringAsFixed(0)} kg',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Number of animals
          Row(
            children: [
              const Text(
                'Number of animals:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              _qtyButton(Icons.remove_rounded, () {
                if (_numberOfAnimals > 1) {
                  setState(() {
                    _numberOfAnimals--;
                    _totalMixController.text =
                        (a.dailyFeedKg * _numberOfAnimals).toStringAsFixed(0);
                    _suggestion = null;
                  });
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$_numberOfAnimals',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _qtyButton(Icons.add_rounded, () {
                setState(() {
                  _numberOfAnimals++;
                  _totalMixController.text = (a.dailyFeedKg * _numberOfAnimals)
                      .toStringAsFixed(0);
                  _suggestion = null;
                });
              }),
            ],
          ),
          const SizedBox(height: 14),

          // Daily feed breakdown
          const Text(
            'Daily Feed Requirement (1 animal):',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (a.greenFodderKg > 0)
                Expanded(
                  child: _dailyMiniCard(
                    '🌿',
                    'Green Fodder',
                    '${a.greenFodderKg.toStringAsFixed(1)} kg',
                  ),
                ),
              if (a.greenFodderKg > 0) const SizedBox(width: 8),
              if (a.dryFodderKg > 0)
                Expanded(
                  child: _dailyMiniCard(
                    '🟫',
                    'Dry Fodder',
                    '${a.dryFodderKg.toStringAsFixed(1)} kg',
                  ),
                ),
              if (a.dryFodderKg > 0) const SizedBox(width: 8),
              if (a.concentrateKg > 0)
                Expanded(
                  child: _dailyMiniCard(
                    '🌾',
                    'Concentrate',
                    '${a.concentrateKg.toStringAsFixed(1)} kg',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Total daily & nutrient targets
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '📦 Total daily: ${a.dailyFeedKg.toStringAsFixed(1)} kg × $_numberOfAnimals',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '= ${totalDaily.toStringAsFixed(0)} kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF3D5A1E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _miniStat(
                      '💪',
                      '${a.targetProtein.toStringAsFixed(0)}%',
                      'Protein',
                    ),
                    _miniStat(
                      '🌿',
                      '${a.targetFiber.toStringAsFixed(0)}%',
                      'Fiber',
                    ),
                    _miniStat(
                      '⚡',
                      a.targetEnergy.toStringAsFixed(0),
                      'Energy',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    a.tip,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF6B4E2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dailyMiniCard(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Color(0xFF999999)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 1: Total Mix ──

  Widget _totalMixCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5FBF0)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('⚖️', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Feed (kg)',
                  style: TextStyle(fontSize: 14, color: Color(0xFF7A7A7A)),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _totalMixController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    suffixText: 'kg',
                    suffixStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                  onChanged: (_) => setState(() => _suggestion = null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 2: Feed Library Grid ──

  Widget _feedLibraryGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _feedLibrary.length,
      itemBuilder: (context, index) {
        final item = _feedLibrary[index];
        final isAdded = _selectedItems.any((s) => s.item.id == item.id);
        return LongPressDraggable<_FeedItem>(
          data: item,
          feedback: Transform.scale(
            scale: 1.05,
            child: Opacity(opacity: 0.9, child: _feedCard(item, false)),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _feedCard(item, isAdded),
          ),
          child: GestureDetector(
            onTap: () => _addItem(item),
            child: _feedCard(item, isAdded),
          ),
        );
      },
    );
  }

  Widget _feedCard(_FeedItem item, bool isAdded) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAdded ? RumenoTheme.primaryGreen : Colors.transparent,
          width: isAdded ? 2.5 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 28)),
              const Spacer(),
              if (isAdded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: RumenoTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✓ Added',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Color(0xFF999999),
                  size: 20,
                ),
            ],
          ),
          const Spacer(),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            '₹${item.pricePerKg.toStringAsFixed(0)}/kg',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFF3D5A1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addCustomButton() {
    return GestureDetector(
      onTap: _showAddCustomFeedDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.4),
            width: 1.5,
          ),
          color: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Color(0xFF5B7A2E)),
            SizedBox(width: 8),
            Text(
              'Add Your Own Feed',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF5B7A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 3: Mix Drop Zone + Selected Items ──

  Widget _mixDropZone() {
    return DragTarget<_FeedItem>(
      onAcceptWithDetails: (details) => _addItem(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHover = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isHover ? const Color(0xFFD5F0C5) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isHover
                  ? RumenoTheme.primaryGreen
                  : const Color(0xFFBFD8A8),
              width: isHover ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: _selectedItems.isEmpty
              ? _emptyMixPlaceholder()
              : Column(
                  children: [
                    ..._selectedItems.map(_selectedFeedTile),
                    const SizedBox(height: 6),
                    // Total cost bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5B7A2E), Color(0xFF7DA03E)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '💰 Total Cost',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '₹${_currentCost.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _emptyMixPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(
            Icons.playlist_add_rounded,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          Text(
            'Tap any feed above to add here',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'or long-press & drag it here',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _selectedFeedTile(_SelectedFeed selected) {
    return Dismissible(
      key: ValueKey(selected.item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCDD2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          '🗑️ Remove',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      onDismissed: (_) => _removeItem(selected.item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected.item.color.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD5E3BF)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(selected.item.emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '₹${selected.item.pricePerKg.toStringAsFixed(0)}/kg',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),
                    ],
                  ),
                ),
                // Cost for this line
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${selected.lineCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Color(0xFF3D5A1E),
                      ),
                    ),
                    const Text(
                      'cost',
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Quantity controls: big ± buttons + slider + editable input
            Row(
              children: [
                // Big minus button
                _qtyButton(Icons.remove_rounded, () {
                  _updateQty(selected.item.id, max(0, selected.quantityKg - 5));
                }),
                const SizedBox(width: 8),
                // Editable input box
                SizedBox(
                  width: 72,
                  height: 44,
                  child: TextFormField(
                    key: ValueKey(
                      'qty_${selected.item.id}_${selected.quantityKg.toStringAsFixed(0)}',
                    ),
                    initialValue: selected.quantityKg.toStringAsFixed(0),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      suffixText: 'kg',
                      suffixStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF999999),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD5E3BF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD5E3BF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: RumenoTheme.primaryGreen,
                          width: 2,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) {
                        _updateQty(selected.item.id, max(0, parsed));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Big plus button
                _qtyButton(Icons.add_rounded, () {
                  _updateQty(selected.item.id, selected.quantityKg + 5);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: 28, color: RumenoTheme.primaryGreen),
        ),
      ),
    );
  }

  // ── Summary Card ──

  Widget _summaryCard(double protein, double fiber, double energy,
      double carbohydrate, double fat, double moisture, double ash) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('📊', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text(
                'Nutrition Check',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _bigStatPill(
                  emoji: '⚖️',
                  label: 'Quantity',
                  value: '${_currentTotalQty.toStringAsFixed(0)} kg',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _bigStatPill(
                  emoji: '💰',
                  label: 'Total Cost',
                  value: '₹${_currentCost.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _nutrientBar(
            label: '💪 Protein',
            value: protein,
            maxVal: 50,
            color: const Color(0xFFE53935),
            target: _selectedAnimal.targetProtein,
          ),
          const SizedBox(height: 10),
          _nutrientBar(
            label: '🌿 Fiber',
            value: fiber,
            maxVal: 50,
            color: const Color(0xFF43A047),
            target: _selectedAnimal.targetFiber,
          ),
          const SizedBox(height: 10),
          _nutrientBar(
            label: '⚡ Energy',
            value: energy,
            maxVal: 100,
            color: const Color(0xFFFFA000),
            target: _selectedAnimal.targetEnergy,
          ),
          const SizedBox(height: 10),
          _nutrientBar(
            label: '🍞 Carbohydrate',
            value: carbohydrate,
            maxVal: 100,
            color: const Color(0xFF8D6E63),
            target: _selectedAnimal.targetCarbohydrate,
          ),
          const SizedBox(height: 10),
          _nutrientBar(
            label: '🧈 Fat',
            value: fat,
            maxVal: 20,
            color: const Color(0xFFFF7043),
            target: _selectedAnimal.targetFat,
          ),
          const SizedBox(height: 10),
          _nutrientBar(
            label: '💧 Moisture',
            value: moisture,
            maxVal: 100,
            color: const Color(0xFF42A5F5),
            target: _selectedAnimal.targetMoisture,
          ),
          const SizedBox(height: 10),
          _nutrientBar(
            label: '\ud83e\uddea Ash',
            value: ash,
            maxVal: 100,
            color: const Color(0xFF78909C),
            target: _selectedAnimal.targetAsh,
          ),
        ],
      ),
    );
  }

  Widget _bigStatPill({
    required String emoji,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutrientBar({
    required String label,
    required double value,
    required double maxVal,
    required Color color,
    required double target,
  }) {
    final pct = (value / maxVal).clamp(0.0, 1.0);
    final targetPct = (target / maxVal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              '  (target ${target.toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 12,
          child: Stack(
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Filled
              FractionallySizedBox(
                widthFactor: pct,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              // Target marker
              Positioned(
                left:
                    targetPct *
                    (MediaQuery.of(context).size.width - 64), // approximate
                top: 0,
                bottom: 0,
                child: Container(width: 2.5, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── AI Button ──

  Widget _aiButton() {
    final limit = _getAiMixLimit();
    final isUnlimited = limit < 0;
    final remaining = isUnlimited ? -1 : limit - _aiUsageCount;
    final isExhausted = !isUnlimited && remaining <= 0;

    return Column(
      children: [
        GestureDetector(
          onTap: _isAiLoading ? null : _runAiSuggestion,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: _isAiLoading
                  ? const LinearGradient(
                      colors: [Color(0xFF999999), Color(0xFFAAAAAA)],
                    )
                  : isExhausted
                      ? const LinearGradient(
                          colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF5B7A2E), Color(0xFF7DA03E)],
                        ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isExhausted ? Colors.grey : RumenoTheme.primaryGreen)
                      .withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isAiLoading) ...[
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'AI is thinking...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ] else if (isExhausted) ...[
                  const Text('🔒', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  const Text(
                    'AI Limit Reached',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ] else ...[
                  const Text('✨', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  const Text(
                    'Ask AI for Best Mix',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Usage counter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isExhausted
                ? const Color(0xFFFFEBEE)
                : const Color(0xFFF1F9EA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isUnlimited
                    ? Icons.all_inclusive_rounded
                    : isExhausted
                        ? Icons.warning_amber_rounded
                        : Icons.auto_awesome_rounded,
                size: 16,
                color: isExhausted
                    ? const Color(0xFFE53935)
                    : const Color(0xFF5B7A2E),
              ),
              const SizedBox(width: 6),
              Text(
                isUnlimited
                    ? '$_aiUsageCount used · Unlimited (${_getCurrentPlanName()})'
                    : isExhausted
                        ? '$_aiUsageCount/$limit used · Upgrade for more'
                        : '$_aiUsageCount/$limit used · ${_getCurrentPlanName()} Plan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isExhausted
                      ? const Color(0xFFE53935)
                      : const Color(0xFF5B7A2E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔒', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text(
                'AI Limit Reached',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ve used all $_aiUsageCount AI suggestions for this month on your ${_getCurrentPlanName()} plan.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text('🚀 Upgrade for more AI suggestions',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Starter: 10/mo • Pro: 50/mo • Business: Unlimited',
                        style: TextStyle(fontSize: 12, color: Color(0xFF7B1FA2))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.push('/farmer/more/subscription');
                      },
                      icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                      label: const Text('Upgrade'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedipediaButton() {
    return GestureDetector(
      onTap: _openFeedipedia,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
          color: const Color(0xFFE3F2FD),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🌐', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'Open Feedipedia Reference',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AI Suggestion Card ──

  Widget _aiSuggestionCard(_AiSuggestion suggestion) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1F9EA), Color(0xFFE8F5E9)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFA5D6A7)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🤖', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Suggested Mix',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              Text('✨', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 12),
          ...suggestion.combination.map(
            (s) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: s.item.color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(s.item.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s.item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${s.quantityKg.toStringAsFixed(1)} kg',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${(s.quantityKg * s.item.pricePerKg).toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3D5A1E),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Nutrient summary row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _miniStat(
                '💪',
                '${suggestion.expectedProtein.toStringAsFixed(1)}%',
                'Protein',
              ),
              _miniStat(
                '🌿',
                '${suggestion.expectedFiber.toStringAsFixed(1)}%',
                'Fiber',
              ),
              _miniStat(
                '⚡',
                suggestion.expectedEnergy.toStringAsFixed(0),
                'Energy',
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Cost comparison
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your current cost:',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '₹${suggestion.currentCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI suggested cost:',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '₹${suggestion.expectedCost.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3D5A1E),
                      ),
                    ),
                  ],
                ),
                if (suggestion.savings > 0) ...[
                  const Divider(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          'You save ₹${suggestion.savings.toStringAsFixed(0)}!',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (suggestion.savings < 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Extra cost ₹${(-suggestion.savings).toStringAsFixed(0)} for better nutrition',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Based on Feedipedia nutrient data & local cost factors',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          // ── Rumeno Product Recommendations ──
          _buildRumenoProductRecommendations(),
        ],
      ),
    );
  }

  Widget _miniStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
        ),
      ],
    );
  }

  // ── Rumeno Product Recommendations ──

  Widget _buildRumenoProductRecommendations() {
    final feedProducts = mockProducts
        .where((p) =>
            p.isRumenoOwned &&
            (p.category == ProductCategory.animalFeed ||
                p.category == ProductCategory.supplements))
        .toList();

    if (feedProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🛒', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recommended Rumeno Products',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Boost your feed mix with these quality products',
            style: TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
          ),
          const SizedBox(height: 12),
          ...feedProducts.map((product) => _buildRumenoProductTile(product)),
        ],
      ),
    );
  }

  Widget _buildRumenoProductTile(Product product) {
    return GestureDetector(
      onTap: () => context.push('/shop/product/${product.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                product.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('📦', style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D2D2D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Info icon for benefits
                      GestureDetector(
                        onTap: () => _showBenefitsDialog(product),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      if (product.mrp != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '₹${product.mrp!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product.discountPercent.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Star rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFFFA000),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5D4037),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Cart button
            GestureDetector(
              onTap: () {
                context.read<EcommerceProvider>().addToCart(product);
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    content: GestureDetector(
                      onTap: () {
                        messenger.hideCurrentSnackBar();
                        context.push('/shop/cart');
                      },
                      child: Row(
                        children: [
                          const Text('🛒', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('${product.name} added to cart!'),
                          ),
                          const Text(
                            'View Cart →',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: RumenoTheme.primaryGreen,
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBenefitsDialog(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  product.imageUrl,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text('📦', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Rumeno Verified ✓',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Tags
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: product.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 14),
              // Price row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  if (product.mrp != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '₹${product.mrp!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF999999),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  // Rating
                  const Icon(Icons.star_rounded,
                      size: 18, color: Color(0xFFFFA000)),
                  Text(
                    ' ${product.rating}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    ' (${product.reviewCount})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.push('/shop/product/${product.id}');
                      },
                      icon: const Icon(Icons.shopping_bag_rounded, size: 18),
                      label: const Text('View Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Disclaimer ──

  Widget _disclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1C877), width: 1.5),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text('⚠️', style: TextStyle(fontSize: 28)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Important Notice',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF8A6A0A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'This is AI suggestion. Kindly check with a Vet doctor before using. '
            'It is a possible good solution for feed rate. '
            'Kindly get it verified by a qualified veterinary doctor.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF6B4E2E),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('🩺', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Always consult your Veterinary Doctor',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
