import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class FiltersChips extends StatelessWidget {
  final List<dynamic> categoryFilters;
  final Function(dynamic) onRemoveFilter;

  const FiltersChips({
    required this.categoryFilters,
    required this.onRemoveFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children:
            categoryFilters.map((categoryValue) {
              return Chip(
                label: Text(
                  categoryValue.toString().split('.').last,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onDeleted: () => onRemoveFilter(categoryValue),
                deleteIconColor: Colors.black54,
                backgroundColor: Colors.blueGrey[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              );
            }).toList(),
      ),
    );
  }
}
