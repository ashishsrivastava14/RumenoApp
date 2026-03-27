import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';

/// Post-login role picker.
/// Shown only when the logged-in user has multiple roles.
/// If the user is NOT logged in, redirects to /login.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    // If not authenticated, redirect to login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (!auth.isAuthenticated) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    final auth = context.read<AuthProvider>();
    auth.selectRole(role);
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
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final roles = auth.roles;
    final l10n = AppLocalizations.of(context);

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
              RumenoTheme.primaryGreen.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/animals_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      RumenoTheme.primaryGreen.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                      RumenoTheme.primaryGreen.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Logo
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/Rumeno_logo-rb.png',
                              width: 180,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Greeting
                          if (auth.currentUser != null)
                            Text(
                              'Hi, ${auth.currentUser!.name}!',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.authSelectRolePrompt,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 32),
                          // Role cards – only the roles this user has
                          ...roles.map((role) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _RoleCard(
                              emoji: _emojiFor(role),
                              title: _titleFor(role, l10n),
                              subtitle: _subtitleFor(role, l10n),
                              gradient: _gradientFor(role),
                              onTap: () => _selectRole(role),
                            ),
                          )),
                          const SizedBox(height: 16),
                          // Logout link
                          TextButton.icon(
                            onPressed: () {
                              auth.logout();
                              context.go('/shop');
                            },
                            icon: const Icon(Icons.logout, size: 18),
                            label: const Text('Sign Out'),
                            style: TextButton.styleFrom(foregroundColor: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _emojiFor(UserRole role) {
    switch (role) {
      case UserRole.farmer: return '🐄';
      case UserRole.vet:    return '🩺';
      case UserRole.admin:  return '🔧';
    }
  }

  String _titleFor(UserRole role, AppLocalizations l10n) {
    switch (role) {
      case UserRole.farmer: return l10n.authRoleFarmOwner;
      case UserRole.vet:    return l10n.authRoleVet;
      case UserRole.admin:  return l10n.authRoleSuperAdmin;
    }
  }

  String _subtitleFor(UserRole role, AppLocalizations l10n) {
    switch (role) {
      case UserRole.farmer: return l10n.authRoleFarmOwnerSubtitle;
      case UserRole.vet:    return l10n.authRoleVetSubtitle;
      case UserRole.admin:  return l10n.authRoleSuperAdminSubtitle;
    }
  }

  LinearGradient _gradientFor(UserRole role) {
    switch (role) {
      case UserRole.farmer:
        return LinearGradient(colors: [
          RumenoTheme.primaryGreen.withValues(alpha: 0.1),
          RumenoTheme.primaryGreen.withValues(alpha: 0.05),
        ]);
      case UserRole.vet:
        return LinearGradient(colors: [
          Colors.blue.withValues(alpha: 0.1),
          Colors.blue.withValues(alpha: 0.05),
        ]);
      case UserRole.admin:
        return LinearGradient(colors: [
          Colors.orange.withValues(alpha: 0.1),
          Colors.orange.withValues(alpha: 0.05),
        ]);
    }
  }
}

/// A tappable role card with press animation.
class _RoleCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isPressed ? 0.08 : 0.12),
                    blurRadius: _isPressed ? 12 : 20,
                    offset: Offset(0, _isPressed ? 4 : 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(gradient: widget.gradient),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: widget.gradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(widget.emoji, style: const TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            _isPressed ? 4 : 0, 0, 0,
                          ),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: widget.gradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
