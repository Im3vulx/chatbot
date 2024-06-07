import 'dart:convert';

import 'package:chatbot/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot/service/auth_service.dart';

class UniverseService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Map<String, dynamic>>> getAllUniverseInfo() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllUniverse: ${response.statusCode}');
    print('Response body getAllUniverse: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all user info: ${response.body}');
      return [];
    }
  }

  Future<void> addUniverse(String name) async {
    final token = await AuthentificationService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
      }),
    );

    print('Response status addUniverse: ${response.statusCode}');
    print('Response body addUniverse: ${response.body}');

    if (response.statusCode == 201) {
      print('Universe added successfully');
    } else {
      print('Failed to add universe');
    }
  }

  Future<Map<String, dynamic>> getDataUniverse(String id) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getDataUniverse: ${response.statusCode}');
    print('Response body getDataUniverse: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      print('Failed to load universe data');
      return {};
    }
  }

  Future<ApiResponse> updateUniverse(String id, String name) async {
    final token = await AuthentificationService().getToken();
    final data = {'name': name};
    final jsonBody = jsonEncode(data);

    final response = await http.put(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status updateUniverse: ${response.statusCode}');
    print('Response body updateUniverse: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(success: false, message: 'Failed to update universe');
    }
  }

  // getUniverseData
  Future<Map<String, dynamic>?> getUniverseData(String id) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getUniverseData: ${response.statusCode}');
    print('Response body getUniverseData: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      print('Failed to load universe data');
      return null;
    }
  }
}