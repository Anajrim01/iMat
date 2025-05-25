import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class ProductFilters extends StatelessWidget {
  final String title;
  final String sortOrder;
  final Function(String) onSortChanged;
  final bool showFavoritesOnly;
  final Function(bool) onShowFavoritesChanged;

  const ProductFilters({
    required this.title,
    required this.sortOrder,
    required this.onSortChanged,
    required this.showFavoritesOnly,
    required this.onShowFavoritesChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main heading and sort control
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Main heading text
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Sorting row
              Row(
                children: [
                  const Text(
                    'Sortera efter:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  _buildDropdown(sortOrder, [
                    'Pris lågt till högt',
                    'Pris högt till lågt',
                    'Alfabetisk ordning',
                  ], onSortChanged),
                ],
              ),
            ],
          ),
        ),

        // Category filter row
        Row(
          children: [
            const Text(
              'Typ av produkt:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            // Expanded(
            //   child: _buildDropdown(
            //     selectedCategory ?? 'Alla',
            //     ['Alla', ...availableCategories],
            //     (value) => onCategoryChanged(value == 'Alla' ? null : value),
            //     isExpanded: true,
            //   ),
            // ),
            const Spacer(),

            // Favorites toggle
            Row(
              children: [
                const Text(
                  'Endast favoriter:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: showFavoritesOnly,
                  onChanged: onShowFavoritesChanged,
                  activeColor: AppTheme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    Function(String) onChanged, {
    bool isExpanded = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        isExpanded: isExpanded,
        icon: const Icon(Icons.keyboard_arrow_down),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}
