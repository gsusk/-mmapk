import '../utils/helpers.dart';

class CheckoutRequest {
  const CheckoutRequest({
    required this.shippingFullName,
    required this.shippingAddressLine,
    required this.shippingCity,
    required this.shippingZipCode,
    required this.shippingCountry,
  });

  final String shippingFullName;
  final String shippingAddressLine;
  final String shippingCity;
  final String shippingZipCode;
  final String shippingCountry;

  Map<String, dynamic> toJson() => {
    'shippingFullName': shippingFullName,
    'shippingAddressLine': shippingAddressLine,
    'shippingCity': shippingCity,
    'shippingZipCode': shippingZipCode,
    'shippingCountry': shippingCountry,
  };
}

class PaymentResult {
  const PaymentResult({
    required this.paymentReference,
    required this.currency,
    required this.amount,
    required this.status,
    required this.orderId,
  });

  final String paymentReference;
  final String currency;
  final double amount;
  final String status;
  final String orderId;

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      paymentReference: asString(json['paymentReference']),
      currency: asString(json['currency']),
      amount: asDouble(json['amount']),
      status: asString(json['status']),
      orderId: asString(json['orderId']),
    );
  }
}
