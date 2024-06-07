import 'dart:convert';

import 'package:chatbot/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot/service/auth_service.dart';

class CharacterService {
  final String baseUrl = 'https://mds.sprw.dev';

  // recueperer les personnages de universe
  Future<List<Map<String, dynamic>>> getAllCharacterInfo(String id) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$id/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllCharacter: ${response.statusCode}');
    print('Response body getAllCharacter: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all character info: ${response.body}');
      return [];
    }
  }

  // ajouter un personnage
  Future<ApiResponse> addCharacter(String name, String universeId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    print('Response status addCharacter: ${response.statusCode}');
    print('Response body addCharacter: ${response.body}');

    if (response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse.fromJson(jsonDecode(response.body));
    }
  }

  // recupere les donnees d'un personnage
  Future<Map<String, dynamic>> getCharacterData(String universeId, String characterId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters/$characterId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getCharacterData: ${response.statusCode}');
    print('Response body getCharacterData: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {};
    }
  }

  // mettre a jour les donnees d'un personnage
  Future<ApiResponse> updateCharacter(String universeId, String characterId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/universes/$universeId/characters/$characterId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status updateCharacter: ${response.statusCode}');
    print('Response body updateCharacter: ${response.body}');

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      return ApiResponse.fromJson(jsonDecode(response.body));
    }
  }
}