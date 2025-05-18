import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/cart_sidebar.dart';
import 'package:imat_app/widgets/category_sidebar.dart';
import 'package:imat_app/widgets/filter_bar.dart';
import 'package:imat_app/widgets/product_grid.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String _sortOrder = 'Pris lågt till högt';
  dynamic _categoryFilter;
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final filtered = _applyFilters(handler);

    return Scaffold(
      appBar: AppBar(title: const Text('iMat')),
      body: Row(
        children: [
          // Vänsterspalt: kategorival
          CategorySidebar(
            showFavorites: _showFavoritesOnly,
            onSelectAll: () => setState(() {
              _showFavoritesOnly = false;
              _categoryFilter = null;
            }),
            onSelectFavorites: () => setState(() {
              _showFavoritesOnly = true;
            }),
          ),

          // Mittsektion: filter + grid
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilterBar(
                    sortOrder: _sortOrder,
                    category: _categoryFilter,
                    categories:
                        handler.products.map((p) => p.category).toSet().toList(),
                    showFavoritesOnly: _showFavoritesOnly,
                    onSortChanged: (v) => setState(() => _sortOrder = v),
                    onCategoryChanged: (v) => setState(() => _categoryFilter = v),
                    onShowFavsChanged: (v) =>
                        setState(() => _showFavoritesOnly = v),
                  ),
                  const SizedBox(height: AppTheme.paddingMediumSmall),
                  if (_categoryFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(_categoryFilter.toString().split('.').last),
                            onDeleted: () => setState(() => _categoryFilter = null),
                          )
                        ],
                      ),
                    ),
                  Expanded(
                    child: ProductGrid(
                      products: filtered,
                      handler: handler,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Högerspalt: kundvagn
          CartSidebar(handler: handler),
        ],
      ),
    );
  }

  List<Product> _applyFilters(ImatDataHandler handler) {
    var list = handler.products;
    if (_showFavoritesOnly) list = handler.favorites;
    if (_categoryFilter != null) {
      list =
          list.where((p) => p.category == _categoryFilter).toList(growable: false);
    }
    list.sort((a, b) => _sortOrder == 'Pris högt till lågt'
        ? b.price.compareTo(a.price)
        : a.price.compareTo(b.price));
    return list;
  }
}
