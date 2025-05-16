import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
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
          ClipOval(
            child: Image.asset(
              "assets/logo_light.png",
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 12.0),

          Text(
            "3.00 €",
            style: TextStyle(
              color: Colors.lightGreen[700],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Fresh Broccoli",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "1 kg",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),

          const SizedBox(height: 8.0),

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
    );
  }
}
