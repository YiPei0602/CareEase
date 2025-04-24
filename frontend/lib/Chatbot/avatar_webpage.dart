import 'package:flutter/material.dart';  // Correct import for StatefulWidget
import 'package:webview_flutter/webview_flutter.dart';

class AvatarWebPage extends StatefulWidget {
  const AvatarWebPage({Key? key}) : super(key: key);

  @override
  State<AvatarWebPage> createState() => _AvatarWebPageState();
}

class _AvatarWebPageState extends State<AvatarWebPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('http://localhost:8000/index.html');  // Make sure this path is correct
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
