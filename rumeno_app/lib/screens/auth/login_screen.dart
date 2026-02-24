import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  bool _otpSent = false;

  String _roleName(UserRole? role) {
    switch (role) {
      case UserRole.farmer:
        return 'Farm Owner';
      case UserRole.vet:
        return 'Veterinarian';
      case UserRole.admin:
        return 'Super Admin';
      case UserRole.farmProducts:
        return 'Farm Products';
      case null:
        return '';
    }
  }

  String _roleEmoji(UserRole? role) {
    switch (role) {
      case UserRole.farmer:
        return '🌾';
      case UserRole.vet:
        return '🩺';
      case UserRole.admin:
        return '🔧';
      case UserRole.farmProducts:
        return '🛒';
      case null:
        return '';
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().selectedRole;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.go('/role-selection'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Role badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_roleEmoji(role), style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      _roleName(role),
                      style: TextStyle(
                        color: RumenoTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Login', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Enter your phone number to continue',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              // Phone field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+91 ',
                  prefixIcon: const Icon(Icons.phone_android),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              if (!_otpSent)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_phoneController.text.length == 10) {
                        setState(() => _otpSent = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP sent: 1234 (mock)')),
                        );
                      }
                    },
                    child: const Text('Send OTP'),
                  ),
                ),
              if (_otpSent) ...[
                Text(
                  'Enter the OTP sent to +91 ${_phoneController.text}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                // Navigate to OTP screen
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/otp');
                    },
                    child: const Text('Enter OTP'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
