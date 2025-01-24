import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/CartProvider.dart';

class CreateShoppingCartPage extends StatefulWidget {
  const CreateShoppingCartPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewShoppingCartState();
  }
}

class _NewShoppingCartState extends State<CreateShoppingCartPage> {
  final _formKey = GlobalKey<FormState>();
  String cartName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create a New Cart"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: "Cart Name",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            cartName = value.trim();
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter a cart name.";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<CartProvider>(context, listen: false)
                  .createCart(cartName);
              Navigator.pop(context); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cart "$cartName" created successfully!'),
                ),
              );
            }
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}
