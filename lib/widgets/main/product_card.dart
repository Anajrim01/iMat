import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final ImatDataHandler handler;
  const ProductCard(this.product, this.handler, {super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  void _showProductDetailsDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          side: BorderSide(color: Colors.deepPurple.shade100, width: 0.5),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.product.name,
                style: AppTheme.textTheme.headlineMedium,
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(c), // Close the dialog
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingTiny),
                child: Row(
                  children: [
                    const Text('Stäng'),
                    const SizedBox(width: AppTheme.paddingTiny),
                    Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                  ],
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppTheme.borderRadius,
                  ),
                  child: widget.handler.getImage(widget.product),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beskrivning:',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      widget.handler.getDetail(widget.product)?.description ??
                          'Ingen beskrivning tillgänglig.',
                      style: AppTheme.textTheme.bodyLarge,
                    ),
                    if (widget.handler.getDetail(widget.product)?.origin !=
                            null &&
                        widget.handler
                            .getDetail(widget.product)!
                            .origin
                            .isNotEmpty) ...[
                      const SizedBox(height: AppTheme.paddingMedium),
                      Text(
                        'Ursprung:',
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.paddingSmall),
                      Text(
                        widget.handler.getDetail(widget.product)!.origin,
                        style: AppTheme.textTheme.bodyLarge,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppTheme.paddingSmall,
              right: AppTheme.paddingSmall,
              left: AppTheme.paddingSmall,
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.handler
                    .shoppingCartAdd(ShoppingItem(widget.product, amount: 1));
                // Hide the dialog after adding to cart?
                // TODO: Discuss with team if we want to close the dialog
                Navigator.pop(c);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: AppTheme.colorScheme.secondary,
                foregroundColor: Colors.black,
                textStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  side: BorderSide(
                    color: Colors.deepPurple.shade100,
                    width: 0.5,
                  ),
                ),
              ),
              child: const Text('Lägg till'),
            ),
          ),
        ],
      ),
    );
  }

  void _onCardTap() {
    _showProductDetailsDialog();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _onCardTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 200,
          decoration: BoxDecoration(
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.deepPurple.withAlpha(50), // Adjusted alpha
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(12), // Adjusted alpha
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: Card(
            elevation: _isHovered ? 10 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              side: BorderSide(color: Colors.deepPurple.shade100, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ImageFavoritePriceRow(
                    product: widget.product,
                    handler: widget.handler,
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _TitleExtraInfo(product: widget.product),
                  const SizedBox(height: AppTheme.paddingSmall),
                  _DescriptionMerInfo(
                    product: widget.product,
                    handler: widget.handler,
                    onMerInfoPressed: _showProductDetailsDialog,
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _AddToCartButton(
                    product: widget.product,
                    handler: widget.handler,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Spara varje underklass i samma fil för enkelhet – övriga justeras på samma sätt:
class _ImageFavoritePriceRow extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  const _ImageFavoritePriceRow({required this.product, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align children to the top of the Row
      children: [
        Expanded(
          flex: 1,
          child: AspectRatio(aspectRatio: 1, child: handler.getImage(product)),
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.end, // Align items to the right of this Column
            mainAxisAlignment:
                MainAxisAlignment.start, // Stack items at the top of this Column
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  handler.isFavorite(product) ? Icons.star : Icons.star_border,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () => handler.toggleFavorite(product),
              ),
              const SizedBox(height: 75),
              Text(
                '${product.price.toStringAsFixed(2).replaceAll('.', ',')} ${product.unit}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.end,
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
    return Text(
      product.name,
      style: Theme.of(context).textTheme.headlineSmall,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DescriptionMerInfo extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  final VoidCallback onMerInfoPressed;
  const _DescriptionMerInfo(
      {required this.product,
      required this.handler,
      required this.onMerInfoPressed});

  @override
  Widget build(BuildContext context) {
    final detail = handler.getDetail(product);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Själva texten
        Expanded(
          child: Text(
            detail?.description ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 3, // nån rad färre i kortet
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        // Mer info-knappen
        ElevatedButton(
          onPressed: onMerInfoPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(64, 36),
            backgroundColor: AppTheme.colorScheme.secondary,
            foregroundColor: Colors.black,
            textStyle: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              side: BorderSide(
                color: Colors.deepPurple.shade100,
                width: 0.5,
              ), // Light purple border
            ),
          ),
          child: const Text('Mer info'),
        ),
      ],
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  const _AddToCartButton({required this.product, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed:
              () => handler.shoppingCartAdd(ShoppingItem(product, amount: 1)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: AppTheme.colorScheme.secondary,
            foregroundColor: Colors.black,
            textStyle: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              side: BorderSide(
                color: Colors.deepPurple.shade100,
                width: 0.5,
              ), // Light purple border
            ),
          ),
          child: const Text('Lägg till'),
        ),
      ),
    );
  }
}
