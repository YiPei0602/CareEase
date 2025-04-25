import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';               // for Icons.android
import 'package:careease_app/Chatbot/api_service.dart';
import 'package:careease_app/Chatbot/stt_service.dart';
import 'package:careease_app/Chatbot/chat_message.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _textController   = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages    = [];
  final FlutterTts        _flutterTts  = FlutterTts();

  bool _isAvatarMode = false;
  bool _isTyping     = false;

  @override
  void initState() {
    super.initState();
    _setupTts();
    _fetchInitialBotMessage();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await _flutterTts.setVoice({
      "name": "com.apple.ttsbundle.Daniel-compact",
      "locale": "en-US"
    });
    await _flutterTts.setPitch(0.8);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _fetchInitialBotMessage() async {
    setState(() => _isTyping = true);
    try {
      final res   = await ApiService.sendMessage('');
      final reply = res['response'] as String;
      final opts  = (res['options'] as List<dynamic>?)?.cast<String>() ?? [];
      _addBot(reply, opts);
      if (_isAvatarMode) await _speak(reply);
    } catch (_) {
      _addBot("Sorry, I can't reach the server right now.", []);
    }
  }

  void _addBot(String text, List<String> options) {
    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        transparent: _isAvatarMode,
        options: options,
        onOptionSelected: _handleSendMessage,
      ));
    });
    _scrollToBottom();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> _handleSendMessage(String message) async {
    if (message.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      final res   = await ApiService.sendMessage(message);
      final reply = res['response'] as String;
      final opts  = (res['options'] as List<dynamic>?)?.cast<String>() ?? [];

      if (_isAvatarMode) {
        await _speak(reply);
        await _displayGradual(reply, opts);
      } else {
        _addBot(reply, opts);
      }
    } catch (_) {
      _addBot("Oops, something went wrong.", []);
    }
  }

  Future<void> _displayGradual(String full, List<String> options) async {
    var partial = '';
    for (final w in full.split(' ')) {
      partial += (partial.isEmpty ? '' : ' ') + w;
      setState(() {
        if (_messages.isNotEmpty && !_messages.last.isUser)
          _messages.removeLast();
        _messages.add(ChatMessage(
          text: partial,
          isUser: false,
          transparent: true,
          options: options,
          onOptionSelected: _handleSendMessage,
        ));
      });
      _scrollToBottom();
      // ↓ SLOWER: was 150ms, now 300ms to match TTS pacing  <<< HERE
      await Future.delayed(const Duration(milliseconds: 280));
    }
    setState(() => _isTyping = false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewSession() {
    setState(() {
      _messages.clear();
      _isTyping = false;
    });
    _fetchInitialBotMessage();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: _isAvatarMode ? _buildAvatarMode() : _buildTextMode(),
      ),
    );
  }

  Widget _buildTextMode() {
    return Column(
      children: [
        _buildControlRow(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (_, i) => _messages[i],
          ),
        ),
        if (_isTyping)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: CupertinoActivityIndicator(),
          ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildAvatarMode() {
    final h = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/avatar/doctor_avatar_male.png',
          fit: BoxFit.cover,
        ),
        Container(color: Colors.black26),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(child: _buildControlRow()),
        ),
        Positioned(
          // ↑ moved bubbles down to 40% so face never covered       <<< HERE
          top: h * 0.4,
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _messages[i],
                ),
              ),
              if (_isTyping)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CupertinoActivityIndicator(),
                ),
              _buildInputBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              final toAvatar = !_isAvatarMode;
              setState(() => _isAvatarMode = toAvatar);
              if (toAvatar) {
                _messages.clear();
                _isTyping = false;
                _fetchInitialBotMessage();
              }
            },
            child: Icon(
              _isAvatarMode
                  ? CupertinoIcons.bubble_left_fill
                  : Icons.android,
              size: 28,
            ),
          ),
          const Spacer(),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            onPressed: _startNewSession,
            child: const Text('New Session'),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            onPressed: () => /* TODO: history */ null,
            child: const Text('Chat History'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: CupertinoColors.white,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        children: [
          GestureDetector(
            onLongPressStart: (_) => SttService.start(),
            onLongPressEnd: (_) async {
              final spoken = await SttService.stop();
              if (spoken.isNotEmpty) {
                _textController.text = spoken;
                _handleSendMessage(spoken);
              }
            },
            child: const Icon(
              CupertinoIcons.mic_circle_fill,
              size: 36,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CupertinoTextField(
              controller: _textController,
              placeholder: 'Type or speak…',
              onSubmitted: _handleSendMessage,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _handleSendMessage(_textController.text),
            child: const Icon(
              CupertinoIcons.arrow_up_circle_fill,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
