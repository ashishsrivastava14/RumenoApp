import 'package:flutter/material.dart';
import '../../config/theme.dart';

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
          _ConfigList(
            items: const [
              {'name': 'FMD Vaccine', 'species': 'All', 'schedule': 'Every 6 months'},
              {'name': 'HS Vaccine', 'species': 'Cattle, Buffalo', 'schedule': 'Annual'},
              {'name': 'BQ Vaccine', 'species': 'Cattle', 'schedule': 'Annual'},
              {'name': 'Brucella Vaccine', 'species': 'Cattle, Buffalo', 'schedule': 'Once (4-8 months age)'},
              {'name': 'PPR Vaccine', 'species': 'Goat, Sheep', 'schedule': 'Annual'},
              {'name': 'Goat Pox Vaccine', 'species': 'Goat', 'schedule': 'Annual'},
              {'name': 'Enterotoxaemia Vaccine', 'species': 'Goat, Sheep', 'schedule': 'Every 6 months'},
              {'name': 'Swine Fever Vaccine', 'species': 'Pig', 'schedule': 'Annual'},
            ],
            type: 'Vaccine',
          ),
          _ConfigList(
            items: const [
              {'name': 'Mastitis', 'species': 'Cattle, Buffalo', 'schedule': 'Common'},
              {'name': 'Foot & Mouth Disease', 'species': 'All ruminants', 'schedule': 'Notifiable'},
              {'name': 'Brucellosis', 'species': 'Cattle, Buffalo', 'schedule': 'Zoonotic'},
              {'name': 'Bovine Tuberculosis', 'species': 'Cattle', 'schedule': 'Zoonotic'},
              {'name': 'Tick Fever', 'species': 'Cattle', 'schedule': 'Seasonal'},
              {'name': 'Bloat', 'species': 'All ruminants', 'schedule': 'Emergency'},
            ],
            type: 'Disease',
          ),
          _ConfigList(
            items: const [
              {'name': 'Ivermectin', 'species': 'All', 'schedule': 'Dewormer'},
              {'name': 'Oxytetracycline', 'species': 'All', 'schedule': 'Antibiotic'},
              {'name': 'Meloxicam', 'species': 'Cattle, Buffalo', 'schedule': 'Anti-inflammatory'},
              {'name': 'Calcium Borogluconate', 'species': 'Cattle', 'schedule': 'Supplement'},
              {'name': 'Albendazole', 'species': 'All', 'schedule': 'Dewormer'},
              {'name': 'Enrofloxacin', 'species': 'All', 'schedule': 'Antibiotic'},
            ],
            type: 'Medicine',
          ),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add ${types[_tab.index]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Applicable Species')),
            const SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: _tab.index == 0 ? 'Schedule' : _tab.index == 1 ? 'Severity' : 'Category')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
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
  final List<Map<String, String>> items;
  final String type;

  const _ConfigList({required this.items, required this.type});

  @override
  Widget build(BuildContext context) {
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
                    Text(item['name']!, style: Theme.of(context).textTheme.titleSmall),
                    Text('${item['species']} • ${item['schedule']}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$v: ${item['name']}')));
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
}
