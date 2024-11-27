import 'package:flutter/material.dart';
import 'package:techno_mobile/ProductInTheList.dart';
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
    return const SingleChildScrollView(
      child: Column(
        children: [
          ProductInTheList(),
          ProductInTheList(),
          ProductInTheList(),
          ProductInTheList(),
          ProductInTheList(),
        ],
      ),
    );
  }
}
