import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imat_app/widgets/custom_appbar.dart';
import 'package:imat_app/widgets/cart_sidebar.dart';

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

    // Apply sorting to orders
    final orders = _sortOrders(allOrders);

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

    final ButtonStyle actionButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 1.0,
      minimumSize: const Size(140, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

    return Scaffold(
      appBar: CustomAppBar(
        onCartPressed: () {
          // Handle cart button press
        },
        onLoginPressed: () {
          // Handle login button press
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Navigation buttons
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
                    Navigator.pushNamed(context, '/');
                  },
                  icon: const Icon(Icons.shopping_basket_outlined, size: 24),
                  label: const Text('Handla'),
                  style: lightPurpleButtonStyle,
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Do nothing, we're already on this page
                  },
                  icon: const Icon(Icons.access_time, size: 24),
                  label: const Text('Tidigare beställningar'),
                  style: selectedButtonStyle,
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _saveValue('showFavorites', true);
                    Navigator.pushNamed(context, '/');
                  },
                  icon: const Icon(Icons.star_border_outlined, size: 24),
                  label: const Text('Mina favoriter'),
                  style: lightPurpleButtonStyle,
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Sort dropdown and header
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            const Text(
                              'Tidigare beställningar',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),

                            // Sort dropdown
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
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadius,
                                ),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButton<String>(
                                value: _sortOrder,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items:
                                    [
                                      'Senaste först',
                                      'Äldsta först',
                                      'Högsta pris',
                                      'Lägsta pris',
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _sortOrder = newValue;
                                      _expandedOrderIndex =
                                          null; // Close any expanded order
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Order count summary
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[800],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Du har gjort ${orders.isEmpty ? "0" : orders.length} beställningar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Order list
                      Expanded(
                        child:
                            orders.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    final order = orders[index];
                                    final isExpanded =
                                        _expandedOrderIndex == index;

                                    final totalAmount = order.items
                                        .fold<double>(
                                          0.0,
                                          (sum, item) =>
                                              sum +
                                              (item.product.price *
                                                  item.amount),
                                        );

                                    final deliveryStatus = _getDeliveryStatus(
                                      order.date,
                                    );

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.borderRadius,
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Order header with status badge
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Orderdatum: ${DateFormat('yyyy-MM-dd').format(order.date)}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Ordernr: #${order.orderNumber}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                      deliveryStatus,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    deliveryStatus,
                                                    style: TextStyle(
                                                      color:
                                                          _getStatusTextColor(
                                                            deliveryStatus,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),

                                            // Order details
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Left column - order info
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Order summary row
                                                      Row(
                                                        children: [
                                                          _buildInfoBadge(
                                                            icon:
                                                                Icons
                                                                    .shopping_basket,
                                                            text:
                                                                '${order.items.length} varor',
                                                            color:
                                                                Colors
                                                                    .purple[100]!,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          _buildInfoBadge(
                                                            icon:
                                                                Icons
                                                                    .payments_outlined,
                                                            text:
                                                                '${totalAmount.toStringAsFixed(2)} kr',
                                                            color:
                                                                Colors
                                                                    .green[100]!,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          _buildInfoBadge(
                                                            icon:
                                                                Icons
                                                                    .credit_card,
                                                            text:
                                                                'Kortbetalning',
                                                            color:
                                                                Colors
                                                                    .blue[100]!,
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                        height: 16,
                                                      ),

                                                      // Delivery info
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: Colors.grey,
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          const Text(
                                                            'Levererad till: Hemadress',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      // Only show items when expanded
                                                      if (isExpanded) ...[
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                        const Divider(
                                                          height: 1,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),

                                                        const Text(
                                                          'Beställda varor:',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),

                                                        // List of order items
                                                        ...order.items.map(
                                                          (item) => Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  bottom: 8,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 40,
                                                                  height: 40,
                                                                  child: handler
                                                                      .getImage(
                                                                        item.product,
                                                                      ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        item
                                                                            .product
                                                                            .name,
                                                                        style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${item.amount} × ${item.product.price.toStringAsFixed(2)} kr',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.grey[700],
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${(item.product.price * item.amount).toStringAsFixed(2)} kr',
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        const Divider(
                                                          height: 1,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),

                                                        // Order total
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Text(
                                                              'Totalt:',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Text(
                                                              '${totalAmount.toStringAsFixed(2)} kr',
                                                              style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(width: 24),

                                                // Right column - action buttons
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_expandedOrderIndex ==
                                                              index) {
                                                            _expandedOrderIndex =
                                                                null;
                                                          } else {
                                                            _expandedOrderIndex =
                                                                index;
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        isExpanded
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                        size: 20,
                                                      ),
                                                      label: Text(
                                                        isExpanded
                                                            ? 'Dölj detaljer'
                                                            : 'Visa detaljer',
                                                      ),
                                                      style: actionButtonStyle,
                                                    ),
                                                    const SizedBox(height: 12),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        // Re-order logic
                                                        for (var item
                                                            in order.items) {
                                                          handler
                                                              .shoppingCartAdd(
                                                                item,
                                                              );
                                                        }
                                                        // TODO: Discuss with group if this good or bad?
                                                        // maybe different color or style?
                                                        //   ScaffoldMessenger.of(
                                                        //     context,
                                                        //   ).showSnackBar(
                                                        //     SnackBar(
                                                        //       content: const Text(
                                                        //         'Varorna har lagts till i kundvagnen',
                                                        //         style: TextStyle(
                                                        //           fontSize: 16,
                                                        //         ),
                                                        //       ),
                                                        //       behavior:
                                                        //           SnackBarBehavior
                                                        //               .floating,
                                                        //       shape: RoundedRectangleBorder(
                                                        //         borderRadius:
                                                        //             BorderRadius.circular(
                                                        //               AppTheme
                                                        //                   .borderRadius,
                                                        //             ),
                                                        //       ),
                                                        //       action: SnackBarAction(
                                                        //         label:
                                                        //             'Visa kundvagn',
                                                        //         onPressed: () {
                                                        //           // Scroll to cart or focus on it
                                                        //         },
                                                        //       ),
                                                        //     ),
                                                        //   );
                                                      },
                                                      icon: const Icon(
                                                        Icons.replay,
                                                        size: 20,
                                                      ),
                                                      label: const Text(
                                                        'Beställ igen',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF6750A4,
                                                            ),
                                                        foregroundColor:
                                                            Colors.white,
                                                        elevation: 1.0,
                                                        minimumSize: const Size(
                                                          140,
                                                          44,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                AppTheme
                                                                    .borderRadius,
                                                              ),
                                                        ),
                                                        textStyle:
                                                            const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    ),
                                                    if (isExpanded) ...[
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      OutlinedButton.icon(
                                                        onPressed: () {
                                                          // Download receipt functionality
                                                        },
                                                        icon: const Icon(
                                                          Icons.download,
                                                          size: 20,
                                                        ),
                                                        label: const Text(
                                                          'Hämta kvitto',
                                                        ),
                                                        style: OutlinedButton.styleFrom(
                                                          foregroundColor:
                                                              Colors.black87,
                                                          side: BorderSide(
                                                            color:
                                                                Colors
                                                                    .grey[400]!,
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 12,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  AppTheme
                                                                      .borderRadius,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
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

  // Helper method to create info badges
  Widget _buildInfoBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Empty state when no orders
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Du har inga tidigare beställningar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dina beställningar kommer att visas här när du har handlat',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Börja handla'),
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

  // Get delivery status based on date
  String _getDeliveryStatus(DateTime orderDate) {
    final now = DateTime.now();
    final difference = now.difference(orderDate).inDays;

    if (difference > 5) {
      return 'Levererad';
    } else if (difference > 2) {
      return 'Under leverans';
    } else {
      return 'Bearbetas';
    }
  }

  // Get status color based on delivery status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Levererad':
        return Colors.green[100]!;
      case 'Under leverans':
        return Colors.orange[100]!;
      case 'Bearbetas':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // Get status text color based on delivery status
  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Levererad':
        return Colors.green[800]!;
      case 'Under leverans':
        return Colors.orange[800]!;
      case 'Bearbetas':
        return Colors.blue[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  void _saveValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
