import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1
  Species _species = Species.cow;
  Gender _gender = Gender.female;
  final _breedController = TextEditingController();
  final _tagController = TextEditingController(text: 'C-009');
  DateTime _dob = DateTime(2023, 1, 1);
  bool _autoTag = true;

  // Step 2
  final _weightController = TextEditingController(text: '400');
  final _heightController = TextEditingController(text: '130');
  final _colorController = TextEditingController(text: 'Brown');

  // Step 3
  String? _fatherId;
  String? _motherId;

  // Step 4
  final _shedController = TextEditingController(text: 'A1');
  AnimalPurpose _purpose = AnimalPurpose.dairy;

  @override
  void dispose() {
    _breedController.dispose();
    _tagController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _colorController.dispose();
    _shedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Add Animal')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
            } else {
              // Save
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Animal added successfully!'), backgroundColor: Colors.green),
              );
              context.pop();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Save Animal' : 'Next'),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Basic Info'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Auto-generate Tag ID'),
                    value: _autoTag,
                    onChanged: (v) => setState(() => _autoTag = v),
                    activeThumbColor: RumenoTheme.primaryGreen,
                  ),
                  if (!_autoTag)
                    TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(labelText: 'Tag ID'),
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Species>(
                    initialValue: _species,
                    decoration: const InputDecoration(labelText: 'Species'),
                    items: Species.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _species = v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _breedController,
                    decoration: const InputDecoration(labelText: 'Breed'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Date of Birth'),
                    subtitle: Text('${_dob.day}/${_dob.month}/${_dob.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dob,
                        firstDate: DateTime(2015),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _dob = date);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Gender: '),
                      const SizedBox(width: 16),
                      ChoiceChip(label: const Text('Male'), selected: _gender == Gender.male, onSelected: (_) => setState(() => _gender = Gender.male), selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2)),
                      const SizedBox(width: 8),
                      ChoiceChip(label: const Text('Female'), selected: _gender == Gender.female, onSelected: (_) => setState(() => _gender = Gender.female), selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2)),
                    ],
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Physical Details'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _weightController, decoration: const InputDecoration(labelText: 'Weight (kg)'), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  TextFormField(controller: _heightController, decoration: const InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  TextFormField(controller: _colorController, decoration: const InputDecoration(labelText: 'Color / Markings')),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo upload (mock)'))),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Upload Photo'),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Pedigree'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _fatherId,
                    decoration: const InputDecoration(labelText: 'Father ID'),
                    items: [null, 'C-007', 'B-005'].map((s) => DropdownMenuItem(value: s, child: Text(s ?? 'None'))).toList(),
                    onChanged: (v) => setState(() => _fatherId = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _motherId,
                    decoration: const InputDecoration(labelText: 'Mother ID'),
                    items: [null, 'C-001', 'C-002', 'C-003'].map((s) => DropdownMenuItem(value: s, child: Text(s ?? 'None'))).toList(),
                    onChanged: (v) => setState(() => _motherId = v),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Farm Assignment'),
              isActive: _currentStep >= 3,
              content: Column(
                children: [
                  TextFormField(controller: _shedController, decoration: const InputDecoration(labelText: 'Shed / Pen Number')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<AnimalPurpose>(
                    initialValue: _purpose,
                    decoration: const InputDecoration(labelText: 'Purpose'),
                    items: AnimalPurpose.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _purpose = v!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
