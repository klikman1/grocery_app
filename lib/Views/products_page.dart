import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';
import 'package:techno_mobile/Widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() {
    return ProductsPageState();
  }
}

class ProductsPageState extends State<ProductsPage> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsFromDB = Provider.of<ProductProvider>(context).products;
    print("Loaded products count: ${productsFromDB.length}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            // 🔍 Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search keywords...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            */
            const SizedBox(height: 20),

            const Text(
              "All products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),

            const SizedBox(height: 10),

            //-------------------- Grid of Product Cards --------------------
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : productsFromDB.isEmpty
                  ? const Center(child: Text("No products found"))
                  : GridView.builder(
                itemCount: productsFromDB.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final product = productsFromDB[index];
                  return ProductCard(productId: product.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
