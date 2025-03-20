import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Map<String, dynamic>> messages = [
    {'sender': 'CareEase', 'text': "Hey Lucas!\nHow are you feeling today?", 'isUser': false},
    {'sender': 'Lucas', 'text': "I have a headache today.", 'isUser': true},
    {'sender': 'CareEase', 'text': "How severe is your headache on a scale of 1-10?", 'isUser': false},
    {'sender': 'Lucas', 'text': "8", 'isUser': true},
    {
      'sender': 'CareEase',
      'text': "Got it. Do you have any of the following additional symptoms?",
      'isUser': false,
      'options': ['Stiff Neck', 'Nausea', 'Sensitive to Light', 'None of These']
    },
  ];

  String selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
      //   title: Text("CareEase"),
      //   centerTitle: true,
      //   actions: [IconButton(icon: Icon(Icons.account_circle), onPressed: () {})],
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   elevation: 1,
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text("Chat History"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("New Session"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['isUser'];
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (index == 0 || messages[index - 1]['sender'] != message['sender'])
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            message['sender'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(color: isUser ? Colors.white : Colors.black),
                        ),
                      ),
                      if (message.containsKey('options'))
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 10.0,
                          children: (message['options'] as List<String>).map((option) {
                            final isSelected = option == selectedOption;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedOption = option;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.mic, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

