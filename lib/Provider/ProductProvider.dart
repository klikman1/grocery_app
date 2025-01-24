import 'package:flutter/material.dart';
import 'package:techno_mobile/models/Product.dart';
import '../firebaseAPI/FireStoreService.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];
  final FirestoreService _firestoreService = FirestoreService();  // FirestoreService instance

  // Getter to provide a copy of the product list
  List<Product> get products {
    return [..._products];
  }

  // Fetch products from Database
  Future<void> fetchProducts() async {
    try {
      final productsFromDatabase = await _firestoreService.fetchProducts();
      _products.clear();  // Clear the list before adding new data
      _products.addAll(productsFromDatabase);  // Add fetched products to the list
      notifyListeners();  // Notify listeners
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Create a new product and add it to both the list and Database
  Future<void> createProduct(String pName, int pStockQuantity, double pUnityPrice,
      String pNutritionDetails, String pImageUrl) async {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: pName,
      stockQuantity: pStockQuantity,
      unityPrice: pUnityPrice,
      nutritionDetails: pNutritionDetails,
      imageUrl: pImageUrl,
    );

    // Add the product to Database
    await _firestoreService.addProduct({
      'name': pName,
      'stockQuantity': pStockQuantity,
      'unityPrice': pUnityPrice,
      'nutritionDetails': pNutritionDetails,
      'imageUrl': pImageUrl,
    });

    // Add the product to the local list
    _products.add(newProduct);
    notifyListeners();  // Notify listeners to rebuild the UI
  }

  // Update product data both locally and in Database
  Future<void> updateProduct({
    required String productId,
    String? name,
    int? stockQuantity,
    double? unityPrice,
    String? nutritionDetails,
    String? imageUrl,
  }) async {
    final product = _products.firstWhere(
          (product) => product.id == productId,
      orElse: () => null as Product,
    );

    if (product != null) {
      // Update the product locally
      if (name != null) product.name = name;
      if (stockQuantity != null) product.stockQuantity = stockQuantity;
      if (unityPrice != null) product.unityPrice = unityPrice;
      if (nutritionDetails != null) product.nutritionDetails = nutritionDetails;
      if (imageUrl != null) product.imageUrl = imageUrl;

      // Update database
      await _firestoreService.updateProduct(
        productId,
        {
          'name': name ?? product.name,
          'stockQuantity': stockQuantity ?? product.stockQuantity,
          'unityPrice': unityPrice ?? product.unityPrice,
          'nutritionDetails': nutritionDetails ?? product.nutritionDetails,
          'imageUrl': imageUrl ?? product.imageUrl,
        },
      );

      notifyListeners();  // Notify listeners to rebuild the UI
    }
  }

  // Find a product by its ID
  Product? findProductById(String productId) {
    return _products.firstWhere(
          (product) => product.id == productId,
      orElse: () => null as Product,
    );
  }

  // Delete product from both the list and Database
  Future<void> deleteProduct(String id) async {
    try {
      // Remove the product from the local list
      _products.removeWhere((product) => product.id == id);

      // Delete the product from the database
      await _firestoreService.deleteProduct(id);

      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}
