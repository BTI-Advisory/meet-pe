import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _refreshTokenKey = 'refreshToken';
  static Future<void> saveRefreshToken(String value) => _storage.write(key: _refreshTokenKey, value: value);
  static Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);
  static Future<void> deleteRefreshToken() => _storage.delete(key: _refreshTokenKey);

  static const _accessTokenKey = 'accessToken';
  static Future<void> saveAccessToken(String value) => _storage.write(key: _accessTokenKey, value: value);
  static Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);
  static Future<void> deleteAccessToken() => _storage.delete(key: _accessTokenKey);

  static const _usernameKey = 'usernameKey';
  static Future<void> saveUsername(String value) => _storage.write(key: _usernameKey, value: value);
  static Future<String?> readUsername() => _storage.read(key: _usernameKey);
  static Future<void> deleteUsername() => _storage.delete(key: _usernameKey);

  static const _passwordKey = 'passwordKey';
  static Future<void> savePassword(String value) => _storage.write(key: _passwordKey, value: value);
  static Future<String?> readPassword() => _storage.read(key: _passwordKey);
  static Future<void> deletePassword() => _storage.delete(key: _passwordKey);

  static Future<void> deleteAll() => _storage.deleteAll();
}
