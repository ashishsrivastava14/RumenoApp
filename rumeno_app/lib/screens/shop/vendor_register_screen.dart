import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/common/marketplace_button.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Step 1: Business Info
  final _businessNameC = TextEditingController();
  final _ownerNameC = TextEditingController();
  final _phoneC = TextEditingController();
  final _emailC = TextEditingController();

  // Step 2: Documents
  final _gstC = TextEditingController();
  final _panC = TextEditingController();

  // Step 3: Bank Details
  final _bankNameC = TextEditingController();
  final _accountC = TextEditingController();
  final _ifscC = TextEditingController();

  // Step 4: Address
  final _addressC = TextEditingController();
  final _cityC = TextEditingController();
  final _stateC = TextEditingController();
  final _pincodeC = TextEditingController();

  @override
  void dispose() {
    _businessNameC.dispose();
    _ownerNameC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    _gstC.dispose();
    _panC.dispose();
    _bankNameC.dispose();
    _accountC.dispose();
    _ifscC.dispose();
    _addressC.dispose();
    _cityC.dispose();
    _stateC.dispose();
    _pincodeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Vendor Registration'),
        actions: const [VeterinarianButton(), FarmButton()],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          type: StepperType.vertical,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  if (_currentStep < 3)
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continue'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submitRegistration,
                      child: const Text('Submit Application'),
                    ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            Step(
              title: const Text('Business Information'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _businessNameC, decoration: const InputDecoration(labelText: 'Business Name *')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _ownerNameC, decoration: const InputDecoration(labelText: 'Owner Name *')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number *', prefixText: '+91 ')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _emailC, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email *')),
                ],
              ),
            ),
            Step(
              title: const Text('Documents'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _gstC, decoration: const InputDecoration(labelText: 'GST Number *')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _panC, decoration: const InputDecoration(labelText: 'PAN Number *')),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload ID Proof'),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Bank Details'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _bankNameC, decoration: const InputDecoration(labelText: 'Bank Name *')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _accountC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Account Number *')),
                  const SizedBox(height: 10),
                  TextFormField(controller: _ifscC, decoration: const InputDecoration(labelText: 'IFSC Code *')),
                ],
              ),
            ),
            Step(
              title: const Text('Address'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _addressC, maxLines: 2, decoration: const InputDecoration(labelText: 'Business Address *')),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: TextFormField(controller: _cityC, decoration: const InputDecoration(labelText: 'City *'))),
                      const SizedBox(width: 10),
                      Expanded(child: TextFormField(controller: _stateC, decoration: const InputDecoration(labelText: 'State *'))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(controller: _pincodeC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Pincode *')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRegistration() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: RumenoTheme.successGreen),
            const SizedBox(width: 8),
            const Text('Application Submitted'),
          ],
        ),
        content: const Text(
          'Your vendor registration has been submitted for review. Our team will verify your documents and approve your account within 2-3 business days. You will be notified via email.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/shop');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
