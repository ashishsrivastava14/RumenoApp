import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  String _audience = 'All Users';
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final history = admin.notifications;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Push Notifications')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compose section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Send Notification', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _audience,
                    decoration: const InputDecoration(labelText: 'Audience'),
                    items: ['All Users', 'All Farmers', 'All Vets', 'Free Plan', 'Starter Plan', 'Pro & Business']
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                    onChanged: (v) => setState(() => _audience = v!),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                  const SizedBox(height: 10),
                  TextField(controller: _bodyCtrl, decoration: const InputDecoration(labelText: 'Message'), maxLines: 3),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_titleCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill title and message'), backgroundColor: Colors.orange));
                          return;
                        }
                        admin.sendNotification(
                          title: _titleCtrl.text.trim(),
                          body: _bodyCtrl.text.trim(),
                          audience: _audience,
                        );
                        _titleCtrl.clear();
                        _bodyCtrl.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification sent!'), backgroundColor: Colors.green));
                      },
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // History
            Text('History (${history.length})', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (history.isEmpty)
              Center(child: Text('No notifications sent yet', style: TextStyle(color: Colors.grey[500]))),
            ...history.map((n) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(n.title, style: Theme.of(context).textTheme.titleSmall)),
                      Text(DateFormat('dd MMM yyyy').format(n.sentAt), style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(n.body, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: RumenoTheme.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(n.audience, style: TextStyle(fontSize: 10, color: RumenoTheme.primaryGreen)),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.group, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('${n.reach} reached', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
