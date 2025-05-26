import 'package:flutter/material.dart';
import 'package:imat_app/pages/create_account_view.dart';
import 'package:imat_app/pages/login_view.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool _showLogin = true;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: _showLogin
            ? LoginView(onSwitchToRegister: _toggleView)
            : CreateAccountView(onSwitchToLogin: _toggleView),
      ),
    );
  }
}

