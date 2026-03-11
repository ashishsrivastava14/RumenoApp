import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';
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

  // Step 3
  String? _fatherId;
  String? _motherId;

  // Step 4
  final _shedController = TextEditingController(text: 'A1');
  AnimalPurpose _purpose = AnimalPurpose.dairy;

  static const _stepMeta = [
    {'icon': Icons.pets, 'title': 'Which Animal?', 'sub': 'Type & basic info'},
    {'icon': Icons.monitor_weight, 'title': 'How it looks?', 'sub': 'Size & color'},
    {'icon': Icons.family_restroom, 'title': 'Family', 'sub': 'Parents (optional)'},
    {'icon': Icons.home_work, 'title': 'Where it lives?', 'sub': 'Shed & purpose'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _breedController.dispose();
    _tagController.dispose();
    _shedController.dispose();
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
        title: const Text('Add New Animal'),
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
                activeColor: RumenoTheme.primaryGreen,
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
        _sliderCard(
            value: _weight,
            min: 10,
            max: 1000,
            unit: 'kg',
            icon: Icons.scale,
            onChanged: (v) => setState(() => _weight = v)),
        const SizedBox(height: 20),
        _sectionLabel('📏  Height'),
        const SizedBox(height: 8),
        _sliderCard(
            value: _height,
            min: 30,
            max: 220,
            unit: 'cm',
            icon: Icons.height,
            onChanged: (v) => setState(() => _height = v)),
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

  Widget _sliderCard({
    required double value,
    required double min,
    required double max,
    required String unit,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: RumenoTheme.primaryGreen, size: 28),
              const SizedBox(width: 10),
              Text(
                '${value.round()} $unit',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: RumenoTheme.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 5).round(),
            activeColor: RumenoTheme.primaryGreen,
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.round()} $unit',
                  style: const TextStyle(
                      color: RumenoTheme.textGrey, fontSize: 12)),
              Text('${max.round()} $unit',
                  style: const TextStyle(
                      color: RumenoTheme.textGrey, fontSize: 12)),
            ],
          ),
        ],
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

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo upload coming soon!'))),
      child: Container(
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
            'Father', ['C-007', 'B-005'], _fatherId,
            (v) => setState(() => _fatherId = v)),
        const SizedBox(height: 24),
        _sectionLabel('🐄  Mother (Cow)'),
        const SizedBox(height: 8),
        _parentSelector(
            'Mother', ['C-001', 'C-002', 'C-003'], _motherId,
            (v) => setState(() => _motherId = v)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _parentSelector(String type, List<String> ids, String? selected,
      Function(String?) onChanged) {
    return Column(
      children: [
        _parentTile(null, 'Don\'t know / None', Icons.do_not_disturb_alt,
            selected, onChanged),
        ...ids.map((id) => _parentTile(
            id, 'Animal $id', Icons.pets, selected, onChanged)),
      ],
    );
  }

  Widget _parentTile(String? id, String label, IconData icon,
      String? selected, Function(String?) onChanged) {
    final sel = selected == id;
    return GestureDetector(
      onTap: () => onChanged(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel
              ? RumenoTheme.primaryGreen.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color:
                  sel ? RumenoTheme.primaryGreen : RumenoTheme.textLight,
              width: sel ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sel
                    ? RumenoTheme.primaryGreen.withValues(alpha: 0.15)
                    : RumenoTheme.backgroundCream,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: sel
                      ? RumenoTheme.primaryGreen
                      : RumenoTheme.textGrey,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight:
                      sel ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                  color: sel
                      ? RumenoTheme.primaryGreen
                      : RumenoTheme.textDark,
                ),
              ),
            ),
            if (sel)
              const Icon(Icons.check_circle,
                  color: RumenoTheme.primaryGreen, size: 22)
            else
              const Icon(Icons.radio_button_unchecked,
                  color: RumenoTheme.textLight, size: 22),
          ],
        ),
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
        _buildSummaryCard(),
        const SizedBox(height: 16),
      ],
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.white),
                            SizedBox(width: 10),
                            Text('Animal added successfully! 🎉'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    context.pop();
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
