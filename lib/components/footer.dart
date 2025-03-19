import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Footer({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.track_changes), label: "Daily Tracker"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatbot"),
        BottomNavigationBarItem(
            icon: Icon(Icons.search), label: "Disease Spotter"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
