import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../models/Product.dart';

class EditProductPage extends StatelessWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.unityPrice.toString());
    final imageController = TextEditingController(text: product.imageUrl);
    final stockController =
        TextEditingController(text: product.stockQuantity.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Edit Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),

            // Edit Price
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "Stock"),
              keyboardType: TextInputType.number,
            ),

            // Edit Price
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Price (€)"),
              keyboardType: TextInputType.number,
            ),

            // Edit Image URL
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: "Image URL"),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // Delete Product Button
                ElevatedButton(
                  onPressed: () {
                    provider.deleteProduct(product.id);
                    Navigator.pop(context); // Return to the previous page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "Delete Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Save the changes
                ElevatedButton(
                  onPressed: () {
                    provider.updateProduct(
                        productId: product.id,
                        name: nameController.text,
                        unityPrice: double.parse(priceController.text),
                        imageUrl: imageController.text,
                        stockQuantity: int.parse(stockController.text));
                    Navigator.pop(context); // Return to the previous page
                  },
                  child: Text("Save Changes"),
                ),
              ],
            )
            // Save Changes Button
          ],
        ),
      ),
    );
  }
}
