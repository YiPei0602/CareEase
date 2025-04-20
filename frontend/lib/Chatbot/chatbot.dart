import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:careease_app/Chatbot/api_service.dart';      // <-- your FastAPI client
import 'package:careease_app/Chatbot/chat_history.dart';
import 'package:careease_app/Chatbot/stt_service.dart';
import 'package:careease_app/Chatbot/avatar_service.dart';    // keep if you use D‑ID

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scroll     = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  late VideoPlayerController _video;
  bool _speechMode = false;
  bool _isTyping   = false;
  bool _recording  = false;

  @override
  void initState() {
    super.initState();
    _video = VideoPlayerController.asset('assets/doctor_avatar_female.mp4');
    _controller.addListener(() => setState(() {
      _isTyping = _controller.text.trim().isNotEmpty;
    }));
    _messages.add({
      'sender': 'CareEase',
      'text'  : 'Hey Lucas!\nHow are you feeling today?',
      'options': null,
      'isUser': false,
    });
  }

  @override
  void dispose() {
    _video.dispose();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /* ─────────── core chat send ─────────── */
  Future<void> _sendText(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'You', 'text': text.trim(), 'options': null, 'isUser': true});
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final bot = await ApiService.sendMessage(text); // {response, options}

      setState(() {
        _messages.add({
          'sender' : 'CareEase',
          'text'   : bot['response'],
          'options': (bot['options'] is List && (bot['options'] as List).isNotEmpty)
    ? bot['options'] as List
    : null,

          'isUser' : false,
        });
      });
      _scrollToBottom();

      /* avatar (optional) */
      if (_speechMode && bot['response'].toString().isNotEmpty) {
        final url = await AvatarService.getAvatarVideo(bot['response']);
        _video = VideoPlayerController.network(url);
        await _video.initialize();
        _video.play();
      }
    } catch (e) {
      setState(() => _messages.add({
            'sender': 'CareEase',
            'text'  : 'Error: $e',
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

  /* ─────────── UI ─────────── */
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFF2EFF5),
      body: Stack(
        children: [
          if (_speechMode && _video.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width : _video.value.size.width,
                  height: _video.value.size.height,
                  child : VideoPlayer(_video),
                ),
              ),
            ),

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
              onTap: () async {
                setState(() => _speechMode = !_speechMode);
                if (_speechMode) {
                  await _video.initialize();
                  _video..seekTo(Duration.zero)..play();
                } else {
                  _video.pause();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Icon(_speechMode ? CupertinoIcons.textformat
                                        : CupertinoIcons.speaker_1_fill,
                    color: CupertinoColors.activeBlue),
              ),
            ),
          ),
          const Spacer(),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            borderRadius: BorderRadius.circular(20),
            onPressed: () => Navigator.push(
              context, CupertinoPageRoute(builder: (_) => ChatHistoryScreen())),
            child: const Text('Chat History'),
          ),
        ]),
      );

  Widget _chatList() => ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.all(12),
        itemCount: _messages.length,
        itemBuilder: (_, i) {
          final m = _messages[i];
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

            /* mic button with STT */
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
              child: Icon(_isTyping
                  ? CupertinoIcons.arrow_up_circle_fill
                  : CupertinoIcons.mic, size: 30,
                  color: CupertinoColors.activeBlue),
            ),
            const SizedBox(width: 16),
          ]),
        ),
      );

  Widget _recordOverlay() => Positioned.fill(
        child: Container(color: Colors.black45, child: const Center(
          child: Text('Listening…', style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
        ),
      );
}

/*──────── bubble ───────*/
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
          constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * .7),
          decoration: BoxDecoration(
            color: isUser ? CupertinoColors.activeBlue : Colors.grey[300],
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black)),
        ),
      );
}
