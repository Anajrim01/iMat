import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingSmall),
      child: Row(
        children: [
          // Sorteringsdropdown
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sortera efter',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: sortOrder,
                  items: const [
                    DropdownMenuItem(
                      value: 'Pris lågt till högt',
                      child: Text('Pris ↑'),
                    ),
                    DropdownMenuItem(
                      value: 'Pris högt till lågt',
                      child: Text('Pris ↓'),
                    ),
                  ],
                  onChanged: (v) => onSortChanged(v!),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.paddingMedium),
          
          // TODO: Replace with a more useful purpose.
          // Kategorival
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Typ av produkt',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                PopupMenuButton<dynamic>(
                  tooltip: 'Välj kategorier',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(38),
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            (category as List<dynamic>).isEmpty
                                ? 'Alla'
                                : (category as List<dynamic>)
                                    .map((c) => c.toString().split('.').last)
                                    .join(', '),
                            overflow: TextOverflow.ellipsis,
                            style:
                                (category as List<dynamic>).isEmpty
                                    ? Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    )
                                    : Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  onSelected: (dynamic selectedValue) {
                    List<dynamic> currentSelected = List.from(
                      category as List<dynamic>,
                    );
                    if (currentSelected.contains(selectedValue)) {
                      currentSelected.remove(selectedValue);
                    } else {
                      currentSelected.add(selectedValue);
                    }
                    onCategoryChanged(currentSelected);
                  },
                  itemBuilder: (BuildContext context) {
                    return categories.map((catItem) {
                      return CheckedPopupMenuItem<dynamic>(
                        value: catItem,
                        checked: (category as List<dynamic>).contains(catItem),
                        child: Text(catItem.toString().split('.').last),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.paddingMedium),
          // Favorit‐switch
          Row(
            children: [
              Text(
                'Endast favoriter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: AppTheme.paddingTiny),
              Switch(
                value: showFavoritesOnly,
                onChanged: onShowFavsChanged,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
