import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Footer(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      activeColor: Colors.blue,
      inactiveColor: Colors.grey,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chart_bar),
          label: "Daily Tracker",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          label: "Chatbot",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          label: "Disease Spotter",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
