import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class FarmProfileScreen extends StatelessWidget {
  const FarmProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(title: const Text('Farm Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.15),
                  child: Icon(Icons.agriculture, size: 50, color: RumenoTheme.primaryGreen),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: RumenoTheme.primaryGreen,
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(initialValue: 'Patel Dairy Farm', decoration: const InputDecoration(labelText: 'Farm Name')),
          const SizedBox(height: 12),
          TextFormField(initialValue: 'Rajesh Patel', decoration: const InputDecoration(labelText: 'Owner Name')),
          const SizedBox(height: 12),
          TextFormField(initialValue: 'Village Vadgam, Taluka Palanpur, Gujarat', decoration: const InputDecoration(labelText: 'Address'), maxLines: 2),
          const SizedBox(height: 12),
          TextFormField(initialValue: '23.0225° N, 72.5714° E', decoration: const InputDecoration(labelText: 'GPS Location', suffixIcon: Icon(Icons.my_location))),
          const SizedBox(height: 12),
          TextFormField(initialValue: 'Suresh Patel', decoration: const InputDecoration(labelText: 'Manager Name')),
          const SizedBox(height: 12),
          TextFormField(initialValue: 'Dr. Anita Sharma - 9876543211', decoration: const InputDecoration(labelText: 'Veterinarian Contact')),
          const SizedBox(height: 12),
          TextFormField(decoration: const InputDecoration(labelText: 'YouTube Channel URL')),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!'), backgroundColor: Colors.green));
              Navigator.pop(context);
            },
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }
}
