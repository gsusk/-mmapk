import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/checkout.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../services/api_client.dart';

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found in the widget tree');
    return scope!.notifier!;
  }
}

class AppState extends ChangeNotifier {
  AppState(this.api);

  final ApiClient api;
  final List<CartLine> _cart = [];
  final Map<int, Product> _productCache = {};
  String? accessToken;
  String? userEmail;
  BasicUser? currentUser;
  bool cartLoading = false;
  String? cartError;

  List<CartLine> get cart => List.unmodifiable(_cart);

  bool get isLoggedIn => accessToken != null;

  int get itemCount => _cart.fold(0, (sum, line) => sum + line.quantity);

  double get subtotal =>
      _cart.fold(0, (sum, line) => sum + line.unitPrice * line.quantity);

  Future<void> login(String email, String password) async {
    accessToken = await api.login(email: email, password: password);
    userEmail = email;
    currentUser = await api.getUserMe(token: accessToken!);
    await loadCart();
    notifyListeners();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    accessToken = await api.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    userEmail = email;
    currentUser = await api.getUserMe(token: accessToken!);
    await loadCart();
    notifyListeners();
  }

  void logout() {
    accessToken = null;
    userEmail = null;
    currentUser = null;
    _cart.clear();
    notifyListeners();
  }

  Future<void> loadCart() async {
    cartLoading = true;
    cartError = null;
    notifyListeners();
    try {
      _replaceCart(await api.getCart(token: accessToken));
    } catch (err) {
      cartError = '$err';
    } finally {
      cartLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product, [int quantity = 1]) async {
    _productCache[product.id] = product;
    cartError = null;
    cartLoading = true;
    notifyListeners();
    try {
      _replaceCart(
        await api.addCartItem(
          productId: product.id,
          quantity: quantity,
          token: accessToken,
        ),
      );
    } catch (err) {
      cartError = '$err';
      rethrow;
    } finally {
      cartLoading = false;
      notifyListeners();
    }
  }

  Future<void> setQuantity(CartLine line, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(line);
      return;
    }
    cartError = null;
    cartLoading = true;
    notifyListeners();
    try {
      _replaceCart(
        await api.updateCartItemQuantity(
          productId: line.productId,
          quantity: quantity,
          token: accessToken,
        ),
      );
    } catch (err) {
      cartError = '$err';
      rethrow;
    } finally {
      cartLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(CartLine line) async {
    cartError = null;
    cartLoading = true;
    notifyListeners();
    try {
      _replaceCart(
        await api.deleteCartItem(productId: line.productId, token: accessToken),
      );
    } catch (err) {
      cartError = '$err';
      rethrow;
    } finally {
      cartLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    cartLoading = true;
    notifyListeners();
    try {
      for (final line in List<CartLine>.from(_cart)) {
        await api.deleteCartItem(productId: line.productId, token: accessToken);
      }
      _cart.clear();
      cartError = null;
    } catch (err) {
      cartError = '$err';
    } finally {
      cartLoading = false;
      notifyListeners();
    }
  }

  Future<PaymentResult> checkout(CheckoutRequest request) {
    if (accessToken == null) {
      throw const ApiException('Debes iniciar sesion para pagar');
    }
    return api.checkout(request, token: accessToken!);
  }

  Future<List<OrderSummary>> loadOrders() {
    if (accessToken == null) {
      throw const ApiException('Debes iniciar sesion para ver tus ordenes');
    }
    return api.getOrders(token: accessToken!);
  }

  Future<OrderSummary> loadOrderDetails(String orderId) {
    if (accessToken == null) {
      throw const ApiException('Debes iniciar sesion para ver la orden');
    }
    return api.getOrderDetails(orderId: orderId, token: accessToken!);
  }

  void _replaceCart(ShoppingCart cart) {
    _cart
      ..clear()
      ..addAll(cart.items.map(_enrichCartLine));
    cartError = null;
  }

  CartLine _enrichCartLine(CartLine line) {
    final product = _productCache[line.productId];
    return product == null ? line : line.copyWith(image: product.image);
  }
}
