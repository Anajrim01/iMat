import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_cart.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
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

    // Get recommended products for "För dig" section
    final recommendedProducts = _getRecommendedProducts(handler, 3);

    return Scaffold(
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left sidebar - "För dig"
                _buildForDigSection(context, handler, recommendedProducts),

                // Main cart content
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Cart header with total
                        _buildCartHeader(context, totalAmount),

                        // Cart items
                        Expanded(
                          child: _buildCartItems(context, cart, handler),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForDigSection(
    BuildContext context,
    ImatDataHandler handler,
    List<dynamic> products,
  ) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'För dig',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 120,
                            child: handler.getImage(product),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Price
                        Text(
                          '${product.price.toStringAsFixed(2)} ${product.unit}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              handler.shoppingCartAdd(
                                ShoppingItem(product, amount: 1),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(64, 48),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: AppTheme.colorScheme.secondary,
                              foregroundColor: Colors.black,
                              textStyle: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadius,
                                ),
                                side: BorderSide(
                                  color: Colors.deepPurple.shade100,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Text('Lägg till'),
                          ),
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

  Widget _buildCartHeader(BuildContext context, double totalAmount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          const Text(
            'Din varukorg',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Totalt:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${totalAmount.toStringAsFixed(2)} kr',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(
    BuildContext context,
    ShoppingCart cart,
    ImatDataHandler handler,
  ) {
    if (cart.items.isEmpty) {
      return const Center(
        child: Text(
          'Din kundvagn är tom',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        final itemTotal = item.amount * item.product.price;

        return Card(
          margin: const EdgeInsets.only(bottom: 24),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Product image
                SizedBox(
                  width: 100,
                  height: 100,
                  child: handler.getImage(item.product),
                ),
                const SizedBox(width: 24),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.product.price.toStringAsFixed(2)} ${item.product.unit}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            100,
                            48,
                          ), // Increased button size
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          backgroundColor: AppTheme.colorScheme.secondary,
                          foregroundColor: Colors.black,
                          textStyle: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            side: BorderSide(
                              color: Colors.deepPurple.shade100,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Text('Mer info'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Right section with price and quantity
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      itemTotal.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        // Decrease button
                        Container(
                          width: 48, // Increased button size
                          height: 48, // Increased button size
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.remove,
                              size: 22,
                            ), // Increased icon size
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              handler.shoppingCartUpdate(item, delta: -1.0);
                            },
                          ),
                        ),

                        // Quantity display
                        Container(
                          width: 60,
                          height: 48, // Increased height
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text(
                            '${item.amount.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        // Increase button
                        Container(
                          width: 48, // Increased button size
                          height: 48, // Increased button size
                          decoration: BoxDecoration(
                            color: AppTheme.colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 22, // Increased icon size
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              handler.shoppingCartUpdate(item, delta: 1.0);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Product> _getRecommendedProducts(ImatDataHandler handler, int count) {
    // Get products currently in the cart
    final cartProductIds =
        handler
            .getShoppingCart()
            .items
            .map((item) => item.product.productId)
            .toSet();

    // First try to recommend based on purchase history
    if (handler.orders.isNotEmpty) {
      // Create frequency map of purchased products
      final frequencyMap = <int, int>{};

      for (final order in handler.orders) {
        for (final item in order.items) {
          if (!cartProductIds.contains(item.product.productId)) {
            frequencyMap[item.product.productId] =
                (frequencyMap[item.product.productId] ?? 0) + 1;
          }
        }
      }

      // Sort products by purchase frequency
      final sortedProductIds =
          frequencyMap.keys.toList()
            ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

      // If we have enough previously purchased products, return those
      if (sortedProductIds.length >= count) {
        return sortedProductIds
            .take(count)
            .map((id) => handler.getProduct(id)!)
            .toList();
      }
    }

    // Fallback: Just take some products not already in cart
    final availableProducts =
        handler.products
            .where((p) => !cartProductIds.contains(p.productId))
            .take(count)
            .toList();

    // If we don't have enough products, just return what we have
    if (availableProducts.length < count) {
      return handler.products.take(count).toList();
    }

    return availableProducts;
  }
}
