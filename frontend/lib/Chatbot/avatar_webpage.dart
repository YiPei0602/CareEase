import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AvatarWebPage extends StatefulWidget {
  final String initialText;
  final Function(Map<String, dynamic>) onResponse;

  const AvatarWebPage({
    Key? key,
    required this.initialText,
    required this.onResponse,
  }) : super(key: key);

  @override
  State<AvatarWebPage> createState() => _AvatarWebPageState();
}

class _AvatarWebPageState extends State<AvatarWebPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            debugPrint('Received message from WebView: ${message.message}');
            final data = jsonDecode(message.message);
            if (data['type'] == 'speaking') {
              widget.onResponse(data);
            } else if (data['type'] == 'error') {
              setState(() {
                _hasError = true;
                _errorMessage = data['message'] ?? 'Unknown error occurred';
              });
              debugPrint('WebView error: $_errorMessage');
            } else if (data['type'] == 'connection' && data['state'] == 'connected') {
              debugPrint('Avatar connected successfully');
              _speakInitialText();
            }
          } catch (e) {
            debugPrint('Error processing WebView message: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('WebView loading started: $url');
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) async {
            debugPrint('WebView loading finished: $url');
            setState(() => _isLoading = false);
            // Add a small delay before initializing the avatar
            await Future.delayed(const Duration(milliseconds: 500));
            await _initializeAvatar();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            setState(() {
              _hasError = true;
              _errorMessage = 'Failed to load avatar: ${error.description}';
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('http://localhost:8000/index.html'))
      ..setUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1');
  }

  Future<void> _initializeAvatar() async {
    try {
      debugPrint('Initializing avatar...');
      // First check if the page is loaded properly
      final String? pageContent = await _controller.runJavaScriptReturningResult(
        'document.documentElement.innerHTML'
      ) as String?;
      
      if (pageContent == null || pageContent.isEmpty) {
        throw Exception('Page content is empty');
      }

      // Check if the required JavaScript functions are available
      final bool hasConnectFunction = await _controller.runJavaScriptReturningResult(
        'typeof window.connectAvatar === "function"'
      ) as bool;

      if (!hasConnectFunction) {
        throw Exception('Avatar connection function not found');
      }

      await _controller.runJavaScript('window.connectAvatar()');
      debugPrint('Avatar initialization completed');
    } catch (e) {
      debugPrint('Error initializing avatar: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize avatar: $e';
      });
    }
  }

  Future<void> _speakInitialText() async {
    if (widget.initialText.isNotEmpty) {
      try {
        debugPrint('Making avatar speak: ${widget.initialText}');
        await _controller.runJavaScript(
          'window.speakMessage(${jsonEncode(widget.initialText)})',
        );
      } catch (e) {
        debugPrint('Error making avatar speak: $e');
      }
    }
  }

  Future<void> _retryConnection() async {
    debugPrint('Retrying connection...');
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _initializeWebView();
  }

  @override
  void didUpdateWidget(AvatarWebPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText && 
        widget.initialText.isNotEmpty) {
      _speakInitialText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(150),
          ),
          clipBehavior: Clip.antiAlias,
          child: WebViewWidget(controller: _controller),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (_hasError)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryConnection,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
