// auth_service.dart - FINAL VERSION
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api/";
  static const Duration _timeout = Duration(seconds: 10);

  Future<void> register(String username, String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'password': password.trim(),
          'email': email.trim(),
        }),
      ).timeout(_timeout);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await TokenStorage.saveAccessToken(data['access'] as String);
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    return await TokenStorage.getAccessToken() != null;
  }
}