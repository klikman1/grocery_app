import 'package:flutter/material.dart';
import 'package:techno_mobile/Views/products_page.dart';
import 'package:techno_mobile/Views/shopping_lists_page.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // default is 1 = Products page
  int _selectedIndex = 1;

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    const ShoppingListsPage(),
    const ProductsPage(),
  ];

  /// Update the selected index when a navigation item is tapped
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Build the icon widget for each tab, with green background if selected
  Widget _buildIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return isSelected
        ? Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    )
        : Icon(icon, color: Colors.grey[600], size: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the current selected page
      body: _pages[_selectedIndex],

      // Bottom navigation bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            //---------------------Shopping lists tab----------------------
            GestureDetector(
              onTap: () => onItemTapped(0),
              child: _buildIcon(Icons.shopping_cart_outlined, 0),
            ),

            //--------------------- Products tab --------------------------
            GestureDetector(
              onTap: () => onItemTapped(1),
              child: _buildIcon(Icons.shopping_bag_outlined, 1),
            ),
          ],
        ),
      ),
    );
  }
}
