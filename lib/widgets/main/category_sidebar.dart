import 'package:flutter/material.dart';

class CategorySidebar extends StatelessWidget {
  final bool showFavorites;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectFavorites;
  final List<dynamic> categories;
  final dynamic selectedCategory;
  final ValueChanged<dynamic> onCategorySelected;

  const CategorySidebar({
    required this.showFavorites,
    required this.onSelectAll,
    required this.onSelectFavorites,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView(
        children: [
          ListTile(
            selected: !showFavorites,
            title: const Text('Allt'),
            onTap: onSelectAll,
          ),
          const Divider(),

          ...categories.map((cat){ final isSelected = selectedCategory.contains(cat);
            return ListTile(
              selected: isSelected,
              title: Text(cat.toString().split(".").last),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () { final updated= List<dynamic>.from(selectedCategory);
                if (isSelected) {
                  updated.remove(cat);
                } else {
                  updated.add(cat);
                }
                onCategorySelected(updated);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}