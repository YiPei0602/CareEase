import 'package:flutter/material.dart';
import '../Chatbot/chatbot.dart';
import '../Appointment/appointment_screen.dart';
import '../Home/home.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../Profile/profile.dart';
import '../DailyTracker/symptoms_list_page.dart';


class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
  CareEaseHomePage(),
  SymptomsListPage(),
  ChatbotScreen(),
  AppointmentScreen(
    specialty: 'Cardiologist Specialist', // Ensure it's a valid specialty
    userState: 'Penang', // Ensure it's a valid state
  ),
  ProfileScreen(),
];


  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: Header(currentIndex: _selectedIndex),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
