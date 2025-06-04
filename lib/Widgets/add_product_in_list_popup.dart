import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';
import '../Provider/CartProvider.dart';
import '../models/CartProduct.dart';
import '../models/Product.dart';

class AddProductInListPopup extends StatefulWidget {
  final String selectedCartId;

  const AddProductInListPopup({
    super.key,
    required this.selectedCartId,
  });

  @override
  State<AddProductInListPopup> createState() {
    return _AddProductInListPopupState();
  }
}

class _AddProductInListPopupState extends State<AddProductInListPopup> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final List<Product> allProducts =
        Provider.of<ProductProvider>(context).products;

    final filtered = allProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //-------------------Search product part-----------------------
            TextField(
              decoration: InputDecoration(
                hintText: 'Search product',
                filled: true,
                fillColor: Colors.grey.shade300,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            SizedBox(height: 16),
            //-------------List view of product to add in the cart---------------
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  return ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addCartProduct(
                          widget.selectedCartId,
                          CartProduct(
                            cartProductId: '',
                            productId: product.id,
                            quantity: 1,
                            isChecked: false,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('ADD'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
