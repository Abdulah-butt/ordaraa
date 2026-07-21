abstract class LocalDatabaseRepository{
  Future<void> initialize();
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> logoutUser();


}