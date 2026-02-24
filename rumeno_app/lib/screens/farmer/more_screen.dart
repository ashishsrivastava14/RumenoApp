import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('More'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.15),
                  child: Text('RP', style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rajesh Patel', style: Theme.of(context).textTheme.titleMedium),
                      Text('Patel Dairy Farm', style: Theme.of(context).textTheme.bodySmall),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: RumenoTheme.planPro.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: Text('Pro Plan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: RumenoTheme.planPro)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.edit, color: RumenoTheme.primaryGreen),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MenuItem(icon: Icons.business, title: 'Farm Profile', subtitle: 'Edit farm details, logo, GPS', onTap: () => context.go('/farmer/more/profile')),
          _MenuItem(icon: Icons.people, title: 'Team Members', subtitle: 'Manage staff and roles', onTap: () => context.go('/farmer/more/team')),
          _MenuItem(icon: Icons.card_membership, title: 'Subscription Plan', subtitle: 'Pro Plan - Active', onTap: () => context.go('/farmer/more/subscription')),
          _MenuItem(icon: Icons.notifications, title: 'Notification Settings', subtitle: 'Configure alerts', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification settings')))),
          _MenuItem(icon: Icons.language, title: 'Language', subtitle: 'English', onTap: () => _showLanguageDialog(context)),
          _MenuItem(icon: Icons.download, title: 'Data Export', subtitle: 'Export your farm data', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data export (mock)')))),
          _MenuItem(icon: Icons.help_outline, title: 'Help & Support', subtitle: 'FAQs and contact', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help & Support')))),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            isDestructive: true,
            onTap: () {
              context.read<AuthProvider>().logout();
              context.go('/role-selection');
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Language'),
        children: ['English', 'Hindi (हिन्दी)', 'Gujarati (ગુજરાતી)', 'Marathi (मराठी)', 'Punjabi (ਪੰਜਾਬੀ)']
            .map((l) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language set to $l (mock)')));
                  },
                  child: Text(l),
                ))
            .toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({required this.icon, required this.title, required this.subtitle, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? RumenoTheme.errorRed : RumenoTheme.primaryGreen),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isDestructive ? RumenoTheme.errorRed : null)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
