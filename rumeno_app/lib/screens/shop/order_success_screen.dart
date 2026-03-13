import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: RumenoTheme.successGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, color: RumenoTheme.successGreen, size: 60),
                ),
                const SizedBox(height: 24),
                Text('Order Placed!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: RumenoTheme.successGreen)),
                const SizedBox(height: 8),
                Text('Your order has been confirmed', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 15)),
                const SizedBox(height: 8),
                Text('Order ID: $orderId', style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  'You will receive an email confirmation shortly.',
                  style: TextStyle(color: RumenoTheme.textGrey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/shop/orders'),
                    child: const Text('Track Order'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/shop'),
                    child: const Text('Continue Shopping'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
