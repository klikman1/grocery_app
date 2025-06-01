import 'dart:io';

import 'package:flutter/material.dart';
import '../Provider/CartProvider.dart';
import '../models/Product.dart';
import 'edit_product_page.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  /// Pop up to confirm if you are deleting the product
  void confirmAndDelete(
    BuildContext context,
    ProductProvider productProvider,
    Product product,
  ) async {
    // First check if product is in any cart
    final isInCart = Provider.of<CartProvider>(context, listen: false)
        .isProductInAnyCart(product.id);

    if (isInCart) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Cannot Delete Product"),
          content: const Text(
            "This product exists in one or more carts. Please remove it from all carts before deleting.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "Delete",
              style:
                  TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await productProvider.deleteProduct(product.id);
      Navigator.of(context).pop();
    }
  }

  /// Button to direct to edit page
  Widget getEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductPage(
              productId: product.id,
              name: product.name,
              price: product.unityPrice,
              description: product.nutritionDetails,
              image: product.imageUrl,
            ),
          ),
        );
      },
    );
  }

  /// Product image widget
  Widget getProductImage() {
    // Check if the image is from internet
    if (product.imageUrl.startsWith('http')) {
      // Network image
      return ClipOval(
        child: Image.network(
          product.imageUrl,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Image from gallery or device storage
      return ClipOval(
        child: Image.file(
          File(product.imageUrl),
          height: 200,
          width: 350,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  /// Price and title widget
  Widget getPriceAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${product.unityPrice} €",
          style: const TextStyle(color: Colors.green, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        )
      ],
    );
  }

  /// Description widget
  Widget getDescription() {
    return Text(
      product.nutritionDetails,
      style: TextStyle(fontSize: 17, color: Colors.grey[700]),
    );
  }

  /// Product info (image, name, price) widget
  Widget buildProductInfoPart(BuildContext context, ProductProvider givenProvider) {
    return Container(
      height: 450,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      margin: const EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          getPriceAndTitle(),
          const SizedBox(height: 40),
          getDescription(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => confirmAndDelete(context, givenProvider, product),
                icon: const Icon(Icons.delete, color: Colors.white,),
                label: const Text("Delete Product", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Product Details"),
          actions: [
            getEditButton(context),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: getProductImage()),
              buildProductInfoPart(context, provider),
            ],
          ),
        ),
      ),
    );
  }
}
