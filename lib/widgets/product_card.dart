import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;

  const ProductCard(this.product, this.handler, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 181,
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImageFavoritePriceRow(product: product, handler: handler),
              const SizedBox(height: AppTheme.paddingSmall),
              _TitleExtraInfo(product: product),
              const SizedBox(height: AppTheme.paddingSmall / 2),
              _DescriptionMerInfo(product: product, handler: handler),
              const SizedBox(height: AppTheme.paddingSmall),
              _AddToCartButton(product: product, handler: handler),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageFavoritePriceRow extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  const _ImageFavoritePriceRow(
      {required this.product, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AspectRatio(
            aspectRatio: 1,
            child: handler.getImage(product),
          ),
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  size: 40,
                  handler.isFavorite(product)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.black,
                ),
                onPressed: () => handler.toggleFavorite(product),
              ),
              Text(
                '${product.price.toStringAsFixed(2).replaceAll('.', ',')} '
                '${product.unit}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TitleExtraInfo extends StatelessWidget {
  final Product product;
  const _TitleExtraInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            product.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Text(
          'Extra info',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class _DescriptionMerInfo extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  const _DescriptionMerInfo(
      {required this.product, required this.handler});

  @override
  Widget build(BuildContext context) {
    final detail = handler.getDetail(product);
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              detail?.description ?? '',
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppTheme.paddingSmall),
          ElevatedButton(
            onPressed: () => _showDetailDialog(context, product, detail),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6E0F8),
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontSize: 12),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
            ),
            child: const Text('Mer info'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext ctx, Product p, detail) {
    showDialog(
      context: ctx,
      builder: (c) => AlertDialog(
        title: Text(p.name),
        content: Text(detail?.description ?? 'Ingen beskrivning'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Stäng'),
          )
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  const _AddToCartButton(
      {required this.product, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () =>
            handler.shoppingCartAdd(ShoppingItem(product, amount: 1)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE6E0F8),
          foregroundColor: Colors.black,
          padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text('Lägg till'),
      ),
    );
  }
}

