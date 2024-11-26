import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:techno_mobile/Pages/HomePage.dart';
import 'package:techno_mobile/Pages/NewProductPage.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DefaultPageState();
  }
}

class _DefaultPageState extends State<DefaultPage> {
  final List<String> _pageTitles = [
    "Home page",
    "Add page",
    "Shopping carts",
  ];

  final List<Widget> _navigationIcons = [
    const Icon(
      Icons.home,
      size: 40,
    ),
    const Icon(
      Icons.add,
      size: 40,
    ),
    const Icon(
      Icons.shopping_cart,
      size: 40,
    ),
  ];

  final List<Widget> _pages = [
    const HomePage(),
    const HomePage(),
    NewProductPage()
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
        onTap: (index) {
          if (index == 1) {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(25.0),
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "What do you want to create?",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.black87),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                              onPressed: () {},
                              child: const Text("A shopping list"),
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.black87),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => NewProductPage(),
                                //   ),
                                // );
                              },
                              child: const Text("A product"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
