import 'package:flutter/material.dart';

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
    return Container(
      alignment: Alignment.center,
      child: const Text("This is Carts page")
    );
  }
}
