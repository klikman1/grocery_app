import 'package:techno_mobile/models/Product.dart';

class ShoppingCart {
  final String id;
  String name;
  int totalProduct;
  double total;
  final Map<String, int> products; // Map of product ID (or name) to quantity

  ShoppingCart({
    required this.id,
    required this.name,
    required this.totalProduct,
    required this.total,
    required this.products,
  });
}


