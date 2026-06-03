import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/cart.dart';
import '../models/checkout.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://192.168.1.65:8080',
);

class ApiClient {
  ApiClient(this.baseUrl);

  final String baseUrl;
  final Map<String, String> _cookies = {};

  Future<List<Product>> getFeaturedProducts() async {
    final json = await _get('/products/featured');
    if (json is! List) throw const ApiException('Respuesta inesperada');
    return json.map(Product.fromDetailedJson).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<Product>> searchProducts(String query) async {
    final json = await _get('/search?q=${Uri.encodeQueryComponent(query)}');
    if (json is Map<String, dynamic>) {
      final products = json['products'];
      if (products is List) {
        return products.map(Product.fromSearchJson).toList();
      }
    }
    throw const ApiException('Respuesta inesperada');
  }

  Future<Product> getProduct(int id) async {
    final json = await _get('/products/$id');
    if (json is Map<String, dynamic>) return Product.fromDetailedJson(json);
    throw const ApiException('Respuesta inesperada');
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final json = await _send(
      'POST',
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    if (json is Map<String, dynamic> && json['accessToken'] is String) {
      return json['accessToken'] as String;
    }
    throw const ApiException('No se recibio token de acceso');
  }

  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final json = await _send(
      'POST',
      '/auth/register',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );
    if (json is Map<String, dynamic> && json['accessToken'] is String) {
      return json['accessToken'] as String;
    }
    throw const ApiException('No se recibio token de acceso despues del registro');
  }

  Future<BasicUser> getUserMe({required String token}) async {
    final json = await _send(
      'GET',
      '/user/me',
      token: token,
    );
    if (json is Map<String, dynamic>) {
      return BasicUser.fromJson(json);
    }
    throw const ApiException('Respuesta inesperada del usuario');
  }

  Future<List<OrderSummary>> getOrders({required String token}) async {
    final json = await _send(
      'GET',
      '/orders',
      token: token,
    );
    if (json is List) {
      return json.map((o) => OrderSummary.fromJson(o as Map<String, dynamic>)).toList();
    }
    throw const ApiException('Respuesta inesperada al obtener ordenes');
  }

  Future<OrderSummary> getOrderDetails({
    required String orderId,
    required String token,
  }) async {
    final json = await _send(
      'GET',
      '/orders/$orderId',
      token: token,
    );
    if (json is Map<String, dynamic>) {
      return OrderSummary.fromJson(json);
    }
    throw const ApiException('Respuesta inesperada al obtener detalle de orden');
  }

  Future<ShoppingCart> getCart({String? token}) async {
    final json = await _send(
      'GET',
      '/cart',
      token: token,
      okStatuses: {200, 404},
    );
    if (json == null) return ShoppingCart.empty;
    if (json is Map<String, dynamic>) return ShoppingCart.fromJson(json);
    throw const ApiException('Respuesta inesperada del carrito');
  }

  Future<ShoppingCart> addCartItem({
    required int productId,
    required int quantity,
    String? token,
  }) async {
    final json = await _send(
      'POST',
      '/cart/items',
      body: {'productId': productId, 'quantity': quantity},
      token: token,
    );
    if (json is Map<String, dynamic>) return ShoppingCart.fromJson(json);
    throw const ApiException('Respuesta inesperada del carrito');
  }

  Future<ShoppingCart> updateCartItemQuantity({
    required int productId,
    required int quantity,
    String? token,
  }) async {
    final json = await _send(
      'PUT',
      '/cart/items/$productId',
      body: {'quantity': quantity},
      token: token,
    );
    if (json is Map<String, dynamic>) return ShoppingCart.fromJson(json);
    throw const ApiException('Respuesta inesperada del carrito');
  }

  Future<ShoppingCart> deleteCartItem({
    required int productId,
    String? token,
  }) async {
    final json = await _send('DELETE', '/cart/items/$productId', token: token);
    if (json is Map<String, dynamic>) return ShoppingCart.fromJson(json);
    throw const ApiException('Respuesta inesperada del carrito');
  }

  Future<PaymentResult> checkout(
    CheckoutRequest checkout, {
    required String token,
  }) async {
    final json = await _send(
      'POST',
      '/checkout/initialize',
      body: checkout.toJson(),
      token: token,
    );
    if (json is Map<String, dynamic>) return PaymentResult.fromJson(json);
    throw const ApiException('Respuesta inesperada del checkout');
  }

  Future<dynamic> _get(String path) => _send('GET', path);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? token,
    Set<int>? okStatuses,
  }) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final uri = Uri.parse('$baseUrl$path');
      final request = await client.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (_cookies.isNotEmpty) {
        request.headers.set(
          HttpHeaders.cookieHeader,
          _cookies.entries
              .map((entry) => '${entry.key}=${entry.value}')
              .join('; '),
        );
      }
      if (token != null) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }
      if (body != null) request.write(jsonEncode(body));

      final response = await request.close().timeout(
        const Duration(seconds: 12),
      );
      _storeCookies(response.cookies);
      final responseBody = await utf8.decoder.bind(response).join();
      final validStatuses =
          okStatuses ?? {for (var status = 200; status < 300; status++) status};
      if (!validStatuses.contains(response.statusCode)) {
        throw ApiException(
          responseBody.isEmpty
              ? 'Error ${response.statusCode}'
              : 'Error ${response.statusCode}: $responseBody',
        );
      }
      if (responseBody.isEmpty) return null;
      return jsonDecode(responseBody);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException('No se pudo conectar con el backend');
    } on TimeoutException {
      throw const ApiException('El backend tardo demasiado en responder');
    } finally {
      client.close(force: true);
    }
  }

  void _storeCookies(List<Cookie> cookies) {
    for (final cookie in cookies) {
      if (cookie.value.isEmpty || cookie.maxAge == 0) {
        _cookies.remove(cookie.name);
      } else {
        _cookies[cookie.name] = cookie.value;
      }
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
