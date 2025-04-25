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
    try {
      final uri = Uri.parse('$_baseUrl/chat');
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': msg.toLowerCase()}), // Convert to lowercase to match backend
      );
      
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(res.body);
        return {
          'response': responseBody['response'],
          'options': responseBody['options'],
          'diagnosis': responseBody['diagnosis'],
          'symptoms': responseBody['symptoms'],
          'recommendations': responseBody['recommendations'],
          'redirect': responseBody['redirect'],
        };
      }
      throw Exception('Server error ${res.statusCode}');
    } catch (e) {
      print('API Error: $e'); // Add logging for debugging
      rethrow;
    }
  }
}
