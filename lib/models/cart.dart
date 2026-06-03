import '../utils/helpers.dart';
import 'product.dart';

class ShoppingCart {
  const ShoppingCart({
    required this.items,
    required this.subTotal,
    required this.size,
  });

  static const empty = ShoppingCart(items: [], subTotal: 0, size: 0);

  final List<CartLine> items;
  final double subTotal;
  final int size;

  factory ShoppingCart.fromJson(Map<String, dynamic> json) {
    final rawItems = json['shoppingCartItems'];
    return ShoppingCart(
      items: rawItems is List
          ? rawItems.map(CartLine.fromJson).toList()
          : const <CartLine>[],
      subTotal: asDouble(json['subTotal']),
      size: asInt(json['size']),
    );
  }
}

class CartLine {
  const CartLine({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.image = '',
  });

  final int productId;
  final String name;
  final double unitPrice;
  final int quantity;
  final String image;

  factory CartLine.fromJson(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return CartLine(
      productId: asInt(json['productId']),
      name: asString(json['name'], 'Producto'),
      unitPrice: asDouble(json['unitPrice']),
      quantity: asInt(json['quantity']),
    );
  }

  CartLine copyWith({int? quantity, String? image}) {
    return CartLine(
      productId: productId,
      name: name,
      unitPrice: unitPrice,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}
