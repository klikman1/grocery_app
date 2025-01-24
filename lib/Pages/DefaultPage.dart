import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:techno_mobile/Pages/CreateProductPage.dart';
import '../Provider/CartProvider.dart';
import '../Pages/HomePage.dart';
import '../Pages/ShoppingCartsPage.dart';
import '../Pages/CreateShoppingCartPage.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<StatefulWidget> createState() => _DefaultPageState();
}

// State class for DefaultPage that manages navigation and initialization
class _DefaultPageState extends State<DefaultPage> {
  // List of titles for the navigation tabs
  final List<String> _pageTitles = [
    "Home Page",
    "Add Page",
    "Shopping Cart List",
  ];

  // List of icons for the navigation bar
  final List<Widget> _navigationIcons = [
    const Icon(Icons.home, size: 40),
    const Icon(Icons.add, size: 40),
    const Icon(Icons.shopping_cart, size: 40),
  ];

  // Pages corresponding to each tab
  final List<Widget> _pages = [
    const HomePage(),
    const HomePage(),
    ShoppingCartsPage(),
  ];

  // Tracks the currently selected tab index
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initialization(); // Handles splash screen removal during initialization
  }

  /// Handles initialization logic such as splash screen removal
  void initialization() async {
    print("Pausing...");
    await Future.delayed(const Duration(seconds: 2)); // Simulates a delay
    print("Unpausing");
    FlutterNativeSplash.remove(); // Removes splash screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with dynamic title based on the selected tab
      appBar: AppBar(
        centerTitle: true, // Centers the title
        title: Text(_pageTitles[_selectedIndex]), // Displays current tab title
        foregroundColor: Colors.blueGrey,
        backgroundColor: Colors.black,
      ),
      // Displays the selected page using an IndexedStack
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Bottom navigation bar with curved style
      bottomNavigationBar: CurvedNavigationBar(
        items: _navigationIcons, // Adds icons to the navigation bar
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        backgroundColor: Colors.white,
        color: Colors.black12,
        index: 1, // Default selected tab
        onTap: (index) {
          if (index == 1) {
            // Shows a modal for the "Add Page" when the middle tab is selected
            _showAddPageModal(context);
          } else {
            // Updates the selected tab index
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  /// Displays a modal bottom sheet for adding a new shopping list or product
  void _showAddPageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center, // Centers the content
          padding: const EdgeInsets.all(25.0),
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "What do you want to create?", // Modal title
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Button to create a shopping list
                  Consumer<CartProvider>(
                    builder: (context, provider, child) => TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black87),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        // Opens the dialog to create a shopping cart
                        showDialog(
                          context: context,
                          builder: (context) => const CreateShoppingCartPage(),
                        );
                      },
                      child: const Text("A Shopping List"),
                    ),
                  ),
                  // Button to create a product
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black87),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      // Navigates to the product creation page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateProductPage(),
                        ),
                      );
                    },
                    child: const Text("A Product"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
