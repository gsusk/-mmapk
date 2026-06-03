import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/app_state.dart';
import '../utils/helpers.dart';
import '../widgets/common.dart';
import '../widgets/product_widgets.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> productFuture;
  int quantity = 1;
  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loaded) return;
    productFuture = AppScope.of(context).api.getProduct(widget.product.id);
    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: productFuture,
      builder: (context, snapshot) {
        final product = snapshot.data ?? widget.product;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Detalle')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: ProductImage(product: product),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (product.category.isNotEmpty)
                    Chip(label: Text(product.category)),
                  if (product.brand.isNotEmpty)
                    Chip(label: Text(product.brand)),
                  Chip(
                    label: Text(product.inStock ? 'En stock' : 'Agotado'),
                    backgroundColor: product.inStock
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFFFE4E6),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 30,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                money(product.price),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (snapshot.connectionState == ConnectionState.waiting) ...[
                const SizedBox(height: 14),
                const LinearProgressIndicator(),
              ],
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  product.description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  QuantityStepper(
                    value: quantity,
                    onChanged: (value) => setState(() => quantity = value),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: product.inStock
                        ? () async {
                            try {
                              await AppScope.of(
                                context,
                              ).addToCart(product, quantity);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} agregado al carrito',
                                  ),
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
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Agregar'),
                    ),
                  ),
                ],
              ),
              if (product.attributes.isNotEmpty) ...[
                const SizedBox(height: 28),
                const Text(
                  'Especificaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                for (final entry in product.attributes.entries)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.key.replaceAll('_', ' ')),
                    trailing: Text('${entry.value}'),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
