import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _cardAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.2 + (index * 0.1),
            0.5 + (index * 0.1),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Animated background pattern
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
            // Main content
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
                          // Logo with shadow
                          Transform.scale(
                            scale: 0.8 + (_fadeAnimation.value * 0.2),
                            child: Container(
                              width: 220,
                              height: 220,
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
                                'assets/images/Rumeno_logo.png',
                                width: 220,
                                height: 220,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Welcome text with gradient
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                RumenoTheme.primaryGreen,
                                RumenoTheme.primaryGreen.withValues(alpha: 0.8),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Welcome to Rumeno',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Select your role to get started',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 10),
                          // Animated Role Cards
                          _buildAnimatedCard(
                            index: 0,
                            emoji: '🐄',
                            title: 'Farm Owner / Staff',
                            subtitle: 'Manage your farm, animals, and operations',
                            gradient: LinearGradient(
                              colors: [
                                RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                                RumenoTheme.primaryGreen.withValues(alpha: 0.05),
                              ],
                            ),
                            onTap: () {
                              context.read<AuthProvider>().selectRole(UserRole.farmer);
                              context.go('/login');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildAnimatedCard(
                            index: 1,
                            emoji: '🩺',
                            title: 'Veterinarian / Partner',
                            subtitle: 'Manage consultations and earn commissions',
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: 0.1),
                                Colors.blue.withValues(alpha: 0.05),
                              ],
                            ),
                            onTap: () {
                              context.read<AuthProvider>().selectRole(UserRole.vet);
                              context.go('/login');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildAnimatedCard(
                            index: 2,
                            emoji: '🔧',
                            title: 'Super Admin',
                            subtitle: 'Manage platform, users, and configurations',
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withValues(alpha: 0.1),
                                Colors.orange.withValues(alpha: 0.05),
                              ],
                            ),
                            onTap: () {
                              context.read<AuthProvider>().selectRole(UserRole.admin);
                              context.go('/login');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildAnimatedCard(
                            index: 3,
                            emoji: '🛒',
                            title: 'Farm Products',
                            subtitle: 'Browse and purchase farm products',
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.withValues(alpha: 0.1),
                                Colors.purple.withValues(alpha: 0.05),
                              ],
                            ),
                            onTap: () {
                              context.read<AuthProvider>()
                                  .selectRole(UserRole.farmProducts);
                              context.go('/login');
                            },
                          ),
                          const SizedBox(height: 24),
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

  Widget _buildAnimatedCard({
    required int index,
    required String emoji,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Transform.translate(
      offset: Offset(0, 50 * (1 - _cardAnimations[index].value)),
      child: Opacity(
        opacity: _cardAnimations[index].value,
        child: _ModernRoleCard(
          emoji: emoji,
          title: title,
          subtitle: subtitle,
          gradient: gradient,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _ModernRoleCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ModernRoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_ModernRoleCard> createState() => _ModernRoleCardState();
}

class _ModernRoleCardState extends State<_ModernRoleCard>
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
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                  ),
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
                        // Emoji container with gradient background
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
                            child: Text(
                              widget.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
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
                        // Animated arrow
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            _isPressed ? 4 : 0,
                            0,
                            0,
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
