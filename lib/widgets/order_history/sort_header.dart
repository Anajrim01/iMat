import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class OrderSortHeader extends StatelessWidget {
  final int orderCount;
  final String currentSortOrder;
  final Function(String) onSortChanged;

  const OrderSortHeader({
    required this.orderCount,
    required this.currentSortOrder,
    required this.onSortChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Text(
            'Tidigare beställningar ($orderCount)',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Sort dropdown
          const Text(
            'Sortera efter:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadius,
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              value: currentSortOrder,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [
                'Senaste först',
                'Äldsta först',
                'Högsta pris',
                'Lägsta pris',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onSortChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}