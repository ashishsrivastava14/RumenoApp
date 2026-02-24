import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/vaccination_card.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Vaccinations'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Schedule'),
            Tab(text: 'History'),
            Tab(text: 'Reminders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ScheduleTab(),
          _HistoryTab(),
          _RemindersTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVaccinationDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }

  void _showAddVaccinationDialog(BuildContext context) {
    String selectedVaccine = 'FMD';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Vaccination', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedVaccine,
              decoration: const InputDecoration(labelText: 'Vaccine'),
              items: ['FMD', 'BQ', 'HS', 'PPR', 'Brucella', 'Deworming'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => selectedVaccine = v!,
            ),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Animal ID')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Vet Name')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Dose & Batch Number')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vaccination record added!'), backgroundColor: Colors.green));
                },
                child: const Text('Save Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upcoming = mockVaccinations.where((v) => v.status != VaccinationStatus.done).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: upcoming.length,
      itemBuilder: (context, index) => VaccinationCard(record: upcoming[index]),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final done = mockVaccinations.where((v) => v.status == VaccinationStatus.done).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: done.length,
      itemBuilder: (context, index) => VaccinationCard(record: done[index]),
    );
  }
}

class _RemindersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final overdue = mockVaccinations.where((v) => v.status == VaccinationStatus.overdue).toList();
    final due = mockVaccinations.where((v) => v.status == VaccinationStatus.due).toList();
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (overdue.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('⚠️ Overdue (${overdue.length})', style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.errorRed)),
          ),
          ...overdue.map((v) => VaccinationCard(record: v)),
        ],
        if (due.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('📅 Upcoming (${due.length})', style: TextStyle(fontWeight: FontWeight.bold, color: RumenoTheme.warningYellow)),
          ),
          ...due.map((v) => VaccinationCard(record: v)),
        ],
      ],
    );
  }
}
