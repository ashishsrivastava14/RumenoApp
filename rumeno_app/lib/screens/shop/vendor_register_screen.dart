import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Text(l10n.vendorRegisterTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/shop');
            }
          },
        ),
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
                      child: Text(l10n.vendorRegisterContinueButton),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submitRegistration,
                      child: Text(l10n.vendorRegisterSubmitButton),
                    ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: Text(l10n.commonBack),
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
              title: Text(l10n.vendorRegisterStep1),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _businessNameC, decoration: InputDecoration(labelText: l10n.vendorRegisterBusinessName)),
                  const SizedBox(height: 10),
                  TextFormField(controller: _ownerNameC, decoration: InputDecoration(labelText: l10n.vendorRegisterOwnerName)),
                  const SizedBox(height: 10),
                  TextFormField(controller: _phoneC, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: l10n.vendorRegisterPhone, prefixText: l10n.loginPhonePrefix)),
                  const SizedBox(height: 10),
                  TextFormField(controller: _emailC, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: l10n.vendorRegisterEmail)),
                ],
              ),
            ),
            Step(
              title: Text(l10n.vendorRegisterStep2),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _gstC, decoration: InputDecoration(labelText: l10n.vendorRegisterGst)),
                  const SizedBox(height: 10),
                  TextFormField(controller: _panC, decoration: InputDecoration(labelText: l10n.vendorRegisterPan)),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_file),
                    label: Text(l10n.vendorRegisterUploadIdProof),
                  ),
                ],
              ),
            ),
            Step(
              title: Text(l10n.vendorRegisterStep3),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _bankNameC, decoration: InputDecoration(labelText: l10n.vendorRegisterBankName)),
                  const SizedBox(height: 10),
                  TextFormField(controller: _accountC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.vendorRegisterAccountNumber)),
                  const SizedBox(height: 10),
                  TextFormField(controller: _ifscC, decoration: InputDecoration(labelText: l10n.vendorRegisterIfsc)),
                ],
              ),
            ),
            Step(
              title: Text(l10n.vendorRegisterStep4),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(controller: _addressC, maxLines: 2, decoration: InputDecoration(labelText: l10n.vendorRegisterBusinessAddress)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: TextFormField(controller: _cityC, decoration: InputDecoration(labelText: l10n.vendorRegisterCity))),
                      const SizedBox(width: 10),
                      Expanded(child: TextFormField(controller: _stateC, decoration: InputDecoration(labelText: l10n.vendorRegisterState))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(controller: _pincodeC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.vendorRegisterPincode)),
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
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: RumenoTheme.successGreen),
              const SizedBox(width: 8),
              Text(dialogL10n.vendorRegisterSuccessTitle),
            ],
          ),
          content: Text(
            dialogL10n.vendorRegisterSuccessMessage,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/shop');
              },
              child: Text(dialogL10n.commonGotIt),
            ),
          ],
        );
      },
    );
  }
}
