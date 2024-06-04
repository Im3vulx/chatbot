import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';

class AuthentificationService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<ApiResponse> login(String username, String password) async {
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    final String jsonBody = jsonEncode(data);

    print('Sending data to API: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['token'] != null) {
        await saveToken(jsonResponse['token']);
      }
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(success: false, message: 'Failed to login');
    }
  }

  Future<ApiResponse> register(String username, String password, String email,
      String firstname, String lastname) async {
    final Map<String, String> data = {
      'username': username,
      'password': password,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    };

    final String jsonBody = jsonEncode(data);

    print('Sending data to API: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['token'] != null) {
        await saveToken(jsonResponse['token']);
      }
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(success: false, message: 'Failed to register');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}