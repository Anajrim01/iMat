import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class OrderHistoryNavigationBar extends StatelessWidget {
  final VoidCallback onShopPressed;
  final VoidCallback onFavoritesPressed;

  const OrderHistoryNavigationBar({
    required this.onShopPressed,
    required this.onFavoritesPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle lightPurpleButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorScheme.secondary,
      foregroundColor: Colors.black,
      elevation: 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        side: BorderSide(color: Colors.deepPurple.shade100, width: 1.5),
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
        side: BorderSide(
          color: Colors.deepPurple.shade100,
          width: 0.5,
        ), // Light purple border
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
          ElevatedButton.icon(
            onPressed: onShopPressed,
            icon: const Icon(Icons.shopping_basket_outlined, size: 24),
            label: const Text('Handla'),
            style: lightPurpleButtonStyle,
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.access_time_outlined, size: 24),
            label: const Text('Tidigare beställningar'),
            style: selectedButtonStyle,
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: onFavoritesPressed,
            icon: const Icon(Icons.star_border_outlined, size: 24),
            label: const Text('Mina favoriter'),
            style: lightPurpleButtonStyle,
          ),
        ],
      ),
    );
  }
}
