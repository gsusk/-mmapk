import '../utils/helpers.dart';

class OrderDetails {
  const OrderDetails({
    required this.id,
    required this.email,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  final String id;
  final String email;
  final int userId;
  final String status;
  final double totalAmount;
  final String createdAt;

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: asString(json['id']),
      email: asString(json['email']),
      userId: asInt(json['userId']),
      status: asString(json['status']),
      totalAmount: asDouble(json['totalAmount']),
      createdAt: asString(json['createdAt']),
    );
  }
}

class OrderItemSummary {
  const OrderItemSummary({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subTotal,
  });

  final String id;
  final String productName;
  final int quantity;
  final double price;
  final double subTotal;

  factory OrderItemSummary.fromJson(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return OrderItemSummary(
      id: asString(json['id']),
      productName: asString(json['productName']),
      quantity: asInt(json['quantity']),
      price: asDouble(json['price']),
      subTotal: asDouble(json['subTotal']),
    );
  }
}

class OrderSummary {
  const OrderSummary({
    required this.orderId,
    required this.userId,
    required this.email,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.createdAt,
  });

  final String orderId;
  final int userId;
  final String email;
  final String status;
  final double totalAmount;
  final List<OrderItemSummary> items;
  final String createdAt;

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return OrderSummary(
      orderId: asString(json['orderId']),
      userId: asInt(json['userId']),
      email: asString(json['email']),
      status: asString(json['status']),
      totalAmount: asDouble(json['totalAmount']),
      items: rawItems is List
          ? rawItems.map(OrderItemSummary.fromJson).toList()
          : const <OrderItemSummary>[],
      createdAt: asString(json['createdAt']),
    );
  }
}
