import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_health.dart';
import '../../models/models.dart';
import '../../providers/admin_provider.dart';

class AdminVetsScreen extends StatefulWidget {
  const AdminVetsScreen({super.key});

  @override
  State<AdminVetsScreen> createState() => _AdminVetsScreenState();
}

class _AdminVetsScreenState extends State<AdminVetsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF880E4F), Color(0xFFAD1457)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text('🩺', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Vet Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text('All Veterinarians',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(icon: Text('👨‍⚕️', style: TextStyle(fontSize: 16)), text: 'Vets'),
                Tab(icon: Text('📋', style: TextStyle(fontSize: 16)), text: 'Consults'),
                Tab(icon: Text('📅', style: TextStyle(fontSize: 16)), text: 'Schedule'),
                Tab(icon: Text('💰', style: TextStyle(fontSize: 16)), text: 'Earnings'),
                Tab(icon: Text('📊', style: TextStyle(fontSize: 16)), text: 'Performance'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _VetsTab(),
            _ConsultationsTab(),
            _ScheduleTab(),
            _EarningsTab(),
            _PerformanceTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteVetDialog(context),
        icon: const Icon(Icons.person_add_rounded, size: 28),
        label: const Text('➕ Invite Vet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFAD1457),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  void _showInviteVetDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final specCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('👨‍⚕️', style: TextStyle(fontSize: 28)),
            SizedBox(width: 10),
            Text('Invite Veterinarian', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    labelText: '👤  Full Name',
                    labelStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(Icons.person, size: 28, color: Color(0xFFAD1457)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
            const SizedBox(height: 14),
            TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    labelText: '📞  Phone Number',
                    labelStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(Icons.phone, size: 28, color: Color(0xFFAD1457)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
            const SizedBox(height: 14),
            TextField(
                controller: specCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    labelText: '🏥  Specialization',
                    labelStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(Icons.medical_information, size: 28, color: Color(0xFFAD1457)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
          ],
        ),
        actions: [
          TextButton.icon(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.close_rounded, size: 20),
              label: const Text('Cancel', style: TextStyle(fontSize: 14))),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAD1457),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final admin = context.read<AdminProvider>();
              admin.addVet(VetModel(
                id: 'V${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                specialization: specCtrl.text.trim().isEmpty ? 'General' : specCtrl.text.trim(),
                licenseNumber: 'VET-NEW-${DateTime.now().year}-${DateTime.now().millisecond}',
                status: VetStatus.pending,
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invite sent to ${nameCtrl.text}!')));
            },
            icon: const Icon(Icons.send_rounded, size: 20),
            label: const Text('📨 Send Invite', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─── Vets Tab ─────────────────────────────────────────────────────────────────
class _VetsTab extends StatefulWidget {
  @override
  State<_VetsTab> createState() => _VetsTabState();
}

class _VetsTabState extends State<_VetsTab> {
  String _search = '';
  VetStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final allVets = admin.vets;

    final filtered = allVets.where((v) {
      final matchSearch =
          v.name.toLowerCase().contains(_search.toLowerCase()) ||
              v.specialization.toLowerCase().contains(_search.toLowerCase());
      return matchSearch && (_statusFilter == null || v.status == _statusFilter);
    }).toList();

    final active = allVets.where((v) => v.status == VetStatus.active).length;
    final pending = allVets.where((v) => v.status == VetStatus.pending).length;
    final total = allVets.length;

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _statPill('Active', '$active', Colors.green),
              const SizedBox(width: 8),
              _statPill('Pending', '$pending', Colors.orange),
              const SizedBox(width: 8),
              _statPill('Total', '$total', RumenoTheme.primaryGreen),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search vet by name or specialization...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _chip('All', _statusFilter == null, () => setState(() => _statusFilter = null)),
              _chip('Active', _statusFilter == VetStatus.active, () => setState(() => _statusFilter = VetStatus.active)),
              _chip('Pending', _statusFilter == VetStatus.pending, () => setState(() => _statusFilter = VetStatus.pending)),
              _chip('Inactive', _statusFilter == VetStatus.inactive, () => setState(() => _statusFilter = VetStatus.inactive)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (context, i) => _VetCard(vet: filtered[i]),
          ),
        ),
      ],
    );
  }

  Widget _statPill(String label, String value, Color color) {
    final emoji = label == 'Active' ? '✅' : label == 'Pending' ? '⏳' : '📊';
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    final emoji = label == 'All' ? '📋' : label == 'Active' ? '✅' : label == 'Pending' ? '⏳' : '⛔';
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Text(emoji, style: const TextStyle(fontSize: 16)),
        label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        selected: selected,
        selectedColor: const Color(0xFFAD1457).withValues(alpha: 0.15),
        onSelected: (_) => onTap(),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
    );
  }
}

class _VetCard extends StatelessWidget {
  final VetModel vet;
  const _VetCard({required this.vet});

  @override
  Widget build(BuildContext context) {
    Color c;
    String statusEmoji;
    switch (vet.status) {
      case VetStatus.active:
        c = RumenoTheme.successGreen;
        statusEmoji = '✅';
        break;
      case VetStatus.pending:
        c = RumenoTheme.warningYellow;
        statusEmoji = '⏳';
        break;
      case VetStatus.inactive:
        c = Colors.grey;
        statusEmoji = '⛔';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: c, width: 5)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFAD1457).withValues(alpha: 0.1),
                  child: const Text('👨‍⚕️', style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vet.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.medical_services_rounded, size: 14, color: Color(0xFFAD1457)),
                          const SizedBox(width: 4),
                          Text(vet.specialization, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.badge_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(vet.licenseNumber, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(statusEmoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(vet.status.name.toUpperCase(), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    if (vet.rating > 0) ...[
                      const SizedBox(height: 4),
                      Row(children: [
                        const Text('⭐', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 2),
                        Text('${vet.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ]),
                    ],
                  ],
                ),
              ],
            ),
            if (vet.status == VetStatus.active) ...[
              const Divider(height: 14),
              Row(
                children: [
                  _stat(context, '${vet.consultations}', 'Consults', Icons.event_note_rounded),
                  _stat(context, '₹${(vet.earnings / 1000).toStringAsFixed(1)}K', 'Earned', Icons.account_balance_wallet_rounded),
                  _stat(context, '${vet.rating}★', 'Rating', Icons.star_rounded),
                ],
              ),
            ],
            if (vet.status == VetStatus.pending) ...[
              const Divider(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RumenoTheme.warningYellow.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const Text('⏳', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('License verification pending', style: TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.w500))),
                ]),
              ),
            ],
            const Divider(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showVetDetailSheet(context, vet),
                    icon: const Icon(Icons.visibility_rounded, size: 20, color: Color(0xFFAD1457)),
                    label: const Text('👁️ View', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFAD1457)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (vet.status == VetStatus.pending)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AdminProvider>().approveVet(vet.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${vet.name} approved!')));
                      },
                      icon: const Icon(Icons.verified_rounded, size: 20),
                      label: const Text('✅ Approve', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.successGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AdminProvider>().toggleVetStatus(vet.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vet.status == VetStatus.active ? '${vet.name} deactivated' : '${vet.name} activated')),
                        );
                      },
                      icon: Icon(vet.status == VetStatus.active ? Icons.pause_circle_rounded : Icons.play_circle_rounded, size: 20),
                      label: Text(vet.status == VetStatus.active ? '⏸️ Deactivate' : '▶️ Activate', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vet.status == VetStatus.active ? Colors.orange : RumenoTheme.successGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVetDetailSheet(BuildContext context, VetModel vet) {
    final statusColor = vet.status == VetStatus.active
        ? RumenoTheme.successGreen
        : vet.status == VetStatus.pending
            ? RumenoTheme.warningYellow
            : RumenoTheme.errorRed;
    final statusEmoji = vet.status == VetStatus.active
        ? '✅'
        : vet.status == VetStatus.pending
            ? '⏳'
            : '⛔';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              // Avatar + Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFAD1457).withValues(alpha: 0.12),
                      child: const Text('👨‍⚕️', style: TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(height: 12),
                    Text(vet.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(vet.specialization, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(statusEmoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(vet.status.name.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Stats row
              Row(
                children: [
                  _detailStat('📋', '${vet.consultations}', 'Consults'),
                  const SizedBox(width: 10),
                  _detailStat('💰', '₹${(vet.earnings / 1000).toStringAsFixed(1)}K', 'Earned'),
                  const SizedBox(width: 10),
                  _detailStat('⭐', vet.rating > 0 ? '${vet.rating}' : '-', 'Rating'),
                ],
              ),
              const SizedBox(height: 20),
              // Info rows
              _infoRow('🪪', 'License', vet.licenseNumber),
              _infoRow('🏥', 'Specialization', vet.specialization),
              _infoRow('💵', 'Commission', '${vet.commissionPercent}%'),
              _infoRow('📊', 'Status', '$statusEmoji ${vet.status.name}'),
              const SizedBox(height: 24),
              // Close button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close_rounded, size: 22),
                  label: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD1457),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailStat(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String emoji, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label, IconData icon) {
    final emoji = label == 'Consults' ? '📋' : label == 'Earned' ? '💰' : '⭐';
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

// ─── Consultations Tab ────────────────────────────────────────────────────────
class _ConsultationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final consultations = admin.consultations;

    final total = consultations.length;
    final completed = consultations.where((c) => c.status == ConsultStatus.completed).length;
    final scheduled = consultations.where((c) => c.status == ConsultStatus.scheduled).length;
    final totalRevenue = consultations.fold<int>(0, (s, c) => s + c.fee);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _kpi(context, '$total', 'Total', Icons.event_note_rounded, RumenoTheme.infoBlue),
              const SizedBox(width: 10),
              _kpi(context, '$completed', 'Done', Icons.check_circle_rounded, RumenoTheme.successGreen),
              const SizedBox(width: 10),
              _kpi(context, '$scheduled', 'Scheduled', Icons.schedule_rounded, RumenoTheme.warningYellow),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF880E4F), Color(0xFFAD1457)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('💰', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹$totalRevenue', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('Total Consultation Revenue', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Recent Consultations', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...consultations.map((c) => _ConsultCard(data: c)),
        ],
      ),
    );
  }

  Widget _kpi(BuildContext context, String value, String label, IconData icon, Color color) {
    final emoji = label == 'Total' ? '📋' : label == 'Done' ? '✅' : '📅';
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ConsultCard extends StatelessWidget {
  final ConsultModel data;
  const _ConsultCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color c;
    String emoji;
    switch (data.status) {
      case ConsultStatus.completed:
        c = RumenoTheme.successGreen;
        emoji = '✅';
        break;
      case ConsultStatus.scheduled:
        c = RumenoTheme.infoBlue;
        emoji = '📅';
        break;
      case ConsultStatus.pending:
        c = RumenoTheme.warningYellow;
        emoji = '⏳';
        break;
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: c, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.type, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Row(
                    children: [
                      const Text('👨‍⚕️ ', style: TextStyle(fontSize: 12)),
                      Text(data.vetName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('🏡 ', style: TextStyle(fontSize: 12)),
                      Text(data.farmName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('📆 ', style: TextStyle(fontSize: 12)),
                      Text(data.date, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${data.fee}', style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(data.status.name.toUpperCase(), style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Earnings Tab ─────────────────────────────────────────────────────────────
class _EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final vets = admin.vets.where((v) => v.status == VetStatus.active || v.earnings > 0).toList();

    final total = vets.fold<double>(0, (s, v) => s + v.earnings);
    final totalConsults = vets.fold<int>(0, (s, v) => s + v.consultations);
    final activeVets = vets.where((v) => v.status == VetStatus.active).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF880E4F), Color(0xFFAD1457)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('💰', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Text('Total Vet Earnings', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text('₹${(total / 1000).toStringAsFixed(1)}K', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const Text('This Month', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _earningBadge('$activeVets', 'Active Vets', Icons.people_rounded),
                    const SizedBox(height: 8),
                    _earningBadge('$totalConsults', 'Consults', Icons.event_note_rounded),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Vet Earnings Breakdown', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...vets.map((v) => _EarningCard(vet: v, total: total)),
          const SizedBox(height: 20),
          Text('Commission Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _commissionCard(context, icon: Icons.percent_rounded, color: const Color(0xFFAD1457), label: 'Platform Commission', value: '20% per consultation'),
          _commissionCard(context, icon: Icons.account_balance_rounded, color: RumenoTheme.infoBlue, label: 'Payout Cycle', value: 'Weekly (every Monday)'),
          _commissionCard(context, icon: Icons.verified_rounded, color: RumenoTheme.successGreen, label: 'Minimum Payout', value: '₹500'),
        ],
      ),
    );
  }

  Widget _earningBadge(String value, String label, IconData icon) {
    final emoji = label.contains('Vet') ? '👨‍⚕️' : '📋';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commissionCard(BuildContext context, {required IconData icon, required Color color, required String label, required String value}) {
    final emoji = label.contains('Commission') ? '💸' : label.contains('Payout') ? '📅' : '✅';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(value, style: TextStyle(fontSize: 13, color: RumenoTheme.primaryGreen, fontWeight: FontWeight.w500)),
        trailing: IconButton(
          icon: const Icon(Icons.edit_rounded, size: 22, color: Color(0xFFAD1457)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit $label')));
          },
        ),
      ),
    );
  }
}

class _EarningCard extends StatelessWidget {
  final VetModel vet;
  final double total;
  const _EarningCard({required this.vet, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? vet.earnings / total : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: const Color(0xFFAD1457), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFAD1457).withValues(alpha: 0.1),
                child: const Text('👨‍⚕️', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vet.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    Row(
                      children: [
                        const Text('📋 ', style: TextStyle(fontSize: 12)),
                        Text('${vet.consultations} consultations', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text('💰 ₹${vet.earnings.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFFAD1457))),
                Text('${vet.commissionPercent}% comm.', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFAD1457)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text('${(pct * 100).toStringAsFixed(1)}% of total earnings', style: TextStyle(fontSize: 9, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

// ─── Schedule Tab ───────────────────────────────────────────────────────────
class _ScheduleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    // Scheduled consults
    final scheduled = admin.consultations.where((c) => c.status == ConsultStatus.scheduled).toList();

    // Upcoming events from mock data
    final events = List.of(mockUpcomingEvents)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Pending vaccinations (due/overdue)
    final now = DateTime.now();
    final pendingVax = mockVaccinations.where((v) {
      final next = v.nextDueDate;
      return next != null && next.isBefore(now.add(const Duration(days: 14)));
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // KPI row
        Row(
          children: [
            _ScheduleKpi(emoji: '📅', label: 'Scheduled', value: '${scheduled.length}', color: const Color(0xFF880E4F)),
            const SizedBox(width: 10),
            _ScheduleKpi(emoji: '🗓️', label: 'Events', value: '${events.length}', color: const Color(0xFF4A148C)),
            const SizedBox(width: 10),
            _ScheduleKpi(emoji: '💉', label: 'Pending Vax', value: '${pendingVax.length}', color: Colors.orange[800]!),
          ],
        ),
        const SizedBox(height: 20),

        // Scheduled consultations
        const Text('📋 Upcoming Consultations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (scheduled.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No scheduled consultations', style: TextStyle(color: Colors.grey)))))
        else
          ...scheduled.map((c) => _ScheduledConsultCard(consult: c)),

        const SizedBox(height: 20),

        // Upcoming farm events
        const Text('🗓️ Upcoming Farm Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...events.map((e) => _EventCard(event: e)),

        const SizedBox(height: 20),

        // Pending vaccinations
        const Text('💉 Pending Vaccinations (Due Soon)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (pendingVax.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('All vaccinations up to date ✅', style: TextStyle(color: Colors.green)))))
        else
          ...pendingVax.map((v) {
            final animal = getAnimalById(v.animalId);
            final dueDate = v.nextDueDate!;
            final overdue = dueDate.isBefore(now);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: overdue ? Colors.red[50] : Colors.orange[50],
              child: ListTile(
                leading: Text(overdue ? '🔴' : '🟡', style: const TextStyle(fontSize: 22)),
                title: Text(v.vaccineName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${animal?.tagId ?? v.animalId} • ${overdue ? 'OVERDUE' : 'Due'}: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
                trailing: Icon(overdue ? Icons.warning_amber : Icons.schedule, color: overdue ? Colors.red : Colors.orange),
              ),
            );
          }),
      ],
    );
  }
}

class _ScheduleKpi extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _ScheduleKpi({required this.emoji, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

class _ScheduledConsultCard extends StatelessWidget {
  final ConsultModel consult;
  const _ScheduledConsultCard({required this.consult});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Text('📋', style: TextStyle(fontSize: 22)),
        title: Text(consult.farmName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Vet: ${consult.vetName} • ${consult.date}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(8)),
          child: const Text('Scheduled', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final UpcomingEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final type = event.eventType;
    final emoji = switch (type) {
      'Vaccination' => '💉',
      'Breeding' => '🐄',
      'Treatment' => '💊',
      'Health Check' || 'Health' => '🩺',
      _ => '📌',
    };
    final date = event.date;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 22)),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$type • ${date.day}/${date.month}/${date.year}'),
        trailing: Text('${date.day}/${date.month}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ),
    );
  }
}

// ─── Performance Tab ────────────────────────────────────────────────────────
class _PerformanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final vets = admin.vets.where((v) => v.status == VetStatus.active).toList();
    final consults = admin.consultations;

    // Overall stats
    final completed = consults.where((c) => c.status == ConsultStatus.completed).length;
    final total = consults.length;
    final completionRate = total > 0 ? (completed / total * 100) : 0.0;
    final avgRating = vets.isNotEmpty ? vets.map((v) => v.rating).reduce((a, b) => a + b) / vets.length : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall KPIs
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF880E4F), Color(0xFFAD1457)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📊 Overall Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PerfKpi(value: '${vets.length}', label: 'Active Vets', emoji: '👨‍⚕️'),
                  _PerfKpi(value: '$completed/$total', label: 'Completed', emoji: '✅'),
                  _PerfKpi(value: '${completionRate.toStringAsFixed(0)}%', label: 'Success Rate', emoji: '📈'),
                  _PerfKpi(value: avgRating.toStringAsFixed(1), label: 'Avg Rating', emoji: '⭐'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Per-vet performance breakdown
        const Text('👨‍⚕️ Vet Performance Comparison', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...vets.map((vet) {
          final vetConsults = consults.where((c) => c.vetName == vet.name).toList();
          final vetCompleted = vetConsults.where((c) => c.status == ConsultStatus.completed).length;
          final vetRate = vetConsults.isNotEmpty ? (vetCompleted / vetConsults.length * 100) : 0.0;
          return _VetPerformanceCard(vet: vet, totalConsults: vetConsults.length, completedConsults: vetCompleted, completionRate: vetRate);
        }),

        const SizedBox(height: 20),

        // Top performers
        const Text('🏆 Leaderboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._buildLeaderboard(vets, consults),
      ],
    );
  }

  List<Widget> _buildLeaderboard(List<VetModel> vets, List<ConsultModel> consults) {
    if (vets.isEmpty) return [const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No active vets', style: TextStyle(color: Colors.grey)))))];

    // Sort by earnings
    final sorted = List<VetModel>.from(vets)..sort((a, b) => b.earnings.compareTo(a.earnings));
    final medals = ['🥇', '🥈', '🥉'];
    return sorted.asMap().entries.map((entry) {
      final i = entry.key;
      final vet = entry.value;
      final vetConsults = consults.where((c) => c.vetName == vet.name).length;
      return Card(
        margin: const EdgeInsets.only(bottom: 6),
        color: i < 3 ? Colors.amber[50] : null,
        child: ListTile(
          leading: Text(i < 3 ? medals[i] : '${i + 1}.', style: TextStyle(fontSize: i < 3 ? 26 : 16)),
          title: Text(vet.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('⭐ ${vet.rating.toStringAsFixed(1)} • $vetConsults consults'),
          trailing: Text('₹${vet.earnings.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFAD1457), fontSize: 15)),
        ),
      );
    }).toList();
  }
}

class _PerfKpi extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _PerfKpi({required this.value, required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _VetPerformanceCard extends StatelessWidget {
  final VetModel vet;
  final int totalConsults;
  final int completedConsults;
  final double completionRate;
  const _VetPerformanceCard({required this.vet, required this.totalConsults, required this.completedConsults, required this.completionRate});

  @override
  Widget build(BuildContext context) {
    final rateColor = completionRate >= 80 ? Colors.green : completionRate >= 50 ? Colors.orange : Colors.red;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('👨‍⚕️', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vet.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(vet.specialization, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: rateColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text('${completionRate.toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.bold, color: rateColor, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _VetStat(emoji: '📋', label: 'Total', value: '$totalConsults'),
                _VetStat(emoji: '✅', label: 'Done', value: '$completedConsults'),
                _VetStat(emoji: '⭐', label: 'Rating', value: vet.rating.toStringAsFixed(1)),
                _VetStat(emoji: '💰', label: 'Earned', value: '₹${vet.earnings.toStringAsFixed(0)}'),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completionRate / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VetStat extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _VetStat({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[500])),
      ],
    );
  }
}

