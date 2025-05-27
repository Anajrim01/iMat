import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/user.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CreateAccountView extends StatelessWidget {
  final VoidCallback onSwitchToLogin;

  CreateAccountView({super.key, required this.onSwitchToLogin});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mobilePhoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _adressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _postAdressController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Skapa ditt konto",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    OutlinedButton(
                      onPressed: onSwitchToLogin,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingLarge,
                          vertical: AppTheme.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                        ),
                        textStyle: AppTheme.textTheme.headlineSmall,
                      ),
                      child: Text(
                        "Logga in",
                        style: TextStyle(color: AppTheme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {}, // Lägg till logik här
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingLarge,
                          vertical: AppTheme.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                        ),
                        textStyle: AppTheme.textTheme.headlineSmall,
                      ),
                      child: const Text(
                        "Skapa konto",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        label: "Förnamn",
                        controller: _firstNameController,
                        hintText: "namn",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildField(
                        label: "Efternamn",
                        controller: _lastNameController,
                        hintText: "efternamn",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        label: "E-postadress/Användarnamn",
                        controller: _emailController,
                        hintText: "namn@gmail.com",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildField(
                        label: "Lösenord",
                        controller: _passwordController,
                        hintText: "lösenord",
                        obscure: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                _buildBulletText(
                  "Detta kommer vara ditt användar-id när du loggar in",
                ),

                /*    IntlPhoneField(
              decoration: InputDecoration(
               border: OutlineInputBorder(
              borderSide: BorderSide(), //Cool inlogg grej
              ),
              ),
              
              controller: _mobilePhoneNumberController,
              initialCountryCode: 'SE',
              onChanged: (phone) {
               print(phone.completeNumber);
               },
              ),*/
                const SizedBox(height: 20),
                _buildField(
                  label: "Mobilnummer",
                  controller: _mobilePhoneNumberController,
                  hintText: "123-456-7890",
                ),

                _buildField(
                  label: "Nummer",
                  controller: _phoneNumberController,
                  hintText: "123-456-7890",
                ),

                _buildField(
                  label: "Adress",
                  controller: _adressController,
                  hintText: "12-345",
                ),
                _buildField(
                  label: "Postkod",
                  controller: _postCodeController,
                  hintText: "12-345",
                ),
                _buildField(
                  label: "Postadress",
                  controller: _postAdressController,
                  hintText: "123-456-7890",
                ),

                const SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      var iMatHandler = Provider.of<ImatDataHandler>(
                        context,
                        listen: false,
                      );
                      // Create the Customer object from the input fields
                      Customer newCustomer = Customer(
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                        _phoneNumberController.text.trim(),
                        _mobilePhoneNumberController.text.trim(),
                        _emailController.text.trim(),
                        _adressController.text.trim(),
                        _postCodeController.text.trim(),
                        _postAdressController.text.trim(),
                      );

                      User newUser = User(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      // Set the customer and user using the handler
                      iMatHandler.setCustomer(newCustomer);
                      iMatHandler.setUser(newUser);

                      // Optionally show confirmation or navigate to another screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kundinformation sparad!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingHuge,
                        vertical: AppTheme.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadiusLarge,
                        ),
                      ),
                      textStyle: AppTheme.textTheme.bodyLarge,
                    ),
                    child: const Text(
                      "Skapa konto",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            if (trailingLabel != null)
              Text(
                trailingLabel,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
          ],
        ),
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

  Widget _buildBulletText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 16)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
