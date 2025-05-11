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
    _carts.removeWhere((cart) => cart.id == cartId);
    notifyListeners();
    await _firestoreService.deleteCart(cartId);
  }
}
