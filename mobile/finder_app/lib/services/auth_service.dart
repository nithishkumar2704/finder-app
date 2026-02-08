import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/accounts';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'accessToken', value: data['access']);
      await _storage.write(key: 'refreshToken', value: data['refresh']);
      return data;
    }
    return null;
  }

  Future<bool> register(String username, String email, String password, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );
    return response.statusCode == 201;
  }

  Future<User?> getProfile() async {
    debugPrint('AuthService: Reading accessToken from storage...');
    final token = await _storage.read(key: 'accessToken');
    debugPrint('AuthService: Token read complete. Value: ${token?.substring(0, 5)}...');
    if (token == null) {
      debugPrint('No token found in storage.');
      return null;
    }

    debugPrint('Fetching profile from $baseUrl/profile/ ...');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint('Profile response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
