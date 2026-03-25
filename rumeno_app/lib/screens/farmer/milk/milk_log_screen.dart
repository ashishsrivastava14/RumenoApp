import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_milk.dart';
import '../../../models/models.dart';

class MilkLogScreen extends StatefulWidget {
  const MilkLogScreen({super.key});

  @override
  State<MilkLogScreen> createState() => _MilkLogScreenState();
}

class _MilkLogScreenState extends State<MilkLogScreen> {
  MilkSession _selectedSession = MilkSession.morning;
  DateTime _selectedDate = DateTime.now();
  Animal? _selectedAnimal;
  final _quantityController = TextEditingController();
  int _currentStep = 0; // 0=session, 1=animal, 2=quantity, 3=confirm

  late List<Animal> _dairyAnimals;

  @override
  void initState() {
    super.initState();
    _dairyAnimals = getDairyAnimals(mockAnimals);
    // Auto-detect session based on time of day
    final hour = DateTime.now().hour;
    _selectedSession = hour < 14 ? MilkSession.morning : MilkSession.evening;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _saveMilkRecord() {
    if (_selectedAnimal == null || _quantityController.text.isEmpty) return;

    final qty = double.tryParse(_quantityController.text);
    if (qty == null || qty <= 0) return;

    final record = MilkRecord(
      id: 'MLK${DateTime.now().millisecondsSinceEpoch}',
      animalId: _selectedAnimal!.id,
      date: _selectedDate,
      session: _selectedSession,
      quantityLitres: qty,
    );

    mockMilkRecords.add(record);

    // Show success and reset
    _showSuccess(record);
  }

  void _showSuccess(MilkRecord record) {
    final animal = mockAnimals.firstWhere((a) => a.id == record.animalId);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF4CAF50), size: 56),
              ),
              const SizedBox(height: 20),
              const Text(
                'Saved!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
              // Visual summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getSpeciesIcon(animal.species),
                      size: 32,
                      color: const Color(0xFF1565C0),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.tagId,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${record.quantityLitres} L  •  ${record.sessionLabel}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.pop();
                      },
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        setState(() {
                          _currentStep = 1; // Go back to animal selection
                          _selectedAnimal = null;
                          _quantityController.clear();
                        });
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add More'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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

  IconData _getSpeciesIcon(Species species) {
    switch (species) {
      case Species.cow:
        return Icons.pets_rounded;
      case Species.buffalo:
        return Icons.pets_rounded;
      case Species.goat:
        return Icons.pets_rounded;
      default:
        return Icons.pets_rounded;
    }
  }

  String _getSpeciesEmoji(Species species) {
    switch (species) {
      case Species.cow:
        return '🐄';
      case Species.buffalo:
        return '🐃';
      case Species.goat:
        return '🐐';
      default:
        return '🐾';
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayTotal = totalMilkForDate(_selectedDate);
    final todayRecords = milkRecordsForDate(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _buildHeader(todayTotal, todayRecords.length),

            // ── Step Indicator ──
            _buildStepIndicator(),

            // ── Main Content ──
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double todayTotal, int recordCount) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 8, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Title bar
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 26),
              ),
              Expanded(
                child: Text(
                  l10n.milkLogTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Date selector
              GestureDetector(
                onTap: () => _pickDate(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        _isToday(_selectedDate)
                            ? l10n.commonToday
                            : DateFormat('dd MMM').format(_selectedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Today's summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SummaryBubble(
                icon: Icons.water_drop_rounded,
                value: '${todayTotal.toStringAsFixed(1)}L',
                label: 'Total',
              ),
              _SummaryBubble(
                icon: Icons.format_list_numbered_rounded,
                value: '$recordCount',
                label: 'Entries',
              ),
              _SummaryBubble(
                icon: Icons.pets_rounded,
                value: '${_dairyAnimals.length}',
                label: 'Animals',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    const labels = ['Time', 'Animal', 'Litres', 'Done'];
    const icons = [
      Icons.schedule_rounded,
      Icons.pets_rounded,
      Icons.water_drop_rounded,
      Icons.check_circle_rounded,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(7, (index) {
          // Even indices = circles (0,2,4,6), odd indices = lines (1,3,5)
          if (index.isEven) {
            final i = index ~/ 2;
            final isActive = i == _currentStep;
            final isDone = i < _currentStep;
            final color = isDone
                ? const Color(0xFF4CAF50)
                : isActive
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFBDBDBD);

            return GestureDetector(
              onTap: isDone ? () => setState(() => _currentStep = i) : null,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isActive ? 0.15 : isDone ? 0.15 : 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color,
                        width: isActive ? 2.5 : 1.5,
                      ),
                    ),
                    child: Icon(
                      isDone ? Icons.check_rounded : icons[i],
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Line between circles
            final leftStep = index ~/ 2;
            final isDone = leftStep < _currentStep;
            return Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(bottom: 18),
                color: isDone ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildSessionStep();
      case 1:
        return _buildAnimalStep();
      case 2:
        return _buildQuantityStep();
      case 3:
        return _buildConfirmStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── STEP 1: Select Morning / Evening ──
  Widget _buildSessionStep() {
    return SingleChildScrollView(
      key: const ValueKey('session'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Big instruction text
          const Text(
            'When did you milk?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap to select morning or evening',
            style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 32),
          // Morning button
          _SessionButton(
            icon: Icons.wb_sunny_rounded,
            emoji: '🌅',
            label: 'Morning',
            sublabel: '',
            isSelected: _selectedSession == MilkSession.morning,
            color: const Color(0xFFFF9800),
            onTap: () {
              setState(() => _selectedSession = MilkSession.morning);
              Future.delayed(const Duration(milliseconds: 250), _nextStep);
            },
          ),
          const SizedBox(height: 16),
          // Evening button
          _SessionButton(
            icon: Icons.nights_stay_rounded,
            emoji: '🌙',
            label: 'Evening',
            sublabel: '',
            isSelected: _selectedSession == MilkSession.evening,
            color: const Color(0xFF5C6BC0),
            onTap: () {
              setState(() => _selectedSession = MilkSession.evening);
              Future.delayed(const Duration(milliseconds: 250), _nextStep);
            },
          ),
          const SizedBox(height: 24),
          // Today's records preview
          _buildTodayRecordsPreview(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTodayRecordsPreview() {
    final records = milkRecordsForDate(_selectedDate);
    if (records.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, size: 18, color: Color(0xFF1565C0)),
              const SizedBox(width: 6),
              Text(
                'Today\'s Entries (${records.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: records.length > 6 ? 6 : records.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final r = records[i];
                final animal = mockAnimals.firstWhere((a) => a.id == r.animalId);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getSpeciesEmoji(animal.species), style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        '${animal.tagId} ${r.quantityLitres}L',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 2: Select Animal ──
  Widget _buildAnimalStep() {
    return Padding(
      key: const ValueKey('animal'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'Which animal?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap on the animal you milked',
            style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.45,
              ),
              itemCount: _dairyAnimals.length,
              itemBuilder: (ctx, i) {
                final animal = _dairyAnimals[i];
                final isSelected = _selectedAnimal?.id == animal.id;
                // Check if already logged today for this session
                final alreadyLogged = mockMilkRecords.any((r) =>
                    r.animalId == animal.id &&
                    r.session == _selectedSession &&
                    r.date.year == _selectedDate.year &&
                    r.date.month == _selectedDate.month &&
                    r.date.day == _selectedDate.day);

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAnimal = animal);
                    Future.delayed(const Duration(milliseconds: 200), _nextStep);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1565C0).withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1565C0)
                            : Colors.grey.shade200,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _getSpeciesEmoji(animal.species),
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          animal.tagId,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D2D2D),
                                          ),
                                        ),
                                        Text(
                                          animal.breed,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF888888),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _speciesColor(animal.species)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      animal.speciesName,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _speciesColor(animal.species),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (animal.shedNumber != null)
                                    Text(
                                      'Shed ${animal.shedNumber}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFAAAAAA),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (alreadyLogged)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '✓ Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Back button
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: _NavButton(
              label: 'Back',
              icon: Icons.arrow_back_rounded,
              isPrimary: false,
              onTap: _prevStep,
            ),
          ),
        ],
      ),
    );
  }

  Color _speciesColor(Species species) {
    switch (species) {
      case Species.cow:
        return const Color(0xFF8D6E63);
      case Species.buffalo:
        return const Color(0xFF455A64);
      case Species.goat:
        return const Color(0xFFFF8F00);
      default:
        return const Color(0xFF78909C);
    }
  }

  // ── STEP 3: Enter Quantity ──
  Widget _buildQuantityStep() {
    return Column(
      key: const ValueKey('quantity'),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'How many litres?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 8),
                // Show selected animal
                if (_selectedAnimal != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getSpeciesEmoji(_selectedAnimal!.species),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedAnimal!.tagId}  •  ${_selectedSession == MilkSession.morning ? '🌅 Morning' : '🌙 Evening'}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),

                // Big quantity input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.water_drop_rounded,
                              color: Color(0xFF1565C0), size: 36),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFCCCCCC),
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Litres',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Quick quantity buttons
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [2, 4, 6, 8, 10, 12, 15, 20].map((q) {
                          return GestureDetector(
                            onTap: () {
                              _quantityController.text = q.toString();
                              setState(() {});
                            },
                            child: Container(
                              width: 60,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _quantityController.text == q.toString()
                                    ? const Color(0xFF1565C0)
                                    : const Color(0xFFF0F4FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _quantityController.text == q.toString()
                                      ? const Color(0xFF1565C0)
                                      : const Color(0xFFDDDDDD),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${q}L',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _quantityController.text == q.toString()
                                        ? Colors.white
                                        : const Color(0xFF1565C0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Navigation buttons pinned at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: _NavButton(
                  label: 'Back',
                  icon: Icons.arrow_back_rounded,
                  isPrimary: false,
                  onTap: _prevStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _NavButton(
                  label: 'Next',
                  icon: Icons.arrow_forward_rounded,
                  isPrimary: true,
                  isEnabled: _quantityController.text.isNotEmpty &&
                      (double.tryParse(_quantityController.text) ?? 0) > 0,
                  onTap: _nextStep,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── STEP 4: Confirm & Save ──
  Widget _buildConfirmStep() {
    final qty = double.tryParse(_quantityController.text) ?? 0;

    return Column(
      key: const ValueKey('confirm'),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Is this correct?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check and tap Save',
                  style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
                ),
                const SizedBox(height: 28),
          // Summary card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Animal info
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          _selectedAnimal != null
                              ? _getSpeciesEmoji(_selectedAnimal!.species)
                              : '',
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedAnimal?.tagId ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        Text(
                          '${_selectedAnimal?.breed ?? ''} ${_selectedAnimal?.speciesName ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 32),
                // Details rows
                _ConfirmRow(
                  icon: _selectedSession == MilkSession.morning
                      ? Icons.wb_sunny_rounded
                      : Icons.nights_stay_rounded,
                  label: 'Session',
                  value: _selectedSession == MilkSession.morning
                      ? '🌅 Morning'
                      : '🌙 Evening',
                  color: _selectedSession == MilkSession.morning
                      ? const Color(0xFFFF9800)
                      : const Color(0xFF5C6BC0),
                ),
                const SizedBox(height: 14),
                _ConfirmRow(
                  icon: Icons.water_drop_rounded,
                  label: 'Quantity',
                  value: '${qty.toStringAsFixed(1)} Litres',
                  color: const Color(0xFF1565C0),
                ),
                const SizedBox(height: 14),
                _ConfirmRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: DateFormat('dd MMM yyyy').format(_selectedDate),
                  color: const Color(0xFF4CAF50),
                ),
              ],
            ),
          ),
              ],
            ),
          ),
        ),
        // Action buttons pinned at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: _NavButton(
                  label: 'Back',
                  icon: Icons.arrow_back_rounded,
                  isPrimary: false,
                  onTap: _prevStep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _NavButton(
                  label: 'Save',
                  icon: Icons.check_rounded,
                  isPrimary: true,
                  color: const Color(0xFF4CAF50),
                  onTap: _saveMilkRecord,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// ─────────────────────────────────────────────────────────────
//  HELPER WIDGETS
// ─────────────────────────────────────────────────────────────

class _SummaryBubble extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryBubble({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionButton extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String label;
  final String sublabel;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _SessionButton({
    required this.icon,
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? color : const Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? color.withValues(alpha: 0.7)
                        : const Color(0xFF999999),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 32),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ConfirmRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF999999),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isEnabled;
  final Color? color;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    this.isEnabled = true,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? const Color(0xFF1565C0);

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary
              ? (isEnabled ? btnColor : btnColor.withValues(alpha: 0.3))
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(color: Colors.grey.shade300),
          boxShadow: isPrimary && isEnabled
              ? [
                  BoxShadow(
                    color: btnColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : const Color(0xFF666666),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isPrimary
                    ? Colors.white
                    : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
