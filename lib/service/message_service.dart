import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatbot/service/auth_service.dart';

class MessageService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Map<String, dynamic>>> getAllMessageInfo(String conversationId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllMessages: ${response.statusCode}');
    print('Response body getAllMessages: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all messages: ${response.body}');
      return [];
    }
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final token = await AuthentificationService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'content': content,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }

  // regenerating the last message in the conversation
  Future<void> regenerateLastMessage(String conversationId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/conversations/$conversationId/regenerate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to regenerate last message');
    }
  }
}
