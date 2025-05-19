import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ImatDataHandler handler;
  const ProductGrid({required this.products, required this.handler, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppTheme.paddingMedium,
        mainAxisSpacing: AppTheme.paddingMedium,
        childAspectRatio: 200 / 220,
      ),
      itemBuilder: (ctx, i) {
        final p = products[i];
        return ProductCard(
          p,
          handler,
          key: ValueKey(p.productId), // <-- primary key
        );
      },
    );
  }
}
