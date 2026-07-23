import '../../core/enums/platform_role.dart';
import '../../core/enums/user_status.dart';
import '../../domain/entities/user.dart';

class UserJson {
  const UserJson({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.locale,
    required this.status,
    required this.platformRole,
  });

  final String id;
  final String displayName;
  final String? avatar;
  final String locale;
  final UserStatus status;
  final PlatformRole? platformRole;

  factory UserJson.fromJson(Map<String, dynamic> json) {
    final platformRoleValue = json['platformRole'] as String?;
    return UserJson(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatar: json['avatar'] as String?,
      locale: json['locale'] as String,
      status: UserStatus.fromApiValue(json['status'] as String),
      platformRole: platformRoleValue == null
          ? null
          : PlatformRole.fromApiValue(platformRoleValue),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'avatar': avatar,
    'locale': locale,
    'status': status.apiValue,
    'platformRole': platformRole?.apiValue,
  };

  User toDomain() => User(
    id: id,
    displayName: displayName,
    avatar: avatar,
    locale: locale,
    status: status,
    platformRole: platformRole,
  );
}
