import 'package:flutter/material.dart';
import 'screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareEase',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set main color to blue
      ),
      home: const MainPage(),  // Show MainPage when the app starts
    );
  }
}
