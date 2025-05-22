import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    final orders = handler.orders;

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
        children: [
          // Navigation buttons
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
                          _saveValue("showFavorites", false);
                          Navigator.pushNamed(context, '/');
                        },
                        icon: const Icon(
                          Icons.shopping_basket_outlined,
                          size: 24,
                        ),
                        label: Text('Handla'),
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
                          style: TextStyle(color: Colors.white),
                        ),
                        style: selectedButtonStyle.copyWith(
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
                          _saveValue('showFavorites', true);
                          Navigator.pushNamed(context, '/');
                        },
                        icon: const Icon(Icons.star_border_outlined, size: 24),
                        label: Text('Mina favoriter'),
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sort dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Sortera efter', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: 'Senaste först',
                  items:
                      [
                            'Senaste först',
                            'Äldsta först',
                            'Högsta pris',
                            'Lägsta pris',
                          ]
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
          ),

          // Order list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: orders.isEmpty ? 3 : orders.length,
              itemBuilder: (context, index) {
                final order = orders.isNotEmpty ? orders[index] : null;
                final sampleDate = DateTime.now().subtract(
                  Duration(days: index * 20 + 6),
                );

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    side: BorderSide(color: Colors.grey[300]!, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Orderdatum: ${DateFormat('yyyy-MM-dd').format(order?.date ?? sampleDate)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Ordernr: #${order?.orderNumber}'),
                                  SizedBox(height: 8),
                                  Text('Varor: ${order?.items.length}'),
                                  SizedBox(height: 8),
                                  Text(
                                    'Summa: ${(order == null ? 0.0 : order.items.fold<double>(0.0, (sum, item) => sum + (item.product.price * item.amount))).toStringAsFixed(2)} kr',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppTheme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(120, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppTheme.borderRadius,
                                      ),
                                    ),
                                  ),
                                  child: Text('Visa detaljer'),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    // Re-order logic
                                    if (order != null) {
                                      for (var item in order.items) {
                                        handler.shoppingCartAdd(item);
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Varorna har lagts till i kundvagnen',
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppTheme.borderRadius,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                      0xFF6750A4,
                                    ), // Purple
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(120, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppTheme.borderRadius,
                                      ),
                                    ),
                                  ),
                                  child: Text('Beställ igen'),
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
    );
  }

  void _saveValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
