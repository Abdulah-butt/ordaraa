import '../../domain/entities/app_user.dart';

class AppUserJson {
  final String? id;
  final String? name;
  final String? email;

  const AppUserJson({this.id, this.name, this.email});

  AppUserJson.guest()
    : id = 'guest',
      name = 'Guest',
      email = '';

  factory AppUserJson.fromJson(Map<String, dynamic> json) {
    return AppUserJson(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  AppUser toDomain() {
    return AppUser(
      id: id ?? 'guest',
      name: name ?? 'Guest',
      email: email ?? '',
    );
  }
}
