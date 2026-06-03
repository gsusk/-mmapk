import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../utils/helpers.dart';
import '../widgets/common.dart';
import '../widgets/product_widgets.dart';
import 'checkout_preview_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          if (appState.cart.isEmpty) {
            return EmptyState(
              icon: appState.cartLoading
                ? Icons.sync
                : Icons.shopping_cart_outlined,
              title: appState.cartLoading
                ? 'Cargando carrito'
                : 'Tu carrito esta vacio',
              message:
                appState.cartError ?? 'Agrega productos y apareceran aqui',
            );
          }
          return Column(
            children: [
              if (appState.cartError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InfoBanner(
                    icon: Icons.error_outline,
                    message: appState.cartError!,
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: appState.cart.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final line = appState.cart[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      leading: SizedBox(
                        width: 58,
                        height: 58,
                        child: CartLineImage(line: line),
                      ),
                      title: Text(
                        line.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(money(line.unitPrice)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: appState.cartLoading
                              ? null
                              : () => appState.setQuantity(line, line.quantity - 1),
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            '${line.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          IconButton(
                            onPressed: appState.cartLoading
                              ? null
                              : () => appState.setQuantity(line, line.quantity + 1),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          money(appState.subtotal),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: appState.cartLoading ? null : () => appState.clearCart(),
                            child: const Text('Vaciar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: appState.cartLoading
                              ? null
                              : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutPreviewPage(),
                                ),
                              ),
                            child: const Text('Pagar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
