import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _maintenanceMode = false;
  bool _newSignups = true;
  bool _emailNotifications = true;
  bool _smsEnabled = true;
  String _defaultLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('App Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'General', [
            _settingTile('App Name', subtitle: 'Rumeno', icon: Icons.apps_rounded, onTap: () {}),
            _settingTile('Default Language', subtitle: _defaultLanguage, icon: Icons.language_rounded, onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Select Language'),
                  children: ['English', 'Hindi', 'Gujarati', 'Marathi', 'Tamil']
                      .map((l) => SimpleDialogOption(onPressed: () { setState(() => _defaultLanguage = l); Navigator.pop(ctx); }, child: Text(l)))
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
              value: _newSignups,
              onChanged: (v) => setState(() => _newSignups = v),
              secondary: Icon(Icons.person_add_rounded, color: RumenoTheme.primaryGreen),
            ),
            SwitchListTile(
              title: const Text('Maintenance Mode', style: TextStyle(fontSize: 14)),
              subtitle: const Text('Show maintenance screen to users'),
              value: _maintenanceMode,
              onChanged: (v) => setState(() => _maintenanceMode = v),
              secondary: Icon(Icons.build_rounded, color: _maintenanceMode ? Colors.orange : RumenoTheme.primaryGreen),
            ),
          ]),
          const SizedBox(height: 16),

          _section(context, 'Notifications', [
            SwitchListTile(
              title: const Text('Email Notifications', style: TextStyle(fontSize: 14)),
              value: _emailNotifications,
              onChanged: (v) => setState(() => _emailNotifications = v),
              secondary: Icon(Icons.email_rounded, color: RumenoTheme.primaryGreen),
            ),
            SwitchListTile(
              title: const Text('SMS Enabled', style: TextStyle(fontSize: 14)),
              value: _smsEnabled,
              onChanged: (v) => setState(() => _smsEnabled = v),
              secondary: Icon(Icons.sms_rounded, color: RumenoTheme.primaryGreen),
            ),
          ]),
          const SizedBox(height: 16),

          _section(context, 'Data', [
            _settingTile('Backup Database', icon: Icons.backup_rounded, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup initiated...'), backgroundColor: Colors.green));
            }),
            _settingTile('Export All Data', icon: Icons.download_rounded, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting data...')));
            }),
            _settingTile('Clear Cache', icon: Icons.delete_sweep_rounded, onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared!')));
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
}
