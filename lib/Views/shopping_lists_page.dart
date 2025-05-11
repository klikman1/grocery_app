import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/Provider/CartProvider.dart';
import 'package:techno_mobile/Widgets/new_list_popup.dart';
import 'package:techno_mobile/Widgets/shopping_list_card.dart';

class ShoppingListsPage extends StatefulWidget {
  const ShoppingListsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ShoppingListsPageState();
  }
}

class ShoppingListsPageState extends State<ShoppingListsPage> {
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
                        return ShoppingListCard(
                            listName: provider.carts[index].name);
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
