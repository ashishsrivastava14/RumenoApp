import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const List<String> _qualifications = ['BVSc', 'MVSc', 'PhD', 'BVSc & AH'];

const List<String> _specializationOptions = [
  'Large Animal Medicine',
  'Small Animal Medicine',
  'Poultry',
  'Surgery',
  'Reproduction & Fertility',
  'Dairy Management',
  'Nutrition & Feed',
  'Pathology',
  'Pharmacology',
  'Preventive Medicine',
  'Wildlife & Zoo Medicine',
  'Aquatic Animal Health',
];

// ─── Enums / helpers ─────────────────────────────────────────────────────────

enum _OtpStatus { idle, sending, sent, verified }

enum _EmailStatus { idle, sending, sent, verified }

enum _DocUploadStatus { idle, uploading, uploaded }

// ─── Screen ──────────────────────────────────────────────────────────────────

class VetRegisterScreen extends StatefulWidget {
  const VetRegisterScreen({super.key});

  @override
  State<VetRegisterScreen> createState() => _VetRegisterScreenState();
}

class _VetRegisterScreenState extends State<VetRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Step 1 — Personal & Professional
  final _fullNameC = TextEditingController();
  String? _qualification;
  final List<String> _selectedSpecializations = [];
  final _experienceC = TextEditingController();

  // Step 2 — Contact & Verification
  final _phoneC = TextEditingController();
  final _otpC = TextEditingController();
  _OtpStatus _otpStatus = _OtpStatus.idle;

  final _emailC = TextEditingController();
  _EmailStatus _emailStatus = _EmailStatus.idle;

  // Step 3 — Documents
  _DocUploadStatus _govIdStatus = _DocUploadStatus.idle;
  String? _govIdFileName;
  _DocUploadStatus _degreeStatus = _DocUploadStatus.idle;
  String? _degreeFileName;

  // Step 4 — Clinic / Practice Address
  final _addressLine1C = TextEditingController();
  final _addressLine2C = TextEditingController();
  final _cityC = TextEditingController();
  final _stateC = TextEditingController();
  final _pincodeC = TextEditingController();

  @override
  void dispose() {
    _fullNameC.dispose();
    _experienceC.dispose();
    _phoneC.dispose();
    _otpC.dispose();
    _emailC.dispose();
    _addressLine1C.dispose();
    _addressLine2C.dispose();
    _cityC.dispose();
    _stateC.dispose();
    _pincodeC.dispose();
    super.dispose();
  }

  // ── Navigation helpers ───────────────────────────────────────────────────

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState?.validate() == true &&
            _qualification != null &&
            _selectedSpecializations.isNotEmpty;
      case 1:
        return _otpStatus == _OtpStatus.verified &&
            _emailStatus == _EmailStatus.verified;
      case 2:
        return _govIdStatus == _DocUploadStatus.uploaded &&
            _degreeStatus == _DocUploadStatus.uploaded;
      case 3:
        return _formKey.currentState?.validate() == true;
      default:
        return true;
    }
  }

  void _onStepContinue() {
    // Trigger form validation first for text fields
    _formKey.currentState?.validate();

    if (!_validateCurrentStep()) {
      _showStepError();
      return;
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitRegistration();
    }
  }

  void _showStepError() {
    String message;
    switch (_currentStep) {
      case 0:
        if (_qualification == null) {
          message = 'Please select your qualification.';
        } else if (_selectedSpecializations.isEmpty) {
          message = 'Please select at least one specialization.';
        } else {
          message = 'Please fill in all required fields.';
        }
        break;
      case 1:
        if (_otpStatus != _OtpStatus.verified) {
          message = 'Please verify your phone number via OTP.';
        } else {
          message = 'Please verify your email address.';
        }
        break;
      case 2:
        message = 'Please upload both required documents.';
        break;
      default:
        message = 'Please fill in all address fields.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: RumenoTheme.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── OTP helpers ─────────────────────────────────────────────────────────

  void _sendOtp() async {
    if (_phoneC.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter a valid 10-digit mobile number.'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _otpStatus = _OtpStatus.sending);
    // TODO: call real OTP service
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _otpStatus = _OtpStatus.sent);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('OTP sent to your mobile number.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _verifyOtp() async {
    if (_otpC.text.isEmpty) return;
    // TODO: validate OTP with backend; using 1234 as mock
    setState(() => _otpStatus = _OtpStatus.sending);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _otpStatus = _OtpStatus.verified);
  }

  // ── Email helpers ────────────────────────────────────────────────────────

  void _sendEmailVerification() async {
    if (!_emailC.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter a valid email address.'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _emailStatus = _EmailStatus.sending);
    // TODO: call real email verification service
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _emailStatus = _EmailStatus.sent);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification link sent to ${_emailC.text}.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // Simulates user clicking the link; real app polls backend or uses deep link
  void _markEmailVerified() {
    setState(() => _emailStatus = _EmailStatus.verified);
  }

  // ── Document upload helpers ──────────────────────────────────────────────

  void _uploadDocument(bool isGovId) async {
    // TODO: integrate file_picker or image_picker
    if (isGovId) {
      setState(() => _govIdStatus = _DocUploadStatus.uploading);
      await Future.delayed(const Duration(milliseconds: 1200));
      setState(() {
        _govIdStatus = _DocUploadStatus.uploaded;
        _govIdFileName = 'government_id.pdf';
      });
    } else {
      setState(() => _degreeStatus = _DocUploadStatus.uploading);
      await Future.delayed(const Duration(milliseconds: 1200));
      setState(() {
        _degreeStatus = _DocUploadStatus.uploaded;
        _degreeFileName = 'degree_certificate.pdf';
      });
    }
  }

  // ── Submission ───────────────────────────────────────────────────────────

  void _submitRegistration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: RumenoTheme.primaryGreen, size: 52),
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Submitted!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your veterinarian registration is under review. Our admin team will verify your documents and activate your account within 2–3 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go('/role-selection');
                },
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Veterinarian Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/role-selection'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          type: StepperType.vertical,
          physics: const ClampingScrollPhysics(),
          controlsBuilder: (context, details) => Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _onStepContinue,
                  child: Text(_currentStep < 3 ? 'Continue' : 'Submit'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () =>
                        setState(() => _currentStep--),
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          ),
          steps: [
            _buildStep0(),
            _buildStep1(),
            _buildStep2(),
            _buildStep3(),
          ],
        ),
      ),
    );
  }

  // ─── Step 0 — Professional Details ───────────────────────────────────────

  Step _buildStep0() {
    return Step(
      title: const Text('Professional Details'),
      subtitle: const Text('Name, qualification & specialization'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name
          TextFormField(
            controller: _fullNameC,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Full name is required.' : null,
          ),
          const SizedBox(height: 14),

          // Qualification dropdown
          DropdownButtonFormField<String>(
            value: _qualification,
            decoration: const InputDecoration(
              labelText: 'Qualification *',
              prefixIcon: Icon(Icons.school_outlined),
            ),
            items: _qualifications
                .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                .toList(),
            onChanged: (v) => setState(() => _qualification = v),
            validator: (v) =>
                v == null ? 'Please select a qualification.' : null,
          ),
          const SizedBox(height: 14),

          // Years of Experience
          TextFormField(
            controller: _experienceC,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Years of Experience *',
              prefixIcon: Icon(Icons.work_history_outlined),
              suffixText: 'yrs',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Years of experience is required.';
              }
              final n = int.tryParse(v);
              if (n == null || n < 0 || n > 60) {
                return 'Enter a valid number (0–60).';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Specialization multi-select
          const Text(
            'Specialization Areas *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: RumenoTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          if (_selectedSpecializations.isEmpty)
            const Text(
              'Select at least one area',
              style: TextStyle(fontSize: 12, color: RumenoTheme.errorRed),
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _specializationOptions.map((s) {
              final selected = _selectedSpecializations.contains(s);
              return FilterChip(
                label: Text(s,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? Colors.white : RumenoTheme.textDark,
                    )),
                selected: selected,
                selectedColor: RumenoTheme.primaryGreen,
                checkmarkColor: Colors.white,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: selected
                      ? RumenoTheme.primaryGreen
                      : RumenoTheme.textLight,
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedSpecializations.add(s);
                    } else {
                      _selectedSpecializations.remove(s);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Step 1 — Contact & Verification ─────────────────────────────────────

  Step _buildStep1() {
    final otpVerified = _otpStatus == _OtpStatus.verified;
    final emailVerified = _emailStatus == _EmailStatus.verified;

    return Step(
      title: const Text('Contact & Verification'),
      subtitle: const Text('Phone OTP and email link'),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Phone + OTP ──
          _SectionLabel(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            verified: otpVerified,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _phoneC,
                  enabled: !otpVerified,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number *',
                    prefixText: '+91 ',
                  ),
                  validator: (v) {
                    if (_currentStep < 1) return null;
                    if (v == null || v.length < 10) {
                      return 'Enter 10-digit number.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _otpStatus == _OtpStatus.sending
                    ? const SizedBox(
                        width: 40, height: 40, child: CircularProgressIndicator())
                    : otpVerified
                        ? const Icon(Icons.verified_rounded,
                            color: RumenoTheme.successGreen, size: 36)
                        : OutlinedButton(
                            onPressed: _otpStatus == _OtpStatus.sent
                                ? null
                                : _sendOtp,
                            child: Text(
                              _otpStatus == _OtpStatus.sent
                                  ? 'Sent'
                                  : 'Send OTP',
                            ),
                          ),
              ),
            ],
          ),

          // OTP input (shown once sent)
          if (_otpStatus == _OtpStatus.sent ||
              _otpStatus == _OtpStatus.verified) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _otpC,
                    enabled: !otpVerified,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      suffixIcon: otpVerified
                          ? const Icon(Icons.check_circle_rounded,
                              color: RumenoTheme.successGreen)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (!otpVerified)
                  ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text('Verify'),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // ── Email ──
          _SectionLabel(
            icon: Icons.email_outlined,
            label: 'Email Address',
            verified: emailVerified,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailC,
                  enabled: !emailVerified,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address *',
                  ),
                  validator: (v) {
                    if (_currentStep < 1) return null;
                    if (v == null || !v.contains('@')) {
                      return 'Enter a valid email.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _emailStatus == _EmailStatus.sending
                    ? const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator())
                    : emailVerified
                        ? const Icon(Icons.verified_rounded,
                            color: RumenoTheme.successGreen, size: 36)
                        : OutlinedButton(
                            onPressed: _emailStatus == _EmailStatus.sent
                                ? null
                                : _sendEmailVerification,
                            child: Text(
                              _emailStatus == _EmailStatus.sent
                                  ? 'Sent'
                                  : 'Send Link',
                            ),
                          ),
              ),
            ],
          ),

          // "Mark verified" button (simulates email link click in development)
          if (_emailStatus == _EmailStatus.sent) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _markEmailVerified,
              icon: const Icon(Icons.open_in_browser_rounded, size: 16),
              label: const Text("I've clicked the verification link"),
              style: TextButton.styleFrom(
                foregroundColor: RumenoTheme.primaryGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Step 2 — Documents ───────────────────────────────────────────────────

  Step _buildStep2() {
    return Step(
      title: const Text('Documents Upload'),
      subtitle: const Text('ID proof and degree — reviewed by admin'),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          _DocUploadTile(
            icon: Icons.badge_outlined,
            title: 'Government ID Proof',
            subtitle: 'Aadhaar / Passport / Driving Licence',
            status: _govIdStatus,
            fileName: _govIdFileName,
            onUpload: () => _uploadDocument(true),
          ),
          const SizedBox(height: 12),
          _DocUploadTile(
            icon: Icons.school_outlined,
            title: 'Degree Certificate',
            subtitle: 'BVSc / MVSc / PhD certificate',
            status: _degreeStatus,
            fileName: _degreeFileName,
            onUpload: () => _uploadDocument(false),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: RumenoTheme.infoBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: RumenoTheme.infoBlue.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: RumenoTheme.infoBlue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Uploaded documents will be manually reviewed by the Rumeno admin team before your account is activated.',
                    style:
                        TextStyle(fontSize: 12, color: RumenoTheme.textGrey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 3 — Clinic / Practice Address ──────────────────────────────────

  Step _buildStep3() {
    return Step(
      title: const Text('Clinic / Practice Address'),
      subtitle: const Text('Where you practise'),
      isActive: _currentStep >= 3,
      state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          TextFormField(
            controller: _addressLine1C,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Address Line 1 *',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            validator: (v) =>
                (_currentStep == 3 && (v == null || v.trim().isEmpty))
                    ? 'Address is required.'
                    : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressLine2C,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Address Line 2 (optional)',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityC,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'City *'),
                  validator: (v) =>
                      (_currentStep == 3 && (v == null || v.trim().isEmpty))
                          ? 'Required'
                          : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _stateC,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'State *'),
                  validator: (v) =>
                      (_currentStep == 3 && (v == null || v.trim().isEmpty))
                          ? 'Required'
                          : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _pincodeC,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: const InputDecoration(
              labelText: 'PIN Code *',
              prefixIcon: Icon(Icons.local_post_office_outlined),
            ),
            validator: (v) {
              if (_currentStep != 3) return null;
              if (v == null || v.length != 6) return 'Enter 6-digit PIN code.';
              return null;
            },
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.verified,
  });

  final IconData icon;
  final String label;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: RumenoTheme.textGrey),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: RumenoTheme.textDark,
          ),
        ),
        const SizedBox(width: 6),
        if (verified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: RumenoTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: RumenoTheme.successGreen.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: RumenoTheme.successGreen, size: 12),
                SizedBox(width: 4),
                Text('Verified',
                    style: TextStyle(
                        fontSize: 11,
                        color: RumenoTheme.successGreen,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }
}

class _DocUploadTile extends StatelessWidget {
  const _DocUploadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.fileName,
    required this.onUpload,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final _DocUploadStatus status;
  final String? fileName;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final uploaded = status == _DocUploadStatus.uploaded;
    final uploading = status == _DocUploadStatus.uploading;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: uploaded
              ? RumenoTheme.successGreen.withValues(alpha: 0.5)
              : RumenoTheme.textLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: uploaded
                  ? RumenoTheme.successGreen.withValues(alpha: 0.1)
                  : RumenoTheme.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              uploaded ? Icons.check_circle_rounded : icon,
              color: uploaded
                  ? RumenoTheme.successGreen
                  : RumenoTheme.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  uploaded ? (fileName ?? 'Uploaded') : subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: uploaded
                        ? RumenoTheme.successGreen
                        : RumenoTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (uploading)
            const SizedBox(
                width: 24, height: 24, child: CircularProgressIndicator())
          else if (uploaded)
            TextButton(
              onPressed: onUpload,
              child: const Text('Replace'),
            )
          else
            ElevatedButton.icon(
              onPressed: onUpload,
              icon: const Icon(Icons.upload_file_rounded, size: 16),
              label: const Text('Upload'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
