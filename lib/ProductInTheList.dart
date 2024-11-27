import 'package:flutter/material.dart';

class ProductInTheList extends StatefulWidget {
  const ProductInTheList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductInTheListState();
  }
}

class _ProductInTheListState extends State<ProductInTheList> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.add_a_photo, size: 40),
              ),
              const SizedBox(width: 10),
              const Text(
                "Item 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  quantity > 0
                      ? IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              quantity--;
                            });
                          },
                        )
                      : const SizedBox(),
                  Text(quantity.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),

              const Text("€" + "Price")
            ],
          )
        ],
      ),
    );
  }
}
