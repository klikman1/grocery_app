import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Widgets/round_image_widget.dart';
import 'package:techno_mobile/models/CartProduct.dart';
import '../Provider/CartProvider.dart';
import '../Provider/ProductProvider.dart';
import '../Views/product_details_page.dart';
import '../models/Product.dart';

class ProductCard extends StatefulWidget {
  final String productId;

  const ProductCard({super.key, required this.productId});

  @override
  State<StatefulWidget> createState() {
    return ProductCardState();
  }
}

class ProductCardState extends State<ProductCard> {
  bool isAdded = false;

  void toggleCartStatus() {
    setState(() {
      isAdded = !isAdded;
    });
  }

  // Add product to a cart
  void addProductToCart(BuildContext context, Product product) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final carts = cartProvider.carts;

    CartProduct newCartProduct = CartProduct(
      cartProductId: '',
      productId: product.id,
      quantity: 1,
      isChecked: false,
    );

    // Create a new cart and add the product
    if (carts.isEmpty) {
      final newCartId = await cartProvider.createCart("My List");
      cartProvider.addCartProduct(newCartId, newCartProduct);
      // Change the button text
      toggleCartStatus();
    }
    // Added the product in the single existing cart
    else if (carts.length == 1) {
      cartProvider.addCartProduct(carts.first.id, newCartProduct);
      // Change the button text
      toggleCartStatus();
    }
    // Let the user choose which cart before adding the product
    else {
      showModalBottomSheet(
        context: context,

        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: carts.map((cart) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text(cart.name, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    cartProvider.addCartProduct(cart.id, newCartProduct);
                    Navigator.pop(context);
                    toggleCartStatus();
                  },
                ),
              );
            }).toList(),
          );

        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context)
        .products
        .firstWhere((p) => p.id == widget.productId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.white38,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundImageWidget(imageLink: product.imageUrl),
            const SizedBox(height: 12.0),
            Text(
              "${product.unityPrice.toStringAsFixed(2)} €",
              style: TextStyle(
                color: Colors.lightGreen[700],
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            TextButton.icon(
              onPressed: () => isAdded == false
                  ? addProductToCart(context, product)
                  : toggleCartStatus,
              icon: Icon(
                isAdded ? Icons.check_circle : Icons.shopping_bag_outlined,
                color: isAdded ? Colors.lightGreen : Colors.lightGreen,
              ),
              label: Text(isAdded ? "Added" : "Add to cart"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
