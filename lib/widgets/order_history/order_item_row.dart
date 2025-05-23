import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class OrderItemRow extends StatelessWidget {
  final ShoppingItem item;
  final ImatDataHandler handler;

  const OrderItemRow({
    required this.item,
    required this.handler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = item.product.price * item.amount;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: handler.getImage(item.product),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${item.amount} × ${item.product.price.toStringAsFixed(2)} kr',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${totalPrice.toStringAsFixed(2)} kr',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}