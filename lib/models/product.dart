import '../utils/helpers.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    this.slug = '',
    this.description = '',
    this.brand = '',
    this.stock = 1,
    this.attributes = const {},
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final String image;
  final String slug;
  final String description;
  final String brand;
  final int stock;
  final Map<String, dynamic> attributes;

  bool get inStock => stock > 0;

  factory Product.fromDetailedJson(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    final category = json['category'];
    final images = json['images'];
    return Product(
      id: asInt(json['id']),
      name: asString(json['name'], 'Producto'),
      slug: asString(json['slug']),
      description: asString(json['description']),
      category: category is Map<String, dynamic>
          ? asString(category['categoryName'])
          : asString(category),
      price: asDouble(json['price']),
      brand: asString(json['brand']),
      stock: asInt(json['stock'], 1),
      image: _firstImage(images),
      attributes: json['attributes'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['attributes'] as Map)
          : const {},
    );
  }

  factory Product.fromSearchJson(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    final images = json['images'];
    return Product(
      id: asInt(json['id']),
      name: asString(json['name'], 'Producto'),
      slug: asString(json['slug']),
      category: asString(json['category']),
      price: asDouble(json['price']),
      brand: asString(json['brand']),
      image: _firstImage(images),
    );
  }

  static String _firstImage(dynamic images) {
    if (images is List && images.isNotEmpty) return asString(images.first);
    return '';
  }
}
