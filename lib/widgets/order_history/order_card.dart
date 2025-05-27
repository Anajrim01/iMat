import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:intl/intl.dart';
import 'package:imat_app/widgets/order_history/info_badge.dart';
import 'package:imat_app/widgets/order_history/status_badge.dart';
import 'package:imat_app/widgets/order_history/order_item_row.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final ImatDataHandler handler;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const OrderCard({
    required this.order,
    required this.handler,
    required this.isExpanded,
    required this.onToggleExpand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = order.items.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.amount),
    );

    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.secondary,
      foregroundColor: Colors.black,
      elevation: 1.0,
      minimumSize: const Size(150, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), 
    );

    return GestureDetector(
      onTap: onToggleExpand,
      child: Card(
        margin: const EdgeInsets.only(bottom: 24),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          side: BorderSide(color: Colors.grey[300]!, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header with status badge
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orderdatum: ${DateFormat('yyyy-MM-dd').format(order.date)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6), 
                        Text(
                          'Ordernr: #${order.orderNumber}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(orderDate: order.date),
                ],
              ),
              const SizedBox(height: 20), 

              // Order details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column - order info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order summary row
                        Row(
                          children: [
                            InfoBadge(
                              icon: Icons.shopping_basket,
                              text: '${order.items.length} varor',
                              color: Colors.purple[100]!,
                            ),
                            const SizedBox(width: 10), 
                            InfoBadge(
                              icon: Icons.payments_outlined,
                              text: '${totalAmount.toStringAsFixed(2)} kr',
                              color: Colors.green[100]!,
                            ),
                            const SizedBox(width: 10), 
                            InfoBadge(
                              icon: Icons.credit_card,
                              text: 'Kortbetalning',
                              color: Colors.blue[100]!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), 

                        // Delivery info
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Levererad till: Hemadress',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),

                        // Only show items when expanded
                        if (isExpanded) ...[
                          const SizedBox(height: 28), 
                          const Divider(height: 1),
                          const SizedBox(height: 20), 

                          const Text(
                            'Beställda varor:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16), 

                          // List of order items
                          ...order.items.map((item) => 
                            OrderItemRow(item: item, handler: handler)
                          ),

                          const SizedBox(height: 20), 
                          const Divider(height: 1),
                          const SizedBox(height: 20), 

                          // Order total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Totalt:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 18), 
                              Text(
                                '${totalAmount.toStringAsFixed(2)} kr',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 28), 

                  // Right column - action buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: onToggleExpand,
                        icon: Icon(
                          isExpanded ? Icons.visibility_off : Icons.visibility,
                          size: 22,
                        ),
                        label: Text(isExpanded ? 'Dölj detaljer' : 'Visa detaljer'),
                        style: actionButtonStyle,
                      ),
                      const SizedBox(height: 14), 
                      ElevatedButton.icon(
                        onPressed: () {
                          // Re-order logic
                          for (var item in order.items) {
                            handler.shoppingCartAdd(item);
                          }
                        },
                        icon: const Icon(Icons.replay, size: 22),
                        label: const Text('Beställ igen'),
                        style: actionButtonStyle,
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 18), 
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement download reciept function
                            // Do nothing
                          },
                          icon: const Icon(Icons.download, size: 22),
                          label: const Text('Hämta kvitto'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey[400]!),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14, 
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
