import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../mock/mock_health.dart';
import '../../widgets/cards/health_record_card.dart';
import '../../widgets/cards/vaccination_card.dart';

class VetAnimalHealthScreen extends StatefulWidget {
  const VetAnimalHealthScreen({super.key});

  @override
  State<VetAnimalHealthScreen> createState() => _VetAnimalHealthScreenState();
}

class _VetAnimalHealthScreenState extends State<VetAnimalHealthScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Animal Health'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Records'),
            Tab(text: 'Vaccinations'),
            Tab(text: 'Consult'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _RecordsTab(),
          _VaccinationsTab(),
          _ConsultTab(),
        ],
      ),
    );
  }
}

class _RecordsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockTreatments.length,
      itemBuilder: (context, index) {
        return HealthRecordCard(record: mockTreatments[index]);
      },
    );
  }
}

class _VaccinationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockVaccinations.length,
      itemBuilder: (context, index) {
        return VaccinationCard(record: mockVaccinations[index]);
      },
    );
  }
}

class _ConsultTab extends StatefulWidget {
  @override
  State<_ConsultTab> createState() => _ConsultTabState();
}

class _ConsultTabState extends State<_ConsultTab> {
  final _notesController = TextEditingController();
  String _selectedAnimal = 'Gir (C-001)';
  final _symptoms = <String>[];
  final _allSymptoms = ['Fever', 'Loss of appetite', 'Lethargy', 'Lameness', 'Swelling', 'Diarrhea', 'Cough', 'Nasal discharge', 'Reduced milk'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Consultation', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // Animal selection
          DropdownButtonFormField<String>(
            initialValue: _selectedAnimal,
            decoration: const InputDecoration(labelText: 'Select Animal'),
            items: mockAnimals.take(8).map((a) => DropdownMenuItem(value: '${a.breed} (${a.tagId})', child: Text('${a.breed} (${a.tagId})'))).toList(),
            onChanged: (v) => setState(() => _selectedAnimal = v!),
          ),
          const SizedBox(height: 16),

          // Symptoms
          Text('Symptoms', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _allSymptoms.map((s) => FilterChip(
              label: Text(s),
              selected: _symptoms.contains(s),
              selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
              checkmarkColor: RumenoTheme.primaryGreen,
              onSelected: (sel) {
                setState(() {
                  sel ? _symptoms.add(s) : _symptoms.remove(s);
                });
              },
            )).toList(),
          ),
          const SizedBox(height: 16),

          // Diagnosis
          const TextField(
            decoration: InputDecoration(labelText: 'Diagnosis'),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(labelText: 'Treatment Prescribed'),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(labelText: 'Medicines'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Follow-up'),
                  items: ['No follow-up', 'After 3 days', 'After 1 week', 'After 2 weeks', 'After 1 month']
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Consultation saved!'), backgroundColor: Colors.green),
                );
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Consultation'),
            ),
          ),
        ],
      ),
    );
  }
}
