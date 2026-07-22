import 'package:equatable/equatable.dart';

import '../../core/enums/membership_role.dart';
import '../../core/enums/membership_status.dart';

class Membership extends Equatable {
  const Membership({
    required this.id,
    required this.organizationId,
    required this.userId,
    required this.role,
    required this.status,
    required this.joinedAt,
  });

  final String id;
  final String organizationId;
  final String userId;
  final MembershipRole role;
  final MembershipStatus status;
  final DateTime? joinedAt;

  Membership copyWith({
    String? id,
    String? organizationId,
    String? userId,
    MembershipRole? role,
    MembershipStatus? status,
    DateTime? Function()? joinedAt,
  }) {
    return Membership(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt == null ? this.joinedAt : joinedAt(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    organizationId,
    userId,
    role,
    status,
    joinedAt,
  ];
}
