import '../../core/enums/platform_role.dart';
import '../../core/enums/user_status.dart';
import '../../domain/entities/order_placed_by.dart';
import 'image_resource_json.dart';

class OrderPlacedByJson {
  const OrderPlacedByJson({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.locale,
    required this.status,
    required this.platformRole,
  });

  final String id;
  final String displayName;
  final ImageResourceJson? avatar;
  final String locale;
  final UserStatus status;
  final PlatformRole? platformRole;

  factory OrderPlacedByJson.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    final platformRole = json['platformRole'] as String?;
    return OrderPlacedByJson(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatar: avatar is Map<String, dynamic>
          ? ImageResourceJson.fromJson(avatar)
          : null,
      locale: json['locale'] as String,
      status: UserStatus.fromApiValue(json['status'] as String),
      platformRole: platformRole == null
          ? null
          : PlatformRole.fromApiValue(platformRole),
    );
  }

  OrderPlacedBy toDomain() => OrderPlacedBy(
    id: id,
    displayName: displayName,
    avatar: avatar?.toDomain(),
    locale: locale,
    status: status,
    platformRole: platformRole,
  );
}
