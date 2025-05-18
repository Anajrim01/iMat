import 'package:flutter/material.dart';

class CategorySidebar extends StatelessWidget {
  final bool showFavorites;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectFavorites;

  const CategorySidebar({
    required this.showFavorites,
    required this.onSelectAll,
    required this.onSelectFavorites,
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
          ListTile(
            selected: showFavorites,
            title: const Text('Favoriter'),
            onTap: onSelectFavorites,
          ),
        ],
      ),
    );
  }
}