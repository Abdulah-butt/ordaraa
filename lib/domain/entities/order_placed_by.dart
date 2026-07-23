import 'package:equatable/equatable.dart';

import '../../core/enums/platform_role.dart';
import '../../core/enums/user_status.dart';
import 'image_resource.dart';

class OrderPlacedBy extends Equatable {
  const OrderPlacedBy({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.locale,
    required this.status,
    required this.platformRole,
  });

  final String id;
  final String displayName;
  final ImageResource? avatar;
  final String locale;
  final UserStatus status;
  final PlatformRole? platformRole;

  OrderPlacedBy copyWith({
    String? id,
    String? displayName,
    ImageResource? Function()? avatar,
    String? locale,
    UserStatus? status,
    PlatformRole? Function()? platformRole,
  }) {
    return OrderPlacedBy(
      id: id ?? this.id,
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
    displayName,
    avatar,
    locale,
    status,
    platformRole,
  ];
}
