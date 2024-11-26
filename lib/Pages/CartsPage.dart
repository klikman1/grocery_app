import 'package:flutter/material.dart';
import 'package:techno_mobile/ProductBox.dart';

class CartsPage extends StatefulWidget {
  const CartsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CartsPage();
  }
}

class _CartsPage extends State<CartsPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          ProductBox(),
          ProductBox(),
          ProductBox(),
          ProductBox(),
          ProductBox(),
        ],
      ),
    );
  }
}
