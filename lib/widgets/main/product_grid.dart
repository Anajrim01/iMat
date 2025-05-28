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
  final bool isSearchResult;
  final String searchQuery;
  final VoidCallback onBrowseAllPressed;

  const ProductGrid({
    required this.products,
    required this.handler,
    this.isFavoritesView = false,
    this.isSearchResult = false,
    this.searchQuery = '',
    required this.onBrowseAllPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Show empty favorites state
    if (isFavoritesView && products.isEmpty) {
      return EmptyFavoritesState(onBrowseButtonPressed: onBrowseAllPressed);
    }

    // Show empty search results state
    if (isSearchResult && products.isEmpty) {
      return _buildEmptySearchResults();
    }

    // make this responsive 
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 3;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    }

    // Product grid with products
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingTiny),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppTheme.paddingTiny,
        mainAxisSpacing: AppTheme.paddingTiny,
        childAspectRatio: screenWidth > 1800 ? 1.15 : 
             (screenWidth >= 1600 ? 1.0 : 
             (screenWidth >= 1440 ? 0.8 : 0.65)),
      ),
      itemBuilder: (_, i) {
        final p = products[i];
        return ProductCard(p, handler, key: ValueKey(p.productId));
      },
    );
  }

  Widget _buildEmptySearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Inga resultat för "$searchQuery"',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Försök med andra sökord eller titta på våra kategorier',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onBrowseAllPressed,
            icon: const Icon(Icons.shopping_basket_outlined),
            label: const Text('Visa alla produkter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
