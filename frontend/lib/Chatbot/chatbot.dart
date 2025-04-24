import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:careease_app/Chatbot/api_service.dart';
import 'package:careease_app/Chatbot/chat_history.dart';
import 'package:careease_app/Chatbot/stt_service.dart';
import 'package:careease_app/Chatbot/avatar_webpage.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  List<List<Map<String, dynamic>>> _chatSessions = [[]];
  int _currentSessionIndex = 0;

  bool _speechMode = false;
  bool _isTyping = false;
  bool _recording = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });

    _chatSessions[_currentSessionIndex].add({
      'sender': 'CareEase',
      'text': 'Hey Lucas!\nHow are you feeling today?',
      'options': null,
      'isUser': false,
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _sendText(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _chatSessions[_currentSessionIndex]
          .add({'sender': 'You', 'text': text.trim(), 'options': null, 'isUser': true});
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final bot = await ApiService.sendMessage(text);

      setState(() {
        _chatSessions[_currentSessionIndex].add({
          'sender': 'CareEase',
          'text': bot['response'],
          'options': (bot['options'] is List && (bot['options'] as List).isNotEmpty)
              ? bot['options'] as List
              : null,
          'isUser': false,
        });
      });
      _scrollToBottom();
    } catch (e) {
      setState(() => _chatSessions[_currentSessionIndex].add({
            'sender': 'CareEase',
            'text': 'Error: $e',
            'options': null,
            'isUser': false,
          }));
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFF2EFF5),
      body: Stack(
        children: [
          if (_speechMode) const Positioned.fill(child: AvatarWebPage()),
          Column(
            children: [
              _topBar(),
              Expanded(child: _chatList()),
              _typingBar(bottom),
            ],
          ),
          if (_recording) _recordOverlay(),
        ],
      ),
    );
  }

  Widget _topBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(children: [
          Tooltip(
            message: _speechMode ? 'Text Mode' : 'Avatar Mode',
            child: GestureDetector(
              onTap: () => setState(() => _speechMode = !_speechMode),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Icon(
                  _speechMode
                      ? CupertinoIcons.textformat
                      : CupertinoIcons.speaker_1_fill,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          ),
          const Spacer(),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            borderRadius: BorderRadius.circular(20),
            onPressed: () => Navigator.push(
                context, CupertinoPageRoute(builder: (_) => ChatHistoryScreen())),
            child: const Text('Chat History'),
          ),
          const SizedBox(width: 8),

          // New Session Only (Delete removed)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _chatSessions.add([]);
                  _currentSessionIndex = _chatSessions.length - 1;
                  _chatSessions[_currentSessionIndex].add({
                    'sender': 'CareEase',
                    'text': 'Hey Lucas!\nHow are you feeling today?',
                    'options': null,
                    'isUser': false,
                  });
                });
              },
              child: const Text('New Session',
                  style: TextStyle(color: Colors.purple)),
            ),
          ),
        ]),
      );

  Widget _chatList() => ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.all(12),
        itemCount: _chatSessions[_currentSessionIndex].length,
        itemBuilder: (_, i) {
          final m = _chatSessions[_currentSessionIndex][i];
          return Column(
            crossAxisAlignment:
                m['isUser'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _Bubble(text: m['text'], isUser: m['isUser']),
              if (m['options'] != null)
                Wrap(
                  spacing: 8,
                  children: (m['options'] as List<dynamic>).map((opt) {
                    return GestureDetector(
                      onTap: () => _sendText(opt.toString()),
                      child: Chip(
                        label: Text(opt.toString(),
                            style: const TextStyle(color: Colors.blue)),
                        backgroundColor: Colors.blue[50],
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      );

  Widget _typingBar(double bottom) => Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Row(children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: 'Ask me anything…', border: InputBorder.none),
                onSubmitted: _sendText,
              ),
            ),
            GestureDetector(
              onTap: _isTyping ? () => _sendText(_controller.text) : null,
              onLongPressStart: (_) async {
                if (!_isTyping) {
                  setState(() => _recording = true);
                  await SttService.start();
                }
              },
              onLongPressEnd: (_) async {
                if (!_isTyping) {
                  setState(() => _recording = false);
                  final voice = await SttService.stop();
                  if (voice.isNotEmpty) _sendText(voice);
                }
              },
              child: Icon(
                _isTyping
                    ? CupertinoIcons.arrow_up_circle_fill
                    : CupertinoIcons.mic,
                size: 30,
                color: CupertinoColors.activeBlue,
              ),
            ),
            const SizedBox(width: 16),
          ]),
        ),
      );

  Widget _recordOverlay() => Positioned.fill(
        child: Container(
          color: Colors.black45,
          child: const Center(
              child: Text('Listening…',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))),
        ),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.isUser});
  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext ctx) => Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * .7),
          decoration: BoxDecoration(
            color: isUser ? CupertinoColors.activeBlue : Colors.grey[300],
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black)),
        ),
      );
}
