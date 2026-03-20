import 'package:flutter/material.dart';
import '../../config/theme.dart';

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
    _tab = TabController(length: 3, vsync: this);
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
            expandedHeight: 140,
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
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 60),
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
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(icon: Text('👨‍⚕️', style: TextStyle(fontSize: 18)), text: 'Vets'),
                Tab(icon: Text('📋', style: TextStyle(fontSize: 18)), text: 'Consults'),
                Tab(icon: Text('💰', style: TextStyle(fontSize: 18)), text: 'Earnings'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _VetsTab(),
            _ConsultationsTab(),
            _EarningsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteVetDialog(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Invite Vet'),
        backgroundColor: const Color(0xFFAD1457),
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
            Icon(Icons.person_add_rounded, color: Color(0xFFAD1457)),
            SizedBox(width: 8),
            Text('Invite Veterinarian'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 10),
            TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 10),
            TextField(
                controller: specCtrl,
                decoration: const InputDecoration(
                    labelText: 'Specialization',
                    prefixIcon: Icon(Icons.medical_information))),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAD1457)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invite sent to ${nameCtrl.text}!')));
            },
            child: const Text('Send Invite'),
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
  _VetStatus? _statusFilter;

  final _vets = const [
    _VetModel('V001', 'Dr. Emily Thompson', 'Large Animal Medicine',
        'VET-MH-2019-0456', _VetStatus.active, 28, 12400, 4.9),
    _VetModel('V002', 'Dr. Rajesh Kumar', 'Bovine & Caprine',
        'VET-UP-2018-0231', _VetStatus.active, 34, 15600, 4.7),
    _VetModel('V003', 'Dr. Priya Sharma', 'Small Ruminants',
        'VET-MP-2020-0589', _VetStatus.active, 22, 9800, 4.8),
    _VetModel('V004', 'Dr. Anil Verma', 'Equine Medicine',
        'VET-HR-2017-0123', _VetStatus.inactive, 0, 3200, 4.5),
    _VetModel('V005', 'Dr. Meena Patel', 'Poultry & Swine',
        'VET-GJ-2021-0044', _VetStatus.pending, 0, 0, 0.0),
    _VetModel('V006', 'Dr. Suresh Nair', 'Large Animal Surgery',
        'VET-KL-2016-0678', _VetStatus.active, 41, 18200, 4.6),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _vets.where((v) {
      final matchSearch =
          v.name.toLowerCase().contains(_search.toLowerCase()) ||
              v.specialization
                  .toLowerCase()
                  .contains(_search.toLowerCase());
      return matchSearch &&
          (_statusFilter == null || v.status == _statusFilter);
    }).toList();

    final active =
        _vets.where((v) => v.status == _VetStatus.active).length;
    final pending =
        _vets.where((v) => v.status == _VetStatus.pending).length;
    final total = _vets.length;

    return Column(
      children: [
        // Stats bar
        Container(
          color: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              _chip('All', _statusFilter == null,
                  () => setState(() => _statusFilter = null)),
              _chip(
                  'Active',
                  _statusFilter == _VetStatus.active,
                  () =>
                      setState(() => _statusFilter = _VetStatus.active)),
              _chip(
                  'Pending',
                  _statusFilter == _VetStatus.pending,
                  () => setState(
                      () => _statusFilter = _VetStatus.pending)),
              _chip(
                  'Inactive',
                  _statusFilter == _VetStatus.inactive,
                  () => setState(
                      () => _statusFilter = _VetStatus.inactive)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (context, i) =>
                _VetCard(vet: filtered[i]),
          ),
        ),
      ],
    );
  }

  Widget _statPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(' ',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: selected,
        selectedColor: const Color(0xFFAD1457).withValues(alpha: 0.15),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _VetCard extends StatelessWidget {
  final _VetModel vet;
  const _VetCard({required this.vet});

  @override
  Widget build(BuildContext context) {
    Color c;
    switch (vet.status) {
      case _VetStatus.active:
        c = RumenoTheme.successGreen;
        break;
      case _VetStatus.pending:
        c = RumenoTheme.warningYellow;
        break;
      case _VetStatus.inactive:
        c = Colors.grey;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFAD1457).withValues(alpha: 0.1),
                  child: Text(
                    vet.name.split(' ').last[0],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAD1457)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vet.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(vet.specialization,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                      Text(vet.licenseNumber,
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: c.withValues(alpha: 0.3)),
                      ),
                      child: Text(vet.status.name,
                          style: TextStyle(
                              color: c,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    if (vet.rating > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
                          Text('${vet.rating}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (vet.status == _VetStatus.active) ...[
              const Divider(height: 14),
              Row(
                children: [
                  _stat(context, '${vet.consultations}', 'Consults',
                      Icons.event_note_rounded),
                  _stat(
                    context,
                    '₹${(vet.earnings / 1000).toStringAsFixed(1)}K',
                    'Earned',
                    Icons.account_balance_wallet_rounded,
                  ),
                  _stat(
                    context,
                    '${vet.rating}★',
                    'Rating',
                    Icons.star_rounded,
                  ),
                ],
              ),
            ],
            if (vet.status == _VetStatus.pending) ...[
              const Divider(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: RumenoTheme.warningYellow.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: RumenoTheme.warningYellow, size: 16),
                    const SizedBox(width: 8),
                    const Text('License verification pending',
                        style:
                            TextStyle(fontSize: 11, color: Colors.orange)),
                  ],
                ),
              ),
            ],
            const Divider(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('View ${vet.name} details')));
                  },
                  icon: const Icon(Icons.visibility_rounded, size: 14),
                  label: const Text('View', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact),
                ),
                const SizedBox(width: 8),
                if (vet.status == _VetStatus.pending)
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${vet.name} approved!')));
                    },
                    icon: const Icon(Icons.verified_rounded, size: 14),
                    label: const Text('Approve',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: RumenoTheme.successGreen,
                        visualDensity: VisualDensity.compact),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  vet.status == _VetStatus.active
                                      ? 'Vet deactivated'
                                      : 'Vet activated')));
                    },
                    icon: Icon(
                      vet.status == _VetStatus.active
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_rounded,
                      size: 14,
                    ),
                    label: Text(
                      vet.status == _VetStatus.active
                          ? 'Deactivate'
                          : 'Activate',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label,
      IconData icon) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(label,
                  style: TextStyle(
                      fontSize: 9, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Consultations Tab ────────────────────────────────────────────────────────
class _ConsultationsTab extends StatelessWidget {
  final _consultations = const [
    _ConsultData('C001', 'Dr. Emily Thompson', 'Ramesh Patel Farm',
        'Vaccination - FMD', '18 Mar 2026', _ConsultStatus.completed, 800),
    _ConsultData('C002', 'Dr. Rajesh Kumar', 'Singh Dairy',
        'Treatment - Mastitis', '19 Mar 2026', _ConsultStatus.completed, 1200),
    _ConsultData('C003', 'Dr. Priya Sharma', 'Green Pastures Farm',
        'Deworming Check', '20 Mar 2026', _ConsultStatus.scheduled, 600),
    _ConsultData('C004', 'Dr. Emily Thompson', 'Sharma Buffalo Farm',
        'Pregnancy Check', '20 Mar 2026', _ConsultStatus.scheduled, 900),
    _ConsultData('C005', 'Dr. Suresh Nair', 'Jain Cattle Co.',
        'Emergency - Bloat', '17 Mar 2026', _ConsultStatus.completed, 2500),
    _ConsultData('C006', 'Dr. Rajesh Kumar', 'Kapoor Dairy',
        'Annual Health Checkup', '21 Mar 2026', _ConsultStatus.pending, 1000),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _consultations.length;
    final completed =
        _consultations.where((c) => c.status == _ConsultStatus.completed).length;
    final scheduled =
        _consultations.where((c) => c.status == _ConsultStatus.scheduled).length;
    final totalRevenue =
        _consultations.fold<int>(0, (s, c) => s + c.fee);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              _kpi(context, '$total', 'Total', Icons.event_note_rounded,
                  RumenoTheme.infoBlue),
              const SizedBox(width: 10),
              _kpi(context, '$completed', 'Done',
                  Icons.check_circle_rounded, RumenoTheme.successGreen),
              const SizedBox(width: 10),
              _kpi(context, '$scheduled', 'Scheduled',
                  Icons.schedule_rounded, RumenoTheme.warningYellow),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF880E4F), Color(0xFFAD1457)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white70, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹$totalRevenue',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Total Consultation Revenue',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Recent Consultations',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._consultations.map((c) => _ConsultCard(data: c)),
        ],
      ),
    );
  }

  Widget _kpi(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color)),
            Text(label,
                style:
                    TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class _ConsultCard extends StatelessWidget {
  final _ConsultData data;
  const _ConsultCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color c;
    IconData ico;
    switch (data.status) {
      case _ConsultStatus.completed:
        c = RumenoTheme.successGreen;
        ico = Icons.check_circle_rounded;
        break;
      case _ConsultStatus.scheduled:
        c = RumenoTheme.infoBlue;
        ico = Icons.schedule_rounded;
        break;
      case _ConsultStatus.pending:
        c = RumenoTheme.warningYellow;
        ico = Icons.pending_rounded;
        break;
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(ico, color: c, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data.type}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  Text('${data.vetName} · ${data.farmName}',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[600])),
                  Text(data.date,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[500])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${data.fee}',
                    style: TextStyle(
                        color: c,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(data.status.name,
                      style: TextStyle(
                          color: c,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
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
  final _earningsData = const [
    _VetEarningModel('Dr. Emily Thompson', 28, 22400, 80),
    _VetEarningModel('Dr. Rajesh Kumar', 34, 27200, 80),
    _VetEarningModel('Dr. Priya Sharma', 22, 13200, 60),
    _VetEarningModel('Dr. Suresh Nair', 41, 32800, 80),
    _VetEarningModel('Dr. Anil Verma', 8, 6400, 80),
  ];

  @override
  Widget build(BuildContext context) {
    final total =
        _earningsData.fold<double>(0, (s, v) => s + v.earned);
    final totalConsults =
        _earningsData.fold<int>(0, (s, v) => s + v.consultations);
    final activeVets = _earningsData.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total earnings banner
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Vet Earnings',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13)),
                      Text(
                        '₹${(total / 1000).toStringAsFixed(1)}K',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text('This Month',
                          style: TextStyle(
                              color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _earningBadge(
                        '$activeVets',
                        'Active Vets',
                        Icons.people_rounded),
                    const SizedBox(height: 8),
                    _earningBadge(
                        '$totalConsults',
                        'Consults',
                        Icons.event_note_rounded),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Vet Earnings Breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._earningsData.map((v) => _EarningCard(data: v, total: total)),
          const SizedBox(height: 20),
          Text('Commission Settings',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _commissionCard(
            context,
            icon: Icons.percent_rounded,
            color: const Color(0xFFAD1457),
            label: 'Platform Commission',
            value: '20% per consultation',
            canEdit: true,
          ),
          _commissionCard(
            context,
            icon: Icons.account_balance_rounded,
            color: RumenoTheme.infoBlue,
            label: 'Payout Cycle',
            value: 'Weekly (every Monday)',
            canEdit: true,
          ),
          _commissionCard(
            context,
            icon: Icons.verified_rounded,
            color: RumenoTheme.successGreen,
            label: 'Minimum Payout',
            value: '₹500',
            canEdit: true,
          ),
        ],
      ),
    );
  }

  Widget _earningBadge(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _commissionCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required bool canEdit,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(value,
            style:
                TextStyle(fontSize: 12, color: RumenoTheme.primaryGreen)),
        trailing: canEdit
            ? IconButton(
                icon: const Icon(Icons.edit_rounded, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit ')));
                },
              )
            : null,
      ),
    );
  }
}

class _EarningCard extends StatelessWidget {
  final _VetEarningModel data;
  final double total;
  const _EarningCard({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? data.earned / total : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFAD1457).withValues(alpha: 0.1),
                child: Text(
                  data.name.split(' ').last[0],
                  style: const TextStyle(
                      color: Color(0xFFAD1457),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(' consultations',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFFAD1457))),
                  Text('% comm.',
                      style: TextStyle(
                          fontSize: 9, color: Colors.grey[500])),
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
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFAD1457)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text('% of total earnings',
              style: TextStyle(fontSize: 9, color: Colors.grey[500])),
        ],
      ),
    );
  }
}

// ─── Data models ─────────────────────────────────────────────────────────────
enum _VetStatus { active, pending, inactive }

enum _ConsultStatus { completed, scheduled, pending }

class _VetModel {
  final String id;
  final String name;
  final String specialization;
  final String licenseNumber;
  final _VetStatus status;
  final int consultations;
  final double earnings;
  final double rating;
  const _VetModel(this.id, this.name, this.specialization,
      this.licenseNumber, this.status, this.consultations,
      this.earnings, this.rating);
}

class _ConsultData {
  final String id;
  final String vetName;
  final String farmName;
  final String type;
  final String date;
  final _ConsultStatus status;
  final int fee;
  const _ConsultData(this.id, this.vetName, this.farmName, this.type,
      this.date, this.status, this.fee);
}

class _VetEarningModel {
  final String name;
  final int consultations;
  final double earned;
  final int commission;
  const _VetEarningModel(
      this.name, this.consultations, this.earned, this.commission);
}
