import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/marketplace_button.dart';

class FarmProfileScreen extends StatefulWidget {
  const FarmProfileScreen({super.key});

  @override
  State<FarmProfileScreen> createState() => _FarmProfileScreenState();
}

class _FarmProfileScreenState extends State<FarmProfileScreen> {
  final _farmNameCtrl = TextEditingController(text: 'Patel Dairy Farm');
  final _ownerNameCtrl = TextEditingController(text: 'Rajesh Patel');
  final _addressCtrl = TextEditingController(text: 'Village Vadgam, Taluka Palanpur, Gujarat');
  final _gpsCtrl = TextEditingController(text: '23.0225° N, 72.5714° E');
  final _managerCtrl = TextEditingController(text: 'Suresh Patel');
  final _vetCtrl = TextEditingController(text: 'Dr. Anita Sharma - 9876543211');
  final _youtubeCtrl = TextEditingController();
  bool _saved = false;

  @override
  void dispose() {
    _farmNameCtrl.dispose();
    _ownerNameCtrl.dispose();
    _addressCtrl.dispose();
    _gpsCtrl.dispose();
    _managerCtrl.dispose();
    _vetCtrl.dispose();
    _youtubeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('My Farm'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Farm photo
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📸 Camera opening...'), backgroundColor: RumenoTheme.primaryGreen),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                      RumenoTheme.primaryGreen.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3), width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: RumenoTheme.primaryGreen.withValues(alpha: 0.15),
                      ),
                      child: const Center(child: Text('🏡', style: TextStyle(fontSize: 48))),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: RumenoTheme.primaryGreen, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Tap to add farm photo',
                          style: TextStyle(
                            color: RumenoTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form fields with visual icons
            _VisualField(
              emoji: '🏡',
              label: 'Farm Name',
              hint: 'Type your farm name',
              controller: _farmNameCtrl,
              icon: Icons.agriculture,
            ),
            _VisualField(
              emoji: '👨‍🌾',
              label: 'Owner Name',
              hint: 'Your full name',
              controller: _ownerNameCtrl,
              icon: Icons.person,
            ),
            _VisualField(
              emoji: '📍',
              label: 'Address',
              hint: 'Village, Taluka, District',
              controller: _addressCtrl,
              icon: Icons.location_on,
              maxLines: 2,
            ),
            _VisualField(
              emoji: '🛰️',
              label: 'GPS Location',
              hint: 'Tap to get location',
              controller: _gpsCtrl,
              icon: Icons.my_location,
              suffixWidget: GestureDetector(
                onTap: () {
                  setState(() => _gpsCtrl.text = '23.0225° N, 72.5714° E');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📍 Location captured!'),
                      backgroundColor: RumenoTheme.successGreen,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: RumenoTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.my_location, color: Colors.white, size: 22),
                ),
              ),
            ),
            _VisualField(
              emoji: '👷',
              label: 'Manager Name',
              hint: 'Farm manager name',
              controller: _managerCtrl,
              icon: Icons.engineering,
            ),
            _VisualField(
              emoji: '🩺',
              label: 'Veterinarian',
              hint: 'Doctor name & phone',
              controller: _vetCtrl,
              icon: Icons.local_hospital,
              keyboardType: TextInputType.text,
            ),
            _VisualField(
              emoji: '📺',
              label: 'YouTube Channel',
              hint: 'Your channel URL (optional)',
              controller: _youtubeCtrl,
              icon: Icons.play_circle,
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _saved = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text('✅ Profile saved successfully!', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Future.delayed(const Duration(seconds: 1), () {
                    if (context.mounted) Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.save_rounded, size: 26),
                label: const Text('Save Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _saved ? RumenoTheme.successGreen : RumenoTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _VisualField extends StatelessWidget {
  final String emoji;
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? suffixWidget;

  const _VisualField({
    required this.emoji,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: RumenoTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: RumenoTheme.textLight),
                    prefixIcon: Icon(icon, color: RumenoTheme.primaryGreen),
                    filled: true,
                    fillColor: RumenoTheme.backgroundCream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                const SizedBox(width: 10),
                suffixWidget!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
