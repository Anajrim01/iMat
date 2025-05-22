import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/pages/order_history_view.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/cart_sidebar.dart';
import 'package:imat_app/widgets/category_sidebar.dart';
import 'package:imat_app/widgets/filter_bar.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    // Favorites shown, don't keep the filter on refresh?
    _saveValue("showFavorites", false);
    
  }
  void _saveValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final filtered = _applyFilters(handler);

    // Common style for "Handla", "Tidigare beställningar", "Mina favoriter" buttons
    final ButtonStyle lightPurpleButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.secondary,
      foregroundColor: Colors.black,
      elevation: 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(
          color: Colors.deepPurple.shade100,
          width: 1,
        ), // Light purple border
      ),
    );
    final ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.primary,
      foregroundColor: Colors.black,
      elevation: 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(
          color: Colors.lightGreenAccent.shade100,
          width: 1,
        ), // Light green border
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'I',
              style: TextStyle(
                color: AppTheme.colorScheme.primary,
                fontSize: 50,
              ),
            ),
            const Text('Mat', style: TextStyle(fontSize: 50)),
            const SizedBox(width: 150),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Sök varor...',
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadius,
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(AppTheme.borderRadius),
                            bottomRight: Radius.circular(AppTheme.borderRadius),
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              'Sök',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 150), // Add spacing before login button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_outline),
              label: const Text('Logga in'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E5F5),
                foregroundColor: Colors.black,
                elevation: 0.5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Kundvagn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0.5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  side: BorderSide(
                    color: Colors.deepPurple.shade100,
                    width: 1,
                  ), // Light purple border
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 25),
          ],
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Button bar: Kategorier, Handla, Tidigare beställningar, Mina favoriter
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showFavoritesOnly = false;
                            _categoryFilter = [];
                          });
                        },
                        icon: const Icon(
                          Icons.shopping_basket_outlined,
                          size: 24,
                        ),
                        label: Text(
                          'Handla',
                          style: TextStyle(
                            color:
                                (_showFavoritesOnly == false)
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        style:
                            (_showFavoritesOnly == false)
                                ? selectedButtonStyle.copyWith(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 20,
                                    ),
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                                : lightPurpleButtonStyle.copyWith(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 20,
                                    ),
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryView(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.access_time, size: 24),
                        label: const Text(
                          'Tidigare beställningar',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: lightPurpleButtonStyle.copyWith(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showFavoritesOnly = true;
                            _categoryFilter = [];
                          });
                        },
                        icon: const Icon(Icons.star_border_outlined, size: 24),
                        label: Text(
                          'Mina favoriter',
                          style: TextStyle(
                            color:
                                (_showFavoritesOnly == true)
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        style:
                            (_showFavoritesOnly == true)
                                ? selectedButtonStyle.copyWith(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 20,
                                    ),
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                                : lightPurpleButtonStyle.copyWith(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 20,
                                    ),
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                        categoryValue
                                            .toString()
                                            .split('.')
                                            .last,
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
                          child: ProductGrid(
                            products: filtered,
                            handler: handler,
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

  List<Product> _applyFilters(ImatDataHandler handler) {
    var list =
        _showFavoritesOnly
            ? handler.favorites.toList()
            : handler.products.toList();

    if (_categoryFilter.isNotEmpty) {
      list = list.where((p) => _categoryFilter.contains(p.category)).toList();
    }

    list.sort(
      (a, b) =>
          _sortOrder == 'Pris högt till lågt'
              ? b.price.compareTo(a.price)
              : a.price.compareTo(b.price),
    );

    return list;
  }
}
