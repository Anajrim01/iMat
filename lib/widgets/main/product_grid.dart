import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/main/product_card.dart';
import 'package:imat_app/widgets/main/empty_favorites_states.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ImatDataHandler handler;
  final bool isFavoritesView;
  final VoidCallback onBrowseAllPressed;

  const ProductGrid({
    required this.products,
    required this.handler,
    this.isFavoritesView = false,
    required this.onBrowseAllPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isFavoritesView && products.isEmpty) {
      return EmptyFavoritesState(onBrowseButtonPressed: onBrowseAllPressed);
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppTheme.paddingMedium,
        mainAxisSpacing: AppTheme.paddingMedium,
        childAspectRatio: 200 / 200,
      ),
      itemBuilder: (_, i) {
        final p = products[i];
        return ProductCard(p, handler, key: ValueKey(p.productId));
      },
    );
  }
}
