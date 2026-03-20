import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';
import '../../widgets/common/marketplace_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ecommerce = context.watch<EcommerceProvider>();
    final order = ecommerce.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Detail'),
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 26), onPressed: () => context.go('/shop/orders')),
          actions: const [VeterinarianButton(), FarmButton()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 60, color: RumenoTheme.textLight),
              const SizedBox(height: 16),
              Text(l10n.orderDetailNotFound),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.orderDetailTitle(order.id), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, size: 26), onPressed: () => context.go('/shop/orders')),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded),
            tooltip: l10n.orderDetailViewInvoiceTooltip,
            onPressed: () => _showInvoiceSheet(context, order),
          ),
          const VeterinarianButton(),
          const FarmButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Order Status Timeline ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timeline_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text(l10n.orderDetailStatusCardTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _TimelineStep(
                      icon: Icons.receipt_long_rounded,
                      title: l10n.orderDetailTimelinePlaced,
                      subtitle: dateFormat.format(order.orderDate),
                      isCompleted: true,
                      isFirst: true,
                    ),
                    _TimelineStep(
                      icon: Icons.check_circle_rounded,
                      title: l10n.orderDetailTimelineConfirmed,
                      subtitle: order.status.index >= OrderStatus.confirmed.index ? l10n.orderDetailTimelineConfirmedDesc : l10n.orderDetailTimelinePending,
                      isCompleted: order.status.index >= OrderStatus.confirmed.index,
                    ),
                    _TimelineStep(
                      icon: Icons.inventory_2_rounded,
                      title: l10n.orderDetailTimelinePacked,
                      subtitle: order.packedDate != null ? dateFormat.format(order.packedDate!) : l10n.orderDetailTimelinePending,
                      isCompleted: order.status.index >= OrderStatus.packed.index,
                    ),
                    _TimelineStep(
                      icon: Icons.local_shipping_rounded,
                      title: l10n.orderDetailTimelineShipped,
                      subtitle: order.shippedDate != null
                          ? '${dateFormat.format(order.shippedDate!)}\n${l10n.orderDetailTimelineShippedTracking(order.trackingNumber ?? "N/A")}'
                          : l10n.orderDetailTimelinePending,
                      isCompleted: order.status.index >= OrderStatus.shipped.index,
                    ),
                    _TimelineStep(
                      icon: Icons.home_rounded,
                      title: l10n.orderDetailTimelineDelivered,
                      subtitle: order.deliveredDate != null ? dateFormat.format(order.deliveredDate!) : l10n.orderDetailTimelinePending,
                      isCompleted: order.status == OrderStatus.delivered,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Items ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text(l10n.orderDetailItemsLabel(order.items.length), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 20),
                    ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              // Larger image
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item.productImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400, size: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    if (item.productDescription.isNotEmpty) ...[                                     
                                      const SizedBox(height: 2),
                                      Text(
                                        item.productDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text('× ${item.quantity}', style: TextStyle(color: RumenoTheme.primaryGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(l10n.orderDetailEachLabel(item.price.toStringAsFixed(0)), style: TextStyle(color: RumenoTheme.textGrey, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text('₹${item.totalPrice.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RumenoTheme.primaryGreen)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Delivery Address ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text(l10n.orderDetailDeliveryAddress, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.home_rounded, color: RumenoTheme.primaryGreen, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.address.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(order.address.fullAddress, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.phone_rounded, size: 14, color: RumenoTheme.textGrey),
                                  const SizedBox(width: 4),
                                  Text(order.address.phone, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Payment & Price ───
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payments_rounded, color: RumenoTheme.primaryGreen, size: 22),
                        const SizedBox(width: 8),
                        Text(l10n.orderDetailPaymentTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _priceRow(Icons.money_rounded, l10n.orderDetailPaymentMethod, order.paymentMethod),
                    if (order.paymentId != null) _priceRow(Icons.tag_rounded, l10n.orderDetailPaymentId, order.paymentId!),
                    const Divider(height: 20),
                    _priceRow(Icons.shopping_cart_rounded, l10n.orderDetailSubtotal, '₹${order.subtotal.toStringAsFixed(0)}'),
                    if (order.discount > 0)
                      _priceRow(
                        Icons.local_offer_rounded,
                        l10n.orderDetailDiscount,
                        '-₹${order.discount.toStringAsFixed(0)}',
                        valueColor: RumenoTheme.successGreen,
                      ),
                    _priceRow(
                      Icons.local_shipping_rounded,
                      l10n.orderDetailDelivery,
                      order.deliveryCharge == 0 ? 'FREE' : '₹${order.deliveryCharge.toStringAsFixed(0)}',
                      valueColor: order.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
                    ),
                    const Divider(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: RumenoTheme.primaryGreen.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet_rounded, color: RumenoTheme.primaryGreen, size: 22),
                          const SizedBox(width: 8),
                          Text('Total Paid', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const Spacer(),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Tax Invoice Card ───
            _InvoiceSectionCard(order: order),

            const SizedBox(height: 16),

            // Reorder button
            if (order.status == OrderStatus.delivered)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    for (final item in order.items) {
                      final product = ecommerce.getProductById(item.productId);
                      if (product != null && product.inStock) {
                        ecommerce.addToCart(product, quantity: item.quantity);
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.orderDetailItemsAddedToCart),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: RumenoTheme.successGreen,
                      ),
                    );
                    context.go('/shop/cart');
                  },
                  icon: const Icon(Icons.replay_rounded, size: 22),
                  label: Text(l10n.orderDetailReorderButton, style: const TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(color: RumenoTheme.primaryGreen, width: 1.5),
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showInvoiceSheet(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        maxChildSize: 0.97,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long_rounded, size: 22),
                    const SizedBox(width: 8),
                    Text('Tax Invoice', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  child: _InvoiceContent(order: order),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: RumenoTheme.textGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: valueColor)),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 3,
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    ),
                  ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade200,
                    border: Border.all(
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isCompleted ? icon : Icons.circle_outlined,
                    color: isCompleted ? Colors.white : Colors.grey.shade400,
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      color: isCompleted ? RumenoTheme.successGreen : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isCompleted ? RumenoTheme.textDark : RumenoTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? RumenoTheme.textGrey : RumenoTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Invoice Section Card (embedded in detail) ───────────────────────────────

class _InvoiceSectionCard extends StatelessWidget {
  final Order order;
  const _InvoiceSectionCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: RumenoTheme.primaryGreen, size: 22),
                const SizedBox(width: 8),
                Text('Tax Invoice', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(order.invoiceNo, style: TextStyle(color: RumenoTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Invoice meta row
            Row(
              children: [
                _metaItem(Icons.calendar_today_rounded, 'Invoice Date', DateFormat('dd MMM yyyy').format(order.orderDate)),
                const SizedBox(width: 16),
                _metaItem(Icons.payments_rounded, 'Payment', order.paymentMethod),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Tax summary panel
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _summaryRow('Taxable Value (ex-GST)', '₹${order.totalTaxableValue.toStringAsFixed(2)}'),
                  const SizedBox(height: 6),
                  ...order.items.map((item) => item.taxRate > 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            const SizedBox(width: 12),
                            Icon(Icons.subdirectory_arrow_right_rounded, size: 14, color: RumenoTheme.textGrey),
                            const SizedBox(width: 4),
                            Expanded(child: Text('CGST @${(item.taxRate * 50).toStringAsFixed(0)}% + SGST @${(item.taxRate * 50).toStringAsFixed(0)}%  (${item.hsnCode ?? ""})', style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey))),
                            Text('₹${item.cgstAmount.toStringAsFixed(2)} + ₹${item.sgstAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11)),
                          ]),
                        )
                      : const SizedBox.shrink()),
                  const Divider(height: 14),
                  _summaryRow('Total CGST', '₹${order.totalCgst.toStringAsFixed(2)}', bold: false),
                  const SizedBox(height: 4),
                  _summaryRow('Total SGST', '₹${order.totalSgst.toStringAsFixed(2)}', bold: false),
                  const SizedBox(height: 4),
                  _summaryRow('Total Tax', '₹${order.totalTaxAmount.toStringAsFixed(2)}'),
                  if (order.discount > 0) ...[
                    const SizedBox(height: 4),
                    _summaryRow(
                      'Discount${order.couponCode != null ? " (${order.couponCode})" : ""}',
                      '-₹${order.discount.toStringAsFixed(2)}',
                      valueColor: RumenoTheme.successGreen,
                    ),
                  ],
                  const SizedBox(height: 4),
                  _summaryRow(
                    'Delivery',
                    order.deliveryCharge == 0 ? 'FREE' : '₹${order.deliveryCharge.toStringAsFixed(2)}',
                    valueColor: order.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
                  ),
                  const Divider(height: 14),
                  Row(
                    children: [
                      const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const Spacer(),
                      Text('₹${order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RumenoTheme.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Seller GSTIN note
            Row(
              children: [
                Icon(Icons.verified_rounded, size: 14, color: RumenoTheme.primaryGreen),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Sold by: Rumeno Agri Pvt. Ltd.  |  GSTIN: 27AACRR1234A1ZV  |  State: Maharashtra (27)',
                    style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 13, color: RumenoTheme.textLight),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'All prices are GST-inclusive. This is a system-generated invoice.',
                    style: TextStyle(fontSize: 10, color: RumenoTheme.textLight, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String label, String value) => Expanded(
        child: Row(
          children: [
            Icon(icon, size: 14, color: RumenoTheme.textGrey),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: RumenoTheme.textGrey)),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      );

  Widget _summaryRow(String label, String value, {bool bold = true, Color? valueColor}) => Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: bold ? RumenoTheme.textDark : RumenoTheme.textGrey))),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.w500, color: valueColor)),
        ],
      );
}

// ─── Full Invoice Content (used in bottom sheet) ─────────────────────────────

class _InvoiceContent extends StatelessWidget {
  final Order order;
  const _InvoiceContent({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Invoice Header ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TAX INVOICE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: RumenoTheme.primaryGreen, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(order.invoiceNo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('Date: ${dateFormat.format(order.orderDate)}', style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Rumeno Agri Pvt. Ltd.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: RumenoTheme.primaryGreen)),
                Text('GSTIN: 27AACRR1234A1ZV', style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                Text('State: Maharashtra (27)', style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
                Text('Pune, Maharashtra 411001', style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ── Parties: Seller / Buyer ──
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _partyBox(
                context,
                'SOLD BY',
                ['Rumeno Agri Pvt. Ltd.', 'Agri Business Park, Pune', 'Maharashtra – 411001', 'GSTIN: 27AACRR1234A1ZV'],
                isLeft: true,
              ),
              Container(width: 1, height: 90, color: Colors.grey.shade300),
              _partyBox(
                context,
                'SHIP TO',
                [
                  order.address.name,
                  order.address.addressLine1,
                  if (order.address.addressLine2 != null) order.address.addressLine2!,
                  '${order.address.city}, ${order.address.state} – ${order.address.pincode}',
                  'Ph: ${order.address.phone}',
                ],
                isLeft: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Items Table ──
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    const Expanded(flex: 4, child: Text('#  Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const SizedBox(width: 4),
                    const Expanded(flex: 2, child: Text('HSN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 1, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('Rate', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('GST%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  ],
                ),
              ),

              // Item rows
              ...order.items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                final gstPct = (item.taxRate * 100).toStringAsFixed(0);
                return Column(
                  children: [
                    Container(
                      color: i.isEven ? Colors.transparent : Colors.grey.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              '${i + 1}.  ${item.productName}',
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(flex: 2, child: Text(item.hsnCode ?? '–', style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey))),
                          Expanded(flex: 1, child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
                          Expanded(flex: 2, child: Text('₹${item.price.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
                          Expanded(flex: 2, child: Text('$gstPct%', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
                          Expanded(flex: 2, child: Text('₹${item.totalPrice.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                    // Per-item GST sub-row
                    if (item.taxRate > 0)
                      Container(
                        color: i.isEven ? Colors.grey.shade50 : Colors.grey.shade100,
                        padding: const EdgeInsets.only(left: 24, right: 10, bottom: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Taxable: ₹${item.taxableValue.toStringAsFixed(2)}  |  CGST ${(item.taxRate * 50).toStringAsFixed(1)}%: ₹${item.cgstAmount.toStringAsFixed(2)}  |  SGST ${(item.taxRate * 50).toStringAsFixed(1)}%: ₹${item.sgstAmount.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 10, color: RumenoTheme.textGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Divider(height: 1, color: Colors.grey.shade200),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Tax Summary Table ──
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: RumenoTheme.primaryGreen.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    const Expanded(flex: 3, child: Text('HSN/SAC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('Taxable Val.', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('CGST Amt', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('SGST Amt', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    const Expanded(flex: 2, child: Text('Total Tax', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                  ],
                ),
              ),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(item.hsnCode ?? '–', style: const TextStyle(fontSize: 11))),
                        Expanded(flex: 2, child: Text('₹${item.taxableValue.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
                        Expanded(flex: 2, child: Text('₹${item.cgstAmount.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
                        Expanded(flex: 2, child: Text('₹${item.sgstAmount.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
                        Expanded(flex: 2, child: Text('₹${item.taxAmount.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  )),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Expanded(flex: 3, child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('₹${order.totalTaxableValue.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('₹${order.totalCgst.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('₹${order.totalSgst.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('₹${order.totalTaxAmount.toStringAsFixed(2)}', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: RumenoTheme.primaryGreen))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Grand Total Box ──
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: RumenoTheme.primaryGreen.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RumenoTheme.primaryGreen.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              _totalLine('Subtotal (tax-inclusive)', '₹${order.subtotal.toStringAsFixed(2)}'),
              if (order.discount > 0)
                _totalLine('Discount${order.couponCode != null ? " (${order.couponCode})" : ""}', '-₹${order.discount.toStringAsFixed(2)}', valueColor: RumenoTheme.successGreen),
              _totalLine(
                'Delivery Charges',
                order.deliveryCharge == 0 ? 'FREE' : '₹${order.deliveryCharge.toStringAsFixed(2)}',
                valueColor: order.deliveryCharge == 0 ? RumenoTheme.successGreen : null,
              ),
              const Divider(height: 14),
              Row(
                children: [
                  const Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const Spacer(),
                  Text('₹${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: RumenoTheme.primaryGreen)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    '(Includes GST of ₹${order.totalTaxAmount.toStringAsFixed(2)})',
                    style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Footer ──
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Terms & Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: RumenoTheme.textDark)),
              const SizedBox(height: 6),
              _footerNote('All prices above are GST-inclusive (CGST + SGST).'),
              _footerNote('This is a computer-generated invoice and does not require a physical signature.'),
              _footerNote('For queries, contact support@rumeno.in or call 1800-XXX-XXXX.'),
              _footerNote('Goods once sold will not be taken back unless defective.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _partyBox(BuildContext context, String title, List<String> lines, {required bool isLeft}) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: RumenoTheme.primaryGreen, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              ...lines.map((l) => Text(l, style: const TextStyle(fontSize: 11))),
            ],
          ),
        ),
      );

  Widget _totalLine(String label, String value, {Color? valueColor}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: RumenoTheme.textGrey))),
            Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor)),
          ],
        ),
      );

  Widget _footerNote(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 11)),
            Expanded(child: Text(text, style: TextStyle(fontSize: 11, color: RumenoTheme.textGrey))),
          ],
        ),
      );
}
