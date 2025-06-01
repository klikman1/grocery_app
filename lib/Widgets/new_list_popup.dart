import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';

class NewListPopup extends StatefulWidget {
  const NewListPopup({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewListPopupState();
  }
}

class NewListPopupState extends State<NewListPopup> {
  final RegExp regExp = RegExp(r'^[\w\s\-]{2,}$');

  final TextEditingController _controller =
      TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //--------------------Title of the dialog-------------------------------
      title: Text(
        "Name your list",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      //------------------Content of the dialog--------------------------------
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            label: Text("Enter a name"),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),

      //-------------------Cancel and Continue Buttons-----------------------
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            backgroundColor: Colors.lightGreen.shade600,
            padding: EdgeInsets.symmetric(horizontal: 35.0),
          ),
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          width: 15.0
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty && regExp.hasMatch(_controller.text.trim())) {
              final listName = _controller.text.trim();
              Provider.of<CartProvider>(context, listen: false).createCart(listName);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cart "$listName" created successfully!'),
                ),
              );
            }
          },

          style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen.shade600,
              padding: EdgeInsets.symmetric(horizontal: 35.0)),
          child: Text(
            "Continue",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
