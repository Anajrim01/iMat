import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart' show ImatDataHandler;
import 'package:imat_app/pages/main_view.dart';
import 'package:imat_app/widgets/main/user_manager.dart';
import 'package:provider/provider.dart';



class LoginView extends StatelessWidget {
  final VoidCallback onSwitchToRegister;

  const LoginView({super.key, required this.onSwitchToRegister});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

  void _login() {
  final userManager = Provider.of<UserManager>(context, listen: false);
  final email = _emailController.text.trim();
  final password = _passwordController.text;
  final imatHandler = Provider.of<ImatDataHandler>(context, listen: false);
  final user = imatHandler.getUser();

  if (user != null && user.userName == email && user.password == password) {
    userManager.logIn();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainView()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fel e-post eller lösenord")),
    );
  }
}


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
                // Rubrik + Stäng
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

                // Knapp-rad
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {}, // Aktiv knapp
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
                        "Logga in",
                        style: TextStyle(color: Colors.white), // vit text
                      ),
                    ),
                    const SizedBox(width: AppTheme.paddingLarge),
                    OutlinedButton(
                      onPressed: onSwitchToRegister,
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
                        "Skapa konto",
                        style: TextStyle(color: AppTheme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // E-post
                _buildField(
                  label: "E-postadress/Användarnamn",
                  controller: _emailController,
                  hintText: "name@gmail.com",
                ),
                const SizedBox(height: 20),

                // Lösenord
                _buildField(
                  label: "Lösenord",
                  controller: _passwordController,
                  hintText: "lösenord",
                  obscure: true,
                ),

                const SizedBox(height: 32),
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
                    child: const Text(
                      "Logga in",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
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



