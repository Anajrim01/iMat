import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class OrderHistoryEmptyState extends StatelessWidget {
  final VoidCallback onShopButtonPressed;

  const OrderHistoryEmptyState({
    required this.onShopButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Du har inga tidigare beställningar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dina beställningar kommer att visas här när du har handlat',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onShopButtonPressed,
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Börja handla'),
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