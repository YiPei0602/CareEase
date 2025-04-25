import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:careease_app/Chatbot/api_service.dart';
import 'package:careease_app/Chatbot/stt_service.dart';
import 'package:careease_app/Chatbot/avatar_webpage.dart';
import 'chat_message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAvatarMode = false;
  String _currentAvatarText = '';
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    _handleSendMessage('hello');
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _startNewSession() {
    setState(() {
      _messages.clear();
      _currentAvatarText = '';
    });
    _initializeChat();
  }

  Future<void> _handleSendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
      ));
      _isTyping = true;
      _textController.clear();
    });

    _scrollToBottom();

    try {
      if (_isAvatarMode) {
        // In avatar mode, let the avatar handle the response
        setState(() {
          _currentAvatarText = message;
        });
      } else {
        // In text mode, handle response normally
        final response = await ApiService.sendMessage(message);
        
        String botResponse = '';
        List<String> options = [];
        
        if (response.containsKey('response')) {
          botResponse = response['response'];
          if (response['options'] != null) {
            options = List<String>.from(response['options']);
          }
        } else {
          botResponse = "I'm sorry, I couldn't process that request.";
        }

        setState(() {
          _messages.add(ChatMessage(
            text: botResponse,
            isUser: false,
            options: options,
            onOptionSelected: (selectedOption) {
              _handleSendMessage(selectedOption);
            },
          ));
          _isTyping = false;
        });

        _scrollToBottom();
      }
    } catch (e) {
      print('Error handling message: $e');
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _handleAvatarResponse(Map<String, dynamic> response) {
    if (!_isAvatarMode) return;

    String botResponse = '';
    List<String> options = [];
    
    if (response.containsKey('response')) {
      botResponse = response['response'];
      if (response['options'] != null) {
        options = List<String>.from(response['options']);
      }
    }

    setState(() {
      _messages.add(ChatMessage(
        text: botResponse,
        isUser: false,
        options: options,
        onOptionSelected: (selectedOption) {
          _handleSendMessage(selectedOption);
        },
      ));
      _isTyping = false;
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareEase Chatbot'),
        actions: [
          // New Session Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewSession,
            tooltip: 'New Session',
          ),
          // Chat History Button
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to chat history
            },
            tooltip: 'Chat History',
          ),
          // Avatar Mode Toggle
          IconButton(
            icon: Icon(_isAvatarMode ? Icons.chat : Icons.face),
            onPressed: () {
              setState(() {
                _isAvatarMode = !_isAvatarMode;
                if (_isAvatarMode && _messages.isNotEmpty) {
                  for (var message in _messages) {
                    if (!message.isUser) {
                      _currentAvatarText = message.text;
                      break;
                    }
                  }
                }
              });
            },
            tooltip: _isAvatarMode ? 'Switch to Text Mode' : 'Switch to Avatar Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isAvatarMode)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(150),
                ),
                child: AvatarWebPage(
                  initialText: _currentAvatarText,
                  onResponse: _handleAvatarResponse,
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onSubmitted: _handleSendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSendMessage(_textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: message.isUser ? 64 : 0,
        right: message.isUser ? 0 : 64,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.isUser
            ? CupertinoColors.activeBlue
            : CupertinoColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isUser
              ? CupertinoColors.white
              : CupertinoColors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
