import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';



class CreateAccountView extends StatelessWidget {
  final VoidCallback onSwitchToLogin;

  CreateAccountView({super.key, required this.onSwitchToLogin});

  final _emailController = TextEditingController();
  final _ssnController = TextEditingController();
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
                      onPressed: onSwitchToLogin,
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
                      onPressed: () {}, // Lägg till logik här
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
                  label: "Personnummer - ",
                  trailingLabel: "Valfritt",
                  controller: _ssnController,
                  hintText: "YYYYMMDD-XXXX",
                ),
                const SizedBox(height: 8),
                _buildBulletText("Med ditt personnummer hämtar vi din adress automatiskt när du ska beställa hem mat."),

                const SizedBox(height: 20),

                
                _buildField(
                  label: "Lösenord",
                  controller: _passwordController,
                  hintText: "lösenord",
                  obscure: true,
                ),

                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementera konto skapande logiuk
                    },
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
                      "Skapa konto",
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

