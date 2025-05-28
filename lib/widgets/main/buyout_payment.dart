import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class BuyoutPayment extends StatefulWidget {
  final ImatDataHandler handler;
  final String deliveryTime;
  const BuyoutPayment({
    required this.handler,
    required this.deliveryTime,
    super.key,
  });

  @override
  State<BuyoutPayment> createState() => _BuyoutPaymentState();
}

class _BuyoutPaymentState extends State<BuyoutPayment> {
  final _cardHolderController = TextEditingController();
  final _cardNumber1Controller = TextEditingController();
  final _cardNumber2Controller = TextEditingController();
  final _cardNumber3Controller = TextEditingController();
  final _cardNumber4Controller = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _cvcController = TextEditingController();

  String _selectedCardType = 'Mastercard';
  final List<String> _cardTypes = ['Mastercard', 'Visa', 'American Express'];

  bool _hasExistingCard = false;
  bool _useExistingCard = false;
  bool _isProcessingPayment = false;

  Map<String, bool> _errors = {
    'cardHolder': false,
    'cardNumber': false,
    'expiry': false,
    'cvc': false,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedCardData();
  }

  void _loadSavedCardData() {
    final CreditCard savedCard = widget.handler.getCreditCard();

    if (savedCard.cardNumber.isNotEmpty) {
      _hasExistingCard = true;
      _useExistingCard = true;

      _selectedCardType = savedCard.cardType;
      _cardHolderController.text = savedCard.holdersName;

      final String cardNumber = savedCard.cardNumber;
      if (cardNumber.length >= 16) {
        _cardNumber1Controller.text = cardNumber.substring(0, 4);
        _cardNumber2Controller.text = cardNumber.substring(4, 8);
        _cardNumber3Controller.text = cardNumber.substring(8, 12);
        _cardNumber4Controller.text = cardNumber.substring(12, 16);
      }

      _monthController.text = savedCard.validMonth.toString();
      _yearController.text = savedCard.validYear.toString();
      _cvcController.text = savedCard.verificationCode.toString();
    }
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumber1Controller.dispose();
    _cardNumber2Controller.dispose();
    _cardNumber3Controller.dispose();
    _cardNumber4Controller.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.handler.getShoppingCart();
    final totalAmount = cart.items.fold<double>(
      0,
      (sum, item) => sum + (item.amount * item.product.price),
    );

    final customer = widget.handler.getCustomer();
    final deliveryAddress =
        '${customer.address}, ${customer.postCode} ${customer.postAddress}';

    final hasAddress =
        customer.address.isNotEmpty &&
        customer.postCode.isNotEmpty &&
        customer.postAddress.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 470,
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 24,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Betala med kort",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (_hasExistingCard) _buildSavedCardSection(),

                      if (!_hasExistingCard || !_useExistingCard)
                        _buildCardForm(),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _isProcessingPayment ? null : _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              _isProcessingPayment
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : const Text(
                                    "Betala köp",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            SizedBox(
              width: 300,
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Totalt",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 4),
                      Text(
                        "${totalAmount.toStringAsFixed(0)} kr",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        "Levereras till",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 4),
                      Text(
                        hasAddress ? deliveryAddress : "Ingen adress angiven",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: hasAddress ? Colors.black : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        "Tid för leverans",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 4),
                      Text(
                        widget.deliveryTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        "Varor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 4),

                      ...cart.items
                          .take(3)
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item.amount}× ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.product.name,
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${(item.amount * item.product.price).toStringAsFixed(0)} kr",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),

                      // show as number cuz too long
                      if (cart.items.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "+ ${cart.items.length - 3} fler varor",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCardSection() {
    final CreditCard savedCard = widget.handler.getCreditCard();
    final String lastFourDigits = savedCard.cardNumber.substring(12, 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sparat kort",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),

        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              _getCardIcon(savedCard.cardType),
              const SizedBox(width: 8),
              Text(
                "${savedCard.cardType} •••• $lastFourDigits",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          subtitle: Text(
            "${savedCard.holdersName} | Giltig till: ${savedCard.validMonth}/${savedCard.validYear}",
            style: const TextStyle(fontSize: 13),
          ),
          value: true,
          groupValue: _useExistingCard,
          activeColor: AppTheme.colorScheme.primary,
          onChanged: (value) {
            setState(() {
              _useExistingCard = true;
            });
          },
        ),

        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            "Använd ett nytt kort",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          value: false,
          groupValue: _useExistingCard,
          activeColor: AppTheme.colorScheme.primary,
          onChanged: (value) {
            setState(() {
              _useExistingCard = false;
            });
          },
        ),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Typ av kort",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCardType,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(8),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              items:
                  _cardTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Row(
                        children: [
                          _getCardIcon(type),
                          const SizedBox(width: 8),
                          Text(type),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedCardType = value;
                  });
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            const Text(
              "Kortinnehavare",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            if (_errors['cardHolder']!) ...[
              const SizedBox(width: 8),
              Text(
                "* Obligatoriskt fält",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _cardHolderController,
          hintText: "t.ex. Grupp Elva",
          hasError: _errors['cardHolder']!,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            const Text(
              "Kortnummer",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            if (_errors['cardNumber']!) ...[
              const SizedBox(width: 8),
              Text(
                "* Ogiltigt kortnummer",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _cardNumber1Controller,
                hintText: "1234",
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                hasError: _errors['cardNumber']!,
                onChanged: (value) {
                  if (value.length == 4) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text("—", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                controller: _cardNumber2Controller,
                hintText: "0000",
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                hasError: _errors['cardNumber']!,
                onChanged: (value) {
                  if (value.length == 4) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text("—", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                controller: _cardNumber3Controller,
                hintText: "0000",
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                hasError: _errors['cardNumber']!,
                onChanged: (value) {
                  if (value.length == 4) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text("—", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                controller: _cardNumber4Controller,
                hintText: "0000",
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                hasError: _errors['cardNumber']!,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Månad/År",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_errors['expiry']!) ...[
                        const SizedBox(width: 8),
                        Text(
                          "* Ogiltigt datum",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: _buildTextField(
                          controller: _monthController,
                          hintText: "MM",
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          textInputFormatter:
                              FilteringTextInputFormatter.digitsOnly,
                          hasError: _errors['expiry']!,
                          onChanged: (value) {
                            if (value.length == 2) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "/",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: _buildTextField(
                          controller: _yearController,
                          hintText: "ÅÅ",
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          textInputFormatter:
                              FilteringTextInputFormatter.digitsOnly,
                          hasError: _errors['expiry']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "CVC-kod",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_errors['cvc']!) ...[
                        const SizedBox(width: 8),
                        Text(
                          "* Obligatoriskt",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Tooltip(
                        message: "3-siffrig kod på baksidan av ditt kort",
                        child: Icon(
                          Icons.help_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: _buildTextField(
                      controller: _cvcController,
                      hintText: "CVC",
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      textInputFormatter:
                          FilteringTextInputFormatter.digitsOnly,
                      obscureText: true,
                      hasError: _errors['cvc']!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int? maxLength,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputFormatter? textInputFormatter,
    bool hasError = false,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      inputFormatters: textInputFormatter != null ? [textInputFormatter] : null,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.green.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.green,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  void _resetErrors() {
    setState(() {
      _errors = {
        'cardHolder': false,
        'cardNumber': false,
        'expiry': false,
        'cvc': false,
      };
    });
  }

  bool _validateForm() {
    _resetErrors();
    bool isValid = true;

    // Skip validation if using existing card
    if (_hasExistingCard && _useExistingCard) {
      return true;
    }

    // Validate card holder
    if (_cardHolderController.text.trim().isEmpty) {
      setState(() {
        _errors['cardHolder'] = true;
      });
      isValid = false;
    }

    // Validate card number
    if (_cardNumber1Controller.text.length != 4 ||
        _cardNumber2Controller.text.length != 4 ||
        _cardNumber3Controller.text.length != 4 ||
        _cardNumber4Controller.text.length != 4) {
      setState(() {
        _errors['cardNumber'] = true;
      });
      isValid = false;
    }

    // Validate expiry date
    final month = _monthController.text;
    final year = _yearController.text;

    if (month.isEmpty || year.isEmpty) {
      setState(() {
        _errors['expiry'] = true;
      });
      isValid = false;
    } else {
      final monthNum = int.tryParse(month);
      if (monthNum == null || monthNum < 1 || monthNum > 12) {
        setState(() {
          _errors['expiry'] = true;
        });
        isValid = false;
      }

      // Check if card is expired
      final currentYear = DateTime.now().year % 100; // Last two digits
      final currentMonth = DateTime.now().month;
      final yearNum = int.tryParse(year);

      if (yearNum == null ||
          yearNum < currentYear ||
          (yearNum == currentYear && monthNum! < currentMonth)) {
        setState(() {
          _errors['expiry'] = true;
        });
        isValid = false;
      }
    }

    // Validate CVC
    if (_cvcController.text.length < 3) {
      setState(() {
        _errors['cvc'] = true;
      });
      isValid = false;
    }

    return isValid;
  }

  void _processPayment() {
    final customer = widget.handler.getCustomer();
    final bool hasAddress =
        customer.address.isNotEmpty &&
        customer.postCode.isNotEmpty &&
        customer.postAddress.isNotEmpty;

    if (!hasAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Leveransadress saknas. Vänligen lägg till en adress."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate form if not using existing card
    if (!(_hasExistingCard && _useExistingCard) && !_validateForm()) {
      return;
    }

    // Show processing payment state
    setState(() {
      _isProcessingPayment = true;
    });

    // Save card data if we're using a new card
    if (!_useExistingCard) {
      final cardNumber =
          _cardNumber1Controller.text +
          _cardNumber2Controller.text +
          _cardNumber3Controller.text +
          _cardNumber4Controller.text;

      final creditCard = CreditCard(
        _selectedCardType,
        _cardHolderController.text.trim(),
        int.tryParse(_monthController.text.trim()) ?? 0,
        int.tryParse(_yearController.text.trim()) ?? 0,
        cardNumber,
        int.tryParse(_cvcController.text.trim()) ?? 0,
      );

      widget.handler.setCreditCard(creditCard);
    }
    widget.handler.placeOrder();
    setState(() {
      _isProcessingPayment = false;
    });

    _showOrderConfirmation();
  }

  void _showOrderConfirmation() {
    final handler = Provider.of<ImatDataHandler>(context, listen: false);
    final totalAmount = handler.getShoppingCart().items.fold<double>(
      0,
      (sum, item) => sum + (item.amount * item.product.price),
    );

    final orderRef = handler.orders.last.orderNumber;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  'Tack för din beställning!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Din beställning på ${totalAmount.toStringAsFixed(0)} kr är bekräftad.',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ordernummer: $orderRef',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Din beställning kommer att levereras enligt vald leveranstid.',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),
                const Text(
                  'En orderbekräftelse har skickats till din e-post.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tillbaka till butiken'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
    );
  }

  Widget _getCardIcon(String cardType) {
    IconData iconData;
    Color iconColor;

    switch (cardType) {
      case 'Mastercard':
        iconData = Icons.credit_card;
        iconColor = Colors.orange;
        break;
      case 'Visa':
        iconData = Icons.credit_card;
        iconColor = Colors.blue;
        break;
      case 'American Express':
        iconData = Icons.credit_card;
        iconColor = Colors.blueGrey;
        break;
      default:
        iconData = Icons.credit_card;
        iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor, size: 20);
  }
}
