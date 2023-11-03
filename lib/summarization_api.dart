import 'dart:convert';

import 'package:http/http.dart' as http;

class SummarizationApi {
  static Future<String> fetchSummary(String inputText) async {
    final response = await http.post(
      Uri.parse(
          'https://api-inference.huggingface.co/models/facebook/bart-large-cnn'),
      headers: {
        'Authorization':
            'Bearer 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', // Replace YOUR_API_KEY with your actual API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'inputs': inputText, // Make sure inputText is a non-empty string
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          final summaryObject = jsonResponse[0];
          if (summaryObject is Map &&
              summaryObject.containsKey('summary_text')) {
            return summaryObject['summary_text'];
          } else {
            throw Exception(
                'Invalid response format: missing "summary_text" field.');
          }
        } else {
          throw Exception(
              'Invalid response format: expected a non-empty list.');
        }
      } catch (e) {
        throw Exception('Failed to parse JSON response: $e');
      }
    } else {
      throw Exception('Failed to fetch summary: ${response.statusCode}');
    }
  }
}
