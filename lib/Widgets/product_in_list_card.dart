import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Widgets/round_image_widget.dart';
import 'package:techno_mobile/models/CartProduct.dart';

import '../Provider/CartProvider.dart';
import '../Provider/ProductProvider.dart';

class ProductInListCard extends StatefulWidget {
  final String cartId;
  final CartProduct productFromCart;

  const ProductInListCard({
    required this.cartId,
    required this.productFromCart,
    super.key,
  });

  @override
  State<ProductInListCard> createState() {
    return ProductInListCardState();
  }
}

class ProductInListCardState extends State<ProductInListCard> {

  // TODO: Quantity isn't being updated in the interface. Check box not updated in the DB
  @override
  Widget build(BuildContext context) {
    // Get all products from DB to fetch product details
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false).products;

    // Get the actual product (not just the cart info)
    final foundProduct = productProvider.firstWhere(
          (p) => p.id == widget.productFromCart.productId,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          // ----------------------Product image ----------------------------
          RoundImageWidget(imageLink: foundProduct.imageUrl, size: 100),

          SizedBox(width: 20),

          // -----------------------Product details--------------------------
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${foundProduct.unityPrice.toStringAsFixed(2)}€',
                    style: TextStyle(color: Colors.green)),
                Text(foundProduct.name,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(foundProduct.nutritionDetails,
                    style: TextStyle(color: Colors.black54), softWrap: true),
              ],
            ),
          ),

          // -----------------------Quantity and checkbox -------------------
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final cartId = widget.cartId;
              final cartProductId = widget.productFromCart.cartProductId;
              final cartProduct = cartProvider.getCartProductById(cartId, cartProductId);

              if (cartProduct == null) return SizedBox();

              final quantity = cartProduct.quantity;
              final isChecked = cartProduct.isChecked;

              return Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          cartProvider.updateCartProductQuantity(
                              cartId, cartProductId, quantity + 1);
                        },
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.green),
                        onPressed: () {
                          if (quantity > 1) {
                            cartProvider.updateCartProductQuantity(
                                cartId, cartProductId, quantity - 1);
                          }
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      cartProvider.toggleCartProductCheck(cartId, cartProductId);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

