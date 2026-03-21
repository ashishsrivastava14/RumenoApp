import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/admin_provider.dart';

class AdminHealthConfigScreen extends StatefulWidget {
  const AdminHealthConfigScreen({super.key});

  @override
  State<AdminHealthConfigScreen> createState() => _AdminHealthConfigScreenState();
}

class _AdminHealthConfigScreenState extends State<AdminHealthConfigScreen> with SingleTickerProviderStateMixin {
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

  static const _tabEmojis = ['💉', '🦠', '💊'];
  static const _tabLabels = ['Vaccines', 'Diseases', 'Medicines'];
  static const _tabColors = [Color(0xFF2E7D32), Color(0xFFE53935), Color(0xFF1565C0)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 60),
                child: Row(
                  children: [
                    const Text('⚕️', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Health Config',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Vaccines, Diseases & Medicines',
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: List.generate(3, (i) => Tab(
                icon: Text(_tabEmojis[i], style: const TextStyle(fontSize: 24)),
                text: _tabLabels[i],
              )),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _ConfigList(type: 'Vaccine', emoji: '💉', color: Color(0xFF2E7D32)),
            _ConfigList(type: 'Disease', emoji: '🦠', color: Color(0xFFE53935)),
            _ConfigList(type: 'Medicine', emoji: '💊', color: Color(0xFF1565C0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: _tabColors[_tab.index.clamp(0, 2)],
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: Text('Add ${_tabLabels[_tab.index.clamp(0, 2)]}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final types = ['Vaccine', 'Disease', 'Medicine'];
    final emojis = ['💉', '🦠', '💊'];
    final nameCtrl = TextEditingController();
    final speciesCtrl = TextEditingController();
    final infoCtrl = TextEditingController();
    final type = types[_tab.index];
    final emoji = emojis[_tab.index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
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
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                // Header with emoji
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Text('Add $type', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),

                // Name field
                _buildFormField(
                  icon: Icons.label_rounded,
                  label: 'Name',
                  controller: nameCtrl,
                  hint: '$type name',
                ),
                const SizedBox(height: 16),

                // Species field
                _buildFormField(
                  icon: Icons.pets_rounded,
                  label: 'Applicable Species',
                  controller: speciesCtrl,
                  hint: 'e.g. All, Cow, Buffalo',
                ),
                const SizedBox(height: 16),

                // Info field
                _buildFormField(
                  icon: _tab.index == 0 ? Icons.schedule_rounded : _tab.index == 1 ? Icons.warning_rounded : Icons.category_rounded,
                  label: _tab.index == 0 ? 'Schedule' : _tab.index == 1 ? 'Severity' : 'Category',
                  controller: infoCtrl,
                  hint: _tab.index == 0 ? 'e.g. Every 6 months' : _tab.index == 1 ? 'e.g. High, Medium, Low' : 'e.g. Antibiotic, Vitamin',
                ),
                const SizedBox(height: 28),

                // Big action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        label: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Row(children: [
                                Icon(Icons.warning_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Please enter a name'),
                              ]),
                              backgroundColor: Colors.orange,
                            ));
                            return;
                          }
                          context.read<AdminProvider>().addHealthConfig(HealthConfigItem(
                            id: '${type[0]}${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            species: speciesCtrl.text.trim().isEmpty ? 'All' : speciesCtrl.text.trim(),
                            info: infoCtrl.text.trim(),
                            type: type,
                          ));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('$type added!'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ));
                        },
                        icon: const Icon(Icons.add_rounded, size: 22, color: Colors.white),
                        label: const Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RumenoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({required IconData icon, required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.06),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
          ),
        ),
      ],
    );
  }
}

class _ConfigList extends StatelessWidget {
  final String type;
  final String emoji;
  final Color color;

  const _ConfigList({required this.type, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.getConfigListByType(type);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text('No ${type.toLowerCase()}s configured',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            const SizedBox(height: 8),
            Text('Tap + to add one',
                style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              // Main content - big and visual
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Big emoji indicator
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.pets_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(item.species, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                          if (item.info.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  type == 'Vaccine' ? Icons.schedule_rounded : type == 'Disease' ? Icons.warning_rounded : Icons.category_rounded,
                                  size: 14, color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(item.info, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons strip - big and color-coded
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _showEditDialog(context, item),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_rounded, size: 20, color: RumenoTheme.infoBlue),
                              const SizedBox(width: 6),
                              Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RumenoTheme.infoBlue)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 30, color: Colors.grey.withValues(alpha: 0.15)),
                    Expanded(
                      child: InkWell(
                        onTap: () => _confirmDelete(context, item),
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_rounded, size: 20, color: RumenoTheme.errorRed),
                              const SizedBox(width: 6),
                              Text('Delete', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RumenoTheme.errorRed)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, HealthConfigItem item) {
    final nameCtrl = TextEditingController(text: item.name);
    final speciesCtrl = TextEditingController(text: item.species);
    final infoCtrl = TextEditingController(text: item.info);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
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
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Text('Edit $type', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                _editFormField(icon: Icons.label_rounded, label: 'Name', controller: nameCtrl, hint: '$type name'),
                const SizedBox(height: 16),
                _editFormField(icon: Icons.pets_rounded, label: 'Applicable Species', controller: speciesCtrl, hint: 'e.g. All, Cow'),
                const SizedBox(height: 16),
                _editFormField(
                  icon: type == 'Vaccine' ? Icons.schedule_rounded : type == 'Disease' ? Icons.warning_rounded : Icons.category_rounded,
                  label: type == 'Vaccine' ? 'Schedule' : type == 'Disease' ? 'Severity' : 'Category',
                  controller: infoCtrl,
                  hint: type == 'Vaccine' ? 'e.g. Every 6 months' : type == 'Disease' ? 'e.g. High' : 'e.g. Antibiotic',
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 22),
                        label: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AdminProvider>().updateHealthConfig(
                            item.id, type,
                            name: nameCtrl.text.trim(),
                            species: speciesCtrl.text.trim(),
                            info: infoCtrl.text.trim(),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('${item.name} updated!'),
                            ]),
                            backgroundColor: RumenoTheme.successGreen,
                          ));
                        },
                        icon: const Icon(Icons.save_rounded, size: 22, color: Colors.white),
                        label: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RumenoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editFormField({required IconData icon, required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.06),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: RumenoTheme.primaryGreen, width: 2)),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, HealthConfigItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: RumenoTheme.errorRed.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.delete_forever_rounded, color: RumenoTheme.errorRed, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Delete "${item.name}"?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('This cannot be undone',
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
                  label: const Text('Cancel', style: TextStyle(fontSize: 15)),
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
                    context.read<AdminProvider>().deleteHealthConfig(item.id, type);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(children: [
                        const Icon(Icons.delete_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('${item.name} deleted'),
                      ]),
                      backgroundColor: RumenoTheme.errorRed,
                    ));
                  },
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                  label: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 15)),
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
}
