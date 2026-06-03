import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../pages/product_detail_page.dart';
import '../services/api_client.dart';
import '../state/app_state.dart';
import '../utils/helpers.dart';
import 'common.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.fit = BoxFit.contain,
  });

  final Product product;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final image = product.image;
    if (image.startsWith('assets/')) {
      return Image.asset(image, fit: fit);
    }
    if (image.isNotEmpty) {
      final url = image.startsWith('http') ? image : '$apiBaseUrl$image';
      return Image.network(
        url,
        fit: fit,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.shopping_bag_outlined,
          size: 56,
          color: Color(0xFF94A3B8),
        ),
      );
    }
    return const Icon(
      Icons.shopping_bag_outlined,
      size: 56,
      color: Color(0xFF94A3B8),
    );
  }
}

class CartLineImage extends StatelessWidget {
  const CartLineImage({super.key, required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    if (line.image.isEmpty) {
      return const Icon(
        Icons.shopping_bag_outlined,
        size: 38,
        color: Color(0xFF94A3B8),
      );
    }
    return ProductImage(
      product: Product(
        id: line.productId,
        name: line.name,
        category: '',
        price: line.unitPrice,
        image: line.image,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: ProductImage(product: product),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filledTonal(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.9,
                            ),
                            foregroundColor: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                product.category.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 42,
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      money(product.price),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: product.inStock
                        ? () async {
                            try {
                              await AppScope.of(context).addToCart(product);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} agregado'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } catch (err) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$err'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        : null,
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 950
            ? 4
            : constraints.maxWidth >= 650
            ? 2
            : 1;
        final itemWidth = (constraints.maxWidth - (columns - 1) * 24) / columns;
        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            for (final product in products)
              SizedBox(
                width: itemWidth,
                child: ProductCard(product: product),
              ),
          ],
        );
      },
    );
  }
}

class DealsSection extends StatelessWidget {
  const DealsSection({
    super.key,
    required this.products,
    this.error,
    this.onRetry,
    this.title = 'Ofertas de la Semana',
    this.subtitle = 'Los mejores precios en tecnologia seleccionada.',
  });

  final List<Product> products;
  final Object? error;
  final VoidCallback? onRetry;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            if (onRetry != null)
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: 16),
          InfoBanner(
            icon: Icons.wifi_off,
            message:
                'No se pudo cargar desde el backend. Mostrando productos de ejemplo.',
          ),
        ],
        const SizedBox(height: 28),
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 56),
            child: Text('No hay productos disponibles en este momento.'),
          )
        else
          ProductGrid(products: products),
      ],
    );
  }
}
