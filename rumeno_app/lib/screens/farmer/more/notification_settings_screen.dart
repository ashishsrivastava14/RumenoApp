import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/marketplace_button.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _vaccinationAlerts = true;
  bool _healthAlerts = true;
  bool _breedingAlerts = true;
  bool _financeAlerts = false;
  bool _milkReminders = true;
  bool _feedReminders = true;
  bool _smsAlerts = false;
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        actions: const [VeterinarianButton(), MarketplaceButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text('🔔', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Choose what alerts you want',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Animal Health Alerts
            _SectionTitle(emoji: '🐄', title: 'Animal Alerts'),
            const SizedBox(height: 10),
            _ToggleTile(
              emoji: '💉',
              title: 'Vaccination Due',
              subtitle: 'When vaccination is due',
              value: _vaccinationAlerts,
              activeColor: const Color(0xFF4CAF50),
              onChanged: (v) => setState(() => _vaccinationAlerts = v),
            ),
            _ToggleTile(
              emoji: '🩺',
              title: 'Health Alerts',
              subtitle: 'When animal is sick',
              value: _healthAlerts,
              activeColor: const Color(0xFFE53935),
              onChanged: (v) => setState(() => _healthAlerts = v),
            ),
            _ToggleTile(
              emoji: '🐣',
              title: 'Breeding Alerts',
              subtitle: 'Heat & pregnancy updates',
              value: _breedingAlerts,
              activeColor: const Color(0xFFFF9800),
              onChanged: (v) => setState(() => _breedingAlerts = v),
            ),
            _ToggleTile(
              emoji: '💰',
              title: 'Money Alerts',
              subtitle: 'Payment & expense reminders',
              value: _financeAlerts,
              activeColor: const Color(0xFF2196F3),
              onChanged: (v) => setState(() => _financeAlerts = v),
            ),

            const SizedBox(height: 20),

            // Daily Reminders
            _SectionTitle(emoji: '⏰', title: 'Daily Reminders'),
            const SizedBox(height: 10),
            _ToggleTile(
              emoji: '🥛',
              title: 'Milking Time',
              subtitle: 'Morning & evening reminder',
              value: _milkReminders,
              activeColor: const Color(0xFF00BCD4),
              onChanged: (v) => setState(() => _milkReminders = v),
            ),
            _ToggleTile(
              emoji: '🌾',
              title: 'Feeding Time',
              subtitle: 'Feed your animals',
              value: _feedReminders,
              activeColor: const Color(0xFF795548),
              onChanged: (v) => setState(() => _feedReminders = v),
            ),

            const SizedBox(height: 20),

            // Delivery Settings
            _SectionTitle(emoji: '📱', title: 'How to Alert'),
            const SizedBox(height: 10),
            _ToggleTile(
              emoji: '📩',
              title: 'SMS Messages',
              subtitle: 'Get alerts via SMS',
              value: _smsAlerts,
              activeColor: const Color(0xFF9C27B0),
              onChanged: (v) => setState(() => _smsAlerts = v),
            ),
            _ToggleTile(
              emoji: '🔊',
              title: 'Sound',
              subtitle: 'Play alert sound',
              value: _soundEnabled,
              activeColor: const Color(0xFF607D8B),
              onChanged: (v) => setState(() => _soundEnabled = v),
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Notification settings saved!'),
                      backgroundColor: RumenoTheme.successGreen,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save_rounded, size: 24),
                label: const Text('Save Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RumenoTheme.primaryGreen,
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

class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionTitle({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: RumenoTheme.textDark)),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: value ? activeColor.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? activeColor.withValues(alpha: 0.3) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: activeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: RumenoTheme.textDark)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: activeColor.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected) ? activeColor : null;
            }),
          ),
        ],
      ),
    );
  }
}
