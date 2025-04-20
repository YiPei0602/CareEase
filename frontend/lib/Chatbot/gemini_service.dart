import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:careease_app/Chatbot/secrets.dart';

class GeminiService {
  static Future<String> getReply(String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$geminiKey',
    );

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    print('🔁 Gemini Status: ${res.statusCode}');
    print('📦 Gemini Response: ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final candidates = data['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        return candidates[0]['content']['parts'][0]['text'].trim();
      } else {
        return '❌ Gemini returned no reply.';
      }
    } else {
      return '❌ Gemini error ${res.statusCode}: ${jsonDecode(res.body)["error"]["message"]}';
    }
  }
}
