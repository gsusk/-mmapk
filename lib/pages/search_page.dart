import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/product_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final controller = TextEditingController(text: widget.initialQuery);
  late Future<List<Product>> searchFuture;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    searchFuture = Future.value(const []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loaded) return;
    searchFuture = AppScope.of(context).api.searchProducts(widget.initialQuery);
    loaded = true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() {
    final query = controller.text.trim();
    if (query.isEmpty) return;
    setState(() {
      searchFuture = AppScope.of(context).api.searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar productos')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: controller,
              onSubmitted: (_) => search(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Que estas buscando?',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: search,
                  icon: const Icon(Icons.arrow_forward),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<Product>>(
              future: searchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProducts();
                }
                if (snapshot.hasError) {
                  return ErrorState(
                    message: '${snapshot.error}',
                    onRetry: search,
                  );
                }
                final products = snapshot.data ?? const <Product>[];
                return DealsSection(
                  products: products,
                  title: 'Resultados',
                  subtitle: '${products.length} producto(s) encontrados.',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
