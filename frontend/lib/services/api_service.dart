import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Adjust for device/emulator

  static Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}), // Send message correctly
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      return {
        "response": responseBody["response"],
        "options": responseBody.containsKey("options")
            ? List<String>.from(responseBody["options"]) // Convert to List<String>
            : [],
      };
    } else {
      throw Exception("Failed to connect to backend");
    }
  }
}
