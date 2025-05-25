import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/shopping_cart_view.dart';

class CartSidebar extends StatelessWidget {
  final ImatDataHandler handler;
  const CartSidebar({required this.handler, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = handler.getShoppingCart();
    final totalAmount = cart.items.fold<double>(
      0,
      (sum, item) => sum + (item.amount * item.product.price),
    );

    return Container(
      width: 300,
      padding: const EdgeInsets.all(AppTheme.paddingMedium * 1.25),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Kundvagn',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '(${cart.items.length})',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const Divider(thickness: 2),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Text(
                      'Din kundvagn är tom',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        fontSize: 20,
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
                          bottom: AppTheme.paddingMedium
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                          side: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppTheme.paddingMedium,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Product image
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: handler.getImage(item.product),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppTheme.paddingMedium,
                                  ),
                                  // Product name
                                  Expanded(
                                    child: Text(
                                      item.product.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.paddingMedium),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          size: 22,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.grey[200],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 30, // Wider container
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${item.amount.toInt()}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
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
                                        icon: const Icon(Icons.add, size: 20),
                                        constraints: const BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 30,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppTheme.colorScheme.primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${itemTotal.toStringAsFixed(2)} kr',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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

          // Total section
          if (cart.items.isNotEmpty) ...[
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.paddingMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Totalt:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} kr',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Checkout button
          ElevatedButton.icon(
            onPressed: cart.items.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoppingCartView(),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60), 
              backgroundColor: AppTheme.colorScheme.secondary,
              foregroundColor: Colors.black,
              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                side: BorderSide(color: Colors.deepPurple.shade100, width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.shopping_cart, size: 18),
            label: const Text('Gå till kassan'),
          ),
        ],
      ),
    );
  }
}
