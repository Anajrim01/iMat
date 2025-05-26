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
                    if (widget.product.isEcological) ...[
                      const SizedBox(height: AppTheme.paddingMedium),
                      Container(
                        padding: const EdgeInsets.all(AppTheme.paddingSmall),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.eco,
                              color: Colors.green,
                              size: 24,
                            ),
                            const SizedBox(width: AppTheme.paddingSmall),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ekologisk produkt',
                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Denna produkt är ekologiskt odlad enligt EU:s regelverk för ekologisk produktion.',
                                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _ImageFavoritePriceRow extends StatelessWidget {
  final Product product;
  final ImatDataHandler handler;
  const _ImageFavoritePriceRow({required this.product, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,  
          child: Stack(
            children: [
              // Product image
              SizedBox(
                width: 120,
                height: 120,
                child: handler.getImage(product),
              ),
              
              // // Eco badge overlay (if ecological)
              // if (product.isEcological)
              //   Positioned(
              //     bottom: 0,
              //     left: 0,
              //     child: Container(
              //       padding: const EdgeInsets.all(4),
              //       decoration: const BoxDecoration(
              //         color: Colors.green,
              //         borderRadius: BorderRadius.only(
              //           topRight: Radius.circular(8),
              //         ),
              //       ),
              //       child: const Icon(
              //         Icons.eco,
              //         color: Colors.white,
              //         size: 16,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
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
                '${product.price.toStringAsFixed(2)} ${product.unit}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Product title
            Expanded(
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Ecological badge
            if (product.isEcological)
              Tooltip(
                message: 'Ekologisk produkt',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Eko',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
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
