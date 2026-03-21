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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Health Config'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Vaccines'),
            Tab(text: 'Diseases'),
            Tab(text: 'Medicines'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _ConfigList(type: 'Vaccine'),
          _ConfigList(type: 'Disease'),
          _ConfigList(type: 'Medicine'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final types = ['Vaccine', 'Disease', 'Medicine'];
    final nameCtrl = TextEditingController();
    final speciesCtrl = TextEditingController();
    final infoCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add ${types[_tab.index]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: speciesCtrl, decoration: const InputDecoration(labelText: 'Applicable Species')),
            const SizedBox(height: 10),
            TextField(controller: infoCtrl, decoration: InputDecoration(labelText: _tab.index == 0 ? 'Schedule' : _tab.index == 1 ? 'Severity' : 'Category')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final type = types[_tab.index];
              context.read<AdminProvider>().addHealthConfig(HealthConfigItem(
                id: '${type[0]}${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                species: speciesCtrl.text.trim().isEmpty ? 'All' : speciesCtrl.text.trim(),
                info: infoCtrl.text.trim(),
                type: type,
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${types[_tab.index]} added!'), backgroundColor: Colors.green));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _ConfigList extends StatelessWidget {
  final String type;

  const _ConfigList({required this.type});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final items = admin.getConfigListByType(type);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medical_services_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('No ${type.toLowerCase()}s configured', style: TextStyle(color: Colors.grey[500])),
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
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.12),
                child: Icon(
                  type == 'Vaccine' ? Icons.vaccines_rounded : type == 'Disease' ? Icons.bug_report_rounded : Icons.medication_rounded,
                  size: 18,
                  color: RumenoTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: Theme.of(context).textTheme.titleSmall),
                    Text('${item.species} • ${item.info}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'Edit') {
                    _showEditDialog(context, item);
                  } else if (v == 'Delete') {
                    _confirmDelete(context, item);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'Edit', child: Text('Edit')),
                  PopupMenuItem(value: 'Delete', child: Text('Delete')),
                ],
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(controller: speciesCtrl, decoration: const InputDecoration(labelText: 'Applicable Species')),
            const SizedBox(height: 10),
            TextField(controller: infoCtrl, decoration: InputDecoration(labelText: type == 'Vaccine' ? 'Schedule' : type == 'Disease' ? 'Severity' : 'Category')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<AdminProvider>().updateHealthConfig(
                item.id, type,
                name: nameCtrl.text.trim(),
                species: speciesCtrl.text.trim(),
                info: infoCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} updated!'), backgroundColor: Colors.green));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, HealthConfigItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: RumenoTheme.errorRed),
            onPressed: () {
              context.read<AdminProvider>().deleteHealthConfig(item.id, type);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} deleted')));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
