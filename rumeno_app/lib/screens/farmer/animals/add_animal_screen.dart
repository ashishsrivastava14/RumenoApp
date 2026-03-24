import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/common/marketplace_button.dart';

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Step 1
  Species _species = Species.cow;
  Gender _gender = Gender.female;
  final _breedController = TextEditingController();
  final _tagController = TextEditingController(text: 'C-009');
  DateTime _dob = DateTime(2023, 1, 1);
  bool _autoTag = true;

  // Step 2
  double _weight = 400;
  double _height = 130;
  String _selectedColor = 'Brown';
  XFile? _animalPhoto;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  // Step 3
  String? _fatherId;
  String? _motherId;
  int _numberOfSiblings = 0;
  final List<_ParentEntry> _customFathers = [];
  final List<_ParentEntry> _customMothers = [];

  // Step 4
  final _shedController = TextEditingController(text: 'A1');
  AnimalPurpose _purpose = AnimalPurpose.dairy;
  List<String> _selectedGroupIds = [];

  // Step 5 – Purchase (all optional)
  DateTime? _purchaseDate;
  final _purchasePlaceController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _toothAgeController = TextEditingController();

  static const _stepMeta = [
    {'icon': Icons.pets, 'title': 'Which Animal?', 'sub': 'Type & basic info'},
    {'icon': Icons.monitor_weight, 'title': 'How it looks?', 'sub': 'Size & color'},
    {'icon': Icons.family_restroom, 'title': 'Family', 'sub': 'Parents (optional)'},
    {'icon': Icons.home_work, 'title': 'Where it lives?', 'sub': 'Shed & purpose'},
    {'icon': Icons.shopping_bag_outlined, 'title': 'Purchase', 'sub': 'Optional'},
  ];

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: _weight.round().toString());
    _heightController = TextEditingController(text: _height.round().toString());
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _breedController.dispose();
    _tagController.dispose();
    _shedController.dispose();
    _purchasePlaceController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _toothAgeController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _animController.reset();
    _animController.forward();
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addAnimalTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/farmer/animals');
            }
          },
        ),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildCurrentStep(),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Progress header ──────────────────────────
  Widget _buildProgressHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: List.generate(_stepMeta.length, (i) {
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;
          return Expanded(
            child: GestureDetector(
              onTap: isDone ? () => _goToStep(i) : null,
              child: Row(
                children: [
                  if (i > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isDone
                            ? RumenoTheme.primaryGreen
                            : RumenoTheme.textLight,
                      ),
                    ),
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? RumenoTheme.primaryGreen
                              : isDone
                                  ? RumenoTheme.successGreen
                                  : RumenoTheme.backgroundCream,
                          border: Border.all(
                            color: isActive || isDone
                                ? RumenoTheme.primaryGreen
                                : RumenoTheme.textLight,
                            width: 2,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                      color: RumenoTheme.primaryGreen
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8)
                                ]
                              : [],
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 20)
                              : Icon(
                                  _stepMeta[i]['icon'] as IconData,
                                  color: isActive
                                      ? Colors.white
                                      : RumenoTheme.textLight,
                                  size: 18,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _stepMeta[i]['title'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive
                              ? RumenoTheme.primaryGreen
                              : RumenoTheme.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  if (i < _stepMeta.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isDone
                            ? RumenoTheme.primaryGreen
                            : RumenoTheme.textLight,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      case 4:
        return _buildStep5();
      default:
        return _buildStep1();
    }
  }

  // ── Step 1 : Basic Info ──────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(Icons.pets, 'Which Animal?',
            'Choose the type and basic details'),
        const SizedBox(height: 20),
        _sectionLabel('🐄  Type of Animal'),
        const SizedBox(height: 10),
        _buildSpeciesGrid(),
        const SizedBox(height: 24),
        _sectionLabel('⚥  Gender'),
        const SizedBox(height: 10),
        _buildGenderRow(),
        const SizedBox(height: 24),
        _sectionLabel('🌱  Breed'),
        const SizedBox(height: 8),
        _bigTextField(_breedController, 'e.g. Holstein, Gir, Murrah…', Icons.grass),
        const SizedBox(height: 24),
        _sectionLabel('🎂  Date of Birth'),
        const SizedBox(height: 8),
        _buildDobPicker(),
        const SizedBox(height: 24),
        _sectionLabel('🏷️  Tag ID'),
        const SizedBox(height: 8),
        _buildTagCard(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSpeciesGrid() {
    const items = [
      {'s': Species.cow, 'e': '🐄', 'l': 'Cow'},
      {'s': Species.buffalo, 'e': '🐃', 'l': 'Buffalo'},
      {'s': Species.goat, 'e': '🐐', 'l': 'Goat'},
      {'s': Species.sheep, 'e': '🐑', 'l': 'Sheep'},
      {'s': Species.pig, 'e': '🐷', 'l': 'Pig'},
      {'s': Species.horse, 'e': '🐴', 'l': 'Horse'},
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.05,
      children: items.map((item) {
        final sel = _species == item['s'];
        return GestureDetector(
          onTap: () => setState(() => _species = item['s'] as Species),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: sel ? RumenoTheme.primaryGreen : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: sel
                      ? RumenoTheme.primaryGreen
                      : RumenoTheme.textLight,
                  width: sel ? 2 : 1),
              boxShadow: sel
                  ? [
                      BoxShadow(
                          color:
                              RumenoTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ]
                  : [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4)
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['e'] as String,
                    style: const TextStyle(fontSize: 34)),
                const SizedBox(height: 4),
                Text(
                  item['l'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: sel ? Colors.white : RumenoTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenderRow() {
    return Row(
      children: [
        Expanded(
            child: _genderCard(Gender.male, '♂', 'Male', Icons.male,
                const Color(0xFF1565C0))),
        const SizedBox(width: 12),
        Expanded(
            child: _genderCard(Gender.female, '♀', 'Female', Icons.female,
                const Color(0xFFC2185B))),
      ],
    );
  }

  Widget _genderCard(
      Gender g, String sym, String label, IconData icon, Color color) {
    final sel = _gender == g;
    return GestureDetector(
      onTap: () => setState(() => _gender = g),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: sel ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: sel ? color : RumenoTheme.textLight,
              width: sel ? 2 : 1),
          boxShadow: [
            BoxShadow(
                color: sel
                    ? color.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 8)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: sel ? Colors.white : color, size: 30),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: sel ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDobPicker() {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: _dob,
          firstDate: DateTime(2015),
          lastDate: DateTime.now(),
        );
        if (d != null) setState(() => _dob = d);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RumenoTheme.textLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month,
                  color: RumenoTheme.primaryGreen, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date of Birth',
                    style: TextStyle(
                        color: RumenoTheme.textGrey, fontSize: 12)),
                Text(
                  '${_dob.day} / ${_dob.month} / ${_dob.year}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: RumenoTheme.textDark),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: RumenoTheme.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildTagCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RumenoTheme.textLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.label, color: RumenoTheme.primaryGreen, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Auto-generate Tag ID',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    Text('System assigns a unique number',
                        style: TextStyle(
                            color: RumenoTheme.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: _autoTag,
                onChanged: (v) => setState(() => _autoTag = v),
                activeThumbColor: RumenoTheme.primaryGreen,
              ),
            ],
          ),
          if (_autoTag)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tag,
                            color: RumenoTheme.primaryGreen, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          _tagController.text,
                          style: const TextStyle(
                              color: RumenoTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (!_autoTag) ...[
            const Divider(height: 20),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: 'Custom Tag ID',
                hintText: 'e.g. C-010',
                prefixIcon: const Icon(Icons.tag),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Step 2 : Physical ────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(Icons.monitor_weight, 'How does it look?',
            'Size, weight and appearance'),
        const SizedBox(height: 20),
        _sectionLabel('⚖️  Weight'),
        const SizedBox(height: 8),
        _measureInputCard(
          emoji: '⚖️',
          label: 'Weight',
          unit: 'kg',
          controller: _weightController,
          value: _weight,
          min: 10,
          max: 1000,
          step: 1,
          onChanged: (v) => setState(() => _weight = v),
        ),
        const SizedBox(height: 20),
        _sectionLabel('📏  Height'),
        const SizedBox(height: 8),
        _measureInputCard(
          emoji: '📏',
          label: 'Height',
          unit: 'cm',
          controller: _heightController,
          value: _height,
          min: 30,
          max: 220,
          step: 1,
          onChanged: (v) => setState(() => _height = v),
        ),
        const SizedBox(height: 20),
        _sectionLabel('🎨  Color / Markings'),
        const SizedBox(height: 10),
        _buildColorPicker(),
        const SizedBox(height: 20),
        _sectionLabel('📸  Animal Photo'),
        const SizedBox(height: 10),
        _buildPhotoUpload(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _measureInputCard({
    required String emoji,
    required String label,
    required String unit,
    required TextEditingController controller,
    required double value,
    required double min,
    required double max,
    required double step,
    required ValueChanged<double> onChanged,
  }) {
    void adjust(double delta) {
      final newVal = (value + delta).clamp(min, max);
      onChanged(newVal);
      controller.text = newVal.round().toString();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: RumenoTheme.primaryGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                // Minus button
                _adjustButton(
                  icon: Icons.remove,
                  onTap: () => adjust(-step),
                  enabled: value > min,
                ),
                const SizedBox(width: 12),
                // Input field
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: RumenoTheme.primaryGreen.withValues(alpha: 0.5),
                              width: 1.5),
                        ),
                        child: TextField(
                          controller: controller,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: RumenoTheme.primaryGreen,
                            height: 1.1,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            suffixText: unit,
                            suffixStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: RumenoTheme.primaryGreen.withValues(alpha: 0.7),
                            ),
                          ),
                          onChanged: (text) {
                            final parsed = double.tryParse(text);
                            if (parsed != null) {
                              final clamped = parsed.clamp(min, max);
                              onChanged(clamped);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Min: ${min.round()} – Max: ${max.round()} $unit',
                        style: const TextStyle(
                            fontSize: 11, color: RumenoTheme.textGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Plus button
                _adjustButton(
                  icon: Icons.add,
                  onTap: () => adjust(step),
                  enabled: value < max,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _adjustButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: enabled
              ? RumenoTheme.primaryGreen
              : RumenoTheme.textLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : RumenoTheme.textGrey,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      {'name': 'Black', 'color': const Color(0xFF1A1A1A)},
      {'name': 'White', 'color': const Color(0xFFF5F5F5)},
      {'name': 'Brown', 'color': const Color(0xFF6B4E2E)},
      {'name': 'Light\nBrown', 'color': const Color(0xFFC49A6C)},
      {'name': 'Grey', 'color': Colors.grey},
      {'name': 'Spotted', 'color': null},
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: colors.map((c) {
        final sel = _selectedColor == (c['name'] as String).replaceAll('\n', ' ');
        final name = (c['name'] as String).replaceAll('\n', ' ');
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: sel
                      ? RumenoTheme.primaryGreen
                      : RumenoTheme.textLight,
                  width: sel ? 2 : 1),
              color: sel
                  ? RumenoTheme.primaryGreen.withValues(alpha: 0.08)
                  : Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (c['color'] != null)
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c['color'] as Color,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Text('🐄', style: TextStyle(fontSize: 16)),
                  ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: sel
                        ? RumenoTheme.primaryGreen
                        : RumenoTheme.textDark,
                  ),
                ),
                if (sel) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle,
                      color: RumenoTheme.primaryGreen, size: 16),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static const int _maxPhotoBytes = 5 * 1024 * 1024; // 5 MB

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (file == null) return;

    final bytes = await file.length();
    if (bytes > _maxPhotoBytes) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            content: const Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Image too large. Max size allowed is 5 MB.',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return;
    }

    setState(() => _animalPhoto = file);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: RumenoTheme.textLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: RumenoTheme.primaryGreen),
                ),
                title: const Text('Take a Photo',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Use camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: RumenoTheme.primaryGreen),
                ),
                title: const Text('Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Pick an existing photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.gallery);
                },
              ),
              if (_animalPhoto != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.red),
                  ),
                  title: const Text('Remove Photo',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _animalPhoto = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _showPhotoOptions,
      child: _animalPhoto != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(_animalPhoto!.path),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.edit_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.5),
                    width: 1.5),
              ),
              child: Column(
                children: [
                  Icon(Icons.add_a_photo_outlined,
                      size: 52,
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.7)),
                  const SizedBox(height: 10),
                  const Text('Tap to add photo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: RumenoTheme.primaryGreen)),
                  const SizedBox(height: 4),
                  Text('Optional – helps identify the animal',
                      style: TextStyle(
                          color: RumenoTheme.textGrey, fontSize: 12)),
                ],
              ),
            ),
    );
  }

  // ── Step 3 : Pedigree ────────────────────────
  Widget _buildStep3() {
    final fatherEntries = [
      const _ParentEntry(animalId: 'C-007'),
      const _ParentEntry(animalId: 'B-005'),
      ..._customFathers,
    ];
    final motherEntries = [
      const _ParentEntry(animalId: 'C-001'),
      const _ParentEntry(animalId: 'C-002'),
      const _ParentEntry(animalId: 'C-003'),
      ..._customMothers,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(Icons.family_restroom, 'Family (Pedigree)',
            'Select parents – tap Skip if unknown'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RumenoTheme.infoBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: RumenoTheme.infoBlue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This step is optional. You can skip if you do not know the parents.',
                  style: TextStyle(
                      color: RumenoTheme.infoBlue, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('🐂  Father (Bull)'),
        const SizedBox(height: 8),
        _parentSelector(
          entries: fatherEntries,
          selected: _fatherId,
          onChanged: (v) => setState(() => _fatherId = v),
          previousFarmEntry: const _ParentEntry(
            animalId: 'BF-112',
            location: 'Green Valley Farm',
            ownerName: 'Ahmad Raza',
          ),
          parentLabel: 'Father',
          onAddNew: () => _showAddParentDialog(
            title: 'Add Father',
            onSave: (entry) {
              setState(() {
                _customFathers.add(entry);
                _fatherId = entry.animalId;
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('🐄  Mother (Cow)'),
        const SizedBox(height: 8),
        _parentSelector(
          entries: motherEntries,
          selected: _motherId,
          onChanged: (v) => setState(() => _motherId = v),
          previousFarmEntry: const _ParentEntry(
            animalId: 'CM-204',
            location: 'Green Valley Farm',
            ownerName: 'Ahmad Raza',
          ),
          parentLabel: 'Mother',
          onAddNew: () => _showAddParentDialog(
            title: 'Add Mother',
            onSave: (entry) {
              setState(() {
                _customMothers.add(entry);
                _motherId = entry.animalId;
              });
            },
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('👶  Number of Siblings at Birth'),
        const SizedBox(height: 8),
        _buildSiblingsCounter(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSiblingsCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RumenoTheme.textLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.people_outline, color: RumenoTheme.primaryGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Siblings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(
                  _numberOfSiblings == 0 ? 'No siblings / unknown' : '$_numberOfSiblings sibling${_numberOfSiblings > 1 ? "s" : ""} in litter',
                  style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _numberOfSiblings > 0 ? () => setState(() => _numberOfSiblings--) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _numberOfSiblings > 0 ? RumenoTheme.primaryGreen : RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.remove, color: _numberOfSiblings > 0 ? Colors.white : RumenoTheme.textLight, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$_numberOfSiblings',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: RumenoTheme.textDark),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => setState(() => _numberOfSiblings++),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: RumenoTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showParentChildrenSheet(Animal parent) {
    final children = getChildrenOf(parent.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: RumenoTheme.warningYellow.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.warning_amber_rounded, color: RumenoTheme.warningYellow, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Offspring of ${parent.tagId}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const Text('Check to avoid inbreeding', style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (children.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No recorded offspring yet', style: TextStyle(color: RumenoTheme.textGrey))),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: children.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final child = children[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      leading: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: RumenoTheme.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text(child.gender == Gender.male ? '♂' : '♀', style: const TextStyle(fontSize: 20))),
                      ),
                      title: Text(child.tagId, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${child.breed} • ${child.ageString}', style: const TextStyle(fontSize: 12)),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.go('/farmer/animals/${child.id}');
                        },
                        child: const Text('View', style: TextStyle(color: RumenoTheme.primaryGreen)),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddParentDialog({
    required String title,
    required void Function(_ParentEntry) onSave,
  }) {
    final idCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final ownerCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: RumenoTheme.textLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: RumenoTheme.primaryGreen
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.pets,
                            color: RumenoTheme.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: RumenoTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: idCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Animal ID *',
                      hintText: 'e.g. C-010',
                      prefixIcon: const Icon(Icons.tag_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: RumenoTheme.backgroundCream,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Animal ID is required'
                            : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: locationCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Location *',
                      hintText: 'e.g. Jaipur',
                      prefixIcon:
                          const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: RumenoTheme.backgroundCream,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Location is required'
                            : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: ownerCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Previous Owner Name',
                      hintText: 'e.g. Ramesh Kumar',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: RumenoTheme.backgroundCream,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              onSave(_ParentEntry(
                                animalId: idCtrl.text.trim(),
                                location: locationCtrl.text.trim(),
                                ownerName: ownerCtrl.text.trim(),
                              ));
                              Navigator.pop(ctx);
                            }
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Save',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            backgroundColor:
                                RumenoTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPreviousFarmParentInfo(String label) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: RumenoTheme.infoBlue),
            SizedBox(width: 8),
            Text('Previous Farm Info', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(
          '$label detail of previous farm if available',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _parentSelector({
    required List<_ParentEntry> entries,
    required String? selected,
    required Function(String?) onChanged,
    required VoidCallback onAddNew,
    _ParentEntry? previousFarmEntry,
    String parentLabel = 'Parent',
  }) {
    return Column(
      children: [
        _parentTile(entry: null, selected: selected, onChanged: onChanged),
        ...entries.map((e) => _parentTile(
              entry: e,
              selected: selected,
              onChanged: onChanged,
            )),
        GestureDetector(
          onTap: onAddNew,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        RumenoTheme.primaryGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: RumenoTheme.primaryGreen, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Add manually (not in list)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: RumenoTheme.primaryGreen,
                    ),
                  ),
                ),
                if (previousFarmEntry != null)
                  GestureDetector(
                    onTap: () {
                      _showPreviousFarmParentInfo(parentLabel);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Tooltip(
                        message: '$parentLabel info from previous farm',
                        child: const Icon(
                          Icons.info_outline,
                          size: 20,
                          color: RumenoTheme.infoBlue,
                        ),
                      ),
                    ),
                  ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: RumenoTheme.primaryGreen),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _parentTile({
    required _ParentEntry? entry,
    required String? selected,
    required Function(String?) onChanged,
  }) {
    final id = entry?.animalId;
    final sel = selected == id;
    final isNone = entry == null;

    // Lookup actual farm animal by tag if available
    final farmAnimal = (!isNone) ? getAnimalByTag(entry.animalId) : null;

    final parts = <String>[];
    if (!isNone) {
      parts.add(entry.animalId);
      if (farmAnimal != null) {
        parts.add(farmAnimal.breed);
        parts.add(farmAnimal.ageString);
      } else {
        if (entry.location.isNotEmpty) parts.add(entry.location);
        if (entry.ownerName.isNotEmpty) parts.add(entry.ownerName);
      }
    }
    final label = isNone ? "Don't know / None" : parts.join(' · ');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: sel ? RumenoTheme.primaryGreen.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textLight, width: sel ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => onChanged(id),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: sel ? RumenoTheme.primaryGreen.withValues(alpha: 0.15) : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isNone ? Icons.do_not_disturb_alt : Icons.pets,
                      color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textGrey,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                            fontSize: 15,
                            color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
                          ),
                        ),
                        if (farmAnimal != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${farmAnimal.gender == Gender.male ? "♂ Male" : "♀ Female"} • ${farmAnimal.speciesName}',
                            style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (sel)
                    const Icon(Icons.check_circle, color: RumenoTheme.primaryGreen, size: 22)
                  else
                    const Icon(Icons.radio_button_unchecked, color: RumenoTheme.textLight, size: 22),
                ],
              ),
            ),
          ),
          // Action buttons shown when selected and a known farm animal
          if (sel && farmAnimal != null) ...[
            const Divider(height: 1, indent: 14, endIndent: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go('/farmer/animals/${farmAnimal.id}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: RumenoTheme.infoBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.open_in_new_rounded, size: 14, color: RumenoTheme.infoBlue),
                            SizedBox(width: 6),
                            Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RumenoTheme.infoBlue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showParentChildrenSheet(farmAnimal),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: RumenoTheme.warningYellow.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.family_restroom, size: 14, color: RumenoTheme.warmBrown),
                            const SizedBox(width: 6),
                            Text(
                              '${getChildrenOf(farmAnimal.id).length} Offspring',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RumenoTheme.warmBrown),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Step 4 : Farm Assignment ─────────────────
  Widget _buildStep4() {
    const purposes = [
      {
        'v': AnimalPurpose.dairy,
        'e': '🥛',
        'l': 'Dairy',
        'd': 'For milk production',
        'c': RumenoTheme.infoBlue
      },
      {
        'v': AnimalPurpose.meat,
        'e': '🥩',
        'l': 'Meat',
        'd': 'For meat production',
        'c': RumenoTheme.errorRed
      },
      {
        'v': AnimalPurpose.breeding,
        'e': '🐣',
        'l': 'Breeding',
        'd': 'For producing offspring',
        'c': RumenoTheme.accentOlive
      },
      {
        'v': AnimalPurpose.mixed,
        'e': '🌿',
        'l': 'Mixed',
        'd': 'Multiple purposes',
        'c': RumenoTheme.warmBrown
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
            Icons.home_work, 'Where does it live?', 'Shed & purpose'),
        const SizedBox(height: 20),
        _sectionLabel('🏠  Shed / Pen Number'),
        const SizedBox(height: 8),
        _bigTextField(
            _shedController, 'e.g. A1, B3, Shed-2…', Icons.home),
        const SizedBox(height: 24),
        _sectionLabel('🎯  Purpose of this Animal'),
        const SizedBox(height: 12),
        ...purposes.map((p) {
          final sel = _purpose == p['v'];
          final col = p['c'] as Color;
          return GestureDetector(
            onTap: () =>
                setState(() => _purpose = p['v'] as AnimalPurpose),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    sel ? col.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: sel ? col : RumenoTheme.textLight,
                    width: sel ? 2 : 1),
                boxShadow: sel
                    ? [
                        BoxShadow(
                            color: col.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Text(p['e'] as String,
                      style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['l'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color:
                                  sel ? col : RumenoTheme.textDark),
                        ),
                        Text(p['d'] as String,
                            style: TextStyle(
                                color: RumenoTheme.textGrey,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                  if (sel)
                    Icon(Icons.check_circle, color: col, size: 26)
                  else
                    const Icon(Icons.radio_button_unchecked,
                        color: RumenoTheme.textLight, size: 26),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        _sectionLabel('📂  Groups (Optional)'),
        const SizedBox(height: 8),
        _buildGroupMultiSelect(),
        const SizedBox(height: 24),
        _buildSummaryCard(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGroupMultiSelect() {
    final groupProvider = context.watch<GroupProvider>();
    final groups = groupProvider.groups;

    if (groups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RumenoTheme.textLight),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: RumenoTheme.textGrey, size: 20),
            const SizedBox(width: 10),
            Text('No groups available. Create groups first.',
                style: TextStyle(color: RumenoTheme.textGrey, fontSize: 14)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tap-to-open multi-select box
        GestureDetector(
          onTap: () => _showGroupPickerDialog(groupProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _selectedGroupIds.isNotEmpty
                    ? RumenoTheme.primaryGreen
                    : RumenoTheme.textLight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.folder_outlined,
                    color: _selectedGroupIds.isNotEmpty
                        ? RumenoTheme.primaryGreen
                        : RumenoTheme.textGrey,
                    size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedGroupIds.isEmpty
                        ? 'Tap to select groups…'
                        : '${_selectedGroupIds.length} group${_selectedGroupIds.length > 1 ? 's' : ''} selected',
                    style: TextStyle(
                      fontSize: 15,
                      color: _selectedGroupIds.isEmpty
                          ? RumenoTheme.textGrey
                          : RumenoTheme.textDark,
                      fontWeight: _selectedGroupIds.isNotEmpty
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down,
                    color: RumenoTheme.textGrey, size: 26),
              ],
            ),
          ),
        ),
        // Selected groups chips
        if (_selectedGroupIds.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedGroupIds.map((gId) {
              final group = groupProvider.getGroupById(gId);
              if (group == null) return const SizedBox.shrink();
              return Chip(
                label: Text(
                  '${group.name} (${group.animalIds.length})',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
                backgroundColor: RumenoTheme.primaryGreen,
                deleteIconColor: Colors.white70,
                onDeleted: () {
                  setState(() => _selectedGroupIds.remove(gId));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  void _showGroupPickerDialog(GroupProvider groupProvider) {
    final groups = groupProvider.groups;
    // work on a local copy so cancel discards changes
    final tempSelected = List<String>.from(_selectedGroupIds);
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = searchQuery.isEmpty
                ? groups
                : groups
                    .where((g) => g.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList();

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: RumenoTheme.textLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.folder_outlined,
                            color: RumenoTheme.primaryGreen),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Select Groups',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (tempSelected.length == groups.length) {
                              setModalState(() => tempSelected.clear());
                            } else {
                              setModalState(() {
                                tempSelected.clear();
                                tempSelected
                                    .addAll(groups.map((g) => g.id));
                              });
                            }
                          },
                          child: Text(
                            tempSelected.length == groups.length
                                ? 'Deselect All'
                                : 'Select All',
                            style: const TextStyle(
                                color: RumenoTheme.primaryGreen,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      onChanged: (v) => setModalState(() => searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search groups…',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: RumenoTheme.backgroundCream,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${tempSelected.length} selected  •  ${filtered.length} groups',
                        style: TextStyle(
                            fontSize: 12, color: RumenoTheme.textGrey),
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  // List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final group = filtered[i];
                        final isSel = tempSelected.contains(group.id);
                        return CheckboxListTile(
                          value: isSel,
                          activeColor: RumenoTheme.primaryGreen,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(group.name,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                          subtitle: Text(
                            '${group.animalIds.length} animals${group.species != null ? '  •  ${group.species!.name[0].toUpperCase()}${group.species!.name.substring(1)}' : '  •  Mixed'}',
                            style: TextStyle(
                                fontSize: 12, color: RumenoTheme.textGrey),
                          ),
                          onChanged: (_) {
                            setModalState(() {
                              if (isSel) {
                                tempSelected.remove(group.id);
                              } else {
                                tempSelected.add(group.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  // Bottom buttons
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(
                                    color: RumenoTheme.textLight),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedGroupIds = List.from(tempSelected);
                                });
                                Navigator.pop(ctx);
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: RumenoTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                tempSelected.isEmpty
                                    ? 'Done'
                                    : 'Done (${tempSelected.length})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard() {
    const emojis = {
      Species.cow: '🐄',
      Species.buffalo: '🐃',
      Species.goat: '🐐',
      Species.sheep: '🐑',
      Species.pig: '🐷',
      Species.horse: '🐴',
    };
    final specName =
        _species.name[0].toUpperCase() + _species.name.substring(1);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            RumenoTheme.primaryGreen,
            RumenoTheme.primaryDarkGreen
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Summary',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(emojis[_species]!,
                  style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$specName  •  ${_gender == Gender.male ? "♂ Male" : "♀ Female"}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _breedController.text.isEmpty
                          ? 'No breed specified'
                          : _breedController.text,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white30, height: 22),
          Row(
            children: [
              _sumItem('⚖️', '${_weight.round()} kg'),
              _sumItem('📏', '${_height.round()} cm'),
              _sumItem('🏷️', _tagController.text),
              _sumItem('🏠', _shedController.text),
            ],
          ),
          if (_selectedGroupIds.isNotEmpty) ...[
            const Divider(color: Colors.white30, height: 22),
            Row(
              children: [
                const Text('📂', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Builder(builder: (_) {
                    final gp = context.read<GroupProvider>();
                    final names = _selectedGroupIds
                        .map((id) => gp.getGroupById(id)?.name)
                        .whereType<String>()
                        .join(', ');
                    return Text(
                      names,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    );
                  }),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _sumItem(String emoji, String val) => Expanded(
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(val,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      );

  // ── Step 5 : Purchase Info ───────────────────
  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(Icons.shopping_bag_outlined, 'Purchase Info',
            'All fields are optional – fill if purchased'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RumenoTheme.accentOlive.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: RumenoTheme.accentOlive),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Fill the below form if you are purchasing the animal.',
                  style: TextStyle(
                      color: RumenoTheme.accentOlive, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _sectionLabel('📅  Date of Purchase'),
        const SizedBox(height: 8),
        _buildPurchaseDatePicker(),
        const SizedBox(height: 20),
        _sectionLabel('📍  Purchase Location'),
        const SizedBox(height: 8),
        _bigTextField(
            _purchasePlaceController,
            'e.g. Local market, Farmer John, City…',
            Icons.location_on_outlined),
        const SizedBox(height: 20),
        _sectionLabel('👤  Old Owner name'),
        const SizedBox(height: 8),
        _bigTextField(
            _ownerNameController, 'e.g. Ravi Kumar', Icons.person_outline),
        const SizedBox(height: 20),
        _sectionLabel('📞  Old Owner Phone Number'),
        const SizedBox(height: 8),
        _buildPhoneField(),
        const SizedBox(height: 20),
        _sectionLabel('🦷  Age by Tooth'),
        const SizedBox(height: 8),
        _bigTextField(
            _toothAgeController,
            'e.g. 2 teeth, 4 teeth, Full mouth…',
            Icons.settings_outlined),
        const SizedBox(height: 24),
        _buildSummaryCard(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPurchaseDatePicker() {
    final hasDate = _purchaseDate != null;
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: _purchaseDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (d != null) setState(() => _purchaseDate = d);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasDate
                ? RumenoTheme.primaryGreen
                : RumenoTheme.textLight,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month,
                  color: RumenoTheme.primaryGreen, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Purchase',
                    style: TextStyle(
                        color: RumenoTheme.textGrey, fontSize: 12),
                  ),
                  Text(
                    hasDate
                        ? '${_purchaseDate!.day} / ${_purchaseDate!.month} / ${_purchaseDate!.year}'
                        : 'Tap to select date (optional)',
                    style: TextStyle(
                      fontSize: hasDate ? 20 : 14,
                      fontWeight: hasDate
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: hasDate
                          ? RumenoTheme.textDark
                          : RumenoTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (hasDate)
              GestureDetector(
                onTap: () => setState(() => _purchaseDate = null),
                child: const Icon(Icons.close,
                    color: RumenoTheme.textGrey, size: 20),
              )
            else
              const Icon(Icons.chevron_right,
                  color: RumenoTheme.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _ownerPhoneController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'e.g. 9876543210',
        hintStyle:
            const TextStyle(color: RumenoTheme.textLight),
        prefixIcon: const Icon(Icons.phone_outlined,
            color: RumenoTheme.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: RumenoTheme.primaryGreen, width: 2)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
      ),
    );
  }

  // ── Shared helpers ───────────────────────────
  Widget _stepHeader(IconData icon, String title, String sub) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child:
              Icon(icon, color: RumenoTheme.primaryGreen, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: RumenoTheme.textDark)),
              Text(sub,
                  style: const TextStyle(
                      fontSize: 13, color: RumenoTheme.textGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: RumenoTheme.textDark)),
      );

  Widget _bigTextField(
      TextEditingController ctrl, String hint, IconData prefixIcon) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: RumenoTheme.textLight),
        prefixIcon:
            Icon(prefixIcon, color: RumenoTheme.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: RumenoTheme.primaryGreen, width: 2)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
      ),
    );
  }

  // ── Save animal to mock store and navigate to detail ──
  void _saveAnimal() {
    final newId = (mockAnimals.length + 1).toString();
    final newAnimal = Animal(
      id: newId,
      tagId: _tagController.text.trim(),
      species: _species,
      breed: _breedController.text.trim().isEmpty ? 'Unknown' : _breedController.text.trim(),
      dateOfBirth: _dob,
      gender: _gender,
      status: AnimalStatus.active,
      purpose: _purpose,
      weightKg: _weight,
      heightCm: _height,
      color: _selectedColor,
      shedNumber: _shedController.text.trim().isEmpty ? null : _shedController.text.trim(),
      fatherId: _fatherId,
      motherId: _motherId,
      numberOfSiblings: _numberOfSiblings,
      purchaseDate: _purchaseDate,
      farmerId: 'F001',
    );
    mockAnimals.add(newAnimal);
    context.go('/farmer/animals/$newId');
  }

  // ── Bottom navigation bar ────────────────────
  Widget _buildBottomBar() {
    final isLast = _currentStep == _stepMeta.length - 1;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () => _goToStep(_currentStep - 1),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                        color: RumenoTheme.primaryGreen),
                    foregroundColor: RumenoTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (isLast) {
                    _saveAnimal();
                  } else {
                    _goToStep(_currentStep + 1);
                  }
                },
                icon: Icon(
                    isLast ? Icons.check : Icons.arrow_forward),
                label: Text(
                  isLast ? 'Save Animal' : 'Next Step',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isLast
                      ? RumenoTheme.successGreen
                      : RumenoTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentEntry {
  final String animalId;
  final String location;
  final String ownerName;

  const _ParentEntry({
    required this.animalId,
    this.location = '',
    this.ownerName = '',
  });
}
