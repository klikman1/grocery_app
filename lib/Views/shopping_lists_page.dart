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
    /// Shopping list page title text
    Widget title() {
      return Text(
        "Your shopping Lists",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    /// Alert dialog for editing the cart name
    Widget editDialog(BuildContext context, CartProvider provider,
        TextEditingController controllerName, String cartId) {
      return AlertDialog(
        //--------------------Title of the dialog-------------------------------
        title: const Text('Edit Cart Name',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),

        //------------------Content of the dialog--------------------------------
        content: TextField(
          controller: controllerName,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        //-------------------Cancel and Continue Buttons-----------------------
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightGreen.shade600,
              padding: EdgeInsets.symmetric(horizontal: 35.0),
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.lightGreen.shade600,
                padding: EdgeInsets.symmetric(horizontal: 35.0)),
            onPressed: () {
              final newName = controllerName.text.trim();
              if (newName.isNotEmpty) {
                // Update the cart name in the provider
                provider.updateCartName(cartId, newName);

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cart name updated!')),
                );
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      body: Consumer<CartProvider>(
        builder: (context, provider, child) {
          // ---------------There is no groceries list created yet --------
          if (provider.carts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //----------------The title of this page------------------------
                title(),
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
          // ---------------There is a groceries list created --------
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
                    child: Center(child: title()),
                  ),
                  //--------------------Groceries list --------------------
                  Flexible(
                    child: ListView.builder(
                      itemCount: provider.carts.length,
                      itemBuilder: (context, index) {
                        final cart = provider.carts[index]; 
                        return Slideable(
                          key: ValueKey(cart.id),
                          items: [
                            ActionItems(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent),
                              onPress: () {
                                final cartNameController =
                                    TextEditingController(
                                  text: cart.name,
                                );

                                /// Edit the Cart's name
                                showDialog(
                                  context: context,
                                  // Prevents dismissing by tapping outside
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return editDialog(context, provider,
                                        cartNameController, cart.id);
                                  },
                                );
                              },
                              backgroudColor: Colors.transparent,
                            ),
                            ActionItems(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPress: () {
                                /// Delete cart
                                provider.deleteCart(cart.id);
                                /// Show a snack bar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${cart.name} has been deleted'),
                                  ),
                                );
                              },
                              backgroudColor: Colors.transparent,
                            ),
                          ],
                          //---- Display the shopping list card --------------
                          child: ShoppingListCard(cartId: cart.id),
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
