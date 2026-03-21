import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../mock/mock_farmers.dart';
import '../../models/models.dart';
import '../../widgets/cards/farmer_card.dart';

class AdminFarmersScreen extends StatefulWidget {
  const AdminFarmersScreen({super.key});

  @override
  State<AdminFarmersScreen> createState() => _AdminFarmersScreenState();
}

class _AdminFarmersScreenState extends State<AdminFarmersScreen> {
  String _search = '';
  String _planFilter = 'All';
  late List<Farmer> _farmers;

  @override
  void initState() {
    super.initState();
    _farmers = List.from(mockFarmers);
  }

  List<Farmer> get _filteredFarmers {
    return _farmers.where((f) {
      final matchSearch = f.name.toLowerCase().contains(_search.toLowerCase()) ||
          f.farmName.toLowerCase().contains(_search.toLowerCase()) ||
          f.phone.contains(_search);
      final matchPlan = _planFilter == 'All' || f.planName == _planFilter;
      return matchSearch && matchPlan;
    }).toList();
  }

  void _toggleFarmerStatus(Farmer farmer) {
    setState(() {
      final idx = _farmers.indexWhere((f) => f.id == farmer.id);
      if (idx != -1) {
        _farmers[idx] = Farmer(
          id: farmer.id,
          name: farmer.name,
          phone: farmer.phone,
          farmName: farmer.farmName,
          address: farmer.address,
          state: farmer.state,
          gpsLocation: farmer.gpsLocation,
          plan: farmer.plan,
          joinedDate: farmer.joinedDate,
          animalCount: farmer.animalCount,
          isActive: !farmer.isActive,
          vetId: farmer.vetId,
          managerName: farmer.managerName,
        );
      }
    });
  }

  void _updateFarmer(Farmer updated) {
    setState(() {
      final idx = _farmers.indexWhere((f) => f.id == updated.id);
      if (idx != -1) {
        _farmers[idx] = updated;
      }
    });
  }

  void _addFarmer(Farmer farmer) {
    setState(() => _farmers.add(farmer));
  }

  void _deleteFarmer(String id) {
    setState(() => _farmers.removeWhere((f) => f.id == id));
  }

  Future<void> _callFarmer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFarmers;
    final totalFarmers = _farmers.length;
    final activeFarmers = _farmers.where((f) => f.isActive).length;
    final inactiveFarmers = totalFarmers - activeFarmers;
    final proFarmers = _farmers.where((f) => f.planName == 'Pro' || f.planName == 'Business').length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFarmerForm(context),
        backgroundColor: RumenoTheme.primaryGreen,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
        label: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/admin/dashboard');
                }
              },
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.download_done_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('Exporting farmer data...'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Title with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.people_alt_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Manage Farmers',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Quick stats row - larger, more visual
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.people_rounded,
                          value: '$totalFarmers',
                          label: 'Total',
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.check_circle_rounded,
                          value: '$activeFarmers',
                          label: 'Active',
                          color: const Color(0xFF66BB6A),
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.cancel_rounded,
                          value: '$inactiveFarmers',
                          label: 'Inactive',
                          color: const Color(0xFFEF5350),
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.star_rounded,
                          value: '$proFarmers',
                          label: 'Premium',
                          color: const Color(0xFFFFD54F),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Search bar - large and easy to use
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: TextField(
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                      prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 24),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                // Filter chips - larger, color-coded with icons
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _FilterChip(label: 'All', icon: Icons.people_rounded, isSelected: _planFilter == 'All', color: Colors.blueGrey, onTap: () => setState(() => _planFilter = 'All')),
                      _FilterChip(label: 'Free', icon: Icons.card_giftcard_rounded, isSelected: _planFilter == 'Free', color: RumenoTheme.planFree, onTap: () => setState(() => _planFilter = 'Free')),
                      _FilterChip(label: 'Starter', icon: Icons.rocket_launch_rounded, isSelected: _planFilter == 'Starter', color: RumenoTheme.planStarter, onTap: () => setState(() => _planFilter = 'Starter')),
                      _FilterChip(label: 'Pro', icon: Icons.star_rounded, isSelected: _planFilter == 'Pro', color: RumenoTheme.planPro, onTap: () => setState(() => _planFilter = 'Pro')),
                      _FilterChip(label: 'Business', icon: Icons.diamond_rounded, isSelected: _planFilter == 'Business', color: RumenoTheme.planBusiness, onTap: () => setState(() => _planFilter = 'Business')),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                // Result count with visual indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.format_list_numbered_rounded, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text('${filtered.length} farmers',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600])),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.person_search_rounded, size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('No farmers found', style: TextStyle(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final farmer = filtered[index];
                return FarmerCard(
                  farmer: farmer,
                  onTap: () => _showFarmerDetail(context, farmer),
                  onCall: () => _callFarmer(farmer.phone),
                );
              },
              childCount: filtered.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  void _showFarmerDetail(BuildContext context, Farmer farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FarmerDetailSheet(
        farmer: farmer,
        onToggleStatus: () {
          _toggleFarmerStatus(farmer);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    farmer.isActive ? Icons.cancel_rounded : Icons.check_circle_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(farmer.isActive ? '${farmer.name} deactivated' : '${farmer.name} activated'),
                ],
              ),
              backgroundColor: farmer.isActive ? RumenoTheme.errorRed : RumenoTheme.successGreen,
            ),
          );
        },
        onEdit: () {
          Navigator.pop(ctx);
          _showEditFarmerForm(context, farmer);
        },
        onCall: () => _callFarmer(farmer.phone),
        onDelete: () {
          Navigator.pop(ctx);
          _showDeleteConfirmation(context, farmer);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Farmer farmer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_forever_rounded, color: RumenoTheme.errorRed, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Delete ${farmer.name}?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('This action cannot be undone',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _deleteFarmer(farmer.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.delete_rounded, color: Colors.white),
                            const SizedBox(width: 8),
                            Text('${farmer.name} removed'),
                          ],
                        ),
                        backgroundColor: RumenoTheme.errorRed,
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                  label: const Text('Delete', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.errorRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddFarmerForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FarmerFormSheet(
        onSave: (farmer) {
          _addFarmer(farmer);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('${farmer.name} added successfully'),
                ],
              ),
              backgroundColor: RumenoTheme.successGreen,
            ),
          );
        },
      ),
    );
  }

  void _showEditFarmerForm(BuildContext context, Farmer farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FarmerFormSheet(
        farmer: farmer,
        onSave: (updated) {
          _updateFarmer(updated);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('${updated.name} updated'),
                ],
              ),
              backgroundColor: RumenoTheme.successGreen,
            ),
          );
        },
      ),
    );
  }
}

// ─── Farmer Detail Bottom Sheet ───────────────────────────────────────────────

class _FarmerDetailSheet extends StatelessWidget {
  final Farmer farmer;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onCall;
  final VoidCallback onDelete;

  const _FarmerDetailSheet({
    required this.farmer,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onCall,
    required this.onDelete,
  });

  Color _planColor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return RumenoTheme.planFree;
      case SubscriptionPlan.starter: return RumenoTheme.planStarter;
      case SubscriptionPlan.pro: return RumenoTheme.planPro;
      case SubscriptionPlan.business: return RumenoTheme.planBusiness;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),

              // Profile header with large avatar
              Center(
                child: Column(
                  children: [
                    // Large avatar with status
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              farmer.name[0],
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              farmer.isActive ? Icons.check_rounded : Icons.close_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      farmer.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      farmer.farmName,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // Plan badge - large
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _planColor(farmer.plan).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        farmer.planName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _planColor(farmer.plan),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info cards - large, icon-first design
              _DetailTile(icon: Icons.phone_rounded, color: RumenoTheme.successGreen, label: 'Phone', value: farmer.phone),
              _DetailTile(icon: Icons.location_on_rounded, color: const Color(0xFFE53935), label: 'Location', value: '${farmer.address}, ${farmer.state}'),
              _DetailTile(icon: Icons.pets_rounded, color: const Color(0xFF8D6E63), label: 'Animals', value: '${farmer.animalCount}'),
              _DetailTile(
                icon: farmer.isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: farmer.isActive ? RumenoTheme.successGreen : RumenoTheme.errorRed,
                label: 'Status',
                value: farmer.isActive ? 'Active' : 'Inactive',
              ),
              _DetailTile(icon: Icons.calendar_month_rounded, color: const Color(0xFF1565C0), label: 'Joined', value: '${farmer.joinedDate.day}/${farmer.joinedDate.month}/${farmer.joinedDate.year}'),
              if (farmer.vetId != null)
                _DetailTile(icon: Icons.medical_services_rounded, color: const Color(0xFF7B1FA2), label: 'Vet ID', value: farmer.vetId!),
              if (farmer.managerName != null)
                _DetailTile(icon: Icons.person_rounded, color: const Color(0xFF00897B), label: 'Manager', value: farmer.managerName!),

              const SizedBox(height: 24),

              // Action buttons - large, colorful, icon-first
              // Row 1: Call & Edit
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.phone_rounded,
                      label: 'Call',
                      color: RumenoTheme.successGreen,
                      onTap: onCall,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      color: const Color(0xFF1565C0),
                      onTap: onEdit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2: Toggle Status & Delete
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: farmer.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                      label: farmer.isActive ? 'Deactivate' : 'Activate',
                      color: farmer.isActive ? Colors.orange : RumenoTheme.successGreen,
                      onTap: onToggleStatus,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.delete_rounded,
                      label: 'Delete',
                      color: RumenoTheme.errorRed,
                      onTap: onDelete,
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
}

// ─── Farmer Add/Edit Form Sheet ───────────────────────────────────────────────

class _FarmerFormSheet extends StatefulWidget {
  final Farmer? farmer;
  final void Function(Farmer) onSave;

  const _FarmerFormSheet({this.farmer, required this.onSave});

  @override
  State<_FarmerFormSheet> createState() => _FarmerFormSheetState();
}

class _FarmerFormSheetState extends State<_FarmerFormSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _farmNameCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _animalCountCtrl;
  late SubscriptionPlan _plan;
  bool get _isEdit => widget.farmer != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.farmer?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.farmer?.phone ?? '');
    _farmNameCtrl = TextEditingController(text: widget.farmer?.farmName ?? '');
    _addressCtrl = TextEditingController(text: widget.farmer?.address ?? '');
    _stateCtrl = TextEditingController(text: widget.farmer?.state ?? '');
    _animalCountCtrl = TextEditingController(text: widget.farmer?.animalCount.toString() ?? '0');
    _plan = widget.farmer?.plan ?? SubscriptionPlan.free;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _farmNameCtrl.dispose();
    _addressCtrl.dispose();
    _stateCtrl.dispose();
    _animalCountCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    return _nameCtrl.text.trim().isNotEmpty &&
        _phoneCtrl.text.trim().isNotEmpty &&
        _farmNameCtrl.text.trim().isNotEmpty &&
        _stateCtrl.text.trim().isNotEmpty;
  }

  void _save() {
    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Please fill all required fields'),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final farmer = Farmer(
      id: widget.farmer?.id ?? 'F${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      farmName: _farmNameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      plan: _plan,
      joinedDate: widget.farmer?.joinedDate ?? DateTime.now(),
      animalCount: int.tryParse(_animalCountCtrl.text) ?? 0,
      isActive: widget.farmer?.isActive ?? true,
      vetId: widget.farmer?.vetId,
      managerName: widget.farmer?.managerName,
    );
    widget.onSave(farmer);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _isEdit ? Icons.edit_rounded : Icons.person_add_rounded,
                      color: RumenoTheme.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isEdit ? 'Edit Farmer' : 'Add New Farmer',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form fields with icons
              _FormField(
                icon: Icons.person_rounded,
                label: 'Name',
                controller: _nameCtrl,
                hint: 'Farmer name',
                required: true,
              ),
              _FormField(
                icon: Icons.phone_rounded,
                label: 'Phone',
                controller: _phoneCtrl,
                hint: 'Phone number',
                keyboardType: TextInputType.phone,
                required: true,
              ),
              _FormField(
                icon: Icons.home_work_rounded,
                label: 'Farm Name',
                controller: _farmNameCtrl,
                hint: 'Farm name',
                required: true,
              ),
              _FormField(
                icon: Icons.location_on_rounded,
                label: 'Address',
                controller: _addressCtrl,
                hint: 'Village, District',
              ),
              _FormField(
                icon: Icons.map_rounded,
                label: 'State',
                controller: _stateCtrl,
                hint: 'State',
                required: true,
              ),
              _FormField(
                icon: Icons.pets_rounded,
                label: 'Animals',
                controller: _animalCountCtrl,
                hint: '0',
                keyboardType: TextInputType.number,
              ),

              // Plan selector - visual with icons
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.card_membership_rounded, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('Plan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SubscriptionPlan.values.map((plan) {
                  final isSelected = _plan == plan;
                  final color = _planColorFor(plan);
                  final icon = _planIconFor(plan);
                  final name = _planNameFor(plan);
                  return GestureDetector(
                    onTap: () => setState(() => _plan = plan),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? color : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Save button - large and prominent
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(_isEdit ? Icons.save_rounded : Icons.person_add_rounded, color: Colors.white, size: 24),
                  label: Text(
                    _isEdit ? 'Save Changes' : 'Add Farmer',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _planColorFor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return RumenoTheme.planFree;
      case SubscriptionPlan.starter: return RumenoTheme.planStarter;
      case SubscriptionPlan.pro: return RumenoTheme.planPro;
      case SubscriptionPlan.business: return RumenoTheme.planBusiness;
    }
  }

  IconData _planIconFor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return Icons.card_giftcard_rounded;
      case SubscriptionPlan.starter: return Icons.rocket_launch_rounded;
      case SubscriptionPlan.pro: return Icons.star_rounded;
      case SubscriptionPlan.business: return Icons.diamond_rounded;
    }
  }

  String _planNameFor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.free: return 'Free';
      case SubscriptionPlan.starter: return 'Starter';
      case SubscriptionPlan.pro: return 'Pro';
      case SubscriptionPlan.business: return 'Business';
    }
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? color : Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool required;

  const _FormField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              if (required) Text(' *', style: TextStyle(color: RumenoTheme.errorRed, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey.withValues(alpha: 0.06),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: RumenoTheme.primaryGreen, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
