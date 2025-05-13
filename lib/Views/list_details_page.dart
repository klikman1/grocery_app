import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/ProductProvider.dart';
import 'package:techno_mobile/Widgets/add_product_in_list_popup.dart';
import 'package:techno_mobile/Widgets/product_card.dart';
import 'package:techno_mobile/Widgets/semi_round_count_box.dart';
import 'package:techno_mobile/models/CartProduct.dart';
import 'package:techno_mobile/models/ShoppingCart.dart';

class ListDetailsPage extends StatefulWidget {
  final ShoppingCart shoppingCart;
  final int checkedCount;
  final int totalCount;

  const ListDetailsPage(
      {super.key,
      required this.shoppingCart,
      required this.checkedCount,
      required this.totalCount});

  @override
  State<StatefulWidget> createState() {
    return ListDetailsPageState();
  }
}

class ListDetailsPageState extends State<ListDetailsPage> {
  @override
  Widget build(BuildContext context) {
    List<CartProduct> productList = widget.shoppingCart.products;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false).products;

    // -------------------No products were added yet--------------------
    if (productList.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.grey.shade100,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //----------------The title of this page------------------------
            _title(),
            //-------------------The body-----------------------------------
            _emptyListDisplay(),
            //-------------------The create button---------------------------
            _addItemButton()
          ],
        ),
      );
    }

    // -------------There is at least a product in the cart ----------------
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //----------------The title of this page------------------------
          _title(),
          //-------------------The body-----------------------------------
          Expanded(
            child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  var product = productProvider
                      .firstWhere((p) => p.id == productList[index].productId);

                  return ProductCard(
                    imageUrl: product.imageUrl,
                    name: product.name,
                    price: product.unityPrice,
                    details: product.nutritionDetails,
                  );
                }),
          ),
          //-------------------Total Panel---------------------------------
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 80), // Add enough bottom padding
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.shoppingCart.total}€',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

        ],
      ),
      //-------------------The create button---------------------------
      floatingActionButton:  _addItemButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  // Title of the page
  Widget _title() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.shoppingCart.name,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          CountBox(
            checkedCount: widget.checkedCount,
            totalCount: widget.totalCount,
          ),
        ],
      ),
    );
  }

  // Method of list display
  Widget _emptyListDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      margin:  const EdgeInsets.symmetric(vertical: 140.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/emptyList.png', height: 200),
          const Text(
            "Your list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          const Text(
            "Click the button below to add an item now",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  // Method of "Add item" button
  Widget _addItemButton() {
    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: AddProductInListPopup(
              selectedCartId: widget.shoppingCart.id,
            ),
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
        fixedSize: Size(280, 50)
      ),
    );
  }
}
