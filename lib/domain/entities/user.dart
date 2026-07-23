import 'package:equatable/equatable.dart';

import '../../core/enums/platform_role.dart';
import '../../core/enums/user_status.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.phone,
    required this.email,
    required this.displayName,
    required this.avatar,
    required this.locale,
    required this.status,
    required this.platformRole,
  });

  final String id;
  final String phone;
  final String? email;
  final String displayName;
  final String? avatar;
  final String locale;
  final UserStatus status;
  final PlatformRole? platformRole;

  User copyWith({
    String? id,
    String? phone,
    String? Function()? email,
    String? displayName,
    String? Function()? avatar,
    String? locale,
    UserStatus? status,
    PlatformRole? Function()? platformRole,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email == null ? this.email : email(),
      displayName: displayName ?? this.displayName,
      avatar: avatar == null ? this.avatar : avatar(),
      locale: locale ?? this.locale,
      status: status ?? this.status,
      platformRole: platformRole == null ? this.platformRole : platformRole(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    phone,
    email,
    displayName,
    avatar,
    locale,
    status,
    platformRole,
  ];
}
