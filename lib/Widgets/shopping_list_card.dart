import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/Views/list_details_page.dart';
import 'package:techno_mobile/Widgets/semi_round_count_box.dart';

class ShoppingListCard extends StatefulWidget {
  final String cartId;

  const ShoppingListCard({super.key, required this.cartId});

  @override
  State<StatefulWidget> createState() {
    return ShoppingListCardState();
  }
}

class ShoppingListCardState extends State<ShoppingListCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        final specificCart =
            provider.carts.firstWhere((cart) => cart.id == widget.cartId);

        // Total number of products
        final totalCount = specificCart.products.length;

        // Total number of checked products
        final checkedCount =
            specificCart.products.where((p) => p.isChecked).length;

        return Card(
          elevation: 6.0,
          margin: EdgeInsets.all(6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 12.0,
            ),

            title: Text(
              specificCart.name,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),


            subtitle: const Text(
              "Read me",
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),


            trailing: CountBox(checkedCount: checkedCount, totalCount: totalCount),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListDetailsPage(cartId: specificCart.id),
                ),
              );
            },
          ),

        );
      },
    );
  }
}
