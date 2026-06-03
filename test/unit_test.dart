import 'package:flutter_test/flutter_test.dart';
import 'package:minimarket_adso_apk/models/cart.dart';
import 'package:minimarket_adso_apk/models/product.dart';
import 'package:minimarket_adso_apk/utils/helpers.dart';


//NOTA: Anadir tests para helper si termino creando mas
void main() {
  group('Helpers Unit Tests', () {
    test('money() formats double values correctly as currency', () {
      expect(money(0), '\$0');
      expect(money(120), '\$120');
      expect(money(1000), '\$1.000');
      expect(money(349900), '\$349.900');
      expect(money(2499900), '\$2.499.900');
    });

    test('asInt() converts various types correctly', () {
      expect(asInt(5), 5);
      expect(asInt(5.7), 5);
      expect(asInt('42'), 42);
      expect(asInt('invalid', 99), 99);
      expect(asInt(null, 10), 10);
    });

    test('asDouble() converts various types correctly', () {
      expect(asDouble(5.5), 5.5);
      expect(asDouble(5), 5.0);
      expect(asDouble('42.42'), 42.42);
      expect(asDouble('invalid', 9.9), 9.9);
      expect(asDouble(null, 1.2), 1.2);
    });

    test('asString() converts various types correctly', () {
      expect(asString('hello'), 'hello');
      expect(asString(123), '123');
      expect(asString(null, 'fallback'), 'fallback');
      expect(asString('', 'fallback'), 'fallback');
    });
  });

  group('Product Model Unit Tests', () {
    test('Product.fromDetailedJson parses correctly', () {
      final json = {
        'id': '10',
        'name': 'Laptop Asus',
        'category': {
          'categoryName': 'Computers',
        },
        'price': 2500000.0,
        'images': ['/img/asus.png'],
        'description': 'Powerful laptop',
        'brand': 'Asus',
        'stock': 5,
        'attributes': {'ram': '16GB'},
      };

      final product = Product.fromDetailedJson(json);

      expect(product.id, 10);
      expect(product.name, 'Laptop Asus');
      expect(product.category, 'Computers');
      expect(product.price, 2500000.0);
      expect(product.image, '/img/asus.png');
      expect(product.description, 'Powerful laptop');
      expect(product.brand, 'Asus');
      expect(product.stock, 5);
      expect(product.inStock, true);
      expect(product.attributes['ram'], '16GB');
    });
  });

  group('ShoppingCart Model Unit Tests', () {
    test('ShoppingCart.fromJson parses correctly', () {
      final json = {
        'shoppingCartItems': [
          {
            'productId': 1,
            'name': 'Mouse Logitech',
            'unitPrice': 75000.0,
            'quantity': 2,
          }
        ],
        'subTotal': 150000.0,
        'size': 2,
      };

      final cart = ShoppingCart.fromJson(json);

      expect(cart.size, 2);
      expect(cart.subTotal, 150000.0);
      expect(cart.items.length, 1);
      expect(cart.items.first.productId, 1);
      expect(cart.items.first.name, 'Mouse Logitech');
      expect(cart.items.first.unitPrice, 75000.0);
      expect(cart.items.first.quantity, 2);
    });
  });
}
