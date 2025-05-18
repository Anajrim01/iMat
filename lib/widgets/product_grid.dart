import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ImatDataHandler handler;

  const ProductGrid({required this.products, required this.handler, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppTheme.paddingSmall,
        mainAxisSpacing: AppTheme.paddingSmall,
        childAspectRatio: 181 / 251,
      ),
      itemBuilder: (_, i) => ProductCard(products[i], handler),
    );
  }
}
