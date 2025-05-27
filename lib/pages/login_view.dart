import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_view.dart';



class LoginView extends StatefulWidget {
  final VoidCallback onSwitchToRegister;

  const LoginView({super.key, required this.onSwitchToRegister});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Fyll i både e-post och lösenord";
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPassword = prefs.getString('user_password');

    if (savedEmail == null || savedPassword == null) {
      setState(() {
        _errorMessage = "Inget konto är registrerat";
      });
      return;
    }

    if (email != savedEmail) {
      setState(() {
        _errorMessage = "Ingen användare hittades med denna e-post";
      });
      return;
    }

    if (password != savedPassword) {
      setState(() {
        _errorMessage = "Fel lösenord – försök igen";
      });
      return;
    }

    
    setState(() {
      _errorMessage = null;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(AppTheme.paddingHuge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              color: Colors.grey[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Logga in",
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
                    ElevatedButton(
                      onPressed: _login,
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
                      child: const Text("Logga in", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: AppTheme.paddingLarge),
                    OutlinedButton(
                      onPressed: widget.onSwitchToRegister,
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
                      child: Text("Skapa konto", style: TextStyle(color: AppTheme.colorScheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                _buildField(
                  label: "E-postadress/Användarnamn",
                  controller: _emailController,
                  hintText: "name@gmail.com",
                ),
                const SizedBox(height: 20),

                _buildField(
                  label: "Lösenord",
                  controller: _passwordController,
                  hintText: "lösenord",
                  obscure: true,
                ),

                const SizedBox(height: 24),

               
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                Center(
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingHuge,
                        vertical: AppTheme.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      ),
                      textStyle: AppTheme.textTheme.bodyLarge,
                    ),
                    child: const Text("Logga in", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
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
}







