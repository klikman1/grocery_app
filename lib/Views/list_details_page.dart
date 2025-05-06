import 'package:flutter/material.dart';

class ListDetailsPage extends StatefulWidget{
  const ListDetailsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListDetailsPageState();
  }

}

class ListDetailsPageState extends State<ListDetailsPage>{
  List<String> listDetails = [];

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
                "Saturday weekly shopping",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  "0/0",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
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