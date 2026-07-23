import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/network/request_model/update_user_profile_request.dart';

void main() {
  test(
    'updateUserProfile patches users/me and maps the user resource',
    () async {
      final network = _UserNetworkRepository();
      final repository = RemoteDatabaseImp(network);

      final user = await repository.updateUserProfile(
        request: const UpdateUserProfileRequest(
          displayName: 'Maya Chen',
          locale: 'en-AU',
        ),
      );

      expect(network.endpoint, APIEndpoint.updateUserProfile);
      expect(network.mode, NetworkRequestMode.patch);
      expect(network.body, {'displayName': 'Maya Chen', 'locale': 'en-AU'});
      expect(user.displayName, 'Maya Chen');
      expect(user.phone, '+61412345678');
      expect(user.email, 'maya@example.com');
      expect(user.locale, 'en-AU');
    },
  );
}

class _UserNetworkRepository implements NetworkRepository {
  String? endpoint;
  NetworkRequestMode? mode;
  dynamic body;

  @override
  Future<dynamic> sendRequest(
    String endpoint, {
    NetworkRequestMode mode = NetworkRequestMode.get,
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> headers = const {},
    dynamic body,
    bool isFormData = false,
    bool returnFullResponse = false,
    List<FileField>? fileFields,
  }) async {
    this.endpoint = endpoint;
    this.mode = mode;
    this.body = body;
    return _userResponse;
  }
}

const _userResponse = <String, dynamic>{
  'id': 'e813fe99-417d-4d6e-9117-695feaa2fb34',
  'phone': '+61412345678',
  'email': 'maya@example.com',
  'displayName': 'Maya Chen',
  'avatar': null,
  'locale': 'en-AU',
  'status': 'ACTIVE',
  'platformRole': null,
};
