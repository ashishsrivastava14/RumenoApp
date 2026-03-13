import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/models.dart';
import '../../../providers/ecommerce_provider.dart';

class AdminVendorsScreen extends StatelessWidget {
  const AdminVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ecommerce = context.watch<EcommerceProvider>();
    final vendors = ecommerce.vendors;
    final pendingCount = ecommerce.pendingVendors.length;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Vendor Management'),
        actions: [
          if (pendingCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: RumenoTheme.warningYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text('$pendingCount Pending', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return _VendorCard(vendor: vendor);
        },
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final Vendor vendor;
  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (vendor.status) {
      case VendorStatus.approved:
        statusColor = RumenoTheme.successGreen;
        break;
      case VendorStatus.pending:
        statusColor = RumenoTheme.warningYellow;
        break;
      case VendorStatus.rejected:
        statusColor = RumenoTheme.errorRed;
        break;
      case VendorStatus.suspended:
        statusColor = RumenoTheme.textGrey;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: RumenoTheme.primaryGreen.withValues(alpha: 0.1),
                  child: Text(vendor.businessName[0], style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.businessName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Owner: ${vendor.ownerName}', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(vendor.statusLabel, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                _stat('Products', '${vendor.totalProducts}'),
                _stat('Orders', '${vendor.totalOrders}'),
                _stat('Commission', '${vendor.commissionPercent.toStringAsFixed(0)}%'),
                _stat('Earnings', '₹${(vendor.totalEarnings / 1000).toStringAsFixed(0)}K'),
              ],
            ),
            if (vendor.status == VendorStatus.pending) ...[
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RumenoTheme.errorRed,
                      side: const BorderSide(color: RumenoTheme.errorRed),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Approve'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 10)),
        ],
      ),
    );
  }
}
