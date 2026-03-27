import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../mock/mock_teams.dart';
import '../../models/models.dart';

class AdminTeamManagementScreen extends StatefulWidget {
  final Farmer farmer;

  const AdminTeamManagementScreen({super.key, required this.farmer});

  @override
  State<AdminTeamManagementScreen> createState() =>
      _AdminTeamManagementScreenState();
}

class _AdminTeamManagementScreenState extends State<AdminTeamManagementScreen> {
  late List<TeamMember> _members;

  @override
  void initState() {
    super.initState();
    _members =
        List.from(mockTeamsByFarmer[widget.farmer.id] ?? <TeamMember>[]);
  }

  Color _roleColor(TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return RumenoTheme.planBusiness;
      case TeamRole.manager:
        return RumenoTheme.planPro;
      case TeamRole.staffEdit:
        return RumenoTheme.planStarter;
      case TeamRole.staffView:
        return RumenoTheme.planFree;
    }
  }

  IconData _roleIcon(TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return Icons.admin_panel_settings_rounded;
      case TeamRole.manager:
        return Icons.manage_accounts_rounded;
      case TeamRole.staffEdit:
        return Icons.edit_rounded;
      case TeamRole.staffView:
        return Icons.visibility_rounded;
    }
  }

  Future<void> _callMember(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _addMember(TeamMember member) {
    setState(() => _members.add(member));
  }

  void _updateMember(TeamMember updated) {
    setState(() {
      final idx = _members.indexWhere((m) => m.id == updated.id);
      if (idx != -1) _members[idx] = updated;
    });
  }

  void _removeMember(String id) {
    setState(() => _members.removeWhere((m) => m.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final owners = _members.where((m) => m.role == TeamRole.owner).length;
    final managers = _members.where((m) => m.role == TeamRole.manager).length;
    final staff = _members.length - owners - managers;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberSheet(context),
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
        label: const Text('Add Member',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
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
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
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
                    // Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.groups_rounded,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Team Management',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(widget.farmer.farmName,
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.85),
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Stats row
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.people_rounded,
                          value: '${_members.length}',
                          label: 'Total',
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.admin_panel_settings_rounded,
                          value: '$owners',
                          label: 'Owners',
                          color: RumenoTheme.planBusiness,
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.manage_accounts_rounded,
                          value: '$managers',
                          label: 'Managers',
                          color: RumenoTheme.planPro,
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.badge_rounded,
                          value: '$staff',
                          label: 'Staff',
                          color: RumenoTheme.planStarter,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Role legend
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: TeamRole.values.map((role) {
                  final color = _roleColor(role);
                  final icon = _roleIcon(role);
                  final name = TeamMember(
                    id: '',
                    name: '',
                    phone: '',
                    role: role,
                    farmerId: '',
                    joinedDate: DateTime.now(),
                  ).roleName;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: 20, color: color),
                      ),
                      const SizedBox(height: 4),
                      Text(name,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          // Member count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.format_list_numbered_rounded,
                      size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text('${_members.length} members',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ],
              ),
            ),
          ),

          // Empty state
          if (_members.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.group_off_rounded,
                        size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('No team members yet',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('Add staff to manage this farm',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[400])),
                  ],
                ),
              ),
            ),

          // Members list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final member = _members[index];
                final color = _roleColor(member.role);
                final icon = _roleIcon(member.role);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () =>
                          _showMemberActions(context, member),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border:
                              Border.all(color: color.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Icon(icon, color: color, size: 26),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(member.name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      if (!member.isActive)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: RumenoTheme.errorRed
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('Inactive',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      RumenoTheme.errorRed)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.phone_rounded,
                                          size: 14, color: Colors.grey[400]),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(member.phone,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500])),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                      'Since ${member.joinedDate.day}/${member.joinedDate.month}/${member.joinedDate.year}',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[400])),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Role badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(member.roleName,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: color)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: _members.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // ─── Member Actions Bottom Sheet ────────────────────────────────────────────

  void _showMemberActions(BuildContext context, TeamMember member) {
    final color = _roleColor(member.role);
    final icon = _roleIcon(member.role);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.75,
        minChildSize: 0.35,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                // Member profile
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: Icon(icon, color: color, size: 36)),
                ),
                const SizedBox(height: 12),
                Text(member.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(member.roleName,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color)),
                ),
                const SizedBox(height: 6),
                Text(member.phone,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                const SizedBox(height: 20),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.phone_rounded,
                        label: 'Call',
                        color: RumenoTheme.successGreen,
                        onTap: () {
                          Navigator.pop(ctx);
                          _callMember(member.phone);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.swap_horiz_rounded,
                        label: 'Change Role',
                        color: const Color(0xFF1565C0),
                        onTap: () {
                          Navigator.pop(ctx);
                          _showChangeRoleSheet(context, member);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: member.isActive
                            ? Icons.block_rounded
                            : Icons.check_circle_outline_rounded,
                        label:
                            member.isActive ? 'Deactivate' : 'Activate',
                        color: member.isActive
                            ? Colors.orange
                            : RumenoTheme.successGreen,
                        onTap: () {
                          Navigator.pop(ctx);
                          _toggleMemberStatus(member);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (member.role != TeamRole.owner)
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.person_remove_rounded,
                          label: 'Remove',
                          color: RumenoTheme.errorRed,
                          onTap: () {
                            Navigator.pop(ctx);
                            _showRemoveConfirmation(context, member);
                          },
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleMemberStatus(TeamMember member) {
    _updateMember(TeamMember(
      id: member.id,
      name: member.name,
      phone: member.phone,
      role: member.role,
      farmerId: member.farmerId,
      joinedDate: member.joinedDate,
      isActive: !member.isActive,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              member.isActive
                  ? Icons.cancel_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(member.isActive
                ? '${member.name} deactivated'
                : '${member.name} activated'),
          ],
        ),
        backgroundColor: member.isActive
            ? RumenoTheme.errorRed
            : RumenoTheme.successGreen,
      ),
    );
  }

  // ─── Change Role Sheet ──────────────────────────────────────────────────────

  void _showChangeRoleSheet(BuildContext context, TeamMember member) {
    TeamRole selectedRole = member.role;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF1565C0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.swap_horiz_rounded,
                        color: Color(0xFF1565C0), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Change Role',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(member.name,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TeamRole.values.map((role) {
                  final sel = selectedRole == role;
                  final color = _roleColor(role);
                  final icon = _roleIcon(role);
                  final name = TeamMember(
                    id: '',
                    name: '',
                    phone: '',
                    role: role,
                    farmerId: '',
                    joinedDate: DateTime.now(),
                  ).roleName;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedRole = role),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: sel
                            ? color.withValues(alpha: 0.12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: sel ? color : Colors.grey.shade300,
                            width: sel ? 2 : 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon,
                              size: 20, color: sel ? color : Colors.grey),
                          const SizedBox(width: 8),
                          Text(name,
                              style: TextStyle(
                                fontWeight:
                                    sel ? FontWeight.bold : FontWeight.normal,
                                color: sel ? color : Colors.grey[700],
                              )),
                          if (sel) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.check_circle, color: color, size: 18),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _updateMember(TeamMember(
                      id: member.id,
                      name: member.name,
                      phone: member.phone,
                      role: selectedRole,
                      farmerId: member.farmerId,
                      joinedDate: member.joinedDate,
                      isActive: member.isActive,
                    ));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                                '${member.name} role updated to ${TeamMember(id: '', name: '', phone: '', role: selectedRole, farmerId: '', joinedDate: DateTime.now()).roleName}'),
                          ],
                        ),
                        backgroundColor: RumenoTheme.successGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_rounded,
                      color: Colors.white, size: 22),
                  label: const Text('Save Role',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Remove Confirmation ────────────────────────────────────────────────────

  void _showRemoveConfirmation(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_remove_rounded,
                  color: RumenoTheme.errorRed, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Remove ${member.name}?',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('This will remove their access to ${widget.farmer.farmName}',
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _removeMember(member.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.person_remove_rounded,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text('${member.name} removed'),
                          ],
                        ),
                        backgroundColor: RumenoTheme.errorRed,
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_remove_rounded,
                      color: Colors.white),
                  label: const Text('Remove',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.errorRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Add Member Sheet ───────────────────────────────────────────────────────

  void _showAddMemberSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    TeamRole selectedRole = TeamRole.staffView;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF1565C0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add_rounded,
                        color: Color(0xFF1565C0), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('Add Team Member',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              // Name
              Row(
                children: [
                  Icon(Icons.person_rounded,
                      size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text('Name',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  Text(' *',
                      style: TextStyle(
                          color: RumenoTheme.errorRed,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Member name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.06),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF1565C0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone
              Row(
                children: [
                  Icon(Icons.phone_rounded,
                      size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text('Phone',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  Text(' *',
                      style: TextStyle(
                          color: RumenoTheme.errorRed,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.06),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF1565C0), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Role selection
              Row(
                children: [
                  Icon(Icons.badge_rounded,
                      size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text('Role',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [TeamRole.manager, TeamRole.staffEdit, TeamRole.staffView]
                        .map((role) {
                  final sel = selectedRole == role;
                  final color = _roleColor(role);
                  final icon = _roleIcon(role);
                  final name = TeamMember(
                    id: '',
                    name: '',
                    phone: '',
                    role: role,
                    farmerId: '',
                    joinedDate: DateTime.now(),
                  ).roleName;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedRole = role),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: sel
                            ? color.withValues(alpha: 0.12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: sel ? color : Colors.grey.shade300,
                            width: sel ? 2 : 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon,
                              size: 20, color: sel ? color : Colors.grey),
                          const SizedBox(width: 8),
                          Text(name,
                              style: TextStyle(
                                fontWeight:
                                    sel ? FontWeight.bold : FontWeight.normal,
                                color: sel ? color : Colors.grey[700],
                              )),
                          if (sel) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.check_circle, color: color, size: 18),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty ||
                        phoneCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.warning_rounded,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              const Text('Please fill name and phone'),
                            ],
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    final member = TeamMember(
                      id: 'TM${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      role: selectedRole,
                      farmerId: widget.farmer.id,
                      joinedDate: DateTime.now(),
                    );
                    _addMember(member);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text('${member.name} added to team'),
                          ],
                        ),
                        backgroundColor: RumenoTheme.successGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_rounded,
                      color: Colors.white, size: 22),
                  label: const Text('Add Member',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

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
                    color: Colors.white.withValues(alpha: 0.8), fontSize: 10)),
          ],
        ),
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
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
