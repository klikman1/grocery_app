import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/models/ShoppingCart.dart';
import 'package:techno_mobile/models/Product.dart';
import '../firebaseAPI/FireStoreService.dart';
import 'ProductProvider.dart';

class CartProvider extends ChangeNotifier {
  final List<ShoppingCart> _carts = [];
  final FirestoreService _firestoreService = FirestoreService();

  List<ShoppingCart> get carts => _carts;

  // Create a cart
  Future<void> createCart(String name) async {

    // Add the new cart to database
    await _firestoreService.addCart({
      'name': name,
      'totalProduct': 0,
      'total': 0.0,
      'products': {},
    });

    final newCart = _firestoreService.fetchCarts();
    fetchCarts();

    notifyListeners();

  }

  // Fetch all carts from database
  Future<void> fetchCarts() async {
    try {
      final cartsFromDatabase = await _firestoreService.fetchCarts(); // Fetch carts from database
      _carts.clear();  // Clear the list before adding new data
      _carts.addAll(cartsFromDatabase);  // Add fetched carts to the list
      notifyListeners();  // Notify listeners to update the UI
    } catch (e) {
      print("Error fetching carts: $e");
    }
  }

  // Add a product to the cart
  Future<void> addProductToCart(String cartId, Product product, int quantity) async {
    final cartIndex = _carts.indexWhere((cart) => cart.id == cartId);
    if (cartIndex == -1) return;

    final cart = _carts[cartIndex];

    // Create a new map with updated quantities
    final updatedProducts = Map<String, int>.from(cart.products);
    updatedProducts.update(
      product.id,
          (existingQuantity) => existingQuantity + quantity,
      ifAbsent: () => quantity,
    );

    // Calculate new totals
    final updatedTotalProduct = cart.totalProduct + quantity;
    final updatedTotal = cart.total + (product.unityPrice * quantity);

    // Update the cart with a new instance
    _carts[cartIndex] = ShoppingCart(
      id: cart.id,
      name: cart.name,
      totalProduct: updatedTotalProduct,
      total: updatedTotal,
      products: updatedProducts,
    );

    // Decrease the product's stock quantity (locally)
    product.stockQuantity -= quantity;

    // Check if the cart exists in Firestore
    final cartDoc = await FirebaseFirestore.instance.collection('carts').doc(cart.id).get();

    if (!cartDoc.exists) {
      // If the cart doesn't exist, create a new cart in Firestore
      await _firestoreService.addCart({
        'name': cart.name,
        'totalProduct': updatedTotalProduct,
        'total': updatedTotal,
        'products': updatedProducts,
      });
      print("Cart created in Firestore!");
    } else {
      // If the cart exists, update it in Firestore
      await _firestoreService.updateCart(cart.id, {
        'name': cart.name,
        'totalProduct': updatedTotalProduct,
        'total': updatedTotal,
        'products': updatedProducts,
      });
      print("Cart updated in Firestore!");
    }

    // Update product stock in database as well
    await _firestoreService.updateProductStock(product.id, product.stockQuantity);

    notifyListeners();
  }

  // Update cart name
  Future<void> updateCartName(String cartId, String newName) async {
    final index = _carts.indexWhere((cart) => cart.id == cartId);
    if (index != -1) {
      _carts[index].name = newName;
      notifyListeners();

      // Update cart name in database
      await _firestoreService.updateCart(cartId, {'name': newName});
    }
  }

  // Remove a product from the cart
  Future<void> removeProductFromCart(BuildContext context, String cartId, String productId) async {
    final cartIndex = _carts.indexWhere((cart) => cart.id == cartId);
    if (cartIndex == -1) return;

    final cart = _carts[cartIndex];
    if (!cart.products.containsKey(productId)) return;

    final quantity = cart.products[productId]!;

    final updatedProducts = Map<String, int>.from(cart.products);
    updatedProducts.remove(productId);

    final product = _findProductById(context, productId);
    if (product != null) {
      product.stockQuantity += quantity;
    }

    final updatedTotalProduct = cart.totalProduct - quantity;
    final updatedTotal = cart.total - (product?.unityPrice ?? 0) * quantity;

    _carts[cartIndex] = ShoppingCart(
      id: cart.id,
      name: cart.name,
      totalProduct: updatedTotalProduct,
      total: updatedTotal,
      products: updatedProducts,
    );

    notifyListeners();

    // Update cart in database
    await _firestoreService.updateCart(cart.id, {
      'name': cart.name,
      'totalProduct': updatedTotalProduct,
      'total': updatedTotal,
      'products': updatedProducts,
    });

    // Update product stock in database
    await _firestoreService.updateProduct(product!.id, {
      'stockQuantity': product.stockQuantity,
    });
  }

  // Remove a certain quantity of a product from the cart
  Future<void> removeQuantityOfProductFromCart(
      BuildContext context, String cartId, String productId, int quantity) async {
    final cartIndex = _carts.indexWhere((cart) => cart.id == cartId);
    if (cartIndex == -1) return;

    final cart = _carts[cartIndex];

    // Check if the product exists in the cart
    if (cart.products.containsKey(productId)) {
      final currentQuantity = cart.products[productId]!;

      // If the current quantity is greater than or equal to the quantity to be removed
      if (currentQuantity >= quantity) {
        // Update the cart's products and total
        final updatedProducts = Map<String, int>.from(cart.products);
        updatedProducts.update(
          productId,
              (existingQuantity) => existingQuantity - quantity,
        );

        // Calculate the updated totals for the cart
        final updatedTotalProduct = cart.totalProduct - quantity;
        final updatedTotal = cart.total - (cart.products[productId]! * quantity);

        // Update the cart in the list
        _carts[cartIndex] = ShoppingCart(
          id: cart.id,
          name: cart.name,
          totalProduct: updatedTotalProduct,
          total: updatedTotal,
          products: updatedProducts,
        );

        // Find the product by its ID
        final product = _findProductById(context, productId);
        if (product != null) {
          // Update product stock quantity
          product.stockQuantity += quantity;
          // Update the product in database
          await _firestoreService.updateProduct(product.id, {
            'stockQuantity': product.stockQuantity,
          });
        }

        // Remove the product from the cart if quantity reaches 0
        if (_carts[cartIndex].products[productId] == 0) {
          _carts[cartIndex].products.remove(productId);
        }

        // Notify listeners to update the UI
        notifyListeners();

        // Update the cart in database
        await _firestoreService.updateCart(cart.id, {
          'name': cart.name,
          'totalProduct': updatedTotalProduct,
          'total': updatedTotal,
          'products': updatedProducts,
        });
      }
    }
  }


  // Delete a cart
  Future<void> deleteCart(String cartId) async {
    _carts.removeWhere((cart) => cart.id == cartId);
    notifyListeners();

    // Delete the cart from database
    await _firestoreService.deleteCart(cartId);
  }

  // Helper method to find a product by ID
  Product? _findProductById(BuildContext context, String productId) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return productProvider.findProductById(productId);
  }
}
