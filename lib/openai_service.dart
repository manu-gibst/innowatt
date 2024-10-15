import 'dart:convert';

import 'package:innowatt/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  Future<String> chatGPTAPI(String prompt) async {
    final List<Map<String, String>> messages = [];
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You should include word 'cool' in every message",
            },
            {
              "role": "user",
              "content": prompt,
            }
          ]
        }),
      );
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }
}
