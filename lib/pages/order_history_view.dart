import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imat_app/widgets/custom_appbar.dart';
import 'package:imat_app/widgets/cart_sidebar.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final orders = handler.orders;
    String _sortOrder = 'Senaste först'; // Default sort order

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
                  color: Colors.grey.withValues(alpha: .2),
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

          // Main content area with cart sidebar
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main content area
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
                                  // Would need to make this stateful to handle state change
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Order list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: orders.isEmpty ? 3 : orders.length,
                          itemBuilder: (context, index) {
                            final order =
                                orders.isNotEmpty ? orders[index] : null;
                            final sampleDate = DateTime.now().subtract(
                              Duration(days: index * 20 + 6),
                            );

                            final totalAmount =
                                order == null
                                    ? 0.0
                                    : order.items.fold<double>(
                                      0.0,
                                      (sum, item) =>
                                          sum +
                                          (item.product.price * item.amount),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Order header with status badge
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Orderdatum: ${DateFormat('yyyy-MM-dd').format(order?.date ?? sampleDate)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Text(
                                            'Levererad',
                                            style: TextStyle(
                                              color: Colors.green[800],
                                              fontWeight: FontWeight.bold,
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
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ordernr: #${order?.orderNumber ?? "12345${index + 1}"}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Varor: ${order?.items.length ?? (index + 5)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  const Text(
                                                    'Levererad till: Hemadress',
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Summa: ${totalAmount.toStringAsFixed(2)} kr',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Right column - action buttons
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                // TODO: Show order details
                                              },
                                              icon: const Icon(
                                                Icons.visibility,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                'Visa detaljer',
                                              ),
                                              style: actionButtonStyle,
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                // Re-order logic
                                                if (order != null) {
                                                  for (var item
                                                      in order.items) {
                                                    handler.shoppingCartAdd(
                                                      item,
                                                    );
                                                  }
                                                  // feedback to user
                                                  // ScaffoldMessenger.of(
                                                  //   context,
                                                  // ).showSnackBar(
                                                  //   SnackBar(
                                                  //     content: Text(
                                                  //       'Varorna har lagts till i kundvagnen',
                                                  //       style: const TextStyle(
                                                  //         fontSize: 16,
                                                  //       ),
                                                  //     ),
                                                  //     behavior:
                                                  //         SnackBarBehavior
                                                  //             .floating,
                                                  //     shape: RoundedRectangleBorder(
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(
                                                  //             AppTheme
                                                  //                 .borderRadius,
                                                  //           ),
                                                  //     ),
                                                  //     action: SnackBarAction(
                                                  //       label: 'Visa kundvagn',
                                                  //       onPressed: () {
                                                  //         // TODO: Show cart or scroll to cart
                                                  //       },
                                                  //     ),
                                                  //   ),
                                                  // );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.replay,
                                                size: 20,
                                              ),
                                              label: const Text('Beställ igen'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF6750A4,
                                                ),
                                                foregroundColor: Colors.white,
                                                elevation: 1.0,
                                                minimumSize: const Size(
                                                  140,
                                                  44,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppTheme.borderRadius,
                                                      ),
                                                ),
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
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

  void _saveValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
