import '../../core/enums/user_role.dart';

abstract class SecureStorageService {
  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<String> getAccessToken();

  Future<String> getRefreshToken();

  Future<void> saveIntendedUserRole(UserRole role);

  Future<UserRole?> getIntendedUserRole();

  Future<void> clearAuthTokens();
}
