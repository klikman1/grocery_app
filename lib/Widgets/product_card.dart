import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double weight;

  const ProductCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.weight,
    super.key,
  });

  @override
  State<ProductCard> createState() {
    return ProductCardState();
  }
}

class ProductCardState extends State<ProductCard> {
  int quantity = 1;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(widget.imageUrl),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.price.toStringAsFixed(2)}€', style: TextStyle(color: Colors.green)),
                Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('${widget.weight} lbs', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.add, color: Colors.green),
                onPressed: () => setState(() => quantity++),
              ),
              Text(quantity.toString(), style: TextStyle(fontSize: 16, color: Colors.grey)),
              IconButton(
                icon: Icon(Icons.remove, color: Colors.green),
                onPressed: () {
                  if (quantity > 1) {
                    setState(() => quantity--);
                  }
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.green,
            ),
            onPressed: () => setState(() => isChecked = !isChecked),
          ),
        ],
      ),
    );
  }
}
