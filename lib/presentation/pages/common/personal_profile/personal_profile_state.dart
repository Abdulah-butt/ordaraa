import 'package:equatable/equatable.dart';

import '../../../../domain/entities/user.dart';

class PersonalProfileState extends Equatable {
  const PersonalProfileState({
    required this.user,
    required this.locale,
    required this.saving,
  });

  final User? user;
  final String locale;
  final bool saving;

  factory PersonalProfileState.initial() =>
      const PersonalProfileState(user: null, locale: '', saving: false);

  PersonalProfileState copyWith({
    User? Function()? user,
    String? locale,
    bool? saving,
  }) {
    return PersonalProfileState(
      user: user == null ? this.user : user(),
      locale: locale ?? this.locale,
      saving: saving ?? this.saving,
    );
  }

  @override
  List<Object?> get props => [user, locale, saving];
}
