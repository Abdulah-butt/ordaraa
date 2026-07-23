import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/enums/user_role.dart';
import 'secure_storage_service.dart';

class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _intendedUserRoleKey = 'intended_user_role';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  @override
  Future<String> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey) ?? '';
  }

  @override
  Future<String> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey) ?? '';
  }

  @override
  Future<void> saveIntendedUserRole(UserRole role) {
    return _storage.write(key: _intendedUserRoleKey, value: role.name);
  }

  @override
  Future<UserRole?> getIntendedUserRole() async {
    final value = await _storage.read(key: _intendedUserRoleKey);
    return UserRole.values.where((role) => role.name == value).firstOrNull;
  }

  @override
  Future<void> clearAuthTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _intendedUserRoleKey),
    ]);
  }
}
