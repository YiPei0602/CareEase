import 'package:flutter/material.dart';
import 'components/main_layout.dart'; // Import MainLayout
import 'screens/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false, // Hide the debug banner
  //     title: 'CareEase',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: MainLayout(), // ✅ Start the app with MainLayout
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareEase',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set main color to blue
      ),
      home: const MainPage(), // Show MainPage when the app starts
    );
  }
}
