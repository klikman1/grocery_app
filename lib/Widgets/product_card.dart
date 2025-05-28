import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductProvider.dart';
import '../Views/product_details_page.dart';

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
            SizedBox(
              width: 120,
              height: 120,
              child: ClipOval(
                child: (product.imageUrl.startsWith('http')
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(product.imageUrl),
                        fit: BoxFit.cover,
                      )),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              "${product.unityPrice.toStringAsFixed(2)} €",
              style: TextStyle(
                color: Colors.lightGreen[700],
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              product.nutritionDetails,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 4.0),
            TextButton.icon(
              onPressed: toggleCartStatus,
              icon: Icon(
                isAdded ? Icons.check_circle : Icons.shopping_bag_outlined,
                color: isAdded ? Colors.green : Colors.lightGreen,
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
