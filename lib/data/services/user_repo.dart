import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<String> login({required String username, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true); // Save login state
      return json.decode(response.body)['id'];
    } else {
      throw Exception('Failed to authenticate.');
    }
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/logout'),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false); // Clear login state
    } else {
      throw Exception('Failed to logout.');
    }
  }

  Future<String> signup({
    required String fullName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String confPassword,
    required String gender,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullname': fullName,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'confPassword': confPassword,
        'gender': gender,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true); // Save login state
      return json.decode(response.body)['_id'];
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('Failed to sign up. Error: ${errorResponse['error']}');
    }
  }
}
