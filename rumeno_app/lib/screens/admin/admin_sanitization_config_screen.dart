import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/admin_provider.dart';

class AdminSanitizationConfigScreen extends StatefulWidget {
  const AdminSanitizationConfigScreen({super.key});

  @override
  State<AdminSanitizationConfigScreen> createState() =>
      _AdminSanitizationConfigScreenState();
}

class _AdminSanitizationConfigScreenState
    extends State<AdminSanitizationConfigScreen>
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

  static const _tabEmojis = ['🧴', '🏠', '📋'];
  static const _tabLabels = ['Sanitizers', 'Areas', 'Protocols'];
  static const _tabColors = [
    Color(0xFF00838F),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00695C), Color(0xFF26A69A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 60),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      const Text('🧹', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Sanitization Config',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text('Sanitizers, Areas & Protocols',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: List.generate(
                3,
                (i) => Tab(
                  icon:
                      Text(_tabEmojis[i], style: const TextStyle(fontSize: 24)),
                  text: _tabLabels[i],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [
            _SanitizersTab(),
            _AreasTab(),
            _ProtocolsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        backgroundColor: _tabColors[_tab.index.clamp(0, 2)],
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: Text('Add ${_tabLabels[_tab.index.clamp(0, 2)]}',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    switch (_tab.index) {
      case 0:
        _showSanitizerSheet(context);
        break;
      case 1:
        _showAreaSheet(context);
        break;
      case 2:
        _showProtocolSheet(context);
        break;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Sanitizers Tab
// ═════════════════════════════════════════════════════════════════════════════
class _SanitizersTab extends StatelessWidget {
  const _SanitizersTab();

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.sanitizers;

    if (items.isEmpty) {
      return const Center(
          child: Text('No sanitizers configured',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final s = items[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF00838F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(s.emoji, style: const TextStyle(fontSize: 24))),
            ),
            title: Text(s.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s.dilution.isNotEmpty)
                  Text('💧 ${s.dilution}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600])),
                if (s.safety.isNotEmpty)
                  Text('⚠️ ${s.safety}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.orange[700])),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!s.isActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Inactive',
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ),
                PopupMenuButton<String>(
                  onSelected: (v) =>
                      _handleAction(context, v, s),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'edit', child: Text('✏️ Edit')),
                    PopupMenuItem(
                        value: 'toggle',
                        child:
                            Text(s.isActive ? '⏸️ Deactivate' : '▶️ Activate')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('🗑️ Delete')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAction(
      BuildContext context, String action, SanitizationSanitizer s) {
    final admin = context.read<AdminProvider>();
    switch (action) {
      case 'edit':
        _showSanitizerSheet(context, existing: s);
        break;
      case 'toggle':
        admin.updateSanitizer(s.id, isActive: !s.isActive);
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Sanitizer?'),
            content: Text('Remove "${s.name}" from the list?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  admin.deleteSanitizer(s.id);
                  Navigator.pop(ctx);
                },
                child: const Text('Delete',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        break;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Areas Tab
// ═════════════════════════════════════════════════════════════════════════════
class _AreasTab extends StatelessWidget {
  const _AreasTab();

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.sanitizationAreas;

    if (items.isEmpty) {
      return const Center(
          child: Text('No areas configured',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final a = items[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(a.emoji, style: const TextStyle(fontSize: 24))),
            ),
            title: Text(a.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            subtitle: a.frequency.isNotEmpty
                ? Text('🔄 ${a.frequency}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!a.isActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Inactive',
                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ),
                PopupMenuButton<String>(
                  onSelected: (v) =>
                      _handleAction(context, v, a),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'edit', child: Text('✏️ Edit')),
                    PopupMenuItem(
                        value: 'toggle',
                        child:
                            Text(a.isActive ? '⏸️ Deactivate' : '▶️ Activate')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('🗑️ Delete')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAction(
      BuildContext context, String action, SanitizationArea a) {
    final admin = context.read<AdminProvider>();
    switch (action) {
      case 'edit':
        _showAreaSheet(context, existing: a);
        break;
      case 'toggle':
        admin.updateSanitizationArea(a.id, isActive: !a.isActive);
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Area?'),
            content: Text('Remove "${a.name}" from the list?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  admin.deleteSanitizationArea(a.id);
                  Navigator.pop(ctx);
                },
                child: const Text('Delete',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        break;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Protocols Tab
// ═════════════════════════════════════════════════════════════════════════════
class _ProtocolsTab extends StatelessWidget {
  const _ProtocolsTab();

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.sanitizationProtocols;

    if (items.isEmpty) {
      return const Center(
          child: Text('No protocols configured',
              style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final p = items[i];
        final areaName = admin.areaNameById(p.areaId);
        final sanitizerNames =
            p.sanitizerIds.map((id) => admin.sanitizerNameById(id)).join(', ');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A1B9A).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                          child: Text('📋',
                              style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('🏠 $areaName  •  🔄 ${p.frequency}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    if (!p.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Inactive',
                            style:
                                TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
                    PopupMenuButton<String>(
                      onSelected: (v) =>
                          _handleAction(context, v, p),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'edit', child: Text('✏️ Edit')),
                        PopupMenuItem(
                            value: 'toggle',
                            child: Text(p.isActive
                                ? '⏸️ Deactivate'
                                : '▶️ Activate')),
                        const PopupMenuItem(
                            value: 'delete', child: Text('🗑️ Delete')),
                      ],
                    ),
                  ],
                ),
                if (sanitizerNames.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('🧴 $sanitizerNames',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[700])),
                ],
                if (p.instructions.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('📝 ${p.instructions}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAction(
      BuildContext context, String action, SanitizationProtocol p) {
    final admin = context.read<AdminProvider>();
    switch (action) {
      case 'edit':
        _showProtocolSheet(context, existing: p);
        break;
      case 'toggle':
        admin.updateSanitizationProtocol(p.id, isActive: !p.isActive);
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Protocol?'),
            content: Text('Remove "${p.name}"?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  admin.deleteSanitizationProtocol(p.id);
                  Navigator.pop(ctx);
                },
                child: const Text('Delete',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        break;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Bottom Sheet Forms
// ═════════════════════════════════════════════════════════════════════════════

void _showSanitizerSheet(BuildContext context,
    {SanitizationSanitizer? existing}) {
  final isEdit = existing != null;
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final emojiCtrl = TextEditingController(text: existing?.emoji ?? '🧴');
  final dilCtrl = TextEditingController(text: existing?.dilution ?? '');
  final safetyCtrl = TextEditingController(text: existing?.safety ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(children: [
                const Text('🧴', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Text(isEdit ? 'Edit Sanitizer' : 'Add Sanitizer',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 24),
              _buildFormField(
                  icon: Icons.label_rounded,
                  label: 'Name',
                  controller: nameCtrl,
                  hint: 'Sanitizer name'),
              const SizedBox(height: 16),
              _buildFormField(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Emoji',
                  controller: emojiCtrl,
                  hint: '🧴'),
              const SizedBox(height: 16),
              _buildFormField(
                  icon: Icons.water_drop_rounded,
                  label: 'Dilution Instructions',
                  controller: dilCtrl,
                  hint: 'e.g. 1:10 with water'),
              const SizedBox(height: 16),
              _buildFormField(
                  icon: Icons.warning_rounded,
                  label: 'Safety Notes',
                  controller: safetyCtrl,
                  hint: 'e.g. Wear gloves'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;
                    final admin = context.read<AdminProvider>();
                    if (isEdit) {
                      admin.updateSanitizer(existing.id,
                          name: name,
                          emoji: emojiCtrl.text.trim(),
                          dilution: dilCtrl.text.trim(),
                          safety: safetyCtrl.text.trim());
                    } else {
                      admin.addSanitizer(SanitizationSanitizer(
                        id: 'SAN${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        emoji: emojiCtrl.text.trim().isEmpty
                            ? '🧴'
                            : emojiCtrl.text.trim(),
                        dilution: dilCtrl.text.trim(),
                        safety: safetyCtrl.text.trim(),
                      ));
                    }
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00838F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isEdit ? 'Update' : 'Add Sanitizer',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showAreaSheet(BuildContext context, {SanitizationArea? existing}) {
  final isEdit = existing != null;
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final emojiCtrl = TextEditingController(text: existing?.emoji ?? '🏠');
  final freqCtrl = TextEditingController(text: existing?.frequency ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.35,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollCtrl,
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Row(children: [
                const Text('🏠', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Text(isEdit ? 'Edit Area' : 'Add Area',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 24),
              _buildFormField(
                  icon: Icons.label_rounded,
                  label: 'Area Name',
                  controller: nameCtrl,
                  hint: 'e.g. Milking Parlour'),
              const SizedBox(height: 16),
              _buildFormField(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Emoji',
                  controller: emojiCtrl,
                  hint: '🏠'),
              const SizedBox(height: 16),
              _buildFormField(
                  icon: Icons.schedule_rounded,
                  label: 'Recommended Frequency',
                  controller: freqCtrl,
                  hint: 'e.g. Weekly'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;
                    final admin = context.read<AdminProvider>();
                    if (isEdit) {
                      admin.updateSanitizationArea(existing.id,
                          name: name,
                          emoji: emojiCtrl.text.trim(),
                          frequency: freqCtrl.text.trim());
                    } else {
                      admin.addSanitizationArea(SanitizationArea(
                        id: 'AR${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        emoji: emojiCtrl.text.trim().isEmpty
                            ? '🏠'
                            : emojiCtrl.text.trim(),
                        frequency: freqCtrl.text.trim(),
                      ));
                    }
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isEdit ? 'Update' : 'Add Area',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showProtocolSheet(BuildContext context,
    {SanitizationProtocol? existing}) {
  final isEdit = existing != null;
  final admin = context.read<AdminProvider>();
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final freqCtrl = TextEditingController(text: existing?.frequency ?? '');
  final instrCtrl =
      TextEditingController(text: existing?.instructions ?? '');

  String selectedAreaId = existing?.areaId ?? '';
  List<String> selectedSanitizerIds =
      List<String>.from(existing?.sanitizerIds ?? []);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheetState) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (ctx, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(children: [
                  const Text('📋', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Text(isEdit ? 'Edit Protocol' : 'Add Protocol',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 24),
                _buildFormField(
                    icon: Icons.label_rounded,
                    label: 'Protocol Name',
                    controller: nameCtrl,
                    hint: 'e.g. Weekly Gate Disinfection'),
                const SizedBox(height: 16),

                // Area dropdown
                const Text('🏠 Target Area',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedAreaId.isEmpty ? null : selectedAreaId,
                      hint: const Text('Select area'),
                      isExpanded: true,
                      items: admin.sanitizationAreas
                          .where((a) => a.isActive)
                          .map((a) => DropdownMenuItem(
                              value: a.id,
                              child: Text('${a.emoji} ${a.name}')))
                          .toList(),
                      onChanged: (v) =>
                          setSheetState(() => selectedAreaId = v ?? ''),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sanitizer multi-select
                const Text('🧴 Sanitizers',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: admin.sanitizers
                      .where((s) => s.isActive)
                      .map((s) {
                    final selected = selectedSanitizerIds.contains(s.id);
                    return FilterChip(
                      label: Text('${s.emoji} ${s.name}'),
                      selected: selected,
                      selectedColor:
                          const Color(0xFF00838F).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFF00838F),
                      onSelected: (v) {
                        setSheetState(() {
                          if (v) {
                            selectedSanitizerIds.add(s.id);
                          } else {
                            selectedSanitizerIds.remove(s.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _buildFormField(
                    icon: Icons.schedule_rounded,
                    label: 'Frequency',
                    controller: freqCtrl,
                    hint: 'e.g. Weekly'),
                const SizedBox(height: 16),
                _buildFormField(
                    icon: Icons.notes_rounded,
                    label: 'Instructions',
                    controller: instrCtrl,
                    hint: 'Step-by-step instructions',
                    maxLines: 3),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty || selectedAreaId.isEmpty) return;
                      if (isEdit) {
                        admin.updateSanitizationProtocol(existing.id,
                            name: name,
                            areaId: selectedAreaId,
                            sanitizerIds: selectedSanitizerIds,
                            frequency: freqCtrl.text.trim(),
                            instructions: instrCtrl.text.trim());
                      } else {
                        admin.addSanitizationProtocol(SanitizationProtocol(
                          id: 'SP${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          areaId: selectedAreaId,
                          sanitizerIds: selectedSanitizerIds,
                          frequency: freqCtrl.text.trim(),
                          instructions: instrCtrl.text.trim(),
                        ));
                      }
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(isEdit ? 'Update' : 'Add Protocol',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// Shared form field helper
// ═════════════════════════════════════════════════════════════════════════════
Widget _buildFormField({
  required IconData icon,
  required String label,
  required TextEditingController controller,
  required String hint,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ]),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF00695C), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    ],
  );
}
