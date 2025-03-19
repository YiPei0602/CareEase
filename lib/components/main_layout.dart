import 'package:flutter/material.dart';
import '../DailyTracker/tracker.dart';
import '../Chatbot/chatbot.dart';
import '../Spotter/spotter.dart';
import '../Profile/profile.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // List of screens (imported from different module folders)
  final List<Widget> _screens = [
    DailyTrackerScreen(),
    ChatbotScreen(),
    SpotterScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Persistent Header (Visible on All Pages)
      appBar: AppBar(
        title: Text("CareEase"),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),

      // ✅ Dynamic Content Area
      body: _screens[_selectedIndex],

      // ✅ Persistent Navigation Bar (Visible on All Pages)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue, // Blue Background
        selectedItemColor: Colors.white, // White Icon when selected
        unselectedItemColor: Colors.white70, // Slightly faded white
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes), label: "Daily Tracker"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatbot"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Disease Spotter"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
