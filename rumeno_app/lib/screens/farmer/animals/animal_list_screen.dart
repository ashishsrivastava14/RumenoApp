import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/animal_card.dart';
import '../../../widgets/common/marketplace_button.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  String _searchQuery = '';
  Species? _selectedSpecies;
  AnimalStatus? _selectedStatus;
  Gender? _selectedGender;
  AnimalPurpose? _selectedPurpose;
  String _sortBy = 'Tag';

  int get _activeFilterCount {
    int count = 0;
    if (_selectedStatus != null) count++;
    if (_selectedGender != null) count++;
    if (_selectedPurpose != null) count++;
    return count;
  }

  List<Animal> get _filteredAnimals {
    var list = mockAnimals.toList();
    if (_selectedSpecies != null) {
      list = list.where((a) => a.species == _selectedSpecies).toList();
    }
    if (_selectedStatus != null) {
      list = list.where((a) => a.status == _selectedStatus).toList();
    }
    if (_selectedGender != null) {
      list = list.where((a) => a.gender == _selectedGender).toList();
    }
    if (_selectedPurpose != null) {
      list = list.where((a) => a.purpose == _selectedPurpose).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((a) =>
          a.tagId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.breed.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    switch (_sortBy) {
      case 'Name':
        list.sort((a, b) => a.breed.compareTo(b.breed));
        break;
      case 'Tag':
        list.sort((a, b) => a.tagId.compareTo(b.tagId));
        break;
      case 'Age':
        list.sort((a, b) => a.dateOfBirth.compareTo(b.dateOfBirth));
        break;
    }
    return list;
  }

  void _openQrScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _QrScannerScreen(
          onAnimalFound: (animal) {
            context.go('/farmer/animals/${animal.id}');
          },
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _FilterBottomSheet(
          selectedStatus: _selectedStatus,
          selectedGender: _selectedGender,
          selectedPurpose: _selectedPurpose,
          onApply: (status, gender, purpose) {
            setState(() {
              _selectedStatus = status;
              _selectedGender = gender;
              _selectedPurpose = purpose;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('My Animals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/farmer/dashboard');
            }
          },
        ),
        actions: [
          const VeterinarianButton(),
          const MarketplaceButton(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (context) => ['Tag', 'Name', 'Age', 'Status']
                .map((s) => PopupMenuItem(value: s, child: Text('Sort by $s')))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar with QR scanner and filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search by tag or breed...',
                        hintStyle: TextStyle(color: RumenoTheme.textLight),
                        prefixIcon: Icon(Icons.search, color: RumenoTheme.textGrey),
                        suffixIcon: Badge(
                          isLabelVisible: _activeFilterCount > 0,
                          label: Text('$_activeFilterCount'),
                          child: IconButton(
                            icon: Icon(Icons.tune, color: RumenoTheme.primaryGreen),
                            onPressed: _showFilterSheet,
                          ),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _QrScanButton(onTap: _openQrScanner),
              ],
            ),
          ),
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(label: 'All', selected: _selectedSpecies == null, onTap: () => setState(() => _selectedSpecies = null)),
                _FilterChip(label: 'Cow', selected: _selectedSpecies == Species.cow, onTap: () => setState(() => _selectedSpecies = Species.cow)),
                _FilterChip(label: 'Buffalo', selected: _selectedSpecies == Species.buffalo, onTap: () => setState(() => _selectedSpecies = Species.buffalo)),
                _FilterChip(label: 'Goat', selected: _selectedSpecies == Species.goat, onTap: () => setState(() => _selectedSpecies = Species.goat)),
                _FilterChip(label: 'Sheep', selected: _selectedSpecies == Species.sheep, onTap: () => setState(() => _selectedSpecies = Species.sheep)),
                _FilterChip(label: 'Pig', selected: _selectedSpecies == Species.pig, onTap: () => setState(() => _selectedSpecies = Species.pig)),
                _FilterChip(label: 'Horse', selected: _selectedSpecies == Species.horse, onTap: () => setState(() => _selectedSpecies = Species.horse)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Active filter tags
          if (_activeFilterCount > 0)
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_selectedStatus != null)
                    _ActiveFilterTag(
                      label: _selectedStatus!.name[0].toUpperCase() + _selectedStatus!.name.substring(1),
                      onRemove: () => setState(() => _selectedStatus = null),
                    ),
                  if (_selectedGender != null)
                    _ActiveFilterTag(
                      label: _selectedGender == Gender.male ? 'Male' : 'Female',
                      onRemove: () => setState(() => _selectedGender = null),
                    ),
                  if (_selectedPurpose != null)
                    _ActiveFilterTag(
                      label: _selectedPurpose!.name[0].toUpperCase() + _selectedPurpose!.name.substring(1),
                      onRemove: () => setState(() => _selectedPurpose = null),
                    ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedStatus = null;
                      _selectedGender = null;
                      _selectedPurpose = null;
                    }),
                    child: Chip(
                      label: const Text('Clear all', style: TextStyle(fontSize: 12, color: Colors.red)),
                      backgroundColor: Colors.red.shade50,
                      side: BorderSide(color: Colors.red.shade200),
                      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          if (_activeFilterCount > 0) const SizedBox(height: 4),
          // Animal count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('${_filteredAnimals.length} animals', style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              child: ListView.builder(
                itemCount: _filteredAnimals.length,
                itemBuilder: (context, index) {
                  final animal = _filteredAnimals[index];
                  return AnimalCard(
                    animal: animal,
                    onTap: () => context.go('/farmer/animals/${animal.id}'),
                    onHealthTap: () => context.go('/farmer/health'),
                    onBreedTap: () => context.go('/farmer/breeding'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/farmer/animals/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Animal'),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label, style: TextStyle(color: selected ? Colors.white : RumenoTheme.textDark, fontSize: 13)),
          backgroundColor: selected ? RumenoTheme.primaryGreen : Colors.white,
          side: BorderSide(color: selected ? RumenoTheme.primaryGreen : Colors.grey.shade300),
        ),
      ),
    );
  }
}

// ── QR Scan Button ──────────────────────────────────────────────────────────

class _QrScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _QrScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: RumenoTheme.primaryGreen,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
      ),
    );
  }
}

// ── Active Filter Tag ───────────────────────────────────────────────────────

class _ActiveFilterTag extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterTag({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
        side: BorderSide(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// ── Filter Bottom Sheet ─────────────────────────────────────────────────────

class _FilterBottomSheet extends StatefulWidget {
  final AnimalStatus? selectedStatus;
  final Gender? selectedGender;
  final AnimalPurpose? selectedPurpose;
  final void Function(AnimalStatus?, Gender?, AnimalPurpose?) onApply;

  const _FilterBottomSheet({
    required this.selectedStatus,
    required this.selectedGender,
    required this.selectedPurpose,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late AnimalStatus? _status;
  late Gender? _gender;
  late AnimalPurpose? _purpose;

  @override
  void initState() {
    super.initState();
    _status = widget.selectedStatus;
    _gender = widget.selectedGender;
    _purpose = widget.selectedPurpose;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => setState(() {
                  _status = null;
                  _gender = null;
                  _purpose = null;
                }),
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status filter
          Text('Status', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: AnimalStatus.values.map((status) {
              final label = status.name[0].toUpperCase() + status.name.substring(1);
              final isSelected = _status == status;
              return ChoiceChip(
                label: Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : RumenoTheme.textDark)),
                selected: isSelected,
                selectedColor: RumenoTheme.primaryGreen,
                onSelected: (sel) => setState(() => _status = sel ? status : null),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Gender filter
          Text('Gender', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: Gender.values.map((g) {
              final label = g == Gender.male ? 'Male' : 'Female';
              final isSelected = _gender == g;
              return ChoiceChip(
                label: Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : RumenoTheme.textDark)),
                selected: isSelected,
                selectedColor: RumenoTheme.primaryGreen,
                onSelected: (sel) => setState(() => _gender = sel ? g : null),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Purpose filter
          Text('Purpose', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: AnimalPurpose.values.map((p) {
              final label = p.name[0].toUpperCase() + p.name.substring(1);
              final isSelected = _purpose == p;
              return ChoiceChip(
                label: Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : RumenoTheme.textDark)),
                selected: isSelected,
                selectedColor: RumenoTheme.primaryGreen,
                onSelected: (sel) => setState(() => _purpose = sel ? p : null),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                widget.onApply(_status, _gender, _purpose);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── QR Scanner Screen ───────────────────────────────────────────────────────

class _QrScannerScreen extends StatefulWidget {
  final void Function(Animal animal) onAnimalFound;

  const _QrScannerScreen({required this.onAnimalFound});

  @override
  State<_QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<_QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final scannedValue = barcode.rawValue!.trim();
    // Try matching by tag ID or animal ID
    final animal = getAnimalByTag(scannedValue) ?? getAnimalById(scannedValue);

    if (animal != null) {
      _hasScanned = true;
      Navigator.pop(context);
      widget.onAnimalFound(animal);
    } else {
      _hasScanned = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No animal found for "$scannedValue"'),
          backgroundColor: RumenoTheme.errorRed,
          action: SnackBarAction(
            label: 'Scan again',
            textColor: Colors.white,
            onPressed: () => setState(() => _hasScanned = false),
          ),
        ),
      );
      // Allow re-scanning after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _hasScanned = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Animal QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Scanner overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: RumenoTheme.primaryGreen, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Point the camera at the animal\'s QR code',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _controller.toggleTorch(),
                      icon: const Icon(Icons.flash_on, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () => _controller.switchCamera(),
                      icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
