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
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSavedValue();
  }

  void _loadSavedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showFavoritesOnly = prefs.getBool('showFavorites') ?? false;
    });

    // Favorites shown, don't keep the filter on refresh
    _saveBoolValue("showFavorites", false);
  }

  // Shared method to save the value
  void _saveBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
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
      appBar: CustomAppBar(
        onLoginPressed: () {
          // Handle login button press
        },
      ),
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
                // Category sidebar
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
                                  ? 'Mina favoritprodukter'
                                  : 'Alla produkter',
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
                            onBrowseAllPressed:
                                () => setState(() {
                                  _showFavoritesOnly = false;
                                  _categoryFilter = [];
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Always visible cart sidebar
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

    if (_categoryFilter.isNotEmpty) {
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
