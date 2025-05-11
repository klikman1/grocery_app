
import 'CartProduct.dart';

class ShoppingCart {
  final String id;
  String name;
  int totalProduct;
  double total;
  final List<CartProduct> products;

  ShoppingCart({
    required this.id,
    required this.name,
    required this.totalProduct,
    required this.total,
    required this.products,
  });


  // From DB to an Instance
  factory ShoppingCart.fromMap(String id, Map<String, dynamic> data, List<CartProduct> products) {
    return ShoppingCart(
      id: id,
      name: data['name'],
      totalProduct: data['totalProduct'],
      total: (data['total'] as num).toDouble(),
      products: products,
    );
  }

  // From code to DB
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalProduct': totalProduct,
      'total': total,
    };
  }
}


