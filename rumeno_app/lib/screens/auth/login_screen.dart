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
        return '🐄';
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              RumenoTheme.backgroundCream,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animal background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/animals_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom App Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                          onPressed: () => context.go('/role-selection'),
                        ),
                      ],
                    ),
                  ),
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Logo
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                'assets/images/Rumeno_logo.png',
                                width: 240,
                                height: 240,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Role badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: RumenoTheme.primaryGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: RumenoTheme.primaryGreen.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_roleEmoji(role), style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Text(
                                  _roleName(role),
                                  style: TextStyle(
                                    color: RumenoTheme.primaryGreen,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Welcome text
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your phone number to continue',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Phone field card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    prefixText: '+91 ',
                                    prefixIcon: Icon(Icons.phone_android, color: RumenoTheme.primaryGreen),
                                    counterText: '',
                                    filled: true,
                                    fillColor: RumenoTheme.backgroundCream.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (!_otpSent)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_phoneController.text.length == 10) {
                                          setState(() => _otpSent = true);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('OTP sent: 1234 (mock)')),
                                          );
                                        }
                                      },
                                      child: const Text('Send OTP', style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                if (_otpSent) ...[
                                  Text(
                                    'Enter the OTP sent to +91 ${_phoneController.text}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.go('/otp');
                                      },
                                      child: const Text('Enter OTP', style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
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
