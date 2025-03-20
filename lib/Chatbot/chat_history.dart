import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat History")),
      body: Center(child: Text("This is where chat history will be displayed.")),
    );
  }
}

