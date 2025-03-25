// token_storage.dart - FINAL VERSION
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static final _storage = FlutterSecureStorage();

  static Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(
          key: _accessTokenKey,
          value: token,
          aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          iOptions: const IOSOptions(accessibility: KeychainAccessibility.unlocked)
      );
    } catch (e, stack) {
      debugPrint('Token save failed: $e\n$stack');
      rethrow;
    }
  }

  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e, stack) {
      debugPrint('Token read failed: $e\n$stack');
      return null;
    }
  }

  static Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: _accessTokenKey);
    } catch (e, stack) {
      debugPrint('Token delete failed: $e\n$stack');
      rethrow;
    }
  }
}