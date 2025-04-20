import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secrets.dart';

class AvatarService {
  static Future<String> getAvatarVideo(String text) async {
    final res = await http.post(
      Uri.parse('https://api.d-id.com/talks'),
      headers: {
        'Authorization': dIdKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'script': {'type': 'text', 'input': text},
        'avatar_id': avatarId,
      }),
    );

    final id = jsonDecode(res.body)['id'];

    await Future.delayed(const Duration(seconds: 5));

    final result = await http.get(
      Uri.parse('https://api.d-id.com/talks/$id'),
      headers: {'Authorization': dIdKey},
    );

    return jsonDecode(result.body)['result_url'];
  }
}
