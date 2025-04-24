import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ApiService {
  // For iOS Simulator or Android Emulator (defaults to localhost)
static final String _baseUrl = Platform.isAndroid
    ? 'http://10.0.2.2:8000'  // Android Emulator
    : 'http://127.0.0.1:8000'; // iOS Simulator or real device


  /// POST /chat
  static Future<Map<String, dynamic>> sendMessage(String msg) async {
    final uri = Uri.parse('$_baseUrl/chat');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': msg}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Server error ${res.statusCode}');
  }
}
