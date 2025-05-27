import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/user.dart';

class BuyoutPayment extends StatefulWidget {
  final ImatDataHandler handler;
  const BuyoutPayment({required this.handler, super.key});

  @override
  State<BuyoutPayment> createState() => _BuyoutPaymentState();
}

class _BuyoutPaymentState extends State<BuyoutPayment> {
  final _cardTypeController = TextEditingController();
  final _holdersNameController = TextEditingController();
  final _validMonthController = TextEditingController();
  final _validYearController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = widget.handler.getShoppingCart();
    final totalAmount = cart.items.fold<double>(
      0,
      (sum, item) => sum + (item.amount * item.product.price),
    );

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 135),
          Expanded(
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 9),
                          child: Icon(
                            Icons.credit_card,
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Betala med kort",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildField(
                      label: "Korttyp",
                      controller: _cardTypeController,
                      hintText: "Visa/Mastercard",
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      label: "Korthållares namn",
                      controller: _holdersNameController,
                      hintText: "Namn som på kortet",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildField(
                            label: "Giltig till (månad)",
                            controller: _validMonthController,
                            hintText: "MM",
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: _buildField(
                            label: "År",
                            controller: _validYearController,
                            hintText: "ÅÅ",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      label: "Kortnummer",
                      controller: _cardNumberController,
                      hintText: "1234 5678 9012 3456",
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      label: "Verifikationskod",
                      controller: _verificationCodeController,
                      hintText: "CVV/CVC",
                      obscure: true,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 60),
          Container(
            padding: const EdgeInsets.fromLTRB(60, 40, 60, 0),
            width: 400,
            height: 430,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Totalt",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 2, height: 4),
                Row(
                  children: [
                    Text(
                      "${totalAmount.toStringAsFixed(2)} kr",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    String? trailingLabel,
    required TextEditingController controller,
    String? hintText,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.greenAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cardTypeController.dispose();
    _holdersNameController.dispose();
    _validMonthController.dispose();
    _validYearController.dispose();
    _cardNumberController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}