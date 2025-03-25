// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'token_storage.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api/login/";
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const Duration _timeoutDuration = Duration(seconds: 10);

  Future<void> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'password': password.trim(),
        }),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await TokenStorage.saveAccessToken(data['access'] as String);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/courses/'),
        headers: await _getAuthHeaders(),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Courses error: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) throw Exception('No access token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}