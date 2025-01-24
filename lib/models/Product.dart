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
}