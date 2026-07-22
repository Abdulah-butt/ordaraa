import '../../../../core/navigation/route_params.dart';
import '../../../../core/enums/user_role.dart';

class OtpVerificationInitialParams extends RouteParams {
  const OtpVerificationInitialParams({
    required this.phoneNumber,
    this.role = UserRole.buyer,
  });

  final String phoneNumber;
  final UserRole role;

  @override
  Map<String, dynamic> toMap() => {
    'phoneNumber': phoneNumber,
    'role': role.name,
  };

  static OtpVerificationInitialParams fromMap(Map<String, dynamic> map) {
    return OtpVerificationInitialParams(
      phoneNumber: map['phoneNumber'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRole.buyer,
      ),
    );
  }
}
