import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/productWidgets/ProductInTheList.dart';
import '../models/ShoppingCart.dart';

class CartDetailsPage extends StatefulWidget {
  final ShoppingCart cart; // The shopping cart data passed to this page

  // Constructor to initialize the CartDetailsPage with a ShoppingCart object
  const CartDetailsPage({super.key, required this.cart});

  @override
  State<CartDetailsPage> createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    return Scaffold(
      appBar: AppBar(
        // AppBar with the title displaying the cart's name
        title: Text("${cart.name}'s cart details"),
      ),
      body: Column(
        children: [
          // Title at the top of the list
          Padding(
            padding: const EdgeInsets.all(16.0), // Spacing around the text
            child: Align(
              alignment: Alignment.centerLeft, // Aligns the text to the left
              child: Text(
                "Products in Cart",
                style: TextStyle(
                  fontSize: 20, // Font size for the title
                  fontWeight: FontWeight.bold, // Bold font style
                  color: Colors.grey[800], // Gray color for the text
                ),
              ),
            ),
          ),
          // List of products in the cart
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, provider, child) => ListView.builder(
                // The number of items in the cart
                itemCount: provider.carts.firstWhere((ct) => ct.id == cart.id).products.length,
                // Builds each item in the list
                itemBuilder: (context, index) {
                  final foundCart = provider.carts.firstWhere((ct) => ct.id == cart.id);

                  final id = foundCart.products.keys.elementAt(index);
                  final quantity = foundCart.products[id]!;

                  return ProductInTheList(
                    productId: id,// Passes the product ID to the item widget
                    productQuantity: quantity, // Passes the product quantity,
                    concernedCart:foundCart.id,
                  );
                },
              ),
            ),
          ),
          const Divider(), // Divider between the product list and total section
          // Total section at the bottom
          _buildTotalSection(cart.id),
        ],
      ),
    );
  }

  /// Widget for the total section displayed at the bottom of the page
  Widget _buildTotalSection(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Spacing inside the total section
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces elements evenly with space between
        children: [
          // Text label for the total amount
          const Text(
            "Total: ", // Label text
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), // Large, bold font
          ),
          // Total amount in Euros, formatted to 2 decimal places
          Consumer<CartProvider>(
            builder: (context, provider, child) => Text(
              "€ ${provider.carts.firstWhere((ct) => ct.id == id ).total.toStringAsFixed(2)}", // Displays the total price
              style: const TextStyle(fontSize: 16), // Font size for the total amount
            ),
          ),
        ],
      ),
    );
  }
}
