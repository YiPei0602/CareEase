import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:careease_app/services/api_service.dart';
import 'package:careease_app/Chatbot/chat_history.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();
  bool showPdfPrompt = false; // Controls PDF prompt visibility

  @override
  void initState() {
    super.initState();
    messages.add({
      'sender': 'CareEase',
      'text': "Hey Lucas!\nHow are you feeling today?",
      'isUser': false
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'You',
        'text': messageText,
        'isUser': true,
      });
    });

    _scrollToBottom();

    try {
      final botResponse = await ApiService.sendMessage(messageText);

      setState(() {
        messages.add({
          'sender': 'CareEase',
          'text': botResponse["response"],
          'isUser': false,
          'options': botResponse["options"].isNotEmpty
              ? botResponse["options"]
              : null, // Only add options if present
        });
        if (botResponse["response"].toLowerCase().contains("diagnose") ||
            botResponse["response"]
                .toLowerCase()
                .contains("possible diseases")) {
          showPdfPrompt = true;
        }
      });
      _scrollToBottom();
    } catch (error) {
      setState(() {
        messages.add({
          'sender': 'CareEase',
          'text': "Error connecting to server.",
          'isUser': false
        });
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void startNewSession() {
    setState(() {
      messages.clear();
      showPdfPrompt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ChatHistoryScreen()), // Link to chat history page
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text("Chat History"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      messages.clear();
                      messages.add({
                        'sender': 'CareEase',
                        'text': "Hey Lucas!\nHow are you feeling today?",
                        'isUser': false
                      });
                    });
                  },
                  child: const Text("New Session"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['isUser'];

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (index == 0 ||
                          messages[index - 1]['sender'] != message['sender'])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            message['sender'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black),
                        ),
                      ),
                      if (message.containsKey('options') &&
                          message['options'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 10.0,
                            children: (message['options'] as List<String>)
                                .map((option) {
                              return GestureDetector(
                                onTap: () {
                                  sendMessage(
                                      option); // Send selected option as input
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    option,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (showPdfPrompt)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text("Would you like a PDF summary of this chat?"),
                  ElevatedButton(
                    onPressed: () {
                      // Implement PDF generation logic
                    },
                    child: const Text("Generate PDF"),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
