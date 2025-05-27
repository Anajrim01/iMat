import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CreateAccountView extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const CreateAccountView({super.key, required this.onSwitchToLogin});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  String? feedbackMessage;
  Color feedbackColor = Colors.transparent;

  Future<void> _createAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final address = _addressController.text.trim();

    if (email.isEmpty || password.isEmpty || address.isEmpty) {
      setState(() {
        feedbackMessage = "Alla fält måste fyllas i";
        feedbackColor = Colors.red[200]!;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_email') && prefs.getString('user_email') == email) {
      setState(() {
        feedbackMessage = "Konto finns redan för denna e-post";
        feedbackColor = Colors.red[200]!;
      });
      return;
    }

    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    await prefs.setString('user_address', address);

    setState(() {
      feedbackMessage = "Konto skapat! Du kan nu logga in.";
      feedbackColor = Colors.green[200]!;
    });

    
    Future.delayed(const Duration(seconds: 1), widget.onSwitchToLogin);
  }

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
               
                if (feedbackMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: feedbackColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          feedbackColor == Colors.green[200]
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feedbackMessage!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Skapa ditt konto",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      onPressed: widget.onSwitchToLogin,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingLarge,
                          vertical: AppTheme.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
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
                      onPressed: _createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.paddingLarge,
                          vertical: AppTheme.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
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

                
                _buildField(
                  label: "E-postadress/Användarnamn",
                  controller: _emailController,
                  hintText: "name@gmail.com",
                ),
                const SizedBox(height: 8),
                _buildBulletText("Detta kommer vara ditt användar-id när du loggar in"),

                const SizedBox(height: 20),

               
                _buildField(
                  label: "Adress",
                  controller: _addressController,
                  hintText: "Storgatan 1, 123 45 Stad",
                ),
                const SizedBox(height: 8),
                _buildBulletText("Vi använder din adress för hemleverans av mat."),

                const SizedBox(height: 20),

                
                _buildField(
                  label: "Lösenord",
                  controller: _passwordController,
                  hintText: "lösenord",
                  obscure: true,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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




