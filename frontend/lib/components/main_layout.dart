import 'package:flutter/material.dart';
import '../DailyTracker/tracker.dart';
import '../Chatbot/chatbot.dart';
import '../Spotter/index.dart';
import '../Home/home.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../Profile/profile.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CareEaseHomePage(),
    DailyTrackerScreen(),
    ChatbotScreen(),
    const SpotterScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // Updated Header with current index
      appBar: Header(currentIndex: _selectedIndex),

      // ✅ Dynamic Content
      body: _screens[_selectedIndex],

      // ✅ Use the extracted Footer
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
