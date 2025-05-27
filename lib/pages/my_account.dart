import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/user.dart';
import 'package:imat_app/model/imat/util/functions.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool _isEditing = false;

  // Controllers för kundinformation
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mobilePhoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _adressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _postAdressController = TextEditingController();

  // Password controller
  final _passwordController = TextEditingController();

  // Controllers för kortinformation
  final _cardTypeController = TextEditingController();
  final _holdersNameController = TextEditingController();
  final _validMonthController = TextEditingController();
  final _validYearController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _mobilePhoneNumberController.dispose();
    _emailController.dispose();
    _adressController.dispose();
    _postCodeController.dispose();
    _postAdressController.dispose();
    _passwordController.dispose();
    _cardTypeController.dispose();
    _holdersNameController.dispose();
    _validMonthController.dispose();
    _validYearController.dispose();
    _cardNumberController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _startEditing(customer, user, creditCard) {
    setState(() {
      _isEditing = true;

      // Init kundfält
      _firstNameController.text = customer.firstName;
      _lastNameController.text = customer.lastName;
      _phoneNumberController.text = customer.phoneNumber;
      _mobilePhoneNumberController.text = customer.mobilePhoneNumber;
      _emailController.text = customer.email;
      _adressController.text = customer.address;
      _postCodeController.text = customer.postCode;
      _postAdressController.text = customer.postAddress;

      // Init password
      _passwordController.text = user.password;

      // Init kortfält
      if (creditCard != null) {
        _cardTypeController.text = creditCard.cardType;
        _holdersNameController.text = creditCard.holdersName;
        _validMonthController.text = creditCard.validMonth.toString();
        _validYearController.text = creditCard.validYear.toString();
        _cardNumberController.text = creditCard.cardNumber;
        _verificationCodeController.text =
            creditCard.verificationCode.toString();
      }
    });
  }

  void _saveChanges(BuildContext context) {
    final iMatHandler = Provider.of<ImatDataHandler>(context, listen: false);

    // Uppdatera kunddata
    final updateCustomer = Customer(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _phoneNumberController.text.trim(),
      _mobilePhoneNumberController.text.trim(),
      _emailController.text.trim(),
      _adressController.text.trim(),
      _postCodeController.text.trim(),
      _postAdressController.text.trim(),
    );
    iMatHandler.setCustomer(updateCustomer);

    //Måste också uppdatera user
    final updateUser = User(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    iMatHandler.setUser(updateUser);

    // Uppdatera kortdata
    final newCard = CreditCard(
      _cardTypeController.text.trim(),
      _holdersNameController.text.trim(),
      int.tryParse(_validMonthController.text) ?? 0,
      int.tryParse(_validYearController.text) ?? 0,
      _cardNumberController.text.trim(),
      int.tryParse(_verificationCodeController.text) ?? 0,
    );
    iMatHandler.setCreditCard(newCard);

    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final iMatHandler = Provider.of<ImatDataHandler>(context);
    final customer = iMatHandler.getCustomer();
    final creditCard = iMatHandler.getCreditCard();
    final user = iMatHandler.getUser();

    return Scaffold(
      appBar: const CustomMyAccountAppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page title
                const Text(
                  'Mitt Konto',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 2, height: 32),
                const SizedBox(height: 24),

                // Personal information section
                _buildSectionCard('Personuppgifter', [
                  if (_isEditing) ...[
                    _buildFormRow([
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          label: 'Förnamn',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          label: 'Efternamn',
                        ),
                      ),
                    ]),
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-post',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Lösenord',
                      obscureText: true,
                    ),
                    _buildFormRow([
                      Expanded(
                        child: _buildTextField(
                          controller: _phoneNumberController,
                          label: 'Telefon',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _mobilePhoneNumberController,
                          label: 'Mobil',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ]),
                  ] else ...[
                    _buildInfoRow(
                      'Namn',
                      '${customer.firstName} ${customer.lastName}',
                    ),
                    _buildInfoRow('E-post', customer.email),
                    _buildInfoRow('Lösenord', '••••••••'),
                    _buildFormRow([
                      Expanded(
                        child: _buildInfoRow('Telefon', customer.phoneNumber),
                      ),
                      Expanded(
                        child: _buildInfoRow(
                          'Mobil',
                          customer.mobilePhoneNumber,
                        ),
                      ),
                    ]),
                  ],
                ]),

                const SizedBox(height: 24),

                // Address section
                _buildSectionCard('Leveransadress', [
                  if (_isEditing) ...[
                    _buildTextField(
                      controller: _adressController,
                      label: 'Gatuadress',
                    ),
                    _buildFormRow([
                      Expanded(
                        child: _buildTextField(
                          controller: _postCodeController,
                          label: 'Postnummer',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _postAdressController,
                          label: 'Ort',
                        ),
                      ),
                    ]),
                  ] else ...[
                    _buildInfoRow('Adress', customer.address),
                    _buildFormRow([
                      Expanded(
                        child: _buildInfoRow('Postnummer', customer.postCode),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildInfoRow('Ort', customer.postAddress),
                      ),
                    ]),
                  ],
                ]),

                const SizedBox(height: 24),

                // Payment information section
                _buildSectionCard('Betalningsinformation', [
                  if (_isEditing) ...[
                    _buildTextField(
                      controller: _cardNumberController,
                      label: 'Kortnummer',
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _holdersNameController,
                      label: 'Kortinnehavare',
                    ),
                    _buildFormRow([
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value:
                              _cardTypeController.text.isEmpty
                                  ? null
                                  : _cardTypeController.text,
                          decoration: InputDecoration(
                            labelText: 'Korttyp',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.borderRadius,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Visa',
                              child: Text('Visa'),
                            ),
                            DropdownMenuItem(
                              value: 'Mastercard',
                              child: Text('Mastercard'),
                            ),
                            DropdownMenuItem(
                              value: 'American Express',
                              child: Text('American Express'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _cardTypeController.text = value;
                            }
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildFormRow([
                      Expanded(
                        child: _buildTextField(
                          controller: _validMonthController,
                          label: 'Månad',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _validYearController,
                          label: 'År',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _verificationCodeController,
                          label: 'CVC',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ]),
                  ] else if (creditCard.cardNumber.isNotEmpty) ...[
                    _buildInfoRow(
                      'Kortnummer',
                      formatCardNumber(creditCard.cardNumber),
                    ),
                    _buildInfoRow('Kortinnehavare', creditCard.holdersName),
                    _buildInfoRow(
                      'Korttyp',
                      detectCardType(creditCard.cardNumber) ??
                          creditCard.cardType,
                    ),
                    _buildFormRow([
                      Expanded(
                        child: _buildInfoRow(
                          'Giltigt till',
                          '${creditCard.validMonth}/${creditCard.validYear}',
                        ),
                      ),
                      Expanded(child: _buildInfoRow('CVC', '***')),
                    ]),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.credit_card_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Inget betalkort tillagt',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Klicka på "Redigera uppgifter" för att lägga till betalinformation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ]),

                const SizedBox(height: 32),

                // Action buttons
                Center(
                  child: SizedBox(
                    width: 300,
                    child:
                        _isEditing
                            ? Row(
                              children: [
                                Expanded(
                                  child: _buildButton(
                                    'Avbryt',
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    },
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildButton(
                                    'Spara',
                                    onPressed: () => _saveChanges(context),
                                  ),
                                ),
                              ],
                            )
                            : _buildButton(
                              'Redigera uppgifter',
                              onPressed:
                                  () =>
                                      _startEditing(customer, user, creditCard),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.purple[100],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
      ),
      child: Text(text),
    );
  }
}

class CustomMyAccountAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomMyAccountAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            'I',
            style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 50),
          ),
          const Text('Mat', style: TextStyle(fontSize: 50)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home_outlined, size: 24),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3E5F5),
              foregroundColor: Colors.black,
              elevation: 2,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              fixedSize: Size(170, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Text('Hem'),
            ),
          ),
        ],
      ),
    );
  }
}
