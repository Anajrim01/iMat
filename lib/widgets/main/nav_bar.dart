import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/user_manager.dart';
import 'package:imat_app/login_prompt.dart';
import 'package:provider/provider.dart';

class MainNavigationBar extends StatefulWidget {
  final bool showingFavorites;
  final VoidCallback onShopPressed;
  final VoidCallback onOrderHistoryPressed;
  final VoidCallback onFavoritesPressed;

  const MainNavigationBar({
    required this.showingFavorites,
    required this.onShopPressed,
    required this.onOrderHistoryPressed,
    required this.onFavoritesPressed,
    super.key,
  });

  @override
  _MainNavigationBarState createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    final bool isLoggedIn = userManager.isLoggedIn;

    // Button styles
    final ButtonStyle lightPurpleButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.secondary,
      foregroundColor: Colors.black,
      elevation: 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.deepPurple.shade100, width: 0.5),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

    final ButtonStyle selectedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 2.0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.deepPurple.shade100, width: 0.5),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Shop button
          ElevatedButton.icon(
            onPressed: widget.onShopPressed,
            icon: const Icon(Icons.shopping_basket_outlined, size: 24),
            label: const Text('Handla'),
            style:
                widget.showingFavorites
                    ? lightPurpleButtonStyle
                    : selectedButtonStyle,
          ),
          const SizedBox(width: 16),

          // Order history button
          ElevatedButton.icon(
            onPressed: () {
              if (!isLoggedIn) {
                LoginPromptDialog.show(
                  context,
                  'Logga in för att se beställningar',
                  'Du måste vara inloggad för att se dina tidigare beställningar.',
                );
                return;
              }
              widget.onOrderHistoryPressed();
            },
            icon: const Icon(Icons.access_time, size: 24),
            label: const Text('Tidigare beställningar'),
            style: lightPurpleButtonStyle,
          ),
          const SizedBox(width: 16),

          // Favorites button
          ElevatedButton.icon(
            onPressed: () {
              if (!isLoggedIn) {
                LoginPromptDialog.show(
                  context,
                  'Logga in för att se favoriter',
                  'Du måste vara inloggad för att se dina sparade favoriter.',
                );
                return;
              }
              widget.onFavoritesPressed();
            },
            icon: const Icon(Icons.star_border_outlined, size: 24),
            label: const Text('Mina favoriter'),
            style:
                widget.showingFavorites
                    ? selectedButtonStyle
                    : lightPurpleButtonStyle,
          ),
        ],
      ),
    );
  }
}
