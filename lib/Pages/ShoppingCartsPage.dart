import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/models/ShoppingCart.dart';
import 'package:slideable/slideable.dart';
import 'CartDetailsPage.dart';

class ShoppingCartsPage extends StatelessWidget {
  const ShoppingCartsPage({super.key});

  // Alert dialog for editing the cart name
  Widget editDialog(BuildContext context, CartProvider provider, TextEditingController controllerName, String cartId){
    return AlertDialog(
      title: const Text('Edit Cart Name'),
      content: TextField(
        controller: controllerName,
        decoration: const InputDecoration(hintText: 'Enter new name'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            final newName = controllerName.text.trim();
            if (newName.isNotEmpty) {
              // Update the cart name in the provider
              provider.updateCartName(cartId, newName);

              // Show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cart name updated!')),
              );
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Carts'), // Page title
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) {
          bool resetSlide = false;

          if (provider.carts.isEmpty) {
            // If there are no carts, display a centered message
            return const Center(
              child: Text(
                'No carts created yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }


          return ListView.builder(
            itemCount: provider.carts.length, // Number of items in the list
            itemBuilder: (context, index) {
              final cart = provider.carts[index]; // Current cart

              return Slideable(
                key: ValueKey(cart.id), // Unique key for the cart
                resetSlide: resetSlide,
                items: [
                  ActionItems(icon: const Icon(Icons.edit,color: Colors.blueAccent), onPress: () {
                    final cartNameController = TextEditingController(text: cart.name);

                    // Edit the Cart's name
                     showDialog(
                      context: context,
                      barrierDismissible: false, // Prevents dismissing by tapping outside
                      builder: (BuildContext context) {
                        return editDialog(context, provider, cartNameController, cart.id);
                      },
                    );
                  }, backgroudColor: Colors.transparent),

                  ActionItems(icon: const Icon(Icons.delete,color: Colors.red), onPress: () {
                    // Delete cart
                    provider.deleteCart(cart.id);

                    // Show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text('${cart.name} has been deleted'),
                    ),
                    );
                  }, backgroudColor: Colors.transparent),
                ],
                child: Card(
                  child: ListTile(
                    title: Text(cart.name), // Cart name
                    subtitle: Text(
                      'Products: ${cart.totalProduct} | Total: € ${cart.total.toStringAsFixed(2)}', // Cart details
                    ),
                    trailing: const Icon(Icons.arrow_forward), // Navigation icon
                    onTap: () {
                      // Navigates to the cart details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartDetailsPage(cart: cart),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
    ),
    );
  }
}

// Function to show dialog for editing cart name
  Future<void> editCartNameDialog(BuildContext context, TextEditingController nameController, CartProvider provider, ShoppingCart cart) async {
    AlertDialog(
      title: const Text('Edit Cart Name'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(hintText: 'Enter new name'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            final newName = nameController.text.trim();
            if (newName.isNotEmpty) {
              // Update the cart name in the provider
              provider.updateCartName(cart.id, newName);

              // Show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cart name updated!')),
              );
            }
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }

