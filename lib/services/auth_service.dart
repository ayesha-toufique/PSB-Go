import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService {
  // Android emulator: 10.0.2.2 points to your computer.
  // For a physical phone, use your computer's local Wi-Fi IP.
static const String baseUrl = 'http://localhost:5005/api';
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? cnic,
    String? licenseNo,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'role': role,
        if (role == 'driver') 'cnic': cnic,
        if (role == 'driver') 'licenseNo': licenseNo,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await _saveSession(data);
      return data;
    }

    throw Exception(
      data['message'] ?? 'Registration failed',
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _saveSession(data);
      return data;
    }

    throw Exception(data['message'] ?? 'Login failed');
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', data['token']);
    await prefs.setString(
      'user',
      jsonEncode(data['user']),
    );
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.setBool('isLoggedIn', false);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) return null;

    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message'] ?? 'Unable to load profile');
  }
}