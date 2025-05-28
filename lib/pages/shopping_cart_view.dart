import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/pages/auth_view.dart';
import 'package:imat_app/widgets/main/buyout_cart_bar.dart';
import 'package:imat_app/widgets/main/buyout_delivery.dart';
import 'package:imat_app/widgets/main/buyout_payment.dart';
import 'package:imat_app/model/imat/user_manager.dart';
import 'package:provider/provider.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({super.key});

  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
  int _currentStep = 1;
  String _deliveryTime = '';

  // Keys to access child widget states
  final GlobalKey<BuyoutDeliveryState> _deliveryKey =
      GlobalKey<BuyoutDeliveryState>();

  // Step information
  final List<Map<String, dynamic>> _steps = [
    {'number': 1, 'title': 'Varukorg', 'icon': Icons.shopping_cart},
    {'number': 2, 'title': 'Leverans', 'icon': Icons.local_shipping},
    {'number': 3, 'title': 'Betalning', 'icon': Icons.payment},
  ];

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable default back button
        toolbarHeight: 80,
        title: Row(
          children: [
            // iMat logo
            Row(
              children: [
                Text(
                  'I',
                  style: TextStyle(
                    color: AppTheme.colorScheme.primary,
                    fontSize: 50,
                  ),
                ),
                const Text('Mat', style: TextStyle(fontSize: 50)),
              ],
            ),

            const Spacer(),

            // Home button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home_outlined, size: 24),
              label: const Text(
                'Hem',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3E5F5),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step indicator bar
          _buildStepIndicator(),

          // Main content area
          Expanded(
            child:
                _currentStep == 1
                    ? BuyoutCartBar(handler: handler)
                    : _currentStep == 2
                    ? BuyoutDelivery(key: _deliveryKey)
                    : BuyoutPayment(handler: handler, deliveryTime: _deliveryTime),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildStepIndicator() {
    final userManager = context.watch<UserManager>();
    final bool isLoggedIn = userManager.isLoggedIn;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          SizedBox(
            child: TextButton(
              onPressed:
                  _currentStep > 1
                      ? () => _navigateToStep(_currentStep - 1)
                      : () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    _currentStep > 1 && _currentStep <= 2
                        ? _steps[_currentStep - 1]['title']
                        : 'Tillbaka',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          // Centered step indicator
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  _steps.map((step) {
                    final isActive = step['number'] == _currentStep;
                    final isCompleted = step['number'] < _currentStep;

                    return Row(
                      children: [
                        // Step indicator
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isCompleted || isActive
                                    ? Colors.green
                                    : Colors.grey.shade300,
                          ),
                          child: Center(
                            child:
                                isCompleted || isActive
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 26,
                                    )
                                    : Text(
                                      step['number'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                          ),
                        ),

                        // Step title
                        const SizedBox(width: 12),
                        Text(
                          step['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                isActive || isCompleted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isActive || isCompleted
                                    ? Colors.black
                                    : Colors.grey.shade700,
                          ),
                        ),

                        // Connector line
                        if (step['number'] < 3) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 30,
                            height: 3,
                            color:
                                isCompleted
                                    ? Colors.green
                                    : Colors.grey.shade300,
                          ),
                          const SizedBox(width: 12),
                        ],
                      ],
                    );
                  }).toList(),
            ),
          ),

          // Continue button
          SizedBox(
            width: 140,
            child: TextButton(
              onPressed:
                  _currentStep < 3
                      ? () => _validateAndNavigate(_currentStep + 1, isLoggedIn)
                      : null,
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              child:
                  _currentStep < 3
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _steps[_currentStep]['title'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 22),
                        ],
                      )
                      : Container(),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  // Validates the current step before allowing navigation to the next
  void _validateAndNavigate(int nextStep, bool isLoggedIn) {
    // If moving to delivery or payment, check if user is logged in
    if (_currentStep == 1 && nextStep == 2) {
      // Validate cart is not empty
      final handler = Provider.of<ImatDataHandler>(context, listen: false);
      if (handler.getShoppingCart().items.isEmpty) {
        _showValidationError(
          'Din varukorg är tom',
          'Lägg till produkter innan du fortsätter.',
        );
        return;
      }

      if (!isLoggedIn) {
        _showLoginPrompt(
          'Du måste logga in',
          'För att fortsätta till leverans behöver du logga in eller skapa ett konto.',
        );
        return;
      }

      // If cart has items, proceed to next step
      _navigateToStep(nextStep);
    }
    // If moving from delivery to payment
    else if (_currentStep == 2 && nextStep == 3) {
      // Access the delivery state via key
      final deliveryState = _deliveryKey.currentState;

      if (deliveryState != null) {
        bool hasAddress = deliveryState.hasValidAddress();
        bool hasDeliveryTime = deliveryState.hasSelectedTime();

        if (!hasAddress) {
          _showValidationError(
            'Leveransadress saknas',
            'Vänligen ange en leveransadress innan du fortsätter.',
          );
          return;
        }

        if (!hasDeliveryTime) {
          _showValidationError(
            'Leveranstid saknas',
            'Vänligen välj en leveranstid innan du fortsätter.',
          );
          return;
        }
        _deliveryTime = deliveryState.getSelectedTime();

        // All validations passed, proceed to next step
        _navigateToStep(nextStep);
      }
    }
  }

  void _showValidationError(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Text(message, style: const TextStyle(fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
    );
  }

  void _showLoginPrompt(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Text(message, style: const TextStyle(fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Show login dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AuthDialog();
                    },
                  ).then((_) {
                    // Refresh the state after login
                    setState(() {});
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                ),
                child: const Text('Logga in / Skapa konto'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
    );
  }
}
