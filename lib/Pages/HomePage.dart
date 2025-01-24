import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';
import 'package:techno_mobile/productWidgets/ProductWidget.dart';
import 'package:techno_mobile/productWidgets/ProductInTheList.dart';
import 'package:techno_mobile/models/Product.dart';

import '../Provider/CartProvider.dart';
import '../firebaseAPI/dummyData.dart';
import '../firebaseAPI/FireStoreService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the products when the page is loaded
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchProducts();

    // Fetch carts from database
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchCarts();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return provider.products.isEmpty
            ? Center(
          child: Text(
            'No products yet. Start adding some!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            return ProductWidget(product: provider.products[index]);
          },
        );
      },
    );
  }

}
// STORE DATA IN FIREBASE BY FORCE

// return ElevatedButton(
//   onPressed: () async {
//     for (final product in dummyProducts) {
//       await firestoreService.addProduct(product);
//     }
//     print("All products added!");
//   },
//   child: Text('Add Products'),
// );

