import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/pages/AuthDialogView.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/user_manager.dart';

import '../../pages/my_account.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function()? onCartPressed;
  final Function(String) onSearchSubmitted;

  const CustomAppBar({
    super.key,
    this.onCartPressed,
    required this.onSearchSubmitted,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isInteractingWithOverlay = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus && _searchQuery.isNotEmpty) {
      _showSearchResults();
    } else if (!_isInteractingWithOverlay) {
      _removeOverlay();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });

    if (_searchQuery.isNotEmpty && _searchFocusNode.hasFocus) {
      _showSearchResults();
    } else {
      _removeOverlay();
    }
  }

  void _showSearchResults() {
    _removeOverlay();

    final handler = Provider.of<ImatDataHandler>(context, listen: false);
    final searchResults = handler.findProducts(_searchQuery).take(5).toList();

    if (searchResults.isEmpty) return;

    _overlayEntry = _createOverlayEntry(searchResults);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void _handleSearch() {
    widget.onSearchSubmitted(_searchQuery);
    _removeOverlay();
    _searchFocusNode.unfocus();
    // Dont clear search here anymore
    // as it is more convinient for user to see
    // what they searched for.
    // _searchController.clear();
  }

  OverlayEntry _createOverlayEntry(List<Product> products) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final handler = Provider.of<ImatDataHandler>(context, listen: false);

    return OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return GestureDetector(
          onTap: () {
            _removeOverlay();
            _searchFocusNode.unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * 0.2,
                top: offset.dy + size.height,
                width: screenWidth * 0.66,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height),
                  child: GestureDetector(
                    onTap: () => _isInteractingWithOverlay = true,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadius,
                      ),
                      color: Colors.white,
                      child: MouseRegion(
                        onEnter: (_) => _isInteractingWithOverlay = true,
                        onExit: (_) => _isInteractingWithOverlay = false,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading for search results
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      AppTheme.borderRadius,
                                    ),
                                    topRight: Radius.circular(
                                      AppTheme.borderRadius,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Sökresultat för "$_searchQuery"',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Search results
                              Flexible(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            // Product image
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: handler.getImage(product),
                                            ),
                                            const SizedBox(width: 20),

                                            // Product name and price
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${product.price.toStringAsFixed(2)} ${product.unit}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Add button
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                _isInteractingWithOverlay =
                                                    true;
                                                // Add product to cart
                                                handler.shoppingCartAdd(
                                                  ShoppingItem(
                                                    product,
                                                    amount: 1,
                                                  ),
                                                );
                                                // Show confirmation message (feedback)
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${product.name} tillagd i kundvagnen',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    behavior:
                                                        SnackBarBehavior
                                                            .floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppTheme
                                                                .borderRadius,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.add_shopping_cart,
                                                size: 24,
                                                color: Colors.black,
                                              ),
                                              label: const Text(
                                                'Lägg till',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme
                                                        .colorScheme
                                                        .secondary,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppTheme.borderRadius,
                                                      ),
                                                  side: BorderSide(
                                                    color:
                                                        Colors
                                                            .deepPurple
                                                            .shade100,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Footer for search results
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      AppTheme.borderRadius,
                                    ),
                                    bottomRight: Radius.circular(
                                      AppTheme.borderRadius,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Klicka på "Lägg till" för att lägga varan i kundvagnen',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            'I',
            style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 50),
          ),
          const Text('Mat', style: TextStyle(fontSize: 50)),
          const SizedBox(width: 120),

          // Search bar
          Expanded(
            child: CompositedTransformTarget(
              link: _layerLink,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      // Search icon
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.search, size: 28),
                      ),

                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onSubmitted: (_) => _handleSearch(),
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Sök efter varor här...',
                            hintStyle: TextStyle(fontSize: 18),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
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
                      
                      // Clear search button (X)
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              _removeOverlay();
                              _handleSearch(); // maybe inefficient idc tbh
                            });
                          },
                          child: Container(
                            height: 56,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      // Search button
                      GestureDetector(
                        onTap: _handleSearch,
                        child: Container(
                          height: 56,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(AppTheme.borderRadius),
                              bottomRight: Radius.circular(
                                AppTheme.borderRadius,
                              ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 120),

          // Login button
               Consumer<UserManager>(
          builder: (context, userManager, child) {
          if (userManager.isLoggedIn) {
          return ElevatedButton.icon(
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyAccount()),
          );
        },
        icon: const Icon(Icons.account_circle, size: 24),
        label: const Text(
          'Mitt konto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC8E6C9),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AuthDialog();
            },
          );
        },
        icon: const Icon(Icons.person_outline, size: 24),
        label: const Text(
          'Logga in / Registrera',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF3E5F5),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ),
      );
    }
  },
),
          const SizedBox(width: 16),
        ],
      ),
      toolbarHeight: 90,
      automaticallyImplyLeading: false,
    );
  }
}
