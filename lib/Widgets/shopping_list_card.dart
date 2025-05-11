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
    final specificCart = Provider.of<CartProvider>(context, listen: false)
        .carts
        .firstWhere((cart) => cart.id == widget.cartId);

    // Products that are in the specified cart
    var products = "Empty list";
    if(specificCart.products.join(",").isNotEmpty){
      products = specificCart.products.join(",");
    }

    // Total number of products
    final totalCount = specificCart.products.length;

    // Total number of checked products
    final checkedCount = specificCart.products.where((p) => p.isChecked).length;


    return Card(
      elevation: 6.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        //------------- List title and its products-----------------------
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              specificCart.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              products,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            )
          ],
        ),

        //------------------------Semi-round count box ------------------
        trailing: CountBox(checkedCount: checkedCount, totalCount: totalCount),
        onTap: () {
          // Navigates to the list details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListDetailsPage(),
            ),
          );
        },
      ),
    );
  }
}
