import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? token;

  const AppUser({
    this.id,
    this.name,
    this.email,
    this.token,
  });

  AppUser.guest()
      : id = 'guest',
        name = 'Guest',
        email = '',
        token = '';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        token,
      ];
}
