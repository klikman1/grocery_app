import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/firebaseAPI/dummyData.dart';
import 'package:techno_mobile/models/Product.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Pages/EditProductPage.dart';

/*
 Displays a product card with image, description, and an "Add to cart" button
 */
class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context, listen: false);


    // Dialog for selecting a cart
    Widget selectCart(){
      return AlertDialog(
        title: const Text("Select Cart"),
        content: StatefulBuilder(
          builder: (context, setState) {
            String? selectedCartId; // Store selected cart id
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown to select a cart
                DropdownButton<String>(
                  value: selectedCartId,
                  hint: const Text("Select a cart"),
                  isExpanded: true,
                  items: provider.carts.map((cart) {
                    return DropdownMenuItem<String>(
                      value: cart.id,
                      child: Text(cart.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCartId = value;
                      provider.addProductToCart(
                        selectedCartId!,
                        product,
                        1,
                      );
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without adding
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    }

    return Card(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      shadowColor: Colors.black87,
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      margin: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          // Navigate to the EditProductPage with the product details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductPage(product: product),
            ),
          );
        },
        child: Column(
          children: [
            // Product image with fade-in effect
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ).image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product title
                  Text(
                    product.name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Product price
                  Text(
                    "${product.unityPrice} €",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  // Product description
                  Text(
                    product.nutritionDetails,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  // Add to cart button
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black87),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        if (provider.carts.isEmpty) {
                          provider.createCart("QuickList");
                        }

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return selectCart();
                          },
                        );
                      },
                      child: const Text("Add to cart"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
