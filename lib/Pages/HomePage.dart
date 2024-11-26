import 'package:flutter/material.dart';
import 'package:techno_mobile/models/Product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final List<Product> _products = [
    Product(name: "ggg", price: 23, description: "dddd", imageUrl: "ddd"),
    Product(name: "ggg", price: 23, description: "dddd", imageUrl: "ddd"),
    Product(name: "ggg", price: 23, description: "dddd", imageUrl: "ddd"),
    Product(name: "ggg", price: 23, description: "dddd", imageUrl: "ddd"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.red,
      child: const Row(
        children: [
          Text("This is home page"),
          Text("This is home page"),
          Text("This is home page"),
        ],
      ),
    );
  }
}
