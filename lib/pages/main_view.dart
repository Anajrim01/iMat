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
  bool _inFavoritesSection = false;

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      // _showFavoritesOnly = false;
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

    // This is kept as a feature however to allow searching within favorites
    if (args.containsKey('showFavorites') && args['showFavorites'] == true) {
      setState(() {
        _showFavoritesOnly = true;
        _inFavoritesSection = true;
      });
    }
    args.clear(); // Clear args to prevent re-triggering (causes annoying bug otherwise)
  }


  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final filteredProducts = _applyFilters(handler);

    return Scaffold(
      appBar: CustomAppBar(onSearchSubmitted: _performSearch),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation button bar
          MainNavigationBar(
            showingFavorites: _inFavoritesSection,
            onShopPressed:
                () => setState(() {
                  _showFavoritesOnly = false;
                  _categoryFilter = [];
                  _inFavoritesSection = false;
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
                  _inFavoritesSection = true;
                }),
          ),

          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategorySidebar(
                  categories:
                      handler.products.map((p) => p.category).toSet().toList(),
                  selectedCategory: _categoryFilter,
                  onCategorySelected: (updatedCategories) {
                    setState(() {
                      _categoryFilter = updatedCategories;
                      _isSearching = false; // reset search state
                      _searchQuery = ''; // reset search query

                      // Only reset favorites if not in favorites section
                      // This can be confusing, but allows for better UX
                      if (_inFavoritesSection && updatedCategories.isNotEmpty) {
                        _inFavoritesSection = false;
                        _showFavoritesOnly = false;
                      } else if (!_inFavoritesSection &&
                          updatedCategories.isEmpty) {
                        _showFavoritesOnly = false;
                      }
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
                              _categoryFilter.isNotEmpty && _showFavoritesOnly
                                  ? 'Favoritprodukter i ${_categoryFilter[0]} (${filteredProducts.length} st)'
                                  : _categoryFilter.isNotEmpty
                                  ? 'Produkter i ${_categoryFilter[0]} (${filteredProducts.length} st)'
                                  : _showFavoritesOnly
                                  ? 'Mina favoritprodukter${_searchQuery.isNotEmpty ? ' - Sökning: "$_searchQuery"' : ''} (${filteredProducts.length} st)'
                                  : _searchQuery.isEmpty
                                  ? 'Alla produkter (${filteredProducts.length} st)'
                                  : 'Sökresultat för "$_searchQuery" (${filteredProducts.length} st)',
                          sortOrder: _sortOrder,
                          onSortChanged:
                              (newValue) => setState(() {
                                _sortOrder = newValue;
                              }),
                          showFavoritesOnly: _showFavoritesOnly,
                          onShowFavoritesChanged:
                              (value) => setState(() {
                                _showFavoritesOnly = value;
                                _inFavoritesSection = false;
                                // _categoryFilter = []; // reset category filter
                              }),
                        ),

                        const SizedBox(height: 16),
                        // TODO: FiltersChips for whatever new thing?
                        // FiltersChips(
                        //   categoryFilters: _categoryFilter,
                        //   onRemoveFilter:
                        //       (categoryValue) => setState(() {
                        //         _categoryFilter.remove(categoryValue);
                        //       }),
                        // ),

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
    var list = handler.products.toList();

    if (_showFavoritesOnly) {
      list = list.where((p) => handler.isFavorite(p)).toList();
    }

    if (_categoryFilter.isNotEmpty) {
      list = list.where((p) => _categoryFilter.contains(p.category)).toList();
    }

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
