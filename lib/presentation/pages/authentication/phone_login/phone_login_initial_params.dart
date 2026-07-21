import '../../../../core/navigation/route_params.dart';
import '../../../../core/enums/user_role.dart';

class PhoneLoginInitialParams extends RouteParams {
  const PhoneLoginInitialParams({this.role = UserRole.buyer});

  final UserRole role;

  @override
  Map<String, dynamic> toMap() => {'role': role.name};

  static PhoneLoginInitialParams fromMap(Map<String, dynamic> map) {
    return PhoneLoginInitialParams(
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.buyer,
      ),
    );
  }
}
