import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Footer({Key? key, required this.selectedIndex, required this.onItemTapped}) : super(key: key);

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
          label: "Tracker",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          label: "Chatbot",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.calendar_today),
          label: "Appointment",
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          label: "Profile",
        ),
      ],
    );
  }
}