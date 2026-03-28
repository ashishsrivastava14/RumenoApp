import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final s = admin.settings;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('App Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'General', [
            _settingTile('App Name', subtitle: 'Rumeno', icon: Icons.apps_rounded),
            _settingTile('Default Language', subtitle: s.defaultLanguage, icon: Icons.language_rounded, onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Select Language'),
                  children: ['English', 'Hindi', 'Gujarati', 'Marathi', 'Tamil']
                      .map((l) => SimpleDialogOption(
                            onPressed: () {
                              context.read<AdminProvider>().updateSettings(defaultLanguage: l);
                              Navigator.pop(ctx);
                            },
                            child: Text(l),
                          ))
                      .toList(),
                ),
              );
            }),
            _settingTile('App Version', subtitle: '2.1.0 (Build 45)', icon: Icons.info_outline_rounded),
          ]),
          const SizedBox(height: 16),

          _section(context, 'Access Control', [
            SwitchListTile(
              title: const Text('Allow New Sign-ups', style: TextStyle(fontSize: 14)),
              subtitle: const Text('Users can register new accounts'),
              value: s.allowNewSignups,
              onChanged: (v) => context.read<AdminProvider>().updateSettings(allowNewSignups: v),
              secondary: Icon(Icons.person_add_rounded, color: RumenoTheme.primaryGreen),
            ),
            SwitchListTile(
              title: const Text('Maintenance Mode', style: TextStyle(fontSize: 14)),
              subtitle: const Text('Show maintenance screen to users'),
              value: s.maintenanceMode,
              onChanged: (v) => context.read<AdminProvider>().updateSettings(maintenanceMode: v),
              secondary: Icon(Icons.build_rounded, color: s.maintenanceMode ? Colors.orange : RumenoTheme.primaryGreen),
            ),
          ]),
          const SizedBox(height: 16),

          _section(context, 'Notifications', [
            SwitchListTile(
              title: const Text('Email Notifications', style: TextStyle(fontSize: 14)),
              value: s.emailNotifications,
              onChanged: (v) => context.read<AdminProvider>().updateSettings(emailNotifications: v),
              secondary: Icon(Icons.email_rounded, color: RumenoTheme.primaryGreen),
            ),
            SwitchListTile(
              title: const Text('SMS Enabled', style: TextStyle(fontSize: 14)),
              value: s.smsEnabled,
              onChanged: (v) => context.read<AdminProvider>().updateSettings(smsEnabled: v),
              secondary: Icon(Icons.sms_rounded, color: RumenoTheme.primaryGreen),
            ),
          ]),
          const SizedBox(height: 16),

          _section(context, 'AI Feed Mix Limits', [
            _aiLimitTile(context, 'Free', '🌱', s.aiMixLimitFree, (v) {
              context.read<AdminProvider>().updateSettings(aiMixLimitFree: v);
            }),
            _aiLimitTile(context, 'Starter', '⭐', s.aiMixLimitStarter, (v) {
              context.read<AdminProvider>().updateSettings(aiMixLimitStarter: v);
            }),
            _aiLimitTile(context, 'Pro', '🏆', s.aiMixLimitPro, (v) {
              context.read<AdminProvider>().updateSettings(aiMixLimitPro: v);
            }),
            _aiLimitTile(context, 'Business', '💎', s.aiMixLimitBusiness, (v) {
              context.read<AdminProvider>().updateSettings(aiMixLimitBusiness: v);
            }),
          ]),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _settingTile(String title, {String? subtitle, IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: RumenoTheme.primaryGreen) : null,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right_rounded, size: 20) : null,
      onTap: onTap,
    );
  }

  Widget _aiLimitTile(BuildContext context, String planName, String emoji, int currentLimit, ValueChanged<int> onChanged) {
    final isUnlimited = currentLimit < 0;
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 22)),
      title: Text('$planName Plan', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(isUnlimited ? 'Unlimited' : '$currentLimit uses/month'),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => onChanged(currentLimit <= 0 ? -1 : currentLimit - 1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.remove, size: 18),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  isUnlimited ? '∞' : '$currentLimit',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            InkWell(
              onTap: () => onChanged(isUnlimited ? 1 : currentLimit + 1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.add, size: 18, color: RumenoTheme.primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
