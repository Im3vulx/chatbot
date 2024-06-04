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
        final tokenParts = jsonResponse['token'].split('.');
        final payload =
            json.decode(utf8.decode(base64Url.decode(tokenParts[1].padRight(
          tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
          '=',
        ))));
        final data = jsonDecode(payload['data']);
        print('Data User: $data');
        await saveId(data['id']);
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
        final tokenParts = jsonResponse['token'].split('.');
        final payload =
            json.decode(utf8.decode(base64Url.decode(tokenParts[1].padRight(
          tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
          '=',
        ))));
        print('Payload: $payload');
        final id = payload['data']['id'];
        print('id: $id');
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

  Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id.toString());
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final id = await getId();
    final token = await getToken();
    if (id == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getUser: ${response.statusCode}');
    print('Response body getUser: ${response.body}');

    if (response.statusCode == 200) {
      print('User info loaded: ${response.body}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Failed to load user info: ${response.body}');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllUsers: ${response.statusCode}');
    print('Response body getAllUsers: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      return users.map((e) => e as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

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
}
