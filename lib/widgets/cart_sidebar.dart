import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CartSidebar extends StatelessWidget {
  final ImatDataHandler handler;
  const CartSidebar({required this.handler, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = handler.getShoppingCart();
    return Container(
      width: 250,
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Kundvagn', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                final total = item.amount * item.product.price;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Text(
                    '${item.amount} × ${total.toStringAsFixed(2)} kr',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
            ),
            ElevatedButton.icon(
            // TODO: Add a checkout page
            onPressed: () => handler.placeOrder(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppTheme.colorScheme.secondary,
              foregroundColor: Colors.black,
              textStyle: Theme.of(
              context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              side: BorderSide(
                color: Colors.deepPurple.shade100,
                width: 0.5,
              ), // Light purple border
              ),
            ),
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Gå till kassan'),
            ),
          ],
          ),
    );
  }
}
