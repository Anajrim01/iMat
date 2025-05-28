import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class LoginDeliveyPopup extends StatefulWidget {
  const LoginDeliveyPopup({super.key});

  @override
  State<LoginDeliveyPopup> createState() => LoginDeliveyPopupState();
}

class LoginDeliveyPopupState extends State<LoginDeliveyPopup> {
  final _adressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _postAdressController = TextEditingController();

  String? _addressError;

  @override
  void initState() {
    super.initState();
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);
    final customer = iMatHandler.getCustomer();
    if (customer.address.isNotEmpty) {
      _adressController.text = customer.address;
    }
    if (customer.postCode.isNotEmpty) {
      _postCodeController.text = customer.postCode;
    }
    if (customer.postAddress.isNotEmpty) {
      _postAdressController.text = customer.postAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    final handler = context.watch<ImatDataHandler>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.borderRadius),
                  topRight: Radius.circular(AppTheme.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 32, color: Colors.green),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Välj leveransadress',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ange adressen där du vill få dina varor levererade',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fyll i din leveransadress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Address field
                  _buildField(
                    label: "Gatuadress",
                    controller: _adressController,
                    hintText: "t.ex. Storgatan 1",
                    errorText: _addressError,
                    prefixIcon: Icons.home,
                  ),

                  const SizedBox(height: 16),

                  // Postal code and city in a row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildField(
                          label: "Postnummer",
                          controller: _postCodeController,
                          hintText: "t.ex. 123 45",
                          prefixIcon: Icons.markunread_mailbox,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: _buildField(
                          label: "Ort",
                          controller: _postAdressController,
                          hintText: "t.ex. Stockholm",
                          prefixIcon: Icons.location_city,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stored addresses section
            if (handler.getCustomer().address.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Sparade adresser',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List of saved addresses
                    // TODO: Support for multiple saved addresses?
                    // Currently only one saved address is shown
                    // You only live at one place, right?
                    _buildSavedAddressCard(
                      "Hemadress",
                      // Address Postkod Ort
                      "${handler.getCustomer().address}, ${handler.getCustomer().postCode} ${handler.getCustomer().postAddress}",
                      Icons.home,
                      isSelected: false,
                      onSelect: () {
                        _adressController.text = handler.getCustomer().address;
                        _postCodeController.text =
                            handler.getCustomer().postCode;
                        _postAdressController.text =
                            handler.getCustomer().postAddress;
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Avbryt',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_adressController.text.trim().isEmpty) {
                          setState(() {
                            _addressError = "Vänligen ange en adress";
                          });
                          return;
                        }
                        saveInfo();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                        ),
                      ),
                      child: const Text('Spara adress'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedAddressCard(
    String title,
    String address,
    IconData icon, {
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          color: isSelected ? Colors.green.withValues(alpha: 0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green.shade800 : Colors.black,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isSelected ? Colors.green.shade800 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  void saveInfo() {
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);
    final customer = iMatHandler.getCustomer();
    final address = _adressController.text.trim();
    final postCode = _postCodeController.text.trim();
    final postAddress = _postAdressController.text.trim();

    // Update customer data
    final updateCustomer = Customer(
      customer.firstName,
      customer.lastName,
      customer.phoneNumber,
      customer.mobilePhoneNumber,
      customer.email,
      address,
      postCode,
      postAddress,
    );
    iMatHandler.setCustomer(updateCustomer);
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
