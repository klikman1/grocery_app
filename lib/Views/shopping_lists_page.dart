import 'package:flutter/material.dart';
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
  List<String> shoppingLists = [
    "Weekly Groceries",
    "Party Prep",
    "Office Supplies",
    "Weekly Groceries",
    "Party Prep",
  ];

  @override
  Widget build(BuildContext context) {
    // ---------------There is no groceries list created yet --------
    if (shoppingLists.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.grey.shade100,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //----------------The title of this page------------------------
            Text(
              "Your shopping Lists",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

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
              onPressed: () =>
                  showDialog(
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
        ),
      );
    }

    //------------------The groceries list isn't empty---------------------
    return Scaffold(

      //-----------------------Title--------------------------
      appBar: AppBar(
        title: const Text(
          "Your Shopping Lists",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //--------------------Groceries list --------------------

              Flexible(
                child: ListView.builder(
                  itemCount: shoppingLists.length,
                  itemBuilder: (context, index) {
                    return ShoppingListCard(listName: shoppingLists[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: //--------------------Create button ----------------------
      TextButton.icon(
        onPressed: () =>
            showDialog(
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
    );
  }
}
