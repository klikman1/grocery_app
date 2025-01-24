import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/Product.dart';

// Displays a product in a shopping cart with quantity adjustment
class ProductInTheList extends StatefulWidget {
  final String productId; // ID of the product to display
  final int productQuantity; // Quantity in the cart associated to this product
  final String concernedCart;

  const ProductInTheList(
      {super.key,
      required this.productId,
      required this.productQuantity,
      required this.concernedCart});

  @override
  State<StatefulWidget> createState() {
    return _ProductInTheListState();
  }
}

class _ProductInTheListState extends State<ProductInTheList> {
  int quantity = 0; // Current product quantity
  double totalPrice = 0.0; // Total price of the product
  Product? productFound; // The product object, fetched by ID
  bool isButtonDisabled = false; // State of the decrement


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    try {
      productFound = provider.products.firstWhere((prod) => prod.id == widget.productId);
      quantity = widget.productQuantity;
      if (productFound != null) {
        totalPrice =
            productFound!.unityPrice * quantity; // Initialize total price
      }
    } catch (e) {
      productFound = null;
    }
    // Show message if product is not found
    if (productFound == null) {
      return const Center(
        child: Text("Product not found or out of stock"),
      );
    }

    return Dismissible(
      key: ValueKey(widget.productId),
      // Unique key for the product
      direction: DismissDirection.endToStart,
      // Swipe to delete
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // Remove the product from the cart
        Provider.of<CartProvider>(context, listen: false)
            .removeProductFromCart(context, widget.concernedCart, widget.productId);

        // Show a snackbar to confirm deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${productFound!.name} removed from the cart'),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: productFound!.imageUrl.isNotEmpty
                      ? FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(productFound!.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.add_a_photo, size: 40),
                ),
                const SizedBox(width: 10),
                Text(
                  productFound!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            Consumer<CartProvider>(
              builder: (context, provider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Decrement button
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 0 && !isButtonDisabled) {
                            setState(() {
                              quantity--;
                              totalPrice = productFound!.unityPrice *
                                  quantity; // Update total price
                              if (quantity == 0) {
                                isButtonDisabled =
                                    true; // Disable button if quantity is 0
                              }
                            });
                            provider.removeQuantityOfProductFromCart(context,
                                widget.concernedCart,
                                widget.productId,
                                quantity);
                          }
                        },
                      ),

                      /*
                       Display current quantity
                      */
                      Text(quantity.toString()),

                      /*
                       Increment button
                      */
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (quantity < productFound!.stockQuantity) {
                              // Check stock availability
                              setState(() {
                                quantity += 1;
                                totalPrice = productFound!.unityPrice*quantity;
                                isButtonDisabled = false;
                              });
                              provider.addProductToCart(widget.concernedCart,
                                  productFound!, quantity);
                            } else {
                              // Show a message if no stock is available
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No more stock available")),
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  // Display total price
                  Text("€ ${totalPrice.toStringAsFixed(2)}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
