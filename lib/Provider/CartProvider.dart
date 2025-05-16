import 'package:flutter/material.dart';
import 'package:techno_mobile/models/ShoppingCart.dart';
import '../firebaseAPI/FireStoreService.dart';
import '../models/CartProduct.dart';

class CartProvider extends ChangeNotifier {
  final List<ShoppingCart> _carts = [];
  final FirestoreService _firestoreService = FirestoreService();

  List<ShoppingCart> get carts => _carts;

  // Fetch all carts from database
  Future<void> fetchCarts() async {
    try {
      final cartsFromDatabase = await _firestoreService.fetchCarts();
      _carts.clear();
      _carts.addAll(cartsFromDatabase);

      notifyListeners();
    } catch (e) {
      print("Error fetching carts: $e");
    }
  }

  // Create a cart
  Future<void> createCart(String name) async {
    await _firestoreService.addCart({
      'name': name,
      'totalProduct': 0,
      'total': 0.0,
    });

    fetchCarts();
    notifyListeners();
  }

  // Add a CartProduct to the cart
  Future<void> addCartProduct(String cartId, CartProduct cartProduct, double unitPrice) async {
    await _firestoreService.addCartProduct(cartId, cartProduct);
    await fetchCarts();
  }

  // Update a CartProduct in the cart
  Future<void> updateCartProduct(String cartId, CartProduct cartProduct) async {
    await _firestoreService.updateCartProduct(cartId, cartProduct);
    await fetchCarts();
  }

  // Update a CartProduct quantity in the cart
  Future<void> updateCartProductQuantity(String cartId, String cartProductId, int newQuantity) async {
    print(newQuantity);

    await _firestoreService.updateCartProductQuantity(cartId, cartProductId, newQuantity);
    notifyListeners();

  }

  // Remove a CartProduct from the cart
  Future<void> deleteCartProduct(String cartId, String cartProductId) async {
    await _firestoreService.deleteCartProduct(cartId, cartProductId);
    await fetchCarts();
  }

  // Update cart name
  Future<void> updateCartName(String cartId, String newName) async {
    final index = _carts.indexWhere((cart) => cart.id == cartId);
    if (index != -1) {
      _carts[index].name = newName;
      notifyListeners();
      await _firestoreService.updateCart(cartId, {'name': newName});
    }
  }

  // Delete a cart
  Future<void> deleteCart(String cartId) async {
    final cart = _carts.firstWhere((cart) => cart.id == cartId);

    // Delete each CartProduct from Firestore
    for (final product in cart.products) {
      await _firestoreService.deleteCartProduct(cartId, product.cartProductId);
    }

    // Then delete the cart from Firestore
    await _firestoreService.deleteCart(cartId);

    // Finally, remove it locally and notify
    _carts.removeWhere((cart) => cart.id == cartId);
    notifyListeners();
    }


  // Given the ID, returns the product stored in the cart
  CartProduct getCartProductById(String cartId, String cartProductId) {
    final cart = _carts.firstWhere((c) => c.id == cartId);
    return cart.products.firstWhere((p) => p.cartProductId == cartProductId);
  }

  // Return the quantity of the product in a cart
  int getQuantity(String cartId, String cartProductId) {
    final product = getCartProductById(cartId, cartProductId);

    return product.quantity ?? 0;
  }

  void toggleCartProductCheck(String cartId, String productId) {
    final cartProduct = getCartProductById(cartId, productId);
    if (cartProduct != null) {
      cartProduct.isChecked = !cartProduct.isChecked;
      notifyListeners();
    }
  }

}
