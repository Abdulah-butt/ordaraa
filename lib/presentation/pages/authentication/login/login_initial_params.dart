import '../../../../core/navigation/route_params.dart';

class LoginInitialParams extends RouteParams {
  const LoginInitialParams();

  @override
  Map<String, dynamic> toMap() {
    return {};
  }

  static LoginInitialParams fromMap(Map<String, dynamic> map) {
    return LoginInitialParams();
  }
}
