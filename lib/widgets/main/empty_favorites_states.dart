import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class EmptyFavoritesState extends StatelessWidget {
  final VoidCallback onBrowseButtonPressed;

  const EmptyFavoritesState({required this.onBrowseButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Du har inga favoritprodukter ännu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Markera produkter med stjärnan för att lägga till dem som favoriter',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onBrowseButtonPressed,
            icon: const Icon(Icons.shopping_basket_outlined),
            label: const Text('Bläddra bland produkter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
