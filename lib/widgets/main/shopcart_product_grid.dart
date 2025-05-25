import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/main/product_card.dart';

class ShopcartProductGrid extends StatelessWidget {
  final List<Product> products;
  final ImatDataHandler handler;

  const ShopcartProductGrid({
    required this.products,
    required this.handler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Product grid with products
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: AppTheme.paddingMedium,
              mainAxisSpacing: AppTheme.paddingMedium,
              childAspectRatio: 200 / 200,
            ),
            itemBuilder: (_, i) {
              final p = products[i];
              return ProductCard(p, handler, key: ValueKey(p.productId));
            },
          ),
        ),
      ],
    );
  }
}