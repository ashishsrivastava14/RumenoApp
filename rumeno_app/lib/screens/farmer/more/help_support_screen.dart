import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/common/marketplace_button.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitEnquiry() {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
      _descriptionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Enquiry submitted! We will get back to you shortly.'),
          backgroundColor: RumenoTheme.successGreen,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _submitted = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Help & Support'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF607D8B), Color(0xFF455A64)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('❓', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 10),
                  const Text(
                    'How can we help?',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fill in the form below and we\'ll get back to you',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Enquiry form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('✉️', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          'Send an Enquiry',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: RumenoTheme.textDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Name field (readonly)
                    _buildReadonlyField(
                      label: 'Name',
                      value: user?.name ?? '',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 14),

                    // Phone field (readonly)
                    _buildReadonlyField(
                      label: 'Phone',
                      value: user?.phone ?? '',
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 14),

                    // Description field
                    Text(
                      'Description',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RumenoTheme.textGrey),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Describe your issue or question...',
                        hintStyle: TextStyle(color: RumenoTheme.textGrey.withValues(alpha: 0.6), fontSize: 14),
                        filled: true,
                        fillColor: RumenoTheme.backgroundCream,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: RumenoTheme.primaryGreen, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please describe your issue';
                        if (v.trim().length < 10) return 'Please provide more details (min 10 characters)';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitted ? null : _submitEnquiry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RumenoTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text('Submit Enquiry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // FAQ section
            Row(
              children: [
                const Text('📋', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text('Common Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RumenoTheme.textDark)),
              ],
            ),
            const SizedBox(height: 12),

            _FaqCard(
              emoji: '🐄',
              question: 'How to add an animal?',
              answer: 'Go to Animals tab → Tap the + button → Follow the 4 steps to add your animal.',
            ),
            _FaqCard(
              emoji: '💉',
              question: 'How to track vaccination?',
              answer: 'Go to Health tab → Tap Vaccination → Add new vaccination record for your animal.',
            ),
            _FaqCard(
              emoji: '💰',
              question: 'How to add expenses?',
              answer: 'Go to Finance tab → Tap + button → Select category → Enter amount → Save.',
            ),
            _FaqCard(
              emoji: '👥',
              question: 'How to add team members?',
              answer: 'Go to More → My Team → Tap Add Worker → Fill name, phone, and role.',
            ),
            _FaqCard(
              emoji: '📊',
              question: 'How to see reports?',
              answer: 'Go to Finance tab → Tap Reports → Select date range to see your farm reports.',
            ),
            _FaqCard(
              emoji: '🌐',
              question: 'How to change language?',
              answer: 'Go to More → Language → Select your preferred language.',
            ),

            const SizedBox(height: 24),

            // Video tutorials
            Row(
              children: [
                const Text('🎬', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text('Video Tutorials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RumenoTheme.textDark)),
              ],
            ),
            const SizedBox(height: 12),

            _VideoTile(
              emoji: '▶️',
              title: 'Getting started with Rumeno',
              duration: '5 min',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎬 Opening video tutorial...'), backgroundColor: RumenoTheme.primaryGreen),
                );
              },
            ),
            _VideoTile(
              emoji: '▶️',
              title: 'Managing your animals',
              duration: '3 min',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎬 Opening video tutorial...'), backgroundColor: RumenoTheme.primaryGreen),
                );
              },
            ),
            _VideoTile(
              emoji: '▶️',
              title: 'Track health & vaccination',
              duration: '4 min',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎬 Opening video tutorial...'), backgroundColor: RumenoTheme.primaryGreen),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReadonlyField({required String label, required String value, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RumenoTheme.textGrey),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: RumenoTheme.textGrey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 15, color: RumenoTheme.textDark.withValues(alpha: 0.8)),
                ),
              ),
              Icon(Icons.lock_outline_rounded, size: 15, color: RumenoTheme.textGrey.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqCard extends StatefulWidget {
  final String emoji;
  final String question;
  final String answer;

  const _FaqCard({
    required this.emoji,
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _expanded ? RumenoTheme.primaryGreen.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _expanded ? RumenoTheme.primaryGreen.withValues(alpha: 0.3) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _expanded ? RumenoTheme.primaryGreen : RumenoTheme.textDark,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.expand_more,
                    color: _expanded ? RumenoTheme.primaryGreen : RumenoTheme.textGrey,
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.answer,
                  style: const TextStyle(fontSize: 14, color: RumenoTheme.textDark, height: 1.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String duration;
  final VoidCallback onTap;

  const _VideoTile({
    required this.emoji,
    required this.title,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: RumenoTheme.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: RumenoTheme.textGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(duration, style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
            ),
          ],
        ),
      ),
    );
  }
}
