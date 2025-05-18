import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String sortOrder;
  final dynamic category;
  final List<dynamic> categories;
  final bool showFavoritesOnly;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<dynamic> onCategoryChanged;
  final ValueChanged<bool> onShowFavsChanged;

  const FilterBar({
    required this.sortOrder,
    required this.category,
    required this.categories,
    required this.showFavoritesOnly,
    required this.onSortChanged,
    required this.onCategoryChanged,
    required this.onShowFavsChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sorteringsdropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sortera efter',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: sortOrder,
              items: const [
                DropdownMenuItem(
                  value: 'Pris lågt till högt',
                  child: Text('Lågt→högt'),
                ),
                DropdownMenuItem(
                  value: 'Pris högt till lågt',
                  child: Text('Högt→lågt'),
                ),
              ],
              onChanged: (v) => onSortChanged(v!),
            ),
          ],
        ),
        const SizedBox(width: 24),

        // Kategoridropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Typ av frukt',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<dynamic>(
              hint: const Text('Alla'),
              value: category,
              items: [
                const DropdownMenuItem(value: null, child: Text('Alla')),
                ...categories.map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.toString().split('.').last),
                  ),
                ),
              ],
              onChanged: onCategoryChanged,
            ),
          ],
        ),
        const Spacer(),

        // Favorit‐toggle
        Row(
          children: [
            const Text('Endast favoriter'),
            Switch(value: showFavoritesOnly, onChanged: onShowFavsChanged),
          ],
        ),
      ],
    );
  }
}
