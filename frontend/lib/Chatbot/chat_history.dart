import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat History")),
      body: const Center(
          child: Text("This is where chat history will be displayed.")),
    );
  }
}
