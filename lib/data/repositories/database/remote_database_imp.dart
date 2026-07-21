import '../../../domain/entities/app_user.dart';
import '../../../domain/repositories/database/remote_database_repository.dart';
import '../../../network/api_endpoint.dart';
import '../../../network/network_repository.dart';
import '../../../network/request_model/create_account_request.dart';
import '../../../network/request_model/login_request.dart';
import '../../models/app_user_json.dart';

class RemoteDatabaseImp implements RemoteDatabaseRepository {
  final NetworkRepository _networkRepository;

  RemoteDatabaseImp(this._networkRepository);

  @override
  Future<AppUser> login({required LoginRequest request}) async {
    var response = await _networkRepository.sendRequest(APIEndpoint.login,
        mode: NetworkRequestMode.post, body: request.toJson());
    return AppUserJson.fromJson(response).toDomain();
  }

  @override
  Future<AppUser> getUserProfile() async {
    var response = await _networkRepository.sendRequest(APIEndpoint.getProfile);
    return AppUserJson.fromJson(response).toDomain();
  }

  @override
  Future<AppUser> createAccount({required CreateAccountRequest request}) async {
    var response = await _networkRepository.sendRequest(
      APIEndpoint.createAccount,
      mode: NetworkRequestMode.post,
      body: request.toJson(),
    );
    return AppUserJson.fromJson(response).toDomain();
  }
}
