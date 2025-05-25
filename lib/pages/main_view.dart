import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/pages/order_history_view.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/shared/cart_sidebar.dart';
import 'package:imat_app/widgets/main/category_sidebar.dart';
import 'package:imat_app/widgets/main/product_grid.dart';
import 'package:imat_app/widgets/main/nav_bar.dart';
import 'package:imat_app/widgets/main/product_filters.dart';
import 'package:imat_app/widgets/main/filters_chips.dart';
import 'package:imat_app/widgets/shared/custom_appbar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String _sortOrder = 'Pris lågt till högt';
  List<dynamic> _categoryFilter = [];
  bool _showFavoritesOnly = false;
  String _searchQuery = '';
  bool _isSearching = false;

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      _showFavoritesOnly = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;
    if (args.containsKey('searchQuery')) {
      final searchQuery = args['searchQuery'] as String;
      if (searchQuery.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _performSearch(searchQuery);
        });
      }
    }

    // Introduces a bug where search and favorites are both active
    // This is kept as a feature however to allow searching within favorites
    if (args.containsKey('showFavorites') && args['showFavorites'] == true) {
      setState(() {
        _showFavoritesOnly = true;
        _categoryFilter = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final filteredProducts = _applyFilters(handler);

    // Get unique categories for the dropdown
    final uniqueCategories =
        handler.products
            .map((p) => p.category.toString().split('.').last)
            .toSet()
            .toList();

    return Scaffold(
      appBar: CustomAppBar(onSearchSubmitted: _performSearch),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation button bar
          MainNavigationBar(
            showingFavorites: _showFavoritesOnly,
            onShopPressed:
                () => setState(() {
                  _showFavoritesOnly = false;
                  _categoryFilter = [];
                }),
            onOrderHistoryPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryView(),
                ),
              );
            },
            onFavoritesPressed:
                () => setState(() {
                  _showFavoritesOnly = true;
                  _categoryFilter = [];
                }),
          ),

          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Category sidebar - SET FILTERING HERE (Maybe pass categories down to the sidebar?)
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
                  categories:
                      handler.products.map((p) => p.category).toSet().toList(),
                  selectedCategory: _categoryFilter,
                  onCategorySelected: (updatedCategories) {
                    setState(() {
                      _categoryFilter = updatedCategories;
                    });
                  },
                ),

                // Product content area
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Filters section
                        ProductFilters(
                          title:
                              _showFavoritesOnly
                                  ? 'Mina favoritprodukter ${_searchQuery.isNotEmpty ? ' - Sökresultat för "$_searchQuery" (${filteredProducts.length} produkter)' : '(${handler.favorites.length}) '}'
                                  : _searchQuery.isEmpty
                                  ? 'Alla produkter'
                                  : 'Sökresultat för "$_searchQuery" (${filteredProducts.length} produkter)',
                          sortOrder: _sortOrder,
                          onSortChanged:
                              (newValue) => setState(() {
                                _sortOrder = newValue;
                              }),
                          selectedCategory:
                              _categoryFilter.isEmpty
                                  ? null
                                  : _categoryFilter.first
                                      .toString()
                                      .split('.')
                                      .last,
                          availableCategories: uniqueCategories,
                          onCategoryChanged:
                              (newValue) => setState(() {
                                if (newValue == null) {
                                  _categoryFilter = [];
                                } else {
                                  _categoryFilter =
                                      handler.products
                                          .map((p) => p.category)
                                          .toSet()
                                          .toList()
                                          .where(
                                            (c) =>
                                                c.toString().split('.').last ==
                                                newValue,
                                          )
                                          .toList();
                                }
                              }),
                          showFavoritesOnly: _showFavoritesOnly,
                          onShowFavoritesChanged:
                              (value) => setState(() {
                                _showFavoritesOnly = value;
                              }),
                        ),

                        const SizedBox(height: 16),
                        FiltersChips(
                          categoryFilters: _categoryFilter,
                          onRemoveFilter:
                              (categoryValue) => setState(() {
                                _categoryFilter.remove(categoryValue);
                              }),
                        ),

                        // Product grid
                        Expanded(
                          child: ProductGrid(
                            products: filteredProducts,
                            handler: handler,
                            isFavoritesView: _showFavoritesOnly,
                            isSearchResult: _isSearching,
                            searchQuery: _searchQuery,
                            onBrowseAllPressed:
                                () => setState(() {
                                  _isSearching = false;
                                  _searchQuery = '';
                                  _showFavoritesOnly = false;
                                  _categoryFilter = [];
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CartSidebar(handler: handler),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Apply sorting and filtering to the products
  List<Product> _applyFilters(ImatDataHandler handler) {
    var list =
        _showFavoritesOnly
            ? handler.favorites.toList()
            : handler.products.toList();

    if (_isSearching && _searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      list =
          list
              .where(
                (p) =>
                    p.name.toLowerCase().contains(lowerQuery) ||
                    p.category.toString().toLowerCase().contains(lowerQuery),
              )
              .toList();
    } else if (_categoryFilter.isNotEmpty) {
      list = list.where((p) => _categoryFilter.contains(p.category)).toList();
    }

    switch (_sortOrder) {
      case 'Pris högt till lågt':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Pris lågt till högt':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Alfabetisk ordning':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        list.sort((a, b) => a.price.compareTo(b.price));
    }

    return list;
  }
}
