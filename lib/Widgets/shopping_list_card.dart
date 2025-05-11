import 'package:flutter/material.dart';
import 'package:techno_mobile/Views/list_details_page.dart';
import 'package:techno_mobile/Widgets/semi_round_count_box.dart';

class ShoppingListCard extends StatefulWidget {
  final String listName;

  const ShoppingListCard({super.key, required this.listName});

  @override
  State<StatefulWidget> createState() {
    return ShoppingListCardState();
  }
}

class ShoppingListCardState extends State<ShoppingListCard> {
  @override
  Widget build(BuildContext context) {
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
              widget.listName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              "rice, bread, plantain + 13 more",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            )
          ],
        ),

        //------------------------Semi-round count box ------------------
        trailing: CountBox(),
        onTap: (){
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
