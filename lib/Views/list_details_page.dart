import 'package:flutter/material.dart';
import 'package:techno_mobile/Widgets/semi_round_count_box.dart';
import 'package:techno_mobile/models/ShoppingCart.dart';

class ListDetailsPage extends StatefulWidget{
  final ShoppingCart shoppingCart;
  final int checkedCount;
  final int totalCount;

  const ListDetailsPage({super.key,required this.shoppingCart, required this.checkedCount, required this.totalCount});

  @override
  State<StatefulWidget> createState() {
    return ListDetailsPageState();
  }

}

class ListDetailsPageState extends State<ListDetailsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //----------------The title of this page------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.shoppingCart.name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              CountBox(checkedCount: widget.checkedCount, totalCount: widget.totalCount),
            ],
          ),

          //-------------------The body-----------------------------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/emptyList.png',
                  height: 300,
                ),
                Text(
                  "Your list is empty",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  "Click the button below to add an item now",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ),
          //-------------------The create button---------------------------
          TextButton.icon(
            onPressed: (){},
            label: Text(
              "Add item",
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

}