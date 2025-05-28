import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiClient {
  final String _endpoint = 'working on this for next commit';

  Future<String> sendPrompt(String prompt) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'prompt': prompt}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['response'] as String;
    } else {
      throw Exception('AI API error: ${response.statusCode}');
    }
  }
}
