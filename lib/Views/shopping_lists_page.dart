import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slideable/slideable.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/Widgets/new_list_popup.dart';
import 'package:techno_mobile/Widgets/shopping_list_card.dart';
import '../Provider/ProductProvider.dart';

class ShoppingListsPage extends StatefulWidget {
  const ShoppingListsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ShoppingListsPageState();
  }
}

class ShoppingListsPageState extends State<ShoppingListsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the products when the page is loaded
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchProducts();

    // Fetch carts from database
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchCarts();

  }

  @override
  Widget build(BuildContext context) {

    // Shopping list page title text
    Widget _title(){
      return Text(
        "Your shopping Lists",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }


    return Scaffold(
      //-----------------------Title--------------------------

      backgroundColor: Colors.grey.shade100,

      body: Consumer<CartProvider>(
        builder: (context, provider, child) {
          // ---------------There is no groceries list created yet --------
          if (provider.carts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //----------------The title of this page------------------------
                _title(),
                //-------------------The body-----------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/cart.png',
                        height: 150,
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        "You have not added any shopping lists, Tap the button below to create one now",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(fontSize: 18.0),
                      )
                    ],
                  ),
                ),

                //-------------------The create button---------------------------
                TextButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const NewListPopup(),
                  ),
                  label: Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreen.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 25.0)),
                )
              ],
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //----------------The title of this page------------------------
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: _title()
                    ),
                  ),
                  //--------------------Groceries list --------------------
                  Flexible(
                    child: ListView.builder(
                      itemCount: provider.carts.length,
                      itemBuilder: (context, index) {
                        final cart = provider.carts[index]; // Current cart
                        return Slideable(
                          key: ValueKey(cart.id),
                          items: [
                            ActionItems(
                                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                onPress: () {
                                  final cartNameController =
                                  TextEditingController(text: cart.name);

                                  // Edit the Cart's name
                                  showDialog(
                                    context: context,
                                    // Prevents dismissing by tapping outside
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Container();
                                      // TODO Implement the edit part
                                    },
                                  );
                                },
                                backgroudColor: Colors.transparent),
                            ActionItems(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPress: () {
                                  // Delete cart
                                  provider.deleteCart(cart.id);

                                  // Show a snack bar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${cart.name} has been deleted'),
                                    ),
                                  );
                                },
                                backgroudColor: Colors.transparent),
                          ],
                          child: ShoppingListCard(
                              cartId: cart.id
                          ),
                        );
                      },
                    ),
                  ),

                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const NewListPopup(),
                    ),
                    label: Text(
                      "Create",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.lightGreen.shade600,
                        padding: EdgeInsets.symmetric(horizontal: 25.0)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
