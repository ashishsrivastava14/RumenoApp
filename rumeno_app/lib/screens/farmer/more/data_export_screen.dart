import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/common/marketplace_button.dart';

class DataExportScreen extends StatefulWidget {
  const DataExportScreen({super.key});

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen> {
  // ─── Tab ───
  int _tabIndex = 0; // 0 = Farm Data, 1 = Sell Animal

  // ─── Common ───
  String _format = 'PDF';
  bool _exporting = false;
  DateTimeRange? _dateRange;

  // ─── Farm Data Export ───
  final Set<String> _selectedCategories = {};
  bool _includeMedicalHistory = true;
  String? _selectedGroupId;

  // Category-specific filters
  final Set<Species> _speciesFilter = {};
  final Set<AnimalStatus> _statusFilter = {};
  final Set<AnimalPurpose> _purposeFilter = {};
  final Set<String> _ageRangeFilter = {};
  final Set<String> _animalEventFilter = {};
  final Set<VaccinationStatus> _vaccinationStatusFilter = {};
  final Set<TreatmentStatus> _treatmentStatusFilter = {};
  final Set<DewormingStatus> _dewormingStatusFilter = {};
  final Set<LabReportStatus> _labReportStatusFilter = {};
  final Set<ExpenseCategory> _expenseCategoryFilter = {};
  final Set<PaymentMode> _paymentModeFilter = {};
  final Set<MilkSession> _milkSessionFilter = {};
  bool _breedingPregnantOnly = false;

  // ─── Sell Animal Export ───
  final Set<String> _selectedAnimalIds = {};
  bool _sellIncludeHealth = true;
  bool _sellIncludeBreeding = true;
  bool _sellIncludeFinance = true;
  bool _sellIncludeMilk = true;

  // ─── Export categories config ───
  static const _exportCategories = [
    {
      'key': 'animals',
      'emoji': '🐄',
      'title': 'Animals',
      'subtitle': 'All animal records',
      'color': Color(0xFF4CAF50),
    },
    {
      'key': 'health',
      'emoji': '🩺',
      'title': 'Health',
      'subtitle': 'Vaccination, Treatment\nDeworming & Lab Reports',
      'color': Color(0xFFE53935),
    },
    {
      'key': 'breeding',
      'emoji': '🐣',
      'title': 'Breeding',
      'subtitle': 'Breeding records',
      'color': Color(0xFFFF9800),
    },
    {
      'key': 'finance',
      'emoji': '💰',
      'title': 'Finance',
      'subtitle': 'Income & expenses',
      'color': Color(0xFF2196F3),
    },
    {
      'key': 'milk',
      'emoji': '🥛',
      'title': 'Milk Records',
      'subtitle': 'Daily milk data',
      'color': Color(0xFF00BCD4),
    },
    {
      'key': 'team',
      'emoji': '👥',
      'title': 'Team',
      'subtitle': 'Team members list',
      'color': Color(0xFF9C27B0),
    },
  ];

  static const _ageRangeOptions = [
    {'key': 'under_1m', 'emoji': '🐣', 'label': 'Under 1 Month'},
    {'key': '1_3m', 'emoji': '🍼', 'label': '1 – 3 Months'},
    {'key': '3_6m', 'emoji': '🐄', 'label': '3 – 6 Months'},
    {'key': '6_9m', 'emoji': '🐄', 'label': '6 – 9 Months'},
    {'key': '9_12m', 'emoji': '🐄', 'label': '9 – 12 Months'},
    {'key': '12_18m', 'emoji': '🐄', 'label': '12 – 18 Months'},
    {'key': '18_24m', 'emoji': '🐄', 'label': '18 – 24 Months'},
    {'key': '24_plus', 'emoji': '🐃', 'label': '24+ Months'},
  ];

  static const _animalEventOptions = [
    {'key': 'castration', 'emoji': '✂️', 'label': 'Castration', 'color': Color(0xFF795548)},
    {'key': 'mortality', 'emoji': '💀', 'label': 'Mortality', 'color': Color(0xFF616161)},
    {'key': 'sell', 'emoji': '💰', 'label': 'Sell', 'color': Color(0xFFFF9800)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).exportTitle),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTabSelector(),
            const SizedBox(height: 20),
            if (_tabIndex == 0) ..._buildFarmDataTab(),
            if (_tabIndex == 1) ..._buildSellAnimalTab(),
          ],
        ),
      ),
    );
  }

  // ─── Header Banner ───
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF00838F)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('📋', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          const Text(
            'Save Your Farm Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select what you want to download',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab Selector ───
  Widget _buildTabSelector() {
    return Container(
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
      child: Row(
        children: [
          _buildTab(0, '📋', 'Farm Data', const Color(0xFF00BCD4)),
          _buildTab(1, '🐄', 'Sell Animal', const Color(0xFFFF9800)),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String emoji, String label, Color color) {
    final selected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: selected
                ? Border.all(color: color, width: 2)
                : Border.all(color: Colors.transparent),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? color : RumenoTheme.textGrey,
                ),
              ),
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(Icons.check_circle, color: color, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  TAB 1: FARM DATA EXPORT
  // ═══════════════════════════════════════════════════════
  List<Widget> _buildFarmDataTab() {
    return [
      // ── Date Range ──
      _buildSectionTitle('📅', 'Date Range'),
      const SizedBox(height: 8),
      _buildDateRangePicker(),
      const SizedBox(height: 24),

      // ── Group Filter ──
      _buildSectionTitle('📂', 'Group'),
      const SizedBox(height: 8),
      _buildGroupFilter(),
      const SizedBox(height: 24),

      // ── Select Data Categories ──
      _buildCategoryHeader(),
      const SizedBox(height: 10),
      _buildCategoryGrid(),
      const SizedBox(height: 20),

      // ── Category-specific filters ──
      if (_selectedCategories.isNotEmpty) ...[
        _buildSectionTitle('🔍', 'Filters'),
        const SizedBox(height: 8),
        _buildInfoBanner(
          '👆 Tap to select filters. Leave empty = export all',
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        if (_selectedCategories.contains('animals')) _buildAnimalFilters(),
        if (_selectedCategories.contains('health')) _buildHealthFilters(),
        if (_selectedCategories.contains('breeding')) _buildBreedingFilters(),
        if (_selectedCategories.contains('finance')) _buildFinanceFilters(),
        if (_selectedCategories.contains('milk')) _buildMilkFilters(),
        const SizedBox(height: 16),

        // ── Medical History Toggle ──
        _buildMedicalHistoryToggle(),
        const SizedBox(height: 20),
      ],

      // ── Format Selection ──

      _buildFormatSelection(),
      const SizedBox(height: 24),

      // ── Export Button ──
      _buildExportButton(
        enabled: _selectedCategories.isNotEmpty,
        label: _selectedCategories.isEmpty
            ? 'Select Data First'
            : 'Download ${_selectedCategories.length} item(s)',
      ),
      const SizedBox(height: 16),
    ];
  }

  // ─── Date Range Picker ───
  Widget _buildDateRangePicker() {
    return GestureDetector(
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime(2027),
          initialDateRange: _dateRange,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: RumenoTheme.primaryGreen,
                ),
              ),
              child: child!,
            );
          },
        );
        if (range != null) setState(() => _dateRange = range);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _dateRange != null
              ? RumenoTheme.primaryGreen.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _dateRange != null
                ? RumenoTheme.primaryGreen
                : Colors.grey.shade300,
            width: _dateRange != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('📅', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dateRange != null ? 'Date Selected' : 'Select Date Range',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _dateRange != null
                          ? RumenoTheme.primaryGreen
                          : RumenoTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _dateRange != null
                        ? '${_fmtDate(_dateRange!.start)}  ➜  ${_fmtDate(_dateRange!.end)}'
                        : 'Tap to choose start & end date',
                    style: TextStyle(
                      fontSize: 13,
                      color: _dateRange != null
                          ? RumenoTheme.primaryDarkGreen
                          : RumenoTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (_dateRange != null)
              GestureDetector(
                onTap: () => setState(() => _dateRange = null),
                child: const Icon(Icons.close, color: Colors.grey, size: 20),
              )
            else
              Icon(Icons.calendar_month,
                  color: RumenoTheme.primaryGreen, size: 22),
          ],
        ),
      ),
    );
  }

  // ─── Group Filter ───
  Widget _buildGroupFilter() {
    final groupProvider = context.watch<GroupProvider>();
    final groups = groupProvider.groups;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _selectedGroupId != null
            ? RumenoTheme.primaryGreen.withValues(alpha: 0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _selectedGroupId != null
              ? RumenoTheme.primaryGreen
              : Colors.grey.shade300,
          width: _selectedGroupId != null ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedGroupId,
                hint: const Text(
                  '📂 Filter by Group',
                  style: TextStyle(fontSize: 14, color: RumenoTheme.textGrey),
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down,
                    color: RumenoTheme.textGrey),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Animals',
                        style: TextStyle(fontSize: 14)),
                  ),
                  ...groups.map((g) => DropdownMenuItem<String?>(
                        value: g.id,
                        child: Text(
                          '${g.name} (${g.animalIds.length})',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ],
                onChanged: (val) => setState(() => _selectedGroupId = val),
              ),
            ),
          ),
          if (_selectedGroupId != null)
            GestureDetector(
              onTap: () => setState(() => _selectedGroupId = null),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close,
                    size: 18, color: RumenoTheme.errorRed),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Category Header with Select All ───
  Widget _buildCategoryHeader() {
    return Row(
      children: [
        const Text('📂', style: TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        const Text('Select Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(
          onPressed: () {
            setState(() {
              if (_selectedCategories.length == _exportCategories.length) {
                _selectedCategories.clear();
              } else {
                _selectedCategories.addAll(
                    _exportCategories.map((e) => e['key'] as String));
              }
            });
          },
          child: Text(
            _selectedCategories.length == _exportCategories.length
                ? 'Deselect All'
                : 'Select All',
            style: TextStyle(
                color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ─── Category Grid ───
  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: _exportCategories.map((opt) {
        final key = opt['key'] as String;
        final sel = _selectedCategories.contains(key);
        final color = opt['color'] as Color;
        return GestureDetector(
          onTap: () => setState(
              () => sel ? _selectedCategories.remove(key) : _selectedCategories.add(key)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: sel ? color.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: sel ? color : Colors.grey.shade200,
                  width: sel ? 2.5 : 1),
              boxShadow: sel
                  ? [
                      BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(opt['emoji'] as String,
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 6),
                      Text(
                        opt['title'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: sel ? color : RumenoTheme.textDark,
                        ),
                      ),
                      Text(
                        opt['subtitle'] as String,
                        style:
                            TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (sel)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.check_circle, color: color, size: 22),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Animal Filters ───
  Widget _buildAnimalFilters() {
    return _buildFilterCard(
      emoji: '🐄',
      title: 'Animal Filters',
      color: const Color(0xFF4CAF50),
      children: [
        _buildFilterSubtitle('Type'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Species.values.map((s) {
            final icons = {
              Species.cow: '🐄',
              Species.buffalo: '🐃',
              Species.goat: '🐐',
              Species.sheep: '🐑',
              Species.pig: '🐷',
              Species.horse: '🐴',
            };
            return _buildIconChip(
              emoji: icons[s]!,
              label: s.name[0].toUpperCase() + s.name.substring(1),
              selected: _speciesFilter.contains(s),
              color: const Color(0xFF4CAF50),
              onTap: () => setState(() => _speciesFilter.contains(s)
                  ? _speciesFilter.remove(s)
                  : _speciesFilter.add(s)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('Health Status'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AnimalStatus.values.map((s) {
            final info = _animalStatusInfo(s);
            return _buildIconChip(
              emoji: info['emoji']!,
              label: info['label']!,
              selected: _statusFilter.contains(s),
              color: _animalStatusColor(s),
              onTap: () => setState(() => _statusFilter.contains(s)
                  ? _statusFilter.remove(s)
                  : _statusFilter.add(s)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('Purpose'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AnimalPurpose.values.map((p) {
            final icons = {
              AnimalPurpose.dairy: '🥛',
              AnimalPurpose.meat: '🥩',
              AnimalPurpose.breeding: '🐣',
              AnimalPurpose.mixed: '🔄',
            };
            return _buildIconChip(
              emoji: icons[p]!,
              label: p.name[0].toUpperCase() + p.name.substring(1),
              selected: _purposeFilter.contains(p),
              color: const Color(0xFF4CAF50),
              onTap: () => setState(() => _purposeFilter.contains(p)
                  ? _purposeFilter.remove(p)
                  : _purposeFilter.add(p)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('Age Group'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _ageRangeOptions.map((opt) {
            final key = opt['key'] as String;
            return _buildIconChip(
              emoji: opt['emoji'] as String,
              label: opt['label'] as String,
              selected: _ageRangeFilter.contains(key),
              color: const Color(0xFF4CAF50),
              onTap: () => setState(() => _ageRangeFilter.contains(key)
                  ? _ageRangeFilter.remove(key)
                  : _ageRangeFilter.add(key)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('Animal Events'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _animalEventOptions.map((opt) {
            final key = opt['key'] as String;
            return _buildIconChip(
              emoji: opt['emoji'] as String,
              label: opt['label'] as String,
              selected: _animalEventFilter.contains(key),
              color: opt['color'] as Color,
              onTap: () => setState(() => _animalEventFilter.contains(key)
                  ? _animalEventFilter.remove(key)
                  : _animalEventFilter.add(key)),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Health Filters ───
  Widget _buildHealthFilters() {
    return _buildFilterCard(
      emoji: '🩺',
      title: 'Health Filters',
      color: const Color(0xFFE53935),
      children: [
        _buildFilterSubtitle('💉 Vaccination Status'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: VaccinationStatus.values.map((s) {
            final info = _vaccStatusInfo(s);
            return _buildIconChip(
              emoji: info['emoji']!,
              label: info['label']!,
              selected: _vaccinationStatusFilter.contains(s),
              color: _vaccStatusColor(s),
              onTap: () => setState(() =>
                  _vaccinationStatusFilter.contains(s)
                      ? _vaccinationStatusFilter.remove(s)
                      : _vaccinationStatusFilter.add(s)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('💊 Treatment Status'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TreatmentStatus.values.map((s) {
            final info = _treatStatusInfo(s);
            return _buildIconChip(
              emoji: info['emoji']!,
              label: info['label']!,
              selected: _treatmentStatusFilter.contains(s),
              color: _treatStatusColor(s),
              onTap: () => setState(() =>
                  _treatmentStatusFilter.contains(s)
                      ? _treatmentStatusFilter.remove(s)
                      : _treatmentStatusFilter.add(s)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('🪱 Deworming Status'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DewormingStatus.values.map((s) {
            final info = _dewormStatusInfo(s);
            return _buildIconChip(
              emoji: info['emoji']!,
              label: info['label']!,
              selected: _dewormingStatusFilter.contains(s),
              color: _dewormStatusColor(s),
              onTap: () => setState(() =>
                  _dewormingStatusFilter.contains(s)
                      ? _dewormingStatusFilter.remove(s)
                      : _dewormingStatusFilter.add(s)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('🔬 Lab Report Status'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: LabReportStatus.values.map((s) {
            final info = _labStatusInfo(s);
            return _buildIconChip(
              emoji: info['emoji']!,
              label: info['label']!,
              selected: _labReportStatusFilter.contains(s),
              color: _labStatusColor(s),
              onTap: () => setState(() =>
                  _labReportStatusFilter.contains(s)
                      ? _labReportStatusFilter.remove(s)
                      : _labReportStatusFilter.add(s)),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Breeding Filters ───
  Widget _buildBreedingFilters() {
    return _buildFilterCard(
      emoji: '🐣',
      title: 'Breeding Filters',
      color: const Color(0xFFFF9800),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildIconChip(
              emoji: '🤰',
              label: 'Pregnant Only',
              selected: _breedingPregnantOnly,
              color: const Color(0xFFFF9800),
              onTap: () => setState(
                  () => _breedingPregnantOnly = !_breedingPregnantOnly),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Finance Filters ───
  Widget _buildFinanceFilters() {
    return _buildFilterCard(
      emoji: '💰',
      title: 'Finance Filters',
      color: const Color(0xFF2196F3),
      children: [
        _buildFilterSubtitle('Expense Type'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ExpenseCategory.values.map((c) {
            final icons = {
              ExpenseCategory.feed: '🌾',
              ExpenseCategory.medicine: '💊',
              ExpenseCategory.veterinary: '🩺',
              ExpenseCategory.labour: '👷',
              ExpenseCategory.equipment: '🔧',
              ExpenseCategory.transport: '🚛',
              ExpenseCategory.other: '📦',
            };
            return _buildIconChip(
              emoji: icons[c]!,
              label: c.name[0].toUpperCase() + c.name.substring(1),
              selected: _expenseCategoryFilter.contains(c),
              color: const Color(0xFF2196F3),
              onTap: () => setState(() => _expenseCategoryFilter.contains(c)
                  ? _expenseCategoryFilter.remove(c)
                  : _expenseCategoryFilter.add(c)),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildFilterSubtitle('Payment Mode'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PaymentMode.values.map((m) {
            final icons = {
              PaymentMode.cash: '💵',
              PaymentMode.upi: '📱',
              PaymentMode.bank: '🏦',
              PaymentMode.credit: '💳',
            };
            return _buildIconChip(
              emoji: icons[m]!,
              label: m.name.toUpperCase(),
              selected: _paymentModeFilter.contains(m),
              color: const Color(0xFF2196F3),
              onTap: () => setState(() => _paymentModeFilter.contains(m)
                  ? _paymentModeFilter.remove(m)
                  : _paymentModeFilter.add(m)),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Milk Filters ───
  Widget _buildMilkFilters() {
    return _buildFilterCard(
      emoji: '🥛',
      title: 'Milk Filters',
      color: const Color(0xFF00BCD4),
      children: [
        _buildFilterSubtitle('Session'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildIconChip(
              emoji: '🌅',
              label: 'Morning',
              selected: _milkSessionFilter.contains(MilkSession.morning),
              color: const Color(0xFFFF9800),
              onTap: () => setState(() =>
                  _milkSessionFilter.contains(MilkSession.morning)
                      ? _milkSessionFilter.remove(MilkSession.morning)
                      : _milkSessionFilter.add(MilkSession.morning)),
            ),
            _buildIconChip(
              emoji: '🌆',
              label: 'Evening',
              selected: _milkSessionFilter.contains(MilkSession.evening),
              color: const Color(0xFF5C6BC0),
              onTap: () => setState(() =>
                  _milkSessionFilter.contains(MilkSession.evening)
                      ? _milkSessionFilter.remove(MilkSession.evening)
                      : _milkSessionFilter.add(MilkSession.evening)),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Medical History Toggle ───
  Widget _buildMedicalHistoryToggle() {
    return GestureDetector(
      onTap: () =>
          setState(() => _includeMedicalHistory = !_includeMedicalHistory),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _includeMedicalHistory
              ? const Color(0xFFE8F5E9)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _includeMedicalHistory
                ? const Color(0xFF4CAF50)
                : Colors.grey.shade300,
            width: _includeMedicalHistory ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              _includeMedicalHistory ? '📋' : '📄',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Include Medical History',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Vaccination, Treatment, Deworming, Lab Reports for each animal',
                    style: TextStyle(
                        fontSize: 12, color: RumenoTheme.textGrey),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: _includeMedicalHistory
                    ? const Color(0xFF4CAF50)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _includeMedicalHistory
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  TAB 2: SELL ANIMAL EXPORT
  // ═══════════════════════════════════════════════════════
  List<Widget> _buildSellAnimalTab() {
    return [
      // Info banner
      _buildInfoBanner(
        '🐄 Select animals you want to sell.\nExport their full details for the buyer.',
        const Color(0xFFFF9800),
      ),
      const SizedBox(height: 20),

      // ── Date Range ──
      _buildSectionTitle('📅', 'Date Range'),
      const SizedBox(height: 8),
      _buildDateRangePicker(),
      const SizedBox(height: 24),

      // ── Animal Selection ──
      _buildSectionTitle('🐄', 'Select Animals'),
      const SizedBox(height: 8),
      Row(
        children: [
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                if (_selectedAnimalIds.length == mockAnimals.length) {
                  _selectedAnimalIds.clear();
                } else {
                  _selectedAnimalIds
                      .addAll(mockAnimals.map((a) => a.id));
                }
              });
            },
            child: Text(
              _selectedAnimalIds.length == mockAnimals.length
                  ? 'Deselect All'
                  : 'Select All',
              style: TextStyle(
                  color: RumenoTheme.primaryGreen,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      ...mockAnimals.map((animal) => _buildAnimalSelectionTile(animal)),
      const SizedBox(height: 20),

      // ── What to include ──
      if (_selectedAnimalIds.isNotEmpty) ...[
        _buildSectionTitle('📑', 'Include in Export'),
        const SizedBox(height: 10),
        _buildSellIncludeOption(
          emoji: '🩺',
          title: 'Medical History',
          subtitle:
              'Vaccination, Treatment, Deworming, Lab Reports',
          value: _sellIncludeHealth,
          color: const Color(0xFFE53935),
          onChanged: (v) =>
              setState(() => _sellIncludeHealth = v),
        ),
        _buildSellIncludeOption(
          emoji: '🐣',
          title: 'Breeding History',
          subtitle: 'Heat cycles, AI, Pregnancy records',
          value: _sellIncludeBreeding,
          color: const Color(0xFFFF9800),
          onChanged: (v) =>
              setState(() => _sellIncludeBreeding = v),
        ),
        _buildSellIncludeOption(
          emoji: '💰',
          title: 'Finance Records',
          subtitle: 'Expenses related to this animal',
          value: _sellIncludeFinance,
          color: const Color(0xFF2196F3),
          onChanged: (v) =>
              setState(() => _sellIncludeFinance = v),
        ),
        _buildSellIncludeOption(
          emoji: '🥛',
          title: 'Milk Records',
          subtitle: 'Daily milk production data',
          value: _sellIncludeMilk,
          color: const Color(0xFF00BCD4),
          onChanged: (v) =>
              setState(() => _sellIncludeMilk = v),
        ),
        const SizedBox(height: 16),

      ],

      // ── Format Selection ──
      _buildFormatSelection(),
      const SizedBox(height: 24),

      // ── Export Button ──
      _buildExportButton(
        enabled: _selectedAnimalIds.isNotEmpty,
        label: _selectedAnimalIds.isEmpty
            ? 'Select Animals First'
            : 'Export ${_selectedAnimalIds.length} Animal(s)',
      ),
      const SizedBox(height: 16),
    ];
  }

  // ─── Animal Selection Tile ───
  Widget _buildAnimalSelectionTile(Animal animal) {
    final selected = _selectedAnimalIds.contains(animal.id);
    final statusInfo = _animalStatusInfo(animal.status);
    final speciesIcons = {
      Species.cow: '🐄',
      Species.buffalo: '🐃',
      Species.goat: '🐐',
      Species.sheep: '🐑',
      Species.pig: '🐷',
      Species.horse: '🐴',
    };
    final statusColor = _animalStatusColor(animal.status);

    return GestureDetector(
      onTap: () => setState(() => selected
          ? _selectedAnimalIds.remove(animal.id)
          : _selectedAnimalIds.add(animal.id)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFF9800).withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF9800)
                : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Animal icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  speciesIcons[animal.species]!,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${animal.tagId}  •  ${animal.breed}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(statusInfo['emoji']!,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        statusInfo['label']!,
                        style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${animal.ageString}  •  ${animal.weightKg}kg',
                        style: TextStyle(
                            fontSize: 12, color: RumenoTheme.textGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Checkbox visual
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color:
                    selected ? const Color(0xFFFF9800) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFF9800)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sell Include Option ───
  Widget _buildSellIncludeOption({
    required String emoji,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? color : Colors.grey.shade200,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: RumenoTheme.textGrey)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: value ? color : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════════════════

  Widget _buildSectionTitle(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoBanner(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: color, height: 1.4),
      ),
    );
  }

  Widget _buildFilterCard({
    required String emoji,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
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
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFilterSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: RumenoTheme.textGrey,
        ),
      ),
    );
  }

  Widget _buildIconChip({
    required String emoji,
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? color : RumenoTheme.textDark,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle, color: color, size: 16),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Format Selection (shared) ───
  Widget _buildFormatSelection() {
    return Column(
      children: [
        Row(
          children: [
            const Text('📄', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            const Text('File Format',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: ['PDF', 'CSV', 'Excel'].map((fmt) {
            final sel = _format == fmt;
            final icons = {'PDF': '📕', 'CSV': '📗', 'Excel': '📊'};
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _format = fmt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: fmt != 'Excel' ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: sel
                        ? RumenoTheme.primaryGreen.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel
                          ? RumenoTheme.primaryGreen
                          : Colors.grey.shade200,
                      width: sel ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(icons[fmt]!,
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(
                        fmt,
                        style: TextStyle(
                          fontWeight:
                              sel ? FontWeight.bold : FontWeight.normal,
                          color: sel
                              ? RumenoTheme.primaryGreen
                              : RumenoTheme.textDark,
                        ),
                      ),
                      if (sel)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(Icons.check_circle,
                              color: RumenoTheme.primaryGreen, size: 16),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Export Button (shared) ───
  Widget _buildExportButton({required bool enabled, required String label}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: !enabled || _exporting
            ? null
            : () async {
                setState(() => _exporting = true);
                await Future.delayed(const Duration(seconds: 2));
                if (!context.mounted) return;
                setState(() => _exporting = false);

                final msg = _tabIndex == 0
                    ? '📥 ${_selectedCategories.length} category(s) exported as $_format!'
                    : '📥 ${_selectedAnimalIds.length} animal(s) exported as $_format!';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: RumenoTheme.successGreen,
                  ),
                );
              },
        icon: _exporting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Icon(Icons.download_rounded, size: 26),
        label: Text(
          _exporting ? 'Exporting...' : label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              !enabled ? Colors.grey : RumenoTheme.primaryGreen,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════
  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Map<String, String> _animalStatusInfo(AnimalStatus s) {
    switch (s) {
      case AnimalStatus.active:
        return {'emoji': '✅', 'label': 'Active'};
      case AnimalStatus.pregnant:
        return {'emoji': '🤰', 'label': 'Pregnant'};
      case AnimalStatus.dry:
        return {'emoji': '🌵', 'label': 'Dry'};
      case AnimalStatus.sick:
        return {'emoji': '🤒', 'label': 'Sick'};
      case AnimalStatus.underTreatment:
        return {'emoji': '💊', 'label': 'Treatment'};
      case AnimalStatus.quarantine:
        return {'emoji': '🔒', 'label': 'Quarantine'};
      case AnimalStatus.deceased:
        return {'emoji': '💀', 'label': 'Deceased'};
    }
  }

  Color _animalStatusColor(AnimalStatus s) {
    switch (s) {
      case AnimalStatus.active:
        return const Color(0xFF4CAF50);
      case AnimalStatus.pregnant:
        return const Color(0xFF9C27B0);
      case AnimalStatus.dry:
        return const Color(0xFFFF9800);
      case AnimalStatus.sick:
        return const Color(0xFFE53935);
      case AnimalStatus.underTreatment:
        return const Color(0xFFFF5722);
      case AnimalStatus.quarantine:
        return const Color(0xFF795548);
      case AnimalStatus.deceased:
        return const Color(0xFF616161);
    }
  }

  Map<String, String> _vaccStatusInfo(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.due:
        return {'emoji': '⏰', 'label': 'Due'};
      case VaccinationStatus.overdue:
        return {'emoji': '🚨', 'label': 'Overdue'};
      case VaccinationStatus.done:
        return {'emoji': '✅', 'label': 'Done'};
    }
  }

  Color _vaccStatusColor(VaccinationStatus s) {
    switch (s) {
      case VaccinationStatus.due:
        return const Color(0xFFFF9800);
      case VaccinationStatus.overdue:
        return const Color(0xFFE53935);
      case VaccinationStatus.done:
        return const Color(0xFF4CAF50);
    }
  }

  Map<String, String> _treatStatusInfo(TreatmentStatus s) {
    switch (s) {
      case TreatmentStatus.active:
        return {'emoji': '🏥', 'label': 'Active'};
      case TreatmentStatus.completed:
        return {'emoji': '✅', 'label': 'Completed'};
      case TreatmentStatus.followUp:
        return {'emoji': '🔄', 'label': 'Follow Up'};
    }
  }

  Color _treatStatusColor(TreatmentStatus s) {
    switch (s) {
      case TreatmentStatus.active:
        return const Color(0xFFE53935);
      case TreatmentStatus.completed:
        return const Color(0xFF4CAF50);
      case TreatmentStatus.followUp:
        return const Color(0xFF2196F3);
    }
  }

  Map<String, String> _dewormStatusInfo(DewormingStatus s) {
    switch (s) {
      case DewormingStatus.due:
        return {'emoji': '⏰', 'label': 'Due'};
      case DewormingStatus.overdue:
        return {'emoji': '🚨', 'label': 'Overdue'};
      case DewormingStatus.done:
        return {'emoji': '✅', 'label': 'Done'};
    }
  }

  Color _dewormStatusColor(DewormingStatus s) {
    switch (s) {
      case DewormingStatus.due:
        return const Color(0xFFFF9800);
      case DewormingStatus.overdue:
        return const Color(0xFFE53935);
      case DewormingStatus.done:
        return const Color(0xFF4CAF50);
    }
  }

  Map<String, String> _labStatusInfo(LabReportStatus s) {
    switch (s) {
      case LabReportStatus.pending:
        return {'emoji': '⏳', 'label': 'Pending'};
      case LabReportStatus.completed:
        return {'emoji': '✅', 'label': 'Completed'};
    }
  }

  Color _labStatusColor(LabReportStatus s) {
    switch (s) {
      case LabReportStatus.pending:
        return const Color(0xFFFF9800);
      case LabReportStatus.completed:
        return const Color(0xFF4CAF50);
    }
  }
}
