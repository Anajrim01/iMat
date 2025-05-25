import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class BuyoutCartBar extends StatelessWidget {
  final ImatDataHandler handler;
  const BuyoutCartBar({required this.handler, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = handler.getShoppingCart();
    final totalAmount = cart.items.fold<double>(
      0,
      (sum, item) => sum + (item.amount * item.product.price),
    );

    return Container(
      width: 250,
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Kundvagn',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Text(
                '(${cart.items.length})',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child:
                cart.items.isEmpty
                    ? Center(
                      child: Text(
                        'Din kundvagn är tom',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (_, i) {
                        final item = cart.items[i];
                        final itemTotal = item.amount * item.product.price;

                        return Card(
                          margin: const EdgeInsets.only(
                            bottom: AppTheme.paddingSmall,
                          ),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            side: BorderSide(
                              color: Colors.grey[300]!,
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppTheme.paddingSmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Product image
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: handler.getImage(item.product),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppTheme.paddingSmall,
                                    ),
                                    // Product name
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.paddingSmall),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Quantity controls
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            handler.shoppingCartUpdate(
                                              item,
                                              delta: -1.0,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 16,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 28,
                                            minHeight: 28,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${item.amount.toInt()}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            handler.shoppingCartUpdate(
                                              item,
                                              delta: 1.0,
                                            );
                                          },
                                          icon: const Icon(Icons.add, size: 16),
                                          constraints: const BoxConstraints(
                                            minWidth: 28,
                                            minHeight: 28,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Item total
                                    Text(
                                      '${itemTotal.toStringAsFixed(2)} kr',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}