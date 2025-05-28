import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/util/functions.dart';

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
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppTheme.borderRadius),
          bottomRight: Radius.circular(AppTheme.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Kategorier',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1),
          ),

          // Scrollable list of categories
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildCategoryItem(
                  categoryName: "Alla produkter",
                  isSelected: selectedCategory.isEmpty,
                  onTap: () {
                    onCategorySelected([]);
                  },
                  icon: "all",
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(height: 1),
                ),

                ...categories.map((cat) {
                  final categoryName = cat.toString().split(".").last;
                  final isSelected = selectedCategory.contains(cat);
                  final normalizedName = normalizeString(categoryName);

                  return _buildCategoryItem(
                    categoryName: normalizedName,
                    isSelected: isSelected,
                    onTap: () {
                      if (isSelected) {
                        onCategorySelected([]);
                      } else {
                        onCategorySelected([cat]);
                      }
                    },
                    icon: categoryName.toLowerCase(),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required String categoryName,
    required bool isSelected,
    required VoidCallback onTap,
    required String icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.colorScheme.primaryContainer
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // SVG icon (or fallback to Material icon if SVG not available)
              _buildCategoryIcon(icon, isSelected),
              const SizedBox(width: 12),

              // Category name
              Expanded(
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected
                            ? AppTheme.colorScheme.primary
                            : Colors.black,
                  ),
                ),
              ),

              // Selected indicator
              if (isSelected)
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: AppTheme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String categoryName, bool isSelected) {
    final Color iconColor =
        isSelected ? AppTheme.colorScheme.primary : Colors.grey[600]!;
        
    // Path to the SVG icon
    final String iconPath = 'assets/icons/categories/${categoryName.toLowerCase()}.svg';
    
    // Use DefaultAssetBundle to check if the asset exists
    return FutureBuilder<bool>(
      future: _checkAssetExists(iconPath), // Workaround to check if the SVG exists as non-existent assets will throw an error (try catch won't work?)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && 
            snapshot.hasData && 
            snapshot.data == true) {
          // SVG exists, load it
          return SvgPicture.asset(
            iconPath,
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );
        } else {
          // SVG doesn't exist, use fallback
          return _getFallbackIcon(categoryName, iconColor);
        }
      },
    );
  }

  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Widget _getFallbackIcon(String categoryName, Color color) {
    return Icon(_getCategoryIcon(categoryName), size: 22, color: color);
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'all':
        return Icons.home;
      case 'bread':
        return Icons.bakery_dining;
      case 'dairy':
        return Icons.egg;
      case 'drinks':
        return Icons.local_drink;
      case 'fruit':
        return Icons.apple;
      case 'meat':
        return Icons.kebab_dining;
      case 'pantry':
        return Icons.kitchen;
      case 'snacks':
        return Icons.cookie;
      case 'sweet':
        return Icons.cake;
      case 'vegetables':
        return Icons.eco;
      default:
        return Icons.category;
    }
  }
}
