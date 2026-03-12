import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/marketplace_button.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final List<Map<String, String>> _members = [
    {'name': 'Rajesh Patel', 'phone': '9876543210', 'role': 'Owner'},
    {'name': 'Suresh Patel', 'phone': '9876543221', 'role': 'Manager'},
    {'name': 'Mohan Lal', 'phone': '9876543222', 'role': 'Staff (Edit)'},
    {'name': 'Ramu', 'phone': '9876543223', 'role': 'Staff (View)'},
  ];

  static const _roleEmojis = {
    'Owner': '👑',
    'Manager': '👷',
    'Staff (Edit)': '✏️',
    'Staff (View)': '👁️',
  };

  Color _roleColor(String role) {
    if (role.contains('Owner')) return RumenoTheme.planBusiness;
    if (role.contains('Manager')) return RumenoTheme.planPro;
    if (role.contains('Edit')) return RumenoTheme.planStarter;
    return RumenoTheme.planFree;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('My Team'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: Column(
        children: [
          // Header with team count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  RumenoTheme.primaryGreen,
                  RumenoTheme.primaryDarkGreen,
                ],
              ),
            ),
            child: Row(
              children: [
                const Text('👥', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_members.length} Team Members',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Manage your farm workers',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Role legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _roleEmojis.entries.map((e) {
                return Column(
                  children: [
                    Text(e.value, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                    Text(
                      e.key.replaceAll(' (', '\n('),
                      style: TextStyle(fontSize: 10, color: _roleColor(e.key), fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Members list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final m = _members[index];
                final color = _roleColor(m['role']!);
                final emoji = _roleEmojis[m['role']] ?? '👤';
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Avatar with emoji
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m['name']!,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RumenoTheme.textDark),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.phone, size: 14, color: RumenoTheme.textGrey),
                                  const SizedBox(width: 4),
                                  Text(m['phone']!, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            m['role']!,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberSheet(),
        icon: const Icon(Icons.person_add_rounded, size: 24),
        label: const Text('Add Worker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: RumenoTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddMemberSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String selectedRole = 'Staff (View)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('👥', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 10),
                  Text('Add New Worker', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              // Name field with visual label
              Row(
                children: [
                  const Text('👤', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  const Text('Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Worker name',
                  prefixIcon: const Icon(Icons.person, color: RumenoTheme.primaryGreen),
                  filled: true,
                  fillColor: RumenoTheme.backgroundCream,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Phone field with visual label
              Row(
                children: [
                  const Text('📱', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: '9876543210',
                  prefixIcon: const Icon(Icons.phone, color: RumenoTheme.primaryGreen),
                  filled: true,
                  fillColor: RumenoTheme.backgroundCream,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Role selection with visual tiles
              Row(
                children: [
                  const Text('🎖️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  const Text('Role', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Manager', 'Staff (Edit)', 'Staff (View)'].map((role) {
                  final sel = selectedRole == role;
                  final color = _roleColor(role);
                  final emoji = _roleEmojis[role] ?? '👤';
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedRole = role),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: sel ? color.withValues(alpha: 0.12) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: sel ? color : Colors.grey.shade300, width: sel ? 2 : 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            role,
                            style: TextStyle(
                              fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                              color: sel ? color : RumenoTheme.textDark,
                            ),
                          ),
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

              // Add button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('⚠️ Please fill name and phone'), backgroundColor: RumenoTheme.warningYellow),
                      );
                      return;
                    }
                    setState(() {
                      _members.add({
                        'name': nameCtrl.text.trim(),
                        'phone': phoneCtrl.text.trim(),
                        'role': selectedRole,
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Worker added!'), backgroundColor: RumenoTheme.successGreen),
                    );
                  },
                  icon: const Icon(Icons.person_add, size: 22),
                  label: const Text('Add Worker', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RumenoTheme.primaryGreen,
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
}
