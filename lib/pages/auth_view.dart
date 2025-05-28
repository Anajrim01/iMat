import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/user_manager.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool _showLogin = true;
  bool _isCreatingAccount = false;

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobilePhoneNumberController = TextEditingController();

  // Error states
  String? _emailError;
  String? _passwordError;
  String? _phoneError;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
      // Clear fields and errors when switching views
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _mobilePhoneNumberController.clear();
      _emailError = null;
      _passwordError = null;
      _phoneError = null;
    });
  }

  bool _validateLoginForm() {
    bool isValid = true;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Validate email
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "E-postadress krävs";
      });
      isValid = false;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Lösenord krävs";
      });
      isValid = false;
    }

    return isValid;
  }

  bool _validateRegisterForm() {
    bool isValid = true;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Validate email
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "E-postadress krävs";
      });
      isValid = false;
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text)) {
      setState(() {
        _emailError = "Ange en giltig e-postadress";
      });
      isValid = false;
    }

    // Validate phone number
    if (_mobilePhoneNumberController.text.isNotEmpty &&
        !RegExp(
          r'^(?:\+?46|0)[0-9]{7,12}$',
        ).hasMatch(_mobilePhoneNumberController.text)) {
      setState(() {
        _phoneError = "Ange ett giltigt telefonnummer";
      });
      isValid = false;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Lösenord krävs";
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = "Lösenordet måste vara minst 6 tecken";
      });
      isValid = false;
    }

    // Validate password confirmation
    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _passwordError = "Lösenorden matchar inte";
      });
      isValid = false;
    }

    return isValid;
  }

  void _login() {
    if (_validateLoginForm()) {
      final userManager = Provider.of<UserManager>(context, listen: false);
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final imatHandler = Provider.of<ImatDataHandler>(context, listen: false);
      final user = imatHandler.getUser();

      if (user.userName == email && user.password == password) {
        userManager.logIn();
        Navigator.of(context).pop();
      } else {
        setState(() {
          _emailError = "Fel e-post eller lösenord";
          _passwordError = "Fel e-post eller lösenord";
        });
      }
    }
  }

  void _register() {
    if (_validateRegisterForm()) {
      setState(() {
        _isCreatingAccount = true;
      });

      // simulated delay to mimic account creation and it looks better :v
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        final userManager = Provider.of<UserManager>(context, listen: false);
        final imatHandler = Provider.of<ImatDataHandler>(
          context,
          listen: false,
        );

        final user = imatHandler.getUser();
        user.userName = _emailController.text.trim();
        user.password = _passwordController.text.trim();
        imatHandler.setUser(user);

        if (_firstNameController.text.isNotEmpty ||
            _lastNameController.text.isNotEmpty) {
          final customer = imatHandler.getCustomer();
          customer.firstName = _firstNameController.text.trim();
          customer.lastName = _lastNameController.text.trim();
          customer.email = _emailController.text.trim();
          customer.phoneNumber = _mobilePhoneNumberController.text.trim();
          customer.mobilePhoneNumber = _mobilePhoneNumberController.text.trim();
          imatHandler.setCustomer(customer);
        }

        userManager.logIn();

        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      elevation: 8,
      child: Container(
        width: 480,
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'I',
                        style: TextStyle(
                          color: AppTheme.colorScheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Mat',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            _showLogin ? _buildLoginForm() : _buildRegisterForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            "Logga in på ditt konto",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Wrap(
            alignment: WrapAlignment.start,
            children: [
              Text(
                "Ange dina uppgifter nedan för att logga in. ",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              Text(
                "Ny kund? ",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              GestureDetector(
                onTap: _toggleView,
                child: Text(
                  "Skapa nytt konto här",
                  style: TextStyle(
                    color: AppTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Email field
          _buildTextField(
            controller: _emailController,
            label: "E-postadress",
            hintText: "t.ex. grupp.elva@exempel.se",
            icon: Icons.email_outlined,
            errorText: _emailError,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          // Password field
          _buildTextField(
            controller: _passwordController,
            label: "Lösenord",
            hintText: "Ditt lösenord",
            icon: Icons.lock_outline,
            errorText: _passwordError,
            obscureText: true,
          ),

          const SizedBox(height: 24),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              child: const Text(
                "Logga in",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // tos text
          Center(
            child: Text(
              "Genom att logga in godkänner du våra användarvillkor och integritetspolicy.",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
      child:
          _isCreatingAccount
              ? _buildCreatingAccountState()
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Skapa nytt konto",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        "Fyll i dina uppgifter nedan. ",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      Text(
                        "Befintlig kund? ",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: _toggleView,
                        child: Text(
                          "Logga in här",
                          style: TextStyle(
                            color: AppTheme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          label: "Förnamn",
                          hintText: "t.ex. Grupp",
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          label: "Efternamn",
                          hintText: "t.ex. Elva",
                          icon: Icons.person_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _emailController,
                    label: "E-postadress",
                    hintText: "t.ex. grupp.elva@exempel.se",
                    icon: Icons.email_outlined,
                    errorText: _emailError,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _mobilePhoneNumberController,
                    label: "Mobilnummer",
                    hintText: "t.ex. +46701234567",
                    icon: Icons.phone_android_outlined,
                    errorText: _phoneError,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _passwordController,
                    label: "Lösenord",
                    hintText: "Minst 6 tecken",
                    icon: Icons.lock_outline,
                    errorText: _passwordError,
                    obscureText: true,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: "Bekräfta lösenord",
                    hintText: "Upprepa lösenord",
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.borderRadius,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Skapa konto",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // tos text
                  Center(
                    child: Text(
                      "Genom att skapa ett konto godkänner du våra användarvillkor och integritetspolicy.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildCreatingAccountState() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.green),
          const SizedBox(height: 24),
          const Text(
            "Skapar ditt konto...",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Ett ögonblick, vi ställer in ditt konto.",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            errorText: errorText,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: BorderSide(color: AppTheme.colorScheme.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              borderSide: const BorderSide(color: Colors.red),
            ),
            errorStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
