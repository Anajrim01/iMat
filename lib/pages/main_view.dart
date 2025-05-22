import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/pages/login_view.dart';
import 'package:imat_app/pages/order_history_view.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/cart_sidebar.dart';
import 'package:imat_app/widgets/category_sidebar.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imat_app/widgets/custom_appbar.dart';

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

    // Common style for navigation buttons
    final ButtonStyle lightPurpleButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.secondary,
      foregroundColor: Colors.black,
      elevation: 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.deepPurple.shade100, width: 1.5),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

    final ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 2.0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.deepPurple.shade300, width: 1.5),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

    return Scaffold(
      appBar: CustomAppBar(
        onCartPressed: () {
          // Handle cart button press
        },
        onLoginPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const LoginView(),
          ));
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation button bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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
                  icon: const Icon(Icons.shopping_basket_outlined, size: 24),
                  label: const Text('Handla'),
                  style:
                      _showFavoritesOnly == false
                          ? selectedButtonStyle
                          : lightPurpleButtonStyle,
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
                  label: const Text('Tidigare beställningar'),
                  style: lightPurpleButtonStyle,
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
                  label: const Text('Mina favoriter'),
                  style:
                      _showFavoritesOnly == true
                          ? selectedButtonStyle
                          : lightPurpleButtonStyle,
                ),
              ],
            ),
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
                  categories: handler.products
                      .map((p) => p.category)
                      .toSet()
                      .toList(),
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
                        // Main heading and sort control - simplified like in reference design
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Main heading text
                              Text(
                                _showFavoritesOnly
                                    ? 'Mina favoritprodukter'
                                    : 'Alla produkter',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Sorting row
                              Row(
                                children: [
                                  const Text(
                                    'Sortera efter:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: _sortOrder,
                                      underline: const SizedBox(),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      items:
                                          [
                                            'Pris lågt till högt',
                                            'Pris högt till lågt',
                                            'Alfabetisk ordning',
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _sortOrder = newValue;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Category filter row
                        Row(
                          children: [
                            Text(
                              'Typ av produkt:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      _categoryFilter.isEmpty
                                          ? 'Alla'
                                          : _categoryFilter.first
                                              .toString()
                                              .split('.')
                                              .last,
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items:
                                      [
                                        'Alla',
                                        ...handler.products
                                            .map(
                                              (p) =>
                                                  p.category
                                                      .toString()
                                                      .split('.')
                                                      .last,
                                            )
                                            .toSet(),
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        if (newValue == 'Alla') {
                                          _categoryFilter = [];
                                        } else {
                                          _categoryFilter =
                                              handler.products
                                                  .map((p) => p.category)
                                                  .toSet()
                                                  .toList()
                                                  .where(
                                                    (c) =>
                                                        c
                                                            .toString()
                                                            .split('.')
                                                            .last ==
                                                        newValue,
                                                  )
                                                  .toList();
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const Spacer(),

                            // Favorites toggle
                            Row(
                              children: [
                                const Text(
                                  'Endast favoriter:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: _showFavoritesOnly,
                                  onChanged: (value) {
                                    setState(() {
                                      _showFavoritesOnly = value;
                                    });
                                  },
                                  activeColor: Colors.deepPurple,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Selected category chips if any
                        if (_categoryFilter.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          _categoryFilter.remove(categoryValue);
                                        });
                                      },
                                      deleteIconColor: Colors.black54,
                                      backgroundColor: Colors.blueGrey[100],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.borderRadius,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),

                        // Product grid
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

                // Always visible cart sidebar
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
