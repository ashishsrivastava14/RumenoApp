import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../mock/mock_health.dart';
import '../../../mock/mock_weight.dart';
import '../../../models/models.dart';
import '../../../widgets/charts/bar_chart_widget.dart';
import '../../../widgets/charts/line_chart_widget.dart';
import '../../../widgets/cards/vaccination_card.dart';
import '../../../widgets/cards/health_record_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class AnimalDetailScreen extends StatelessWidget {
  final String animalId;
  const AnimalDetailScreen({super.key, required this.animalId});

  @override
  Widget build(BuildContext context) {
    final animal = getAnimalById(animalId);
    if (animal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Animal Not Found')),
        body: const Center(child: Text('Animal not found')),
      );
    }

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        backgroundColor: RumenoTheme.backgroundCream,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'animal-${animal.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [RumenoTheme.primaryGreen, RumenoTheme.primaryDarkGreen],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.pets, color: Colors.white, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(animal.tagId, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              Text('${animal.breed} • ${animal.gender == Gender.male ? "Male ♂" : "Female ♀"}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(animal.statusLabel, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(animal.tagId),
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
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Health'),
                    Tab(text: 'Vaccination'),
                    Tab(text: 'Breeding'),
                    Tab(text: 'Reproduction'),
                    Tab(text: 'Production'),
                    Tab(text: 'Finance'),
                    Tab(text: 'Family'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _OverviewTab(animal: animal),
              _HealthTab(animalId: animal.id),
              _VaccinationTab(animalId: animal.id),
              _BreedingTab(animalId: animal.id),
              _ReproductionTab(animal: animal),
              _ProductionTab(animal: animal),
              _FinanceTab(animalId: animal.id),
              _FamilyTab(animal: animal),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _OverviewTab extends StatefulWidget {
  final Animal animal;
  const _OverviewTab({required this.animal});

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  late DateTime? _mortalityDate;
  late String? _mortalityReason;
  late DateTime? _castrationDate;
  late DateTime? _saleDate;
  late double? _salePrice;
  late String? _buyerName;
  late String? _buyerPhone;
  late String? _buyerAddress;

  @override
  void initState() {
    super.initState();
    _mortalityDate = widget.animal.mortalityDate;
    _mortalityReason = widget.animal.mortalityReason;
    _castrationDate = widget.animal.castrationDate;
    _saleDate = widget.animal.saleDate;
    _salePrice = widget.animal.salePrice;
    _buyerName = widget.animal.buyerName;
    _buyerPhone = widget.animal.buyerPhone;
    _buyerAddress = widget.animal.buyerAddress;
  }

  // ── Mortality reasons — big emoji presets for illiterate users ──
  static const _mortalityReasons = [
    {'emoji': '🤒', 'label': 'Disease'},
    {'emoji': '🫁', 'label': 'Pneumonia'},
    {'emoji': '💧', 'label': 'Diarrhea'},
    {'emoji': '🐍', 'label': 'Snake Bite'},
    {'emoji': '🐺', 'label': 'Predator'},
    {'emoji': '🥶', 'label': 'Cold'},
    {'emoji': '🍽️', 'label': 'Not Eating'},
    {'emoji': '🤰', 'label': 'Birth Complication'},
    {'emoji': '⚡', 'label': 'Sudden Death'},
    {'emoji': '❓', 'label': 'Unknown'},
    {'emoji': '✏️', 'label': 'Other'},
  ];

  void _showRecordMortalitySheet() {
    DateTime deathDate = DateTime.now();
    String? reason;
    final otherController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pill handle
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                const Row(children: [
                  Text('💀', style: TextStyle(fontSize: 30)),
                  SizedBox(width: 10),
                  Expanded(child: Text('Record Death', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 6),
                Text('${widget.animal.tagId} — ${widget.animal.breed}', style: const TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
                const SizedBox(height: 20),

                // Date picker
                const Text('📅  When did it die?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: deathDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (_, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: RumenoTheme.primaryGreen, onPrimary: Colors.white, surface: Colors.white)), child: child!),
                    );
                    if (d != null) setModalState(() => deathDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6)),
                    ),
                    child: Row(children: [
                      const Text('📅', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd MMM yyyy').format(deathDate), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.calendar_today_rounded, color: RumenoTheme.primaryGreen, size: 22),
                    ]),
                  ),
                ),
                const SizedBox(height: 22),

                // Reason — big emoji tiles
                const Text('😞  Why did it die?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _mortalityReasons.map((r) {
                    final sel = reason == r['label'];
                    return GestureDetector(
                      onTap: () => setModalState(() {
                        reason = r['label'] as String;
                        if (reason != 'Other') otherController.clear();
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: sel ? RumenoTheme.errorRed.withValues(alpha: 0.12) : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: sel ? RumenoTheme.errorRed : RumenoTheme.textLight, width: sel ? 2.5 : 1),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(r['emoji'] as String, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Text(r['label'] as String, style: TextStyle(fontSize: 15, fontWeight: sel ? FontWeight.bold : FontWeight.w500, color: sel ? RumenoTheme.errorRed : RumenoTheme.textDark)),
                        ]),
                      ),
                    );
                  }).toList(),
                ),

                // Other reason text field
                if (reason == 'Other') ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: otherController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Describe the reason',
                      hintText: 'e.g. Poisoning, old age…',
                      prefixIcon: const Icon(Icons.edit_note_rounded, color: RumenoTheme.primaryGreen),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2),
                      ),
                      filled: true,
                      fillColor: RumenoTheme.backgroundCream,
                    ),
                    onChanged: (_) => setModalState(() {}),
                  ),
                ],

                const SizedBox(height: 28),

                // Save
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (reason == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please select a reason'), backgroundColor: RumenoTheme.errorRed, behavior: SnackBarBehavior.floating));
                        return;
                      }
                      if (reason == 'Other' && otherController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please describe the reason'), backgroundColor: RumenoTheme.errorRed, behavior: SnackBarBehavior.floating));
                        return;
                      }
                      final finalReason = reason == 'Other' ? otherController.text.trim() : reason;
                      Navigator.pop(ctx);
                      otherController.dispose();
                      setState(() {
                        _mortalityDate = deathDate;
                        _mortalityReason = finalReason;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text('${widget.animal.tagId} marked as deceased')]),
                        backgroundColor: RumenoTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    icon: const Text('💀', style: TextStyle(fontSize: 22)),
                    label: const Text('Confirm Death', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  void _showRecordCastrationSheet() {
    DateTime castDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pill handle
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                const Row(children: [
                  Text('✂️', style: TextStyle(fontSize: 30)),
                  SizedBox(width: 10),
                  Expanded(child: Text('Record Castration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 6),
                Text('${widget.animal.tagId} — ${widget.animal.breed}', style: const TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
                const SizedBox(height: 20),

                // Animal info summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(children: [
                    Row(children: [
                      const Text('🏷️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Text('Animal ID', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text(widget.animal.tagId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('🎂', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Text('Date of Birth', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text(DateFormat('dd MMM yyyy').format(widget.animal.dateOfBirth), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),

                // Date picker
                const Text('✂️  Castration Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: castDate,
                      firstDate: widget.animal.dateOfBirth,
                      lastDate: DateTime.now(),
                      builder: (_, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: RumenoTheme.primaryGreen, onPrimary: Colors.white, surface: Colors.white)), child: child!),
                    );
                    if (d != null) setModalState(() => castDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6)),
                    ),
                    child: Row(children: [
                      const Text('📅', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd MMM yyyy').format(castDate), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.calendar_today_rounded, color: RumenoTheme.primaryGreen, size: 22),
                    ]),
                  ),
                ),
                const SizedBox(height: 28),

                // Save
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() => _castrationDate = castDate);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text('${widget.animal.tagId} castration recorded')]),
                        backgroundColor: RumenoTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    icon: const Text('✂️', style: TextStyle(fontSize: 22)),
                    label: const Text('Save Castration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.warningYellow,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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


  void _showSellAnimalSheet() {
    DateTime sellDate = DateTime.now();
    double? price;
    final priceController = TextEditingController();
    String buyerName = '';
    String buyerPhone = '';
    String buyerAddress = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pill handle
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                const Row(children: [
                  Text('🏷️', style: TextStyle(fontSize: 30)),
                  SizedBox(width: 10),
                  Expanded(child: Text('Sell Animal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 6),
                Text('${widget.animal.tagId} — ${widget.animal.breed}', style: const TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
                const SizedBox(height: 20),

                // Animal info summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(children: [
                    Row(children: [
                      const Text('🏷️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Text('Animal ID', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text(widget.animal.tagId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('🐄', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Text('Breed', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text(widget.animal.breed, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Text('⚖️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Text('Weight', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text('${widget.animal.weightKg} kg', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),

                // Date picker
                const Text('📅  Sale Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: sellDate,
                      firstDate: widget.animal.dateOfBirth,
                      lastDate: DateTime.now(),
                      builder: (_, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: RumenoTheme.primaryGreen, onPrimary: Colors.white, surface: Colors.white)), child: child!),
                    );
                    if (d != null) setModalState(() => sellDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6)),
                    ),
                    child: Row(children: [
                      const Text('📅', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd MMM yyyy').format(sellDate), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.calendar_today_rounded, color: RumenoTheme.primaryGreen, size: 22),
                    ]),
                  ),
                ),
                const SizedBox(height: 22),

                // Price
                const Text('💰  Selling Price', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                    hintText: 'Enter selling price',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    setModalState(() => price = parsed);
                  },
                ),
                const SizedBox(height: 18),

                // Buyer name (optional)
                const Text('👤  Buyer Name (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 17),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Enter buyer name',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    prefixIcon: const Padding(padding: EdgeInsets.only(left: 12, right: 8), child: Text('👤', style: TextStyle(fontSize: 22))),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) => buyerName = val.trim(),
                ),
                const SizedBox(height: 18),

                // Buyer phone (optional)
                const Text('📱  Buyer Phone (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 17),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: '9876543210',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    prefixIcon: const Padding(padding: EdgeInsets.only(left: 12, right: 8), child: Text('📱', style: TextStyle(fontSize: 22))),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) => buyerPhone = val.trim(),
                ),
                const SizedBox(height: 18),

                // Buyer address (optional)
                const Text('📍  Buyer Address (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 17),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Village / Town / City',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    prefixIcon: const Padding(padding: EdgeInsets.only(left: 12, right: 8), child: Text('📍', style: TextStyle(fontSize: 22))),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) => buyerAddress = val.trim(),
                ),
                const SizedBox(height: 28),

                // Save
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (price == null || price! <= 0) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please set the selling price'), backgroundColor: RumenoTheme.errorRed, behavior: SnackBarBehavior.floating));
                        return;
                      }
                      Navigator.pop(ctx);
                      setState(() {
                        _saleDate = sellDate;
                        _salePrice = price;
                        _buyerName = buyerName.isNotEmpty ? buyerName : null;
                        _buyerPhone = buyerPhone.isNotEmpty ? buyerPhone : null;
                        _buyerAddress = buyerAddress.isNotEmpty ? buyerAddress : null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text('${widget.animal.tagId} marked as sold')]),
                        backgroundColor: RumenoTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    icon: const Text('🏷️', style: TextStyle(fontSize: 22)),
                    label: const Text('Confirm Sale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  @override
  Widget build(BuildContext context) {
    final animal = widget.animal;
    final isDead = _mortalityDate != null;
    final isCastrated = _castrationDate != null;
    final isSold = _saleDate != null;

    String? ageAtDeath;
    if (_mortalityDate != null) {
      final days = _mortalityDate!.difference(animal.dateOfBirth).inDays;
      if (days < 30) {
        ageAtDeath = '$days days';
      } else if (days < 365) {
        ageAtDeath = '${days ~/ 30}m ${days % 30}d';
      } else {
        ageAtDeath = '${days ~/ 365}y ${(days % 365) ~/ 30}m';
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Deceased Banner ──
        if (isDead) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(children: [
              const Text('💀', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              const Text('DECEASED', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _MortalityInfoChip(emoji: '📅', label: 'Date', value: DateFormat('dd MMM yyyy').format(_mortalityDate!)),
                const SizedBox(width: 10),
                if (ageAtDeath != null)
                  _MortalityInfoChip(emoji: '⏳', label: 'Age', value: ageAtDeath),
              ]),
              if (_mortalityReason != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: RumenoTheme.errorRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('❓', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('Reason: ${_mortalityReason!}', style: const TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 16),
        ],

        // ── Castration Banner ──
        if (isCastrated) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RumenoTheme.warningYellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RumenoTheme.warningYellow, width: 1.5),
            ),
            child: Row(children: [
              const Text('✂️', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Castrated', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: RumenoTheme.textDark)),
                const SizedBox(height: 4),
                Text('Date: ${DateFormat('dd MMM yyyy').format(_castrationDate!)}', style: const TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
              ])),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: RumenoTheme.warningYellow.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: RumenoTheme.warmBrown, size: 22),
              ),
            ]),
          ),
          const SizedBox(height: 16),
        ],

        // ── Sold Banner ──
        if (isSold) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RumenoTheme.primaryGreen, width: 1.5),
            ),
            child: Column(
              children: [
                Row(children: [
                  const Text('🏷️', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('SOLD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: RumenoTheme.textDark)),
                    const SizedBox(height: 4),
                    Text('Date: ${DateFormat('dd MMM yyyy').format(_saleDate!)}', style: const TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
                  ])),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: RumenoTheme.primaryGreen.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: RumenoTheme.primaryGreen, size: 22),
                  ),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    const Text('💰', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    const Text('Price', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                    const Spacer(),
                    Text('₹${NumberFormat('#,##,###').format(_salePrice)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
                  ]),
                ),
                if (_buyerName != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      const Text('👤', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      const Text('Buyer', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text(_buyerName!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
                if (_buyerPhone != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      const Text('📱', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      const Text('Phone', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Text(_buyerPhone!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
                if (_buyerAddress != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      const Text('📍', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      const Text('Address', style: TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                      const Spacer(),
                      Flexible(child: Text(_buyerAddress!, textAlign: TextAlign.end, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    ]),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Action Buttons — Record Mortality / Castration / Sell ──
        if (!isDead || !isCastrated || !isSold) ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (!isDead)
                _BigActionButton(
                  emoji: '💀',
                  label: 'Record\nDeath',
                  color: Colors.grey.shade700,
                  onTap: _showRecordMortalitySheet,
                ),
              if (!isCastrated && animal.gender == Gender.male)
                _BigActionButton(
                  emoji: '✂️',
                  label: 'Record\nCastration',
                  color: RumenoTheme.warningYellow,
                  onTap: _showRecordCastrationSheet,
                ),
              if (!isSold && !isDead)
                _BigActionButton(
                  emoji: '🏷️',
                  label: 'Sell\nAnimal',
                  color: RumenoTheme.primaryGreen,
                  onTap: _showSellAnimalSheet,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // ── Standard Info Rows ──
        _InfoRow('Tag ID', animal.tagId),
        _InfoRow('Species', animal.speciesName),
        _InfoRow('Breed', animal.breed),
        _InfoRow('Age', animal.ageString),
        _InfoRow('Weight', '${animal.weightKg} kg'),
        _InfoRow('Height', '${animal.heightCm ?? "-"} cm'),
        _InfoRow('Color', animal.color ?? '-'),
        _InfoRow('Shed', animal.shedNumber ?? '-'),
        _InfoRow('Purpose', animal.purpose.name.toUpperCase()),
        const SizedBox(height: 20),
        _AnimalQrCard(animal: animal),
        const SizedBox(height: 20),
        _AdgSection(animal: animal),
        if (animal.purpose == AnimalPurpose.dairy || animal.purpose == AnimalPurpose.mixed) ...[
          const SizedBox(height: 16),
          BarChartWidget(
            title: 'Milk Performance (L/month)',
            values: const [180, 210, 195, 225, 240, 230],
            labels: const ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb'],
            barColor: RumenoTheme.infoBlue,
          ),
        ],
        const SizedBox(height: 16),
        LineChartWidget(
          title: 'Kidding Performance',
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(2, 1),
            FlSpot(3, 2),
            FlSpot(4, 1),
          ],
          bottomLabels: const ['2022', '2023', '2024', '2025', '2026'],
          lineColor: RumenoTheme.warningYellow,
          minY: 0,
          maxY: 3,
        ),
      ],
    );
  }
}

// ── Animal QR Code Card ───────────────────────────────────────────────────

class _AnimalQrCard extends StatelessWidget {
  final Animal animal;
  const _AnimalQrCard({required this.animal});

  /// QR data encodes the tagId so the scanner can look up the animal.
  String get _qrData => animal.tagId;

  void _showFullScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                animal.tagId,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${animal.speciesName} · ${animal.breed}',
                style: const TextStyle(fontSize: 13, color: RumenoTheme.textGrey),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 240,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF1A3A0D),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF1A3A0D),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _qrData,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: RumenoTheme.primaryGreen,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Scan with Rumeno app to open animal details',
                style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreen(context),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // QR thumbnail
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.25),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: QrImageView(
                  data: _qrData,
                  version: QrVersions.auto,
                  size: 80,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF1A3A0D),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1A3A0D),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Animal QR Code',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: RumenoTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _qrData,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      color: RumenoTheme.primaryGreen,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tap to view full-size • Scan to identify animal',
                    style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_full_rounded,
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── ADG (Average Daily Gain) Section — illiterate-friendly ──

class _AdgSection extends StatefulWidget {
  final Animal animal;
  const _AdgSection({required this.animal});

  @override
  State<_AdgSection> createState() => _AdgSectionState();
}

class _AdgSectionState extends State<_AdgSection> {
  late List<WeightRecord> _weightRecords;

  @override
  void initState() {
    super.initState();
    _weightRecords = getWeightRecords(widget.animal.id);
  }

  /// Overall ADG from first to last record (kg/day)
  double? get _overallAdg {
    if (_weightRecords.length < 2) return null;
    final first = _weightRecords.first;
    final last = _weightRecords.last;
    final days = last.date.difference(first.date).inDays;
    if (days <= 0) return null;
    return (last.weightKg - first.weightKg) / days;
  }

  /// Recent ADG from second-last to last record
  double? get _recentAdg {
    if (_weightRecords.length < 2) return null;
    final prev = _weightRecords[_weightRecords.length - 2];
    final last = _weightRecords.last;
    final days = last.date.difference(prev.date).inDays;
    if (days <= 0) return null;
    return (last.weightKg - prev.weightKg) / days;
  }

  /// Total weight gained from first to last
  double? get _totalGain {
    if (_weightRecords.length < 2) return null;
    return _weightRecords.last.weightKg - _weightRecords.first.weightKg;
  }

  /// Growth rating: 'great', 'good', 'slow', 'losing'
  String _growthRating(double? adg) {
    if (adg == null) return 'none';
    // Thresholds are relative to species
    final sp = widget.animal.species;
    final double goodThreshold;
    final double greatThreshold;
    switch (sp) {
      case Species.cow:
      case Species.buffalo:
        goodThreshold = 0.3;
        greatThreshold = 0.6;
      case Species.goat:
      case Species.sheep:
        goodThreshold = 0.05;
        greatThreshold = 0.1;
      case Species.pig:
        goodThreshold = 0.4;
        greatThreshold = 0.7;
      case Species.horse:
        goodThreshold = 0.3;
        greatThreshold = 0.6;
    }
    if (adg < 0) return 'losing';
    if (adg < goodThreshold) return 'slow';
    if (adg < greatThreshold) return 'good';
    return 'great';
  }

  void _showRecordWeightSheet() {
    double? selectedWeight;
    int? selectedBCS;
    DateTime weighDate = DateTime.now();
    final weightCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Row(children: [
                  const Text('⚖️', style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Record Weight', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('${widget.animal.tagId} — ${widget.animal.breed}', style: const TextStyle(fontSize: 14, color: RumenoTheme.textGrey)),
                    ],
                  )),
                ]),
                const SizedBox(height: 20),

                // Date picker
                const Text('📅  When?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: weighDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (_, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: RumenoTheme.primaryGreen, onPrimary: Colors.white, surface: Colors.white)), child: child!),
                    );
                    if (d != null) setModalState(() => weighDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6)),
                    ),
                    child: Row(children: [
                      const Text('📅', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd MMM yyyy').format(weighDate), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      const Icon(Icons.calendar_today_rounded, color: RumenoTheme.primaryGreen, size: 22),
                    ]),
                  ),
                ),
                const SizedBox(height: 22),

                // Weight input
                const Text('⚖️  How much?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(
                  controller: weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    suffixText: 'kg',
                    suffixStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                    hintText: 'Enter weight',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    setModalState(() => selectedWeight = parsed);
                  },
                ),
                const SizedBox(height: 22),

                // Body Condition Score
                const Text('📊  Body Condition Score', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.6)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedBCS,
                      hint: const Text('Select score (1–5)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      icon: const Icon(Icons.arrow_drop_down_rounded, color: RumenoTheme.primaryGreen, size: 28),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: RumenoTheme.textDark),
                      items: List.generate(5, (i) {
                        final score = i + 1;
                        return DropdownMenuItem<int>(
                          value: score,
                          child: Text('$score — ${const ['Very Thin', 'Thin', 'Average', 'Fat', 'Obese'][i]}'),
                        );
                      }),
                      onChanged: (val) => setModalState(() => selectedBCS = val),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Save
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final weight = selectedWeight;
                      if (weight == null || weight <= 0) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please select or enter weight'), backgroundColor: RumenoTheme.errorRed, behavior: SnackBarBehavior.floating));
                        return;
                      }
                      final bcs = selectedBCS;
                      Navigator.pop(ctx);
                      setState(() {
                        _weightRecords.add(WeightRecord(
                          id: 'W_${DateTime.now().millisecondsSinceEpoch}',
                          animalId: widget.animal.id,
                          date: weighDate,
                          weightKg: weight,
                          bodyConditionScore: bcs,
                        ));
                        _weightRecords.sort((a, b) => a.date.compareTo(b.date));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Text('Weight ${weight.toStringAsFixed(1)} kg recorded!')]),
                        backgroundColor: RumenoTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    icon: const Text('⚖️', style: TextStyle(fontSize: 22)),
                    label: const Text('Save Weight', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RumenoTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  @override
  Widget build(BuildContext context) {
    final adg = _overallAdg;
    final recent = _recentAdg;
    final totalGain = _totalGain;
    final rating = _growthRating(adg);
    final hasRecords = _weightRecords.length >= 2 && adg != null && totalGain != null;

    // Rating visual config
    final String ratingEmoji;
    final String ratingLabel;
    final Color ratingColor;
    final Color ratingBgColor;
    switch (rating) {
      case 'great':
        ratingEmoji = '🚀';
        ratingLabel = 'Great Growth!';
        ratingColor = const Color(0xFF2E7D32);
        ratingBgColor = const Color(0xFFE8F5E9);
      case 'good':
        ratingEmoji = '👍';
        ratingLabel = 'Good Growth';
        ratingColor = const Color(0xFF558B2F);
        ratingBgColor = const Color(0xFFF1F8E9);
      case 'slow':
        ratingEmoji = '🐢';
        ratingLabel = 'Slow Growth';
        ratingColor = const Color(0xFFF9A825);
        ratingBgColor = const Color(0xFFFFF8E1);
      case 'losing':
        ratingEmoji = '⚠️';
        ratingLabel = 'Losing Weight!';
        ratingColor = const Color(0xFFC62828);
        ratingBgColor = const Color(0xFFFFEBEE);
      default:
        ratingEmoji = '📊';
        ratingLabel = 'No Data';
        ratingColor = RumenoTheme.textGrey;
        ratingBgColor = RumenoTheme.backgroundCream;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        Row(children: [
          const Text('📈', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          const Expanded(child: Text('Growth Tracker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          // Record Weight button
          GestureDetector(
            onTap: _showRecordWeightSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Text('⚖️', style: TextStyle(fontSize: 18)),
                SizedBox(width: 6),
                Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 14),

        if (!hasRecords) ...[
          // ── No data — prompt to record ──
          GestureDetector(
            onTap: _showRecordWeightSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: RumenoTheme.backgroundCream,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3), width: 2, strokeAlign: BorderSide.strokeAlignInside),
              ),
              child: Column(children: [
                const Text('⚖️', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 10),
                const Text('Tap to record first weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: RumenoTheme.textGrey)),
                const SizedBox(height: 6),
                Text('Current: ${widget.animal.weightKg.toStringAsFixed(0)} kg', style: const TextStyle(fontSize: 14, color: RumenoTheme.textLight)),
              ]),
            ),
          ),
        ] else ...[
          // ── Big Growth Status Card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ratingBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ratingColor.withValues(alpha: 0.3), width: 2),
            ),
            child: Column(children: [
              // Big emoji + rating
              Text(ratingEmoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(ratingLabel, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ratingColor)),
              const SizedBox(height: 16),

              // ADG value — big and prominent
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    adg >= 0 ? '📈' : '📉',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(children: [
                    Text(
                      '${adg.abs().toStringAsFixed(2)} kg',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ratingColor),
                    ),
                    Text('per day', style: TextStyle(fontSize: 14, color: ratingColor.withValues(alpha: 0.7))),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),

              // Visual weight journey — first → last with arrow
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _WeightBubble(
                  label: _weightRecords.first.weightKg.toStringAsFixed(0),
                  sub: DateFormat('MMM yy').format(_weightRecords.first.date),
                  color: RumenoTheme.textGrey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(children: [
                    Icon(
                      totalGain >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      color: ratingColor,
                      size: 32,
                    ),
                    Text(
                      '${totalGain >= 0 ? "+" : ""}${totalGain.toStringAsFixed(1)} kg',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ratingColor),
                    ),
                  ]),
                ),
                _WeightBubble(
                  label: _weightRecords.last.weightKg.toStringAsFixed(0),
                  sub: DateFormat('MMM yy').format(_weightRecords.last.date),
                  color: ratingColor,
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 14),

          // ── Recent vs Overall ADG comparison ──
          if (recent != null)
            Row(children: [
              Expanded(child: _AdgMiniCard(
                emoji: '📅',
                title: 'Last Month',
                value: '${recent.abs().toStringAsFixed(2)} kg/day',
                isPositive: recent >= 0,
              )),
              const SizedBox(width: 10),
              Expanded(child: _AdgMiniCard(
                emoji: '📊',
                title: 'Overall',
                value: '${adg.abs().toStringAsFixed(2)} kg/day',
                isPositive: adg >= 0,
              )),
            ]),
          const SizedBox(height: 14),

          // ── Weight history timeline — visual step markers ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Text('📋', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text('Weight History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),
                ...List.generate(_weightRecords.length, (i) {
                  final rec = _weightRecords[i];
                  final isLast = i == _weightRecords.length - 1;
                  final double? change;
                  if (i > 0) {
                    change = rec.weightKg - _weightRecords[i - 1].weightKg;
                  } else {
                    change = null;
                  }
                  return _WeightTimelineRow(
                    date: rec.date,
                    weightKg: rec.weightKg,
                    change: change,
                    isLast: isLast,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Weight chart using actual records ──
          LineChartWidget(
            title: 'Weight Chart',
            spots: List.generate(_weightRecords.length, (i) => FlSpot(i.toDouble(), _weightRecords[i].weightKg)),
            bottomLabels: _weightRecords.map((w) => DateFormat('MMM').format(w.date)).toList(),
          ),
        ],
      ],
    );
  }
}

/// Circular weight bubble for the journey visualization
class _WeightBubble extends StatelessWidget {
  final String label;
  final String sub;
  final Color color;

  const _WeightBubble({required this.label, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color, width: 2.5),
        ),
        child: Center(
          child: Text('$label\nkg', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color, height: 1.2)),
        ),
      ),
      const SizedBox(height: 4),
      Text(sub, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7))),
    ]);
  }
}

/// Mini card for Recent vs Overall ADG
class _AdgMiniCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final bool isPositive;

  const _AdgMiniCard({required this.emoji, required this.title, required this.value, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text(isPositive ? '📈' : '📉', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isPositive ? RumenoTheme.successGreen : RumenoTheme.errorRed)),
        ]),
      ]),
    );
  }
}

/// Single row in the weight timeline
class _WeightTimelineRow extends StatelessWidget {
  final DateTime date;
  final double weightKg;
  final double? change;
  final bool isLast;

  const _WeightTimelineRow({required this.date, required this.weightKg, this.change, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline dot + line
          SizedBox(
            width: 28,
            child: Column(children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLast ? RumenoTheme.primaryGreen : RumenoTheme.textLight,
                  border: Border.all(color: isLast ? RumenoTheme.primaryGreen : RumenoTheme.textLight, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: RumenoTheme.textLight.withValues(alpha: 0.4))),
            ]),
          ),
          const SizedBox(width: 10),
          // Date + weight + change
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(children: [
                Text(DateFormat('dd MMM yy').format(date), style: const TextStyle(fontSize: 13, color: RumenoTheme.textGrey)),
                const Spacer(),
                Text('${weightKg.toStringAsFixed(1)} kg', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isLast ? RumenoTheme.primaryGreen : RumenoTheme.textDark)),
                if (change != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: change! >= 0
                          ? RumenoTheme.successGreen.withValues(alpha: 0.12)
                          : RumenoTheme.errorRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${change! >= 0 ? "+" : ""}${change!.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: change! >= 0 ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                      ),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Big Action Button for illiterate-friendly mortality/castration actions ──
class _BigActionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BigActionButton({required this.emoji, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Info chip used in mortality banner ──
class _MortalityInfoChip extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _MortalityInfoChip({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 6),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
        ]),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.titleSmall)),
        ],
      ),
    );
  }
}

class _HealthTab extends StatelessWidget {
  final String animalId;
  const _HealthTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final records = mockTreatments.where((t) => t.animalId == animalId).toList();
    if (records.isEmpty) {
      return const Center(child: Text('No health records'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (context, index) => HealthRecordCard(record: records[index]),
    );
  }
}

class _VaccinationTab extends StatelessWidget {
  final String animalId;
  const _VaccinationTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final records = mockVaccinations.where((v) => v.animalId == animalId).toList();
    if (records.isEmpty) {
      return const Center(child: Text('No vaccination records'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (context, index) => VaccinationCard(record: records[index]),
    );
  }
}

class _BreedingTab extends StatelessWidget {
  final String animalId;
  const _BreedingTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final records = mockBreedingRecords.where((b) => b.animalId == animalId).toList();
    if (records.isEmpty) {
      return const Center(child: Text('No breeding records'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final r = records[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Heat: ${DateFormat('dd MMM yyyy').format(r.heatDate)}', style: Theme.of(context).textTheme.titleSmall),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: r.isPregnant ? RumenoTheme.infoBlue.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r.isPregnant ? 'Pregnant' : 'Not Pregnant', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: r.isPregnant ? RumenoTheme.infoBlue : Colors.grey)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Intensity: ${r.intensity.name} • AI: ${r.aiDone ? "Yes" : "No"}', style: Theme.of(context).textTheme.bodySmall),
              if (r.expectedDelivery != null)
                Text('Expected Delivery: ${DateFormat('dd MMM yyyy').format(r.expectedDelivery!)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.primaryGreen)),
            ],
          ),
        );
      },
    );
  }
}

class _ProductionTab extends StatelessWidget {
  final Animal animal;
  const _ProductionTab({required this.animal});

  @override
  Widget build(BuildContext context) {
    if (animal.purpose != AnimalPurpose.dairy && animal.purpose != AnimalPurpose.mixed) {
      return const Center(child: Text('Production data for dairy animals only'));
    }

    // Calculate milk dry off date from breeding records
    final breedingRecords = mockBreedingRecords.where((b) => b.animalId == animal.id && b.isPregnant && b.expectedDelivery != null).toList();
    DateTime? milkDryOffDate;
    DateTime? expectedDelivery;
    if (breedingRecords.isNotEmpty) {
      expectedDelivery = breedingRecords.last.expectedDelivery;
      milkDryOffDate = expectedDelivery!.subtract(const Duration(days: 60));
    }

    final now = DateTime.now();
    final dryOffAlert = milkDryOffDate != null && milkDryOffDate.difference(now).inDays <= 7 && milkDryOffDate.isAfter(now);
    final dryOffOverdue = milkDryOffDate != null && milkDryOffDate.isBefore(now);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LineChartWidget(
          title: 'Daily Milk Production (L)',
          spots: const [
            FlSpot(0, 8), FlSpot(1, 9), FlSpot(2, 8.5), FlSpot(3, 10), FlSpot(4, 9.5), FlSpot(5, 11),
          ],
          bottomLabels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          lineColor: RumenoTheme.infoBlue,
        ),
        if (milkDryOffDate != null) ...[
          const SizedBox(height: 16),
          _MilkDryOffCard(
            dryOffDate: milkDryOffDate,
            expectedDelivery: expectedDelivery!,
            isAlert: dryOffAlert,
            isOverdue: dryOffOverdue,
          ),
        ],
      ],
    );
  }
}

class _FinanceTab extends StatelessWidget {
  final String animalId;
  const _FinanceTab({required this.animalId});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ExpenseItem('Vaccination - FMD', '₹500', '10 Dec 2025'),
        _ExpenseItem('Antibiotics', '₹2,500', '18 Feb 2026'),
        _ExpenseItem('Vet Consultation', '₹1,500', '18 Feb 2026'),
      ],
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  const _ExpenseItem(this.title, this.amount, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Text(date, style: Theme.of(context).textTheme.bodySmall),
          ])),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.errorRed)),
        ],
      ),
    );
  }
}

// ─── Reproduction Tab ───

class _ReproductionTab extends StatefulWidget {
  final Animal animal;
  const _ReproductionTab({required this.animal});

  @override
  State<_ReproductionTab> createState() => _ReproductionTabState();
}

class _ReproductionTabState extends State<_ReproductionTab> {
  late List<BreedingRecord> _breedingRecords;
  late List<_SyncRecord> _syncRecords;
  late List<_MiscarriageRecord> _miscarriageRecords;
  late List<_LactationRecord> _lactationHistory;
  late List<_MastitisRecord> _mastitisHistory;
  late int _lactationNumber;

  @override
  void initState() {
    super.initState();
    final animal = widget.animal;
    _breedingRecords = mockBreedingRecords.where((b) => b.animalId == animal.id).toList();

    _syncRecords = [
      if (_breedingRecords.isNotEmpty)
        _SyncRecord(
          date: _breedingRecords.first.heatDate.subtract(const Duration(days: 10)),
          protocol: 'Ovsynch',
          status: 'Completed',
          notes: 'GnRH + PGF2α protocol',
        ),
    ];

    _miscarriageRecords = [
      if (animal.id == '6')
        _MiscarriageRecord(
          date: DateTime(2025, 3, 15),
          stage: '4 months',
          cause: 'Unknown',
          notes: 'Vet examined, no infection found',
        ),
    ];

    _lactationNumber = animal.purpose == AnimalPurpose.dairy || animal.purpose == AnimalPurpose.mixed ? 3 : 0;
    _lactationHistory = [
      if (_lactationNumber > 0) ...[
        _LactationRecord(number: 1, startDate: DateTime(2022, 5, 10), endDate: DateTime(2023, 2, 15), totalMilkLitres: 3250, daysInMilk: 281),
        _LactationRecord(number: 2, startDate: DateTime(2023, 8, 20), endDate: DateTime(2024, 5, 10), daysInMilk: 264, totalMilkLitres: 3680),
        _LactationRecord(number: 3, startDate: DateTime(2025, 1, 5), endDate: null, daysInMilk: null, totalMilkLitres: null),
      ],
    ];

    _mastitisHistory = [
      if (animal.id == '1')
        _MastitisRecord(date: DateTime(2026, 1, 25), quarter: 'Rear Left', severity: 'Subclinical', treatment: 'Cephalexin intramammary', resolvedDate: DateTime(2026, 2, 5)),
      if (animal.id == '2')
        _MastitisRecord(date: DateTime(2025, 6, 10), quarter: 'Front Right', severity: 'Clinical', treatment: 'Amoxicillin + anti-inflammatory', resolvedDate: DateTime(2025, 6, 22)),
    ];
  }

  // ── Add Synchronization ──
  void _showAddSyncDialog() {
    String protocol = 'Ovsynch';
    DateTime date = DateTime.now();
    final notesCtrl = TextEditingController();
    final protocols = ['Ovsynch', 'Co-Synch', 'Pre-Synch', 'Double Ovsynch', 'CIDR', 'PGF2α', 'Other'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🔄', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Add Synchronization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('Protocol', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: protocols.map((p) {
                    final sel = protocol == p;
                    return GestureDetector(
                      onTap: () => setModalState(() => protocol = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? RumenoTheme.primaryGreen : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textLight, width: sel ? 2 : 1),
                        ),
                        child: Text(p, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: sel ? Colors.white : RumenoTheme.textDark)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, date, (d) => setModalState(() => date = d)),
                const SizedBox(height: 12),
                _formField(notesCtrl, '📝 Notes (optional)', TextInputType.text),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save Synchronization', () {
                  Navigator.pop(ctx);
                  setState(() {
                    _syncRecords.add(_SyncRecord(date: date, protocol: protocol, status: 'Completed', notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim()));
                  });
                  _showSavedSnackBar('Synchronization record added!');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Heat ──
  void _showAddHeatDialog() {
    DateTime heatDate = DateTime.now();
    HeatIntensity intensity = HeatIntensity.moderate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🔥', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Record Heat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('Heat Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, heatDate, (d) => setModalState(() => heatDate = d)),
                const SizedBox(height: 16),
                const Text('Intensity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: HeatIntensity.values.map((hi) {
                    final sel = intensity == hi;
                    final color = switch (hi) { HeatIntensity.strong => RumenoTheme.errorRed, HeatIntensity.moderate => RumenoTheme.warningYellow, HeatIntensity.mild => RumenoTheme.successGreen };
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => intensity = hi),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: sel ? color.withValues(alpha: 0.15) : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sel ? color : RumenoTheme.textLight, width: sel ? 2 : 1),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.whatshot, color: sel ? color : RumenoTheme.textGrey, size: 24),
                              const SizedBox(height: 4),
                              Text(hi.name[0].toUpperCase() + hi.name.substring(1), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: sel ? color : RumenoTheme.textGrey)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save Heat Record', () {
                  Navigator.pop(ctx);
                  setState(() {
                    _breedingRecords.add(BreedingRecord(
                      id: 'BR_${DateTime.now().millisecondsSinceEpoch}',
                      animalId: widget.animal.id,
                      heatDate: heatDate,
                      intensity: intensity,
                      aiDone: false,
                      isPregnant: false,
                      notes: 'Heat detected',
                    ));
                  });
                  _showSavedSnackBar('Heat record added!');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add AI (with Synchronization option) ──
  void _showAddAIDialog() {
    DateTime aiDate = DateTime.now();
    final bullSemenCtrl = TextEditingController();
    final technicianCtrl = TextEditingController();
    HeatIntensity intensity = HeatIntensity.moderate;
    bool addSync = false;
    String syncProtocol = 'Ovsynch';
    DateTime syncDate = DateTime.now().subtract(const Duration(days: 10));
    final syncNotesCtrl = TextEditingController();

    final protocols = ['Ovsynch', 'Co-Synch', 'Pre-Synch', 'Double Ovsynch', 'CIDR', 'PGF2α', 'Other'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('💉', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Add Artificial Insemination', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('AI Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, aiDate, (d) => setModalState(() => aiDate = d)),
                const SizedBox(height: 12),
                _formField(bullSemenCtrl, '🐂 Bull / Semen ID', TextInputType.text),
                const SizedBox(height: 12),
                _formField(technicianCtrl, '👨‍⚕️ Technician Name', TextInputType.text),
                const SizedBox(height: 16),
                const Text('Heat Intensity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: HeatIntensity.values.map((hi) {
                    final sel = intensity == hi;
                    final color = switch (hi) { HeatIntensity.strong => RumenoTheme.errorRed, HeatIntensity.moderate => RumenoTheme.warningYellow, HeatIntensity.mild => RumenoTheme.successGreen };
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => intensity = hi),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? color.withValues(alpha: 0.15) : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sel ? color : RumenoTheme.textLight, width: sel ? 2 : 1),
                          ),
                          child: Center(child: Text(hi.name[0].toUpperCase() + hi.name.substring(1), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: sel ? color : RumenoTheme.textGrey))),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Synchronization toggle
                GestureDetector(
                  onTap: () => setModalState(() => addSync = !addSync),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: addSync ? RumenoTheme.primaryGreen.withValues(alpha: 0.08) : RumenoTheme.backgroundCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: addSync ? RumenoTheme.primaryGreen : RumenoTheme.textLight),
                    ),
                    child: Row(
                      children: [
                        Icon(addSync ? Icons.check_box : Icons.check_box_outline_blank, color: addSync ? RumenoTheme.primaryGreen : RumenoTheme.textGrey),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Add Synchronization Protocol', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                      ],
                    ),
                  ),
                ),
                if (addSync) ...[
                  const SizedBox(height: 12),
                  const Text('Sync Protocol', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: RumenoTheme.textDark)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: protocols.map((p) {
                      final sel = syncProtocol == p;
                      return GestureDetector(
                        onTap: () => setModalState(() => syncProtocol = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: sel ? RumenoTheme.primaryGreen : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textLight),
                          ),
                          child: Text(p, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: sel ? Colors.white : RumenoTheme.textDark)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Sync Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: RumenoTheme.textDark)),
                  const SizedBox(height: 8),
                  _datePickerTile(ctx, syncDate, (d) => setModalState(() => syncDate = d)),
                  const SizedBox(height: 8),
                  _formField(syncNotesCtrl, '📝 Sync Notes (optional)', TextInputType.text),
                ],
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save AI Record', () {
                  if (bullSemenCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter Bull / Semen ID'), backgroundColor: RumenoTheme.errorRed));
                    return;
                  }
                  Navigator.pop(ctx);
                  setState(() {
                    _breedingRecords.add(BreedingRecord(
                      id: 'BR_${DateTime.now().millisecondsSinceEpoch}',
                      animalId: widget.animal.id,
                      heatDate: aiDate,
                      intensity: intensity,
                      aiDone: true,
                      bullSemenId: bullSemenCtrl.text.trim(),
                      technicianName: technicianCtrl.text.trim().isEmpty ? null : technicianCtrl.text.trim(),
                      matingDate: aiDate,
                      isPregnant: false,
                    ));
                    if (addSync) {
                      _syncRecords.add(_SyncRecord(date: syncDate, protocol: syncProtocol, status: 'Completed', notes: syncNotesCtrl.text.trim().isEmpty ? null : syncNotesCtrl.text.trim()));
                    }
                  });
                  _showSavedSnackBar('AI record added!${addSync ? ' Sync protocol recorded.' : ''}');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Miscarriage ──
  void _showAddMiscarriageDialog() {
    DateTime date = DateTime.now();
    final stageCtrl = TextEditingController();
    final causeCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('⚠️', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Record Miscarriage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, date, (d) => setModalState(() => date = d)),
                const SizedBox(height: 12),
                _formField(stageCtrl, '📅 Pregnancy Stage (e.g. 4 months)', TextInputType.text),
                const SizedBox(height: 12),
                _formField(causeCtrl, '🔍 Cause (if known)', TextInputType.text),
                const SizedBox(height: 12),
                _formField(notesCtrl, '📝 Notes (optional)', TextInputType.text),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save Record', () {
                  if (stageCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter pregnancy stage'), backgroundColor: RumenoTheme.errorRed));
                    return;
                  }
                  Navigator.pop(ctx);
                  setState(() {
                    _miscarriageRecords.add(_MiscarriageRecord(
                      date: date,
                      stage: stageCtrl.text.trim(),
                      cause: causeCtrl.text.trim().isEmpty ? 'Unknown' : causeCtrl.text.trim(),
                      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                    ));
                  });
                  _showSavedSnackBar('Miscarriage record added.');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Update Pregnancy Status ──
  void _showUpdatePregnancyDialog() {
    bool isPregnant = true;
    DateTime matingDate = DateTime.now().subtract(const Duration(days: 30));
    DateTime expectedDelivery = DateTime.now().add(const Duration(days: 250));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🤰', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Update Pregnancy Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isPregnant = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isPregnant ? RumenoTheme.infoBlue.withValues(alpha: 0.12) : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isPregnant ? RumenoTheme.infoBlue : RumenoTheme.textLight, width: isPregnant ? 2 : 1),
                          ),
                          child: Column(children: [
                            Icon(Icons.check_circle, color: isPregnant ? RumenoTheme.infoBlue : RumenoTheme.textGrey, size: 28),
                            const SizedBox(height: 4),
                            Text('Pregnant', style: TextStyle(fontWeight: FontWeight.w600, color: isPregnant ? RumenoTheme.infoBlue : RumenoTheme.textGrey)),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => isPregnant = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !isPregnant ? Colors.grey.withValues(alpha: 0.12) : RumenoTheme.backgroundCream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: !isPregnant ? Colors.grey : RumenoTheme.textLight, width: !isPregnant ? 2 : 1),
                          ),
                          child: Column(children: [
                            Icon(Icons.remove_circle_outline, color: !isPregnant ? Colors.grey : RumenoTheme.textGrey, size: 28),
                            const SizedBox(height: 4),
                            Text('Not Pregnant', style: TextStyle(fontWeight: FontWeight.w600, color: !isPregnant ? Colors.grey : RumenoTheme.textGrey)),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isPregnant) ...[
                  const SizedBox(height: 16),
                  const Text('Mating Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                  const SizedBox(height: 8),
                  _datePickerTile(ctx, matingDate, (d) => setModalState(() => matingDate = d)),
                  const SizedBox(height: 12),
                  const Text('Expected Delivery', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                  const SizedBox(height: 8),
                  _datePickerTile(ctx, expectedDelivery, (d) => setModalState(() => expectedDelivery = d)),
                ],
                const SizedBox(height: 24),
                _saveButton(ctx, 'Update Status', () {
                  Navigator.pop(ctx);
                  setState(() {
                    if (isPregnant) {
                      _breedingRecords.add(BreedingRecord(
                        id: 'BR_${DateTime.now().millisecondsSinceEpoch}',
                        animalId: widget.animal.id,
                        heatDate: matingDate,
                        intensity: HeatIntensity.strong,
                        aiDone: false,
                        matingDate: matingDate,
                        isPregnant: true,
                        expectedDelivery: expectedDelivery,
                      ));
                    }
                  });
                  _showSavedSnackBar(isPregnant ? 'Marked as pregnant.' : 'Marked as not pregnant.');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Lactation ──
  void _showAddLactationDialog() {
    DateTime startDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🥛', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Start New Lactation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('Lactation Start Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, startDate, (d) => setModalState(() => startDate = d)),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Start Lactation', () {
                  Navigator.pop(ctx);
                  setState(() {
                    _lactationNumber++;
                    _lactationHistory.add(_LactationRecord(number: _lactationNumber, startDate: startDate));
                  });
                  _showSavedSnackBar('Lactation #$_lactationNumber started!');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Add Mastitis ──
  void _showAddMastitisDialog() {
    DateTime date = DateTime.now();
    String quarter = 'Rear Left';
    String severity = 'Subclinical';
    final treatmentCtrl = TextEditingController();
    final quarters = ['Front Left', 'Front Right', 'Rear Left', 'Rear Right'];
    final severities = ['Subclinical', 'Clinical', 'Acute', 'Chronic'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _pillHandle(),
                const SizedBox(height: 16),
                const Row(children: [Text('🩺', style: TextStyle(fontSize: 26)), SizedBox(width: 10), Text('Record Mastitis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 20),
                const Text('Date Detected', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                _datePickerTile(ctx, date, (d) => setModalState(() => date = d)),
                const SizedBox(height: 16),
                const Text('Udder Quarter', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 3,
                  children: quarters.map((q) {
                    final sel = quarter == q;
                    return GestureDetector(
                      onTap: () => setModalState(() => quarter = q),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: sel ? RumenoTheme.primaryGreen : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? RumenoTheme.primaryGreen : RumenoTheme.textLight, width: sel ? 2 : 1),
                        ),
                        child: Center(child: Text(q, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: sel ? Colors.white : RumenoTheme.textDark))),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Severity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: RumenoTheme.textDark)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: severities.map((s) {
                    final sel = severity == s;
                    return GestureDetector(
                      onTap: () => setModalState(() => severity = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? RumenoTheme.warningYellow.withValues(alpha: 0.15) : RumenoTheme.backgroundCream,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? RumenoTheme.warningYellow : RumenoTheme.textLight, width: sel ? 2 : 1),
                        ),
                        child: Text(s, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: sel ? RumenoTheme.warmBrown : RumenoTheme.textDark)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                _formField(treatmentCtrl, '💊 Treatment given', TextInputType.text),
                const SizedBox(height: 24),
                _saveButton(ctx, 'Save Mastitis Record', () {
                  if (treatmentCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter treatment details'), backgroundColor: RumenoTheme.errorRed));
                    return;
                  }
                  Navigator.pop(ctx);
                  setState(() {
                    _mastitisHistory.add(_MastitisRecord(date: date, quarter: quarter, severity: severity, treatment: treatmentCtrl.text.trim()));
                  });
                  _showSavedSnackBar('Mastitis record added.');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Shared bottom sheet helpers ──
  Widget _pillHandle() {
    return Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))));
  }

  Widget _formField(TextEditingController ctrl, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: RumenoTheme.backgroundCream,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.textLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.textLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _datePickerTile(BuildContext ctx, DateTime current, ValueChanged<DateTime> onPicked) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: ctx, initialDate: current, firstDate: DateTime(2020), lastDate: DateTime(2030));
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: RumenoTheme.backgroundCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RumenoTheme.textLight),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: RumenoTheme.primaryGreen),
            const SizedBox(width: 10),
            Text(DateFormat('dd MMM yyyy').format(current), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.edit, size: 16, color: RumenoTheme.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext ctx, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: RumenoTheme.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _showSavedSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(msg))]),
      backgroundColor: RumenoTheme.successGreen,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final currentPregnancy = _breedingRecords.where((b) => b.isPregnant).toList();

    // Calculate milk dry off date
    DateTime? milkDryOffDate;
    DateTime? expectedDelivery;
    if (currentPregnancy.isNotEmpty && currentPregnancy.last.expectedDelivery != null) {
      expectedDelivery = currentPregnancy.last.expectedDelivery;
      milkDryOffDate = expectedDelivery!.subtract(const Duration(days: 60));
    }

    final now = DateTime.now();
    final dryOffAlert = milkDryOffDate != null && milkDryOffDate.difference(now).inDays <= 7 && milkDryOffDate.isAfter(now);
    final dryOffOverdue = milkDryOffDate != null && milkDryOffDate.isBefore(now);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            // ── Synchronization Section ──
            _sectionHeaderWithAdd('Synchronization', Icons.sync, _showAddSyncDialog),
            if (_syncRecords.isEmpty)
              _EmptySection(message: 'No synchronization records')
            else
              ..._syncRecords.map((s) => _SyncCard(record: s)),

            const SizedBox(height: 20),

            // ── Heat History ──
            _sectionHeaderWithAdd('Heat History', Icons.whatshot, _showAddHeatDialog),
            if (_breedingRecords.isEmpty)
              _EmptySection(message: 'No heat records')
            else
              ..._breedingRecords.map((r) => _HeatCard(record: r)),

            const SizedBox(height: 20),

            // ── Miscarriage History ──
            _sectionHeaderWithAdd('Miscarriage History', Icons.warning_amber_rounded, _showAddMiscarriageDialog),
            if (_miscarriageRecords.isEmpty)
              _EmptySection(message: 'No miscarriage records')
            else
              ..._miscarriageRecords.map((m) => _MiscarriageCard(record: m)),

            const SizedBox(height: 20),

            // ── Artificial Insemination ──
            _sectionHeaderWithAdd('Artificial Insemination', Icons.medical_services_outlined, _showAddAIDialog),
            if (_breedingRecords.where((b) => b.aiDone).isEmpty)
              _EmptySection(message: 'No AI records')
            else
              ..._breedingRecords.where((b) => b.aiDone).map((r) => _AICard(record: r)),

            const SizedBox(height: 20),

            // ── Pregnancy Status ──
            _sectionHeaderWithAdd('Pregnancy Status', Icons.pregnant_woman, _showUpdatePregnancyDialog),
            _PregnancyStatusCard(
              isPregnant: currentPregnancy.isNotEmpty,
              record: currentPregnancy.isNotEmpty ? currentPregnancy.last : null,
            ),

            const SizedBox(height: 20),

            // ── Lactation ──
            _sectionHeaderWithAdd('Lactation', Icons.water_drop_outlined, _showAddLactationDialog),
            _InfoRow('Current Lactation Number', _lactationNumber > 0 ? '$_lactationNumber' : 'N/A'),
            const SizedBox(height: 8),
            if (_lactationHistory.isEmpty)
              _EmptySection(message: 'No lactation history')
            else
              ..._lactationHistory.map((l) => _LactationCard(record: l)),

            const SizedBox(height: 20),

            // ── Mastitis History ──
            _sectionHeaderWithAdd('Mastitis History', Icons.healing, _showAddMastitisDialog),
            if (_mastitisHistory.isEmpty)
              _EmptySection(message: 'No mastitis records')
            else
              ..._mastitisHistory.map((m) => _MastitisCard(record: m)),

            const SizedBox(height: 20),

            // ── Milk Dry Off Date ──
            _ReproSectionHeader(title: 'Milk Dry Off', icon: Icons.event),
            if (milkDryOffDate != null)
              _MilkDryOffCard(
                dryOffDate: milkDryOffDate,
                expectedDelivery: expectedDelivery!,
                isAlert: dryOffAlert,
                isOverdue: dryOffOverdue,
              )
            else
              _EmptySection(message: 'No expected delivery date to calculate dry off'),

            const SizedBox(height: 24),
          ],
        ),
        // FAB
        Positioned(
          right: 16, bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'repro_fab',
            onPressed: () => _showAddRecordMenu(),
            backgroundColor: RumenoTheme.primaryGreen,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Record', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeaderWithAdd(String title, IconData icon, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: RumenoTheme.primaryGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen))),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16, color: RumenoTheme.primaryGreen),
                  SizedBox(width: 4),
                  Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RumenoTheme.primaryGreen)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRecordMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.75),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Add Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _menuItem(ctx, '🔄', 'Synchronization', 'Add sync protocol', () { Navigator.pop(ctx); _showAddSyncDialog(); }),
            _menuItem(ctx, '🔥', 'Heat Observation', 'Record heat detection', () { Navigator.pop(ctx); _showAddHeatDialog(); }),
            _menuItem(ctx, '💉', 'Artificial Insemination', 'Record AI with optional sync', () { Navigator.pop(ctx); _showAddAIDialog(); }),
            _menuItem(ctx, '⚠️', 'Miscarriage', 'Record pregnancy loss', () { Navigator.pop(ctx); _showAddMiscarriageDialog(); }),
            _menuItem(ctx, '🤰', 'Pregnancy Status', 'Update pregnancy check', () { Navigator.pop(ctx); _showUpdatePregnancyDialog(); }),
            _menuItem(ctx, '🥛', 'Start Lactation', 'Begin new lactation period', () { Navigator.pop(ctx); _showAddLactationDialog(); }),
            _menuItem(ctx, '🩺', 'Mastitis', 'Record mastitis incident', () { Navigator.pop(ctx); _showAddMastitisDialog(); }),
          ],
        ),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext ctx, String emoji, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
      trailing: const Icon(Icons.chevron_right, color: RumenoTheme.textGrey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

// ─── Reproduction Data Classes ───

class _SyncRecord {
  final DateTime date;
  final String protocol;
  final String status;
  final String? notes;
  const _SyncRecord({required this.date, required this.protocol, required this.status, this.notes});
}

class _MiscarriageRecord {
  final DateTime date;
  final String stage;
  final String cause;
  final String? notes;
  const _MiscarriageRecord({required this.date, required this.stage, required this.cause, this.notes});
}

class _LactationRecord {
  final int number;
  final DateTime startDate;
  final DateTime? endDate;
  final int? daysInMilk;
  final double? totalMilkLitres;
  const _LactationRecord({required this.number, required this.startDate, this.endDate, this.daysInMilk, this.totalMilkLitres});
}

class _MastitisRecord {
  final DateTime date;
  final String quarter;
  final String severity;
  final String treatment;
  final DateTime? resolvedDate;
  const _MastitisRecord({required this.date, required this.quarter, required this.severity, required this.treatment, this.resolvedDate});
}

// ─── Reproduction Section Widgets ───

class _ReproSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _ReproSectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: RumenoTheme.primaryGreen),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen)),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Center(child: Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey))),
    );
  }
}

class _SyncCard extends StatelessWidget {
  final _SyncRecord record;
  const _SyncCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Protocol: ${record.protocol}', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _StatusChip(label: record.status, color: RumenoTheme.successGreen),
            ],
          ),
          const SizedBox(height: 4),
          Text('Date: ${DateFormat('dd MMM yyyy').format(record.date)}', style: Theme.of(context).textTheme.bodySmall),
          if (record.notes != null)
            Text(record.notes!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _HeatCard extends StatelessWidget {
  final BreedingRecord record;
  const _HeatCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Heat: ${DateFormat('dd MMM yyyy').format(record.heatDate)}', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text('Intensity: ${record.intensity.name[0].toUpperCase()}${record.intensity.name.substring(1)}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          _IntensityIndicator(intensity: record.intensity),
        ],
      ),
    );
  }
}

class _IntensityIndicator extends StatelessWidget {
  final HeatIntensity intensity;
  const _IntensityIndicator({required this.intensity});

  @override
  Widget build(BuildContext context) {
    final color = switch (intensity) {
      HeatIntensity.strong => RumenoTheme.errorRed,
      HeatIntensity.moderate => RumenoTheme.warningYellow,
      HeatIntensity.mild => RumenoTheme.successGreen,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(intensity.name[0].toUpperCase() + intensity.name.substring(1), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _MiscarriageCard extends StatelessWidget {
  final _MiscarriageRecord record;
  const _MiscarriageCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RumenoTheme.errorRed.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: RumenoTheme.errorRed),
              const SizedBox(width: 6),
              Text('Miscarriage - ${DateFormat('dd MMM yyyy').format(record.date)}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: RumenoTheme.errorRed)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Stage: ${record.stage} • Cause: ${record.cause}', style: Theme.of(context).textTheme.bodySmall),
          if (record.notes != null)
            Text(record.notes!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _AICard extends StatelessWidget {
  final BreedingRecord record;
  const _AICard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('AI - ${DateFormat('dd MMM yyyy').format(record.matingDate ?? record.heatDate)}', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _StatusChip(
                label: record.isPregnant ? 'Successful' : 'Pending',
                color: record.isPregnant ? RumenoTheme.successGreen : RumenoTheme.warningYellow,
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (record.bullSemenId != null)
            Text('Bull/Semen ID: ${record.bullSemenId}', style: Theme.of(context).textTheme.bodySmall),
          if (record.technicianName != null)
            Text('Technician: ${record.technicianName}', style: Theme.of(context).textTheme.bodySmall),
          Text('Heat Intensity: ${record.intensity.name[0].toUpperCase()}${record.intensity.name.substring(1)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.textGrey)),
        ],
      ),
    );
  }
}

class _PregnancyStatusCard extends StatelessWidget {
  final bool isPregnant;
  final BreedingRecord? record;
  const _PregnancyStatusCard({required this.isPregnant, this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPregnant ? RumenoTheme.infoBlue.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPregnant ? Icons.check_circle : Icons.remove_circle_outline,
                color: isPregnant ? RumenoTheme.infoBlue : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isPregnant ? 'Currently Pregnant' : 'Not Pregnant',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isPregnant ? RumenoTheme.infoBlue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isPregnant && record != null) ...[
            const SizedBox(height: 10),
            _InfoRow('Mating Date', record!.matingDate != null ? DateFormat('dd MMM yyyy').format(record!.matingDate!) : '-'),
            _InfoRow('Expected Delivery', record!.expectedDelivery != null ? DateFormat('dd MMM yyyy').format(record!.expectedDelivery!) : '-'),
            if (record!.expectedDelivery != null)
              _InfoRow('Days Remaining', '${record!.expectedDelivery!.difference(DateTime.now()).inDays} days'),
          ],
        ],
      ),
    );
  }
}

class _LactationCard extends StatelessWidget {
  final _LactationRecord record;
  const _LactationCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final isCurrent = record.endDate == null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.4)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Lactation #${record.number}', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              if (isCurrent) _StatusChip(label: 'Current', color: RumenoTheme.primaryGreen),
            ],
          ),
          const SizedBox(height: 6),
          Text('Start: ${DateFormat('dd MMM yyyy').format(record.startDate)}', style: Theme.of(context).textTheme.bodySmall),
          if (record.endDate != null)
            Text('End: ${DateFormat('dd MMM yyyy').format(record.endDate!)}', style: Theme.of(context).textTheme.bodySmall),
          if (record.daysInMilk != null)
            Text('Days in Milk: ${record.daysInMilk}', style: Theme.of(context).textTheme.bodySmall),
          if (record.totalMilkLitres != null)
            Text('Total Yield: ${record.totalMilkLitres!.toStringAsFixed(0)} L', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MastitisCard extends StatelessWidget {
  final _MastitisRecord record;
  const _MastitisCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final isResolved = record.resolvedDate != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isResolved ? Colors.grey.withValues(alpha: 0.2) : RumenoTheme.warningYellow.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${record.severity} Mastitis', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              _StatusChip(label: isResolved ? 'Resolved' : 'Active', color: isResolved ? RumenoTheme.successGreen : RumenoTheme.warningYellow),
            ],
          ),
          const SizedBox(height: 6),
          Text('Date: ${DateFormat('dd MMM yyyy').format(record.date)}', style: Theme.of(context).textTheme.bodySmall),
          Text('Quarter: ${record.quarter}', style: Theme.of(context).textTheme.bodySmall),
          Text('Treatment: ${record.treatment}', style: Theme.of(context).textTheme.bodySmall),
          if (isResolved)
            Text('Resolved: ${DateFormat('dd MMM yyyy').format(record.resolvedDate!)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: RumenoTheme.successGreen)),
        ],
      ),
    );
  }
}

class _MilkDryOffCard extends StatelessWidget {
  final DateTime dryOffDate;
  final DateTime expectedDelivery;
  final bool isAlert;
  final bool isOverdue;
  const _MilkDryOffCard({required this.dryOffDate, required this.expectedDelivery, required this.isAlert, required this.isOverdue});

  @override
  Widget build(BuildContext context) {
    final daysUntilDryOff = dryOffDate.difference(DateTime.now()).inDays;

    Color borderColor;
    Color iconColor;
    String alertMessage;
    if (isOverdue) {
      borderColor = RumenoTheme.errorRed;
      iconColor = RumenoTheme.errorRed;
      alertMessage = 'Milk dry off date has passed! Stop milking immediately to ensure proper dry period before delivery.';
    } else if (isAlert) {
      borderColor = RumenoTheme.warningYellow;
      iconColor = RumenoTheme.warningYellow;
      alertMessage = 'Milk dry off approaching in $daysUntilDryOff days. Plan to stop milking by ${DateFormat('dd MMM yyyy').format(dryOffDate)} to allow 60 days dry period before expected delivery.';
    } else {
      borderColor = RumenoTheme.infoBlue;
      iconColor = RumenoTheme.infoBlue;
      alertMessage = 'Dry off scheduled 60 days before expected delivery date.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.4), width: isAlert || isOverdue ? 1.5 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isOverdue ? Icons.error : isAlert ? Icons.warning_amber_rounded : Icons.event, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text('Milk Dry Off Date', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow('Dry Off Date', DateFormat('dd MMM yyyy').format(dryOffDate)),
          _InfoRow('Expected Delivery', DateFormat('dd MMM yyyy').format(expectedDelivery)),
          if (!isOverdue)
            _InfoRow('Days Until Dry Off', '$daysUntilDryOff days'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: borderColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(alertMessage, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: borderColor, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Family Tab ──────────────────────────────

class _FamilyTab extends StatelessWidget {
  final Animal animal;
  const _FamilyTab({required this.animal});

  void _navigateToAnimal(BuildContext context, String animalId) {
    context.push('/farmer/animals/$animalId');
  }

  Widget _animalChip(BuildContext context, Animal a, {bool isWarning = false}) {
    return GestureDetector(
      onTap: () => _navigateToAnimal(context, a.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isWarning
              ? RumenoTheme.warningYellow.withValues(alpha: 0.1)
              : RumenoTheme.primaryGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isWarning
                ? RumenoTheme.warningYellow.withValues(alpha: 0.4)
                : RumenoTheme.primaryGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(a.gender == Gender.male ? '♂' : '♀', style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.tagId, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isWarning ? RumenoTheme.warmBrown : RumenoTheme.primaryGreen)),
                Text(a.breed, style: const TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
              ],
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: isWarning ? RumenoTheme.warmBrown : RumenoTheme.primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _parentBlock(BuildContext context, Animal? parent, String role, IconData icon, Color color) {
    final grandpa = parent?.fatherId != null ? getAnimalById(parent!.fatherId!) : null;
    final grandma = parent?.motherId != null ? getAnimalById(parent!.motherId!) : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Text(role, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: RumenoTheme.textDark)),
            ],
          ),
          const SizedBox(height: 12),
          if (parent == null)
            const Text('Unknown', style: TextStyle(color: RumenoTheme.textGrey, fontStyle: FontStyle.italic))
          else ...[
            _animalChip(context, parent),
            const SizedBox(height: 12),
            // Grandparents
            if (grandpa != null || grandma != null) ...[
              Text(
                'Parents of ${parent.tagId}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: RumenoTheme.textGrey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (grandpa != null)
                    _grandparentChip(context, grandpa, role.contains('Father') ? 'Paternal Grandfather' : 'Maternal Grandfather'),
                  if (grandma != null)
                    _grandparentChip(context, grandma, role.contains('Father') ? 'Paternal Grandmother' : 'Maternal Grandmother'),
                ],
              ),
            ] else
              const Text('Grandparents unknown', style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey, fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }

  Widget _grandparentChip(BuildContext context, Animal gp, String label) {
    return GestureDetector(
      onTap: () => _navigateToAnimal(context, gp.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: RumenoTheme.backgroundCream,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: RumenoTheme.textLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_tree_outlined, size: 13, color: RumenoTheme.textGrey),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: RumenoTheme.textGrey)),
                Text(gp.tagId, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: RumenoTheme.textDark)),
                Text(gp.breed, style: const TextStyle(fontSize: 10, color: RumenoTheme.textGrey)),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.open_in_new_rounded, size: 11, color: RumenoTheme.textGrey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final father = animal.fatherId != null ? getAnimalById(animal.fatherId!) : null;
    final mother = animal.motherId != null ? getAnimalById(animal.motherId!) : null;
    final siblings = getSiblingsOf(animal);
    final children = getChildrenOf(animal.id);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Father block ──
        _parentBlock(context, father, 'Father', Icons.male, const Color(0xFF1565C0)),
        const SizedBox(height: 14),

        // ── Mother block ──
        _parentBlock(context, mother, 'Mother', Icons.female, const Color(0xFFC2185B)),
        const SizedBox(height: 20),

        // ── Siblings ──
        Row(
          children: [
            const Icon(Icons.people_alt_outlined, color: RumenoTheme.primaryGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              'Siblings (${siblings.isEmpty ? "None" : "${siblings.length} found"})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (animal.numberOfSiblings != null && animal.numberOfSiblings! > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${animal.numberOfSiblings} sibling${animal.numberOfSiblings! > 1 ? "s" : ""} recorded at birth',
              style: const TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
            ),
          ),
        const SizedBox(height: 8),
        if (siblings.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: const Text('No siblings found in farm records', style: TextStyle(color: RumenoTheme.textGrey, fontStyle: FontStyle.italic)),
          )
        else
          Wrap(
            spacing: 8, runSpacing: 8,
            children: siblings.map((s) => _animalChip(context, s)).toList(),
          ),
        const SizedBox(height: 20),

        // ── Children / Offspring ──
        Row(
          children: [
            const Icon(Icons.child_friendly, color: RumenoTheme.accentOlive, size: 20),
            const SizedBox(width: 8),
            Text(
              'Offspring (${children.isEmpty ? "None" : "${children.length} found"})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (children.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: const Text('No recorded offspring in farm', style: TextStyle(color: RumenoTheme.textGrey, fontStyle: FontStyle.italic)),
          )
        else
          Column(
            children: children.map((c) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: RumenoTheme.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(c.gender == Gender.male ? '♂' : '♀', style: const TextStyle(fontSize: 20))),
                  ),
                  title: Text(c.tagId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(
                    '${c.breed} • ${c.ageString} • ${c.statusLabel}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: RumenoTheme.primaryGreen),
                    onPressed: () => _navigateToAnimal(context, c.id),
                  ),
                  onTap: () => _navigateToAnimal(context, c.id),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
