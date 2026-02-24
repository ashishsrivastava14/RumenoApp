import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  int _resendTimer = 30;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Pre-fill mock OTP
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controllers[0].text = '1';
        _controllers[1].text = '2';
        _controllers[2].text = '3';
        _controllers[3].text = '4';
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp == '1234') {
      setState(() => _isVerifying = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        final auth = context.read<AuthProvider>();
        final role = auth.selectedRole ?? UserRole.farmer;
        auth.login('9876543210', role);

        switch (role) {
          case UserRole.farmer:
            context.go('/farmer/dashboard');
            break;
          case UserRole.vet:
            context.go('/vet/dashboard');
            break;
          case UserRole.admin:
            context.go('/admin/dashboard');
            break;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Use 1234'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify OTP', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'Enter the 4-digit code sent to your phone',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (i) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < 3) {
                          _focusNodes[i + 1].requestFocus();
                        }
                        if (value.isEmpty && i > 0) {
                          _focusNodes[i - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Resend
              Center(
                child: _resendTimer > 0
                    ? Text(
                        'Resend OTP in ${_resendTimer}s',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : TextButton(
                        onPressed: () {
                          _startTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP resent: 1234 (mock)')),
                          );
                        },
                        child: const Text('Resend OTP'),
                      ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyOtp,
                  child: _isVerifying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Verify & Login'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: RumenoTheme.warningYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Mock OTP: 1234',
                    style: TextStyle(
                      color: RumenoTheme.warmBrown,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
