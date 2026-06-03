import 'dart:async';
import 'package:flutter/material.dart';

import '../data/fallback_products.dart';
import '../models/product.dart';
import '../state/app_state.dart';
import '../widgets/home_widgets.dart';
import '../widgets/product_widgets.dart';
import '../widgets/common.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  late Future<List<Product>> featuredFuture;
  bool loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loaded) return;
    final appState = AppScope.of(context);
    featuredFuture = appState.api.getFeaturedProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(appState.loadCart());
    });
    loaded = true;
  }

  void reload() {
    setState(() {
      featuredFuture = AppScope.of(context).api.getFeaturedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const StoreNavbar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => reload(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1160),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              const HeroCarousel(),
                              const SizedBox(height: 28),
                              const TrustBar(),
                              const SizedBox(height: 56),
                              FutureBuilder<List<Product>>(
                                future: featuredFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const LoadingProducts();
                                  }
                                  final products =
                                      snapshot.data ??
                                      (snapshot.hasError
                                          ? fallbackProducts
                                          : const <Product>[]);
                                  return DealsSection(
                                    products: products,
                                    error: snapshot.error,
                                    onRetry: reload,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
