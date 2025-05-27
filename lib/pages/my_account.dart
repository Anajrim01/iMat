import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/user.dart';
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
    _emailController.dispose();
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
        _verificationCodeController.text = creditCard.verificationCode.toString();
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
      _passwordController.text.trim()
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
      appBar: AppBar(title: const Text('My Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              if (_isEditing) ...[
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ] else ...[
                Text('Name: ${customer.firstName} ${customer.lastName}'),
                Text('Email: ${customer.email}'),
                Text('Lösenord: ${user.password}'),
              ],

              const SizedBox(height: 24),
              const Text(
                'Credit Card',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (_isEditing) ...[
                TextField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _cardTypeController,
                  decoration: const InputDecoration(labelText: 'Card Type'),
                ),
                TextField(
                  controller: _holdersNameController,
                  decoration: const InputDecoration(labelText: 'Holder\'s Name'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _validMonthController,
                        decoration: const InputDecoration(labelText: 'Month'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _validYearController,
                        decoration: const InputDecoration(labelText: 'Year'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _verificationCodeController,
                  decoration: const InputDecoration(labelText: 'Verification Code'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _saveChanges(context),
                  child: const Text('Save Changes'),
                ),
              ] else ...[
                Text('Card Number: ${creditCard?.cardNumber ?? 'N/A'}'),
                Text('Card Type: ${creditCard?.cardType ?? 'N/A'}'),
                Text('Holder: ${creditCard?.holdersName ?? 'N/A'}'),
                Text('Expires: ${creditCard?.validMonth}/${creditCard?.validYear}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _startEditing(customer, user, creditCard),
                  
                  child: const Text('Edit Account'),
                ),
                ElevatedButton(
                onPressed: () {
                print(iMatHandler.getCustomer().email);
                          },
                child: Text('Click Me'),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
