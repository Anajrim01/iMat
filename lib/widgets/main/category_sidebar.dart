import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class CategorySidebar extends StatelessWidget {
  final List<dynamic> categories;
  final dynamic selectedCategory;
  final ValueChanged<dynamic> onCategorySelected;

  const CategorySidebar({
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
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              'Kategorier',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCategoryCard(
              categoryName: "Alla",
              isSelected: selectedCategory.isEmpty,
              onTap: () {
                onCategorySelected([]);
              },
            ),
          ),
          ...categories.map((cat) {
            final categoryName = cat.toString().split(".").last;
            final isSelected = selectedCategory.contains(cat);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildCategoryCard(
                categoryName: categoryName,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    onCategorySelected([]);
                  } else {
                    onCategorySelected([cat]);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String categoryName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final buttonColor =
        isSelected
            ? AppTheme.colorScheme.primary
            : AppTheme.colorScheme.secondary;
    final imagePath = _getCategoryImagePath(categoryName);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category image
            Image.asset(
              imagePath,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image not found
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Icon(
                    _getCategoryIcon(categoryName),
                    size: 60,
                    color: buttonColor.withValues(alpha: 0.7),
                  ),
                );
              },
            ),

            // Category button
            Container(
              color: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryImagePath(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'melons':
        return 'images/categories/melons.jpg';
      case 'flour_sugar_salt':
        return 'images/categories/flour_sugar_salt.jpg';
      case 'meat':
        return 'images/categories/meat.jpg';
      case 'dairies':
        return 'images/categories/dairies.jpg';
      case 'vegetable_fruit':
        return 'images/categories/vegetable_fruit.jpg';
      default:
        return '';
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      // Add icons for specific categories
      default:
        return Icons.category;
    }
  }
}
