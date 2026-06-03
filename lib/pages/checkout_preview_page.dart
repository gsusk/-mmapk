import 'package:flutter/material.dart';

import '../models/checkout.dart';
import '../state/app_state.dart';
import '../utils/helpers.dart';
import '../widgets/common.dart';

class CheckoutPreviewPage extends StatefulWidget {
  const CheckoutPreviewPage({super.key});

  @override
  State<CheckoutPreviewPage> createState() => _CheckoutPreviewPageState();
}

class _CheckoutPreviewPageState extends State<CheckoutPreviewPage> {
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController(text: 'Colombia');
  bool loading = false;
  String? error;
  PaymentResult? result;

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() {
      loading = true;
      error = null;
      result = null;
    });
    try {
      final payment = await AppScope.of(context).checkout(
        CheckoutRequest(
          shippingFullName: fullNameController.text.trim(),
          shippingAddressLine: addressController.text.trim(),
          shippingCity: cityController.text.trim(),
          shippingZipCode: zipController.text.trim(),
          shippingCountry: countryController.text.trim(),
        ),
      );
      setState(() => result = payment);
    } catch (err) {
      setState(() => error = '$err');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          InfoBanner(
            icon: appState.isLoggedIn ? Icons.lock_outline : Icons.login,
            message: appState.isLoggedIn
              ? 'Checkout conectado a /checkout/initialize.'
              : 'Inicia sesion para continuar con el checkout real.',
          ),
          const SizedBox(height: 20),
          for (final line in appState.cart)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(line.name),
              subtitle: Text('${line.quantity} x ${money(line.unitPrice)}'),
              trailing: Text(money(line.unitPrice * line.quantity)),
            ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            trailing: Text(
              money(appState.subtotal),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: fullNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre completo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Direccion',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: zipController,
                  decoration: const InputDecoration(
                    labelText: 'Codigo postal',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: countryController,
            decoration: const InputDecoration(
              labelText: 'Pais',
              border: OutlineInputBorder(),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 14),
            InfoBanner(icon: Icons.error_outline, message: error!),
          ],
          if (result != null) ...[
            const SizedBox(height: 14),
            InfoBanner(
              icon: Icons.check_circle_outline,
              message:
                'Pago ${result!.status}: ${result!.paymentReference} por ${money(result!.amount)} ${result!.currency}. Orden ${result!.orderId}',
            ),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: loading || !appState.isLoggedIn ? null : submit,
            child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar pago'),
          ),
        ],
      ),
    );
  }
}
