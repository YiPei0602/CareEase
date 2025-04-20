import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Use Android emulator’s 10.0.2.2; else localhost for iOS / simulator
  static final _baseUrl = 'http://192.168.0.3:8000';

  /// Sends the user message to your FastAPI `/chat` endpoint
  static Future<Map<String, dynamic>> sendMessage(String msg) async {
    final uri = Uri.parse('$_baseUrl/chat');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': msg}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Server error ${res.statusCode}');
    }
  }
}
