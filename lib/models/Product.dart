import 'dart:core';

class Product {
  final String id;
  String name;
  int stockQuantity;
  double unityPrice;
  String nutritionDetails;
  String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.stockQuantity,
    required this.unityPrice,
    required this.nutritionDetails,
    required this.imageUrl,
  });

  // From DB to an Instance
  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'],
      stockQuantity: data['stockQuantity'],
      unityPrice: (data['unityPrice'] as num).toDouble(),
      nutritionDetails: data['nutritionDetails'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // From code to DB
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'stockQuantity': stockQuantity,
      'unityPrice': unityPrice,
      'nutritionDetails': nutritionDetails,
      'imageUrl': imageUrl,
    };
  }
}