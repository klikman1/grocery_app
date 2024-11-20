import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:techno_mobile/Pages/CartsPage.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{
  final List<String> _pageTitles = [
    "Home page",
    "Add page",
    "Shopping carts",
  ];

  final List<Widget> _navigationIcons = [
    const Icon(Icons.home, size: 40,),
    const Icon(Icons.add, size: 40,),
    const Icon(Icons.shopping_cart, size: 40,),
  ];

  final List<Widget> _pages = [
    // Home page,
    // Add page,
    const CartsPage()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_pageTitles[_selectedIndex]),
        foregroundColor: Colors.blueGrey,
        backgroundColor: Colors.black,
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: _navigationIcons,
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        backgroundColor: Colors.white,
        color: Colors.black12,
        index: 1,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });

          if(index == 2){
            const CartsPage();
          }

          log(index);
        },
      ),
    );
  }


}