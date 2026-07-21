
import '../../../network/request_model/create_account_request.dart';
import '../../../network/request_model/login_request.dart';
import '../../entities/app_user.dart';

abstract class RemoteDatabaseRepository{
  Future<AppUser> login({required LoginRequest request});
  Future<AppUser> createAccount({required CreateAccountRequest request});

  Future<AppUser> getUserProfile();

}