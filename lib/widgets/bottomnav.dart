import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:rinosfirstproject/Screens/home.dart';
import 'package:rinosfirstproject/Screens/category.dart';
import 'package:rinosfirstproject/Screens/profile.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentselectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    CategoriesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentselectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentselectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: currentselectedIndex,
        onItemSelected: _onItemTapped,
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blueAccent,  // Blue color when active
            inactiveColor: Colors.blueGrey, // Grey color when inactive
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.category),
            title: Text('Category'),
            activeColor: Colors.orangeAccent,  // Orange color when active
            inactiveColor: Colors.orange,  // Grey color when inactive
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Colors.purpleAccent, // Purple color when active
            inactiveColor: Colors.purple, // Grey color when inactive
          ),
        ],
        animationCurve: Curves.easeInOut,  // Smooth animation
        animationDuration: Duration(milliseconds: 300),  // Animation duration
      ),
    );
  }
}
