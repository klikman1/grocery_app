import 'package:flutter/material.dart';
import 'package:techno_mobile/Widgets/product_card.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> productList = [
      ProductCard(),
      ProductCard(),
      ProductCard(),
      ProductCard(),
      ProductCard(),
      ProductCard(),
      ProductCard(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👇 Search bar below AppBar
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
            const SizedBox(height: 20),
            const Text(
              "Featured products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  return productList[index];
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );


  }
}
