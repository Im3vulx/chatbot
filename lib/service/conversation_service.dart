import 'dart:convert';

import 'package:chatbot/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot/service/auth_service.dart';

class ConversationService {
  final String baseUrl = 'https://mds.sprw.dev';

  // get all conversation of user
  Future<List<Map<String, dynamic>>> getAllConversationInfo() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllConversation: ${response.statusCode}');
    print('Response body getAllConversation: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all conversation info: ${response.body}');
      return [];
    }
  }

  // Ajouter une conversation
  Future<void> addConversation( String universeId, String characterId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'universe_id': universeId,
        'character_id': characterId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add conversation');
    }
  }

  // get all universe
  Future<List<Map<String, dynamic>>> getAllUniverses() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllUniverses: ${response.statusCode}');
    print('Response body getAllUniverses: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all universes: ${response.body}');
      return [];
    }
  }

  // get all character by universe
  Future<List<Map<String, dynamic>>> getCharactersByUniverse(String universeId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getCharactersByUniverse: ${response.statusCode}');
    print('Response body getCharactersByUniverse: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load characters by universe: ${response.body}');
      return [];
    }
  }

  // delete conversation
  Future<ApiResponse> deleteConversation(String conversationId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/conversations/$conversationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ApiResponse(success: true, message: 'Conversation deleted');
    } else {
      return ApiResponse(
          success: false, message: 'Failed to delete conversation');
    }
  }
}