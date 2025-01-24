import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Product.dart';
import '../models/ShoppingCart.dart';

class FirestoreService {
  final CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');
  final CollectionReference cartsCollection = FirebaseFirestore.instance.collection('carts'); // Cart collection

  // Fetch products from Database
  Future<List<Product>> fetchProducts() async {
    try {
      final productsFromDatabase = await productsCollection.get();

      return productsFromDatabase.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          name: data['name'],
          stockQuantity: data['stockQuantity'],
          unityPrice: data['unityPrice'],
          nutritionDetails: data['nutritionDetails'],
          imageUrl: data['imageUrl'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching products from Database: $e");
      return [];
    }
  }

  // Add a product to Database
  Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      await productsCollection.add(product);
      print("Product added to Database!");
    } catch (e) {
      print("Error adding product to Database: $e");
    }
  }

  // Update a product in Database
  Future<void> updateProduct(String productId, Map<String, dynamic> updatedProductData) async {
    try {
      await productsCollection.doc(productId).update(updatedProductData);
      print("Product updated in Database!");
    } catch (e) {
      print("Error updating product in Database: $e");
    }
  }

  // Update product stock in database
  Future<void> updateProductStock(String productId, int stockQuantity) async {
    try {
      await productsCollection.doc(productId).update({'stockQuantity': stockQuantity});
      print("Product stock updated in database!");
    } catch (e) {
      print("Error updating product stock in database: $e");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      print("Error deleting product from database: $e");
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///////////////////////// C A R T S //////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////



  // Fetch carts from Database
  Future<List<ShoppingCart>> fetchCarts() async {
    try {
      final cartsFromDatabase = await cartsCollection.get();  // Get carts collection from database

      return cartsFromDatabase.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ShoppingCart(
          id: doc.id,
          name: data['name'],
          totalProduct: data['totalProduct'],
          total: data['total'],
          products: Map<String, int>.from(data['products']),  // Convert product data to Map<String, int>
        );
      }).toList();
    } catch (e) {
      print("Error fetching carts from database: $e");
      return [];
    }
  }


  // Add a cart to Database
  Future<void> addCart(Map<String, dynamic> cartData) async {
    try {
      await cartsCollection.add(cartData);
      print("Cart added to Database!");
    } catch (e) {
      print("Error adding cart to Database: $e");
    }
  }

  // Update a cart in Database
  Future<void> updateCart(String cartId, Map<String, dynamic> updatedCartData) async {
    try {
      await cartsCollection.doc(cartId).update(updatedCartData);
      print("Cart updated in Database!");
    } catch (e) {
      print("Error updating cart in Database: $e");
    }
  }

  // Delete a cart from Database
  Future<void> deleteCart(String cartId) async {
    try {
      await cartsCollection.doc(cartId).delete();
      print("Cart deleted from Database!");
    } catch (e) {
      print("Error deleting cart from database: $e");
    }
  }
}
