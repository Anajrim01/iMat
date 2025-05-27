import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class FiltersChips extends StatelessWidget {
  final List<String> filtersList;
  final Function(String) onFilterTapped;
  final Color? chipColor;

  const FiltersChips({
    required this.filtersList,
    required this.onFilterTapped,
    this.chipColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (filtersList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children:
            filtersList.map((categoryValue) {
              return CustomFilterChip(
                label: categoryValue,
                onTap: () => onFilterTapped(categoryValue),
                backgroundColor: chipColor,
              );
            }).toList(),
      ),
    );
  }
}

class CustomFilterChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const CustomFilterChip({
    required this.label,
    required this.onTap,
    this.backgroundColor,
    super.key,
  });

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final Color enabledColor = AppTheme.colorScheme.primary;
    final Color disabledColor = AppTheme.colorScheme.secondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onTap();
      },
      child: Chip(
        label: Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
        backgroundColor: isSelected ? enabledColor : disabledColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
      ),
    );
  }
}
