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
  List<dynamic> _categoryFilter = [];
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final filtered = _applyFilters(handler);

    return Scaffold(
      appBar: AppBar(title: const Text('IMat')),
      body: Row(
        children: [
          // Vänsterspalt: kategorival
          CategorySidebar(
            showFavorites: _showFavoritesOnly,
            onSelectAll:
                () => setState(() {
                  _showFavoritesOnly = false;
                  _categoryFilter = [];
                }),
            onSelectFavorites:
                () => setState(() {
                  _showFavoritesOnly = true;
                  _categoryFilter = [];
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
                    category: _categoryFilter, // Pass the list of categories
                    categories:
                        handler.products
                            .map((p) => p.category)
                            .toSet()
                            .toList(),
                    showFavoritesOnly: _showFavoritesOnly,
                    onSortChanged: (v) => setState(() => _sortOrder = v),
                    onCategoryChanged:
                        (v) => setState(
                          () => _categoryFilter = v as List<dynamic>,
                        ),
                    onShowFavsChanged:
                        (v) => setState(() => _showFavoritesOnly = v),
                  ),
                  const SizedBox(height: AppTheme.paddingMediumSmall),
                  if (_categoryFilter.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppTheme.paddingSmall,
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            _categoryFilter.map((categoryValue) {
                              return Chip(
                                label: Text(
                                  categoryValue.toString().split('.').last,
                                ),
                                onDeleted: () {
                                  setState(() {
                                    _categoryFilter.remove(categoryValue);
                                  });
                                },
                                backgroundColor: Colors.blueGrey[100],
                              );
                            }).toList(),
                      ),
                    ),
                  Expanded(
                    child: ProductGrid(products: filtered, handler: handler),
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
    // Klona listan så att vi inte sorterar om originalet
    var list = handler.products.toList();

    if (_showFavoritesOnly) {
      list = handler.favorites.toList();
    }

    if (_categoryFilter.isNotEmpty) {
      list = list.where((p) => _categoryFilter.contains(p.category)).toList();
    }

    // Sortera klonen
    list.sort(
      (a, b) =>
          _sortOrder == 'Pris högt till lågt'
              ? b.price.compareTo(a.price)
              : a.price.compareTo(b.price),
    );

    return list;
  }
}
