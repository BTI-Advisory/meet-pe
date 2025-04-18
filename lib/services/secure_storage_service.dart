import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _installFlagKey = 'installFlag';

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

  static const _roleKey = 'roleKey';
  static Future<void> saveRole(String value) => _storage.write(key: _roleKey, value: value);
  static Future<String?> readRole() => _storage.read(key: _roleKey);
  static Future<void> deleteRole() => _storage.delete(key: _roleKey);

  static const _actionKey = 'actionKey';
  static Future<void> saveAction(String value) => _storage.write(key: _actionKey, value: value);
  static Future<String?> readAction() => _storage.read(key: _actionKey);
  static Future<void> deleteAction() => _storage.delete(key: _actionKey);

  static const _isVerifiedKey = 'isVerified';
  static Future<void> saveIsVerified(String value) => _storage.write(key: _isVerifiedKey, value: value);
  static Future<String?> readIsVerified() => _storage.read(key: _isVerifiedKey);
  static Future<void> deleteIsVerified() => _storage.delete(key: _isVerifiedKey);

  static const _forgotPasswordTokenKey = 'token';
  static Future<void> saveForgotPasswordToken(String value) => _storage.write(key: _forgotPasswordTokenKey, value: value);
  static Future<String?> readForgotPasswordToken() => _storage.read(key: _forgotPasswordTokenKey);
  static Future<void> deleteForgotPasswordToken() => _storage.delete(key: _forgotPasswordTokenKey);

  static const _isCompletedKey = 'completed';
  static Future<void> saveCompleted(String value) => _storage.write(key: _isCompletedKey, value: value);
  static Future<String?> readCompleted() => _storage.read(key: _isCompletedKey);
  static Future<void> deleteCompleted() => _storage.delete(key: _isCompletedKey);

  static const _isFirstLaunchKey = 'firstLaunch';
  static Future<void> saveIsFirstLaunch(String value) => _storage.write(key: _isFirstLaunchKey, value: value);
  static Future<String?> readIsFirstLaunch() => _storage.read(key: _isFirstLaunchKey);
  static Future<void> deleteIsFirstLaunch() => _storage.delete(key: _isFirstLaunchKey);

  static Future<void> deleteAll() => _storage.deleteAll();

  static Future<void> _clearSecureStorage() async {
    await _storage.deleteAll();
  }

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isFreshInstall = prefs.getBool(_installFlagKey) ?? true;

    if (isFreshInstall) {
      await _clearSecureStorage();
      await prefs.setBool(_installFlagKey, false);
    }
  }
}
