import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final int? currentIndex;
  
  Header({this.currentIndex});
  
  @override
  Widget build(BuildContext context) {
    String title = "CareEase";
    
    // Update title based on current screen index
    if (currentIndex != null) {
      switch (currentIndex) {
        case 0:
          title = "Home";
          break;
        case 1:
          title = "Symptoms Tracker";
          break;
        case 2:
          title = "CareBot";
          break;
        case 3:
          title = "Appointment";
          break;
        case 4:
          title = "Profile";
          break;
      }
    }
    
    return CupertinoNavigationBar(
      middle: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      // Removing border for a cleaner iOS look
      border: null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);
}