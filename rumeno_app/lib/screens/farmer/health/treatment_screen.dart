import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_health.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/health_record_card.dart';

class TreatmentScreen extends StatelessWidget {
  const TreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Disease & Treatment')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Active Treatments', style: Theme.of(context).textTheme.titleMedium),
          ),
          ...mockTreatments
              .where((t) => t.status == TreatmentStatus.active || t.status == TreatmentStatus.followUp)
              .map((t) => HealthRecordCard(record: t)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Completed Treatments', style: Theme.of(context).textTheme.titleMedium),
          ),
          ...mockTreatments
              .where((t) => t.status == TreatmentStatus.completed)
              .map((t) => HealthRecordCard(record: t)),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTreatmentDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Treatment'),
      ),
    );
  }

  void _showAddTreatmentDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Treatment', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Animal ID')),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: ['Fever', 'Diarrhea', 'Limping', 'Loss of appetite', 'Coughing', 'Bloating']
                  .map((s) => FilterChip(label: Text(s, style: const TextStyle(fontSize: 12)), onSelected: (_) {}, selected: false))
                  .toList(),
            ),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Diagnosis')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Treatment / Medicine')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Withdrawal Period (days)')),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Lab report upload (mock)'))),
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach Lab Report'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Treatment added!'), backgroundColor: Colors.green));
                },
                child: const Text('Save Treatment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
