import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiClient {
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  final String apiKey;
  AiApiClient(this.apiKey);

  Future<String> send(String prompt) async {
    final uri = Uri.parse('$_endpoint?key=$apiKey');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>;
      return candidates.isNotEmpty
          ? (candidates[0]['content']['parts'] as List)[0]['text'] as String
          : '';
    } else {
      throw Exception('AI API error ${response.statusCode}: ${response.body}');
    }
  }
}
