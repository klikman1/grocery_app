import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Widgets/product_in_list_card.dart';
import '../Provider/CartProvider.dart';
import '../Widgets/add_product_in_list_popup.dart';
import '../Widgets/semi_round_count_box.dart';

class ListDetailsPage extends StatelessWidget {
  final String cartId;

  const ListDetailsPage({super.key, required this.cartId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final cart = cartProvider.carts.firstWhere((c) => c.id == cartId);
        final products = cart.products;
        final checkedCount = products.where((p) => p.isChecked).length;
        final totalCount = products.length;

        return Scaffold(
          appBar: AppBar(),
          backgroundColor: Colors.grey.shade100,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cart.name,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    CountBox(
                        checkedCount: checkedCount, totalCount: totalCount),
                  ],
                ),
              ),

              // Products or empty list
              Expanded(
                child: products.isEmpty
                    ? _emptyListDisplay()
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductInListCard(
                            cartId: cartId,
                            productFromCart: products[index],
                          );
                        },
                      ),
              ),

              // Total price panel
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${cart.total.toStringAsFixed(2)}€',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: _addItemButton(context, cartId),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _emptyListDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/emptyList.png', height: 200),
        Text("Your list is empty", style: TextStyle(fontSize: 18.0)),
        Text("Click the button below to add an item now",
            style: TextStyle(fontSize: 18.0)),
      ],
    );
  }

  Widget _addItemButton(BuildContext context, String cartID) {
    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: AddProductInListPopup(selectedCartId: cartID),
          ),
        );
      },
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "Add item",
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      style: TextButton.styleFrom(
          backgroundColor: Colors.lightGreen.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          fixedSize: Size(280, 50)),
    );
  }
}
