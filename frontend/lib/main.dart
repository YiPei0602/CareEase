import 'package:flutter/material.dart';
import 'MainPage/mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'CareEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(), // ✅ Start the app with MainLayout
    );
  }
}
