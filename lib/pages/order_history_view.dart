import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imat_app/widgets/shared/custom_appbar.dart';
import 'package:imat_app/widgets/shared/cart_sidebar.dart';
import 'package:imat_app/widgets/order_history/nav_bar.dart';
import 'package:imat_app/widgets/order_history/sort_header.dart';
import 'package:imat_app/widgets/order_history/order_card.dart';
import 'package:imat_app/widgets/order_history/empty_state.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  String _sortOrder = 'Senaste först';
  int? _expandedOrderIndex;

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final allOrders = handler.orders;

    final orders = _sortOrders(allOrders);

    return Scaffold(
      appBar: CustomAppBar(
        onLoginPressed: () {
          // Handle login action
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation buttons
          OrderHistoryNavigationBar(
            onShopPressed: () => Navigator.pushNamed(context, '/'),
            onFavoritesPressed: () {
              _saveBoolValue('showFavorites', true);
              Navigator.pushNamed(context, '/');
            },
          ),

          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Orders list area
                Expanded(
                  child: Column(
                    children: [
                      // Sort header with dropdown
                      OrderSortHeader(
                        orderCount: orders.length,
                        currentSortOrder: _sortOrder,
                        onSortChanged: (newValue) {
                          setState(() {
                            _sortOrder = newValue;
                            _expandedOrderIndex = null;
                          });
                        },
                      ),

                      // Order list
                      Expanded(
                        child:
                            orders.isEmpty
                                ? OrderHistoryEmptyState(
                                  onShopButtonPressed:
                                      () => Navigator.pushNamed(context, '/'),
                                )
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    final order = orders[index];
                                    final isExpanded =
                                        _expandedOrderIndex == index;

                                    return OrderCard(
                                      order: order,
                                      handler: handler,
                                      isExpanded: isExpanded,
                                      onToggleExpand: () {
                                        setState(() {
                                          if (_expandedOrderIndex == index) {
                                            _expandedOrderIndex = null;
                                          } else {
                                            _expandedOrderIndex = index;
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),

                // Shopping cart sidebar
                CartSidebar(handler: handler),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sort orders based on selected sort order
  List<Order> _sortOrders(List<Order> orders) {
    final sortedOrders = orders.toList();

    switch (_sortOrder) {
      case 'Senaste först':
        sortedOrders.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Äldsta först':
        sortedOrders.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Högsta pris':
        sortedOrders.sort((a, b) {
          final aTotal = a.items.fold<double>(
            0.0,
            (sum, item) => sum + (item.product.price * item.amount),
          );
          final bTotal = b.items.fold<double>(
            0.0,
            (sum, item) => sum + (item.product.price * item.amount),
          );
          return bTotal.compareTo(aTotal);
        });
        break;
      case 'Lägsta pris':
        sortedOrders.sort((a, b) {
          final aTotal = a.items.fold<double>(
            0.0,
            (sum, item) => sum + (item.product.price * item.amount),
          );
          final bTotal = b.items.fold<double>(
            0.0,
            (sum, item) => sum + (item.product.price * item.amount),
          );
          return aTotal.compareTo(bTotal);
        });
        break;
    }

    return sortedOrders;
  }

  void _saveBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
