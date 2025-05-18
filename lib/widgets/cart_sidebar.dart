import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CartSidebar extends StatelessWidget {
  final ImatDataHandler handler;

  const CartSidebar({required this.handler, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = handler.getShoppingCart();
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppTheme.paddingMediumSmall),
            child: Text('Kundvagn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: cart.items.map((item) {
                final total = item.amount * item.product.price;
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('× ${item.amount}'),
                  trailing: Text('${total.toStringAsFixed(2)} kr'),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMediumSmall),
            child: ElevatedButton(
              onPressed: handler.placeOrder,
              child: const Text('Beställ'),
            ),
          ),
        ],
      ),
    );
  }
}
