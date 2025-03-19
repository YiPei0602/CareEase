import 'package:flutter/material.dart';
import 'components/main_layout.dart'; // Import MainLayout
import 'MainPage/mainpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'CareEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(), // ✅ Start the app with MainLayout
    );
  }
}
