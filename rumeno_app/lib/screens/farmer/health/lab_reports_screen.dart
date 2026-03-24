import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../providers/group_provider.dart';
import '../../../widgets/common/marketplace_button.dart';

class LabReportsScreen extends StatefulWidget {
  const LabReportsScreen({super.key});

  @override
  State<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends State<LabReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<LabReport> _reports;

  // ── Filters ──────────────────────────────────
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _filterTest;      // test name filter
  DateTime? _filterDateFrom;
  DateTime? _filterDateTo;

  // ── Group / Category Filters ──
  Species? _selectedCategory;
  String? _selectedGroupId;

  List<LabReport> _applyFilters(List<LabReport> source) {
    return source.where((r) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!r.testName.toLowerCase().contains(q) &&
            !r.animalId.toLowerCase().contains(q) &&
            !(r.labName?.toLowerCase().contains(q) ?? false) &&
            !(r.vetName?.toLowerCase().contains(q) ?? false)) {
          return false;
        }
      }
      if (_filterTest != null && r.testName != _filterTest) return false;
      if (_filterDateFrom != null &&
          r.testDate.isBefore(_filterDateFrom!)) {
        return false;
      }
      if (_filterDateTo != null &&
          r.testDate.isAfter(
              _filterDateTo!.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }).toList();
  }

  bool get _hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _filterTest != null ||
      _filterDateFrom != null ||
      _filterDateTo != null ||
      _selectedGroupId != null ||
      _selectedCategory != null;

  void _clearFilters() {
    setState(() {
      _searchCtrl.clear();
      _searchQuery = '';
      _filterTest = null;
      _filterDateFrom = null;
      _filterDateTo = null;
      _selectedCategory = null;
      _selectedGroupId = null;
    });
  }

  void _showFilterSheet() {
    String? tmpTest = _filterTest;
    DateTime? tmpFrom = _filterDateFrom;
    DateTime? tmpTo = _filterDateTo;

    const testNames = [
      'Complete Blood Count',
      'Brucella Test',
      'Milk Culture & Sensitivity',
      'Fecal Egg Count',
      'Liver Function Test',
      'Tuberculin Test',
      'Pregnancy Confirmation',
      'Blood Smear',
      'Urine Analysis',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('🔍',
                        style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Filter Reports',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () {
                        setSheet(() {
                          tmpTest = null;
                          tmpFrom = null;
                          tmpTo = null;
                        });
                      },
                      child: const Text('Clear All',
                          style:
                              TextStyle(color: RumenoTheme.warmBrown)),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                // ── Test Type ──────────────────────────
                const Text('Test Type',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: testNames.map((t) {
                    final sel = tmpTest == t;
                    return GestureDetector(
                      onTap: () => setSheet(
                          () => tmpTest = sel ? null : t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel
                              ? RumenoTheme.warmBrown
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: sel
                                  ? RumenoTheme.warmBrown
                                  : RumenoTheme.textLight),
                        ),
                        child: Text(t,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: sel
                                    ? Colors.white
                                    : RumenoTheme.textDark)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // ── Date Range ─────────────────────────
                const Text('Date Range',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: ctx,
                      initialDateRange: (tmpFrom != null && tmpTo != null)
                          ? DateTimeRange(start: tmpFrom!, end: tmpTo!)
                          : null,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context)
                              .colorScheme
                              .copyWith(
                                  primary: RumenoTheme.warmBrown,
                                  onPrimary: Colors.white),
                        ),
                        child: child!,
                      ),
                    );
                    if (range != null) {
                      setSheet(() {
                        tmpFrom = range.start;
                        tmpTo = range.end;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: (tmpFrom != null || tmpTo != null)
                          ? RumenoTheme.warmBrown.withValues(alpha: 0.08)
                          : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (tmpFrom != null || tmpTo != null)
                            ? RumenoTheme.warmBrown
                            : RumenoTheme.textLight,
                        width: (tmpFrom != null || tmpTo != null) ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('📅',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            (tmpFrom != null && tmpTo != null)
                                ? '${tmpFrom!.day}/${tmpFrom!.month}/${tmpFrom!.year}  →  ${tmpTo!.day}/${tmpTo!.month}/${tmpTo!.year}'
                                : tmpFrom != null
                                    ? 'From ${tmpFrom!.day}/${tmpFrom!.month}/${tmpFrom!.year}'
                                    : 'Select date range',
                            style: TextStyle(
                              fontSize: 13,
                              color: (tmpFrom != null || tmpTo != null)
                                  ? RumenoTheme.textDark
                                  : Colors.grey.shade500,
                              fontWeight: (tmpFrom != null || tmpTo != null)
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (tmpFrom != null || tmpTo != null)
                          GestureDetector(
                            onTap: () => setSheet(() {
                              tmpFrom = null;
                              tmpTo = null;
                            }),
                            child: const Icon(Icons.close,
                                size: 16,
                                color: RumenoTheme.textGrey),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filterTest = tmpTest;
                        _filterDateFrom = tmpFrom;
                        _filterDateTo = tmpTo;
                      });
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.warmBrown,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Apply Filters',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _reports = List.from(mockLabReports);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Add Lab Report Dialog ────────────────────
  void _showAddLabReportDialog(BuildContext context) {
    String selTest = 'Complete Blood Count';
    DateTime? reportDate;
    Animal? selectedAnimal;
    final labNameCtrl = TextEditingController();
    final vetNameCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final otherTestCtrl = TextEditingController();
    XFile? pickedFile;

    const testItems = [
      {'v': 'Complete Blood Count', 'e': '🩸', 'd': 'CBC'},
      {'v': 'Brucella Test', 'e': '🔬', 'd': 'Brucellosis'},
      {'v': 'Milk Culture & Sensitivity', 'e': '🥛', 'd': 'Mastitis'},
      {'v': 'Fecal Egg Count', 'e': '🪱', 'd': 'Parasites'},
      {'v': 'Liver Function Test', 'e': '🫀', 'd': 'LFT'},
      {'v': 'Tuberculin Test', 'e': '🫁', 'd': 'TB test'},
      {'v': 'Pregnancy Confirmation', 'e': '🤰', 'd': 'Pregnancy'},
      {'v': 'Blood Smear', 'e': '💉', 'd': 'Blood parasites'},
      {'v': 'Urine Analysis', 'e': '🧪', 'd': 'Urinalysis'},
      {'v': 'Other', 'e': '✏️', 'd': 'Other'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text('🔬', style: TextStyle(fontSize: 26)),
                    SizedBox(width: 10),
                    Text('Add Lab Report',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Select Test',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.15,
                  children: testItems.map((item) {
                    final sel = selTest == item['v'];
                    return GestureDetector(
                      onTap: () => setModalState(
                          () => selTest = item['v'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: sel
                              ? RumenoTheme.warmBrown
                              : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel
                                ? RumenoTheme.warmBrown
                                : RumenoTheme.textLight,
                            width: sel ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['e'] as String,
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 2),
                            Text(item['d'] as String,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: sel
                                        ? Colors.white
                                        : RumenoTheme.textDark),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Other test name input
                if (selTest == 'Other') ...[
                  TextField(
                    controller: otherTestCtrl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '✏️  Enter test name',
                      filled: true,
                      fillColor: RumenoTheme.backgroundCream,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: RumenoTheme.textLight)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: RumenoTheme.textLight)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: RumenoTheme.warmBrown, width: 2)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                // Date of Report
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: reportDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (d != null) setModalState(() => reportDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: reportDate != null
                            ? RumenoTheme.warmBrown
                            : RumenoTheme.textLight,
                        width: reportDate != null ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('📅', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          reportDate != null
                              ? '${reportDate!.day}/${reportDate!.month}/${reportDate!.year}'
                              : 'Date of Report (optional)',
                          style: TextStyle(
                            fontSize: 14,
                            color: reportDate != null
                                ? RumenoTheme.textDark
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final searchCtrl = TextEditingController();
                    Animal? picked;
                    await showDialog<Animal>(
                      context: ctx,
                      builder: (dCtx) => StatefulBuilder(
                        builder: (dCtx, setDialogState) {
                          final query = searchCtrl.text.toLowerCase();
                          final filtered = mockAnimals
                              .where((a) =>
                                  a.status != AnimalStatus.deceased &&
                                  (a.tagId.toLowerCase().contains(query) ||
                                      a.breed.toLowerCase().contains(query) ||
                                      a.species.name.toLowerCase().contains(query)))
                              .toList();
                          return AlertDialog(
                            title: const Text('Select Animal'),
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 400,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: searchCtrl,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search by tag, breed or species…',
                                      prefixIcon: const Icon(Icons.search),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (_) =>
                                        setDialogState(() {}),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: filtered.isEmpty
                                        ? const Center(
                                            child: Text('No animals found'),
                                          )
                                        : ListView.separated(
                                            itemCount: filtered.length,
                                            separatorBuilder: (_, _) =>
                                                const Divider(height: 1),
                                            itemBuilder: (_, i) {
                                              final a = filtered[i];
                                              return ListTile(
                                                dense: true,
                                                leading: Text(
                                                  _animalEmoji(a.species),
                                                  style: const TextStyle(
                                                      fontSize: 22),
                                                ),
                                                title: Text(
                                                  a.tagId,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                subtitle: Text(
                                                    '${a.breed} · ${a.weightKg} kg'),
                                                onTap: () {
                                                  picked = a;
                                                  Navigator.pop(dCtx);
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dCtx),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                    if (picked != null) {
                      setModalState(() => selectedAnimal = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedAnimal != null
                            ? RumenoTheme.warmBrown
                            : Colors.grey.shade300,
                        width: selectedAnimal != null ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: selectedAnimal != null
                          ? RumenoTheme.warmBrown.withOpacity(0.06)
                          : Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedAnimal != null
                              ? _animalEmoji(selectedAnimal!.species)
                              : '🐄',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: selectedAnimal != null
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedAnimal!.tagId,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '${selectedAnimal!.breed} · ${selectedAnimal!.weightKg} kg',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Tap to select animal',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14),
                                ),
                        ),
                        Icon(Icons.arrow_drop_down,
                            color: Colors.grey.shade500),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _dialogField(labNameCtrl, '🏥  Lab Name (optional)',
                    TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(vetNameCtrl,
                    '👨‍⚕️  Vet Name (optional)', TextInputType.text),
                const SizedBox(height: 12),
                _dialogField(notesCtrl, '📝  Notes (optional)',
                    TextInputType.text),
                const SizedBox(height: 16),
                // ── Upload Report ──────────────────────────
                const Text('Upload Report (optional)',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final result = await showModalBottomSheet<XFile?>(
                      context: ctx,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                            const SizedBox(height: 16),
                            const Text('Select Source',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const CircleAvatar(
                                  backgroundColor: RumenoTheme.backgroundCream,
                                  child: Icon(Icons.camera_alt,
                                      color: RumenoTheme.warmBrown)),
                              title: const Text('Take Photo'),
                              subtitle: const Text('Capture with camera'),
                              onTap: () async {
                                final f = await picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 85);
                                Navigator.pop(ctx, f);
                              },
                            ),
                            ListTile(
                              leading: const CircleAvatar(
                                  backgroundColor: RumenoTheme.backgroundCream,
                                  child: Icon(Icons.photo_library,
                                      color: RumenoTheme.warmBrown)),
                              title: const Text('Choose from Gallery'),
                              subtitle: const Text('Select an existing image'),
                              onTap: () async {
                                final f = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 85);
                                Navigator.pop(ctx, f);
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                    if (result != null) {
                      setModalState(() => pickedFile = result);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: pickedFile != null
                          ? RumenoTheme.successGreen.withValues(alpha: 0.08)
                          : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: pickedFile != null
                            ? RumenoTheme.successGreen
                            : RumenoTheme.textLight,
                        width: pickedFile != null ? 2 : 1,
                      ),
                    ),
                    child: pickedFile != null
                        ? Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(pickedFile!.path),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Report Uploaded ✅',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: RumenoTheme.successGreen,
                                            fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text(
                                      pickedFile!.name,
                                      style: const TextStyle(
                                          color: RumenoTheme.textGrey,
                                          fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    setModalState(() => pickedFile = null),
                                child: const Icon(Icons.close,
                                    color: RumenoTheme.textGrey, size: 18),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file,
                                  color: RumenoTheme.warmBrown, size: 22),
                              SizedBox(width: 8),
                              Text('Tap to upload report image',
                                  style: TextStyle(
                                      color: RumenoTheme.warmBrown,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (selectedAnimal == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please select an animal'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      final testName = selTest == 'Other'
                          ? otherTestCtrl.text.trim()
                          : selTest;
                      if (testName.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a test name'),
                              backgroundColor: RumenoTheme.errorRed),
                        );
                        return;
                      }
                      final record = LabReport(
                        id: 'LR_${DateTime.now().millisecondsSinceEpoch}',
                        animalId: selectedAnimal!.tagId,
                        testName: testName,
                        testDate: DateTime.now(),
                        labName: labNameCtrl.text.trim().isEmpty
                            ? null
                            : labNameCtrl.text.trim(),
                        vetName: vetNameCtrl.text.trim().isEmpty
                            ? null
                            : vetNameCtrl.text.trim(),
                        status: LabReportStatus.pending,
                        notes: notesCtrl.text.trim().isEmpty
                            ? null
                            : notesCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                      setState(() => _reports.insert(0, record));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Lab report added! 🔬'),
                          ]),
                          backgroundColor: RumenoTheme.successGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Report',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.warmBrown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _animalEmoji(Species species) {
    switch (species) {
      case Species.cow: return '🐄';
      case Species.buffalo: return '🐃';
      case Species.goat: return '🐐';
      case Species.sheep: return '🐑';
      case Species.pig: return '🐷';
      default: return '🐾';
    }
  }

  Widget _dialogField(
      TextEditingController ctrl, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: RumenoTheme.backgroundCream,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: RumenoTheme.warmBrown, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  // ── Build ────────────────────────────────────

  // ── Group Filter Bar ──────────────────────────
  Widget _buildGroupFilterBar(GroupProvider groupProvider) {
    final groups = _selectedCategory != null
        ? groupProvider.getGroupsBySpecies(_selectedCategory!)
        : groupProvider.groups;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryChip(null, '🐾', 'All'),
                ...Species.values.map(
                  (s) => _categoryChip(
                      s,
                      _animalEmoji(s),
                      s.name[0].toUpperCase() + s.name.substring(1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Group dropdown
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGroupId != null
                          ? RumenoTheme.warmBrown
                          : RumenoTheme.textLight,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedGroupId,
                      hint: const Text('📂 Filter by Group',
                          style: TextStyle(
                              fontSize: 14, color: RumenoTheme.textGrey)),
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
                      onChanged: (val) =>
                          setState(() => _selectedGroupId = val),
                    ),
                  ),
                ),
              ),
              if (_selectedGroupId != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _selectedGroupId = null),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: RumenoTheme.errorRed),
                  ),
                ),
              ],
            ],
          ),
          // Show animals in selected group
          if (_selectedGroupId != null) ...[
            const SizedBox(height: 8),
            _buildGroupAnimalsPreview(groupProvider),
          ],
        ],
      ),
    );
  }

  Widget _categoryChip(Species? species, String emoji, String label) {
    final selected = _selectedCategory == species;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: selected,
        label: Text('$emoji $label', style: const TextStyle(fontSize: 12)),
        onSelected: (_) => setState(() {
          _selectedCategory = selected ? null : species;
          _selectedGroupId = null;
        }),
        selectedColor: RumenoTheme.warmBrown.withValues(alpha: 0.2),
        checkmarkColor: RumenoTheme.warmBrown,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? RumenoTheme.warmBrown : RumenoTheme.textDark,
        ),
      ),
    );
  }

  Widget _buildGroupAnimalsPreview(GroupProvider provider) {
    final animals = provider.getAnimalsInGroup(_selectedGroupId!);
    if (animals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text('No animals in this group',
            style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: animals.map((a) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: RumenoTheme.warmBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: RumenoTheme.warmBrown.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${_animalEmoji(a.species)} ${a.tagId}',
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: RumenoTheme.warmBrown),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = context.watch<GroupProvider>();

    // Pre-filter by group/category
    var baseReports = _reports;
    if (_selectedGroupId != null) {
      final group = groupProvider.getGroupById(_selectedGroupId!);
      if (group != null) {
        final tagIds = mockAnimals
            .where((a) => group.animalIds.contains(a.id))
            .map((a) => a.tagId)
            .toSet();
        baseReports = baseReports.where((r) => tagIds.contains(r.animalId)).toList();
      }
    } else if (_selectedCategory != null) {
      final tagIds = mockAnimals
          .where((a) => a.species == _selectedCategory)
          .map((a) => a.tagId)
          .toSet();
      baseReports = baseReports.where((r) => tagIds.contains(r.animalId)).toList();
    }

    final allPending =
        baseReports.where((r) => r.status == LabReportStatus.pending).toList();
    final allCompleted =
        baseReports.where((r) => r.status == LabReportStatus.completed).toList();
    final pending = _applyFilters(allPending);
    final completed = _applyFilters(allCompleted);

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).healthCardLabReports),
        actions: const [VeterinarianButton(), MarketplaceButton()],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: '⏳ Pending (${pending.length})'),
            Tab(text: '✅ Completed (${completed.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Category & Group Filter Bar ──
          _buildGroupFilterBar(groupProvider),
          // ── Search + Filter bar ──────────────
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) =>
                        setState(() => _searchQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search by test, animal, lab…',
                      prefixIcon: const Icon(Icons.search,
                          color: RumenoTheme.textGrey, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () => setState(() {
                                _searchCtrl.clear();
                                _searchQuery = '';
                              }),
                              child: const Icon(Icons.close,
                                  size: 18,
                                  color: RumenoTheme.textGrey),
                            )
                          : null,
                      filled: true,
                      fillColor: RumenoTheme.backgroundCream,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: RumenoTheme.textLight)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: RumenoTheme.textLight)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: RumenoTheme.warmBrown, width: 2)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _hasActiveFilters
                          ? RumenoTheme.warmBrown
                          : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _hasActiveFilters
                              ? RumenoTheme.warmBrown
                              : RumenoTheme.textLight),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: _hasActiveFilters
                          ? Colors.white
                          : RumenoTheme.textGrey,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Active filter chips ──────────────
          if (_hasActiveFilters)
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_filterTest != null)
                      _activeChip('🔬 $_filterTest',
                          () => setState(() => _filterTest = null)),
                    if (_filterDateFrom != null)
                      _activeChip(
                          '📅 From ${_filterDateFrom!.day}/${_filterDateFrom!.month}/${_filterDateFrom!.year}',
                          () => setState(
                              () => _filterDateFrom = null)),
                    if (_filterDateTo != null)
                      _activeChip(
                          '📅 To ${_filterDateTo!.day}/${_filterDateTo!.month}/${_filterDateTo!.year}',
                          () =>
                              setState(() => _filterDateTo = null)),
                    GestureDetector(
                      onTap: _clearFilters,
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: RumenoTheme.errorRed
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: RumenoTheme.errorRed
                                  .withValues(alpha: 0.4)),
                        ),
                        child: const Text('Clear all',
                            style: TextStyle(
                                fontSize: 12,
                                color: RumenoTheme.errorRed,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // ── Tab content ──────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(pending, 'pending'),
                _buildList(completed, 'completed'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLabReportDialog(context),
        backgroundColor: RumenoTheme.warmBrown,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Report',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _activeChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding:
          const EdgeInsets.only(left: 10, right: 4, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: RumenoTheme.warmBrown.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: RumenoTheme.warmBrown.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: RumenoTheme.warmBrown,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: RumenoTheme.warmBrown),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<LabReport> reports, String type) {
    if (reports.isEmpty) {
      return _emptyState(
        _hasActiveFilters ? '🔍' : (type == 'pending' ? '⏳' : '✅'),
        _hasActiveFilters
            ? 'No matching reports'
            : (type == 'pending'
                ? 'No pending reports'
                : 'No completed reports yet'),
        _hasActiveFilters
            ? 'Try adjusting your filters'
            : (type == 'pending'
                ? 'Tap + to add a new lab test'
                : 'Results will appear here once ready'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: reports.length,
      itemBuilder: (_, i) => _LabReportCard(report: reports[i]),
    );
  }

  Widget _emptyState(String emoji, String title, String sub) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: RumenoTheme.textDark)),
            const SizedBox(height: 8),
            Text(sub,
                style: const TextStyle(
                    color: RumenoTheme.textGrey, fontSize: 14),
                textAlign: TextAlign.center),
          ],
        ),
      );
}

class _LabReportCard extends StatelessWidget {
  final LabReport report;

  const _LabReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final isPending = report.status == LabReportStatus.pending;
    final statusColor =
        isPending ? RumenoTheme.warningYellow : RumenoTheme.successGreen;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border:
            Border(left: BorderSide(color: statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(report.testName,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                    isPending ? 'Pending' : 'Completed',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
              'Animal: ${report.animalId}${report.labName != null ? ' • ${report.labName}' : ''}${report.vetName != null ? ' • ${report.vetName}' : ''}',
              style: Theme.of(context).textTheme.bodySmall),
          if (report.result != null) ...[
            const SizedBox(height: 4),
            Text('Result: ${report.result}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                        color: RumenoTheme.primaryGreen,
                        fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 4),
          Text(
              'Date: ${DateFormat('dd MMM yyyy').format(report.testDate)}${report.notes != null ? ' • ${report.notes}' : ''}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: RumenoTheme.textLight)),
        ],
      ),
    );
  }
}
