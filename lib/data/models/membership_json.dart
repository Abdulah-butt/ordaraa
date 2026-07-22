import '../../core/enums/membership_role.dart';
import '../../core/enums/membership_status.dart';
import '../../domain/entities/membership.dart';

class MembershipJson {
  const MembershipJson({
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

  factory MembershipJson.fromJson(Map<String, dynamic> json) {
    final joinedAtValue = json['joinedAt'] as String?;
    return MembershipJson(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String,
      role: MembershipRole.fromApiValue(json['role'] as String),
      status: MembershipStatus.fromApiValue(json['status'] as String),
      joinedAt: joinedAtValue == null ? null : DateTime.parse(joinedAtValue),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizationId': organizationId,
    'userId': userId,
    'role': role.apiValue,
    'status': status.apiValue,
    'joinedAt': joinedAt?.toUtc().toIso8601String(),
  };

  Membership toDomain() => Membership(
    id: id,
    organizationId: organizationId,
    userId: userId,
    role: role,
    status: status,
    joinedAt: joinedAt,
  );
}
