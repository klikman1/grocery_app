import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CartProduct.dart';
import '../models/Product.dart';
import '../models/ShoppingCart.dart';

class FirestoreService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference cartsCollection =
      FirebaseFirestore.instance.collection('carts'); // Cart collection

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
  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedProductData) async {
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
      await productsCollection
          .doc(productId)
          .update({'stockQuantity': stockQuantity});
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
      final cartsFromDatabase = await cartsCollection.get();

      final carts = await Future.wait(cartsFromDatabase.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;

        // Fetch cart products
        final productsSnapshot =
            await cartsCollection.doc(doc.id).collection('products').get();

        final cartProducts = productsSnapshot.docs.map((productDoc) {
          final productData = productDoc.data();
          return CartProduct(
            cartProductId: productDoc.id,
            productId: productData['productId'],
            quantity: productData['quantity'],
            isChecked: productData['isChecked'] ?? false,
          );
        }).toList();

        return ShoppingCart(
          id: doc.id,
          name: data['name'],
          totalProduct: data['totalProduct'],
          total: (data['total'] as num).toDouble(),
          products: cartProducts,
        );
      }).toList());

      print(carts.toString());

      return carts;
    } catch (e) {
      print("Error fetching carts from database: $e");
      return [];
    }
  }

  // Add a cart to Database
  Future<String> addCart(Map<String, dynamic> cartData) async {
    try {
      final docRef = await cartsCollection.add(cartData);
      print("Cart added to Database!");
      return docRef.id;
    } catch (e) {
      print("Error adding cart to Database: $e");
      return e.toString();
    }
  }

  //////////////////////////////////////////////////////////////
  /////////////// C A R T S P R O D U C T S ///////////////////
  ////////////////////////////////////////////////////////////

  // TODO: MODIFY THE TOTAL QUANTITY AND TOTAL PRICE OF THE CART
  // Add a CartProduct to a Cart
  Future<void> addCartProduct(String cartId, CartProduct cartProduct) async {
    try {
      final cartDoc = cartsCollection.doc(cartId);
      final cartProductsCollection = cartDoc.collection('products');

      // 0. generates a random ID
      final cartProductsCollectionWithID = cartProduct.cartProductId.isEmpty
          ? cartProductsCollection.doc()
          : cartProductsCollection.doc(cartProduct.cartProductId);

      // 1. Add the CartProduct
      await cartProductsCollectionWithID.set({
        'productId': cartProduct.productId,
        'quantity': cartProduct.quantity,
        'isChecked': cartProduct.isChecked,
      });

      print("CartProduct added to cart $cartId!");

      // Now update total quantity and total price in the ShoppingCart
      await _recalculateCartTotals(cartId);
    } catch (e) {
      print("Error adding cartProduct: $e");
    }
  }

  // Fetch all CartProducts for a Cart
  Future<List<CartProduct>> fetchCartProducts(String cartId) async {
    try {
      final cart = cartsCollection.doc(cartId);
      final snapshot = await cart.collection('products').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CartProduct(
          cartProductId: doc.id,
          productId: data['productId'],
          quantity: data['quantity'],
          isChecked: data['isChecked'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching cart products: $e");
      return [];
    }
  }

  // Update a CartProduct
  Future<void> updateCartProduct(String cartId, CartProduct cartProduct) async {
    try {
      final cartProductCollection = cartsCollection
          .doc(cartId)
          .collection('products')
          .doc(cartProduct.cartProductId);

      await cartProductCollection.update({
        'productId': cartProduct.productId,
        'quantity': cartProduct.quantity,
        'isChecked': cartProduct.isChecked,
      });

      await _recalculateCartTotals(cartId);

      print("CartProduct ${cartProduct.cartProductId} updated!");
    } catch (e) {
      print("Error updating cartProduct: $e");
    }
  }

  // Update a CartProduct quantity
  Future<void> updateCartProductQuantity(String cartId, String cartProductId, int quantity) async {
    try {
      final cartDoc = cartsCollection.doc(cartId);
      final cartProductDoc = cartDoc.collection('products').doc(cartProductId);

      await cartProductDoc.update({'quantity': quantity});

      await _recalculateCartTotals(cartId);

      print("Cart product quantity updated!");
    } catch (e) {
      print("Error updating cartProduct quantity: $e");
    }
  }

  // Delete a CartProduct
  Future<void> deleteCartProduct(String cartId, String cartProductId) async {
    try {
      await cartsCollection
          .doc(cartId)
          .collection('products')
          .doc(cartProductId)
          .delete();

      await _recalculateCartTotals(cartId);

      print("CartProduct $cartProductId deleted from cart $cartId.");
    } catch (e) {
      print("Error deleting cartProduct: $e");
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  // Update a cart in Database
  Future<void> updateCart(
      String cartId, Map<String, dynamic> updatedCartData) async {
    try {
      await cartsCollection.doc(cartId).update(updatedCartData);
      print("Cart updated in Database!");
    } catch (e) {
      print("Error updating cart in Database: $e");
    }
  }

  // TODO: MODIFY THE TOTAL QUANTITY AND TOTAL PRICE OF THE CART
  // Updates the `products` list of a cart in Database
  Future<void> updateCartProducts(ShoppingCart cart) async {
    try {
      // Transform into a list the new products data of the cart
      final productsData = cart.products
          .map((cp) => {
                'productId': cp.productId,
                'quantity': cp.quantity,
                'isChecked': cp.isChecked,
              })
          .toList();

      // Update the DB with new data
      await cartsCollection.doc(cart.id).update({
        'products': productsData,
      });

      print("Cart products updated in Database!");
    } catch (e) {
      print("Error updating cart products: $e");
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

  // Update total quantity and total price in the ShoppingCart
  Future<void> _recalculateCartTotals(String cartId) async {
    try {
      final cartCollection = cartsCollection.doc(cartId);
      final cartProductsSnapshot =
          await cartCollection.collection('products').get();

      int totalQuantity = 0;
      double totalPrice = 0.0;

      for (var doc in cartProductsSnapshot.docs) {
        final data = doc.data();
        final int quantity = data['quantity'] ?? 0;
        final productId = data['productId'];

        // Fetch product price
        final productSnapshot = await productsCollection.doc(productId).get();
        final productData = productSnapshot.data() as Map<String, dynamic>;
        final unitPrice = productData['unityPrice'] ?? 0;

        totalQuantity += quantity;
        totalPrice += quantity * unitPrice;
      }

      // Update the cart's totalProduct and total
      await cartCollection.update({
        'totalProduct': totalQuantity,
        'total': totalPrice,
      });

      print("Cart totals updated for cart $cartId!");
    } catch (e) {
      print("Error recalculating cart totals: $e");
    }
  }
}
